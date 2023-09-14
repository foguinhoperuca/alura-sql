DROP DATABASE IF EXISTS alura_dev_plpgsql;
DROP SCHEMA IF EXISTS dev_plpgsql CASCADE;

DROP TRIGGER IF EXISTS tg_create_instructor_logs ON dev_plpgsql.instructors;
DROP FUNCTION IF EXISTS dev_plpgsql.fn_create_instructor_trigger;
DROP FUNCTION IF EXISTS dev_plpgsql.fn_create_course;
DROP FUNCTION IF EXISTS dev_plpgsql.fn_create_instructor;
DROP TABLE IF EXISTS dev_plpgsql.instructor_logs;
DROP SEQUENCE IF EXISTS dev_plpgsql.instructor_logs_id_seq;
DROP TABLE IF EXISTS dev_plpgsql.instructors;
DROP SEQUENCE IF EXISTS dev_plpgsql.instructors_id_seq;
DROP TABLE IF EXISTS dev_plpgsql.students_courses;
DROP TABLE IF EXISTS dev_plpgsql.courses;
DROP SEQUENCE IF EXISTS dev_plpgsql.courses_id_seq;
DROP TABLE IF EXISTS dev_plpgsql.categories;
DROP SEQUENCE IF EXISTS dev_plpgsql.categories_id_seq;
DROP TABLE IF EXISTS dev_plpgsql.students;
DROP SEQUENCE IF EXISTS dev_plpgsql.students_id_seq;

CREATE DATABASE alura_dev_plpgsql;
CREATE SCHEMA dev_plpgsql;

CREATE SEQUENCE dev_plpgsql.students_id_seq START 1 MINVALUE 1;
CREATE TABLE dev_plpgsql.students
(
	id INTEGER NOT NULL DEFAULT nextval('dev_plpgsql.students_id_seq'::regclass),
	first_name  VARCHAR(255) NOT NULL,
	last_name  VARCHAR(255) NOT NULL,
	birthday DATE NOT NULL,
	CONSTRAINT students_pkey PRIMARY KEY (id)
);
ALTER SEQUENCE dev_plpgsql.students_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE dev_plpgsql.students_id_seq TO postgres WITH GRANT OPTION;
ALTER TABLE dev_plpgsql.students OWNER TO postgres;
GRANT ALL ON TABLE dev_plpgsql.students TO postgres WITH GRANT OPTION;

CREATE SEQUENCE dev_plpgsql.categories_id_seq START 1 MINVALUE 1;
CREATE TABLE dev_plpgsql.categories
(
	id INTEGER NOT NULL DEFAULT nextval('dev_plpgsql.categories_id_seq'::regclass),
	category_name VARCHAR(255),
	CONSTRAINT categories_pkey PRIMARY KEY (id)
);
ALTER SEQUENCE dev_plpgsql.categories_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE dev_plpgsql.categories_id_seq TO postgres WITH GRANT OPTION;
ALTER TABLE dev_plpgsql.categories OWNER TO postgres;
GRANT ALL ON TABLE dev_plpgsql.categories TO postgres WITH GRANT OPTION;

CREATE SEQUENCE dev_plpgsql.courses_id_seq START 1 MINVALUE 1;
CREATE TABLE dev_plpgsql.courses
(
	id INTEGER NOT NULL DEFAULT nextval('dev_plpgsql.courses_id_seq'::regclass),
	category_id INTEGER NOT NULL,
	course_name VARCHAR(255),
	CONSTRAINT fk_categories_on_courses FOREIGN KEY (category_id) REFERENCES dev_plpgsql.categories (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT courses_pkey PRIMARY KEY (id)
);
ALTER SEQUENCE dev_plpgsql.courses_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE dev_plpgsql.courses_id_seq TO postgres WITH GRANT OPTION;
ALTER TABLE dev_plpgsql.courses OWNER TO postgres;
GRANT ALL ON TABLE dev_plpgsql.courses TO postgres WITH GRANT OPTION;

CREATE TABLE dev_plpgsql.students_courses
(
	student_id INTEGER NOT NULL,
	course_id INTEGER NOT NULL,
	CONSTRAINT students_courses_pkey PRIMARY KEY (student_id, course_id),
	CONSTRAINT fk_students_on_students_courses FOREIGN KEY (student_id) REFERENCES dev_plpgsql.students (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fk_courses_on_students_courses FOREIGN KEY (course_id) REFERENCES dev_plpgsql.courses (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE dev_plpgsql.students_courses OWNER TO postgres;
GRANT ALL ON TABLE dev_plpgsql.students_courses TO postgres WITH GRANT OPTION;

CREATE SEQUENCE dev_plpgsql.instructors_id_seq START 1 MINVALUE 1;
CREATE TABLE dev_plpgsql.instructors
(
	id INTEGER NOT NULL DEFAULT nextval('dev_plpgsql.instructors_id_seq'::regclass),
	instructor_name VARCHAR(255),
    salary DECIMAL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT instructors_pkey PRIMARY KEY (id)
);
ALTER SEQUENCE dev_plpgsql.instructors_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE dev_plpgsql.instructors_id_seq TO postgres WITH GRANT OPTION;
ALTER TABLE dev_plpgsql.instructors OWNER TO postgres;
GRANT ALL ON TABLE dev_plpgsql.instructors TO postgres WITH GRANT OPTION;

CREATE SEQUENCE dev_plpgsql.instructor_logs_id_seq START 1 MINVALUE 1;
CREATE TABLE dev_plpgsql.instructor_logs
(
	id INTEGER NOT NULL DEFAULT nextval('dev_plpgsql.instructor_logs_id_seq'::regclass),
	information VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT instructor_logs_pkey PRIMARY KEY (id)
);
ALTER SEQUENCE dev_plpgsql.instructor_logs_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE dev_plpgsql.instructor_logs_id_seq TO postgres WITH GRANT OPTION;
ALTER TABLE dev_plpgsql.instructor_logs OWNER TO postgres;
GRANT ALL ON TABLE dev_plpgsql.instructor_logs TO postgres WITH GRANT OPTION;

CREATE OR REPLACE FUNCTION dev_plpgsql.fn_create_course(v_course_name VARCHAR, v_category_name VARCHAR) RETURNS void AS
$$
DECLARE
    v_category_id INTEGER;
BEGIN
    SELECT id INTO v_category_id FROM dev_plpgsql.categories AS c WHERE c.category_name = v_category_name;

    IF NOT FOUND THEN
        INSERT INTO dev_plpgsql.categories (category_name) VALUES
            (v_category_name)
        RETURNING id INTO v_category_id
        ;
    END IF;

    INSERT INTO dev_plpgsql.courses (course_name, category_id) VALUES
        (v_course_name, v_category_id)
    ;
END;
$$ LANGUAGE plpgsql

CREATE OR REPLACE FUNCTION dev_plpgsql.fn_create_instructor(v_instructor_name VARCHAR, v_instructor_salary DECIMAL) RETURNS void AS
$$
DECLARE
    v_instructor_id INTEGER;
    v_salary_avarage DECIMAL;
    v_poorest_instructors INTEGER DEFAULT 0;
    v_total_instructors INTEGER DEFAULT 0;
    v_salary DECIMAL;
    v_percentage DECIMAL;
BEGIN
    INSERT INTO dev_plpgsql.instructors (instructor_name, salary) VALUES
        (v_instructor_name, v_instructor_salary)
    RETURNING id INTO v_instructor_id
    ;

    SELECT
        AVG(i.salary) INTO v_salary_avarage
    FROM dev_plpgsql.instructors AS i
    WHERE
        i.id <> v_instructor_id
    ;

    IF v_instructor_salary > v_salary_avarage THEN
        INSERT INTO dev_plpgsql.instructor_logs (information) VALUES
            (v_instructor_name || ' has better salary than avarage.')
        ;
    END IF;

    FOR v_salary IN
        SELECT
            i.salary
        FROM dev_plpgsql.instructors AS i
        WHERE
            i.id <> v_instructor_id
    LOOP
        v_total_instructors := v_total_instructors + 1;
        IF v_instructor_salary > v_salary THEN
            v_poorest_instructors := v_poorest_instructors + 1;
        END IF;
    END LOOP;

    v_percentage := v_poorest_instructors::DECIMAL / v_total_instructors::DECIMAL * 100;

    INSERT INTO instructor_logs (information) VALUES
        (v_instructor_name || ' has better salary than ' || v_percentage || '% of all instructors.')
    ;
END;
$$ LANGUAGE plpgsql

DROP TRIGGER IF EXISTS tg_create_instructor_logs ON dev_plpgsql.instructors;
DROP FUNCTION IF EXISTS dev_plpgsql.fn_create_instructor_trigger;
CREATE OR REPLACE FUNCTION dev_plpgsql.fn_create_instructor_trigger() RETURNS TRIGGER LANGUAGE plpgsql AS
$$
DECLARE
    v_salary_avarage DECIMAL;
    v_poorest_instructors INTEGER DEFAULT 0;
    v_total_instructors INTEGER DEFAULT 0;
    v_salary DECIMAL;
    v_percentage DECIMAL;
BEGIN
    SELECT
        AVG(i.salary) INTO v_salary_avarage
    FROM dev_plpgsql.instructors AS i
    WHERE
        i.id <> NEW.id
    ;

    IF NEW.salary > v_salary_avarage THEN
        INSERT INTO dev_plpgsql.instructor_logs (information) VALUES
            (NEW.instructor_name || ' has better salary than avarage.')
        ;
    END IF;

    FOR v_salary IN
        SELECT
            i.salary
        FROM dev_plpgsql.instructors AS i
        WHERE
            i.id <> NEW.id
    LOOP
        v_total_instructors := v_total_instructors + 1;
        IF NEW.salary > v_salary THEN
            v_poorest_instructors := v_poorest_instructors + 1;
        END IF;
    END LOOP;

    v_percentage := v_poorest_instructors::DECIMAL / v_total_instructors::DECIMAL * 100;

    INSERT INTO dev_plpgsql.instructor_logs (information) VALUES
        (NEW.instructor_name || ' has better salary than ' || v_percentage || '% of all instructors.')
    ;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER tg_create_instructor_logs
    AFTER INSERT ON dev_plpgsql.instructors
    FOR EACH ROW
    EXECUTE FUNCTION dev_plpgsql.fn_create_instructor_trigger()
;
