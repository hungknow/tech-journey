BEGIN;

CREATE TABLE IF NOT EXISTS todos (
    id uuid PRIMARY KEY,
    title VARCHAR(128),
    completed bool
);

COMMIT;