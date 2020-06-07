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

TABLESPACE pg_default;

ALTER TABLE public.users
    OWNER to postgres;
-- Index: fki_user_to_account

-- DROP INDEX public.fki_user_to_account;

CREATE INDEX fki_user_to_account
    ON public.users USING btree
    (account_id ASC NULLS LAST)
    TABLESPACE pg_default;





-- Table: public.roles

-- DROP TABLE public.roles;

CREATE TABLE public.roles
(
    roles_id integer NOT NULL DEFAULT nextval('roles_roles_id_seq'::regclass),
    roles character varying(100) COLLATE pg_catalog."default" NOT NULL,
    user_id bigint,
    CONSTRAINT roles_id PRIMARY KEY (roles_id),
    CONSTRAINT role_to_user FOREIGN KEY (user_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.roles
    OWNER to postgres;
-- Index: fki_role_to_user

-- DROP INDEX public.fki_role_to_user;

CREATE INDEX fki_role_to_user
    ON public.roles USING btree
    (user_id ASC NULLS LAST)
    TABLESPACE pg_default;



CREATE TABLE public.account
(
    account_id integer NOT NULL DEFAULT nextval('account_account_id_seq'::regclass),
    no_of_users bigint NOT NULL,
    sub_start_date date NOT NULL,
    sub_end_date date NOT NULL,
    account_key character varying(200) COLLATE pg_catalog."default" NOT NULL,
    account_name character varying(100) COLLATE pg_catalog."default",
    updated_time timestamp without time zone,
    updated_user bigint,
    is_active boolean,
    CONSTRAINT account_id PRIMARY KEY (account_id)
)

TABLESPACE pg_default;

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
