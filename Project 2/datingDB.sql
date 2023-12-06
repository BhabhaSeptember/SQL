-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.my_contacts
(
    contact_id bigserial,
    last_name character varying(50),
    first_name character varying(50) NOT NULL,
    phone character varying(10) NOT NULL,
    email character varying(100) NOT NULL,
    gender character(1) NOT NULL,
    birthday date NOT NULL,
    prof_id bigserial,
    zip_code character varying(4),
    status_id bigserial,
    PRIMARY KEY (contact_id)
);

CREATE TABLE IF NOT EXISTS public.profession
(
    prof_id bigserial,
    profession character varying(100) NOT NULL,
    PRIMARY KEY (prof_id),
    CONSTRAINT prof_unique UNIQUE (prof_id, profession)
);

CREATE TABLE IF NOT EXISTS public.zip_code
(
    zip_code character varying(4),
    city character varying(100) NOT NULL,
    province character varying(25) NOT NULL,
    PRIMARY KEY (zip_code)
-- 	CONSTRAINT zip_code_length CHECK zip_code = numeric(4,0)
);
SELECT * FROM zip_code
DROP TABLE zip_code
INSERT INTO zip_code (zip_code)
VALUES
	
CREATE TABLE IF NOT EXISTS public.status
(
    status_id bigserial,
    status character varying(50) NOT NULL,
    PRIMARY KEY (status_id)
);

CREATE TABLE IF NOT EXISTS public.contact_interests
(
    contact_id bigserial,
    interest_id bigserial,
    PRIMARY KEY (contact_id, interest_id)
);

CREATE TABLE IF NOT EXISTS public.contact_seeking
(
    contact_id bigserial,
    seeking_id bigserial,
    PRIMARY KEY (contact_id, seeking_id)
);

CREATE TABLE IF NOT EXISTS public.interests
(
    interest_id bigserial,
    interests_1 character varying(100) NOT NULL,
    interests_2 character varying(100),
    interests_3 character varying(100),
    PRIMARY KEY (interest_id)
);

CREATE TABLE IF NOT EXISTS public.seeking
(
    seeking_id bigserial,
    looking_for character varying(250) NOT NULL,
    PRIMARY KEY (seeking_id)
);

ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT prof_id FOREIGN KEY (prof_id)
    REFERENCES public.profession (prof_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT zip_code FOREIGN KEY (zip_code)
    REFERENCES public.zip_code (zip_code) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT status FOREIGN KEY (status_id)
    REFERENCES public.status (status_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_interests
    ADD CONSTRAINT contact_id FOREIGN KEY (contact_id)
    REFERENCES public.my_contacts (contact_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_interests
    ADD CONSTRAINT interest_id FOREIGN KEY (interest_id)
    REFERENCES public.interests (interest_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_seeking
    ADD CONSTRAINT seeking_id FOREIGN KEY (seeking_id)
    REFERENCES public.seeking (seeking_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_seeking
    ADD CONSTRAINT contact_id FOREIGN KEY (contact_id)
    REFERENCES public.my_contacts (contact_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;

-----------------------------------------------------------------------------------------