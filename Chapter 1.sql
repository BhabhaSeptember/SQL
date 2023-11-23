CREATE DATABASE analysis;

CREATE TABLE teachers (
    id bigserial,
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);

INSERT INTO teachers (first_name, last_name, school, hire_date, salary)
VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
       ('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000),
       ('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500),
       ('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
       ('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500),
       ('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);




-- Practice Exercises

CREATE TABLE all_animals (
	_id bigserial,
	nickname varchar(25),
	animal_type varchar(50)
);

INSERT INTO all_animals (nickname, animal_type)
VALUES ('Pipa', 'Hippo'),
	   ('Terry', 'Tiger'),
	   ('Ronny', 'Rhino');


CREATE TABLE animal_specifics (
	_id bigserial,
	nickname varchar(25),
	species varchar(75),
	animal_type  varchar(50),
	arrival_date date,
	life_expectancy numeric
);

INSERT INTO animal_specifics(nickname,species, animal_type, arrival_date, life_expectancy)
VALUES ('Pipa', 'Pygmy hippopotamus', 'Hippo', '1999-07-12', 36),
	   ('Terry', 'Panthera tigris', 'Tiger', '1995-07-15', 15),
	   ('Ronny', 'Rhinocerotidae', 'Rhino', '2003-08-22', 45);






