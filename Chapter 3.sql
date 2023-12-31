CREATE TABLE char_data_types (
    varchar_column varchar(10),
    char_column char(10),
    text_column text
);
INSERT INTO char_data_types
VALUES
    ('abc', 'abc', 'abc'),
    ('defghi', 'defghi', 'defghi');
COPY char_data_types TO 'C:\SQL\typetest.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');




CREATE TABLE number_data_types (
    numeric_column numeric(20,5),
    real_column real,
    double_column double precision
);
INSERT INTO number_data_types
VALUES
    (.7, .7, .7),
    (2.13579, 2.13579, 2.13579),
    (2.1357987654, 2.1357987654, 2.1357987654);
SELECT * FROM number_data_types;




SELECT
    numeric_column * 10000000 AS "Fixed",
    real_column * 10000000 AS "Float"
FROM number_data_types
WHERE numeric_column = .7;




CREATE TABLE date_time_types (
    timestamp_column timestamp with time zone,
    interval_column interval
);
INSERT INTO date_time_types
VALUES
    ('2018-12-31 01:00 EST','2 days'),
    ('2018-12-31 01:00 PST','1 month'),
    ('2018-12-31 01:00 Australia/Melbourne','1 century'),
    (now(),'1 week');
SELECT * FROM date_time_types;




SELECT
    timestamp_column,
    interval_column,
    timestamp_column - interval_column AS new_date
FROM date_time_types;




SELECT timestamp_column, 
    CAST(timestamp_column AS varchar(10))
FROM date_time_types;




SELECT numeric_column,
     CAST(numeric_column AS integer),
     CAST(numeric_column AS varchar(6))
FROM number_data_types;


-- Below returns error
SELECT 
    CAST(char_column AS integer) 
FROM char_data_types; 



-- CAST function short hand 
SELECT timestamp_column::varchar(10)
FROM date_time_types;



-- -- Practice Exercises

-- 1. fixed-point data type of numeric(4,1) is appropriate
-- with scale of 1 indicating values would be recorded to the nearest tenth and
-- a precision of 4 meaning we accomodate 3 digits before the decimal point since
-- we do not expect drivers to exceed the 3digit 999miles.

-- 2. varying characters of varchar(50) would be appropriate for first and last names.
-- varchar eliminates white space if entered characters do not reach the specified 50 compared to
-- using char(50). 
-- Separating the two names makes data management and certain queries easier to perform.

-- 3. We would receive an error