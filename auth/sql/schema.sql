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
