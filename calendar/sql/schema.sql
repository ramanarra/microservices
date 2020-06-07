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

ALTER TABLE public.appointment
    ADD COLUMN payment_status boolean;

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

CREATE TABLE public.appointment_cancel_reschedule
(
    appointment_cancel_reschedule_id serial NOT NULL,
    cancel_on date NOT NULL,
    cancel_by bigint NOT NULL,
    cancel_payment_status character varying(100) NOT NULL,
    cancel_by_id bigint NOT NULL,
    reschedule boolean NOT NULL,
    reschedule_appointment_id bigint NOT NULL,
    appointment_id bigint NOT NULL,
    PRIMARY KEY (appointment_cancel_reschedule_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.appointment_cancel_reschedule
    OWNER to postgres;


ALTER TABLE public.appointment_cancel_reschedule
    ADD CONSTRAINT can_resch_to_app_id FOREIGN KEY (appointment_id)
    REFERENCES public.appointment (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX fki_can_resch_to_app_id
    ON public.appointment_cancel_reschedule(appointment_id);


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