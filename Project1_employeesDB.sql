--TODO: FIX BELOW CODE
CREATE TABLE employees (
	emp_id bigserial PRIMARY KEY,
	first_name varchar(100) NOT NULL,
	surname varchar(100) NOT NULL,
	gender character(1),
	address varchar(250) NOT NULL,
	email varchar(100) NOT NULL,
	depart_id integer REFERENCES department (depart_id), 
	role_id integer REFERENCES roles (role_id),
	salary_id integer REFERENCES salaries (salary_id),
	overtime_id integer REFERENCES overtime_hours (overtime_id),
CONSTRAINT emp_details_unique 
  UNIQUE (emp_id, email, salary_id, overtime_id)	
);
SELECT * FROM employees;
INSERT INTO employees (first_name,surname,gender,address,email)
VALUES
	('Paul'),
	('Shezi'),
	('M'),
	('29 Browning Drive, Observatory, Cape Town, 7925 '),
	('pshezi@outlook.com');
	('2'),
	('4'),
	('3');
INSERT INTO employees (first_name)

---------------------------------------------------------------------
--TODO: Not part of employeesDB, just a test to fix errors of table above
CREATE TABLE test (
	emp_id bigserial PRIMARY KEY,
	first_name varchar(100) NOT NULL,
	surname varchar(100) NOT NULL,
	gender varchar(1)
	)
INSERT INTO test (first_name, surname)
VALUES
	('Paul',
	('Shezi');
	 
-- 	('1'),

	
-- 	('M');
-----------------------------------------------------------------
CREATE TABLE department (
	depart_id bigserial PRIMARY KEY,
	depart_name varchar(100) NOT NULL,
	depart_city varchar(50) NOT NULL,
CONSTRAINT depart_city_unique UNIQUE (depart_name, depart_city)	
);
INSERT INTO department (depart_name, depart_city)
VALUES 
	('Department of Education', 'Pietermaritzburg'),
	('Department of Water and Sanitation', 'Cape Town'),
	('Department of Agriculture, Forestry and Fisheries', 'Port Elizabeth'),
	('Department of Home Affairs', 'Pretoria'),
	('Department of Minerals and Energy', 'Orkney');
SELECT * FROM department;



CREATE TABLE roles (
	role_id bigserial PRIMARY KEY,
	emp_role varchar(100) NOT NULL
);
INSERT INTO roles(emp_role)
VALUES
	('Land Surveyor'),
	('Administrative Clerk'),
	('Data Center Technician'),
	('Environmental Manager'),
	('Teachers Assistant');
SELECT * FROM roles;




CREATE TABLE salaries (
	salary_id bigserial PRIMARY KEY,
	salary_pa money NOT NULL 
);
INSERT INTO salaries (salary_pa)
VALUES
	('390000'),
	('159115'),
	('273752'),
	('480000'),
	('132000');
SELECT * FROM salaries;
	
	


CREATE TABLE overtime_hours (
	overtime_id bigserial PRIMARY KEY,
	overtime_hours interval,
	CONSTRAINT overtime_unique UNIQUE (overtime_id, overtime_hours)
);
INSERT INTO overtime_hours (overtime_hours)
VALUES 
	(12/40/50::interval);