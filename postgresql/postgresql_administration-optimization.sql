-- view conf:  cat /etc/postgresql/15/main/postgresql.conf | grep -v '#' | grep -ve '^$'
-- admin postgres: pg_ctl <COMMAND>

-- DROP TABLE instructors;
-- CREATE TABLE instructors (
--     id SERIAL PRIMARY KEY,
--     instructor_name VARCHAR(255) NOT NULL,
--     salary DECIMAL(10, 2)
-- );

DROP TRIGGER IF EXISTS tg_create_instructor_logs_cursor ON dev_plpgsql.instructors;
DROP FUNCTION IF EXISTS dev_plpgsql.fn_create_course_cursor;
DROP FUNCTION IF EXISTS dev_plpgsql.internal_instructors;
DROP TRIGGER IF EXISTS tg_create_instructor_logs ON dev_plpgsql.instructors;
DROP FUNCTION IF EXISTS dev_plpgsql.fn_create_instructor_trigger;
DROP FUNCTION IF EXISTS dev_plpgsql.fn_create_course;
DROP FUNCTION IF EXISTS dev_plpgsql.fn_create_instructor;

SELECT COUNT(*) FROM instructors;
DO $$
    DECLARE
    BEGIN
        FOR i IN 1..1000000 LOOP
            INSERT INTO instructors (instructor_name, salary) VALUES ('Instructors ' || i, random() * 1000 + 1);
        END LOOP;
    END;
$$;
UPDATE instructors SET salary = salary * 2 WHERE id % 2 = 1;
DELETE FROM instructors WHERE id % 2 = 0;

VACUUM ANALYSE instructors;
VACUUM VERBOSE;
VACUUM FULL;

REINDEX TABLE instructors;

SELECT relname, n_dead_tup FROM pg_stat_user_tables;
SELECT pg_size_pretty(pg_relation_size('instructors'));
