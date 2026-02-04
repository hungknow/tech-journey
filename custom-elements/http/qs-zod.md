# Query String Parsing with qs + Zod

Parse complex URL query strings (filters, sort, pagination) into a typed structure in a TypeScript backend.

---

## Data flow

**URL:**  
`GET /users?age[gte]=21&role=admin&name[like]=john&sort=age:desc,name:asc`

**After qs:**  
`{ age: { gte: '21' }, role: 'admin', name: { like: 'john' }, sort: 'age:desc,name:asc' }`  
*(Also supports array form: `sort[]=age:desc&sort[]=name:asc` → `sort: ['age:desc', 'name:asc']`.)*

**Middleware:** numbers/date coerce; enums validated; `like` = substring match; `sort` = `column:direction` (default `asc`); `page`/`limit` = pagination.

**Attached to request:**

```ts
req.searchQuery = {
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

Use `req.searchQuery.sort` for multi-column `ORDER BY` (e.g. `ORDER BY age DESC, name ASC`).

---

## Types — `searchTypes.ts`

```typescript
import { z } from 'zod';

export type FieldType = 'string' | 'number' | 'enum' | 'date' | 'boolean';

export interface SearchFieldConfig {
  type: FieldType;
  options?: string[]; // Required when type is 'enum'
}

export interface SearchConfig {
  fields: Record<string, SearchFieldConfig>;
}

export interface FilterOperators<T> {
  eq?: T;
  ne?: T;
  gt?: T;
  lt?: T;
  gte?: T;
  lte?: T;
  like?: string; // strings only: substring match
  in?: T[];
}

export interface SearchQuery<T = any> {
  filters: Partial<Record<keyof T, FilterOperators<any>>>;
  pagination: { page: number; limit: number };
  sort?: Array<{ field: string; order: 'asc' | 'desc' }>;
}
```

---

## Middleware — `searchMiddleware.ts`

- Builds a **dynamic Zod schema** from `SearchConfig` (once at startup).
- Parses `req.query` (qs-shaped), validates, then splits into `filters`, `pagination`, `sort`.
- Sets `req.searchQuery`; on validation failure returns 400 with Zod `format()`.

```typescript
import { Request, Response, NextFunction, RequestHandler } from 'express';
import { z, ZodTypeAny } from 'zod';
import { SearchConfig } from './searchTypes';

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
  const fieldSchemas: Record<string, ZodTypeAny> = {};

  Object.entries(config.fields).forEach(([key, rule]) => {
    let baseType: ZodTypeAny;
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

    const operators = z.object({
      eq: baseType.optional(),
      ne: baseType.optional(),
      gt: rule.type === 'number' || rule.type === 'date' ? baseType.optional() : z.undefined(),
      lt: rule.type === 'number' || rule.type === 'date' ? baseType.optional() : z.undefined(),
      gte: rule.type === 'number' || rule.type === 'date' ? baseType.optional() : z.undefined(),
      lte: rule.type === 'number' || rule.type === 'date' ? baseType.optional() : z.undefined(),
      like: rule.type === 'string' ? z.string().optional() : z.undefined(),
      in: z.union([z.string(), z.array(z.string())])
        .transform((val) => (Array.isArray(val) ? val : val.split(',')))
        .optional(),
    });

    fieldSchemas[key] = operators.optional();
  });

  const querySchema = z.object({
    ...fieldSchemas,
    page: z.coerce.number().min(1).default(1),
    limit: z.coerce.number().min(1).max(100).default(10),
    sort: z
      .union([z.string(), z.array(z.string())])
      .optional()
      .transform((val): Array<{ field: string; order: 'asc' | 'desc' }> | undefined => {
        if (val == null) return undefined;
        const parts = Array.isArray(val) ? val : val.split(',').map((s) => s.trim()).filter(Boolean);
        if (parts.length === 0) return undefined;
        return parts.map((part) => {
          const [field, order] = part.split(':');
          return { field: field ?? '', order: (order === 'desc' ? 'desc' : 'asc') as 'asc' | 'desc' };
        });
      }),
  });

  return (req: Request, res: Response, next: NextFunction): void => {
    const result = querySchema.safeParse(req.query);
    if (!result.success) {
      res.status(400).json({ error: 'Invalid Search Parameters', details: result.error.format() });
      return;
    }
    const { page, limit, sort, ...filters } = result.data;
    req.searchQuery = { filters, pagination: { page, limit }, sort };
    next();
  };
};
```

---

## Usage — `userController.ts`

1. Define **field config** (type + enum options when needed).
2. Use **createSearchMiddleware(config)** on the route.
3. Read **req.searchQuery** (filters, pagination, sort) in the handler.

```typescript
import express, { Request, Response } from 'express';
import { createSearchMiddleware } from './searchMiddleware';
import { SearchConfig } from './searchTypes';

const router = express.Router();

const userSearchConfig: SearchConfig = {
  fields: {
    name: { type: 'string' },
    age: { type: 'number' },
    role: { type: 'enum', options: ['admin', 'user', 'guest'] },
    isActive: { type: 'boolean' },
    joinedAt: { type: 'date' },
  },
};

const getUsers = (req: Request, res: Response) => {
  const { filters, pagination, sort } = req.searchQuery;
  // e.g. filters.name?.like, filters.age?.gte, sort → ORDER BY
  res.json({ meta: { pagination, sort }, data: 'Mock Data based on filters' });
};

// GET /users?age[gte]=18&name[like]=john&role[in]=admin,user&sort=age:desc,name:asc
router.get('/users', createSearchMiddleware(userSearchConfig), getUsers);

export default router;
```

---

## Other languages

- **Golang:** (placeholder — implement equivalent with a query parser + struct tags or manual parsing.)
