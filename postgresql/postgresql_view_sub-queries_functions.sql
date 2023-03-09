DROP SCHEMA IF EXISTS dspg_02 CASCADE;
CREATE SCHEMA dspg_02 AUTHORIZATION postgres;
COMMENT ON SCHEMA dspg_02 IS 'Curso Postgresql: Views, sub-consultas e funções.';
GRANT ALL ON SCHEMA dspg_02 TO postgres WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA dspg_02 GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA dspg_02 GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA dspg_02 GRANT EXECUTE ON FUNCTIONS TO postgres WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA dspg_02 GRANT USAGE ON TYPES TO postgres WITH GRANT OPTION;

/*
 * DDL
 */
DROP VIEW IF EXISTS vw_courses_in_categories_with_min_students;
DROP VIEW IF EXISTS vw_courses_in_categories_with_max_students;
DROP TABLE IF EXISTS dspg_02.students_courses;
DROP TABLE IF EXISTS dspg_02.courses;
DROP TABLE IF EXISTS dspg_02.categories;
DROP TABLE IF EXISTS dspg_02.students;

CREATE TABLE dspg_02.categories (
	id SERIAL PRIMARY KEY,
	category_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE dspg_02.courses (
	id SERIAL PRIMARY KEY,
	course_name VARCHAR(255) NOT NULL,
	category_id INTEGER NOT NULL REFERENCES dspg_02.categories(id)
);

CREATE TABLE dspg_02.students (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	birthday DATE NOT NULL
);

CREATE TABLE dspg_02.students_courses (
	student_id INTEGER NOT NULL REFERENCES dspg_02.students(id),
	course_id INTEGER NOT NULL REFERENCES dspg_02.courses(id),
	enrolled_in TIMESTAMP NOT NULL,
	PRIMARY KEY (student_id, course_id)
);

/*
 * DML
 */
INSERT INTO dspg_02.categories(category_name) VALUES
	('Programming'),
	('Business/Leadership'),
	('UX/Design'),
	('Data Science'),
	('Database'),
	('Front-end'),
	('Dev Ops')
;

INSERT INTO dspg_02.courses(course_name, category_id) VALUES
	('Python', 1),
	('Ruby', 1),
	('Java', 1),
	('C', 1),
	('C++', 1),
	('Perl', 1),
	('PHP', 1),
	('Modern Management', 2),
	('Negotiation', 2),
	('GIMP', 3),
	('Inkscape', 3),
	('Pandas', 4),
	('Machine Learning', 4),
	('Power BI', 4),
	('PostgreSQL', 5),
	('MySQL', 5),
	('Oracle', 5),
	('SQL Server', 5),
	('SQLite', 5),
	('Javascript/Typescript', 6),
	('HTML/CSS', 6),
	('Git', 7),
	('Apache/Web Server', 7),
	('Docker', 7),
	('Ansible', 7)
;

INSERT INTO dspg_02.students(first_name, last_name, birthday) VALUES
	('Jefferson', 'Campos', '1984-04-01'),
	('Jonh', 'Wick', '1980-04-01'),
	('Greg', 'McGuire', '1974-04-01'),
	('Mike', 'Sullivan', '1951-04-01'),
	('Vinicius', 'Dias', '1997-10-15'),
	('Patricia', 'Freitas', '1986-10-25'),
	('Diogo', 'Oliveira', '1984-08-27'),
	('Maria', 'Rosa', '1985-01-01'),
	('Otto', 'von Bismarck', '1833-04-01')
;

INSERT INTO dspg_02.students_courses (student_id, course_id, enrolled_in) VALUES
	(1, 1, NOW()),
	(1, 2, NOW()),
	(1, 3, NOW()),
	(1, 4, NOW()),
	(1, 5, NOW()),
	(1, 6, NOW()),
	(1, 7, NOW()),
	(1, 15, NOW()),
	(1, 22, NOW()),
	(1, 23, NOW()),
	(1, 24, NOW()),
	(1, 25, NOW()),
	(2, 1, NOW()),
	(2, 2, NOW()),
	(2, 15, NOW()),
	(3, 1, NOW()),
	(3, 2, NOW()),
	(3, 3, NOW()),
	(3, 4, NOW()),
	(3, 15, NOW()),
	(4, 1, NOW()),
	(4, 2, NOW()),
	(4, 4, NOW()),
	(4, 5, NOW()),
	(4, 6, NOW()),
	(4, 15, NOW()),
	(5, 1, NOW()),
	(5, 7, NOW()),
	(5, 8, NOW()),
	(6, 9, NOW()),
	(6, 10, NOW()),
	(6, 15, NOW()),
	(7, 11, NOW()),
	(7, 12, NOW()),
	(7, 13, NOW()),
	(7, 14, NOW()),
	(7, 15, NOW()),
	(7, 16, NOW()),
	(8, 17, NOW()),
	(8, 18, NOW()),
	(8, 19, NOW()),
	(8, 20, NOW()),
	(8, 21, NOW()),
	(9, 1, NOW()),
	(9, 15, NOW()),
	(9, 17, NOW())
;

/*
 * Reports
 */

-- Students wih more courses
SELECT
	CONCAT(s.first_name, ' ', s.last_name) AS "STUDENT_NAME",
	COUNT(sc.course_id) AS "TOTAL_COURSES"
FROM dspg_02.students AS s
JOIN dspg_02.students_courses AS sc ON sc.student_id = s.id
GROUP BY
	-- 1,
	-- 2
	"STUDENT_NAME"
ORDER BY
	"TOTAL_COURSES" DESC,
	"STUDENT_NAME" DESC
-- LIMIT 1
;

-- Course with more students
SELECT
	c.course_name,
	COUNT(sc.student_id) AS "TOTAL_STUDENTS"
FROM dspg_02.courses AS c
JOIN dspg_02.students_courses AS sc ON sc.course_id = c.id
GROUP BY
	1
ORDER BY
	"TOTAL_STUDENTS" DESC,
	c.course_name ASC
-- LIMIT 1
;

-- Categories with more students
SELECT
	ca.category_name,
	COUNT(sc.student_id) AS "TOTAL_STUDENTS"
FROM dspg_02.courses AS c
JOIN dspg_02.students_courses AS sc ON sc.course_id = c.id
JOIN dspg_02.categories AS ca ON c.category_id = ca.id
GROUP BY
	ca.category_name
ORDER BY
	"TOTAL_STUDENTS" DESC,
	ca.category_name ASC
-- LIMIT 1
;

-- Courses from Front-end or programming
SELECT
	*
FROM dspg_02.courses AS c
WHERE
	c.category_id IN (1, 2)
;

-- Course with categories that hasn't name with spaces
SELECT
	c.*,
	ca.category_name
FROM dspg_02.courses AS c
JOIN dspg_02.categories AS ca ON c.category_id = ca.id
WHERE
	c.category_id IN (
		SELECT
			id
		FROM categories
		WHERE
			category_name NOT LIKE ('% %')
	)
;

-- CATEGORIES with MIN students
WITH summary AS (
	SELECT
		ca.category_name,
		COUNT(sc.student_id) AS "TOTAL_STUDENTS"
	FROM dspg_02.courses AS c
	JOIN dspg_02.students_courses AS sc ON sc.course_id = c.id
	JOIN dspg_02.categories AS ca ON c.category_id = ca.id
	GROUP BY
		ca.category_name
	ORDER BY
		"TOTAL_STUDENTS" DESC,
		ca.category_name ASC
)
SELECT
	ca.category_name,
	COUNT(sc.student_id) AS "TOTAL_STUDENTS"
FROM dspg_02.courses AS c
JOIN dspg_02.students_courses AS sc ON sc.course_id = c.id
JOIN dspg_02.categories AS ca ON c.category_id = ca.id
GROUP BY
	ca.category_name
HAVING
	COUNT(sc.student_id) = (
		SELECT
			MIN("TOTAL_STUDENTS")
		FROM summary
	)
ORDER BY
	ca.category_name DESC
;

-- COURSE in categories with MIN students
DROP VIEW IF EXISTS vw_courses_in_categories_with_min_students;
CREATE OR REPLACE VIEW vw_courses_in_categories_with_min_students AS
	WITH
	summary AS (
		SELECT
			ca.category_name,
			COUNT(sc.student_id) AS "TOTAL_STUDENTS_PER_CATEGORY"
		FROM dspg_02.courses AS c
		JOIN dspg_02.students_courses AS sc ON sc.course_id = c.id
		JOIN dspg_02.categories AS ca ON c.category_id = ca.id
		GROUP BY
			ca.category_name
		ORDER BY
			"TOTAL_STUDENTS_PER_CATEGORY" DESC,
			ca.category_name ASC
	),
	min_categories AS (
		SELECT
			s_ca.category_name AS "CATEGORY"
		FROM dspg_02.courses AS s_c
		JOIN dspg_02.students_courses AS s_sc ON s_sc.course_id = s_c.id
		JOIN dspg_02.categories AS s_ca ON s_c.category_id = s_ca.id
		GROUP BY
			s_ca.category_name
		HAVING
			COUNT(s_sc.student_id) = (
				SELECT
					MIN("TOTAL_STUDENTS_PER_CATEGORY")
				FROM summary
			)
	)
	SELECT
		LOWER(c.course_name) AS "COURSE_NAME",
		UPPER(ca.category_name) AS "CATEGORY_NAME",
		COUNT(sc.student_id) AS "TOTAL_STUDENTS_PER_COURSE"
	FROM dspg_02.courses AS c
	JOIN dspg_02.students_courses AS sc ON sc.course_id = c.id
	JOIN dspg_02.categories AS ca ON c.category_id = ca.id
	GROUP BY
		c.course_name,
		ca.category_name
	HAVING
		ca.category_name IN (
			SELECT
				"CATEGORY"
			FROM min_categories
		)
	ORDER BY
		ca.category_name DESC,
		c.course_name ASC
;
SELECT * FROM vw_courses_in_categories_with_min_students;

-- COURSE in categories with MAX students
DROP VIEW IF EXISTS vw_courses_in_categories_with_max_students;
CREATE OR REPLACE VIEW vw_courses_in_categories_with_max_students AS
	WITH
	summary AS (
		SELECT
			ca.category_name,
			COUNT(sc.student_id) AS "TOTAL_STUDENTS_PER_CATEGORY"
		FROM dspg_02.courses AS c
		JOIN dspg_02.students_courses AS sc ON sc.course_id = c.id
		JOIN dspg_02.categories AS ca ON c.category_id = ca.id
		GROUP BY
			ca.category_name
		ORDER BY
			"TOTAL_STUDENTS_PER_CATEGORY" DESC,
			ca.category_name ASC
	),
	max_categories AS (
		SELECT
			s_ca.category_name AS "CATEGORY"
		FROM dspg_02.courses AS s_c
		JOIN dspg_02.students_courses AS s_sc ON s_sc.course_id = s_c.id
		JOIN dspg_02.categories AS s_ca ON s_c.category_id = s_ca.id
		GROUP BY
			s_ca.category_name
		HAVING
			COUNT(s_sc.student_id) = (
				SELECT
					MAX("TOTAL_STUDENTS_PER_CATEGORY")
				FROM summary
			)
	)
	SELECT
		UPPER(c.course_name) AS "COURSE_NAME",
		LOWER(ca.category_name) AS "CATEGORY_NAME",
		COUNT(sc.student_id) AS "TOTAL_STUDENTS_PER_COURSE"
	FROM dspg_02.courses AS c
	JOIN dspg_02.students_courses AS sc ON sc.course_id = c.id
	JOIN dspg_02.categories AS ca ON c.category_id = ca.id
	GROUP BY
		c.course_name,
		ca.category_name
	HAVING
		ca.category_name IN (
			SELECT
				"CATEGORY"
			FROM max_categories
		)
	ORDER BY
		ca.category_name DESC,
		c.course_name ASC
;
SELECT * FROM vw_courses_in_categories_with_max_students;

-- Manipulation of views
SELECT
	*
FROM vw_courses_in_categories_with_max_students AS v
WHERE
	v."COURSE_NAME" LIKE '%C%'
;

-- Date manipulation
SELECT
	(s.first_name || ' ' || s.last_name) AS "FULL_NAME",
	NOW()::DATE,
	s.birthday,
	AGE(s.birthday) AS "STUDENT_AGE_FULL",
	EXTRACT(YEAR FROM AGE(s.birthday)) AS "STUDENT_AGE"
FROM dspg_02.students AS s;
