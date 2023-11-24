-- SELECT 
--  date_part('year', '2019-12-01 18:37:12 EST'::timestamptz) AS "year",
--  date_part('month', '2019-12-01 18:37:12 EST'::timestamptz) AS "month",
--  date_part('day', '2019-12-01 18:37:12 EST'::timestamptz) AS "day",
--  date_part('hour', '2019-12-01 18:37:12 EST'::timestamptz) AS "hour",
--  date_part('minute', '2019-12-01 18:37:12 EST'::timestamptz) AS "minute",
--  date_part('seconds', '2019-12-01 18:37:12 EST'::timestamptz) AS "seconds",
--  date_part('timezone_hour', '2019-12-01 18:37:12 EST'::timestamptz) AS "tz",
--  date_part('week', '2019-12-01 18:37:12 EST'::timestamptz) AS "week",
--  date_part('quarter', '2019-12-01 18:37:12 EST'::timestamptz) AS "quarter",
--  date_part('epoch', '2019-12-01 18:37:12 EST'::timestamptz) AS "epoch",
--  extract('year' from '2019-12-01 18:37:12 EST'::timestamptz) AS "year_extract_example";



-- SELECT 
-- 	 make_date(2018, 2, 22) AS "date",
-- 	 make_time(18, 4, 30.3) AS "time",
-- 	 make_timestamptz(2018, 2, 22, 18, 4, 30.3, 'Europe/Lisbon') AS "timestamp";



-- CREATE TABLE current_time_example (
-- 	 time_id bigserial,
-- 	 current_timestamp_col timestamp with time zone,
-- 	 clock_timestamp_col timestamp with time zone
-- );
-- INSERT INTO current_time_example (current_timestamp_col, clock_timestamp_col)
--  (SELECT 
-- 	 current_timestamp,
-- 	 clock_timestamp()
--  FROM generate_series(1,1000)
--  );
-- SELECT * FROM current_time_example;

-- SHOW timezone;
-- SHOW ALL;

-- SELECT * FROM pg_timezone_abbrevs;
-- SELECT * FROM pg_timezone_names;


-- SELECT * FROM pg_timezone_names
-- WHERE name LIKE 'Europe%';



SET timezone TO 'US/Pacific';
CREATE TABLE time_zone_test (
 test_date timestamp with time zone
);
INSERT INTO time_zone_test 
VALUES ('2020-01-01 4:00');
SELECT test_date
FROM time_zone_test;
SET timezone TO 'US/Eastern';
SELECT test_date
FROM time_zone_test;
SELECT test_date AT TIME ZONE 'Asia/Seoul'
FROM time_zone_test;