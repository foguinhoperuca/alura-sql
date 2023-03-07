DROP SCHEMA IF EXISTS data_science_pg_02 CASCADE;
CREATE SCHEMA data_science_pg_02;

--
-- DDL
--
CREATE TABLE data_science_pg_02.students (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	birthday DATE NOT NULL
);

CREATE TABLE data_science_pg_02.categories (
	id SERIAL PRIMARY KEY,
	category_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE data_science_pg_02.courses (
	id SERIAL PRIMARY KEY,
	course_name VARCHAR(255) NOT NULL,
	category_id INTEGER NOT NULL REFERENCES data_science_pg_02.categories(id)
);

CREATE TABLE data_science_pg_02.students_courses (
	student_id INTEGER NOT NULL REFERENCES data_science_pg_02.students(id),
	course_id INTEGER NOT NULL REFERENCES data_science_pg_02.courses(id),
	enrolled_in TIMESTAMP NOT NULL,
	PRIMARY KEY (student_id, course_id)
);

--
-- DML
--
INSERT INTO data_science_pg_02.students(first_name, last_name, birthday) VALUES
	('Jefferson', 'Campos', '1984-04-01'),
	('Jonh', 'Wick', '1980-04-01'),
	('Greg', 'McGuire', '1974-04-01'),
	('Mike', 'Sullivan', '1951-04-01'),
	('Vinicius', 'Dias', '1997-10-15'),
	('Patricia', 'Freitas', '1986-10-25'),
	('Diogo', 'Oliveira', '1984-08-27'),
	('Maria', 'Rosa', '1985-01-01')
;

INSERT INTO data_science_pg_02.categories(category_name) VALUES
	('Programming'),
	('Business/Leardship'),
	('UX/Design'),
	('Data Science'),
	('Database'),
	('Front-end')
;

INSERT INTO data_science_pg_02.courses(course_name, category_id) VALUES
	('Python', 1),
	('Ruby', 1),
	('Java', 1),
	('C', 1),
	('C++', 1),
	('Perl'),
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
	('HTML/CSS', 6)
;

INSERT INTO aluno_curso (student_id, course_id) VALUES
	(1, 4, NOW()),
	(1, 5, NOW()),
	(2, 1, NOW()),
	(2, 2, NOW()),
	(3, 4, NOW()),
	(3, 3, NOW()),
	(4, 4, NOW()),
	(4, 6, NOW()),
	(4, 5, NOW()),
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
	(8, 18, NOW()),
	(8, 19, NOW()),
	(8, 20, NOW()),
	(8, 21, NOW())
;

--
-- Reports
--
SELECT
	s.first_name,
	s.last_name,
	COUNT(sc.course_id) AS "TOTAL_COURSES"
FROM students AS s
JOIN students_courses AS sc ON sc.students_id = students.id
GROUP BY
	1,
	2
ORDER BY
	TOTAL_COURSES DESC
LIMIT 1
;
   
SELECT
	c.course_name,
	COUNT(sc.students_id) AS "TOTAL_STUDENTS"
FROM courses AS c
JOIN students_courses AS sc ON sc.course_id = courses.id
GROUP BY
	1
ORDER BY
	TOTAL_STUDENTS DESC
LIMIT 1
;
