DROP DATABASE IF EXISTS alura;
CREATE DATABASE alura;
CREATE SCHEMA postgresql_course;


/*
 * Students
 */
DROP TABLE IF EXISTS postgresql_course.students;
DROP SEQUENCE IF EXISTS postgresql_course.students_id_seq;
CREATE SEQUENCE postgresql_course.students_id_seq START 1 MINVALUE 1;
CREATE TABLE postgresql_course.students
(
	id INTEGER NOT NULL DEFAULT nextval('postgresql_course.students_id_seq'::regclass),
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
ALTER SEQUENCE postgresql_course.students_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE postgresql_course.students_id_seq TO postgres WITH GRANT OPTION;
ALTER TABLE postgresql_course.students OWNER TO postgres;
GRANT ALL ON TABLE postgresql_course.students TO postgres WITH GRANT OPTION;

--
-- DML Students
--

INSERT INTO postgresql_course.students (student_name, cpf, observation, age, money, height, active, birthday) VALUES
	('Diogo', '12345678901', 'Some obs goes here 01', 20, 100.50, 1.90, TRUE, '2002-07-17'),
	('José', '10987654321', 'Some obs goes here 02', 25, 99.99, 1.80, FALSE, '1990-04-07'),
	('Mário', '15975385246', 'Some obs goes here 03', 43, 1030.74, 1.70, TRUE, '1986-09-08'),
	('Alberto DEL Tree', '75314796364', 'Some obs goes here 04', 54, 7010.44, 1.81, TRUE, '1974-10-11')
;

UPDATE postgresql_course.students SET
	observation = 'More observation update A-02',
	money = 875.15,
	active = TRUE
WHERE
	id = 3
;

DELETE FROM postgresql_course.students WHERE student_name LIKE '%Alberto DEL Tree%';

-- Some queries
SELECT
  s.id,
  s.cpf,
  s.observation AS OBS,
  s.active
FROM postgresql_course.students AS s
WHERE
	s.active IS FALSE
;

/*
 * Course
 */
DROP TABLE IF EXISTS postgresql_course.courses;
DROP SEQUENCE IF EXISTS postgresql_course.courses_id_seq;
CREATE SEQUENCE postgresql_course.courses_id_seq START 1 MINVALUE 1;
CREATE TABLE postgresql_course.courses
(
	id INTEGER NOT NULL DEFAULT nextval('postgresql_course.courses_id_seq'::regclass),
	course_name VARCHAR(255),
	class_time TIME,
	code VARCHAR(16) UNIQUE,
	observation TEXT,
	CONSTRAINT courses_pkey PRIMARY KEY (id)
);
ALTER SEQUENCE postgresql_course.student_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE postgresql_course.student_id_seq TO postgres WITH GRANT OPTION;
ALTER TABLE postgresql_course.courses OWNER TO postgres;
GRANT ALL ON TABLE postgresql_course.courses TO postgres WITH GRANT OPTION;

--
-- DML
--

INSERT INTO postgresql_course.courses (id, course_name, class_time, code, observation) VALUES
	(1, 'HTML', '14:15:00', '0123456789ABCDEF', 'Basic course'),
	(2, 'Javascript', '15:15:00', '123456789ABCDEF0', 'Basic course')
;

/*
 * Course - Student
 */
DROP TABLE IF EXISTS postgresql_course.students_courses;
CREATE TABLE postgresql_course.students_courses
(
	student_id INTEGER NOT NULL,
	course_id INTEGER NOT NULL,
	enrolled_in TIMESTAMP,
	observation TEXT,
	CONSTRAINT fk_students_on_students_courses FOREIGN KEY (student_id) REFERENCES postgresql_course.students (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fk_courses_on_students_courses FOREIGN KEY (course_id) REFERENCES postgresql_course.courses (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE postgresql_course.students_courses OWNER TO postgres;
GRANT ALL ON TABLE postgresql_course.students_courses TO postgres WITH GRANT OPTION;

INSERT INTO postgresql_course.students_courses(student_id, course_id, enrolled_in, observation) VALUES
	(1, 1, '2023-03-03 09:47:51', 'OBS 01'),
	(1, 2, '2023-03-03 10:21:57', 'OBS 02' ),
	(2, 1, '2023-03-03 11:10:11', 'OBS 03' ),
	(2, 2, '2023-03-03 12:51:49', 'OBS 04' )
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
FROM postgresql_course.students AS s
INNER JOIN postgresql_course.students_courses AS sc ON s.id = sc.student_id
INNER JOIN postgresql_course.courses AS c ON sc.course_id = c.id
;




/*
 * Employee
 */
