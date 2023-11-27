SELECT upper('hello');

SELECT trim('s' from 'socks');

SELECT trim(trailing 's' from 'socks');

SELECT trim(leading 's' from 'socks');

SELECT char_length(trim(' Pat '));

SELECT ltrim('socks', 's');

SELECT rtrim('socks', 's');

SELECT left('703-555-1212', 3);
SELECT left('703-555-1212',4);

SELECT right('703-555-1212', 8);

SELECT replace('stacy', 'st', 'Tr');

SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '\d{4}');


-- Creating a table for crime reports
CREATE TABLE crime_reports (
 crime_id bigserial PRIMARY KEY,
 date_1 timestamp with time zone,
 date_2 timestamp with time zone,
 street varchar(250),
 city varchar(100),
 crime_type varchar(100),
 description text,
 case_number varchar(50),
 original_text text NOT NULL
);
COPY crime_reports (original_text)
FROM 'C:\SQL\crime_reports.csv'
WITH (FORMAT CSV, HEADER OFF, QUOTE '"');

SELECT original_text FROM crime_reports;


SELECT 
	crime_id,
 regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports;


SELECT 
	crime_id,
 regexp_matches(original_text, '\d{1,2}\/\d{1,2}\/\d{2}', 'g')
FROM crime_reports;


SELECT 
	crime_id,
 regexp_match(original_text, '-\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports;


SELECT 
	crime_id,
 	regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})')
FROM crime_reports;







--  below returns text in an array
SELECT 
 	regexp_match(original_text, '(?:C0|SO)[0-9]+') AS case_number,
 	regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,
 	regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,
 	regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city,
regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))') AS street
FROM crime_reports;



-- below extracts text from the array
SELECT 
 	crime_id,
 	(regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1] AS case_number
		(regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1] AS street
		(regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1] AS date_1,
		(regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] AS time_of_incident
FROM crime_reports;




-- todo: fix error
UPDATE crime_reports
SET date_1 =
(
 (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1] 
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
 ||' US/Eastern'
)::timestamptz;
SELECT 
    crime_id,
    date_1,
    original_text
FROM crime_reports;


-- 
UPDATE crime_reports
SET case_number = 
(
	(regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1]
)::character varying (50);

UPDATE crime_reports
SET street =
(
(regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1]
)::character varying (250);




-------------------------------------------------------------------------------

UPDATE crime_reports
SET date_1 = 
 (
 (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
 ||' US/Eastern'
 )::timestamptz,
 
 date_2 = 
 CASE
 WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NULL)
 AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
 THEN
 ((regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
 ||' US/Eastern'
 )::timestamptz 
WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NOT NULL)
 AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
 THEN 
 ((regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})'))[1]
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
 ||' US/Eastern'
 )::timestamptz 
 
 ELSE NULL
 END,
 street = (regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1],
 city = (regexp_match(original_text,
 '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n'))[1],
 crime_type = (regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):'))[1],
 description = (regexp_match(original_text, ':\s(.+)(?:C0|SO)'))[1],
 case_number = (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1];
 
 
 
 -- Using CASE to Handle Special Instances
 UPDATE crime_reports
SET date_1 = 
 (
 (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
 ||' US/Eastern'
 )::timestamptz,
 
 date_2 = 
 CASE
 WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NULL)
 AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
 THEN
 ((regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
 ||' US/Eastern'
 )::timestamptz
 WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NOT NULL)
 AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
 THEN 
 ((regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})'))[1]
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
 ||' US/Eastern'
 )::timestamptz 
 
 ELSE NULL
 END,
 street = (regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1],
 city = (regexp_match(original_text,
 '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n'))[1],
 crime_type = (regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):'))[1],
 description = (regexp_match(original_text, ':\s(.+)(?:C0|SO)'))[1],
 case_number = (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1];
 
 
 
 -- Listing 13-11
 SELECT 
	 date_1,
	 street,
	 city,
	 crime_type
FROM crime_reports;



-- Using Regular Expressions with WHERE
SELECT geo_name
FROM us_counties_2010
WHERE geo_name ~* '(.+lade.+|.+lare.+)'
ORDER BY geo_name;
SELECT geo_name
FROM us_counties_2010
WHERE geo_name ~* '.+ash.+' AND geo_name !~ 'Wash.+'
ORDER BY geo_name;


-- Adding Regular Expression Functions
SELECT regexp_replace('05/12/2018', '\d{4}', '2017');
SELECT regexp_split_to_table('Four,score,and,seven,years,ago', ',');
 
SELECT regexp_split_to_array('Phil Mike Tony Steve', ',');




SELECT array_length(regexp_split_to_array('Phil Mike Tony Steve', ' '), 1);
-------------------------------------------------------------------------------
