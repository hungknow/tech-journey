# Purpose

This document explains how to parse complex URL query strings—such as filter and search parameters—into a structured, type-safe format in your TypeScript backend.

# Data flow

**Example:**  
`GET /users?age[gte]=21&role=admin&name[like]=john&sort=age:desc,name:asc`

**qs result:**  
`{ age: { gte: '21' }, role: 'admin', name: { like: 'john' }, sort: 'age:desc,name:asc' }`  
*(With array form `sort[]=age:desc&sort[]=name:asc`, qs gives `sort: ['age:desc', 'name:asc']`—both are supported.)*

**Middleware logic:**  
- `age` is a number: checks `gte`, casts to `21`
- `role` is enum: checks `'admin'` ∈ `['admin','user','guest']`
- `name` is a string: accepts any text in `like`; backend finds records whose name **includes** the input (substring match, e.g. "John Doe", "johnny")
- `sort`: multiple columns supported. Either comma-separated string `age:desc,name:asc` or array `['age:desc', 'name:asc']`. Each part is `column:direction`; default direction is `asc` if omitted. Result is an array of `{ field, order }` in order (first = primary sort).
- `page`, `limit` → pagination

**Result:**  
```ts
{
  pagination: { page: 1, limit: 10 },
  filters: {
    age: { gte: 21 },
    role: { eq: 'admin' },
    name: { like: 'john' }
  },
  sort: [
    { field: 'age', order: 'desc' },
    { field: 'name', order: 'asc' }
  ]
}
```
Usage: Use `req.searchQuery.sort` (array) for multi-column ordering: each element has `field` (column) and `order` (`'asc'` | `'desc'`). Apply in order, e.g. `ORDER BY age DESC, name ASC`.

# Code

## Typescript

`searchTypes.ts`
```typescript
import { z } from 'zod';

// --- Configuration Types ---
export type FieldType = 'string' | 'number' | 'enum' | 'date' | 'boolean';

export interface SearchFieldConfig {
  type: FieldType;
  options?: string[]; // Required if type is 'enum'
}

export interface SearchConfig {
  fields: Record<string, SearchFieldConfig>;
}

// --- Output Data Types (What your controller receives) ---
// This interface defines what standard operators look like
export interface FilterOperators<T> {
  eq?: T;
  ne?: T;
  gt?: T;
  lt?: T;
  gte?: T;
  lte?: T;
  like?: string; // Only for strings: "contains" / substring (e.g. find name that includes this text)
  in?: T[];
}

export interface SearchQuery<T = any> {
  filters: Partial<Record<keyof T, FilterOperators<any>>>;
  pagination: {
    page: number;
    limit: number;
  };
  /** Multiple columns in order (first = primary sort). */
  sort?: Array<{ field: string; order: 'asc' | 'desc' }>;
}
```

`searchMiddleware.ts`
```typescript
import { Request, Response, NextFunction, RequestHandler } from 'express';
import { z, ZodObject, ZodTypeAny } from 'zod';
import { SearchConfig } from './searchTypes';

// Extend Express Request to include our new property
declare global {
  namespace Express {
    interface Request {
      searchQuery: {
        filters: Record<string, any>;
        pagination: { page: number; limit: number };
        sort?: Array<{ field: string; order: 'asc' | 'desc' }>;
      };
    }
  }
}

export const createSearchMiddleware = (config: SearchConfig): RequestHandler => {
  // 1. Build the Dynamic Zod Schema based on the Config
  // We compute this ONCE when the app starts.
  
  const fieldSchemas: Record<string, ZodTypeAny> = {};

  Object.entries(config.fields).forEach(([key, rule]) => {
    let baseType: ZodTypeAny;

    // Define the base Zod validator for the value type
    switch (rule.type) {
      case 'number':
        baseType = z.coerce.number();
        break;
      case 'boolean':
        baseType = z.enum(['true', 'false']).transform((v) => v === 'true');
        break;
      case 'date':
        baseType = z.coerce.date();
        break;
      case 'enum':
        if (!rule.options) throw new Error(`Enum field '${key}' missing options`);
        baseType = z.enum(rule.options as [string, ...string[]]);
        break;
      case 'string':
      default:
        baseType = z.string();
        break;
    }

    // Define allowed operators for this field
    const operators = z.object({
      eq: baseType.optional(),
      ne: baseType.optional(),
      gt: rule.type === 'number' || rule.type === 'date' ? baseType.optional() : z.undefined(),
      lt: rule.type === 'number' || rule.type === 'date' ? baseType.optional() : z.undefined(),
      gte: rule.type === 'number' || rule.type === 'date' ? baseType.optional() : z.undefined(),
      lte: rule.type === 'number' || rule.type === 'date' ? baseType.optional() : z.undefined(),
      like: rule.type === 'string' ? z.string().optional() : z.undefined(),
      in: z.union([z.string(), z.array(z.string())]) // Handle "val,val" string or array
        .transform((val) => {
           const arr = Array.isArray(val) ? val : val.split(',');
           // We must re-validate the array items against the baseType if needed, 
           // but for simplicity here we return strings. 
           // In a complex app, you'd map this array to baseType parsing.
           return arr;
        }).optional(),
    });

    fieldSchemas[key] = operators.optional();
  });

  // 2. Add Standard Pagination & Sort Schemas
  const querySchema = z.object({
    ...fieldSchemas, // Spread the dynamic fields
    
    // Pagination (Standardized)
    page: z.coerce.number().min(1).default(1),
    limit: z.coerce.number().min(1).max(100).default(10),
    
    // Sorting: ?sort=age:desc,name:asc or ?sort[]=age:desc&sort[]=name:asc (multiple columns)
    sort: z.union([
      z.string(),
      z.array(z.string()),
    ]).optional().transform((val): Array<{ field: string; order: 'asc' | 'desc' }> | undefined => {
      if (val == null) return undefined;
      const parts = Array.isArray(val) ? val : val.split(',').map((s) => s.trim()).filter(Boolean);
      if (parts.length === 0) return undefined;
      return parts.map((part) => {
        const [field, order] = part.split(':');
        return { field: field ?? '', order: (order === 'desc' ? 'desc' : 'asc') as 'asc' | 'desc' };
      });
    }),
  });

  // 3. The Middleware Function
  return (req: Request, res: Response, next: NextFunction): void => {
    // req.query is assumed to be parsed by 'qs' (Express default)
    const result = querySchema.safeParse(req.query);

    if (!result.success) {
      res.status(400).json({
        error: 'Invalid Search Parameters',
        details: result.error.format(),
      });
      return;
    }

    // Separate pagination/sort from filters
    const { page, limit, sort, ...filters } = result.data;

    // Attach to Request
    req.searchQuery = {
      filters,
      pagination: { page, limit },
      sort,
    };

    next();
  };
};
```

`userController.ts`
```typescript
import express, { Request, Response } from 'express';
import { createSearchMiddleware } from './searchMiddleware';
import { SearchConfig } from './searchTypes';

const router = express.Router();

// --- 1. Define the Rules (The Contract) ---
const userSearchConfig: SearchConfig = {
  fields: {
    name:     { type: 'string' },  // User can input any text; use filters.name.like for "name includes text"
    age:      { type: 'number' },
    role:     { type: 'enum', options: ['admin', 'user', 'guest'] },
    isActive: { type: 'boolean' },
    joinedAt: { type: 'date' }
  }
};

// --- 2. The Controller Handler ---
// The filters inside req.searchQuery will match the config above.
const getUsers = (req: Request, res: Response) => {
  const { filters, pagination, sort } = req.searchQuery;

  // Example Logging to show structure
  console.log("Page:", pagination.page);   // number
  console.log("Limit:", pagination.limit); // number
  
  // name.like: user input; find records where name includes this text (e.g. SQL LIKE '%' || value || '%')
  if (filters.name?.like) {
    console.log("Search name containing:", filters.name.like);
  }
  
  if (filters.age?.gte) {
    console.log("Search age >=", filters.age.gte);
  }

  // --- At this point, you pass `req.searchQuery` to your Service Layer ---
  // const users = userService.find(req.searchQuery);
  
  // Build ORDER BY from sort (e.g. ORDER BY age DESC, name ASC)
  if (sort?.length) {
    console.log("Sort by:", sort.map((s) => `${s.field} ${s.order}`).join(', '));
  }

  res.json({ 
    meta: { pagination, sort },
    data: "Mock Data based on filters" 
  });
};

// --- 3. Wire it up ---
// GET /users?age[gte]=18&name[like]=john&role[in]=admin,user&sort=age:desc,name:asc
router.get('/users', createSearchMiddleware(userSearchConfig), getUsers);

export default router;
```

## Golang

```golang
```