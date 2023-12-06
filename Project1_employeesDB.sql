--TODO: Test out unique constraints
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
INSERT INTO employees
VALUES
	('2', 'Makhosi', 'Mshengu', 'F', '67 Carey Road, Pelham, Pietermaritzburg, 3201', 'mmshengu@yahoo.co.za', 1, 5, 5, 1);
	('5', 'Olivia' ,'Oaks', 'F', '1 Albion Road, Rondebosch Oaks, Rondebosch, Cape Town, 7701', 'olioaks@yahoo.com', 2, 2, 2, 2);
INSERT INTO employees
VALUES
	('1', 'Joe', 'Johnson', 'M', '29 Browning Road, Observatory, Cape Town, 7925', 'jshezi@outlook.com', 2, 4, 3 );	
	('3', 'Brian', 'Becker', 'M', '44 Shakespeare Road, Matlosana, Orkney, 2619', 'brianbekker@outlook.com', 5, 1, 1 ),
	('4', 'Paula', 'Peterson', 'F', '7 Marshall Road, Humewood, Pretoria, 0001', 'ppeter@gmail.com', 4, 3, 4 );
SELECT * FROM employees;



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
	overtime_hours time with timezone,
	CONSTRAINT overtime_unique UNIQUE (overtime_id, overtime_hours)
);
INSERT INTO overtime_hours
VALUES
	('1', '09:00:50'),
	('2', '15:30:00');




	-- JOINING TABLES

SELECT * FROM employees;
SELECT * FROM department;
SELECT * FROM roles;
SELECT * FROM salaries;
SELECT * FROM overtime_hours;

SELECT *
FROM department JOIN employees
ON department.depart_id = employees.depart_id


SELECT * 
FROM salaries JOIN employees 
ON salaries.salary_id = employees.salary_id


SELECT * 
FROM roles JOIN employees
ON roles.role_id = employees.role_id

SELECT * 
FROM overtime_hours JOIN employees
ON overtime_hours.overtime_id = employees.overtime_id



--Showing that constraints are working
INSERT INTO employees
VALUES
	('1', 'Joe', 'Jackson', 'M', '29 Scott Road, Rondebosch, Cape Town, 7925', 'jjackson@gmail.com', 2, 4, 3 );
--RETURNS ERROR:  Key (emp_id)=(1) already exists.duplicate key value violates unique constraint "employees_pkey" 


INSERT INTO employees
VALUES
	(3, 'Joe', 'Jackson', 'M', '29 Scott Road, Rondebosch, Cape Town, 7925', 'jjackson@gmail.com', 6, 4, 3)
--RETURNS ERROR:  Key (depart_id)=(6) is not present in table "department".insert or update on table "employees" violates foreign key constraint "employees_depart_id_fkey" 
