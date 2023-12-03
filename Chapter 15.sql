-- Creating and Querying Views
CREATE OR REPLACE VIEW nevada_counties_pop_2010_view AS
SELECT 
	 geo_name,
	 state_fips,
	 county_fips,
	 p0010001 AS pop_2010
 FROM us_counties_2010
 WHERE state_us_abbreviation = 'NV'
 ORDER BY county_fips;
 
-- DROP VIEW nevada_counties_pop_2010 
SELECT * 
FROM nevada_counties_pop_2010_view
LIMIT 5; 


-- Calculating Percentage Change Using a View
CREATE OR REPLACE VIEW county_pop_change_2010_2000_view AS
SELECT c2010.geo_name,
 c2010.state_us_abbreviation AS st,
 c2010.state_fips,
 c2010.county_fips,
 c2010.p0010001 AS pop_2010,
 c2000.p0010001 AS pop_2000,
 round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001) 
 / c2000.p0010001 * 100, 1 ) AS pct_change_2010_2000
 FROM us_counties_2010 AS c2010 INNER JOIN us_counties_2000 AS c2000
 ON c2010.state_fips = c2000.state_fips
 AND c2010.county_fips = c2000.county_fips
 ORDER BY c2010.state_fips, c2010.county_fips;


-- Simplified query incorporating the above view
SELECT geo_name,
	 st,
	 pop_2010,
	 pct_change_2010_2000
FROM county_pop_change_2010_2000_view
WHERE st = 'NV'
LIMIT 5;



-- Inserting, Updating, and Deleting Data Using a View
SELECT *
FROM employees

SELECT * 
FROM departments

CREATE OR REPLACE VIEW employees_tax_dept_view AS
 SELECT emp_id,
	 first_name,
	 last_name,
	 dept_id
 FROM employees
 WHERE dept_id = 1
 ORDER BY emp_id
 WITH LOCAL CHECK OPTION;
 
 SELECT *
 FROM employees_tax_dept_view 
 
 
 
 -- Inserting Rows Using employees_tax_dept_view
INSERT INTO employees_tax_dept_view (first_name, last_name, dept_id)
VALUES ('Suzanne', 'Legere', 1);

INSERT INTO employees_tax_dept_view (first_name, last_name, dept_id)
VALUES ('Jamil', 'White', 2);

SELECT * FROM employees_tax_dept_view;
SELECT * FROM employees;



-- Updating Rows Using employees_tax_dept_view
UPDATE employees_tax_dept_view
SET last_name = 'Le Gere' 
WHERE emp_id = 5;
SELECT * FROM employees_tax_dept_view;
SELECT * FROM employees;


-- Deleting Rows Using the employees_tax_dept_view
DELETE FROM employees_tax_dept_view
WHERE emp_id = 5;
SELECT * FROM employees_tax_dept_view;
SELECT * FROM employees;

DELETE FROM employees_tax_dept_view
WHERE emp_id = 4;




-- Programming Your Own Functions
-- Creating The percentage_change() Function

CREATE OR REPLACE FUNCTION percent_change(
	 new_value numeric,
	 old_value numeric,
	 decimal_places integer DEFAULT 1)
RETURNS numeric AS
'SELECT round(
 ((new_value - old_value) / old_value) * 100, decimal_places
);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;




-- Using The percent_change() Function
SELECT percent_change(110, 108, 2);
SELECT percent_change(110, 108);
SELECT percent_change(110, 108, 0);


SELECT c2010.geo_name,
	 c2010.state_us_abbreviation AS st,
	 c2010.p0010001 AS pop_2010,
	 
	--Using Function
	 percent_change(c2010.p0010001, c2000.p0010001) AS pct_chg_func,
	
	--Longhand formula version
	 round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
	/ c2000.p0010001 * 100, 1 ) AS pct_chg_formula
	
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips 
 AND c2010.county_fips = c2000.county_fips
ORDER BY pct_chg_func DESC
LIMIT 5;





-- Updating Data With a Function
SELECT *
FROM teachers


ALTER TABLE teachers ADD COLUMN personal_days integer;
SELECT first_name,
 last_name,
 hire_date,
 personal_days
FROM teachers;




CREATE OR REPLACE FUNCTION update_personal_days()
RETURNS void AS $$
BEGIN
 UPDATE teachers
 SET personal_days = 
 CASE WHEN (now() - hire_date) BETWEEN '5 years'::interval 
 AND '10 years'::interval THEN 4
 WHEN (now() - hire_date) > '10 years'::interval THEN 5
 ELSE 3 
 END;
 RAISE NOTICE 'personal_days updated!';
END;
$$ LANGUAGE plpgsql;


SELECT * FROM teachers

CREATE OR REPLACE FUNCTION update_personal_days()
RETURNS void AS $$
BEGIN
 UPDATE teachers
 SET personal_days = 
 CASE WHEN (now() - hire_date) BETWEEN '5 years'::interval 
 AND '10 years'::interval THEN 4
 WHEN (now() - hire_date) > '10 years'::interval THEN 5
 ELSE 3 
 END;
 RAISE NOTICE 'personal_days updated!';
END;
$$ LANGUAGE plpgsql;

--Running the update function 
SELECT update_personal_days();


SELECT first_name,
 last_name,
 hire_date,
 personal_days
FROM teachers;



-- Using Python Language in a Function
-------------TODO: FIX LANGUAGE ERROR----------------------------------------- 
CREATE EXTENSION plpythonu;

CREATE OR REPLACE FUNCTION trim_county(input_string text)
RETURNS text AS $$
 import re
 cleaned = re.sub(r' County', '', input_string)
 return cleaned
$$ LANGUAGE plpythonu;


SELECT geo_name,
 trim_county(geo_name)
FROM us_counties_2010
ORDER BY state_fips, county_fips
LIMIT 5;

-------------------------------------------------------------------

--Automating Database Actions With Triggers
--Example 1: Logging Grade Updates to a Table

-- Creating Tables to Track Grades and Updates
CREATE TABLE grades (
	 student_id bigint,
	 course_id bigint,
	 course varchar(30) NOT NULL,
	 grade varchar(5) NOT NULL,
PRIMARY KEY (student_id, course_id)
);
INSERT INTO grades
VALUES
	 (1, 1, 'Biology 2', 'F'),
	 (1, 2, 'English 11B', 'D'),
	 (1, 3, 'World History 11B', 'C'),
	 (1, 4, 'Trig 2', 'B');
	 
SELECT * FROM grades;

CREATE TABLE grades_history (
	 student_id bigint NOT NULL,
	 course_id bigint NOT NULL,
	 change_time timestamp with time zone NOT NULL,
	 course varchar(30) NOT NULL,
	 old_grade varchar(5) NOT NULL,
	 new_grade varchar(5) NOT NULL,
PRIMARY KEY (student_id, course_id, change_time)
)

SELECT * FROM grades_history;
 



--Creating the Function and Trigger
CREATE OR REPLACE FUNCTION record_if_grade_changed()
RETURNS trigger AS
$$
BEGIN
   IF NEW.grade <> OLD.grade THEN
      INSERT INTO grades_history (
			 student_id,
			 course_id,
			 change_time,
			 course,
			 old_grade,
			 new_grade)
 		VALUES
			 (OLD.student_id,
			 OLD.course_id,
			 now(),
			 OLD.course,
			 OLD.grade,
			 NEW.grade);
 		END IF;
 		RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--
CREATE TRIGGER grades_update
AFTER UPDATE
 ON grades
FOR EACH ROW
EXECUTE PROCEDURE record_if_grade_changed();


-- Testing the Trigger
UPDATE grades
SET grade = 'C'
WHERE student_id = 1 AND course_id = 1;


SELECT student_id,
	 change_time,
	 course,
	 old_grade,
	 new_grade
FROM grades_history;



-- Example 2: Automatically Classifying Temperatures
CREATE TABLE temperature_test (
	 station_name varchar(50),
	 observation_date date,
	 max_temp integer,
	 min_temp integer,
	 max_temp_group varchar(40),
PRIMARY KEY (station_name, observation_date)
);


CREATE OR REPLACE FUNCTION classify_max_temp()
 RETURNS trigger AS
$$
BEGIN
 CASE 
	 WHEN NEW.max_temp >= 90 THEN NEW.max_temp_group := 'Hot';
	 WHEN NEW.max_temp BETWEEN 70 AND 89 THEN NEW.max_temp_group := 'Pleasantly Warm';
	 WHEN NEW.max_temp BETWEEN 50 AND 69 THEN NEW.max_temp_group := 'Cold';
	 WHEN NEW.max_temp BETWEEN 33 AND 49 THEN NEW.max_temp_group := 'Unreasonably Cold';
	 WHEN NEW.max_temp BETWEEN 20 AND 32 THEN NEW.max_temp_group := 'Icey';
	 ELSE NEW.max_temp_group := 'Inhumane';
 END CASE;
 RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- 
CREATE TRIGGER temperature_insert
BEFORE INSERT
 ON temperature_test
FOR EACH ROW 
EXECUTE PROCEDURE classify_max_temp();


INSERT INTO temperature_test (station_name, observation_date, max_temp, min_temp)
VALUES
 ('North Station', '2019/01/19', 10, -3),
 ('North Station', '2019/3/20/', 28, 19),
 ('North Station', '2019/5/2', 65, 42),
 ('North Station', '2019/8/9', 93, 74);
 
SELECT * FROM temperature_test;