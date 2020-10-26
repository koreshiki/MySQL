-- This query produce table name following
-- 1. Tables with prefix only
-- 2. Tables with no prefix only
-- in performance_schema.

SELECT
    t1.table_name
FROM
    (
        SELECT
            table_name
        FROM
            information_schema.TABLES
        WHERE
            table_schema = 'sys'
        AND table_name NOT LIKE 'x$%'
    ) t1
    LEFT JOIN
        (
            SELECT
                table_name
            FROM
                information_schema.TABLES
            WHERE
                table_schema = 'sys'
            AND table_name LIKE 'x$%'
        ) t2
    ON  CONCAT('x$', t1.table_name) = t2.table_name
WHERE
    t2.table_name is null
UNION ALL
SELECT
    t2.table_name
FROM
    (
        SELECT
            table_name
        FROM
            information_schema.TABLES
        WHERE
            table_schema = 'sys'
        AND table_name NOT LIKE 'x$%'
    ) t1
RIGHT JOIN
    (
        SELECT
            table_name
        FROM
            information_schema.TABLES
        WHERE
            table_schema = 'sys'
        AND table_name LIKE 'x$%'
    ) t2
ON  CONCAT('x$', t1.table_name) = t2.table_name
WHERE
    t1.table_name is null;
