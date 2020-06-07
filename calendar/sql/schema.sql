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
    id bigint NOT NULL DEFAULT nextval('appointment_seq'::regclass),
    doctor_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    appointment_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    payment_status boolean,
    is_active boolean,
    is_cancel boolean,
    created_by character varying COLLATE pg_catalog."default",
    created_id bigint,
    CONSTRAINT appointment_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE public.appointment
    OWNER to postgres;

CREATE TABLE public.work_schedule_config
(
    wrk_sched_con_id serial NOT NULL,
    doctor_id bigint NOT NULL,
    day_of_week character varying(50) NOT NULL,
    CONSTRAINT wrk_sched_con_id PRIMARY KEY (wrk_sched_con_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.work_schedule_config
    OWNER to postgres;

CREATE TABLE public.work_schedule
(
    wrk_sched_id serial NOT NULL,
    doctor_id bigint NOT NULL,
    date date NOT NULL,
    CONSTRAINT wrk_sched_id PRIMARY KEY (wrk_sched_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.work_schedule
    OWNER to postgres;

CREATE TABLE public.interval
(
    interval_id serial NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    wrk_sched_con_id bigint NOT NULL,
    CONSTRAINT interval_id PRIMARY KEY (interval_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.interval
    OWNER to postgres;


CREATE TABLE public.interval_days
(
    interval_days_id serial NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    wrk_sched_id bigint NOT NULL,
    CONSTRAINT interval_days_id PRIMARY KEY (interval_days_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.interval_days
    OWNER to postgres;


CREATE TABLE public.payment_details
(
    payment_id serial NOT NULL,
    appointment_id bigint NOT NULL,
    refund bigint NOT NULL,
    CONSTRAINT payment_id PRIMARY KEY (payment_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.payment_details
    OWNER to postgres;

-- Table: public.appointment_cancel_reschedule

-- DROP TABLE public.appointment_cancel_reschedule;

CREATE TABLE public.appointment_cancel_reschedule
(
    appointment_cancel_reschedule_id integer NOT NULL DEFAULT nextval('appointment_cancel_reschedule_appointment_cancel_reschedule_seq'::regclass),
    cancel_on date NOT NULL,
    cancel_by bigint NOT NULL,
    cancel_payment_status character varying(100) COLLATE pg_catalog."default" NOT NULL,
    cancel_by_id bigint NOT NULL,
    reschedule boolean NOT NULL,
    reschedule_appointment_id bigint NOT NULL,
    appointment_id bigint NOT NULL,
    CONSTRAINT appointment_cancel_reschedule_pkey PRIMARY KEY (appointment_cancel_reschedule_id),
    CONSTRAINT can_resch_to_app_id FOREIGN KEY (appointment_id)
        REFERENCES public.appointment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.appointment_cancel_reschedule
    OWNER to postgres;
-- Index: fki_can_resch_to_app_id

-- DROP INDEX public.fki_can_resch_to_app_id;

CREATE INDEX fki_can_resch_to_app_id
    ON public.appointment_cancel_reschedule USING btree
    (appointment_id ASC NULLS LAST)
    TABLESPACE pg_default;


ALTER TABLE public.payment_details
    ADD CONSTRAINT payment_to_app_id FOREIGN KEY (appointment_id)
    REFERENCES public.appointment (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX fki_payment_to_app_id
    ON public.payment_details(appointment_id);


ALTER TABLE public.interval_days
    ADD CONSTRAINT int_days_to_wrk_sched_id FOREIGN KEY (wrk_sched_id)
    REFERENCES public.work_schedule (wrk_sched_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX fki_int_days_to_wrk_sched_id
    ON public.interval_days(wrk_sched_id);

ALTER TABLE public.interval
    ADD CONSTRAINT interval_to_wrk_sched_config_id FOREIGN KEY (wrk_sched_con_id)
    REFERENCES public.work_schedule_config (wrk_sched_con_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX fki_interval_to_wrk_sched_config_id
    ON public.interval(wrk_sched_con_id);



-- Table: public.account_details

-- DROP TABLE public.account_details;

CREATE TABLE public.account_details
(
    account_key character varying(200) COLLATE pg_catalog."default" NOT NULL,
    hospital_name character varying(200) COLLATE pg_catalog."default" NOT NULL,
    street1 character varying(100) COLLATE pg_catalog."default",
    street2 character varying(100) COLLATE pg_catalog."default",
    city character varying(100) COLLATE pg_catalog."default",
    state character varying COLLATE pg_catalog."default" NOT NULL,
    pincode character varying(100) COLLATE pg_catalog."default" NOT NULL,
    phone bigint NOT NULL,
    support_email character varying(100) COLLATE pg_catalog."default",
    account_details_id integer NOT NULL DEFAULT nextval('account_details_account_details_id_seq'::regclass),
    CONSTRAINT account_details_pkey PRIMARY KEY (account_details_id),
    CONSTRAINT account_key_unique UNIQUE (account_key)
)

TABLESPACE pg_default;

ALTER TABLE public.account_details
    OWNER to postgres;


-- Table: public.appointment_doc_config

-- DROP TABLE public.appointment_doc_config;

CREATE TABLE public.appointment_doc_config
(
    appointment_doc_config_id integer NOT NULL DEFAULT nextval('appointment_doc_config_appointment_doc_config_id_seq'::regclass),
    appointment_id bigint NOT NULL,
    consultation_cost real NOT NULL,
    is_preconsultation_allowed boolean,
    pre_consultation_hours integer,
    pre_consultation_mins integer,
    is_patient_cancellation_allowed boolean,
    cancellation_days character varying COLLATE pg_catalog."default",
    cancellation_hours integer,
    cancellation_mins integer,
    is_patient_reschedule_allowed boolean,
    reschedule_days character varying COLLATE pg_catalog."default",
    reschedule_hours integer,
    reschedule_mins integer,
    auto_cancel_days character varying(100) COLLATE pg_catalog."default",
    auto_cancel_hours integer,
    auto_cancel_mins integer,
    CONSTRAINT appointment_doc_config_id PRIMARY KEY (appointment_doc_config_id),
    CONSTRAINT app_doc_con_to_app_id FOREIGN KEY (appointment_id)
        REFERENCES public.appointment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.appointment_doc_config
    OWNER to postgres;
-- Index: fki_app_doc_con_to_app_id

-- DROP INDEX public.fki_app_doc_con_to_app_id;

CREATE INDEX fki_app_doc_con_to_app_id
    ON public.appointment_doc_config USING btree
    (appointment_id ASC NULLS LAST)
    TABLESPACE pg_default;



-- Table: public.doc_config_can_resch

-- DROP TABLE public.doc_config_can_resch;

CREATE TABLE public.doc_config_can_resch
(
    doc_config_can_resch_id integer NOT NULL DEFAULT nextval('doc_config_can_resch_doc_config_can_resch_id_seq'::regclass),
    doc_key character varying(200) COLLATE pg_catalog."default" NOT NULL,
    is_patient_cancellation_allowed boolean,
    cancellation_days character varying(100) COLLATE pg_catalog."default",
    cancellation_hours integer,
    cancellation_mins integer,
    is_patient_resch_allowed boolean,
    reschedule_days character varying(100) COLLATE pg_catalog."default",
    reschedule_hours integer,
    reschedule_mins integer,
    auto_cancel_days character varying(100) COLLATE pg_catalog."default",
    auto_cancel_hours integer,
    auto_cancel_mins integer,
    is_active boolean,
    created_on date,
    modified_on date,
    CONSTRAINT doc_config_can_resch_pkey PRIMARY KEY (doc_config_can_resch_id)
)

TABLESPACE pg_default;

ALTER TABLE public.doc_config_can_resch
    OWNER to postgres;


-- Table: public.doc_config_schedule

-- DROP TABLE public.doc_config_schedule;

CREATE TABLE public.doc_config_schedule
(
    doc_config_schedule_id integer NOT NULL DEFAULT nextval('work_schedule_config_wrk_sched_con_id_seq'::regclass),
    doctor_id bigint NOT NULL,
    day_of_week character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT doc_config_schedule_id PRIMARY KEY (doc_config_schedule_id)
)

TABLESPACE pg_default;

ALTER TABLE public.doc_config_schedule
    OWNER to postgres;

-- Table: public.doc_config_schedule_interval

-- DROP TABLE public.doc_config_schedule_interval;

CREATE TABLE public.doc_config_schedule_interval
(
    id integer NOT NULL DEFAULT nextval('interval_interval_id_seq'::regclass),
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    wrk_sched_con_id bigint NOT NULL,
    CONSTRAINT interval_id PRIMARY KEY (id),
    CONSTRAINT interval_to_wrk_sched_config_id FOREIGN KEY (wrk_sched_con_id)
        REFERENCES public.doc_config_schedule (doc_config_schedule_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.doc_config_schedule_interval
    OWNER to postgres;
-- Index: fki_interval_to_wrk_sched_con_id

-- DROP INDEX public.fki_interval_to_wrk_sched_con_id;

CREATE INDEX fki_interval_to_wrk_sched_con_id
    ON public.doc_config_schedule_interval USING btree
    (wrk_sched_con_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fki_interval_to_wrk_sched_config_id

-- DROP INDEX public.fki_interval_to_wrk_sched_config_id;

CREATE INDEX fki_interval_to_wrk_sched_config_id
    ON public.doc_config_schedule_interval USING btree
    (wrk_sched_con_id ASC NULLS LAST)
    TABLESPACE pg_default;


-- Table: public.doctor

-- DROP TABLE public.doctor;

CREATE TABLE public.doctor
(
    doctor_id integer NOT NULL DEFAULT nextval('doctor_details_doctor_id_seq'::regclass),
    doctor_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    account_key character varying(200) COLLATE pg_catalog."default" NOT NULL,
    doctor_key character varying(200) COLLATE pg_catalog."default" NOT NULL,
    experience bigint NOT NULL,
    speciality character varying(200) COLLATE pg_catalog."default" NOT NULL,
    qualiication character varying(500) COLLATE pg_catalog."default",
    photo character varying(500) COLLATE pg_catalog."default",
    "number" bigint,
    signature character varying(500) COLLATE pg_catalog."default",
    CONSTRAINT doctor_id PRIMARY KEY (doctor_id),
    CONSTRAINT doctor_key_unique UNIQUE (doctor_key),
    CONSTRAINT doctor_to_account FOREIGN KEY (account_key)
        REFERENCES public.account_details (account_key) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.doctor
    OWNER to postgres;
-- Index: fki_doctor_to_account

-- DROP INDEX public.fki_doctor_to_account;

CREATE INDEX fki_doctor_to_account
    ON public.doctor USING btree
    (account_key COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;




-- Table: public.doctor_config_preconsultation

-- DROP TABLE public.doctor_config_preconsultation;

CREATE TABLE public.doctor_config_preconsultation
(
    doctor_config_id integer NOT NULL DEFAULT nextval('doctor_config_preconsultation_doctor_config_id_seq'::regclass),
    doctor_key character varying COLLATE pg_catalog."default" NOT NULL,
    consultation_cost bigint,
    is_preconsultation_allowed boolean,
    preconsultation_hours integer,
    prconsultation_minutes integer,
    is_active boolean,
    created_on date,
    modified_on date,
    CONSTRAINT doctor_config_preconsultation_pkey PRIMARY KEY (doctor_config_id),
    CONSTRAINT doc_config_to_doc_key FOREIGN KEY (doctor_key)
        REFERENCES public.doctor (doctor_key) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.doctor_config_preconsultation
    OWNER to postgres;
-- Index: fki_doc_config_to_doc_key

-- DROP INDEX public.fki_doc_config_to_doc_key;

CREATE INDEX fki_doc_config_to_doc_key
    ON public.doctor_config_preconsultation USING btree
    (doctor_key COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;




-- Table: public.interval_days

-- DROP TABLE public.interval_days;

CREATE TABLE public.interval_days
(
    interval_days_id integer NOT NULL DEFAULT nextval('interval_days_interval_days_id_seq'::regclass),
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    wrk_sched_id bigint NOT NULL,
    CONSTRAINT interval_days_id PRIMARY KEY (interval_days_id),
    CONSTRAINT int_days_to_wrk_sched_id FOREIGN KEY (wrk_sched_id)
        REFERENCES public.work_schedule (wrk_sched_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.interval_days
    OWNER to postgres;
-- Index: fki_int_days_to_wrk_sched_id

-- DROP INDEX public.fki_int_days_to_wrk_sched_id;

CREATE INDEX fki_int_days_to_wrk_sched_id
    ON public.interval_days USING btree
    (wrk_sched_id ASC NULLS LAST)
    TABLESPACE pg_default;



-- Table: public.payment_details

-- DROP TABLE public.payment_details;

CREATE TABLE public.payment_details
(
    payment_id integer NOT NULL DEFAULT nextval('payment_details_payment_id_seq'::regclass),
    appointment_id bigint NOT NULL,
    refund bigint NOT NULL,
    is_paid boolean,
    CONSTRAINT payment_id PRIMARY KEY (payment_id),
    CONSTRAINT payment_to_app_id FOREIGN KEY (appointment_id)
        REFERENCES public.appointment (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.payment_details
    OWNER to postgres;
-- Index: fki_payment_to_app_id

-- DROP INDEX public.fki_payment_to_app_id;

CREATE INDEX fki_payment_to_app_id
    ON public.payment_details USING btree
    (appointment_id ASC NULLS LAST)
    TABLESPACE pg_default;



-- Table: public.work_schedule

-- DROP TABLE public.work_schedule;

CREATE TABLE public.work_schedule
(
    wrk_sched_id integer NOT NULL DEFAULT nextval('work_schedule_wrk_sched_id_seq'::regclass),
    doctor_id bigint NOT NULL,
    date date NOT NULL,
    CONSTRAINT wrk_sched_id PRIMARY KEY (wrk_sched_id)
)

TABLESPACE pg_default;

ALTER TABLE public.work_schedule
    OWNER to postgres;