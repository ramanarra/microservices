CREATE SEQUENCE public.appointment_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.appointment_seq
    OWNER TO postgres;


CREATE TABLE public.appointment
(
    id bigint NOT NULL,
    doctor_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    appointment_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    CONSTRAINT appointment_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.appointment
    OWNER to postgres;