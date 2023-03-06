DROP SCHEMA IF EXISTS data_science_pg_02 CASCADE;
CREATE SCHEMA data_science_pg_02;

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
  PRIMARY KEY (student_id, course_id)
);
