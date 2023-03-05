DROP DATABASE IF EXISTS alura;
CREATE DATABASE alura;
DROP SCHEMA IF EXISTS data_science_pg;
CREATE SCHEMA data_science_pg;

/*
 * Students
 */
DROP TABLE IF EXISTS data_science_pg.students;
DROP SEQUENCE IF EXISTS data_science_pg.students_id_seq;
CREATE SEQUENCE data_science_pg.students_id_seq START 1 MINVALUE 1;
CREATE TABLE data_science_pg.students
(
	id INTEGER NOT NULL DEFAULT nextval('data_science_pg.students_id_seq'::regclass),
	student_name  VARCHAR(255),
	cpf CHAR(11),
	observation TEXT,
	age INTEGER,
	money NUMERIC(10,2),
	height REAL,
	active BOOLEAN,
	birthday DATE,
	CONSTRAINT students_pkey PRIMARY KEY (id)
);
ALTER SEQUENCE data_science_pg.students_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE data_science_pg.students_id_seq TO postgres WITH GRANT OPTION;
ALTER TABLE data_science_pg.students OWNER TO postgres;
GRANT ALL ON TABLE data_science_pg.students TO postgres WITH GRANT OPTION;

--
-- DML Students
--

INSERT INTO data_science_pg.students (student_name, cpf, observation, age, money, height, active, birthday) VALUES
	('Diogo', '12345678901', 'Some obs goes here 01', 20, 100.50, 1.90, TRUE, '2002-07-17'),
	('José', '10987654321', 'Some obs goes here 02', 25, 99.99, 1.80, FALSE, '1990-04-07'),
	('Mário', '15975385246', 'Some obs goes here 03', 43, 1030.74, 1.70, TRUE, '1986-09-08'),
	('Alberto DEL Tree', '75314796364', 'Some obs goes here 04', 54, 7010.44, 1.81, TRUE, '1974-10-11')
;

UPDATE data_science_pg.students SET
	observation = 'More observation update A-02',
	money = 875.15,
	active = TRUE
WHERE
	id = 3
;

DELETE FROM data_science_pg.students WHERE student_name LIKE '%Alberto DEL Tree%';

-- Some queries
SELECT
  s.id,
  s.cpf,
  s.observation AS OBS,
  s.active
FROM data_science_pg.students AS s
WHERE
	s.active IS FALSE
;

/*
 * Course
 */
DROP TABLE IF EXISTS data_science_pg.courses;
DROP SEQUENCE IF EXISTS data_science_pg.courses_id_seq;
CREATE SEQUENCE data_science_pg.courses_id_seq START 1 MINVALUE 1;
CREATE TABLE data_science_pg.courses
(
	id INTEGER NOT NULL DEFAULT nextval('data_science_pg.courses_id_seq'::regclass),
	course_name VARCHAR(255),
	class_time TIME,
	code VARCHAR(16) UNIQUE,
	observation TEXT,
	CONSTRAINT courses_pkey PRIMARY KEY (id)
);
ALTER SEQUENCE data_science_pg.courses_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE data_science_pg.courses_id_seq TO postgres WITH GRANT OPTION;
ALTER TABLE data_science_pg.courses OWNER TO postgres;
GRANT ALL ON TABLE data_science_pg.courses TO postgres WITH GRANT OPTION;

--
-- DML
--

INSERT INTO data_science_pg.courses (id, course_name, class_time, code, observation) VALUES
	(1, 'HTML', '14:15:00', '0123456789ABCDEF', 'Basic course'),
	(2, 'Javascript', '15:15:00', '123456789ABCDEF0', 'Basic course'),
	(3, 'Python', '16:20:00', '23456789ABCDEF01', 'Basic course python'),
	(4, 'Java', '17:00:00', '3456789ABCDEF012', 'Basic course java')
;

/*
 * Course - Student
 */
DROP TABLE IF EXISTS data_science_pg.students_courses;
CREATE TABLE data_science_pg.students_courses
(
	student_id INTEGER NOT NULL,
	course_id INTEGER NOT NULL,
	enrolled_in TIMESTAMP,
	observation TEXT,
	CONSTRAINT fk_students_on_students_courses FOREIGN KEY (student_id) REFERENCES data_science_pg.students (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fk_courses_on_students_courses FOREIGN KEY (course_id) REFERENCES data_science_pg.courses (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE data_science_pg.students_courses OWNER TO postgres;
GRANT ALL ON TABLE data_science_pg.students_courses TO postgres WITH GRANT OPTION;

INSERT INTO data_science_pg.students_courses(student_id, course_id, enrolled_in, observation) VALUES
	(1, 1, '2023-03-03 09:47:51', 'OBS 01'),
	(1, 2, '2023-03-03 10:21:57', 'OBS 02'),
	(2, 1, '2023-03-03 11:10:11', 'OBS 03'),
	(2, 2, '2023-03-03 12:51:49', 'OBS 04'),
	(1, 3, '2023-03-03 13:25:21', 'OBS 05'),
	(1, 4, '2023-03-03 14:08:19', 'OBS 06'),
	(2, 4, '2023-03-03 14:08:19', 'OBS 07'),
	(3, 4, '2023-03-03 14:08:19', 'OBS 08')
;

SELECT
	s.student_name,
	s.cpf,
	s.active AS "Student is Active?",
	c.course_name,
	c.code,
	c.class_time,
	sc.enrolled_in,
	sc.observation
FROM data_science_pg.students AS s
INNER JOIN data_science_pg.students_courses AS sc ON s.id = sc.student_id
INNER JOIN data_science_pg.courses AS c ON sc.course_id = c.id
ORDER BY
	c.course_name DESC
	LIMIT 10 OFFSET 2
;

-- Total students enrolled by course
SELECT
	COUNT(sc.course_id),
	c.course_name
FROM data_science_pg.students_courses AS sc
INNER JOIN data_science_pg.courses AS c ON sc.course_id = c.id
GROUP BY
	c.course_name
HAVING
  	c.course_name LIKE '%Java%'
  	AND COUNT(sc.course_id) > 2
;
