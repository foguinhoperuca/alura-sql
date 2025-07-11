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
DROP VIEW IF EXISTS dspg_02.vw_ticket_to_detention;
DROP VIEW IF EXISTS dspg_02.vw_students_ranking;
DROP VIEW IF EXISTS dspg_02.vw_free_man;
DROP TABLE IF EXISTS dspg_02.students_courses;
DROP TABLE IF EXISTS dspg_02.courses;
DROP TABLE IF EXISTS dspg_02.categories;
DROP TABLE IF EXISTS dspg_02.students_in_detention;
DROP TABLE IF EXISTS dspg_02.students;
DROP TYPE IF EXISTS dspg_02.course_levels;

CREATE TYPE dspg_02.course_levels AS ENUM
(
	'STARTING',
	'NORMAL',
	'EXPERT'
);

CREATE TABLE dspg_02.categories (
	id SERIAL PRIMARY KEY,
	category_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE dspg_02.courses (
	id SERIAL PRIMARY KEY,
	category_id INTEGER NOT NULL REFERENCES dspg_02.categories(id),
	course_name VARCHAR(255) NOT NULL,
	course_level dspg_02.course_levels NULL
);

CREATE TABLE dspg_02.students (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	birthday DATE NOT NULL,
	ankle_monitor BOOLEAN
);

CREATE TABLE dspg_02.students_courses (
	student_id INTEGER NOT NULL REFERENCES dspg_02.students(id),
	course_id INTEGER NOT NULL REFERENCES dspg_02.courses(id),
	enrolled_in TIMESTAMP NOT NULL,
	PRIMARY KEY (student_id, course_id)
);

DROP TABLE IF EXISTS dspg_02.detentions;
CREATE TABLE dspg_02.detentions (
	id INTEGER PRIMARY KEY,
	full_name VARCHAR(512) NOT NULL,
	total_courses INTEGER NOT NULL
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

INSERT INTO dspg_02.courses(course_name, category_id, course_level) VALUES
	('Python', 1, 'STARTING'),
	('Ruby', 1, 'NORMAL'),
	('Java', 1, 'EXPERT'),
	('C', 1, 'EXPERT'),
	('C++', 1, 'EXPERT'),
	('Perl', 1, 'EXPERT'),
	('PHP', 1, 'STARTING'),
	('Modern Management', 2, 'STARTING'),
	('Negotiation', 2, 'NORMAL'),
	('GIMP', 3, 'EXPERT'),
	('Inkscape', 3, 'NORMAL'),
	('Pandas', 4, 'NORMAL'),
	('Machine Learning', 4, 'EXPERT'),
	('Power BI', 4, 'STARTING'),
	('PostgreSQL', 5, 'EXPERT'),
	('MySQL', 5, 'STARTING'),
	('Oracle', 5, 'STARTING'),
	('SQL Server', 5, 'STARTING'),
	('SQLite', 5, 'NORMAL'),
	('Javascript/Typescript', 6, 'NORMAL'),
	('HTML/CSS', 6, 'NORMAL'),
	('Git', 7, 'EXPERT'),
	('Apache/Web Server', 7, 'EXPERT'),
	('Docker', 7, 'NORMAL'),
	('Ansible', 7, 'NORMAL')
;

INSERT INTO dspg_02.students(first_name, last_name, birthday, ankle_monitor) VALUES
	('Jefferson', 'Campos', '1984-04-01', FALSE),
	('Jonh', 'Wick', '1980-04-01', FALSE),
	('Greg', 'McGuire', '1974-04-01', FALSE),
	('Mike', 'Sullivan', '1951-04-01', FALSE),
	('Vinicius', 'Dias', '1997-10-15', FALSE),
	('Patricia', 'Freitas', '1986-10-25', FALSE),
	('Diogo', 'Oliveira', '1984-08-27', FALSE),
	('Maria', 'Rosa', '1985-01-01', FALSE),
	('Otto', 'von Bismarck', '1833-04-01', FALSE)
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

-- insert students in detention by number of courses
DROP VIEW IF EXISTS dspg_02.vw_students_ranking;
CREATE OR REPLACE VIEW dspg_02.vw_students_ranking AS
	SELECT
		CONCAT(r_s.first_name, ' ', r_s.last_name) AS "student_name",
		COUNT(r_sc.course_id) AS "total_courses"
	FROM dspg_02.students AS r_s
	JOIN dspg_02.students_courses AS r_sc ON r_sc.student_id = r_s.id
	GROUP BY
		"student_name"
	ORDER BY
		"total_courses" DESC,
		"student_name" DESC
;
DROP VIEW IF EXISTS dspg_02.vw_ticket_to_detention;
CREATE OR REPLACE VIEW dspg_02.vw_ticket_to_detention AS
	WITH
		detention AS (
			SELECT
				MIN(sr."total_courses") AS "detention_min_courses"
			FROM dspg_02.vw_students_ranking AS sr
		)
	SELECT
		id,
		CONCAT(s.first_name, ' ', s.last_name) AS "student_name",
		COUNT(sc.course_id) AS "total_courses"
	FROM dspg_02.students AS s
	JOIN dspg_02.students_courses AS sc ON sc.student_id = s.id
	GROUP BY
		id,
		"student_name"
	HAVING
		COUNT(sc.course_id) = (
			SELECT
				d."detention_min_courses"
			FROM detention AS d
		)
	ORDER BY
		"student_name" DESC
;
INSERT INTO dspg_02.detentions(id, full_name, total_courses)
	SELECT * FROM dspg_02.vw_ticket_to_detention
;
UPDATE dspg_02.students AS s SET
	ankle_monitor = TRUE
FROM dspg_02.detentions AS d
WHERE
	s.id = d.id
;
-- SELECT * FROM dspg_02.vw_students_ranking;
-- SELECT * FROM dspg_02.vw_ticket_to_detention;
-- SELECT * FROM dspg_02.detentions;
-- SELECT * FROM dspg_02.students;

-- Add a course to Jonh Wick and freed him
BEGIN;
	INSERT INTO dspg_02.students_courses (student_id, course_id, enrolled_in) VALUES
		(2, 23, NOW())
	;
	DROP VIEW IF EXISTS dspg_02.vw_free_man;
	CREATE OR REPLACE VIEW dspg_02.vw_free_man AS
		SELECT
			*
		FROM dspg_02.detentions AS d
		WHERE
			d.id NOT IN (SELECT id FROM dspg_02.vw_ticket_to_detention)
	;
	-- SELECT * FROM dspg_02.vw_free_man;
	DELETE
	FROM dspg_02.detentions AS d
	USING dspg_02.vw_free_man AS f
	WHERE
		d.id = f.id
	;
	UPDATE dspg_02.students AS s SET
		ankle_monitor = FALSE
	WHERE
		s.ankle_monitor IS TRUE
		AND s.id NOT IN (SELECT id FROM dspg_02.detentions)
	;
COMMIT;

