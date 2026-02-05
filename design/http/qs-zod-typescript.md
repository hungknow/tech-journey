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

## Types & helpers — `searchTypes.ts`

Filter config is defined with **Zod**. Helpers build operator objects (eq, gte, like, etc.) from a base type so the middleware can validate and infer types from the same schema.

```typescript
import { z, ZodTypeAny } from 'zod';

export interface SearchQuery<T = Record<string, unknown>> {
  filters: Partial<T>;
  pagination: { page: number; limit: number };
  sort?: Array<{ field: string; order: 'asc' | 'desc' }>;
}

const inOperator = z
  .union([z.string(), z.array(z.string())])
  .transform((val) => (Array.isArray(val) ? val : val.split(',').map((s) => s.trim()).filter(Boolean)));

/** String filters: eq, ne, like, in */
export function filterFieldString() {
  return z
    .object({
      eq: z.string().optional(),
      ne: z.string().optional(),
      like: z.string().optional(),
      in: inOperator.optional(),
    })
    .optional();
}

/** Number filters: eq, ne, gt, lt, gte, lte, in */
export function filterFieldNumber() {
  return z
    .object({
      eq: z.coerce.number().optional(),
      ne: z.coerce.number().optional(),
      gt: z.coerce.number().optional(),
      lt: z.coerce.number().optional(),
      gte: z.coerce.number().optional(),
      lte: z.coerce.number().optional(),
      in: inOperator.pipe(z.array(z.coerce.number())).optional(),
    })
    .optional();
}

/** Date filters: eq, ne, gt, lt, gte, lte, in */
export function filterFieldDate() {
  return z
    .object({
      eq: z.coerce.date().optional(),
      ne: z.coerce.date().optional(),
      gt: z.coerce.date().optional(),
      lt: z.coerce.date().optional(),
      gte: z.coerce.date().optional(),
      lte: z.coerce.date().optional(),
      in: inOperator.pipe(z.array(z.coerce.date())).optional(),
    })
    .optional();
}

/** Enum filters: eq, ne, in (validated against options) */
export function filterFieldEnum<T extends [string, ...string[]]>(options: T) {
  const enumSchema = z.enum(options);
  return z
    .object({
      eq: enumSchema.optional(),
      ne: enumSchema.optional(),
      in: inOperator.pipe(z.array(enumSchema)).optional(),
    })
    .optional();
}

/** Boolean filter: eq only */
export function filterFieldBoolean() {
  return z
    .object({
      eq: z
        .enum(['true', 'false'])
        .transform((v) => v === 'true')
        .optional(),
    })
    .optional();
}
```

---

## Middleware — `searchMiddleware.ts`

- Accepts a **Zod object schema** for the filters (the same schema you use to define searchable fields).
- Merges it with **pagination** and **sort** schemas, then validates `req.query` (qs-shaped).
- Sets `req.searchQuery` with typed filters inferred from the schema; on failure returns 400 with Zod `format()`.

```typescript
import { Request, Response, NextFunction, RequestHandler } from 'express';
import { z, ZodObject } from 'zod';
import { SearchQuery } from './searchTypes';

declare global {
  namespace Express {
    interface Request {
      searchQuery: SearchQuery;
    }
  }
}

const sortSchema = z
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
  });

const paginationSchema = z.object({
  page: z.coerce.number().min(1).default(1),
  limit: z.coerce.number().min(1).max(100).default(10),
  sort: sortSchema,
});

/** Creates search middleware from a Zod filters schema. Infers filter shape from the schema. */
export function createSearchMiddleware<T extends z.ZodRawShape>(
  filtersSchema: ZodObject<T>
): RequestHandler {
  const querySchema = filtersSchema.merge(paginationSchema);

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
}
```

---

## Usage — `userController.ts`

1. Define the **filters schema** with Zod using the helpers (`filterFieldString`, `filterFieldNumber`, `filterFieldEnum`, etc.).
2. Pass that schema to **createSearchMiddleware(filtersSchema)** — the middleware understands and validates using the same Zod type.
3. Read **req.searchQuery** (typed filters, pagination, sort) in the handler.

```typescript
import express, { Request, Response } from 'express';
import { createSearchMiddleware } from './searchMiddleware';
import {
  filterFieldString,
  filterFieldNumber,
  filterFieldEnum,
  filterFieldBoolean,
  filterFieldDate,
} from './searchTypes';
import { z } from 'zod';

const router = express.Router();

const userSearchConfig = z.object({
  name: filterFieldString(),
  age: filterFieldNumber(),
  role: filterFieldEnum(['admin', 'user', 'guest']),
  isActive: filterFieldBoolean(),
  joinedAt: filterFieldDate(),
});

const getUsers = (req: Request, res: Response) => {
  const { filters, pagination, sort } = req.searchQuery;
  // filters are typed from userSearchConfig, e.g. filters.name?.like, filters.age?.gte
  res.json({ meta: { pagination, sort }, data: 'Mock Data based on filters' });
};

// GET /users?age[gte]=18&name[like]=john&role[in]=admin,user&sort=age:desc,name:asc
router.get('/users', createSearchMiddleware(userSearchConfig), getUsers);

export default router;
```
