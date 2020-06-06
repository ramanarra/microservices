CREATE SEQUENCE public.player_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.player_id_seq
    OWNER TO postgres;


CREATE TABLE public.users
(
    id bigint NOT NULL DEFAULT nextval('player_id_seq'::regclass),
    name character varying(250) COLLATE pg_catalog."default" NOT NULL,
    email character varying(250) COLLATE pg_catalog."default" NOT NULL,
    password character varying(250) COLLATE pg_catalog."default" NOT NULL,
    salt character varying(250) COLLATE pg_catalog."default",
    role character varying(250) COLLATE pg_catalog."default",
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_key UNIQUE (email)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.users
    OWNER to postgres;

CREATE TABLE public.doctor
(
    doctor_id serial NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    account_key character varying(200) NOT NULL,
    CONSTRAINT doctor_id PRIMARY KEY (doctor_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.doctor
    OWNER to postgres;

CREATE TABLE public.patient
(
    patient_id serial NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    CONSTRAINT patient_id PRIMARY KEY (patient_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.patient
    OWNER to postgres;


CREATE TABLE public.roles
(
    roles_id serial NOT NULL,
    doctor_id bigint NOT NULL,
    roles character varying(100) NOT NULL,
    account_key character varying(200) NOT NULL,
    CONSTRAINT roles_id PRIMARY KEY (roles_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.roles
    OWNER to postgres;

CREATE TABLE public.account
(
    account_id serial NOT NULL,
    email character varying(100) NOT NULL,
    no_of_users bigint NOT NULL,
    sub_start_date date NOT NULL,
    sub_end_date date NOT NULL,
    account_key character varying(200) NOT NULL,
    CONSTRAINT account_id PRIMARY KEY (account_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.account
    OWNER to postgres;

ALTER TABLE public.roles
    ADD CONSTRAINT roles_to_doctor_id FOREIGN KEY (doctor_id)
    REFERENCES public.doctor (doctor_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX fki_roles_to_doctor_id
    ON public.roles(doctor_id);
