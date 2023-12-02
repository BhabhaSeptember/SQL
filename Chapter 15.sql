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