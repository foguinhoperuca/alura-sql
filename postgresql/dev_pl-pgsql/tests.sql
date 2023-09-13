-- TESTS

SELECT
    dev_plpgsql.fn_create_course('PHP', 'Programming')
;

SELECT
    *
FROM dev_plpgsql.courses AS co
LEFT JOIN dev_plpgsql.categories AS ca ON co.category_id = ca.id
;

SELECT
    dev_plpgsql.fn_create_course('Java', 'Programming')
;


-- Instuctor

INSERT INTO dev_plpgsql.instructors (instructor_name, salary, created_at) VALUES
	('Instructor A', 1000.00, NOW()),
	('Instructor B', 2000.00, NOW()),
	('Instructor C', 3000.00, NOW()),
	('Instructor D', 5000.00, NOW()),
	('Instructor E', 8000.00, NOW())
;

    
SELECT
    *
FROM dev_plpgsql.instructors AS i
;

SELECT
    *
FROM dev_plpgsql.instructor_logs AS l
;

-- EXECUTE dev_plpgsql.fn_create_instructor('Jeff', 1000);
SELECT dev_plpgsql.fn_create_instructor('Jeff 1', 1000.00);
SELECT dev_plpgsql.fn_create_instructor('Jeff 2', 2000.00);
