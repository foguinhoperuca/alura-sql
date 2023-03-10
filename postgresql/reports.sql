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
DROP VIEW IF EXISTS dspg_02.vw_courses_in_categories_with_min_students;
CREATE OR REPLACE VIEW dspg_02.vw_courses_in_categories_with_min_students AS
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
DROP VIEW IF EXISTS dspg_02.vw_courses_in_categories_with_max_students;
CREATE OR REPLACE VIEW dspg_02.vw_courses_in_categories_with_max_students AS
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
