--
-- PostgreSQL database dump
--

-- Dumped from database version 11.8
-- Dumped by pg_dump version 13.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: consultations; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.consultations AS ENUM (
    'online',
    'inHospital'
);


ALTER TYPE public.consultations OWNER TO postgres;

--
-- Name: live_statuses; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.live_statuses AS ENUM (
    'offline',
    'online',
    'videoSessionReady',
    'inSession'
);


ALTER TYPE public.live_statuses OWNER TO postgres;

--
-- Name: overbookingtype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.overbookingtype AS ENUM (
    'Per Hour',
    'Per day'
);


ALTER TYPE public.overbookingtype OWNER TO postgres;

--
-- Name: payment_statuses; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_statuses AS ENUM (
    'notPaid',
    'partiallyPaid',
    'fullyPaid',
    'refunded'
);


ALTER TYPE public.payment_statuses OWNER TO postgres;

--
-- Name: payments; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payments AS ENUM (
    'onlineCollection',
    'directPayment',
    'notRequired'
);


ALTER TYPE public.payments OWNER TO postgres;

--
-- Name: preconsultations; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.preconsultations AS ENUM (
    'on',
    'off'
);


ALTER TYPE public.preconsultations OWNER TO postgres;

--
-- Name: statuses; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.statuses AS ENUM (
    'completed',
    'paused',
    'notCompleted'
);


ALTER TYPE public.statuses OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: account_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_details (
    account_key character varying(200) NOT NULL,
    hospital_name character varying(200) NOT NULL,
    street1 character varying(100),
    state character varying,
    pincode character varying(100) NOT NULL,
    phone bigint NOT NULL,
    "supportEmail" character varying(100),
    account_details_id integer NOT NULL,
    hospital_photo character varying(500),
    country character varying(100),
    landmark character varying(100),
    city character varying(100),
    "cityState" character varying
);


ALTER TABLE public.account_details OWNER TO postgres;

--
-- Name: account_details_account_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_details_account_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_details_account_details_id_seq OWNER TO postgres;

--
-- Name: account_details_account_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_details_account_details_id_seq OWNED BY public.account_details.account_details_id;


--
-- Name: appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment (
    id integer NOT NULL,
    "doctorId" bigint NOT NULL,
    patient_id bigint NOT NULL,
    appointment_date date NOT NULL,
    "startTime" time without time zone NOT NULL,
    "endTime" time without time zone NOT NULL,
    payment_status boolean,
    is_active boolean,
    is_cancel boolean DEFAULT false,
    created_by character varying,
    created_id bigint,
    cancelled_by character varying(100),
    cancelled_id bigint,
    "slotTiming" bigint,
    paymentoption public.payments DEFAULT 'directPayment'::public.payments,
    consultationmode public.consultations DEFAULT 'online'::public.consultations,
    status public.statuses DEFAULT 'notCompleted'::public.statuses,
    "createdTime" timestamp without time zone,
    "hasConsultation" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- Name: COLUMN appointment."hasConsultation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.appointment."hasConsultation" IS 'true means consultation started';


--
-- Name: appointment_cancel_reschedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment_cancel_reschedule (
    appointment_cancel_reschedule_id integer NOT NULL,
    cancel_on date NOT NULL,
    cancel_by bigint NOT NULL,
    cancel_payment_status character varying(100) NOT NULL,
    cancel_by_id bigint NOT NULL,
    reschedule boolean NOT NULL,
    reschedule_appointment_id bigint NOT NULL,
    appointment_id bigint NOT NULL
);


ALTER TABLE public.appointment_cancel_reschedule OWNER TO postgres;

--
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq OWNER TO postgres;

--
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq OWNED BY public.appointment_cancel_reschedule.appointment_cancel_reschedule_id;


--
-- Name: appointment_doc_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment_doc_config (
    appointment_doc_config_id integer NOT NULL,
    appointment_id bigint NOT NULL,
    consultation_cost real NOT NULL,
    is_preconsultation_allowed boolean,
    pre_consultation_hours integer,
    pre_consultation_mins integer,
    is_patient_cancellation_allowed boolean,
    cancellation_days character varying,
    cancellation_hours integer,
    cancellation_mins integer,
    is_patient_reschedule_allowed boolean,
    reschedule_days character varying,
    reschedule_hours integer,
    reschedule_mins integer,
    auto_cancel_days character varying(100),
    auto_cancel_hours integer,
    auto_cancel_mins integer
);


ALTER TABLE public.appointment_doc_config OWNER TO postgres;

--
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_doc_config_appointment_doc_config_id_seq OWNER TO postgres;

--
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq OWNED BY public.appointment_doc_config.appointment_doc_config_id;


--
-- Name: appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_id_seq OWNER TO postgres;

--
-- Name: appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_id_seq OWNED BY public.appointment.id;


--
-- Name: appointment_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_seq OWNER TO postgres;

--
-- Name: communication_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.communication_type (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.communication_type OWNER TO postgres;

--
-- Name: communication_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.communication_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communication_type_id_seq OWNER TO postgres;

--
-- Name: communication_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.communication_type_id_seq OWNED BY public.communication_type.id;


--
-- Name: doc_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doc_config (
    id integer NOT NULL,
    doctor_key character varying,
    consultation_cost character varying DEFAULT 200,
    is_pre_consultation_allowed boolean DEFAULT true,
    "pre-consultation-hours" character varying DEFAULT 2,
    "pre-consultation-mins" character varying,
    is_patient_cancellation_allowed boolean DEFAULT true,
    cancellation_days character varying DEFAULT 5,
    cancellation_hours character varying DEFAULT 2,
    cancellation_mins character varying DEFAULT 30,
    is_patient_reschedule_allowed boolean DEFAULT true,
    reschedule_days character varying DEFAULT 6,
    reschedule_hours character varying DEFAULT 8,
    reschedule_mins character varying DEFAULT 40,
    auto_cancel_days character varying DEFAULT 5,
    auto_cancel_hours character varying DEFAULT 3,
    auto_cancel_mins character varying DEFAULT 15,
    "isActive" boolean DEFAULT false,
    created_on time with time zone,
    modified_on time with time zone,
    "overBookingCount" bigint,
    "overBookingEnabled" boolean DEFAULT false,
    "overBookingType" public.overbookingtype,
    "consultationSessionTimings" integer
);


ALTER TABLE public.doc_config OWNER TO postgres;

--
-- Name: doctor_config_can_resch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_config_can_resch (
    doc_config_can_resch_id integer NOT NULL,
    doc_key character varying(200) NOT NULL,
    is_patient_cancellation_allowed boolean,
    cancellation_days character varying(100),
    cancellation_hours integer,
    cancellation_mins integer,
    is_patient_resch_allowed boolean,
    reschedule_days character varying(100),
    reschedule_hours integer,
    reschedule_mins integer,
    auto_cancel_days character varying(100),
    auto_cancel_hours integer,
    auto_cancel_mins integer,
    is_active boolean,
    created_on date,
    modified_on date
);


ALTER TABLE public.doctor_config_can_resch OWNER TO postgres;

--
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doc_config_can_resch_doc_config_can_resch_id_seq OWNER TO postgres;

--
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;


--
-- Name: doc_config_schedule_day; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doc_config_schedule_day (
    doctor_id bigint NOT NULL,
    "dayOfWeek" character varying(50) NOT NULL,
    id integer NOT NULL,
    doctor_key character varying
);


ALTER TABLE public.doc_config_schedule_day OWNER TO postgres;

--
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doc_config_schedule_day_doc_config_schedule_day_id_seq OWNER TO postgres;

--
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq OWNED BY public.doc_config_schedule_day.id;


--
-- Name: doc_config_schedule_interval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doc_config_schedule_interval (
    "startTime" time without time zone NOT NULL,
    "endTime" time without time zone NOT NULL,
    "docConfigScheduleDayId" bigint NOT NULL,
    id integer NOT NULL,
    doctorkey character varying
);


ALTER TABLE public.doc_config_schedule_interval OWNER TO postgres;

--
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq OWNER TO postgres;

--
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq OWNED BY public.doc_config_schedule_interval.id;


--
-- Name: docconfigid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.docconfigid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.docconfigid_seq OWNER TO postgres;

--
-- Name: docconfigid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.docconfigid_seq OWNED BY public.doc_config.id;


--
-- Name: doctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor (
    "doctorId" integer NOT NULL,
    doctor_name character varying(100) NOT NULL,
    account_key character varying(200) NOT NULL,
    doctor_key character varying(200) NOT NULL,
    experience bigint,
    speciality character varying(200),
    qualification character varying(500),
    photo character varying(500),
    number bigint,
    signature character varying(500),
    first_name character varying(100),
    last_name character varying(100),
    registration_number character varying(200),
    email character varying(200),
    live_status public.live_statuses DEFAULT 'offline'::public.live_statuses,
    last_active timestamp without time zone
);


ALTER TABLE public.doctor OWNER TO postgres;

--
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_config_can_resch_doc_config_can_resch_id_seq OWNER TO postgres;

--
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;


--
-- Name: doctor_config_pre_consultation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_config_pre_consultation (
    doctor_config_id integer NOT NULL,
    doctor_key character varying NOT NULL,
    consultation_cost bigint,
    is_preconsultation_allowed boolean,
    preconsultation_hours integer,
    preconsultation_minutes integer,
    is_active boolean,
    created_on date,
    modified_on date
);


ALTER TABLE public.doctor_config_pre_consultation OWNER TO postgres;

--
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_config_pre_consultation_doctor_config_id_seq OWNER TO postgres;

--
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;


--
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_config_preconsultation_doctor_config_id_seq OWNER TO postgres;

--
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;


--
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_details_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_details_doctor_id_seq OWNER TO postgres;

--
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_details_doctor_id_seq OWNED BY public.doctor."doctorId";


--
-- Name: doctor_doctor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_doctor_id_seq OWNER TO postgres;

--
-- Name: doctor_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_doctor_id_seq OWNED BY public.doctor."doctorId";


--
-- Name: interval_days; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interval_days (
    interval_days_id integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    wrk_sched_id bigint NOT NULL
);


ALTER TABLE public.interval_days OWNER TO postgres;

--
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.interval_days_interval_days_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.interval_days_interval_days_id_seq OWNER TO postgres;

--
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interval_days_interval_days_id_seq OWNED BY public.interval_days.interval_days_id;


--
-- Name: medicine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicine (
    id integer NOT NULL,
    prescription_id bigint NOT NULL,
    name_of_medicine character varying,
    frequency_of_each_dose character varying,
    count_of_medicine_for_each_dose bigint,
    type_of_medicine character varying,
    dose_of_medicine character varying,
    count_of_days character varying
);


ALTER TABLE public.medicine OWNER TO postgres;

--
-- Name: medicine_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medicine_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicine_id_seq OWNER TO postgres;

--
-- Name: medicine_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medicine_id_seq OWNED BY public.medicine.id;


--
-- Name: message_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_metadata (
    id integer NOT NULL,
    message_type_id bigint,
    communication_type_id bigint,
    message_template_id bigint
);


ALTER TABLE public.message_metadata OWNER TO postgres;

--
-- Name: message_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_metadata_id_seq OWNER TO postgres;

--
-- Name: message_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_metadata_id_seq OWNED BY public.message_metadata.id;


--
-- Name: message_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_template (
    id integer NOT NULL,
    sender character varying(200),
    subject character varying(200),
    body character varying(5000)
);


ALTER TABLE public.message_template OWNER TO postgres;

--
-- Name: message_template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_template_id_seq OWNER TO postgres;

--
-- Name: message_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_template_id_seq OWNED BY public.message_template.id;


--
-- Name: message_template_placeholders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_template_placeholders (
    id integer NOT NULL,
    message_template_id bigint,
    placeholder_name character varying(200),
    message_type_id bigint
);


ALTER TABLE public.message_template_placeholders OWNER TO postgres;

--
-- Name: message_template_placeholders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_template_placeholders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_template_placeholders_id_seq OWNER TO postgres;

--
-- Name: message_template_placeholders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_template_placeholders_id_seq OWNED BY public.message_template_placeholders.id;


--
-- Name: message_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_type (
    id integer NOT NULL,
    name character varying(200)
);


ALTER TABLE public.message_type OWNER TO postgres;

--
-- Name: message_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_type_id_seq OWNER TO postgres;

--
-- Name: message_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_type_id_seq OWNED BY public.message_type.id;


--
-- Name: openvidu_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.openvidu_session (
    openvidu_session_id integer NOT NULL,
    doctor_key character varying(100) NOT NULL,
    session_name character varying(100) NOT NULL,
    session_id character varying(100) NOT NULL
);


ALTER TABLE public.openvidu_session OWNER TO postgres;

--
-- Name: openvidu_session_openvidu_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.openvidu_session_openvidu_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.openvidu_session_openvidu_session_id_seq OWNER TO postgres;

--
-- Name: openvidu_session_openvidu_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.openvidu_session_openvidu_session_id_seq OWNED BY public.openvidu_session.openvidu_session_id;


--
-- Name: openvidu_session_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.openvidu_session_token (
    openvidu_session_token_id integer NOT NULL,
    openvidu_session_id bigint NOT NULL,
    token text NOT NULL,
    doctor_id bigint,
    patient_id bigint
);


ALTER TABLE public.openvidu_session_token OWNER TO postgres;

--
-- Name: openvidu_session_token_openvidu_session_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.openvidu_session_token_openvidu_session_token_id_seq OWNER TO postgres;

--
-- Name: openvidu_session_token_openvidu_session_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq OWNED BY public.openvidu_session_token.openvidu_session_token_id;


--
-- Name: patient_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_details (
    id integer NOT NULL,
    name character varying(100),
    landmark character varying(100),
    country character varying(100),
    registration_number character varying(200),
    address character varying(400),
    state character varying(100),
    pincode character varying(100),
    email character varying(100),
    photo character varying(600),
    phone character varying(100),
    patient_id bigint,
    "firstName" character varying(100),
    "lastName" character varying(100),
    "dateOfBirth" character varying(100),
    "alternateContact" character varying(100),
    age bigint,
    live_status public.live_statuses DEFAULT 'online'::public.live_statuses,
    last_active timestamp without time zone
);


ALTER TABLE public.patient_details OWNER TO postgres;

--
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_details_patient_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patient_details_patient_details_id_seq OWNER TO postgres;

--
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_details_patient_details_id_seq OWNED BY public.patient_details.id;


--
-- Name: patient_report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_report (
    id integer NOT NULL,
    patient_id bigint NOT NULL,
    appointment_id bigint,
    file_name character varying NOT NULL,
    file_type character varying NOT NULL,
    report_url character varying NOT NULL,
    comments character varying,
    report_date date
);


ALTER TABLE public.patient_report OWNER TO postgres;

--
-- Name: patient_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patient_report_id_seq OWNER TO postgres;

--
-- Name: patient_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_report_id_seq OWNED BY public.patient_report.id;


--
-- Name: payment_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_details (
    id integer NOT NULL,
    appointment_id bigint,
    order_id character varying(200),
    receipt_id character varying(200),
    amount character varying(100),
    payment_status public.payment_statuses DEFAULT 'notPaid'::public.payment_statuses
);


ALTER TABLE public.payment_details OWNER TO postgres;

--
-- Name: payment_details_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_details_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_details_payment_id_seq OWNER TO postgres;

--
-- Name: payment_details_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_details_payment_id_seq OWNED BY public.payment_details.id;


--
-- Name: prescription; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prescription (
    id integer NOT NULL,
    appointment_id bigint NOT NULL,
    appointment_date date,
    hospital_logo character varying(500),
    hospital_name character varying(100),
    doctor_name character varying(200),
    doctor_signature character varying(500),
    patient_name character varying(200),
    prescription_url character varying
);


ALTER TABLE public.prescription OWNER TO postgres;

--
-- Name: prescription_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prescription_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prescription_id_seq OWNER TO postgres;

--
-- Name: prescription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prescription_id_seq OWNED BY public.prescription.id;


--
-- Name: tabesample; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tabesample (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    place character varying(100)
);


ALTER TABLE public.tabesample OWNER TO postgres;

--
-- Name: tabesample_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tabesample_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tabesample_id_seq OWNER TO postgres;

--
-- Name: tabesample_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tabesample_id_seq OWNED BY public.tabesample.id;


--
-- Name: work_schedule_day; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_schedule_day (
    id integer NOT NULL,
    doctor_id bigint NOT NULL,
    date date NOT NULL,
    is_active boolean,
    doctor_key character varying(100)
);


ALTER TABLE public.work_schedule_day OWNER TO postgres;

--
-- Name: work_schedule_day_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_schedule_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.work_schedule_day_id_seq OWNER TO postgres;

--
-- Name: work_schedule_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.work_schedule_day_id_seq OWNED BY public.work_schedule_day.id;


--
-- Name: work_schedule_interval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_schedule_interval (
    id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    work_schedule_day_id bigint,
    is_active boolean
);


ALTER TABLE public.work_schedule_interval OWNER TO postgres;

--
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_schedule_interval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.work_schedule_interval_id_seq OWNER TO postgres;

--
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.work_schedule_interval_id_seq OWNED BY public.work_schedule_interval.id;


--
-- Name: account_details account_details_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details ALTER COLUMN account_details_id SET DEFAULT nextval('public.account_details_account_details_id_seq'::regclass);


--
-- Name: appointment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment ALTER COLUMN id SET DEFAULT nextval('public.appointment_id_seq'::regclass);


--
-- Name: appointment_cancel_reschedule appointment_cancel_reschedule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule ALTER COLUMN appointment_cancel_reschedule_id SET DEFAULT nextval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq'::regclass);


--
-- Name: appointment_doc_config appointment_doc_config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config ALTER COLUMN appointment_doc_config_id SET DEFAULT nextval('public.appointment_doc_config_appointment_doc_config_id_seq'::regclass);


--
-- Name: communication_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.communication_type ALTER COLUMN id SET DEFAULT nextval('public.communication_type_id_seq'::regclass);


--
-- Name: doc_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config ALTER COLUMN id SET DEFAULT nextval('public.docconfigid_seq'::regclass);


--
-- Name: doc_config_schedule_day id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq'::regclass);


--
-- Name: doc_config_schedule_interval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq'::regclass);


--
-- Name: doctor doctorId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor ALTER COLUMN "doctorId" SET DEFAULT nextval('public.doctor_details_doctor_id_seq'::regclass);


--
-- Name: doctor_config_can_resch doc_config_can_resch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_can_resch ALTER COLUMN doc_config_can_resch_id SET DEFAULT nextval('public.doc_config_can_resch_doc_config_can_resch_id_seq'::regclass);


--
-- Name: doctor_config_pre_consultation doctor_config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_pre_consultation ALTER COLUMN doctor_config_id SET DEFAULT nextval('public.doctor_config_preconsultation_doctor_config_id_seq'::regclass);


--
-- Name: interval_days interval_days_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interval_days ALTER COLUMN interval_days_id SET DEFAULT nextval('public.interval_days_interval_days_id_seq'::regclass);


--
-- Name: medicine id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine ALTER COLUMN id SET DEFAULT nextval('public.medicine_id_seq'::regclass);


--
-- Name: message_metadata id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata ALTER COLUMN id SET DEFAULT nextval('public.message_metadata_id_seq'::regclass);


--
-- Name: message_template id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template ALTER COLUMN id SET DEFAULT nextval('public.message_template_id_seq'::regclass);


--
-- Name: message_template_placeholders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template_placeholders ALTER COLUMN id SET DEFAULT nextval('public.message_template_placeholders_id_seq'::regclass);


--
-- Name: message_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_type ALTER COLUMN id SET DEFAULT nextval('public.message_type_id_seq'::regclass);


--
-- Name: openvidu_session openvidu_session_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session ALTER COLUMN openvidu_session_id SET DEFAULT nextval('public.openvidu_session_openvidu_session_id_seq'::regclass);


--
-- Name: openvidu_session_token openvidu_session_token_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session_token ALTER COLUMN openvidu_session_token_id SET DEFAULT nextval('public.openvidu_session_token_openvidu_session_token_id_seq'::regclass);


--
-- Name: patient_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_details ALTER COLUMN id SET DEFAULT nextval('public.patient_details_patient_details_id_seq'::regclass);


--
-- Name: patient_report id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_report ALTER COLUMN id SET DEFAULT nextval('public.patient_report_id_seq'::regclass);


--
-- Name: payment_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details ALTER COLUMN id SET DEFAULT nextval('public.payment_details_payment_id_seq'::regclass);


--
-- Name: prescription id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescription ALTER COLUMN id SET DEFAULT nextval('public.prescription_id_seq'::regclass);


--
-- Name: tabesample id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabesample ALTER COLUMN id SET DEFAULT nextval('public.tabesample_id_seq'::regclass);


--
-- Name: work_schedule_day id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_day_id_seq'::regclass);


--
-- Name: work_schedule_interval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_interval_id_seq'::regclass);


--
-- Data for Name: account_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_details (account_key, hospital_name, street1, state, pincode, phone, "supportEmail", account_details_id, hospital_photo, country, landmark, city, "cityState") FROM stdin;
Acc_2	Dr Kamakshi Memorial Hospital	Kasturba Nagar	Tamil Nadu	600020	9623456257	kamashimemorialhospital@gmail.com	2	https://images1-fabric.practo.com/practices/1137076/dr-kamakshi-memorial-hospital-chennai-597acd4b1a0f5.jpg	India	Kasturba Nagar	\N	\N
Acc_3	Dr Mehtas Hospital	Nichols road	Tamil Nadu	600031	9623456258	drmehtashospital@gmail.com	3	\N	India	Nichols Road	\N	\N
Acc_4	HCG Cancer Centre	Luz church	Tamil Nadu	600004	9623456259	hcgcancercentre@gmail.com	4	\N	India	Luz church	\N	\N
Acc_5	Kauvery Hospital	TTK road	Tamil Nadu	600018	9623456270	kauveryhospital@gmail.com	5	\N	India	TTK road	\N	\N
Acc_6	Frontier Lifeline Hospital	Ambattur Industrial Estate Road	Tamil Nadu	600101	9623656270	frontierlifeline@gmail.com	6	\N	India	Industrial Estate	\N	\N
Acc_1	Apollo Hospitals	porur	Tamil Nadu	600116	962345626	test@apollo.com	1	https://s.ndtvimg.com//images/entities/300/apollo-hospital-chennai_636408444078079763_108400.jpg?q=50	Indian	Greams Lane4	\N	Chennai, TamilNadu
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointment (id, "doctorId", patient_id, appointment_date, "startTime", "endTime", payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id, "slotTiming", paymentoption, consultationmode, status, "createdTime", "hasConsultation") FROM stdin;
2243	6	85	2021-01-05	11:30:00	11:40:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	paused	2021-01-04 11:22:23.6	f
2284	5	85	2021-01-13	16:00:00	16:15:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	completed	2021-01-13 10:17:59.128	f
2301	5	282	2021-01-18	18:55:00	19:10:00	\N	t	f	PATIENT	282	\N	\N	15	directPayment	online	completed	2021-01-18 15:51:30.553	f
2244	6	341	2021-01-04	16:30:00	16:40:00	\N	t	f	PATIENT	341	\N	\N	10	onlineCollection	online	paused	2021-01-04 16:29:55.169	f
2302	5	282	2021-01-18	16:25:00	16:40:00	\N	t	f	PATIENT	282	\N	\N	15	directPayment	online	completed	2021-01-18 16:11:37.551	f
2285	5	85	2021-01-13	16:15:00	16:30:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	completed	2021-01-13 10:46:16.774	f
2245	6	342	2021-01-04	16:40:00	16:50:00	\N	t	f	PATIENT	342	\N	\N	10	onlineCollection	online	paused	2021-01-04 16:33:06.025	f
2286	5	85	2021-01-13	16:45:00	17:00:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	paused	2021-01-13 11:00:03.324	f
2303	5	282	2021-01-18	19:25:00	19:40:00	\N	t	f	PATIENT	282	\N	\N	15	directPayment	online	notCompleted	2021-01-18 16:26:05.859	f
2246	6	343	2021-01-04	17:10:00	17:20:00	\N	t	f	DOCTOR	33	\N	\N	10	directPayment	online	notCompleted	2021-01-04 16:47:39.053	f
2247	6	403	2021-01-04	16:50:00	17:00:00	\N	t	f	DOCTOR	33	\N	\N	10	directPayment	online	notCompleted	2021-01-04 16:48:12.383	f
2287	5	356	2021-01-15	17:00:00	17:15:00	\N	t	f	PATIENT	356	\N	\N	15	onlineCollection	online	notCompleted	2021-01-15 16:55:56.757	f
2304	5	4	2021-01-18	18:10:00	18:25:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	completed	2021-01-18 17:39:00.479	f
2305	6	85	2021-01-18	23:00:00	23:10:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	paused	2021-01-18 20:41:09.465	f
2248	6	85	2021-01-04	17:30:00	17:40:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	completed	2021-01-04 17:30:44.19	f
2288	5	258	2021-01-15	17:45:00	18:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2021-01-15 16:57:42.889	f
362	5	50	2020-08-05	02:15:00	02:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
2249	5	85	2021-01-05	20:55:00	21:10:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2021-01-04 17:47:30.984	f
2289	5	258	2021-01-15	20:00:00	20:15:00	\N	t	f	PATIENT	258	\N	\N	15	onlineCollection	online	paused	2021-01-15 16:59:48.72	f
2306	5	85	2021-01-19	23:40:00	23:55:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	paused	2021-01-19 10:06:55.527	f
2250	6	85	2021-01-04	18:00:00	18:10:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	notCompleted	2021-01-04 17:53:21.528	f
2290	5	356	2021-01-15	19:00:00	19:15:00	\N	t	f	PATIENT	356	\N	\N	15	onlineCollection	online	paused	2021-01-15 17:31:23.285	f
2307	5	85	2021-01-20	22:45:00	23:00:00	\N	t	f	PATIENT	85	\N	\N	15	directPayment	online	paused	2021-01-20 09:51:05.133	f
2251	6	85	2021-01-04	18:20:00	18:30:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	notCompleted	2021-01-04 18:18:23.646	f
2291	5	284	2021-01-16	13:00:00	13:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2021-01-15 23:32:50.108	f
2308	5	358	2021-01-20	19:15:00	19:35:00	\N	f	t	DOCTOR	32	DOCTOR	32	20	directPayment	online	notCompleted	2021-01-20 18:51:23.546	f
2309	5	358	2021-01-20	19:55:00	20:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	20	directPayment	online	notCompleted	2021-01-20 18:51:46.447	f
2252	6	85	2021-01-04	19:00:00	19:10:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	paused	2021-01-04 18:43:12.696	f
2292	5	446	2021-01-16	13:15:00	13:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2021-01-15 23:46:53.22	f
2293	5	352	2021-01-16	13:30:00	13:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2021-01-15 23:47:12.938	f
2253	6	85	2021-01-04	19:40:00	19:50:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	paused	2021-01-04 19:22:36.48	f
2294	6	85	2021-01-16	03:10:00	03:20:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	notCompleted	2021-01-16 00:06:41.135	f
2310	5	312	2021-01-20	19:55:00	20:15:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	\N	2021-01-20 18:52:39.57	f
2311	6	359	2021-01-20	19:10:00	19:20:00	\N	t	f	PATIENT	359	\N	\N	10	onlineCollection	online	completed	2021-01-20 19:05:03.456	f
2254	6	85	2021-01-04	20:20:00	20:30:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	completed	2021-01-04 19:57:33.013	f
2295	5	258	2021-01-16	17:15:00	17:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2021-01-16 16:16:49.989	f
2255	6	85	2021-01-05	16:50:00	17:00:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	\N	2021-01-05 16:20:43.348	f
2312	6	359	2021-01-20	19:20:00	19:30:00	\N	f	t	PATIENT	359	DOCTOR	33	10	onlineCollection	online	notCompleted	2021-01-20 19:12:06.276	f
2296	5	85	2021-01-16	18:00:00	18:15:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	\N	2021-01-16 16:34:29.901	f
2256	6	86	2021-01-05	16:40:00	16:50:00	\N	t	f	DOCTOR	33	\N	\N	10	directPayment	online	notCompleted	2021-01-05 16:22:32.837	f
2297	5	85	2021-01-16	21:30:00	21:45:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	\N	2021-01-16 17:00:23.144	f
2313	6	359	2021-01-20	19:40:00	19:50:00	\N	t	f	DOCTOR	33	\N	\N	10	directPayment	online	paused	2021-01-20 19:12:30.181	f
2257	5	258	2021-01-05	22:55:00	23:10:00	\N	t	f	PATIENT	258	\N	\N	15	onlineCollection	online	notCompleted	2021-01-05 17:07:38.618	f
2298	5	85	2021-01-16	21:15:00	21:30:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	\N	2021-01-16 17:01:55.348	f
2314	5	85	2021-01-21	23:20:00	23:40:00	\N	t	f	PATIENT	85	\N	\N	20	onlineCollection	online	paused	2021-01-21 09:53:35.029	f
2258	5	85	2021-01-05	21:25:00	21:40:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	notCompleted	2021-01-05 21:09:10.771	f
2299	6	85	2021-01-16	22:00:00	22:10:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	paused	2021-01-16 17:15:15.081	f
2315	5	105	2021-01-21	16:20:00	16:40:00	\N	t	f	PATIENT	105	\N	\N	20	directPayment	online	paused	2021-01-21 16:06:58.795	f
2259	6	347	2021-01-06	19:20:00	19:30:00	\N	t	f	PATIENT	347	\N	\N	10	onlineCollection	online	paused	2021-01-06 19:18:59.484	f
2300	5	85	2021-01-18	19:10:00	19:25:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	paused	2021-01-18 10:12:28.205	f
2316	6	85	2021-01-21	22:50:00	23:00:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	paused	2021-01-21 18:02:34.311	f
2317	5	258	2021-01-22	16:20:00	16:40:00	\N	t	f	PATIENT	258	\N	\N	20	onlineCollection	online	completed	2021-01-22 11:45:17.951	f
2260	6	85	2021-01-06	20:00:00	20:10:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	paused	2021-01-06 19:28:24.438	f
540	1	1	2020-08-17	01:19:00	02:04:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-09 15:29:00.59	t
2261	5	140	2021-01-09	13:00:00	13:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2021-01-08 19:43:32.739	f
2318	5	258	2021-01-22	17:00:00	17:20:00	\N	t	f	PATIENT	258	\N	\N	20	onlineCollection	online	completed	2021-01-22 11:53:37.09	f
2262	5	258	2021-01-10	13:00:00	13:15:00	\N	t	f	PATIENT	258	\N	\N	15	onlineCollection	online	notCompleted	2021-01-10 10:59:05.651	f
2319	5	258	2021-01-22	18:00:00	18:20:00	\N	t	f	PATIENT	258	\N	\N	20	onlineCollection	online	paused	2021-01-22 12:18:49.826	f
2263	5	258	2021-01-12	21:55:00	22:10:00	\N	t	f	PATIENT	258	\N	\N	15	onlineCollection	online	completed	2021-01-11 12:35:58.23	f
2320	5	258	2021-01-22	17:20:00	17:40:00	\N	t	f	PATIENT	258	\N	\N	20	onlineCollection	online	completed	2021-01-22 12:22:54.706	f
2264	5	258	2021-01-12	12:15:00	12:30:00	\N	t	f	PATIENT	258	\N	\N	15	onlineCollection	online	completed	2021-01-11 12:38:06.912	f
2321	5	258	2021-01-22	17:40:00	18:00:00	\N	t	f	PATIENT	258	\N	\N	20	onlineCollection	online	completed	2021-01-22 12:30:18.959	f
2265	5	258	2021-01-11	13:55:00	14:10:00	\N	t	f	PATIENT	258	\N	\N	15	onlineCollection	online	paused	2021-01-11 12:42:05.972	f
2322	5	105	2021-01-22	16:40:00	17:00:00	\N	t	f	PATIENT	105	\N	\N	20	directPayment	online	\N	2021-01-22 15:43:59.312	f
2266	5	85	2021-01-11	14:40:00	14:55:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	paused	2021-01-11 13:04:58.491	f
2267	22	351	2021-01-11	18:00:00	18:30:00	\N	t	f	PATIENT	351	\N	\N	30	onlineCollection	online	notCompleted	2021-01-11 15:15:00.747	f
2268	5	351	2021-01-11	15:40:00	15:55:00	\N	t	f	PATIENT	351	\N	\N	15	onlineCollection	online	notCompleted	2021-01-11 15:28:13.76	f
2269	5	85	2021-01-11	17:40:00	17:55:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	paused	2021-01-11 16:15:26.147	f
642	5	151	2020-08-20	12:00:00	12:45:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-18 19:46:00.389	t
2270	5	85	2021-01-12	21:10:00	21:25:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	completed	2021-01-11 22:35:51.957	f
2271	6	85	2021-01-12	20:50:00	21:00:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	\N	2021-01-12 13:21:01.675	f
1631	3	397	2020-09-22	21:30:00	21:45:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	paused	2020-09-22 20:58:59.541	t
2272	5	85	2021-01-12	22:10:00	22:25:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	\N	2021-01-12 15:37:39.821	f
643	5	151	2020-08-21	09:45:00	10:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-18 19:46:18.377	t
2273	5	258	2021-01-12	20:55:00	21:10:00	\N	t	f	PATIENT	258	\N	\N	15	onlineCollection	online	\N	2021-01-12 19:36:23.53	f
2274	5	258	2021-01-12	21:40:00	21:55:00	\N	t	f	PATIENT	258	\N	\N	15	onlineCollection	online	\N	2021-01-12 19:40:25.423	f
2275	5	258	2021-01-12	22:25:00	22:40:00	\N	t	f	PATIENT	258	\N	\N	15	onlineCollection	online	paused	2021-01-12 20:46:47.393	f
1863	5	142	2020-11-26	14:15:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 14:06:18.789	t
2276	22	352	2021-01-13	16:00:00	16:30:00	\N	t	f	PATIENT	352	\N	\N	30	onlineCollection	online	notCompleted	2021-01-13 00:08:22.501	f
1915	5	258	2020-11-27	18:49:00	19:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	paused	2020-11-27 15:01:06.647	t
2277	6	85	2021-01-13	13:45:00	13:55:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	notCompleted	2021-01-13 00:33:58.994	f
1970	6	279	2020-12-01	18:00:00	18:30:00	\N	f	t	PATIENT	279	PATIENT	\N	30	onlineCollection	online	notCompleted	2020-12-01 12:23:43.504	t
2278	5	85	2021-01-14	12:00:00	12:15:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	notCompleted	2021-01-13 00:35:01.197	f
2023	5	86	2020-12-03	19:10:00	19:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	paused	2020-12-03 19:00:39.292	t
2279	1	85	2021-01-13	09:00:00	10:00:00	\N	t	f	PATIENT	85	\N	\N	60	onlineCollection	online	notCompleted	2021-01-13 00:44:13.771	f
2077	5	310	2020-12-08	21:25:00	21:40:00	\N	t	f	PATIENT	310	\N	\N	15	directPayment	online	paused	2020-12-08 21:10:41.513	t
2280	5	85	2021-01-14	12:15:00	12:30:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	notCompleted	2021-01-13 01:06:21.469	f
2169	5	332	2020-12-23	16:00:00	16:15:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	\N	2020-12-23 13:52:06.941	t
2281	45	258	2021-01-16	19:20:00	19:40:00	\N	t	f	PATIENT	258	\N	\N	20	onlineCollection	online	notCompleted	2021-01-13 07:36:47.496	f
114	1	1	2020-07-22	10:00:00	12:00:00	\N	t	f	PATIENT	1	\N	\N	\N	directPayment	online	notCompleted	\N	t
118	5	1	2020-07-24	10:00:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
120	5	3	2020-07-23	11:15:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
116	5	1	2020-07-23	10:00:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
126	5	1	2020-07-25	11:00:00	11:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
135	5	3	2020-07-23	15:15:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
137	5	3	2020-07-23	13:45:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
139	5	2	2020-07-22	12:45:00	13:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
140	5	1	2020-07-23	14:00:00	15:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
142	5	2	2020-07-23	13:00:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
143	5	2	2020-07-23	13:00:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
145	5	3	2020-07-29	14:00:00	15:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
191	5	104	2020-07-28	05:30:00	06:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
151	1	1	2020-07-28	02:00:00	02:30:00	\N	t	f	PATIENT	1	\N	\N	30	directPayment	online	notCompleted	\N	t
122	5	3	2020-07-21	01:10:00	01:25:00	\N	t	f	DOCTOR	32	\N	\N	\N	directPayment	online	notCompleted	\N	t
124	5	3	2020-07-21	02:23:00	02:38:00	\N	t	f	DOCTOR	32	\N	\N	\N	directPayment	online	notCompleted	\N	t
128	5	2	2020-07-21	10:45:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
130	5	3	2020-07-24	14:15:00	15:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
133	5	2	2020-07-23	10:00:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
147	5	1	2020-07-22	10:00:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
149	5	1	2020-07-22	11:00:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
153	5	1	2020-07-28	03:00:00	03:30:00	\N	t	f	PATIENT	1	\N	\N	30	directPayment	online	notCompleted	\N	t
155	5	1	2020-07-28	10:00:00	10:30:00	\N	t	f	PATIENT	1	\N	\N	30	directPayment	online	notCompleted	\N	t
159	5	1	2020-07-28	14:30:00	15:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
163	5	1	2020-07-24	10:30:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
161	5	1	2020-07-29	02:00:00	02:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
171	5	1	2020-07-26	10:00:00	10:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
169	5	2	2020-07-30	10:30:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
173	5	1	2020-07-30	15:00:00	15:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
165	5	1	2020-07-24	11:30:00	12:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
181	5	1	2020-07-30	14:00:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
183	5	101	2020-07-30	02:00:00	02:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
185	5	103	2020-07-28	02:00:00	02:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
187	5	1	2020-07-30	11:30:00	12:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
189	5	1	2020-07-30	13:30:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
175	5	1	2020-07-31	10:00:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
157	5	1	2020-07-28	03:30:00	04:00:00	\N	f	t	PATIENT	1	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
177	5	93	2020-07-29	03:00:00	03:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
193	5	105	2020-07-28	05:30:00	06:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
167	5	1	2020-08-04	02:30:00	03:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
197	5	110	2020-07-31	14:30:00	15:15:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
195	5	112	2020-07-28	13:00:00	13:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
199	5	112	2020-07-28	13:45:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
201	5	1	2020-07-29	10:45:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
203	5	3	2020-07-29	13:45:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
205	5	1	2020-07-28	13:00:00	13:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
207	5	1	2020-07-29	10:45:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	online	notCompleted	\N	t
209	5	1	2020-07-29	12:45:00	13:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	online	notCompleted	\N	t
217	5	122	2020-07-31	10:00:00	10:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
221	5	124	2020-07-28	17:30:00	18:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
219	5	1	2020-07-28	16:00:00	16:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
211	5	60	2020-07-29	02:00:00	02:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
215	5	60	2020-07-30	13:00:00	13:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	inHospital	notCompleted	\N	t
223	5	1	2020-07-30	14:30:00	15:15:00	\N	t	f	DOCTOR	32	\N	\N	45	onlineCollection	online	notCompleted	\N	t
225	5	50	2020-07-28	17:30:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	45	onlineCollection	online	notCompleted	\N	t
213	5	121	2020-07-29	02:45:00	03:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
227	5	1	2020-07-28	17:00:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
229	5	131	2020-07-28	05:00:00	06:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
231	5	64	2020-07-30	11:00:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
232	5	132	2020-07-28	05:00:00	06:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
179	5	61	2020-07-29	11:00:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
115	5	1	2020-07-22	10:00:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
119	5	1	2020-08-12	10:00:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
129	5	2	2020-07-22	12:45:00	13:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
125	5	1	2020-07-23	10:00:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
132	5	1	2020-07-24	10:45:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
127	5	3	2020-07-22	14:15:00	15:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
134	5	3	2020-07-22	14:15:00	15:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
136	5	3	2020-07-30	14:15:00	15:00:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
138	5	3	2020-07-22	14:15:00	15:00:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
141	5	1	2020-07-23	15:00:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
117	5	1	2020-07-24	12:00:00	11:00:00	\N	t	t	DOCTOR	32	\N	\N	\N	directPayment	online	notCompleted	\N	t
150	5	1	2020-07-24	04:00:00	05:00:00	\N	t	f	PATIENT	1	\N	\N	60	directPayment	online	notCompleted	\N	t
121	5	3	2020-07-21	02:53:00	03:07:00	\N	t	f	DOCTOR	32	\N	\N	\N	directPayment	online	notCompleted	\N	t
123	5	3	2020-07-21	01:40:00	01:55:00	\N	t	f	DOCTOR	32	\N	\N	\N	directPayment	online	notCompleted	\N	t
146	5	1	2020-06-12	10:00:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
148	5	1	2020-07-22	10:00:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
158	5	1	2020-07-28	14:00:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
160	5	1	2020-07-28	15:00:00	15:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
162	5	1	2020-07-28	01:00:00	01:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
131	5	1	2020-07-24	10:00:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
172	5	2	2020-07-25	15:00:00	15:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
170	5	1	2020-07-30	11:30:00	12:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
111	5	1	2020-07-20	09:00:00	09:30:00	\N	t	f	DOCTOR	32	\N	\N	\N	directPayment	online	notCompleted	\N	t
174	5	1	2020-07-30	10:00:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
152	5	1	2020-07-28	02:00:00	02:30:00	\N	f	t	PATIENT	1	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
164	5	1	2020-07-24	11:00:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
180	5	1	2020-07-27	10:30:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
156	5	1	2020-07-28	10:30:00	11:00:00	\N	f	t	PATIENT	1	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
154	5	1	2020-07-28	02:30:00	03:00:00	\N	f	t	PATIENT	1	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
186	5	1	2020-07-28	02:30:00	03:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
184	5	102	2020-07-30	10:30:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
182	5	1	2020-07-30	10:00:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
190	5	1	2020-07-30	11:30:00	12:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
188	5	1	2020-07-30	11:00:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
192	5	1	2020-07-26	11:00:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
166	5	1	2020-08-04	02:00:00	02:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
194	5	110	2020-07-28	05:00:00	05:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
196	5	110	2020-07-30	13:45:00	14:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
168	5	2	2020-07-29	13:30:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
198	5	2	2020-07-28	10:00:00	10:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
200	5	1	2020-07-28	05:00:00	05:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
202	5	1	2020-07-28	13:45:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
144	5	3	2020-07-29	15:00:00	16:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
204	5	1	2020-07-28	05:00:00	05:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
208	5	1	2020-07-26	15:15:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
206	5	1	2020-07-28	16:00:00	16:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
216	5	60	2020-07-30	13:45:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
222	5	124	2020-07-26	14:30:00	15:15:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
212	5	60	2020-07-30	10:00:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
113	5	1	2020-07-22	11:00:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
218	5	123	2020-07-28	13:00:00	13:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
224	5	56	2020-07-28	17:30:00	18:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
214	5	73	2020-07-30	10:45:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	notRequired	inHospital	notCompleted	\N	t
210	5	1	2020-07-28	05:00:00	05:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
226	5	95	2020-07-28	05:00:00	06:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
228	5	63	2020-07-28	16:00:00	17:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
230	5	96	2020-07-28	05:00:00	06:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	onlineCollection	online	notCompleted	\N	t
233	5	97	2020-07-28	13:00:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
178	5	60	2020-07-29	10:30:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
176	5	92	2020-07-29	02:30:00	03:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
234	5	65	2020-07-29	12:00:00	13:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
235	5	133	2020-07-28	05:00:00	06:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
236	5	134	2020-07-28	05:00:00	06:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
237	5	99	2020-07-29	13:00:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
238	5	135	2020-07-29	02:00:00	03:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
240	5	23	2020-07-30	10:00:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
220	5	50	2020-07-28	16:45:00	17:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
239	5	100	2020-07-29	10:00:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
242	5	1	2020-07-28	07:30:00	08:00:00	\N	t	f	DOCTOR	32	\N	\N	30	onlineCollection	online	notCompleted	\N	t
243	5	92	2020-07-28	13:30:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
245	5	1	2020-07-28	07:00:00	07:10:00	\N	t	f	DOCTOR	32	\N	\N	10	onlineCollection	online	notCompleted	\N	t
244	5	137	2020-07-28	05:00:00	05:10:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	\N	t
247	5	1	2020-07-28	05:48:00	05:58:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	\N	t
248	5	1	2020-07-28	05:48:00	05:58:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	\N	t
241	5	60	2020-07-28	10:00:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
246	5	1	2020-07-29	02:47:00	02:57:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	onlineCollection	online	notCompleted	\N	t
249	5	1	2020-07-29	10:50:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	\N	t
251	5	1	2020-07-29	10:00:00	10:50:00	\N	f	t	DOCTOR	32	DOCTOR	32	50	directPayment	online	notCompleted	\N	t
252	5	1	2020-07-29	15:50:00	16:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	50	directPayment	online	notCompleted	\N	t
254	5	1	2020-07-29	10:45:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
255	5	1	2020-07-29	15:00:00	15:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
256	5	1	2020-07-29	15:45:00	16:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
259	5	1	2020-07-29	15:00:00	15:45:00	\N	t	f	DOCTOR	32	\N	\N	45	onlineCollection	inHospital	notCompleted	\N	t
260	5	140	2020-07-29	15:45:00	16:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
264	5	50	2020-07-29	16:30:00	17:15:00	\N	t	f	DOCTOR	32	\N	\N	45	notRequired	inHospital	notCompleted	\N	t
266	5	55	2020-08-06	10:45:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	45	onlineCollection	online	notCompleted	\N	t
270	5	108	2020-08-05	10:00:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	60	notRequired	online	notCompleted	\N	t
267	5	142	2020-07-29	03:00:00	03:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
271	5	142	2020-07-30	15:30:00	16:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	\N	t
273	5	109	2020-08-03	14:15:00	15:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	online	notCompleted	\N	t
275	5	109	2020-07-29	17:15:00	18:00:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
276	5	144	2020-08-04	14:00:00	14:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
278	5	146	2020-08-03	14:15:00	15:00:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
253	5	139	2020-07-29	10:00:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
250	5	1	2020-07-29	02:00:00	02:50:00	\N	f	t	DOCTOR	32	DOCTOR	32	50	directPayment	online	notCompleted	\N	t
281	5	1	2020-07-30	15:15:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
258	5	50	2020-08-04	05:00:00	05:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
283	5	147	2020-07-29	18:00:00	18:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
285	5	58	2020-07-29	02:00:00	02:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
286	5	84	2020-07-29	02:45:00	03:30:00	\N	t	f	DOCTOR	32	\N	\N	45	onlineCollection	online	notCompleted	\N	t
265	5	1	2020-08-04	07:00:00	07:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
288	5	1	2020-08-11	14:00:00	14:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
290	5	2	2020-08-06	15:00:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	60	onlineCollection	inHospital	notCompleted	\N	t
291	5	63	2020-08-10	15:00:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	60	onlineCollection	online	notCompleted	\N	t
272	5	144	2020-08-03	15:00:00	15:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
287	5	50	2020-08-05	15:45:00	16:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
289	5	148	2020-08-11	09:00:00	09:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
269	5	143	2020-08-03	13:00:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
277	5	145	2020-08-05	15:00:00	15:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
292	5	149	2020-08-04	13:00:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
282	5	61	2020-08-10	12:00:00	12:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
279	5	111	2020-08-06	13:00:00	13:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
293	5	150	2020-08-10	14:00:00	15:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
263	5	60	2020-08-04	09:00:00	09:45:00	\N	f	t	DOCTOR	32	ADMIN	53	45	onlineCollection	online	notCompleted	\N	t
274	5	109	2020-08-04	10:00:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	online	notCompleted	\N	t
268	5	1	2020-08-03	12:00:00	13:00:00	\N	f	t	DOCTOR	32	ADMIN	53	60	onlineCollection	online	notCompleted	\N	t
280	5	111	2020-08-06	13:45:00	14:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
294	5	150	2020-08-12	02:00:00	03:00:00	\N	f	t	DOCTOR	32	ADMIN	53	60	onlineCollection	online	notCompleted	\N	t
284	5	78	2020-08-04	07:00:00	07:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
295	5	115	2020-08-17	13:00:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
300	5	152	2020-08-04	15:00:00	16:00:00	\N	t	f	PATIENT	152	\N	\N	60	directPayment	online	notCompleted	\N	t
261	5	1	2020-08-05	02:00:00	02:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	notRequired	online	notCompleted	\N	t
303	5	1	2020-07-31	16:00:00	16:55:00	\N	t	f	DOCTOR	32	\N	\N	55	directPayment	online	notCompleted	\N	t
296	5	116	2020-08-04	05:00:00	06:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
297	5	116	2020-08-04	07:00:00	08:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
298	5	116	2020-08-05	03:00:00	04:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
305	5	160	2020-08-03	13:00:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
306	5	161	2020-08-03	13:00:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
309	5	1	2020-08-12	10:00:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
308	5	161	2020-08-04	07:00:00	08:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
312	5	161	2020-08-05	11:00:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
313	5	145	2020-08-04	17:00:00	18:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
314	5	162	2020-08-05	16:00:00	17:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
302	5	116	2020-08-10	13:00:00	13:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
311	5	1	2020-08-15	10:00:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	\N	t
316	5	162	2020-08-05	18:00:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	60	onlineCollection	online	notCompleted	\N	t
318	5	162	2020-08-11	05:00:00	06:00:00	\N	t	f	DOCTOR	32	\N	\N	60	onlineCollection	online	notCompleted	\N	t
319	5	162	2020-08-11	16:00:00	17:00:00	\N	t	f	DOCTOR	32	\N	\N	60	onlineCollection	online	notCompleted	\N	t
323	5	162	2020-08-11	13:00:00	13:45:00	\N	t	f	DOCTOR	32	\N	\N	45	onlineCollection	online	notCompleted	\N	t
324	5	162	2020-08-06	13:00:00	13:45:00	\N	t	f	DOCTOR	32	\N	\N	45	onlineCollection	online	notCompleted	\N	t
325	5	162	2020-08-11	14:45:00	15:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
326	5	1	2020-08-20	10:00:00	10:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
262	5	141	2020-08-06	10:00:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
322	5	162	2020-08-12	18:00:00	18:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
327	5	1	2020-08-11	09:00:00	10:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	\N	t
329	5	85	2020-08-11	07:30:00	07:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
331	5	52	2020-08-11	07:45:00	08:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
332	5	1	2020-08-03	13:00:00	13:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
333	5	1	2020-08-03	13:00:00	13:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	onlineCollection	online	notCompleted	\N	t
334	5	1	2020-08-05	03:00:00	03:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
328	5	85	2020-08-04	07:00:00	07:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	onlineCollection	online	notCompleted	\N	t
336	5	1	2020-08-03	13:15:00	13:30:00	\N	t	f	ADMIN	53	\N	\N	\N	onlineCollection	online	notCompleted	\N	t
337	5	1	2020-08-03	15:00:00	15:15:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
339	1	1	2020-08-03	04:00:00	04:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
340	1	1	2020-08-03	04:30:00	05:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
341	5	162	2020-08-10	12:15:00	12:30:00	\N	t	f	PATIENT	162	\N	\N	15	directPayment	online	notCompleted	\N	t
342	5	162	2020-08-18	14:15:00	14:30:00	\N	t	f	PATIENT	162	\N	\N	15	directPayment	online	notCompleted	\N	t
335	5	165	2020-08-03	13:00:00	13:15:00	\N	f	t	DOCTOR	32	ADMIN	53	15	directPayment	online	notCompleted	\N	t
343	1	162	2020-08-03	06:30:00	07:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
344	1	1	2020-08-03	05:00:00	05:30:00	\N	t	f	DOC_ASSISTANT	59	\N	\N	\N	directPayment	online	notCompleted	\N	t
330	5	50	2020-08-06	10:30:00	10:45:00	\N	f	t	DOCTOR	32	ADMIN	53	15	directPayment	online	notCompleted	\N	t
345	1	162	2020-08-04	09:30:00	10:00:00	\N	t	f	PATIENT	162	\N	\N	30	directPayment	online	notCompleted	\N	t
346	5	74	2020-08-04	16:00:00	16:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
347	5	1	2020-08-04	07:00:00	07:15:00	\N	t	f	DOC_ASSISTANT	59	\N	\N	\N	directPayment	online	notCompleted	\N	t
348	5	125	2020-08-05	20:15:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
349	5	163	2020-08-04	18:00:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
350	5	146	2020-08-03	15:45:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
352	5	146	2020-08-04	16:15:00	16:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
354	5	55	2020-08-04	07:30:00	07:45:00	\N	t	f	DOC_ASSISTANT	59	\N	\N	\N	directPayment	online	notCompleted	\N	t
317	5	162	2020-08-10	13:00:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	onlineCollection	online	notCompleted	\N	t
353	5	1	2020-08-04	07:15:00	07:30:00	\N	f	t	DOC_ASSISTANT	59	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
307	5	1	2020-08-05	02:00:00	03:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	\N	t
315	5	162	2020-08-04	13:00:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	onlineCollection	online	notCompleted	\N	t
351	5	170	2020-08-04	09:00:00	09:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
338	5	1	2020-08-12	15:00:00	15:15:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
320	5	162	2020-08-12	17:00:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	onlineCollection	online	notCompleted	\N	t
299	5	5	2020-08-03	15:00:00	16:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	completed	\N	t
321	5	163	2020-08-03	13:30:00	14:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
356	5	173	2020-08-05	15:15:00	15:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
360	1	5	2020-08-17	10:30:00	11:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
355	5	172	2020-08-06	10:00:00	10:15:00	\N	f	t	DOCTOR	32	ADMIN	53	15	directPayment	online	notCompleted	\N	t
364	5	55	2020-08-12	03:15:00	03:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
367	5	116	2020-08-04	07:15:00	07:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
369	5	141	2020-08-03	13:45:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	inHospital	notCompleted	\N	t
357	5	173	2020-08-04	09:45:00	10:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	onlineCollection	online	notCompleted	\N	t
371	5	162	2020-08-04	10:00:00	10:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
372	5	58	2020-08-04	07:45:00	08:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	inHospital	notCompleted	\N	t
373	5	5	2020-08-04	13:00:00	13:15:00	\N	t	f	PATIENT	5	\N	\N	15	directPayment	online	notCompleted	\N	t
374	5	116	2020-08-05	17:00:00	17:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	onlineCollection	inHospital	notCompleted	\N	t
375	5	116	2020-08-04	13:15:00	13:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
376	5	116	2020-08-06	10:15:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	inHospital	notCompleted	\N	t
366	5	116	2020-08-05	02:45:00	03:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	inHospital	notCompleted	\N	t
378	5	151	2020-08-05	02:30:00	02:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	onlineCollection	inHospital	notCompleted	\N	t
380	5	151	2020-08-10	12:00:00	12:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
363	5	1	2020-08-06	10:00:00	10:15:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
381	5	178	2020-08-05	02:30:00	02:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
361	5	1	2020-08-05	02:00:00	02:15:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
383	5	178	2020-08-11	07:15:00	07:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
382	5	178	2020-08-11	07:00:00	07:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
387	5	90	2020-08-05	02:30:00	02:45:00	\N	t	f	DOCTOR	32	\N	\N	15	onlineCollection	online	notCompleted	\N	t
386	5	179	2020-08-11	07:00:00	07:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
388	5	180	2020-08-11	07:00:00	07:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
389	5	179	2020-08-06	10:30:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
377	5	116	2020-08-06	10:15:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
384	5	1	2020-08-06	10:00:00	10:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
385	5	179	2020-08-05	02:00:00	02:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
390	5	181	2020-08-05	02:00:00	02:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
391	5	181	2020-08-06	10:00:00	10:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
379	5	151	2020-08-05	02:45:00	03:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	onlineCollection	inHospital	notCompleted	\N	t
393	5	146	2020-08-06	10:30:00	10:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
394	5	182	2020-08-06	11:30:00	11:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
392	5	182	2020-08-06	11:45:00	12:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
396	5	186	2020-08-03	15:30:00	15:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
397	5	187	2020-08-04	14:45:00	15:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
398	5	187	2020-08-04	13:30:00	13:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	onlineCollection	online	notCompleted	\N	t
399	5	187	2020-08-04	13:45:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	\N	t
400	1	150	2020-08-03	18:30:00	19:00:00	\N	t	f	PATIENT	150	\N	\N	30	directPayment	online	notCompleted	\N	t
401	1	150	2020-08-24	10:00:00	11:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
403	5	150	2020-08-04	11:09:00	11:54:00	\N	t	f	PATIENT	150	\N	\N	45	directPayment	online	notCompleted	\N	t
404	1	140	2020-08-10	04:00:00	05:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
365	5	50	2020-08-03	13:00:00	13:15:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
368	5	141	2020-08-03	13:30:00	13:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
406	1	150	2020-08-11	10:00:00	11:00:00	\N	t	f	PATIENT	150	\N	\N	60	directPayment	online	notCompleted	\N	t
395	5	185	2020-08-03	14:00:00	14:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
405	5	150	2020-08-03	12:00:00	12:30:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	notCompleted	\N	t
407	5	193	2020-08-03	09:00:00	09:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	online	notCompleted	\N	t
408	5	194	2020-08-03	09:00:00	09:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	inHospital	notCompleted	\N	t
402	5	5	2020-08-04	18:15:00	19:00:00	\N	f	t	PATIENT	5	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
409	5	195	2020-08-03	09:00:00	09:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	notRequired	inHospital	notCompleted	\N	t
410	5	195	2020-08-11	17:30:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
411	5	196	2020-08-03	09:00:00	09:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	online	notCompleted	\N	t
412	5	198	2020-08-03	12:00:00	12:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	online	notCompleted	\N	t
413	5	203	2020-08-03	09:00:00	09:15:00	\N	t	f	DOCTOR	32	\N	\N	15	onlineCollection	online	notCompleted	\N	t
414	5	205	2020-08-04	09:00:00	09:45:00	\N	t	f	DOCTOR	32	\N	\N	45	onlineCollection	online	notCompleted	\N	t
415	5	205	2020-08-05	15:00:00	15:45:00	\N	t	f	PATIENT	205	\N	\N	45	directPayment	online	notCompleted	\N	t
416	5	3	2020-08-05	17:15:00	18:00:00	\N	t	f	PATIENT	3	\N	\N	45	directPayment	online	notCompleted	\N	t
417	5	206	2020-08-11	14:00:00	14:45:00	\N	t	f	PATIENT	206	\N	\N	45	directPayment	online	notCompleted	\N	t
418	3	206	2020-08-06	15:50:00	16:15:00	\N	t	f	PATIENT	206	\N	\N	25	directPayment	online	notCompleted	\N	t
419	3	206	2020-08-25	09:50:00	10:15:00	\N	t	f	PATIENT	206	\N	\N	25	directPayment	online	notCompleted	\N	t
420	3	206	2020-08-04	12:20:00	12:45:00	\N	t	f	PATIENT	206	\N	\N	25	directPayment	online	notCompleted	\N	t
421	1	207	2020-08-14	02:00:00	02:45:00	\N	t	f	PATIENT	207	\N	\N	45	directPayment	online	notCompleted	\N	t
422	1	207	2020-08-21	05:00:00	05:45:00	\N	t	f	PATIENT	207	\N	\N	45	directPayment	online	notCompleted	\N	t
423	1	207	2020-08-21	02:00:00	02:45:00	\N	t	f	PATIENT	207	\N	\N	45	directPayment	online	notCompleted	\N	t
424	2	208	2020-08-04	09:00:00	10:00:00	\N	t	f	DOCTOR	29	\N	\N	60	onlineCollection	online	notCompleted	\N	t
425	3	207	2020-08-13	16:00:00	16:15:00	\N	t	f	PATIENT	207	\N	\N	15	directPayment	online	notCompleted	\N	t
426	25	5	2020-08-04	20:30:00	21:00:00	\N	t	f	DOCTOR	52	\N	\N	30	directPayment	online	notCompleted	\N	t
427	22	5	2020-08-05	19:00:00	19:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
428	22	5	2020-08-05	19:30:00	20:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
429	22	5	2020-08-05	20:00:00	20:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
430	22	5	2020-08-05	20:30:00	21:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
431	22	5	2020-08-05	21:00:00	21:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
432	22	5	2020-08-05	21:30:00	22:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
433	22	5	2020-08-05	17:00:00	17:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
434	22	5	2020-08-05	17:30:00	18:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
435	1	5	2020-08-04	14:00:00	14:45:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
436	1	5	2020-08-04	16:15:00	17:00:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
437	1	5	2020-08-04	17:00:00	17:45:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
438	1	5	2020-08-04	15:30:00	16:15:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
439	1	5	2020-08-04	14:45:00	15:30:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
440	8	5	2020-08-04	15:00:00	15:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
441	8	5	2020-08-04	15:30:00	16:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
442	25	5	2020-08-05	17:00:00	17:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
444	25	5	2020-08-04	23:00:00	23:30:00	\N	t	f	DOCTOR	52	\N	\N	30	directPayment	online	notCompleted	\N	t
445	1	5	2020-08-10	17:15:00	18:00:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
446	22	5	2020-08-04	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
447	22	5	2020-08-04	16:30:00	17:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
448	22	5	2020-08-17	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
449	5	5	2020-08-05	02:45:00	03:30:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
450	8	5	2020-08-06	10:00:00	10:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
451	5	5	2020-08-12	18:00:00	18:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
452	3	206	2020-08-06	15:15:00	15:30:00	\N	t	f	PATIENT	206	\N	\N	15	directPayment	online	notCompleted	\N	t
453	5	5	2020-08-18	14:30:00	15:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
454	5	1	2020-08-05	20:30:00	21:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
455	5	1	2020-08-06	14:30:00	15:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
457	5	1	2020-08-24	09:00:00	09:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
458	1	5	2020-08-07	02:00:00	02:45:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
459	25	5	2020-08-07	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
460	25	5	2020-08-07	17:00:00	17:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
461	1	5	2020-08-07	02:50:00	03:00:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	\N	t
462	13	150	2020-08-07	08:00:00	08:30:00	\N	t	f	ADMIN	55	\N	\N	\N	directPayment	online	notCompleted	\N	t
463	13	150	2020-08-07	08:30:00	09:00:00	\N	t	f	ADMIN	55	\N	\N	\N	directPayment	online	notCompleted	\N	t
464	13	150	2020-08-07	10:30:00	11:00:00	\N	t	f	ADMIN	55	\N	\N	\N	directPayment	online	notCompleted	\N	t
465	5	5	2020-08-11	18:15:00	19:00:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
468	22	5	2020-08-08	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
469	6	1	2020-08-09	09:00:00	09:30:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	notCompleted	\N	t
470	6	1	2020-08-06	23:00:00	23:59:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	notCompleted	\N	t
456	5	1	2020-08-10	09:30:00	10:00:00	\N	f	t	DOCTOR	32	ADMIN	53	30	directPayment	online	notCompleted	\N	t
471	5	82	2020-08-12	02:00:00	02:45:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	\N	t
472	5	5	2020-08-12	02:00:00	02:45:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	\N	t
473	5	1	2020-08-07	09:00:00	09:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
474	5	1	2020-08-06	18:45:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	\N	t
476	22	217	2020-08-15	17:00:00	17:30:00	\N	t	f	PATIENT	217	\N	\N	30	directPayment	online	notCompleted	\N	t
475	5	218	2020-08-06	19:42:00	20:17:00	\N	f	t	DOCTOR	32	DOCTOR	32	35	onlineCollection	online	notCompleted	\N	t
477	5	218	2020-08-10	09:00:00	09:35:00	\N	t	f	DOCTOR	32	\N	\N	35	directPayment	online	notCompleted	\N	t
478	12	5	2020-08-11	09:00:00	09:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
479	22	5	2020-08-20	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
467	5	5	2020-08-12	10:00:00	10:45:00	\N	f	t	PATIENT	5	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
466	5	5	2020-08-12	10:45:00	11:30:00	\N	f	t	PATIENT	5	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
480	5	206	2020-08-07	10:43:00	11:18:00	\N	t	f	DOCTOR	32	\N	\N	35	directPayment	online	notCompleted	\N	t
481	5	206	2020-08-06	19:42:00	20:17:00	\N	t	f	DOCTOR	32	\N	\N	35	directPayment	online	notCompleted	\N	t
482	5	119	2020-08-06	20:17:00	20:52:00	\N	t	f	DOCTOR	32	\N	\N	35	directPayment	online	notCompleted	\N	t
483	5	1	2020-08-07	10:00:00	10:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	\N	t
484	5	1	2020-08-07	11:20:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	\N	t
485	5	1	2020-08-07	11:20:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	\N	t
486	4	1	2020-08-07	18:00:00	18:10:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
487	4	1	2020-08-07	18:30:00	18:40:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
488	4	1	2020-08-07	18:10:00	18:20:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
489	4	152	2020-08-07	19:00:00	19:10:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
490	5	162	2020-08-07	11:48:00	11:58:00	\N	t	f	DOCTOR	32	\N	\N	10	onlineCollection	online	notCompleted	\N	t
491	4	152	2020-08-07	19:30:00	19:40:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
492	4	152	2020-08-07	20:00:00	20:10:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
493	4	152	2020-08-07	20:30:00	20:40:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
494	4	152	2020-08-07	19:10:00	19:20:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
495	5	162	2020-08-07	16:19:00	16:29:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	\N	t
496	4	152	2020-08-07	18:40:00	18:50:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
497	4	168	2020-08-07	19:40:00	19:50:00	\N	t	f	DOCTOR	31	\N	\N	10	directPayment	online	notCompleted	\N	t
498	1	162	2020-08-08	09:50:00	10:00:00	\N	t	f	PATIENT	162	\N	\N	10	directPayment	online	notCompleted	\N	t
499	25	5	2020-08-08	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	\N	t
500	5	162	2020-08-07	19:30:00	20:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
501	5	162	2020-08-07	20:30:00	21:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
301	5	116	2020-08-10	12:45:00	13:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	\N	t
503	5	162	2020-08-10	16:30:00	17:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
504	1	1	2020-08-08	11:00:00	12:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
505	5	162	2020-08-08	11:00:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	\N	t
506	1	1	2020-08-08	15:00:00	16:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
507	1	92	2020-08-08	18:00:00	19:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
509	1	92	2020-08-11	02:30:00	03:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
510	1	141	2020-08-14	05:00:00	06:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	\N	t
511	1	141	2020-08-14	05:00:00	06:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	\N	t
512	1	141	2020-08-14	05:00:00	06:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
513	1	105	2020-08-08	17:00:00	18:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
514	1	141	2020-08-10	05:00:00	06:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
515	1	141	2020-08-11	16:00:00	17:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	\N	t
516	5	92	2020-08-08	10:30:00	11:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	\N	t
517	5	92	2020-08-08	10:30:00	11:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	\N	t
518	5	92	2020-08-08	10:30:00	11:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	\N	t
519	5	92	2020-08-08	10:30:00	11:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	\N	t
520	5	162	2020-08-08	11:41:00	11:45:00	\N	t	f	DOCTOR	32	\N	\N	4	onlineCollection	online	notCompleted	\N	t
521	5	162	2020-08-08	16:07:00	16:11:00	\N	t	f	DOCTOR	32	\N	\N	4	directPayment	online	notCompleted	\N	t
522	5	162	2020-08-08	16:11:00	16:15:00	\N	t	f	DOCTOR	32	\N	\N	4	onlineCollection	online	notCompleted	\N	t
526	1	5	2020-08-11	08:30:00	09:30:00	\N	t	f	PATIENT	5	\N	\N	60	directPayment	online	notCompleted	2020-08-08 15:30:11.974	t
527	5	90	2020-08-08	18:00:00	18:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-08 18:23:33.806	t
528	25	5	2020-08-10	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-08-08 20:43:39.281	t
529	2	1	2020-08-09	17:30:00	17:45:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-09 17:35:07.885	t
530	1	90	2020-08-14	04:00:00	05:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-09 12:42:59.495	t
532	1	1	2020-08-15	10:00:00	11:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-09 12:52:26.658	t
531	1	1	2020-08-14	04:00:00	05:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-09 12:49:19.805	t
536	1	142	2020-08-10	02:34:00	03:34:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-09 13:51:46.695	t
535	1	83	2020-08-10	01:34:00	02:34:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-09 13:50:16.328	t
537	1	91	2020-08-10	01:34:00	02:34:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-09 14:01:33.563	t
502	5	162	2020-08-10	10:00:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	onlineCollection	online	notCompleted	\N	t
508	1	1	2020-08-11	01:30:00	02:30:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	\N	t
539	1	167	2020-08-14	03:00:00	04:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-09 14:45:28.346	t
523	1	92	2020-08-15	14:45:00	15:30:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-08 14:54:27.694	t
533	1	82	2020-08-15	10:00:00	11:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-09 13:46:28.186	t
534	1	83	2020-08-15	11:00:00	12:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-09 13:48:02.901	t
538	5	1	2020-08-09	12:00:00	12:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-09 19:48:48.754	t
525	5	5	2020-08-13	15:00:00	15:30:00	\N	f	t	PATIENT	5	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-08 15:28:36.378	t
524	1	90	2020-08-15	16:15:00	17:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-08 14:55:53.431	t
541	1	141	2020-08-15	18:45:00	19:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-09 15:30:31.761	t
547	1	140	2020-08-14	02:45:00	03:30:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-11 08:55:15.894	t
548	1	221	2020-08-15	18:00:00	18:45:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-11 09:02:06.235	t
549	1	140	2020-08-15	09:45:00	10:30:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-11 09:04:23.924	t
550	1	178	2020-08-14	02:45:00	03:30:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-11 09:10:08.548	t
551	1	140	2020-08-11	14:00:00	14:45:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-11 09:33:28.047	t
443	5	5	2020-08-12	20:00:00	20:45:00	\N	f	t	PATIENT	5	DOCTOR	32	45	directPayment	online	notCompleted	\N	t
554	5	230	2020-08-14	09:45:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-11 11:55:39.903	t
552	5	215	2020-08-13	12:45:00	13:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	online	notCompleted	2020-08-11 09:57:49.064	t
553	5	234	2020-08-11	19:00:00	19:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-11 16:25:41.227	t
542	5	5	2020-08-14	11:15:00	12:00:00	\N	f	t	PATIENT	5	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-09 17:12:49.355	t
543	5	5	2020-08-17	12:00:00	12:45:00	\N	f	t	PATIENT	5	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-09 17:20:54.754	t
544	5	5	2020-08-31	15:00:00	15:45:00	\N	f	t	PATIENT	5	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-09 19:38:05.981	t
545	5	221	2020-08-10	21:15:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-10 20:59:06.47	t
546	5	119	2020-08-12	20:45:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-11 05:13:52.674	t
557	5	162	2020-08-14	10:30:00	11:15:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-11 13:11:27.583	t
559	5	1	2020-08-12	10:00:00	10:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-11 21:35:19.343	t
562	5	1	2020-08-12	15:45:00	16:30:00	\N	t	f	PATIENT	\N	\N	\N	45	directPayment	online	notCompleted	2020-08-11 22:02:56.614	t
563	5	1	2020-08-17	09:00:00	09:45:00	\N	f	t	PATIENT	1	PATIENT	\N	45	directPayment	online	notCompleted	2020-08-11 22:08:24.893	t
564	5	1	2020-08-17	09:45:00	10:30:00	\N	t	f	PATIENT	\N	\N	\N	45	directPayment	online	notCompleted	2020-08-11 22:10:13.65	t
565	5	1	2020-08-17	09:00:00	09:45:00	\N	f	t	PATIENT	1	PATIENT	\N	45	directPayment	online	notCompleted	2020-08-11 22:12:02.316	t
566	5	1	2020-08-17	12:00:00	12:45:00	\N	f	t	PATIENT	\N	PATIENT	\N	45	directPayment	online	notCompleted	2020-08-11 22:16:43.45	t
567	5	1	2020-08-17	09:00:00	09:45:00	\N	f	t	PATIENT	\N	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-11 22:20:02.586	t
568	5	1	2020-08-17	12:00:00	12:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-11 22:34:12.216	t
569	5	1	2020-08-17	09:00:00	09:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-11 22:37:02.746	t
556	5	1	2020-08-11	21:15:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-11 13:08:41.783	t
570	5	215	2020-08-11	21:15:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	onlineCollection	online	notCompleted	2020-08-11 17:10:45.941	t
571	5	1	2020-08-12	20:00:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 17:33:34.159	t
558	5	1	2020-08-11	20:30:00	21:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-11 21:09:58.25	t
555	5	1	2020-08-11	19:00:00	19:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-11 18:05:13.917	t
572	5	152	2020-08-15	10:30:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 17:42:18.157	t
573	5	142	2020-08-15	11:30:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 17:42:33.112	t
574	5	169	2020-08-15	16:30:00	17:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 17:43:00.133	t
575	5	151	2020-08-11	21:30:00	22:00:00	\N	t	f	PATIENT	151	\N	\N	30	directPayment	online	notCompleted	2020-08-11 17:51:36.899	t
576	5	1	2020-08-13	10:00:00	10:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 17:54:14.119	t
577	5	152	2020-08-13	11:30:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 18:01:20.415	t
578	5	152	2020-08-11	19:00:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 18:01:42.497	t
579	5	169	2020-08-15	18:30:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 18:03:15.535	t
580	5	162	2020-08-14	09:00:00	09:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-11 18:04:02.089	t
581	5	152	2020-08-11	19:30:00	20:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 18:07:04.593	t
582	5	162	2020-08-11	20:00:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 18:07:26.467	t
583	5	152	2020-08-14	09:00:00	09:30:00	\N	f	t	DOCTOR	32	PATIENT	\N	30	directPayment	online	notCompleted	2020-08-11 18:08:09.5	t
586	5	152	2020-08-21	09:00:00	09:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 18:33:33.088	t
585	5	152	2020-08-17	16:30:00	17:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-08-11 23:52:50.747	t
587	5	152	2020-08-19	02:00:00	02:30:00	\N	t	f	PATIENT	\N	\N	\N	30	directPayment	online	notCompleted	2020-08-12 00:14:41.612	t
588	5	1	2020-08-14	11:30:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-11 19:17:21.69	t
589	16	5	2020-08-14	08:00:00	08:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-08-11 19:55:52.474	t
590	5	152	2020-08-18	15:00:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-08-12 09:10:14.374	t
591	5	151	2020-08-12	17:00:00	18:00:00	\N	t	f	PATIENT	151	\N	\N	60	directPayment	online	notCompleted	2020-08-12 09:45:23.821	t
592	3	150	2020-08-13	16:15:00	16:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-12 15:29:37.308	t
593	5	162	2020-08-13	12:00:00	12:30:00	\N	t	f	DOCTOR	32	\N	\N	30	notRequired	online	notCompleted	2020-08-12 16:11:42.782	t
594	5	162	2020-08-15	16:00:00	16:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-12 16:12:59.977	t
595	5	215	2020-08-14	12:30:00	13:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-12 18:12:30.07	t
560	5	1	2020-08-17	15:00:00	15:45:00	\N	f	t	DOCTOR	32	ADMIN	53	45	directPayment	online	notCompleted	2020-08-11 21:41:36.804	t
596	5	121	2020-08-12	20:30:00	21:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-12 18:58:25.956	t
597	5	162	2020-08-14	13:00:00	13:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-12 19:40:24.133	t
598	5	230	2020-08-13	11:00:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-13 08:52:38.093	t
599	5	178	2020-08-15	12:00:00	12:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-13 08:53:47.541	t
600	5	121	2020-08-15	12:30:00	13:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-13 09:37:24.267	t
601	5	178	2020-08-15	17:00:00	17:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-13 10:45:11.17	t
603	5	141	2020-08-13	13:00:00	13:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-13 10:47:21.763	t
602	5	141	2020-08-13	12:30:00	13:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-13 10:47:00.415	t
607	22	5	2020-08-13	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-08-13 16:11:18.638	t
606	5	177	2020-08-14	09:15:00	09:30:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	notCompleted	2020-08-13 15:37:40.47	t
610	5	178	2020-08-15	11:15:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-08-13 16:28:29.266	t
609	5	178	2020-08-15	11:00:00	11:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-08-13 16:28:07.623	t
608	5	178	2020-08-15	10:15:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-08-13 16:27:53.445	t
611	5	178	2020-08-14	09:30:00	09:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-08-13 16:31:11.95	t
614	5	121	2020-08-13	18:00:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-08-13 17:21:15.377	t
615	5	121	2020-08-13	18:15:00	18:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-08-13 17:21:37.04	t
616	5	121	2020-08-13	18:30:00	18:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-08-13 17:25:04.873	t
617	5	1	2020-08-14	09:00:00	09:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-08-13 17:30:34.702	t
618	1	206	2020-08-30	06:45:00	07:30:00	\N	t	f	PATIENT	206	\N	\N	45	directPayment	online	notCompleted	2020-08-13 18:04:26.868	t
613	5	178	2020-08-14	10:00:00	10:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-08-13 17:20:11.226	t
612	5	178	2020-08-14	09:45:00	10:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-08-13 16:31:30.596	t
604	5	162	2020-08-14	13:00:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-08-13 11:43:03.09	t
621	5	206	2020-08-13	21:00:00	21:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-13 20:04:23.51	t
620	5	206	2020-08-13	20:17:00	20:52:00	\N	f	t	DOCTOR	32	DOCTOR	32	35	directPayment	online	notCompleted	2020-08-13 19:19:58.058	t
619	5	206	2020-08-13	19:42:00	20:17:00	\N	f	t	DOCTOR	32	DOCTOR	32	35	directPayment	online	notCompleted	2020-08-13 19:19:20.155	t
584	5	152	2020-08-17	16:00:00	16:30:00	\N	f	t	PATIENT	\N	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-11 23:45:30.302	t
622	5	206	2020-08-13	19:30:00	20:15:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-13 20:11:16.771	t
623	5	5	2020-08-21	12:00:00	12:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-08-13 20:15:12.087	t
624	5	151	2020-08-18	09:00:00	09:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-13 20:17:44.87	t
625	5	151	2020-08-18	09:30:00	10:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-13 20:18:17.277	t
626	5	140	2020-08-17	10:30:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-14 09:38:55.093	t
627	5	119	2020-08-20	10:30:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-14 09:43:16.378	t
628	5	119	2020-08-19	02:30:00	03:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-14 09:43:54.071	t
629	5	119	2020-08-19	03:00:00	03:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-14 09:45:51.695	t
630	5	119	2020-08-19	03:30:00	04:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-14 10:55:52.13	t
631	5	202	2020-08-17	16:00:00	16:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	notRequired	online	notCompleted	2020-08-17 09:40:01.472	t
632	11	5	2020-08-17	10:30:00	11:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-08-17 10:31:58.05	t
633	22	248	2020-08-17	18:30:00	19:00:00	\N	t	f	PATIENT	248	\N	\N	30	directPayment	online	notCompleted	2020-08-17 11:16:28.92	t
634	5	248	2020-08-17	15:00:00	15:30:00	\N	t	f	PATIENT	248	\N	\N	30	directPayment	online	notCompleted	2020-08-17 11:16:53.037	t
635	5	162	2020-08-17	20:30:00	21:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-17 11:30:59.887	t
636	5	162	2020-08-17	19:00:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-17 11:31:22.144	t
637	5	250	2020-08-17	21:00:00	21:30:00	\N	t	f	PATIENT	250	\N	\N	30	directPayment	online	notCompleted	2020-08-17 12:19:44.022	t
638	5	250	2020-08-18	13:00:00	13:45:00	\N	t	f	PATIENT	250	\N	\N	45	directPayment	online	notCompleted	2020-08-17 13:20:21.962	t
639	5	162	2020-08-18	21:30:00	22:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-18 13:35:21.796	t
640	1	5	2020-08-18	21:00:00	21:45:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	2020-08-18 19:11:39.665	t
641	5	122	2020-08-18	19:00:00	19:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-18 18:19:07.978	t
644	5	5	2020-08-19	10:00:00	10:45:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	2020-08-18 20:00:37.827	t
646	5	162	2020-08-19	20:45:00	21:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-19 11:17:12.811	t
647	5	151	2020-08-24	15:00:00	15:45:00	\N	t	f	PATIENT	151	\N	\N	45	directPayment	online	notCompleted	2020-08-19 12:36:22.615	t
648	5	151	2020-08-19	20:00:00	20:45:00	\N	t	f	PATIENT	151	\N	\N	45	directPayment	online	notCompleted	2020-08-19 13:13:29.8	t
645	5	5	2020-08-19	17:00:00	17:45:00	\N	f	t	PATIENT	5	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-18 20:31:03.028	t
650	5	162	2020-08-19	17:00:00	17:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-19 15:14:09.918	t
605	5	5	2020-08-28	21:00:00	22:00:00	\N	f	t	PATIENT	5	PATIENT	\N	60	directPayment	online	completed	2020-08-13 12:24:54.331	t
651	22	216	2020-08-19	17:00:00	17:30:00	\N	t	f	PATIENT	216	\N	\N	30	directPayment	online	notCompleted	2020-08-19 15:39:53.463	t
652	22	216	2020-08-19	17:30:00	18:00:00	\N	t	f	PATIENT	216	\N	\N	30	directPayment	online	notCompleted	2020-08-19 15:49:01.649	t
653	22	216	2020-08-19	18:00:00	18:30:00	\N	t	f	PATIENT	216	\N	\N	30	directPayment	online	notCompleted	2020-08-19 15:56:15.969	t
654	22	216	2020-08-19	16:30:00	17:00:00	\N	t	f	PATIENT	216	\N	\N	30	directPayment	online	notCompleted	2020-08-19 16:05:29.144	t
649	5	254	2020-08-20	12:45:00	13:30:00	\N	f	t	PATIENT	254	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-19 14:19:44.112	t
655	5	162	2020-08-20	13:45:00	14:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-19 20:06:46.014	t
657	5	1	2020-08-21	10:30:00	11:15:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-20 10:16:03.604	t
659	5	151	2020-08-20	20:00:00	21:00:00	\N	t	f	PATIENT	151	\N	\N	60	directPayment	online	notCompleted	2020-08-20 13:09:47.714	t
656	5	114	2020-08-20	12:45:00	13:30:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-19 20:49:15.169	t
658	5	162	2020-08-20	18:45:00	19:30:00	\N	f	t	DOCTOR	32	ADMIN	53	45	directPayment	online	notCompleted	2020-08-20 11:09:20.259	t
660	5	119	2020-08-20	21:00:00	21:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-20 17:09:15.097	t
661	5	162	2020-08-20	21:00:00	21:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-20 19:33:48.335	t
662	5	119	2020-08-21	11:15:00	12:00:00	\N	t	f	PATIENT	119	\N	\N	45	directPayment	online	notCompleted	2020-08-20 19:52:28.864	t
663	5	151	2020-08-21	12:45:00	13:30:00	\N	t	f	PATIENT	151	\N	\N	45	directPayment	online	notCompleted	2020-08-21 11:47:26.278	t
665	5	258	2020-08-21	18:33:00	19:18:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-21 12:31:54.647	t
666	5	119	2020-08-21	18:33:00	19:18:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-21 12:37:10.636	t
667	6	162	2020-08-23	09:00:00	09:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-21 14:10:42.993	t
679	5	5	2020-08-24	16:38:00	16:48:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-23 20:26:01.529	t
669	5	119	2020-08-22	22:00:00	22:45:00	\N	t	f	PATIENT	119	\N	\N	45	directPayment	online	notCompleted	2020-08-21 19:32:33.024	t
670	5	119	2020-08-22	10:45:00	11:30:00	\N	t	f	PATIENT	119	\N	\N	45	directPayment	online	notCompleted	2020-08-21 19:34:04.439	t
668	5	5	2020-08-22	10:00:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	paused	2020-08-21 19:53:58.931	t
671	5	5	2020-08-22	16:00:00	16:45:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	2020-08-22 12:22:03.239	t
672	5	150	2020-08-22	22:45:00	23:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	completed	2020-08-22 17:42:53.215	t
673	5	151	2020-08-24	19:00:00	19:45:00	\N	t	f	PATIENT	151	\N	\N	45	directPayment	online	notCompleted	2020-08-23 08:48:29.273	t
690	5	262	2020-08-25	16:00:00	17:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	completed	2020-08-25 16:19:42.919	t
681	5	5	2020-08-27	10:20:00	10:30:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-08-23 20:17:36.956	t
678	3	151	2020-08-23	19:15:00	19:30:00	\N	t	f	PATIENT	151	\N	\N	15	directPayment	online	notCompleted	2020-08-23 12:00:50.392	t
682	5	5	2020-08-25	01:11:00	01:21:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-24 10:08:15.085	t
684	5	5	2020-09-25	20:07:00	20:17:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-24 10:40:00.996	t
674	5	5	2020-08-24	15:45:00	16:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	completed	2020-08-23 14:31:32.344	t
664	5	150	2020-08-25	14:45:00	15:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	completed	2020-08-21 12:20:24.185	t
677	3	151	2020-08-23	19:00:00	19:15:00	\N	t	f	PATIENT	151	\N	\N	15	directPayment	online	completed	2020-08-23 12:00:36.729	t
257	5	5	2020-07-30	13:00:00	13:45:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	completed	\N	t
304	5	5	2020-08-04	16:00:00	16:55:00	\N	f	t	DOCTOR	32	DOC_ASSISTANT	59	55	directPayment	online	completed	\N	t
310	5	5	2020-08-04	05:00:00	06:00:00	\N	t	f	PATIENT	5	\N	\N	60	directPayment	online	completed	\N	t
358	5	5	2020-08-04	16:45:00	17:00:00	\N	t	f	PATIENT	5	\N	\N	15	directPayment	online	completed	\N	t
359	5	5	2020-08-10	13:45:00	14:00:00	\N	t	f	PATIENT	5	\N	\N	15	directPayment	online	completed	\N	t
370	5	5	2020-08-03	15:15:00	15:30:00	\N	t	f	PATIENT	5	\N	\N	15	directPayment	online	completed	\N	t
687	1	5	2020-08-24	15:45:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	2020-08-24 12:42:55.309	t
680	5	5	2020-08-24	16:48:00	16:58:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-08-23 20:31:30.322	t
688	5	162	2020-08-24	21:00:00	22:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-08-24 14:09:53.799	t
689	23	216	2020-08-25	16:00:00	16:30:00	\N	t	f	PATIENT	216	\N	\N	30	directPayment	online	notCompleted	2020-08-25 06:49:00.601	t
691	5	139	2020-08-25	13:00:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-08-25 10:51:48.536	t
675	3	151	2020-08-23	17:00:00	17:15:00	\N	t	f	PATIENT	151	\N	\N	15	directPayment	online	completed	2020-08-23 10:46:48.436	t
693	5	206	2020-08-26	02:09:00	02:19:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-25 11:49:00.878	t
676	3	151	2020-08-23	18:30:00	18:45:00	\N	t	f	PATIENT	151	\N	\N	15	directPayment	online	completed	2020-08-23 12:00:22.28	t
696	5	243	2020-08-25	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-25 17:05:11.048	t
695	5	140	2020-08-25	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-25 15:30:45.24	t
692	5	151	2020-08-25	19:00:00	20:00:00	\N	f	t	PATIENT	151	DOCTOR	32	60	directPayment	online	completed	2020-08-25 11:02:02.973	t
694	5	243	2020-08-25	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-25 15:26:11.824	t
683	5	5	2020-08-26	17:00:00	17:10:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	completed	2020-08-24 10:31:37.073	t
699	5	151	2020-08-25	20:30:00	21:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-25 17:12:59.193	t
685	1	5	2020-09-24	11:15:00	12:00:00	\N	f	t	ADMIN	53	PATIENT	\N	\N	directPayment	online	notCompleted	2020-08-24 11:59:07.458	t
698	5	243	2020-08-25	20:00:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-08-25 17:12:32.461	t
686	5	5	2020-08-29	16:00:00	16:10:00	\N	f	t	PATIENT	5	ADMIN	53	10	directPayment	online	notCompleted	2020-08-24 12:41:49.974	t
712	5	227	2020-08-26	17:30:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:11:13.913	t
711	5	206	2020-08-26	17:00:00	17:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	notRequired	online	completed	2020-08-26 13:10:56.943	t
702	5	141	2020-08-25	19:30:00	20:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-08-25 18:25:59.86	t
697	5	140	2020-08-25	19:00:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-08-25 17:12:09.114	t
701	5	141	2020-08-25	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-25 18:16:07.634	t
700	5	151	2020-08-25	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-25 17:13:15.085	t
704	5	206	2020-08-25	21:30:00	22:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-08-25 20:38:11.609	t
703	5	243	2020-08-25	21:00:00	21:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-08-25 20:37:56.939	t
723	5	139	2020-08-26	20:30:00	21:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	notRequired	online	completed	2020-08-26 13:26:44.25	t
722	5	126	2020-08-26	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	notRequired	online	completed	2020-08-26 13:26:24.23	t
706	5	151	2020-08-26	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 10:00:41.813	t
707	5	162	2020-08-26	20:00:00	20:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	paused	2020-08-26 10:06:03.463	t
727	5	206	2020-08-26	20:00:00	20:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:42:31.436	t
729	5	142	2020-08-26	17:00:00	17:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:44:54.018	t
724	5	221	2020-08-26	20:30:00	21:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:30:50.086	t
725	5	141	2020-08-26	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:31:05.737	t
705	5	141	2020-08-26	20:30:00	21:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 10:00:22.62	t
708	5	151	2020-08-26	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 10:17:43.698	t
709	5	119	2020-08-26	20:30:00	21:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 10:18:24.801	t
710	5	162	2020-08-26	20:00:00	20:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 10:19:13.9	t
717	5	235	2020-08-26	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	notRequired	online	completed	2020-08-26 13:18:05.417	t
718	5	247	2020-08-26	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	notRequired	online	completed	2020-08-26 13:18:24.798	t
716	5	206	2020-08-26	20:00:00	20:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	notRequired	online	completed	2020-08-26 13:17:49.968	t
715	5	162	2020-08-26	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:12:37.334	t
714	5	151	2020-08-26	20:30:00	21:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:11:59.557	t
713	5	141	2020-08-26	20:00:00	20:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:11:36.022	t
737	5	162	2020-08-26	17:00:00	17:30:00	\N	t	f	PATIENT	162	\N	\N	30	directPayment	online	notCompleted	2020-08-26 14:46:38.585	t
726	5	141	2020-08-26	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:41:54.686	t
721	5	256	2020-08-26	17:30:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	notRequired	online	completed	2020-08-26 13:21:41.914	t
720	5	253	2020-08-26	20:00:00	20:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	notRequired	online	completed	2020-08-26 13:21:26.179	t
719	5	149	2020-08-26	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	notRequired	online	completed	2020-08-26 13:21:11.017	t
736	5	181	2020-08-26	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 14:24:44.917	t
735	5	151	2020-08-26	20:00:00	20:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 14:24:19.273	t
733	5	181	2020-08-26	17:30:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:51:48.681	t
730	5	141	2020-08-26	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:45:11.96	t
728	5	151	2020-08-26	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:44:41.505	t
731	5	151	2020-08-26	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:51:01.036	t
732	5	122	2020-08-26	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 13:51:17.308	t
738	5	151	2020-08-26	20:30:00	21:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 14:48:49.021	t
734	5	253	2020-08-26	17:30:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 14:23:47.621	t
741	5	213	2020-08-26	20:00:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-08-26 14:57:26.1	t
739	5	253	2020-08-26	21:00:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 14:49:04.545	t
740	5	142	2020-08-26	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 14:49:28.068	t
742	5	179	2020-08-26	21:00:00	21:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-08-26 14:57:37.223	t
744	5	162	2020-08-26	11:00:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-27 00:05:27.993	t
745	5	162	2020-08-26	12:00:00	12:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-27 00:07:15.759	t
746	1	5	2020-08-27	05:00:00	05:45:00	\N	t	f	PATIENT	\N	\N	\N	45	directPayment	online	notCompleted	2020-08-26 18:38:58.547	t
747	5	162	2020-08-27	19:30:00	20:00:00	\N	t	f	PATIENT	162	\N	\N	30	directPayment	online	notCompleted	2020-08-27 00:09:20.097	t
743	5	170	2020-08-26	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-08-26 14:57:47.971	t
748	5	162	2020-08-26	21:30:00	22:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-08-26 19:05:31.88	t
749	5	119	2020-08-27	10:00:00	10:30:00	\N	t	f	PATIENT	119	\N	\N	30	directPayment	online	notCompleted	2020-08-26 19:55:30.133	t
750	5	5	2020-08-27	10:45:00	11:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-27 11:19:41.498	t
752	5	215	2020-08-27	15:15:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-27 11:43:33.428	t
753	5	269	2020-08-27	12:00:00	12:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-27 12:06:15.81	t
754	5	162	2020-08-27	18:00:00	18:10:00	\N	t	f	PATIENT	162	\N	\N	10	directPayment	online	notCompleted	2020-08-27 14:43:23.802	t
755	5	162	2020-08-27	18:40:00	18:50:00	\N	t	f	PATIENT	162	\N	\N	10	directPayment	online	notCompleted	2020-08-27 14:56:10.277	t
756	5	1	2020-08-27	18:20:00	18:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-27 16:05:00.282	t
757	5	5	2020-08-28	10:00:00	10:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-08-27 21:58:01.674	t
758	5	5	2020-08-28	10:30:00	11:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-08-27 21:58:19.619	t
761	5	276	2020-08-27	21:30:00	22:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-27 20:04:06.193	t
762	5	277	2020-08-28	11:00:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-08-27 20:16:29.217	t
764	5	282	2020-08-31	15:30:00	16:00:00	\N	f	t	DOCTOR	32	PATIENT	\N	30	directPayment	online	notCompleted	2020-08-28 09:00:22.779	t
773	5	282	2020-08-31	21:00:00	21:30:00	\N	t	f	PATIENT	282	\N	\N	30	directPayment	online	notCompleted	2020-08-28 11:27:34.496	t
768	5	282	2020-08-28	11:30:00	12:00:00	\N	t	f	PATIENT	282	\N	\N	30	directPayment	online	completed	2020-08-28 10:31:10.693	t
751	5	266	2020-08-28	12:00:00	12:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	completed	2020-08-27 11:29:17.52	t
797	5	282	2020-08-28	18:59:00	19:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:53:57.554	t
759	5	162	2020-08-28	19:19:00	19:49:00	\N	f	t	PATIENT	162	DOCTOR	32	30	directPayment	online	completed	2020-08-27 19:12:14.476	t
774	5	151	2020-08-28	17:59:00	18:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 12:02:57.519	t
782	5	151	2020-08-28	18:09:00	18:19:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:28:48.848	t
803	5	288	2020-08-29	16:40:00	16:50:00	\N	f	t	PATIENT	288	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-08-28 14:01:52.564	t
775	5	151	2020-08-28	17:59:00	18:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 12:14:15.753	t
772	5	282	2020-08-28	13:00:00	13:30:00	\N	f	t	PATIENT	282	DOCTOR	32	30	directPayment	online	completed	2020-08-28 11:02:19.904	t
792	5	288	2020-08-28	19:09:00	19:19:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	inHospital	completed	2020-08-28 13:41:59.462	t
776	5	151	2020-08-28	17:59:00	18:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 12:24:07.432	t
777	5	282	2020-08-28	18:49:00	18:59:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 12:24:52.865	t
785	25	288	2020-08-31	17:00:00	17:30:00	\N	t	f	PATIENT	288	\N	\N	30	onlineCollection	online	notCompleted	2020-08-28 13:31:56.517	t
781	22	284	2020-08-29	16:00:00	16:30:00	\N	t	f	PATIENT	284	\N	\N	30	onlineCollection	online	notCompleted	2020-08-28 13:14:22.52	t
779	5	151	2020-08-28	17:59:00	18:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:08:14.55	t
780	5	282	2020-08-28	18:49:00	18:59:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:08:31.952	t
778	5	1	2020-08-28	18:59:00	19:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 12:44:00.798	t
787	23	288	2020-09-23	18:30:00	19:00:00	\N	t	f	PATIENT	288	\N	\N	30	onlineCollection	online	notCompleted	2020-08-28 13:34:55.347	t
788	8	288	2020-09-25	19:00:00	19:30:00	\N	t	f	PATIENT	288	\N	\N	30	onlineCollection	online	notCompleted	2020-08-28 13:37:35.974	t
789	5	288	2020-09-22	14:50:00	15:00:00	\N	t	f	PATIENT	288	\N	\N	10	onlineCollection	online	notCompleted	2020-08-28 13:38:52.988	t
790	5	151	2020-08-28	17:59:00	18:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:41:04.653	t
784	5	151	2020-08-28	17:59:00	18:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:31:49.207	t
786	5	282	2020-08-28	19:09:00	19:19:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:34:01.321	t
760	5	162	2020-08-28	18:19:00	18:49:00	\N	f	t	PATIENT	162	DOCTOR	32	30	directPayment	online	completed	2020-08-27 19:14:11.25	t
783	5	282	2020-08-28	19:09:00	19:19:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:29:26.633	t
791	5	282	2020-08-28	18:09:00	18:19:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:41:24.725	t
795	5	151	2020-08-28	18:09:00	18:19:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:53:41.245	t
763	5	281	2020-08-29	10:00:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-27 20:39:16.575	t
798	5	1	2020-08-28	17:49:00	17:59:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:54:17.955	t
794	5	288	2020-08-28	18:49:00	18:59:00	\N	f	t	PATIENT	288	DOCTOR	32	10	onlineCollection	online	completed	2020-08-28 13:49:15.092	t
796	5	288	2020-08-28	18:09:00	18:19:00	\N	f	t	PATIENT	288	DOCTOR	32	10	onlineCollection	online	completed	2020-08-28 13:53:55.468	t
793	5	288	2020-08-28	17:59:00	18:09:00	\N	f	t	PATIENT	288	DOCTOR	32	10	onlineCollection	online	completed	2020-08-28 13:44:25.85	t
801	5	282	2020-08-28	17:49:00	17:59:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:58:59.585	t
802	5	162	2020-08-28	18:59:00	19:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:59:18.272	t
799	5	288	2020-08-28	19:09:00	19:19:00	\N	f	t	PATIENT	288	DOCTOR	32	10	onlineCollection	online	completed	2020-08-28 13:55:47.872	t
805	5	162	2020-08-28	18:49:00	18:59:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 14:03:45.228	t
767	5	282	2020-08-29	10:30:00	11:00:00	\N	f	t	PATIENT	282	ADMIN	53	30	directPayment	online	notCompleted	2020-08-28 10:28:47.914	t
770	5	282	2020-09-07	15:00:00	15:30:00	\N	f	t	PATIENT	282	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-28 10:57:40.14	t
765	5	282	2020-09-01	09:00:00	09:30:00	\N	t	f	PATIENT	282	\N	\N	30	directPayment	online	completed	2020-08-28 10:09:38.794	t
766	5	282	2020-09-01	09:30:00	10:00:00	\N	t	f	PATIENT	282	\N	\N	30	directPayment	online	completed	2020-08-28 10:23:10.115	t
771	5	282	2020-09-07	15:30:00	16:00:00	\N	t	f	PATIENT	282	\N	\N	30	directPayment	online	completed	2020-08-28 11:01:10.618	t
806	10	288	2020-09-29	17:00:00	17:30:00	\N	t	f	PATIENT	288	\N	\N	30	onlineCollection	online	notCompleted	2020-08-28 14:05:47.988	t
1244	6	257	2020-09-08	14:30:00	15:15:00	\N	t	f	PATIENT	\N	\N	\N	45	directPayment	online	notCompleted	2020-09-08 21:28:52.753	t
804	5	282	2020-08-28	17:49:00	17:59:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 14:03:23.059	t
800	5	151	2020-08-28	18:09:00	18:19:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 13:58:34.516	t
808	8	288	2020-09-19	11:30:00	12:00:00	\N	t	f	PATIENT	288	\N	\N	30	onlineCollection	online	notCompleted	2020-08-28 14:08:57.428	t
832	5	105	2020-08-29	12:15:00	13:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-29 05:33:05.541	t
811	4	284	2020-08-28	18:00:00	18:15:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-28 14:24:12.364	t
812	4	244	2020-08-28	20:15:00	20:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-28 14:24:41.263	t
833	22	291	2020-08-29	16:30:00	17:00:00	\N	t	f	PATIENT	291	\N	\N	30	onlineCollection	online	notCompleted	2020-08-29 06:40:03.039	t
809	5	282	2020-08-28	17:49:00	17:59:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 14:09:11.963	t
807	5	151	2020-08-28	18:09:00	18:19:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 14:08:39.901	t
834	5	293	2020-08-29	10:00:00	10:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-29 08:32:54.139	t
810	5	162	2020-08-28	18:59:00	19:09:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	completed	2020-08-28 14:09:40.14	t
813	5	281	2020-08-31	19:00:00	19:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-28 15:04:32.628	t
815	5	151	2020-08-28	18:09:00	18:19:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	completed	2020-08-28 15:16:56.684	t
835	5	296	2020-08-29	17:30:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-29 08:46:59.868	t
818	5	5	2020-08-29	00:40:00	00:50:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-08-28 15:57:08.201	t
838	5	162	2020-08-29	11:20:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-29 09:05:21.87	t
822	5	1	2020-08-28	22:30:00	22:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 17:04:03.412	t
840	5	300	2020-08-29	11:10:00	11:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-29 09:08:09.708	t
821	5	288	2020-08-28	22:00:00	22:10:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 16:24:07.585	t
817	5	142	2020-08-28	19:09:00	19:19:00	\N	f	t	DOCTOR	32	ADMIN	53	10	directPayment	online	completed	2020-08-28 15:17:38.669	t
826	5	162	2020-08-28	17:49:00	18:34:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-28 18:05:39.41	t
827	5	288	2020-08-28	17:49:00	18:34:00	\N	t	f	PATIENT	\N	\N	\N	45	directPayment	online	notCompleted	2020-08-28 18:14:01.739	t
828	5	162	2020-08-28	21:00:00	21:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	notCompleted	2020-08-28 20:29:48.536	t
823	5	127	2020-08-28	22:20:00	22:30:00	\N	f	t	PATIENT	127	DOCTOR	32	10	onlineCollection	online	completed	2020-08-28 17:05:41.701	t
829	5	127	2020-08-31	19:45:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-28 20:44:41.853	t
830	5	162	2020-08-28	21:00:00	21:45:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-28 20:45:12.261	t
831	5	162	2020-08-28	21:45:00	22:30:00	\N	t	f	DOCTOR	32	\N	\N	45	directPayment	online	notCompleted	2020-08-28 20:46:24.918	t
825	5	162	2020-08-29	00:00:00	00:10:00	\N	f	t	DOCTOR	32	PATIENT	\N	10	directPayment	online	notCompleted	2020-08-28 17:13:57.431	t
824	5	162	2020-08-29	00:50:00	01:00:00	\N	f	t	DOCTOR	32	PATIENT	\N	10	directPayment	online	notCompleted	2020-08-28 17:12:13.883	t
814	5	162	2020-09-07	16:00:00	16:10:00	\N	f	t	PATIENT	162	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-08-28 15:05:01.627	t
841	5	301	2020-08-29	11:30:00	11:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-29 09:08:22.087	t
839	5	119	2020-08-29	11:00:00	11:10:00	\N	f	t	DOCTOR	32	ADMIN	53	10	directPayment	online	notCompleted	2020-08-29 09:05:46.958	t
837	5	140	2020-08-29	10:50:00	11:00:00	\N	f	t	DOCTOR	32	ADMIN	53	10	directPayment	online	notCompleted	2020-08-29 09:03:45.239	t
842	5	254	2020-08-29	11:00:00	11:10:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-08-29 09:09:34.502	t
843	5	283	2020-08-29	10:50:00	11:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-29 09:21:02.088	t
844	5	5	2020-08-29	16:10:00	16:20:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-29 15:11:57.879	t
845	1	162	2020-08-29	18:45:00	19:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-29 09:55:55.4	t
846	5	5	2020-08-29	11:00:00	11:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-08-29 10:28:54.916	t
847	5	5	2020-08-29	16:30:00	16:40:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-08-29 10:37:42.951	t
848	5	5	2020-08-29	16:40:00	16:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-29 10:55:29.571	t
849	5	320	2020-08-29	16:20:00	16:30:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-08-29 16:29:40.322	t
850	21	319	2020-08-29	16:30:00	17:00:00	\N	t	f	PATIENT	319	\N	\N	30	onlineCollection	online	notCompleted	2020-08-29 11:00:28.048	t
851	21	319	2020-09-15	16:00:00	16:30:00	\N	t	f	PATIENT	319	\N	\N	30	onlineCollection	online	notCompleted	2020-08-29 11:01:29.736	t
852	5	162	2020-09-01	11:50:00	12:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-08-29 12:29:15.502	t
854	5	162	2020-08-31	22:00:00	22:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-29 12:58:11.393	t
855	5	5	2020-08-29	22:00:00	22:10:00	\N	t	f	PATIENT	5	\N	\N	10	onlineCollection	online	notCompleted	2020-08-29 13:32:59.894	t
856	5	5	2020-08-29	16:00:00	16:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-08-29 14:41:51.302	t
857	5	324	2020-08-31	19:10:00	19:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-29 14:46:54.239	t
858	5	5	2020-08-30	22:10:00	22:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-08-30 08:53:58.86	t
859	5	5	2020-08-30	19:30:00	19:40:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-08-30 08:56:34.698	t
836	5	1	2020-09-01	13:00:00	13:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	45	directPayment	online	completed	2020-08-29 08:49:38.461	t
820	5	288	2020-09-01	11:10:00	11:20:00	\N	t	f	PATIENT	288	\N	\N	10	onlineCollection	online	completed	2020-08-28 16:14:20.25	t
853	5	162	2020-09-04	09:10:00	09:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-08-29 12:30:51.301	t
816	5	1	2020-08-28	18:49:00	18:59:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-28 15:17:12.335	t
860	5	5	2020-08-31	20:30:00	20:40:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-08-30 09:06:14.916	t
861	5	5	2020-09-02	02:00:00	02:10:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	notCompleted	2020-08-30 09:26:58.035	t
862	3	309	2020-08-30	17:30:00	17:45:00	\N	t	f	DOCTOR	30	\N	\N	15	directPayment	online	completed	2020-08-30 10:39:19.339	t
866	5	5	2020-09-02	10:00:00	10:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-08-30 10:56:22.271	t
819	5	288	2020-09-01	11:10:00	11:20:00	\N	f	t	PATIENT	288	DOCTOR	32	10	onlineCollection	online	notCompleted	2020-08-28 16:14:20.25	t
868	5	288	2020-09-03	10:40:00	10:50:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-08-30 14:48:45.689	t
863	3	105	2020-08-30	17:45:00	18:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 10:39:30.984	t
864	3	277	2020-08-30	18:00:00	18:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 10:39:41.541	t
865	3	277	2020-08-30	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 10:40:02.357	t
890	5	5	2020-08-31	19:20:00	19:30:00	\N	f	t	PATIENT	5	DOCTOR	32	10	onlineCollection	online	notCompleted	2020-08-31 11:51:01.634	t
881	3	88	2020-08-30	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 18:01:38.678	t
878	3	105	2020-08-30	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-08-30 18:01:11.845	t
879	3	216	2020-08-30	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 18:01:20.673	t
880	3	140	2020-08-30	19:00:00	19:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 18:01:29.806	t
869	3	324	2020-08-30	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 17:48:50.443	t
870	3	323	2020-08-30	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-08-30 17:49:02.322	t
871	3	206	2020-08-30	19:00:00	19:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-08-30 17:49:14.993	t
872	3	151	2020-08-30	19:15:00	19:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-08-30 17:49:37.184	t
873	3	324	2020-08-30	17:45:00	18:00:00	\N	t	f	DOCTOR	30	\N	\N	15	directPayment	online	completed	2020-08-30 17:56:20.391	t
882	3	162	2020-08-30	19:15:00	19:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 18:01:47.653	t
874	3	142	2020-08-30	18:00:00	18:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 17:56:29	t
877	3	105	2020-08-30	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 17:57:03.838	t
876	3	149	2020-08-30	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 17:56:54.473	t
875	3	140	2020-08-30	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 17:56:42.293	t
893	5	5	2020-08-31	22:10:00	22:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-31 13:00:36.903	t
769	5	282	2020-08-31	15:00:00	15:30:00	\N	f	t	PATIENT	282	DOCTOR	32	30	directPayment	online	notCompleted	2020-08-28 10:51:19.55	t
894	5	282	2020-08-31	22:20:00	22:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-31 13:03:29.873	t
892	5	5	2020-08-31	20:30:00	20:40:00	\N	f	t	PATIENT	5	DOCTOR	32	10	onlineCollection	online	notCompleted	2020-08-31 11:51:54.636	t
895	5	5	2020-08-31	19:30:00	19:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-31 13:04:38.186	t
886	3	142	2020-08-30	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-08-30 18:09:45.992	t
883	3	181	2020-08-30	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 18:09:05.89	t
884	3	151	2020-08-30	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 18:09:19.588	t
885	3	162	2020-08-30	19:00:00	19:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-08-30 18:09:31.42	t
905	5	309	2020-09-01	14:10:00	14:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-01 12:57:02.868	t
888	5	277	2020-09-01	11:30:00	11:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	notRequired	online	notCompleted	2020-08-30 18:17:28.401	t
889	5	277	2020-09-02	02:30:00	02:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-30 18:17:58.683	t
891	5	5	2020-08-31	19:20:00	19:30:00	\N	f	t	PATIENT	5	DOCTOR	32	10	onlineCollection	online	notCompleted	2020-08-31 11:51:01.635	t
896	5	5	2020-08-31	20:30:00	20:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-08-31 13:05:34.082	t
897	5	1	2020-09-01	11:30:00	11:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-01 11:10:18	t
900	5	5	2020-09-01	11:40:00	11:50:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	completed	2020-09-01 09:07:51.47	t
898	5	5	2020-09-01	11:20:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	completed	2020-09-01 11:27:34	t
899	5	5	2020-09-01	11:40:00	11:50:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-01 09:07:51.469	t
887	5	206	2020-09-01	11:30:00	11:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-08-30 18:16:56.676	t
901	5	150	2020-09-03	10:10:00	10:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-01 12:14:10.708	t
904	5	309	2020-09-01	14:10:00	14:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-01 12:57:02.861	t
906	5	150	2020-09-01	14:30:00	14:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-01 14:26:46.682	t
903	5	150	2020-09-01	19:00:00	19:10:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-09-01 12:16:12.827	t
867	2	151	2020-09-03	14:00:00	14:15:00	\N	f	t	PATIENT	151	PATIENT	\N	15	directPayment	online	notCompleted	2020-08-30 12:41:06.552	t
907	5	5	2020-09-01	18:20:00	18:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-01 20:58:36	t
908	5	5	2020-09-02	10:10:00	10:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-01 18:28:32.135	t
909	5	162	2020-09-04	09:50:00	10:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-01 18:39:05.806	t
912	5	309	2020-09-05	00:20:00	00:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-01 19:10:49.394	t
913	5	5	2020-09-02	10:40:00	10:50:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 10:49:42.853	t
914	5	5	2020-09-02	10:40:00	10:50:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 10:49:42.854	t
915	1	5	2020-09-07	05:04:00	05:49:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	2020-09-02 10:51:49.397	t
917	1	5	2020-09-07	00:34:00	01:19:00	\N	f	t	PATIENT	5	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-02 10:54:26.927	t
919	1	5	2020-09-14	05:04:00	05:49:00	\N	f	t	PATIENT	5	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-02 11:00:06.014	t
925	1	5	2020-09-07	02:49:00	03:34:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	2020-09-02 11:16:22.638	t
926	1	5	2020-09-07	02:49:00	03:34:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	notCompleted	2020-09-02 11:16:22.64	t
920	5	327	2020-09-02	11:00:00	11:10:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-02 11:04:32.681	t
927	5	327	2020-09-02	11:20:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-02 11:25:49.757	t
928	5	327	2020-09-02	17:20:00	17:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-02 11:26:34.054	t
929	5	1	2020-09-02	11:20:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-02 11:27:32.284	t
930	5	1	2020-09-02	11:30:00	11:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-02 11:29:20.053	t
931	5	1	2020-09-02	17:00:00	17:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-02 11:30:48.813	t
932	5	162	2020-09-02	21:00:00	21:10:00	\N	t	f	PATIENT	162	\N	\N	10	onlineCollection	online	notCompleted	2020-09-02 12:06:03.128	t
933	5	162	2020-09-02	21:00:00	21:10:00	\N	t	f	PATIENT	162	\N	\N	10	onlineCollection	online	notCompleted	2020-09-02 12:06:03.128	t
942	5	5	2020-09-02	17:10:00	17:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 13:18:57.404	t
943	5	5	2020-09-02	17:10:00	17:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 13:18:57.406	t
944	5	151	2020-09-02	17:30:00	17:40:00	\N	t	f	PATIENT	151	\N	\N	10	directPayment	online	notCompleted	2020-09-02 13:20:28.264	t
945	5	137	2020-09-14	20:10:00	20:20:00	\N	t	f	PATIENT	137	\N	\N	10	onlineCollection	online	notCompleted	2020-09-02 19:26:13.853	t
947	5	276	2020-09-03	10:20:00	10:30:00	\N	t	f	DOCTOR	32	\N	\N	10	notRequired	online	notCompleted	2020-09-02 13:59:19.617	t
940	5	5	2020-09-02	20:00:00	20:10:00	\N	t	t	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 18:10:04.397	t
941	5	5	2020-09-02	20:10:00	20:20:00	\N	t	t	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 18:13:50.804	t
956	5	5	2020-09-02	17:50:00	18:00:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 16:19:24.769	t
957	5	5	2020-09-02	17:50:00	18:00:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 16:19:24.771	t
958	5	5	2020-09-02	20:00:00	20:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 16:20:02.794	t
959	5	5	2020-09-02	20:00:00	20:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 16:20:02.797	t
960	5	5	2020-09-02	17:40:00	17:50:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 16:40:59.719	t
961	5	5	2020-09-02	17:40:00	17:50:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-02 16:40:59.72	t
918	1	5	2020-09-14	05:04:00	05:49:00	\N	f	t	PATIENT	5	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-02 11:00:06.011	t
955	5	5	2020-09-11	17:49:00	17:59:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 14:41:08.07	t
923	1	5	2020-09-21	05:49:00	06:34:00	\N	f	t	PATIENT	5	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-02 11:14:06.838	t
910	5	162	2020-09-04	09:40:00	09:50:00	\N	f	t	DOCTOR	32	ADMIN	53	10	directPayment	online	notCompleted	2020-09-01 18:40:05.397	t
953	5	5	2020-09-05	00:00:00	00:10:00	\N	f	t	PATIENT	5	ADMIN	53	10	directPayment	online	notCompleted	2020-09-02 14:15:22.081	t
952	5	5	2020-09-05	00:00:00	00:10:00	\N	f	t	PATIENT	5	ADMIN	53	10	directPayment	online	notCompleted	2020-09-02 14:15:22.08	t
950	5	298	2020-09-08	09:50:00	10:00:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-09-02 14:12:49.239	t
935	5	162	2020-09-09	20:50:00	21:00:00	\N	f	t	PATIENT	162	ADMIN	53	10	onlineCollection	online	notCompleted	2020-09-02 12:12:43.001	t
916	1	5	2020-09-07	00:34:00	01:19:00	\N	f	t	PATIENT	5	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-02 10:54:26.926	t
924	1	5	2020-09-07	02:04:00	02:49:00	\N	f	t	PATIENT	5	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-02 11:15:59.866	t
962	5	5	2020-09-14	19:00:00	19:10:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 17:16:32.137	t
954	5	5	2020-09-11	17:49:00	17:59:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 14:41:08.069	t
963	5	5	2020-09-15	09:00:00	09:10:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 17:19:41.727	t
966	5	5	2020-09-15	09:10:00	09:20:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 17:20:42.157	t
921	1	5	2020-09-21	05:04:00	05:49:00	\N	f	t	PATIENT	5	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-02 11:11:26.667	t
951	5	298	2020-09-04	09:20:00	09:30:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	notCompleted	2020-09-02 14:13:09.242	t
911	5	162	2020-09-04	09:40:00	09:50:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-01 18:40:05.396	t
934	5	162	2020-09-09	20:50:00	21:00:00	\N	f	t	PATIENT	162	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-09-02 12:12:42.999	t
937	5	162	2020-09-16	11:00:00	11:10:00	\N	f	t	PATIENT	162	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-09-02 12:14:03.419	t
949	5	298	2020-09-08	09:50:00	10:00:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	notCompleted	2020-09-02 14:12:49.239	t
964	5	5	2020-09-15	09:00:00	09:10:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 17:19:41.729	t
938	5	5	2020-09-07	20:00:00	20:10:00	\N	f	t	PATIENT	5	DOCTOR	32	10	directPayment	online	completed	2020-09-02 12:28:48.307	t
965	5	5	2020-09-15	09:10:00	09:20:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 17:20:42.156	t
922	1	5	2020-09-21	05:49:00	06:34:00	\N	f	t	PATIENT	5	DOCTOR	28	45	directPayment	online	notCompleted	2020-09-02 11:14:06.837	t
946	5	137	2020-09-14	20:10:00	20:20:00	\N	t	f	PATIENT	137	\N	\N	10	onlineCollection	online	paused	2020-09-02 19:26:13.911	t
968	5	5	2020-09-05	10:00:00	10:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-02 22:59:37.295	t
973	5	5	2020-09-02	20:10:00	20:20:00	\N	t	f	PATIENT	5	\N	\N	10	onlineCollection	online	notCompleted	2020-09-02 18:28:54.556	t
974	5	5	2020-09-02	20:10:00	20:20:00	\N	t	f	PATIENT	5	\N	\N	10	onlineCollection	online	notCompleted	2020-09-02 18:28:54.557	t
948	5	298	2020-09-03	10:30:00	10:40:00	\N	f	t	ADMIN	53	DOCTOR	32	\N	directPayment	online	notCompleted	2020-09-02 14:12:18.409	t
976	5	298	2020-09-03	10:00:00	10:10:00	\N	f	t	DOCTOR	32	ADMIN	53	10	directPayment	online	notCompleted	2020-09-02 19:19:27.781	t
939	5	5	2020-09-07	20:00:00	20:10:00	\N	f	t	PATIENT	5	ADMIN	53	10	directPayment	online	notCompleted	2020-09-02 12:28:48.309	t
983	5	5	2020-09-03	15:30:00	16:00:00	\N	t	f	PATIENT	5	\N	\N	30	onlineCollection	online	completed	2020-09-03 09:42:36.23	t
979	5	1	2020-09-03	11:00:00	11:10:00	\N	f	t	ADMIN	53	ADMIN	53	10	directPayment	online	notCompleted	2020-09-03 02:44:02.828	t
980	5	1	2020-09-03	11:10:00	11:20:00	\N	f	t	ADMIN	53	ADMIN	53	10	directPayment	online	notCompleted	2020-09-03 02:49:59.031	t
970	5	5	2020-09-16	02:10:00	02:20:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 23:33:40.355	t
971	5	5	2020-09-17	10:00:00	10:10:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 23:46:57.281	t
1004	4	150	2020-09-07	10:00:00	10:30:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	notCompleted	2020-09-03 12:51:16.271	t
975	5	298	2020-09-03	10:00:00	10:10:00	\N	f	t	DOCTOR	32	ADMIN	53	10	directPayment	online	completed	2020-09-02 19:19:27.783	t
981	5	335	2020-09-03	10:50:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	inHospital	completed	2020-09-03 08:57:16.365	t
1005	4	150	2020-09-07	10:00:00	10:30:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	notCompleted	2020-09-03 12:51:16.274	t
985	5	127	2020-09-03	18:00:00	18:30:00	\N	t	f	PATIENT	127	\N	\N	30	onlineCollection	online	completed	2020-09-03 09:47:52.316	t
977	5	1	2020-09-03	10:30:00	10:40:00	\N	t	f	ADMIN	53	\N	\N	10	directPayment	online	completed	2020-09-03 02:00:25.242	t
902	5	327	2020-09-03	10:30:00	10:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	notRequired	online	completed	2020-09-01 12:15:50.727	t
995	4	150	2020-09-03	16:30:00	17:00:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	notCompleted	2020-09-03 11:05:22.707	t
982	5	5	2020-09-03	15:30:00	16:00:00	\N	t	f	PATIENT	5	\N	\N	30	onlineCollection	online	completed	2020-09-03 09:42:36.229	t
991	5	5	2020-09-03	19:00:00	19:30:00	\N	f	t	PATIENT	5	DOCTOR	32	30	onlineCollection	online	completed	2020-09-03 10:15:39.153	t
993	5	5	2020-09-03	19:30:00	20:00:00	\N	f	t	PATIENT	5	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 10:17:16.75	t
989	5	162	2020-09-10	14:00:00	14:30:00	\N	f	t	PATIENT	162	DOCTOR	32	30	onlineCollection	online	notCompleted	2020-09-03 10:05:47.474	t
978	5	5	2020-09-03	10:40:00	10:50:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	completed	2020-09-03 02:40:04.216	t
996	4	150	2020-09-03	16:30:00	17:00:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	notCompleted	2020-09-03 11:05:22.709	t
997	4	150	2020-09-06	09:00:00	09:30:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	notCompleted	2020-09-03 11:08:11.111	t
994	5	5	2020-09-03	18:30:00	19:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	completed	2020-09-03 15:56:55.903	t
967	5	139	2020-09-05	00:10:00	00:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	notRequired	online	notCompleted	2020-09-02 17:23:32.166	t
990	5	5	2020-09-03	19:00:00	19:30:00	\N	t	f	PATIENT	5	\N	\N	30	onlineCollection	online	completed	2020-09-03 10:15:39.151	t
1000	5	127	2020-09-03	15:00:00	15:20:00	\N	t	f	PATIENT	127	\N	\N	20	onlineCollection	online	notCompleted	2020-09-03 12:09:27.059	t
1001	5	1	2020-09-03	20:00:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 17:46:59.631	t
998	4	162	2020-09-03	17:00:00	17:30:00	\N	f	t	PATIENT	162	ADMIN	53	30	directPayment	online	completed	2020-09-03 11:12:02.663	t
1010	5	298	2020-09-03	13:00:00	13:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 13:12:09.496	t
1009	5	139	2020-09-03	14:00:00	14:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-09-03 13:11:14.715	t
1012	5	139	2020-09-03	14:00:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 13:12:49.969	t
1011	5	139	2020-09-03	13:30:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 13:12:21.919	t
1002	5	5	2020-09-03	20:30:00	21:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-09-03 12:21:19.04	t
1015	1	105	2020-09-05	09:00:00	09:45:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-09-03 13:48:38.49	t
936	5	162	2020-09-16	11:00:00	11:10:00	\N	f	t	PATIENT	162	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-09-02 12:14:03.419	t
1008	5	298	2020-09-03	13:30:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	completed	2020-09-03 13:10:49.588	t
1017	5	1	2020-09-03	21:00:00	21:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 19:59:51.069	t
984	5	127	2020-09-03	18:00:00	18:30:00	\N	f	t	PATIENT	127	DOCTOR	32	30	onlineCollection	online	completed	2020-09-03 09:47:52.316	t
1013	5	139	2020-09-03	14:00:00	14:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-09-03 13:12:49.97	t
1016	5	162	2020-09-03	14:30:00	15:00:00	\N	t	f	PATIENT	162	\N	\N	30	onlineCollection	online	completed	2020-09-03 14:03:10.93	t
999	5	127	2020-09-03	15:00:00	15:20:00	\N	t	f	PATIENT	127	\N	\N	20	onlineCollection	online	completed	2020-09-03 12:09:27.059	t
1018	5	1	2020-09-03	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 14:33:48.848	t
988	5	162	2020-09-10	14:00:00	14:30:00	\N	f	t	PATIENT	162	PATIENT	\N	30	onlineCollection	online	notCompleted	2020-09-03 10:05:47.475	t
986	5	162	2020-09-15	20:00:00	20:30:00	\N	f	t	PATIENT	162	PATIENT	\N	30	onlineCollection	online	notCompleted	2020-09-03 09:59:21.282	t
1003	5	5	2020-09-03	20:30:00	21:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 12:21:19.043	t
1014	1	105	2020-09-05	09:00:00	09:45:00	\N	f	t	ADMIN	53	DOCTOR	28	\N	directPayment	online	notCompleted	2020-09-03 13:48:38.488	t
1006	6	150	2020-09-10	11:00:00	12:00:00	\N	f	t	PATIENT	150	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-03 12:54:00.223	t
1007	6	150	2020-09-10	11:00:00	12:00:00	\N	f	t	PATIENT	150	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-03 12:54:00.225	t
972	5	5	2020-09-18	09:00:00	09:10:00	\N	f	t	PATIENT	5	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-02 23:49:27.585	t
969	5	5	2020-09-16	02:00:00	02:10:00	\N	f	t	PATIENT	5	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-02 23:24:42.391	t
1019	5	1	2020-09-04	09:30:00	10:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 14:34:36.117	t
1021	5	1	2020-09-04	10:00:00	10:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 14:40:46.48	t
1023	5	1	2020-09-04	11:30:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 14:42:12.841	t
1025	5	5	2020-09-04	11:00:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 14:56:58.344	t
1026	5	5	2020-09-04	12:00:00	12:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 14:58:13.613	t
1028	5	5	2020-09-04	12:30:00	13:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 14:58:56.041	t
1033	5	1	2020-09-04	13:00:00	13:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 22:11:10.329	t
1035	5	5	2020-09-04	17:49:00	18:19:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 22:12:30.957	t
1036	5	5	2020-09-04	18:19:00	18:49:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 22:13:13.315	t
1037	5	5	2020-09-04	18:49:00	19:19:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 22:18:22.3	t
1038	5	5	2020-09-04	19:19:00	19:49:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 22:18:54.383	t
1039	5	5	2020-09-04	21:00:00	21:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 22:19:33.227	t
1041	2	206	2020-09-04	09:00:00	09:15:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-03 17:29:55.999	t
1042	2	206	2020-09-04	09:15:00	09:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-03 17:31:26.164	t
1043	2	206	2020-09-04	09:15:00	09:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-03 17:31:26.166	t
1020	5	1	2020-09-04	09:30:00	10:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 14:34:36.12	t
1044	5	1	2020-09-04	09:00:00	09:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 17:40:50.541	t
992	5	5	2020-09-03	19:30:00	20:00:00	\N	f	t	PATIENT	5	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 10:17:16.748	t
1046	5	5	2020-09-03	09:00:00	09:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 17:42:25.852	t
1047	1	151	2020-09-04	02:00:00	02:45:00	\N	f	t	DOCTOR	28	DOCTOR	28	45	notRequired	online	notCompleted	2020-09-03 17:42:45.665	t
987	5	162	2020-09-10	10:00:00	10:30:00	\N	f	t	PATIENT	162	PATIENT	\N	30	onlineCollection	online	notCompleted	2020-09-03 10:04:18.174	t
1048	4	151	2020-09-03	17:30:00	18:00:00	\N	t	f	DOCTOR	31	\N	\N	30	notRequired	online	completed	2020-09-03 17:47:16.571	t
1049	4	151	2020-09-03	18:00:00	18:30:00	\N	t	f	DOCTOR	31	\N	\N	30	notRequired	online	notCompleted	2020-09-03 18:03:58.16	t
1050	4	151	2020-09-03	18:00:00	18:30:00	\N	t	f	DOCTOR	31	\N	\N	30	notRequired	online	notCompleted	2020-09-03 18:03:58.163	t
1029	5	162	2020-09-11	10:00:00	10:30:00	\N	f	t	DOCTOR	32	PATIENT	\N	30	directPayment	online	notCompleted	2020-09-03 15:34:23.573	t
1030	5	162	2020-09-11	10:00:00	10:30:00	\N	f	t	DOCTOR	32	PATIENT	\N	30	directPayment	online	notCompleted	2020-09-03 15:34:23.575	t
1056	6	162	2020-09-03	22:00:00	23:00:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	notCompleted	2020-09-03 20:12:39.873	t
1057	5	162	2020-09-05	12:30:00	13:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 20:18:10.964	t
1052	4	151	2020-09-03	18:30:00	19:00:00	\N	f	t	DOCTOR	31	DOCTOR	31	30	directPayment	online	completed	2020-09-03 18:38:00.875	t
1051	4	151	2020-09-03	18:30:00	19:00:00	\N	f	t	DOCTOR	31	DOCTOR	31	30	directPayment	online	completed	2020-09-03 18:38:00.874	t
1053	4	151	2020-09-03	19:30:00	20:00:00	\N	t	f	DOCTOR	31	\N	\N	30	notRequired	online	notCompleted	2020-09-03 18:43:32.956	t
1054	4	151	2020-09-03	19:30:00	20:00:00	\N	t	f	DOCTOR	31	\N	\N	30	notRequired	online	notCompleted	2020-09-03 18:43:32.966	t
1045	5	1	2020-09-03	21:30:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 17:41:40.258	t
1055	5	162	2020-09-03	21:30:00	22:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-09-03 20:06:54.845	t
1032	5	162	2020-09-06	12:00:00	12:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 16:24:30.86	t
1031	5	162	2020-09-06	12:00:00	12:30:00	\N	f	t	DOCTOR	32	PATIENT	\N	30	directPayment	online	notCompleted	2020-09-03 16:24:30.858	t
1022	5	1	2020-09-04	10:30:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 14:41:34.45	t
1058	6	215	2020-09-03	20:00:00	21:00:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	notCompleted	2020-09-03 20:23:03.224	t
1062	5	162	2020-09-04	22:30:00	23:00:00	\N	t	f	PATIENT	162	\N	\N	30	onlineCollection	online	notCompleted	2020-09-03 20:34:27.195	t
1063	5	162	2020-09-04	22:30:00	23:00:00	\N	t	f	PATIENT	162	\N	\N	30	onlineCollection	online	notCompleted	2020-09-03 20:34:27.195	t
1034	5	5	2020-09-04	13:30:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-09-03 22:11:51.135	t
1024	5	5	2020-09-04	11:00:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-09-03 14:56:58.34	t
1059	6	337	2020-09-06	09:00:00	10:00:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-03 20:24:16.627	t
1027	5	5	2020-09-04	12:00:00	12:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	completed	2020-09-03 14:58:13.615	t
1061	6	162	2020-09-06	10:00:00	11:00:00	\N	f	t	PATIENT	162	DOCTOR	33	60	onlineCollection	online	notCompleted	2020-09-03 20:29:49.786	t
1067	6	297	2020-09-05	16:22:00	17:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 11:14:59.868	t
1068	6	299	2020-09-05	17:22:00	18:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 11:15:14.909	t
1069	6	339	2020-09-05	16:22:00	17:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 11:16:27.759	t
1070	6	339	2020-09-04	17:22:00	18:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 11:16:36.132	t
1040	5	5	2020-09-05	10:30:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-09-03 22:20:28.191	t
1071	6	341	2020-09-05	16:22:00	17:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 11:33:57.393	t
1066	6	298	2020-09-05	15:22:00	16:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 11:10:31.108	t
1060	6	162	2020-09-06	10:00:00	11:00:00	\N	f	t	PATIENT	162	DOCTOR	33	60	onlineCollection	online	notCompleted	2020-09-03 20:29:49.786	t
1064	6	337	2020-09-04	15:14:00	16:14:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	completed	2020-09-04 11:08:04.303	t
1065	6	162	2020-09-04	16:14:00	17:14:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 11:08:17.923	t
1072	6	337	2020-09-04	16:14:00	17:14:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 11:37:37.804	t
1074	6	341	2020-09-04	16:14:00	17:14:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 11:40:31.044	t
1097	6	351	2020-09-05	15:22:00	16:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 16:46:36.331	t
1079	5	5	2020-09-04	21:30:00	22:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-09-04 12:28:33.831	t
1080	5	5	2020-09-04	21:30:00	22:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-09-04 12:28:33.833	t
1075	6	341	2020-09-04	15:14:00	16:14:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	completed	2020-09-04 11:41:01.274	t
1077	6	298	2020-09-04	15:14:00	16:14:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	completed	2020-09-04 11:41:23.127	t
1104	6	351	2020-09-05	16:22:00	17:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-05 10:22:34.98	t
1078	6	162	2020-09-04	15:14:00	16:14:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	completed	2020-09-04 11:41:50.736	t
1105	6	351	2020-09-05	15:22:00	16:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-05 10:22:48.733	t
1073	6	337	2020-09-04	15:14:00	16:14:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	completed	2020-09-04 11:40:05.895	t
1106	6	351	2020-09-05	17:22:00	18:22:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	notCompleted	2020-09-05 10:22:58.06	t
1076	6	341	2020-09-04	16:14:00	17:14:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	completed	2020-09-04 11:41:06.941	t
1081	22	344	2020-09-05	16:00:00	16:30:00	\N	t	f	PATIENT	344	\N	\N	30	directPayment	online	notCompleted	2020-09-04 12:51:15.466	t
1082	19	344	2020-09-05	08:00:00	08:30:00	\N	t	f	PATIENT	344	\N	\N	30	directPayment	online	notCompleted	2020-09-04 12:53:39.036	t
1083	21	346	2020-09-05	16:00:00	16:30:00	\N	t	f	PATIENT	346	\N	\N	30	directPayment	online	notCompleted	2020-09-04 12:55:28.087	t
1084	21	346	2020-09-05	16:00:00	16:30:00	\N	t	f	PATIENT	346	\N	\N	30	directPayment	online	notCompleted	2020-09-04 12:55:28.088	t
1085	19	346	2020-09-05	08:30:00	09:00:00	\N	t	f	PATIENT	346	\N	\N	30	directPayment	online	notCompleted	2020-09-04 12:56:11.88	t
1086	19	346	2020-09-05	08:30:00	09:00:00	\N	t	f	PATIENT	346	\N	\N	30	directPayment	online	notCompleted	2020-09-04 12:56:11.881	t
1087	10	347	2020-09-05	16:00:00	16:30:00	\N	t	f	PATIENT	347	\N	\N	30	directPayment	online	notCompleted	2020-09-04 13:16:59.021	t
1088	10	347	2020-09-05	16:00:00	16:30:00	\N	t	f	PATIENT	347	\N	\N	30	directPayment	online	notCompleted	2020-09-04 13:16:59.021	t
1089	8	350	2020-09-04	16:00:00	16:30:00	\N	t	f	PATIENT	350	\N	\N	30	directPayment	online	notCompleted	2020-09-04 13:21:17.108	t
1092	8	350	2020-09-05	09:00:00	09:30:00	\N	t	f	PATIENT	350	\N	\N	30	directPayment	online	notCompleted	2020-09-04 13:22:03.6	t
1091	6	162	2020-09-11	15:14:00	16:14:00	\N	f	t	PATIENT	162	PATIENT	\N	60	onlineCollection	online	notCompleted	2020-09-04 13:21:51.935	t
1093	6	162	2020-09-12	15:22:00	16:22:00	\N	f	t	PATIENT	\N	PATIENT	\N	60	directPayment	online	notCompleted	2020-09-04 13:22:22.294	t
1095	6	162	2020-09-19	15:22:00	16:22:00	\N	t	f	PATIENT	\N	\N	\N	60	directPayment	online	notCompleted	2020-09-04 13:25:29.304	t
1096	6	351	2020-09-05	15:22:00	16:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-04 16:46:36.333	t
1098	5	5	2020-09-04	22:00:00	22:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-04 16:50:08.333	t
1099	5	5	2020-09-04	22:00:00	22:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-04 16:50:08.339	t
1100	5	5	2020-09-04	22:10:00	22:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-04 17:40:27.722	t
1101	5	5	2020-09-04	22:10:00	22:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-09-04 17:40:27.728	t
1107	6	359	2020-09-05	16:22:00	17:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-05 10:23:40.763	t
1108	6	359	2020-09-05	15:22:00	16:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-05 10:23:47.726	t
1110	5	298	2020-09-05	11:15:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-09-05 10:27:16.349	t
1102	5	347	2020-09-05	10:15:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-09-05 10:04:01.52	t
1111	5	347	2020-09-05	11:30:00	11:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-09-05 10:27:21.996	t
1112	5	5	2020-09-05	11:45:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-09-05 10:27:28.376	t
1103	5	347	2020-09-05	11:00:00	11:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-09-05 10:07:56.242	t
1113	5	344	2020-09-05	10:15:00	10:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-09-05 10:28:23.273	t
1114	3	105	2020-09-05	15:00:00	15:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-05 10:29:19.968	t
1094	1	162	2020-09-12	10:30:00	11:15:00	\N	f	t	DOCTOR	28	DOCTOR	28	45	directPayment	online	notCompleted	2020-09-04 13:24:32.269	t
1116	6	1	2020-09-05	15:52:00	16:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 11:46:48.811	t
1117	6	1	2020-09-05	15:22:00	15:52:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 11:46:55.429	t
1120	6	150	2020-09-05	09:30:00	10:00:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	notCompleted	2020-09-05 11:49:14.579	t
1119	6	150	2020-09-05	15:22:00	15:52:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 11:47:37.589	t
1118	6	1	2020-09-05	15:52:00	16:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 11:47:24.592	t
1109	6	359	2020-09-05	16:22:00	17:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	60	directPayment	online	notCompleted	2020-09-05 10:23:53.901	t
1121	6	359	2020-09-05	15:22:00	15:52:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	notCompleted	2020-09-05 11:49:51.942	t
1090	6	162	2020-09-11	15:14:00	16:14:00	\N	f	t	PATIENT	162	DOCTOR	33	60	onlineCollection	online	notCompleted	2020-09-04 13:21:51.934	t
1124	6	360	2020-09-06	09:00:00	09:30:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	notCompleted	2020-09-05 14:08:47.233	t
1123	1	347	2020-09-08	14:00:00	14:45:00	\N	f	t	DOCTOR	28	DOCTOR	28	45	directPayment	online	notCompleted	2020-09-05 14:00:28.885	t
1125	6	282	2020-09-09	12:00:00	12:30:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 14:08:58.45	t
1126	6	1	2020-09-07	11:30:00	12:00:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 14:09:09.165	t
1122	6	162	2020-09-05	15:52:00	16:22:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 11:50:32.23	t
1127	6	1	2020-09-05	16:22:00	16:52:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 14:09:19.727	t
1129	6	1	2020-09-30	12:00:00	12:30:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	notCompleted	2020-09-05 14:09:51.36	t
1128	6	162	2020-09-23	12:00:00	12:30:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 14:09:37.852	t
1131	5	127	2020-09-05	19:00:00	20:00:00	\N	t	f	PATIENT	127	\N	\N	60	directPayment	online	notCompleted	2020-09-05 14:18:02.764	t
1132	6	162	2020-09-05	16:22:00	16:52:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 14:59:41.274	t
1134	5	277	2020-09-06	10:00:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-09-05 15:47:31.585	t
1135	5	282	2020-09-08	09:00:00	10:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-09-05 17:05:04.413	t
1136	5	282	2020-09-06	11:00:00	12:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-09-05 17:06:02.415	t
1137	5	282	2020-09-05	22:00:00	23:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-09-05 17:07:40.445	t
1138	5	282	2020-09-06	11:00:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-09-05 17:07:56.652	t
1139	5	362	2020-09-08	09:00:00	10:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-09-05 17:11:32.809	t
1140	5	5	2020-09-05	18:00:00	19:00:00	\N	f	t	PATIENT	5	DOCTOR	32	60	directPayment	online	notCompleted	2020-09-05 18:13:02.195	t
1141	5	5	2020-09-05	20:00:00	21:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-09-05 18:13:51.41	t
1142	5	5	2020-09-05	18:00:00	19:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-09-05 18:14:01.208	t
1143	5	5	2020-09-05	22:00:00	23:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-09-05 18:14:41.728	t
1150	3	151	2020-09-06	18:00:00	18:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 11:21:08.599	t
1151	3	151	2020-09-06	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 11:21:32.444	t
1144	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 10:10:30.101	t
1145	3	151	2020-09-06	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-09-06 10:10:51.042	t
1146	3	151	2020-09-06	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 10:52:58.081	t
1147	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 10:53:20.727	t
1163	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 13:42:08.47	t
1158	3	151	2020-09-06	18:00:00	18:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 12:13:39.297	t
1148	3	151	2020-09-06	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 10:59:42.015	t
1149	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 11:00:02.109	t
1159	3	151	2020-09-06	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 12:14:29.846	t
1152	3	151	2020-09-06	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 11:25:33.632	t
1153	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 11:25:54.578	t
1154	3	151	2020-09-06	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 11:38:40.184	t
1155	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 11:39:02.322	t
1165	3	151	2020-09-06	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 13:52:10.882	t
1160	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 12:32:34.614	t
1156	3	151	2020-09-06	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 11:48:59.466	t
1157	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 11:49:18.582	t
1164	3	151	2020-09-06	18:00:00	18:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 13:50:47.854	t
1161	3	151	2020-09-06	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 12:32:53.007	t
1162	3	151	2020-09-06	18:00:00	18:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-09-06 13:26:31.669	t
1166	1	151	2020-09-06	21:30:00	21:45:00	\N	f	t	DOCTOR	28	DOCTOR	28	15	notRequired	online	completed	2020-09-06 14:23:10.957	t
1167	3	151	2020-09-06	18:00:00	18:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 17:25:24.89	t
1168	3	151	2020-09-06	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 17:25:46.066	t
1170	3	151	2020-09-06	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	directPayment	online	completed	2020-09-06 17:32:59.853	t
1169	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 17:32:16.371	t
1172	3	151	2020-09-06	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 17:39:27.794	t
1171	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 17:39:06.67	t
1173	3	151	2020-09-06	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 18:06:29.671	t
1175	3	151	2020-09-06	19:30:00	19:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 18:12:34.033	t
1174	3	151	2020-09-06	19:00:00	19:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 18:06:53.647	t
1133	6	162	2020-09-08	11:00:00	11:30:00	\N	f	t	DOCTOR	33	DOCTOR	33	30	directPayment	online	notCompleted	2020-09-05 15:00:17.428	t
1176	3	151	2020-09-06	19:00:00	19:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 18:26:27.809	t
1177	3	151	2020-09-06	19:30:00	19:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-06 18:26:50.071	t
1212	5	162	2020-09-08	03:20:00	03:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-08 01:53:09.098	t
1213	2	215	2020-09-08	10:00:00	10:15:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-08 02:13:27.106	t
1179	1	151	2020-09-06	21:00:00	21:15:00	\N	f	t	DOCTOR	28	ADMIN	53	15	notRequired	online	completed	2020-09-06 18:36:05.088	t
1178	3	151	2020-09-06	19:45:00	20:00:00	\N	f	t	DOCTOR	30	ADMIN	53	15	notRequired	online	completed	2020-09-06 18:35:08.368	t
1180	6	216	2020-09-07	09:00:00	10:00:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	notCompleted	2020-09-07 09:32:59.951	t
1182	3	216	2020-09-07	12:00:00	12:15:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-09-07 09:51:02.029	t
1183	1	119	2020-09-07	09:45:00	10:00:00	\N	t	f	PATIENT	119	\N	\N	15	directPayment	online	notCompleted	2020-09-07 09:56:16.213	t
1184	6	5	2020-09-07	10:15:00	10:30:00	\N	t	f	PATIENT	5	\N	\N	15	directPayment	online	notCompleted	2020-09-07 10:20:33.21	t
1186	6	363	2020-09-07	14:00:00	14:15:00	\N	t	f	PATIENT	363	\N	\N	15	directPayment	online	notCompleted	2020-09-07 11:36:20.145	t
1191	1	162	2020-09-07	20:00:00	20:15:00	\N	t	f	PATIENT	162	\N	\N	15	onlineCollection	online	notCompleted	2020-09-07 12:04:24.132	t
1181	6	282	2020-09-07	13:00:00	14:00:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	completed	2020-09-07 09:33:11.288	t
1192	2	162	2020-09-07	21:30:00	21:45:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-07 12:52:08.161	t
1193	1	347	2020-09-07	14:00:00	14:15:00	\N	t	f	DOCTOR	28	\N	\N	15	directPayment	online	notCompleted	2020-09-07 13:05:06.747	t
1115	1	162	2020-09-12	05:00:00	05:45:00	\N	f	t	DOCTOR	28	DOCTOR	28	45	directPayment	online	notCompleted	2020-09-05 11:29:46.492	t
1194	1	162	2020-09-07	14:15:00	14:30:00	\N	t	f	DOCTOR	28	\N	\N	15	directPayment	online	notCompleted	2020-09-07 13:05:22.835	t
1195	12	5	2020-09-09	08:00:00	08:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-09-07 13:06:36.639	t
1196	12	5	2020-09-08	08:00:00	08:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-09-07 13:07:22.352	t
1185	6	5	2020-09-09	13:44:00	13:59:00	\N	f	t	PATIENT	5	DOCTOR	33	15	directPayment	online	notCompleted	2020-09-07 10:38:25.992	t
1197	6	5	2020-09-07	14:15:00	14:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-07 13:10:55.175	t
1211	2	162	2020-09-08	10:15:00	10:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	paused	2020-09-08 00:10:41.05	t
1187	6	5	2020-09-07	17:29:00	17:44:00	\N	t	f	PATIENT	5	\N	\N	15	directPayment	online	completed	2020-09-07 11:46:26.017	t
1199	5	1	2020-09-08	11:30:00	11:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-07 15:51:37.824	t
1130	5	1	2020-09-07	19:00:00	20:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	completed	2020-09-05 14:16:55.142	t
1200	1	206	2020-09-07	16:30:00	16:45:00	\N	t	f	DOCTOR	28	\N	\N	15	notRequired	online	notCompleted	2020-09-07 15:53:47.2	t
1201	1	142	2020-09-07	16:45:00	17:00:00	\N	t	f	DOCTOR	28	\N	\N	15	notRequired	online	notCompleted	2020-09-07 15:54:01.216	t
1202	1	1	2020-09-07	17:00:00	17:15:00	\N	t	f	DOCTOR	28	\N	\N	15	notRequired	online	notCompleted	2020-09-07 15:54:13.051	t
1198	5	162	2020-09-08	11:10:00	11:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-09-07 15:49:02.815	t
1203	5	1	2020-09-08	12:00:00	12:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-07 15:57:00.61	t
1204	6	365	2020-09-08	09:45:00	10:30:00	\N	t	f	PATIENT	365	\N	\N	45	onlineCollection	online	notCompleted	2020-09-07 16:05:42.421	t
1205	21	5	2020-09-08	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-09-07 16:09:23.195	t
1189	6	162	2020-09-08	09:00:00	09:15:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	directPayment	online	notCompleted	2020-09-07 12:00:36.3	t
1207	6	162	2020-09-07	10:30:00	11:15:00	\N	t	f	DOCTOR	33	\N	\N	45	directPayment	online	notCompleted	2020-09-07 16:26:30.678	t
1206	6	5	2020-09-07	16:44:00	17:29:00	\N	t	f	PATIENT	5	\N	\N	45	directPayment	online	completed	2020-09-07 16:10:11.993	t
1208	6	282	2020-09-12	22:46:00	23:31:00	\N	f	t	DOCTOR	33	DOCTOR	33	45	directPayment	online	notCompleted	2020-09-07 17:08:35.545	t
1209	6	282	2020-09-12	03:00:00	03:45:00	\N	t	f	DOCTOR	33	\N	\N	45	directPayment	online	notCompleted	2020-09-07 17:09:47.44	t
1210	21	5	2020-09-07	17:00:00	17:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-09-07 17:14:57.091	t
1214	2	162	2020-09-08	09:30:00	09:45:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-08 02:51:37.679	t
1215	1	351	2020-09-08	14:00:00	14:15:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-09-08 14:07:42.715	t
1216	1	351	2020-09-08	14:00:00	14:15:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-09-08 14:08:41.899	t
1190	6	127	2020-09-08	21:45:00	22:00:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	directPayment	online	notCompleted	2020-09-07 12:02:28.664	t
1217	6	282	2020-09-08	21:00:00	21:45:00	\N	f	t	DOCTOR	33	DOCTOR	33	45	directPayment	online	notCompleted	2020-09-08 14:40:16.758	t
1218	1	1	2020-09-08	14:45:00	15:00:00	\N	f	t	DOCTOR	28	DOCTOR	28	15	directPayment	online	notCompleted	2020-09-08 14:50:58.638	t
1219	1	1	2020-09-08	15:00:00	15:15:00	\N	f	t	DOCTOR	28	DOCTOR	28	15	directPayment	online	notCompleted	2020-09-08 14:51:58.557	t
1220	1	1	2020-09-08	14:45:00	15:00:00	\N	t	f	DOCTOR	28	\N	\N	15	directPayment	online	notCompleted	2020-09-08 14:53:12.134	t
1222	2	162	2020-09-08	16:45:00	17:00:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-08 15:54:59.954	t
1224	1	151	2020-09-08	21:00:00	21:20:00	\N	f	t	DOCTOR	28	DOCTOR	28	20	directPayment	online	completed	2020-09-08 16:08:08.482	t
1225	1	206	2020-09-08	16:20:00	16:40:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	notCompleted	2020-09-08 16:35:49.506	t
1223	1	151	2020-09-08	17:40:00	18:00:00	\N	f	t	DOCTOR	28	DOCTOR	28	20	directPayment	online	completed	2020-09-08 16:01:14.357	t
1226	1	151	2020-09-08	16:40:00	17:00:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	notCompleted	2020-09-08 16:36:40.472	t
1227	3	151	2020-09-08	18:00:00	18:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-08 17:05:50.326	t
1228	2	162	2020-09-08	19:00:00	19:15:00	\N	f	t	DOCTOR	29	DOCTOR	29	15	directPayment	online	completed	2020-09-08 17:49:04.4	t
1221	5	5	2020-09-16	02:15:00	02:30:00	\N	f	t	PATIENT	5	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-08 15:52:05.206	t
1229	2	162	2020-09-08	19:15:00	19:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	completed	2020-09-08 18:15:49.205	t
1233	6	257	2020-09-08	22:00:00	23:00:00	\N	t	f	PATIENT	257	\N	\N	60	directPayment	online	completed	2020-09-08 19:15:27.292	t
1232	6	282	2020-09-08	21:00:00	22:00:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	completed	2020-09-08 19:06:47.856	t
1230	2	162	2020-09-08	19:30:00	19:45:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	completed	2020-09-08 18:16:58.057	t
1264	2	162	2020-09-08	23:15:00	23:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	completed	2020-09-08 23:17:17.406	t
1231	2	215	2020-09-08	19:45:00	20:00:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	paused	2020-09-08 18:18:23.218	t
1237	2	215	2020-09-08	20:15:00	20:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-08 20:05:07.664	t
1255	1	151	2020-09-08	22:00:00	22:20:00	\N	f	t	DOCTOR	28	DOCTOR	28	20	notRequired	online	completed	2020-09-08 21:59:31.125	t
1236	3	151	2020-09-08	20:15:00	20:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-08 19:46:50.036	t
1238	3	151	2020-09-08	20:30:00	20:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-08 20:12:56.45	t
1235	5	151	2020-09-09	03:30:00	03:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-09-08 19:45:14.584	t
1240	3	151	2020-09-08	20:30:00	20:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-08 20:30:26.95	t
1239	3	151	2020-09-08	20:45:00	21:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-08 20:21:59.768	t
1241	3	151	2020-09-08	20:45:00	21:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-08 20:42:11.444	t
1242	2	215	2020-09-08	20:45:00	21:00:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-08 20:53:46.907	t
1243	2	215	2020-09-08	22:30:00	22:45:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	notCompleted	2020-09-08 21:18:04.945	t
1234	6	257	2020-09-09	13:00:00	14:00:00	\N	f	t	PATIENT	257	PATIENT	\N	60	directPayment	online	notCompleted	2020-09-08 19:28:13.718	t
1245	6	257	2020-09-09	13:00:00	13:45:00	\N	f	t	PATIENT	257	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-08 21:29:50.855	t
1246	6	257	2020-09-09	13:45:00	14:30:00	\N	f	t	PATIENT	\N	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-08 21:30:14.566	t
1247	6	257	2020-09-08	13:00:00	13:45:00	\N	t	f	PATIENT	\N	\N	\N	45	directPayment	online	notCompleted	2020-09-08 21:30:25.484	t
1248	6	257	2020-09-09	13:00:00	13:45:00	\N	f	t	PATIENT	257	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-08 21:33:43.695	t
1249	6	257	2020-09-08	13:45:00	14:30:00	\N	t	f	PATIENT	\N	\N	\N	45	directPayment	online	notCompleted	2020-09-08 21:34:09.403	t
1250	6	257	2020-09-09	13:00:00	13:45:00	\N	f	t	PATIENT	257	PATIENT	\N	45	directPayment	online	notCompleted	2020-09-08 21:36:24.275	t
1251	6	257	2020-09-08	15:15:00	16:00:00	\N	t	f	PATIENT	\N	\N	\N	45	directPayment	online	notCompleted	2020-09-08 21:38:26.478	t
1256	1	151	2020-09-08	22:00:00	22:20:00	\N	f	t	DOCTOR	28	DOCTOR	28	20	notRequired	online	completed	2020-09-08 22:01:34.487	t
1253	1	151	2020-09-08	21:40:00	22:00:00	\N	f	t	DOCTOR	28	DOCTOR	28	20	notRequired	online	completed	2020-09-08 21:46:18.654	t
1252	1	151	2020-09-08	22:00:00	22:20:00	\N	f	t	DOCTOR	28	DOCTOR	28	20	directPayment	online	completed	2020-09-08 21:40:19.196	t
1258	6	375	2020-09-09	13:00:00	13:45:00	\N	t	f	PATIENT	375	\N	\N	45	onlineCollection	online	notCompleted	2020-09-08 22:09:53.766	t
1254	1	151	2020-09-08	21:40:00	22:00:00	\N	f	t	DOCTOR	28	DOCTOR	28	20	notRequired	online	completed	2020-09-08 21:54:20.986	t
1265	2	151	2020-09-08	23:30:00	23:45:00	\N	f	t	DOCTOR	29	DOCTOR	29	15	notRequired	online	completed	2020-09-08 23:19:56.673	t
1257	1	151	2020-09-08	22:00:00	22:20:00	\N	f	t	DOCTOR	28	DOCTOR	28	20	notRequired	online	completed	2020-09-08 22:06:57.056	t
1259	1	151	2020-09-08	22:00:00	22:20:00	\N	f	t	DOCTOR	28	DOCTOR	28	20	notRequired	online	completed	2020-09-08 22:15:40.197	t
1261	1	151	2020-09-08	22:00:00	22:20:00	\N	t	f	DOCTOR	28	\N	\N	20	notRequired	online	completed	2020-09-08 22:19:47.9	t
1260	6	376	2020-09-09	13:45:00	14:30:00	\N	f	t	DOCTOR	33	DOCTOR	33	45	directPayment	online	notCompleted	2020-09-08 22:16:19.504	t
1262	2	162	2020-09-08	23:15:00	23:30:00	\N	f	t	DOCTOR	29	DOCTOR	29	15	directPayment	online	completed	2020-09-08 22:51:05.155	t
1266	2	151	2020-09-08	23:30:00	23:45:00	\N	f	t	DOCTOR	29	DOCTOR	29	15	notRequired	online	completed	2020-09-08 23:23:16.504	t
1263	2	162	2020-09-08	23:15:00	23:30:00	\N	f	t	DOCTOR	29	DOCTOR	29	15	directPayment	online	completed	2020-09-08 23:10:37.694	t
1267	2	151	2020-09-08	23:30:00	23:45:00	\N	f	t	DOCTOR	29	DOCTOR	29	15	notRequired	online	completed	2020-09-08 23:24:40.39	t
1268	2	151	2020-09-08	23:30:00	23:45:00	\N	t	f	DOCTOR	29	\N	\N	15	notRequired	online	completed	2020-09-08 23:39:34.705	t
1274	2	162	2020-09-09	01:00:00	01:15:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	completed	2020-09-09 00:48:20.957	t
1270	5	151	2020-09-09	10:00:00	10:20:00	\N	t	f	DOCTOR	32	\N	\N	20	notRequired	online	completed	2020-09-09 00:05:37.383	t
1273	5	151	2020-09-09	10:30:00	10:45:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-09 00:28:04.509	t
1271	5	151	2020-09-09	10:45:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-09 00:07:13.555	t
1269	2	162	2020-09-09	00:15:00	00:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	completed	2020-09-08 23:48:59.393	t
1272	2	162	2020-09-09	00:30:00	00:45:00	\N	f	t	DOCTOR	29	DOCTOR	29	15	directPayment	online	paused	2020-09-09 00:22:06.915	t
1277	5	151	2020-09-09	11:45:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	notCompleted	2020-09-09 01:11:05.214	t
1276	2	162	2020-09-09	01:15:00	01:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	completed	2020-09-09 01:10:33.786	t
1275	2	162	2020-09-09	01:30:00	01:45:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	completed	2020-09-09 01:10:05.597	t
1280	12	5	2020-09-10	08:30:00	09:00:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-09-09 12:44:50.422	t
1278	2	162	2020-09-09	02:15:00	02:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	completed	2020-09-09 01:47:05.202	t
1279	5	162	2020-09-09	11:00:00	11:15:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-09 02:07:42.858	t
1281	6	1	2020-09-15	09:00:00	09:45:00	\N	t	f	DOCTOR	33	\N	\N	45	directPayment	online	notCompleted	2020-09-09 13:08:06.442	t
1282	21	377	2020-09-09	16:00:00	16:30:00	\N	t	f	PATIENT	377	\N	\N	30	directPayment	online	notCompleted	2020-09-09 13:08:15.393	t
1188	6	5	2020-09-09	14:44:00	14:59:00	\N	f	t	PATIENT	5	DOCTOR	33	15	directPayment	online	notCompleted	2020-09-07 11:55:00.511	t
1283	6	378	2020-09-09	13:45:00	14:30:00	\N	f	t	DOCTOR	33	DOCTOR	33	45	directPayment	online	notCompleted	2020-09-09 14:14:16.112	t
1285	6	378	2020-09-09	13:45:00	14:30:00	\N	t	f	PATIENT	378	\N	\N	45	directPayment	online	notCompleted	2020-09-09 14:18:28.417	t
1286	6	378	2020-09-10	10:00:00	10:45:00	\N	t	f	PATIENT	378	\N	\N	45	directPayment	online	notCompleted	2020-09-09 14:23:00.833	t
1305	5	151	2020-09-09	21:00:00	21:15:00	\N	f	t	PATIENT	151	DOCTOR	32	15	directPayment	online	completed	2020-09-09 18:05:04.053	t
1284	6	378	2020-09-09	14:30:00	15:15:00	\N	t	f	DOCTOR	33	\N	\N	45	directPayment	online	completed	2020-09-09 14:14:55.775	t
1287	5	151	2020-09-09	17:00:00	17:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	20	notRequired	online	completed	2020-09-09 14:36:38.447	t
1288	5	151	2020-09-09	17:00:00	17:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 15:04:52.156	t
1289	5	151	2020-09-09	17:00:00	17:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 15:10:53.394	t
1297	6	257	2020-09-09	17:30:00	17:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 17:18:10.761	t
1319	6	380	2020-09-09	20:45:00	21:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-09 20:19:45.505	t
1291	2	162	2020-09-09	16:15:00	16:30:00	\N	t	f	DOCTOR	29	\N	\N	15	directPayment	online	paused	2020-09-09 16:15:05.188	t
1292	21	377	2020-09-09	18:00:00	18:30:00	\N	f	t	DOCTOR	48	DOCTOR	48	30	directPayment	online	notCompleted	2020-09-09 16:42:23.541	t
1293	21	377	2020-09-09	19:00:00	19:30:00	\N	t	f	DOCTOR	48	\N	\N	30	directPayment	online	notCompleted	2020-09-09 16:54:52.825	t
1309	6	151	2020-09-09	19:15:00	19:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-09 19:04:13.329	t
1299	6	257	2020-09-09	18:00:00	18:15:00	\N	t	f	PATIENT	257	\N	\N	15	onlineCollection	online	completed	2020-09-09 17:23:40.459	t
1290	5	151	2020-09-09	17:15:00	17:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 15:26:32.665	t
1295	5	151	2020-09-09	20:00:00	20:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 17:09:14.691	t
1300	6	85	2020-09-09	17:45:00	18:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 17:34:29.766	t
1301	6	162	2020-09-09	18:15:00	18:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 17:39:38.345	t
1302	6	85	2020-09-09	18:30:00	18:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 17:40:02.493	t
1294	6	257	2020-09-09	17:15:00	17:30:00	\N	t	f	PATIENT	257	\N	\N	15	onlineCollection	online	completed	2020-09-09 17:08:38.099	t
1296	5	151	2020-09-09	20:15:00	20:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 17:11:40.524	t
1318	6	379	2020-09-09	20:30:00	20:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 20:18:55.246	t
1310	6	379	2020-09-09	19:30:00	19:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 19:04:29.756	t
1304	6	85	2020-09-09	19:00:00	19:15:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	\N	2020-09-09 17:46:56.436	t
1312	6	380	2020-09-09	19:45:00	20:00:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	directPayment	online	notCompleted	2020-09-09 19:32:45.202	t
1321	6	380	2020-09-09	21:00:00	21:15:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-09 20:45:17.606	t
1303	6	151	2020-09-09	18:45:00	19:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 17:46:28.998	t
1298	5	151	2020-09-09	20:00:00	20:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 17:18:20.37	t
1313	6	379	2020-09-09	20:00:00	20:15:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 19:33:22.945	t
1306	5	5	2020-09-10	11:00:00	11:15:00	\N	f	t	PATIENT	5	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-09 18:41:18.877	t
1315	6	381	2020-09-09	20:15:00	20:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 20:07:02.507	t
1317	5	151	2020-09-09	21:30:00	21:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 20:17:43.897	t
1326	5	5	2020-09-15	09:00:00	09:15:00	\N	f	t	PATIENT	5	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-09 20:55:59.296	t
1314	6	381	2020-09-09	19:45:00	20:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-09 19:35:55.345	t
1325	6	382	2020-09-09	21:15:00	21:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 20:53:23.1	t
1316	5	151	2020-09-09	21:00:00	21:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	notCompleted	2020-09-09 20:09:24.45	t
1311	5	379	2020-09-09	21:15:00	21:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 19:05:38.973	t
1308	5	151	2020-09-09	21:30:00	21:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 18:45:23.625	t
1320	5	5	2020-09-09	20:30:00	20:45:00	\N	t	f	PATIENT	\N	\N	\N	15	directPayment	online	notCompleted	2020-09-09 20:37:40.114	t
1307	5	5	2020-09-09	21:45:00	22:00:00	\N	f	t	PATIENT	\N	DOCTOR	32	15	directPayment	online	notCompleted	2020-09-09 18:42:18.494	t
1323	5	151	2020-09-09	21:30:00	21:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 20:47:35.639	t
1322	5	5	2020-09-09	21:15:00	21:30:00	\N	f	t	PATIENT	\N	DOCTOR	32	15	directPayment	online	\N	2020-09-09 20:46:13.738	t
1329	6	382	2020-09-09	21:45:00	22:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-09 21:22:57.636	t
1328	6	380	2020-09-09	21:30:00	21:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-09 21:22:32.033	t
1327	5	151	2020-09-09	21:45:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-09 21:21:51.764	t
1331	5	5	2020-09-15	09:45:00	10:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-09 21:31:52.232	t
1330	6	379	2020-09-09	22:00:00	22:15:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	directPayment	online	completed	2020-09-09 21:23:28.485	t
1333	5	5	2020-09-15	13:00:00	13:15:00	\N	f	t	PATIENT	\N	DOCTOR	32	15	directPayment	online	notCompleted	2020-09-09 21:34:41.659	t
1332	5	151	2020-09-09	21:45:00	22:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-09 21:32:26.828	t
1324	6	382	2020-09-10	21:00:00	21:15:00	\N	t	f	PATIENT	382	\N	\N	15	directPayment	online	completed	2020-09-09 20:51:10.891	t
1335	5	5	2020-09-16	02:30:00	02:45:00	\N	f	t	PATIENT	\N	DOCTOR	32	15	directPayment	online	notCompleted	2020-09-09 21:50:56.885	t
1334	6	379	2020-09-09	22:00:00	22:15:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	directPayment	online	completed	2020-09-09 21:38:28.566	t
1336	6	379	2020-09-09	22:00:00	22:15:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	directPayment	online	completed	2020-09-09 22:04:03.222	t
1337	6	379	2020-09-09	22:00:00	22:15:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-09 22:13:09.155	t
1338	5	151	2020-09-10	10:00:00	10:30:00	\N	f	t	DOCTOR	32	ADMIN	53	30	notRequired	online	notCompleted	2020-09-09 22:26:30.911	t
1354	5	141	2020-09-10	11:00:00	11:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	notCompleted	2020-09-10 01:20:45.39	t
1339	6	151	2020-09-09	22:45:00	23:00:00	\N	f	t	ADMIN	53	DOCTOR	33	\N	notRequired	online	completed	2020-09-09 22:29:43.793	t
1352	5	151	2020-09-10	10:00:00	10:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 01:18:26.549	t
1340	6	151	2020-09-09	22:45:00	23:00:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	notRequired	online	completed	2020-09-09 22:37:11.777	t
1341	6	151	2020-09-09	22:45:00	23:00:00	\N	t	f	DOCTOR	33	\N	\N	15	notRequired	online	notCompleted	2020-09-09 22:44:45.768	t
1342	6	379	2020-09-09	23:00:00	23:15:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-09 23:03:08.996	t
1360	5	151	2020-09-10	11:15:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 02:19:53.211	t
1356	5	151	2020-09-10	10:45:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 01:27:45.905	t
1344	6	379	2020-09-09	23:15:00	23:30:00	\N	t	f	DOCTOR	33	\N	\N	15	notRequired	online	completed	2020-09-09 23:23:05.391	t
1343	6	151	2020-09-09	23:30:00	23:45:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	notRequired	online	completed	2020-09-09 23:21:59.324	t
1345	6	151	2020-09-09	23:30:00	23:45:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	notRequired	online	completed	2020-09-09 23:32:18.002	t
1355	5	383	2020-09-10	10:30:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 01:22:51.906	t
1346	6	151	2020-09-09	23:30:00	23:45:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	notRequired	online	completed	2020-09-09 23:35:09.888	t
1347	6	151	2020-09-09	23:30:00	23:45:00	\N	t	f	DOCTOR	33	\N	\N	15	notRequired	online	completed	2020-09-09 23:42:17.132	t
1348	1	86	2020-09-10	00:22:00	00:42:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	notCompleted	2020-09-10 00:25:35.488	t
1349	1	85	2020-09-10	00:42:00	01:02:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	completed	2020-09-10 00:28:59.892	t
1361	1	379	2020-09-10	02:42:00	03:02:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	completed	2020-09-10 02:27:46.026	t
1350	1	85	2020-09-10	01:02:00	01:22:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	paused	2020-09-10 00:32:54.47	t
1351	1	5	2020-09-10	01:22:00	01:42:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	paused	2020-09-10 00:37:18.968	t
1357	5	151	2020-09-10	10:45:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-09-10 01:44:30.34	t
1378	6	151	2020-09-10	16:44:00	16:59:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-10 16:40:18.132	t
1372	5	383	2020-09-10	11:45:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-10 03:02:21.679	t
1367	5	151	2020-09-10	11:15:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-10 02:59:59.2	t
1375	3	151	2020-09-10	16:45:00	17:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-10 14:40:06.237	t
1362	5	151	2020-09-10	11:30:00	11:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	notCompleted	2020-09-10 02:32:44.399	t
1359	5	151	2020-09-10	11:00:00	11:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 01:56:05.648	t
1358	1	379	2020-09-10	02:02:00	02:22:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	completed	2020-09-10 01:51:59.044	t
1365	5	383	2020-09-10	10:30:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 02:50:28.894	t
1353	5	140	2020-09-10	10:15:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 01:18:55.582	t
1364	5	151	2020-09-10	09:15:00	09:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 02:49:56.455	t
1376	3	151	2020-09-10	16:00:00	16:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	completed	2020-09-10 14:45:08.296	t
1373	5	383	2020-09-10	10:45:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-10 03:02:45.002	t
1377	1	379	2020-09-10	16:15:00	16:35:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	completed	2020-09-10 16:15:19.532	t
1374	1	379	2020-09-10	03:22:00	03:42:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	completed	2020-09-10 03:24:11.794	t
1368	5	151	2020-09-10	18:15:00	18:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 03:00:33.054	t
1371	3	151	2020-09-10	15:45:00	16:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-10 03:01:49.755	t
1366	1	379	2020-09-10	03:02:00	03:22:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	paused	2020-09-10 02:58:45.551	t
1363	3	383	2020-09-10	16:15:00	16:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-10 02:45:07.708	t
1369	3	383	2020-09-10	16:45:00	17:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-10 03:01:19.078	t
1370	3	151	2020-09-10	17:15:00	17:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-10 03:01:36.35	t
1380	6	379	2020-09-10	16:59:00	17:14:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-10 16:40:42.128	t
1384	5	379	2020-09-10	20:45:00	21:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	notCompleted	2020-09-10 17:17:10.496	t
1382	1	379	2020-09-10	16:55:00	17:15:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	completed	2020-09-10 17:01:07.579	t
1383	6	382	2020-09-10	17:29:00	17:44:00	\N	t	f	PATIENT	382	\N	\N	15	directPayment	online	notCompleted	2020-09-10 17:12:13.22	t
1381	5	379	2020-09-10	20:15:00	20:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-10 16:41:03.201	t
1379	5	151	2020-09-10	19:45:00	20:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	paused	2020-09-10 16:40:41.422	t
1386	6	379	2020-09-10	20:30:00	20:45:00	\N	t	f	PATIENT	379	\N	\N	15	directPayment	online	completed	2020-09-10 17:21:46.593	t
1388	5	1	2020-09-10	18:30:00	18:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-09-10 18:05:37.045	t
1387	6	379	2020-09-12	03:45:00	04:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-10 17:45:26.352	t
1389	5	151	2020-09-10	19:15:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	notCompleted	2020-09-10 18:16:06.56	t
1405	6	151	2020-09-11	09:00:00	09:15:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-11 00:03:09.522	t
1425	4	388	2020-09-11	18:30:00	19:00:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	\N	2020-09-11 18:23:39.103	t
1407	6	151	2020-09-11	00:35:00	00:50:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-11 00:17:10.315	t
1391	1	5	2020-09-10	18:55:00	19:15:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	paused	2020-09-10 18:46:57.206	t
1392	1	383	2020-09-10	19:15:00	19:35:00	\N	t	f	DOCTOR	28	\N	\N	20	directPayment	online	paused	2020-09-10 18:47:24.761	t
1390	6	5	2020-09-10	20:15:00	20:30:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	directPayment	online	notCompleted	2020-09-10 18:40:36.188	t
1414	5	151	2020-09-11	10:15:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-11 01:51:33.418	t
1385	6	151	2020-09-10	20:00:00	20:15:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-10 17:18:25.299	t
1406	6	151	2020-09-11	09:15:00	09:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	\N	2020-09-11 00:10:59.496	t
1393	6	379	2020-09-10	20:15:00	20:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-10 19:16:56.151	t
1408	6	151	2020-09-11	00:50:00	01:05:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-11 00:26:56.489	t
1394	5	151	2020-09-10	21:45:00	22:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	\N	2020-09-10 20:07:56.24	t
1395	20	382	2020-09-11	16:00:00	16:30:00	\N	t	f	PATIENT	382	\N	\N	30	directPayment	online	notCompleted	2020-09-10 20:44:11.62	t
1396	20	385	2020-09-11	16:30:00	17:00:00	\N	t	f	PATIENT	385	\N	\N	30	directPayment	online	notCompleted	2020-09-10 20:52:48.893	t
1397	6	385	2020-09-10	22:00:00	22:15:00	\N	f	t	PATIENT	385	DOCTOR	33	15	directPayment	online	notCompleted	2020-09-10 20:57:50.176	t
1398	6	385	2020-09-10	21:15:00	21:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	\N	2020-09-10 21:01:16.644	t
1399	6	385	2020-09-10	21:30:00	21:45:00	\N	f	t	PATIENT	385	DOCTOR	33	15	directPayment	online	\N	2020-09-10 21:08:33.782	t
1434	4	388	2020-09-11	21:00:00	21:30:00	\N	f	t	DOCTOR	31	DOCTOR	31	30	directPayment	online	completed	2020-09-11 19:40:28.551	t
1400	6	385	2020-09-10	22:15:00	22:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	\N	2020-09-10 21:12:20.952	t
1415	5	151	2020-09-11	09:45:00	10:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-11 01:57:38.445	t
1401	6	151	2020-09-10	21:30:00	21:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-10 21:23:11.05	t
1402	6	151	2020-09-10	21:45:00	22:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	\N	2020-09-10 21:28:07.128	t
1409	6	151	2020-09-11	01:20:00	01:35:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-11 00:27:10.752	t
1416	5	151	2020-09-11	18:49:00	19:04:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	paused	2020-09-11 14:38:56.926	t
1410	6	151	2020-09-11	01:50:00	02:05:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-11 00:31:07.347	t
1403	6	151	2020-09-10	23:15:00	23:30:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	directPayment	online	\N	2020-09-10 22:49:07.248	t
1404	6	151	2020-09-10	23:30:00	23:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-10 23:44:52.504	t
1417	5	151	2020-09-11	19:19:00	19:34:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	notCompleted	2020-09-11 15:09:49.888	t
1418	24	385	2020-09-14	20:00:00	20:30:00	\N	t	f	PATIENT	385	\N	\N	30	directPayment	online	notCompleted	2020-09-11 17:06:52.901	t
1419	8	5	2020-09-22	12:00:00	12:30:00	\N	f	t	PATIENT	5	PATIENT	\N	30	directPayment	online	notCompleted	2020-09-11 17:50:16.945	t
1420	8	5	2020-09-11	17:30:00	18:00:00	\N	t	f	PATIENT	\N	\N	\N	30	directPayment	online	notCompleted	2020-09-11 17:51:06.761	t
1411	5	151	2020-09-11	10:00:00	10:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-09-11 01:08:02.339	t
1412	5	151	2020-09-11	10:45:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-11 01:08:26.406	t
1421	5	5	2020-09-30	10:00:00	10:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-11 17:52:44.14	t
1413	5	151	2020-09-11	10:00:00	10:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-11 01:47:28.666	t
1423	5	388	2020-09-11	21:00:00	21:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-09-11 18:12:53.684	t
1424	5	388	2020-09-11	18:19:00	18:34:00	\N	t	f	PATIENT	388	\N	\N	15	directPayment	online	\N	2020-09-11 18:19:33.643	t
1427	4	388	2020-09-11	19:30:00	20:00:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	completed	2020-09-11 18:27:56.597	t
1426	4	388	2020-09-11	19:00:00	19:30:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	\N	2020-09-11 18:27:47.244	t
1430	4	388	2020-09-11	20:00:00	20:30:00	\N	f	t	PATIENT	388	DOCTOR	31	30	directPayment	online	\N	2020-09-11 19:30:49.562	t
1428	5	389	2020-09-11	21:30:00	21:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-11 19:21:10.991	t
1431	4	388	2020-09-11	20:30:00	21:00:00	\N	f	t	PATIENT	388	DOCTOR	31	30	directPayment	online	notCompleted	2020-09-11 19:31:28.436	t
1432	4	388	2020-09-11	20:00:00	20:30:00	\N	f	t	DOCTOR	31	DOCTOR	31	30	directPayment	online	completed	2020-09-11 19:40:07.824	t
1433	4	388	2020-09-11	20:30:00	21:00:00	\N	f	t	DOCTOR	31	DOCTOR	31	30	directPayment	online	completed	2020-09-11 19:40:18.172	t
1429	5	389	2020-09-11	21:45:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-11 19:24:42.72	t
1436	5	389	2020-09-11	22:30:00	22:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-11 19:57:56.393	t
1435	5	389	2020-09-11	22:15:00	22:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-09-11 19:54:57.051	t
1437	5	389	2020-09-11	22:45:00	23:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-11 20:01:55.065	t
1422	5	5	2020-09-29	09:00:00	09:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-11 17:53:02.89	t
1438	5	389	2020-09-11	22:30:00	22:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-11 20:04:07.559	t
1440	4	388	2020-09-11	21:00:00	21:30:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	completed	2020-09-11 20:17:45.923	t
1439	4	388	2020-09-11	20:30:00	21:00:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	paused	2020-09-11 20:17:35.753	t
1441	4	1	2020-09-11	21:30:00	22:00:00	\N	t	f	DOCTOR	31	\N	\N	30	directPayment	online	completed	2020-09-11 20:22:13.549	t
1465	38	390	2020-09-12	19:55:00	20:25:00	\N	f	t	DOCTOR	86	DOCTOR	86	30	directPayment	online	notCompleted	2020-09-12 19:55:17.898	t
1442	4	127	2020-09-11	22:00:00	22:30:00	\N	t	f	PATIENT	127	\N	\N	30	directPayment	online	\N	2020-09-11 20:27:56.854	t
1445	5	141	2020-09-11	22:30:00	22:45:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	notCompleted	2020-09-11 20:49:56.951	t
1458	5	151	2020-09-12	17:15:00	17:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-09-12 16:59:43.116	t
1443	5	151	2020-09-11	22:00:00	22:15:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-11 20:49:28.826	t
1444	5	389	2020-09-11	22:15:00	22:30:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	\N	2020-09-11 20:49:45.389	t
1460	5	151	2020-09-12	17:45:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-09-12 17:11:55.408	t
1447	5	151	2020-09-12	10:30:00	10:45:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	\N	2020-09-12 00:03:19.49	t
1446	5	151	2020-09-12	10:00:00	10:15:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	paused	2020-09-11 23:02:31.965	t
1448	5	379	2020-09-12	11:00:00	11:15:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-12 00:08:32.202	t
1449	5	151	2020-09-12	11:30:00	11:45:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	notCompleted	2020-09-12 00:58:26.12	t
1450	5	141	2020-09-12	11:45:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	notCompleted	2020-09-12 00:58:41.109	t
1451	6	151	2020-09-12	04:30:00	04:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-12 03:26:41.901	t
1452	6	379	2020-09-12	04:15:00	04:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-12 03:30:27.812	t
1461	5	151	2020-09-12	17:45:00	18:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	paused	2020-09-12 17:24:24.362	t
1456	5	383	2020-09-12	18:15:00	18:30:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	paused	2020-09-12 15:40:23.195	t
1453	5	151	2020-09-12	17:00:00	17:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-09-12 14:45:45.847	t
1467	38	391	2020-09-12	20:55:00	21:25:00	\N	t	f	DOCTOR	86	\N	\N	30	directPayment	online	completed	2020-09-12 19:56:25.293	t
1459	6	379	2020-09-12	17:30:00	17:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-12 17:05:11.125	t
1471	4	391	2020-09-12	20:45:00	21:00:00	\N	t	f	DOCTOR	31	\N	\N	15	directPayment	online	\N	2020-09-12 20:45:29.099	t
1457	5	1	2020-09-12	18:45:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	\N	2020-09-12 15:40:36.611	t
1474	4	150	2020-09-12	21:30:00	21:45:00	\N	t	f	PATIENT	150	\N	\N	15	directPayment	online	notCompleted	2020-09-12 20:57:09.538	t
1454	5	141	2020-09-12	17:30:00	17:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	paused	2020-09-12 14:46:07.002	t
1455	5	151	2020-09-12	17:45:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-09-12 15:16:06.639	t
1473	4	391	2020-09-12	21:00:00	21:15:00	\N	t	f	PATIENT	391	\N	\N	15	directPayment	online	paused	2020-09-12 20:56:08.115	t
1475	6	391	2020-09-12	23:15:00	23:30:00	\N	t	f	DOCTOR	33	\N	\N	15	notRequired	online	paused	2020-09-12 23:17:09.305	t
1476	6	379	2020-09-12	23:30:00	23:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-12 23:24:38.402	t
1466	38	390	2020-09-12	20:25:00	20:55:00	\N	t	f	DOCTOR	86	\N	\N	30	directPayment	online	paused	2020-09-12 19:55:49.231	t
1481	6	379	2020-09-13	02:45:00	03:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-13 02:11:25.081	t
1468	38	391	2020-09-12	21:55:00	22:25:00	\N	t	f	PATIENT	391	\N	\N	30	directPayment	online	\N	2020-09-12 20:00:39.25	t
1462	6	379	2020-09-12	18:30:00	18:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-12 17:45:58.213	t
1463	6	151	2020-09-12	18:45:00	19:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-12 18:02:46.841	t
1484	3	391	2020-09-13	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 15:36:55.399	t
1469	5	151	2020-09-12	20:30:00	20:45:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-12 20:19:29.309	t
1470	5	151	2020-09-12	20:45:00	21:00:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-09-12 20:20:07.363	t
1464	6	379	2020-09-12	19:00:00	19:15:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-12 18:18:15.536	t
1477	6	379	2020-09-13	00:15:00	00:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-12 23:50:47.626	t
1472	4	150	2020-09-12	21:15:00	21:30:00	\N	t	f	PATIENT	150	\N	\N	15	directPayment	online	completed	2020-09-12 20:47:12.603	t
1482	3	391	2020-09-13	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 14:46:46.548	t
1478	6	379	2020-09-13	00:45:00	01:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-13 00:26:08.485	t
1480	6	379	2020-09-13	01:30:00	01:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	paused	2020-09-13 01:01:15.823	t
1479	3	391	2020-09-13	05:30:00	05:45:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	paused	2020-09-13 00:32:33.847	t
1486	3	391	2020-09-13	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 16:06:51.192	t
1483	3	391	2020-09-13	18:00:00	18:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 14:51:53.856	t
1487	3	391	2020-09-13	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 16:24:03.292	t
1485	3	391	2020-09-13	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 15:42:22.222	t
1488	3	391	2020-09-13	19:45:00	20:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 18:38:17.436	t
1489	3	391	2020-09-13	20:00:00	20:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 18:44:51.704	t
1490	3	391	2020-09-13	19:45:00	20:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 18:48:21.602	t
1491	3	391	2020-09-13	20:00:00	20:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 18:50:48.879	t
1492	3	391	2020-09-13	20:15:00	20:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 18:57:38.687	t
1493	3	391	2020-09-13	20:15:00	20:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 19:04:22.792	t
1494	3	391	2020-09-13	19:45:00	20:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 19:10:04.415	t
1495	3	391	2020-09-13	20:15:00	20:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 19:17:28.298	t
1496	3	391	2020-09-13	20:30:00	20:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-13 19:24:18.589	t
1497	3	391	2020-09-13	20:45:00	21:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	paused	2020-09-13 19:33:23.964	t
1498	3	391	2020-09-13	21:00:00	21:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	\N	2020-09-13 21:03:33.064	t
1518	3	391	2020-09-17	15:30:00	15:45:00	\N	t	f	DOCTOR	30	\N	\N	15	directPayment	online	paused	2020-09-17 14:45:03.243	t
1499	5	391	2020-09-14	14:00:00	14:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-09-14 00:07:57.632	t
1500	5	391	2020-09-14	14:00:00	14:15:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	\N	2020-09-14 00:11:06.091	t
1501	6	380	2020-09-14	16:44:00	17:29:00	\N	t	f	DOCTOR	33	\N	\N	45	directPayment	online	notCompleted	2020-09-14 14:55:21.489	t
1502	6	388	2020-09-16	13:45:00	14:00:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-14 18:55:06.093	t
1503	6	388	2020-09-16	14:15:00	14:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-14 19:03:17.07	t
1504	6	388	2020-09-14	19:00:00	19:15:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-14 19:15:08.672	t
1505	6	388	2020-09-14	19:15:00	19:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	completed	2020-09-14 19:15:56.795	t
1506	6	388	2020-09-14	22:15:00	22:30:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-14 22:16:13.246	t
1507	6	388	2020-09-14	22:30:00	22:45:00	\N	f	t	DOCTOR	33	DOCTOR	33	15	directPayment	online	notCompleted	2020-09-14 22:16:43.276	t
1519	38	382	2020-09-17	15:15:00	15:45:00	\N	t	f	DOCTOR	86	\N	\N	30	directPayment	online	completed	2020-09-17 14:45:40.405	t
1508	5	391	2020-09-15	18:00:00	18:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-09-15 17:31:06.068	t
1509	5	391	2020-09-15	18:00:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	\N	2020-09-15 17:36:10.395	t
1510	5	391	2020-09-15	21:00:00	21:15:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	notCompleted	2020-09-15 19:33:05.795	t
1511	6	380	2020-09-15	20:30:00	20:45:00	\N	t	f	DOCTOR	33	\N	\N	15	directPayment	online	notCompleted	2020-09-15 20:08:15.448	t
1512	6	380	2020-09-15	23:30:00	23:45:00	\N	t	f	PATIENT	380	\N	\N	15	onlineCollection	online	paused	2020-09-15 22:51:56.131	t
1536	6	397	2020-09-18	14:00:00	14:10:00	\N	f	t	PATIENT	397	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-18 10:45:48.651	t
1513	43	388	2020-09-16	18:30:00	18:45:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	paused	2020-09-16 18:32:12.713	t
1528	3	151	2020-09-17	21:00:00	21:15:00	\N	f	t	PATIENT	151	DOCTOR	30	15	directPayment	online	\N	2020-09-17 17:44:09.928	t
1514	43	388	2020-09-16	18:45:00	19:00:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	completed	2020-09-16 18:46:24.59	t
1521	38	382	2020-09-17	16:45:00	17:15:00	\N	t	f	DOCTOR	86	\N	\N	30	directPayment	online	paused	2020-09-17 15:00:15.471	t
1520	38	382	2020-09-17	15:45:00	16:15:00	\N	t	f	DOCTOR	86	\N	\N	30	directPayment	online	paused	2020-09-17 14:47:24.723	t
1515	43	388	2020-09-16	19:30:00	19:45:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	completed	2020-09-16 19:14:05.421	t
1516	43	397	2020-09-16	20:00:00	20:15:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	completed	2020-09-16 19:19:14.7	t
1517	38	382	2020-09-19	20:25:00	20:55:00	\N	t	f	DOCTOR	86	\N	\N	30	directPayment	online	notCompleted	2020-09-17 14:43:48.033	t
1522	6	397	2020-09-17	17:24:00	17:34:00	\N	t	f	DOCTOR	33	\N	\N	10	directPayment	online	completed	2020-09-17 16:47:07.94	t
1524	6	397	2020-09-17	20:10:00	20:20:00	\N	f	t	DOCTOR	33	DOCTOR	33	10	directPayment	online	notCompleted	2020-09-17 17:15:44.537	t
1523	3	391	2020-09-17	18:15:00	18:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-17 17:09:26.241	t
1538	6	397	2020-09-18	13:40:00	13:50:00	\N	f	t	PATIENT	397	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-18 11:05:11.252	t
1540	6	397	2020-09-18	14:00:00	14:10:00	\N	f	t	PATIENT	397	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-18 11:06:56.157	t
1535	6	397	2020-09-18	03:50:00	04:00:00	\N	f	t	PATIENT	397	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-09-18 00:02:38.19	t
1525	6	397	2020-09-17	21:10:00	21:20:00	\N	t	f	DOCTOR	33	\N	\N	10	directPayment	online	paused	2020-09-17 17:32:22.12	t
1526	3	391	2020-09-17	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-17 17:38:34.938	t
1527	3	391	2020-09-17	19:00:00	19:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-17 17:40:22.453	t
1531	3	151	2020-09-17	19:45:00	20:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	paused	2020-09-17 18:08:39.76	t
1529	3	151	2020-09-17	20:45:00	21:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-17 17:56:36.239	t
1530	3	151	2020-09-17	21:15:00	21:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-17 18:03:18.407	t
1532	3	391	2020-09-17	19:45:00	20:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-17 18:46:16.354	t
1541	6	397	2020-09-18	12:50:00	13:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-18 11:14:18.348	t
1543	6	397	2020-09-18	13:40:00	13:50:00	\N	t	f	PATIENT	397	\N	\N	10	directPayment	online	notCompleted	2020-09-18 12:04:41.441	t
1545	6	397	2020-09-18	15:20:00	15:30:00	\N	f	t	PATIENT	397	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-18 12:12:13.4	t
1546	6	397	2020-09-18	14:00:00	14:10:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	notCompleted	2020-09-18 12:17:48.088	t
1542	6	397	2020-09-18	12:40:00	12:50:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-18 11:16:59.514	t
1547	6	397	2020-09-18	12:20:00	12:30:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	notCompleted	2020-09-18 12:18:48.396	t
1544	6	397	2020-09-18	13:50:00	14:00:00	\N	f	t	PATIENT	397	PATIENT	\N	10	directPayment	online	notCompleted	2020-09-18 12:06:30.289	t
1548	6	397	2020-09-18	13:10:00	13:20:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	notCompleted	2020-09-18 12:37:50.587	t
1549	6	397	2020-09-18	12:50:00	13:00:00	\N	t	f	PATIENT	397	\N	\N	10	directPayment	online	notCompleted	2020-09-18 12:39:04.089	t
1550	3	391	2020-09-18	14:15:00	14:30:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-18 13:03:49.9	t
1551	43	391	2020-09-21	20:00:00	20:15:00	\N	f	t	PATIENT	391	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-18 13:15:05.99	t
1553	6	397	2020-09-22	10:40:00	10:50:00	\N	t	f	PATIENT	397	\N	\N	10	directPayment	online	notCompleted	2020-09-18 14:18:38.595	t
1534	43	398	2020-09-21	18:45:00	19:00:00	\N	f	t	PATIENT	398	DOCTOR	92	15	directPayment	online	notCompleted	2020-09-17 19:40:32.622	t
1533	43	388	2020-09-21	18:30:00	18:45:00	\N	f	t	PATIENT	388	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-17 19:19:08.291	t
1554	43	388	2020-09-18	14:40:00	14:55:00	\N	t	f	PATIENT	\N	\N	\N	15	directPayment	online	notCompleted	2020-09-18 14:51:41.944	t
1555	43	388	2020-09-18	14:55:00	15:10:00	\N	f	t	PATIENT	388	DOCTOR	92	15	directPayment	online	notCompleted	2020-09-18 14:55:28.306	t
1556	43	388	2020-09-22	09:00:00	09:15:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	notCompleted	2020-09-18 15:09:47.515	t
1557	6	397	2020-09-18	16:50:00	17:00:00	\N	t	f	DOCTOR	33	\N	\N	10	directPayment	online	paused	2020-09-18 15:50:46.126	t
1572	43	388	2020-09-18	19:25:00	19:40:00	\N	t	f	PATIENT	388	\N	\N	15	directPayment	online	completed	2020-09-18 19:28:02.69	t
1595	43	388	2020-09-19	15:00:00	15:15:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	notCompleted	2020-09-19 14:53:34.043	t
1559	43	388	2020-09-18	16:40:00	16:55:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	completed	2020-09-18 16:23:07.086	t
1558	43	388	2020-09-18	17:10:00	17:25:00	\N	t	f	PATIENT	388	\N	\N	15	onlineCollection	online	completed	2020-09-18 16:22:32.883	t
1583	3	391	2020-09-18	23:00:00	23:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-18 22:49:34.492	t
1560	3	391	2020-09-18	17:45:00	18:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	completed	2020-09-18 16:55:36.061	t
1561	43	388	2020-09-18	17:25:00	17:40:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	notCompleted	2020-09-18 17:08:09.826	t
1562	6	402	2020-09-19	05:20:00	05:30:00	\N	t	f	PATIENT	402	\N	\N	10	onlineCollection	online	notCompleted	2020-09-18 17:26:36.503	t
1563	6	402	2020-09-19	05:30:00	05:40:00	\N	f	t	PATIENT	402	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-09-18 17:28:58.025	t
1584	43	397	2020-09-21	20:30:00	20:45:00	\N	t	f	PATIENT	397	\N	\N	15	onlineCollection	online	notCompleted	2020-09-18 23:51:54.163	t
1585	3	391	2020-09-19	16:00:00	16:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-18 23:52:33.241	t
1564	6	402	2020-09-18	17:40:00	17:50:00	\N	t	f	PATIENT	402	\N	\N	10	onlineCollection	online	paused	2020-09-18 17:32:18.484	t
1573	43	388	2020-09-18	19:40:00	19:55:00	\N	t	f	PATIENT	388	\N	\N	15	directPayment	online	completed	2020-09-18 19:31:21.4	t
1566	6	388	2020-09-18	18:20:00	18:30:00	\N	t	f	DOCTOR	33	\N	\N	10	directPayment	online	paused	2020-09-18 18:00:33.01	t
1567	43	388	2020-09-18	18:25:00	18:40:00	\N	f	t	DOCTOR	92	DOCTOR	92	15	directPayment	online	notCompleted	2020-09-18 18:05:48.846	t
1571	6	397	2020-09-18	19:40:00	19:50:00	\N	t	f	DOCTOR	33	\N	\N	10	directPayment	online	completed	2020-09-18 19:10:01.051	t
1574	3	391	2020-09-18	21:00:00	21:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	\N	2020-09-18 19:51:03.775	t
1587	6	397	2020-09-19	18:10:00	18:20:00	\N	t	f	PATIENT	397	\N	\N	10	onlineCollection	online	\N	2020-09-19 00:03:19.879	t
1569	43	397	2020-09-18	18:55:00	19:10:00	\N	t	f	PATIENT	397	\N	\N	15	onlineCollection	online	paused	2020-09-18 18:21:07.96	t
1568	43	397	2020-09-18	18:25:00	18:40:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	completed	2020-09-18 18:06:20.355	t
1565	3	391	2020-09-18	19:00:00	19:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	paused	2020-09-18 17:48:48.192	t
1570	3	391	2020-09-18	19:30:00	19:45:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	paused	2020-09-18 18:49:50.723	t
1586	6	397	2020-09-19	04:40:00	04:50:00	\N	t	f	PATIENT	397	\N	\N	10	onlineCollection	online	paused	2020-09-18 23:54:45.676	t
1576	43	403	2020-09-18	20:55:00	21:10:00	\N	t	f	PATIENT	403	\N	\N	15	directPayment	online	completed	2020-09-18 20:29:19.337	t
1577	43	403	2020-09-18	21:10:00	21:25:00	\N	f	t	PATIENT	403	DOCTOR	92	15	directPayment	online	notCompleted	2020-09-18 20:34:41.619	t
1575	43	403	2020-09-18	20:40:00	20:55:00	\N	t	f	PATIENT	403	\N	\N	15	directPayment	online	completed	2020-09-18 20:28:46.061	t
1578	3	391	2020-09-18	21:45:00	22:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	paused	2020-09-18 20:41:03.259	t
1579	43	388	2020-09-18	21:10:00	21:25:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	completed	2020-09-18 20:44:20.711	t
1581	43	404	2020-09-18	21:25:00	21:40:00	\N	t	f	PATIENT	404	\N	\N	15	directPayment	online	notCompleted	2020-09-18 21:36:48.299	t
1582	43	405	2020-09-18	13:40:00	13:55:00	\N	t	f	PATIENT	405	\N	\N	15	onlineCollection	online	notCompleted	2020-09-18 22:38:01.001	t
1588	43	407	2020-09-21	19:30:00	19:45:00	\N	f	t	PATIENT	407	PATIENT	\N	15	onlineCollection	online	notCompleted	2020-09-19 11:58:04.737	t
1597	43	416	2020-09-19	17:15:00	17:30:00	\N	t	f	PATIENT	416	\N	\N	15	onlineCollection	online	notCompleted	2020-09-19 17:16:59.195	t
1589	43	407	2020-09-21	21:00:00	21:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-19 11:59:36.727	t
1590	43	407	2020-09-21	21:15:00	21:30:00	\N	t	f	PATIENT	\N	\N	\N	15	directPayment	online	notCompleted	2020-09-19 12:00:06.726	t
1591	6	114	2020-09-20	01:00:00	02:00:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	notCompleted	2020-09-19 07:35:03.547	t
1552	43	398	2020-09-21	19:00:00	19:15:00	\N	f	t	PATIENT	398	DOCTOR	92	15	directPayment	online	notCompleted	2020-09-18 13:18:18.114	t
1592	43	398	2020-09-21	18:45:00	19:00:00	\N	f	t	DOCTOR	92	DOCTOR	92	15	directPayment	online	notCompleted	2020-09-19 14:48:57.554	t
1593	43	388	2020-09-21	19:00:00	19:15:00	\N	f	t	DOCTOR	92	DOCTOR	92	15	directPayment	online	notCompleted	2020-09-19 14:49:41.281	t
1598	45	382	2020-09-19	21:20:00	21:40:00	\N	t	f	PATIENT	382	\N	\N	20	directPayment	online	notCompleted	2020-09-19 17:28:07.759	t
1599	45	382	2020-09-19	22:20:00	22:40:00	\N	t	f	PATIENT	382	\N	\N	20	directPayment	online	notCompleted	2020-09-19 17:37:55.015	t
1600	45	382	2020-09-19	18:20:00	18:40:00	\N	f	t	PATIENT	382	PATIENT	\N	20	directPayment	online	notCompleted	2020-09-19 17:44:45.823	t
1601	6	382	2020-09-19	17:00:00	18:00:00	\N	f	t	PATIENT	382	PATIENT	\N	60	directPayment	online	notCompleted	2020-09-19 17:51:49.267	t
1602	45	382	2020-09-19	18:20:00	18:40:00	\N	t	f	PATIENT	382	\N	\N	20	directPayment	online	notCompleted	2020-09-19 17:58:25.232	t
1596	6	397	2020-09-19	20:00:00	21:00:00	\N	t	f	PATIENT	397	\N	\N	60	onlineCollection	online	\N	2020-09-19 16:38:10.275	t
1603	43	388	2020-09-19	20:30:00	20:45:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	paused	2020-09-19 20:25:33.554	t
1604	3	391	2020-09-19	21:45:00	22:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-19 20:33:45.338	t
1605	3	391	2020-09-19	22:00:00	22:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-19 20:37:06.943	t
1606	3	391	2020-09-19	21:45:00	22:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	\N	2020-09-19 20:48:57.109	t
1580	43	403	2020-09-21	19:15:00	19:30:00	\N	t	f	PATIENT	403	\N	\N	15	directPayment	online	completed	2020-09-18 20:47:36.346	t
1594	43	388	2020-09-21	19:00:00	19:15:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	completed	2020-09-19 14:50:19.751	t
1607	3	391	2020-09-19	22:15:00	22:30:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	paused	2020-09-19 21:12:08.87	t
1608	43	397	2020-09-19	21:45:00	22:00:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	notCompleted	2020-09-19 21:51:42.201	t
1609	43	397	2020-09-19	22:00:00	22:15:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	paused	2020-09-19 21:52:04.346	t
1636	6	397	2020-09-22	22:30:00	23:00:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	notCompleted	2020-09-22 22:45:53.7	t
1610	43	397	2020-09-19	22:15:00	22:30:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	completed	2020-09-19 22:04:26.797	t
1611	43	388	2020-09-19	22:30:00	22:45:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	paused	2020-09-19 22:13:13.393	t
1612	43	397	2020-09-19	22:45:00	23:00:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	paused	2020-09-19 22:13:34.97	t
1613	3	391	2020-09-19	23:30:00	23:45:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-19 23:27:33.727	t
1635	6	391	2020-09-22	23:00:00	23:30:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	completed	2020-09-22 22:45:10.787	t
1637	6	391	2020-09-23	18:00:00	18:30:00	\N	t	f	PATIENT	391	\N	\N	30	directPayment	online	notCompleted	2020-09-22 22:53:13.074	t
1614	3	391	2020-09-20	18:00:00	18:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-20 14:55:35.417	t
1615	3	391	2020-09-20	18:30:00	18:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-20 14:59:27.27	t
1616	3	391	2020-09-20	17:30:00	17:45:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-20 15:32:37.008	t
1638	3	389	2020-09-23	19:45:00	20:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-23 14:57:56.9	t
1617	3	391	2020-09-20	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-09-20 15:32:57.164	t
1618	3	391	2020-09-21	13:15:00	13:30:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-20 16:03:34.336	t
1620	3	417	2020-09-20	20:15:00	20:30:00	\N	t	f	PATIENT	417	\N	\N	15	onlineCollection	online	notCompleted	2020-09-20 19:23:53.17	t
1619	3	391	2020-09-24	16:00:00	16:15:00	\N	f	t	DOCTOR	30	PATIENT	\N	15	notRequired	online	notCompleted	2020-09-20 16:42:13.465	t
1621	3	391	2020-09-22	18:45:00	19:00:00	\N	t	f	PATIENT	\N	\N	\N	15	directPayment	online	notCompleted	2020-09-20 19:25:48.999	t
1622	9	418	2020-09-28	14:00:00	14:45:00	\N	t	f	PATIENT	418	\N	\N	45	directPayment	online	notCompleted	2020-09-20 19:52:32.833	t
1623	7	150	2020-09-21	09:00:00	09:30:00	\N	t	f	ADMIN	54	\N	\N	\N	directPayment	online	notCompleted	2020-09-20 20:36:59.188	t
1624	7	150	2020-09-20	20:30:00	21:00:00	\N	t	f	DOCTOR	34	\N	\N	30	directPayment	online	paused	2020-09-20 20:44:42.294	t
1625	7	418	2020-09-20	21:00:00	21:30:00	\N	t	f	PATIENT	418	\N	\N	30	onlineCollection	online	paused	2020-09-20 20:46:33.03	t
1639	22	389	2020-09-23	17:00:00	17:30:00	\N	t	f	PATIENT	389	\N	\N	30	directPayment	online	notCompleted	2020-09-23 15:00:56.046	t
1626	7	417	2020-09-20	21:30:00	22:00:00	\N	t	f	PATIENT	417	\N	\N	30	onlineCollection	online	paused	2020-09-20 20:49:52.916	t
1627	7	419	2020-09-20	22:00:00	22:30:00	\N	t	f	PATIENT	419	\N	\N	30	onlineCollection	online	paused	2020-09-20 20:52:11.702	t
1628	43	388	2020-09-22	15:00:00	15:15:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	completed	2020-09-22 14:43:21.67	t
1640	22	389	2020-09-28	16:00:00	16:30:00	\N	t	f	PATIENT	389	\N	\N	30	directPayment	online	notCompleted	2020-09-23 15:02:36.363	t
1629	43	388	2020-09-22	15:15:00	15:30:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	paused	2020-09-22 14:57:55.347	t
1630	3	391	2020-09-22	20:45:00	21:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	paused	2020-09-22 20:46:48.927	t
1641	22	389	2020-09-28	16:30:00	17:00:00	\N	t	f	PATIENT	389	\N	\N	30	directPayment	online	notCompleted	2020-09-23 15:03:44.443	t
1632	3	1	2020-09-22	22:30:00	22:45:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-22 21:00:29.593	t
1633	3	142	2020-09-22	23:00:00	23:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-22 21:00:53.128	t
1634	6	397	2020-09-23	15:45:00	16:45:00	\N	t	f	DOCTOR	33	\N	\N	60	directPayment	online	notCompleted	2020-09-22 22:43:23.109	t
1642	22	389	2020-09-29	16:00:00	16:30:00	\N	t	f	PATIENT	389	\N	\N	30	directPayment	online	notCompleted	2020-09-23 15:04:18.714	t
1643	22	389	2020-09-29	21:00:00	21:30:00	\N	t	f	PATIENT	389	\N	\N	30	directPayment	online	notCompleted	2020-09-23 15:04:53.208	t
1646	13	389	2020-09-28	10:00:00	10:30:00	\N	t	f	PATIENT	389	\N	\N	30	directPayment	online	notCompleted	2020-09-23 15:06:25.563	t
1647	11	389	2020-09-28	08:00:00	08:30:00	\N	t	f	PATIENT	389	\N	\N	30	directPayment	online	notCompleted	2020-09-23 15:06:57.065	t
1644	13	389	2020-09-29	10:00:00	10:30:00	\N	f	t	PATIENT	389	PATIENT	\N	30	directPayment	online	notCompleted	2020-09-23 15:05:26.18	t
1649	13	389	2020-09-28	11:00:00	11:30:00	\N	t	f	PATIENT	\N	\N	\N	30	directPayment	online	notCompleted	2020-09-23 15:09:03.339	t
1645	13	389	2020-09-29	17:30:00	18:00:00	\N	f	t	PATIENT	389	PATIENT	\N	30	directPayment	online	notCompleted	2020-09-23 15:05:52.515	t
1650	13	389	2020-10-06	10:00:00	10:30:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-09-23 15:11:42.081	t
1648	11	389	2020-09-29	10:00:00	10:30:00	\N	f	t	PATIENT	389	PATIENT	\N	30	directPayment	online	notCompleted	2020-09-23 15:07:39.258	t
1651	43	388	2020-09-23	15:30:00	15:45:00	\N	t	f	DOCTOR	92	\N	\N	15	directPayment	online	notCompleted	2020-09-23 15:28:52.044	t
1652	43	388	2020-09-25	13:40:00	13:55:00	\N	t	f	PATIENT	388	\N	\N	15	directPayment	online	notCompleted	2020-09-23 16:25:36.213	t
1653	3	391	2020-09-24	17:15:00	17:30:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-24 16:30:14.469	t
1654	3	391	2020-09-24	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	paused	2020-09-24 17:37:00.352	t
1655	5	5	2020-09-25	18:19:00	18:34:00	\N	f	t	PATIENT	5	PATIENT	\N	15	directPayment	online	notCompleted	2020-09-25 15:34:35.659	t
1656	1	5	2020-09-26	05:00:00	05:20:00	\N	f	t	PATIENT	5	PATIENT	\N	20	directPayment	online	notCompleted	2020-09-25 16:17:04.102	t
1657	25	5	2020-09-25	16:00:00	16:30:00	\N	t	f	PATIENT	5	\N	\N	30	directPayment	online	notCompleted	2020-09-25 16:18:33.816	t
1658	4	4	2020-09-26	20:00:00	20:15:00	\N	t	f	ADMIN	53	\N	\N	\N	notRequired	online	notCompleted	2020-09-26 16:02:29.486	t
1661	3	84	2020-09-26	17:45:00	18:00:00	\N	f	t	DOCTOR	30	ADMIN	53	15	notRequired	online	notCompleted	2020-09-26 16:05:19.866	t
1659	3	91	2020-09-26	17:15:00	17:30:00	\N	f	t	DOCTOR	30	ADMIN	53	15	notRequired	online	notCompleted	2020-09-26 16:04:41.541	t
1660	3	142	2020-09-26	17:30:00	17:45:00	\N	f	t	DOCTOR	30	ADMIN	53	15	notRequired	online	notCompleted	2020-09-26 16:05:00.231	t
1662	8	5	2020-09-29	19:00:00	19:30:00	\N	f	t	PATIENT	5	PATIENT	\N	30	directPayment	online	notCompleted	2020-09-28 19:52:55.299	t
1695	5	1	2020-10-01	19:40:00	19:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:12:22.602	t
1663	3	391	2020-09-29	19:15:00	19:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-29 18:11:51.885	t
1664	3	391	2020-09-29	19:45:00	20:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	completed	2020-09-29 18:17:00.565	t
1665	3	391	2020-09-29	23:30:00	23:45:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	completed	2020-09-29 23:03:08.937	t
1696	5	1	2020-10-01	19:40:00	19:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:12:22.663	t
1666	3	391	2020-09-30	19:45:00	20:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-30 14:30:28.556	t
1697	5	1	2020-10-01	23:11:00	23:21:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:12:52.52	t
1667	3	391	2020-09-30	19:45:00	20:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-09-30 14:50:09.836	t
1698	5	1	2020-10-01	23:11:00	23:21:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:12:52.588	t
1699	5	1	2020-10-01	23:21:00	23:31:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:13:06.521	t
1670	5	1	2020-10-02	10:00:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-09-30 16:08:57.802	t
1700	5	1	2020-10-01	23:21:00	23:31:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:13:06.673	t
1671	5	1	2020-10-03	11:00:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-09-30 16:12:10.421	t
1672	5	1	2020-10-04	11:00:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-09-30 16:13:52.426	t
1673	5	1	2020-09-30	19:00:00	20:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-09-30 16:17:22.2	t
1674	5	1	2020-10-05	13:00:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-09-30 16:28:15.989	t
1701	5	1	2020-10-02	09:10:00	09:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:15:31.18	t
1702	5	1	2020-10-02	09:20:00	09:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:32:38.132	t
1703	5	1	2020-10-02	09:20:00	09:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:32:38.174	t
1704	5	1	2020-10-02	09:50:00	10:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:39:12.254	t
1675	3	391	2020-09-30	20:15:00	20:30:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-09-30 18:10:02.325	t
1668	3	391	2020-09-30	20:00:00	20:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	completed	2020-09-30 15:10:13.978	t
1676	5	1	2020-10-15	20:00:00	20:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-30 19:15:16.341	t
1677	5	1	2020-09-30	20:00:00	20:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-30 19:27:12.92	t
1678	5	1	2020-09-30	20:10:00	20:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-09-30 20:11:28.207	t
1679	5	1	2020-10-01	20:10:00	20:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 10:42:34.533	t
1680	5	1	2020-10-03	18:20:00	18:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 11:44:50.608	t
1681	5	1	2020-10-03	18:50:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 11:52:20.413	t
1682	5	1	2020-10-03	19:00:00	19:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 12:58:26.778	t
1683	5	1	2020-10-03	18:00:00	18:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 13:29:46.851	t
1684	5	1	2020-10-03	18:10:00	18:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 13:43:14.192	t
1685	5	1	2020-10-01	20:20:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 13:44:38.102	t
1686	5	1	2020-10-01	18:30:00	18:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:04:10.603	t
1687	5	1	2020-10-01	20:40:00	20:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:09:43.781	t
1688	5	1	2020-10-01	20:40:00	20:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:09:43.845	t
1689	5	1	2020-10-02	20:40:00	20:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:09:52.825	t
1690	5	1	2020-10-02	20:40:00	20:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:09:52.824	t
1691	5	1	2020-10-01	18:00:00	18:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:11:25.203	t
1692	5	1	2020-10-01	18:00:00	18:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:11:25.246	t
1693	5	1	2020-10-01	19:30:00	19:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:11:58.455	t
1694	5	1	2020-10-01	19:30:00	19:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:11:58.46	t
1705	5	1	2020-10-02	09:50:00	10:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:39:12.254	t
1706	5	1	2020-10-02	09:40:00	09:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:57:57.193	t
1707	5	1	2020-10-02	09:40:00	09:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 15:57:57.217	t
1708	5	1	2020-10-02	21:10:00	21:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 16:08:54.215	t
1709	5	1	2020-10-02	21:10:00	21:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 16:08:54.225	t
1710	5	1	2020-10-02	18:09:00	18:19:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 16:13:22.01	t
1711	5	1	2020-10-02	18:09:00	18:19:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 16:13:22.023	t
1712	5	1	2020-10-02	17:49:00	17:59:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 16:14:09.653	t
1713	5	1	2020-10-02	17:49:00	17:59:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 16:14:09.68	t
1714	5	1	2020-10-02	18:19:00	18:29:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 16:41:07.512	t
1715	5	1	2020-10-02	18:19:00	18:29:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 16:41:07.544	t
1744	3	391	2020-10-03	23:00:00	23:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	notCompleted	2020-10-03 21:34:10.723	t
1738	3	391	2020-10-03	18:45:00	19:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	paused	2020-10-03 17:27:15.121	t
1716	3	391	2020-10-01	19:30:00	19:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-10-01 18:22:10.242	t
1717	3	391	2020-10-01	20:15:00	20:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-10-01 18:49:55.555	t
1718	5	19	2020-10-04	19:20:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 19:16:49.065	t
1719	5	19	2020-10-01	19:20:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 19:16:56.731	t
1720	5	1	2020-10-04	19:30:00	19:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 19:17:00.969	t
1721	5	1	2020-10-02	09:00:00	09:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-01 19:18:01.75	t
1759	3	391	2020-10-05	20:00:00	20:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-10-05 18:31:51.774	t
1722	3	391	2020-10-01	23:30:00	23:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-10-01 23:28:21.186	t
1723	3	391	2020-10-01	23:30:00	23:45:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-10-01 23:39:40.486	t
1757	5	1	2020-10-06	09:00:00	09:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 17:43:39.089	t
1745	3	391	2020-10-03	23:30:00	23:45:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	completed	2020-10-03 23:09:21.609	t
1724	3	391	2020-10-02	13:45:00	14:00:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	paused	2020-10-02 00:00:54.979	t
1725	5	1	2020-10-03	10:30:00	10:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-03 10:30:38.587	t
1726	5	1	2020-10-03	10:50:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-03 10:41:06.936	t
1727	5	1	2020-10-03	09:00:00	09:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-03 10:41:33.071	t
1728	5	1	2020-10-03	17:30:00	17:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-03 10:47:14.55	t
1729	5	1	2020-10-03	17:00:00	17:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-03 10:48:58.01	t
1730	5	1	2020-10-03	16:40:00	16:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-03 10:52:52.403	t
1731	5	1	2020-10-03	17:20:00	17:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-03 10:53:20.442	t
1732	5	1	2020-10-04	17:40:00	17:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-03 10:57:37.721	t
1746	3	391	2020-10-04	06:15:00	06:30:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	notCompleted	2020-10-04 00:06:23.949	t
1733	3	391	2020-10-03	16:15:00	16:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-10-03 14:10:43.726	t
1747	5	1	2020-10-05	11:50:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 11:53:32.483	t
1748	5	1	2020-10-05	11:50:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 11:53:32.757	t
1739	3	391	2020-10-03	23:00:00	23:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-10-03 18:38:03.789	t
1734	3	391	2020-10-03	16:15:00	16:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-10-03 14:26:12.294	t
1735	3	391	2020-10-03	16:00:00	16:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	notCompleted	2020-10-03 14:45:24.915	t
1749	5	1	2020-10-05	14:00:00	14:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 11:53:53.414	t
1750	5	1	2020-10-05	14:00:00	14:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 11:53:53.424	t
1736	3	391	2020-10-03	16:45:00	17:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-10-03 15:33:15.532	t
1758	5	5	2020-10-06	09:30:00	09:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 18:07:02.768	t
1737	3	391	2020-10-03	17:15:00	17:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-10-03 15:53:36.843	t
1752	5	1	2020-10-05	14:50:00	15:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 14:43:10.821	t
1751	3	391	2020-10-05	14:45:00	15:00:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	paused	2020-10-05 14:16:23.971	t
1742	3	391	2020-10-03	21:00:00	21:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-10-03 20:06:05.92	t
1741	3	391	2020-10-03	21:30:00	21:45:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	paused	2020-10-03 19:52:53.773	t
1740	3	391	2020-10-03	23:00:00	23:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	\N	2020-10-03 19:22:03.237	t
1754	5	19	2020-10-05	15:10:00	15:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 15:16:18.48	t
1743	3	391	2020-10-03	23:00:00	23:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	paused	2020-10-03 21:00:43.874	t
1755	5	1	2020-10-05	15:50:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 15:37:00.674	t
1756	5	1	2020-10-05	15:40:00	15:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-05 15:40:17.039	t
1762	5	1	2020-10-07	17:00:00	17:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-07 16:09:57.848	t
1763	5	1	2020-10-07	17:00:00	17:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-07 16:09:57.857	t
1760	3	391	2020-10-05	21:00:00	21:15:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-10-05 19:45:40.133	t
1764	5	5	2020-10-08	10:00:00	10:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-07 16:13:18.905	t
1753	3	391	2020-10-05	23:00:00	23:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	paused	2020-10-05 14:52:26.525	t
1761	3	391	2020-10-05	21:15:00	21:30:00	\N	f	t	DOCTOR	30	DOCTOR	30	15	notRequired	online	completed	2020-10-05 20:02:24.185	t
1765	5	5	2020-10-09	17:00:00	17:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-08 16:27:08.055	t
1766	5	5	2020-10-09	17:00:00	17:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-08 16:27:08.08	t
1767	5	5	2020-10-09	17:10:00	17:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-08 16:27:47.298	t
1768	5	5	2020-10-09	17:10:00	17:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-08 16:27:47.322	t
1769	5	5	2020-10-09	01:50:00	02:00:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-08 16:30:27.175	t
1770	5	5	2020-10-09	01:50:00	02:00:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-08 16:30:27.209	t
1771	5	152	2020-10-11	10:00:00	10:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-09 11:25:05.559	t
1772	5	152	2020-10-09	11:20:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-09 11:26:50.689	t
1773	5	152	2020-10-12	11:10:00	11:20:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-10-10 11:01:48.818	t
1774	8	164	2020-10-12	09:30:00	10:00:00	\N	t	f	PATIENT	164	\N	\N	30	directPayment	online	notCompleted	2020-10-12 06:24:56.699	t
1775	2	164	2020-10-12	20:30:00	20:45:00	\N	t	f	PATIENT	164	\N	\N	15	directPayment	online	notCompleted	2020-10-12 06:51:41.192	t
1776	2	164	2020-10-13	15:45:00	16:00:00	\N	t	f	PATIENT	164	\N	\N	15	directPayment	online	notCompleted	2020-10-12 07:10:23.119	t
1669	5	1	2020-10-12	10:00:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	completed	2020-09-30 16:08:37.197	t
1777	5	164	2020-10-12	11:20:00	11:30:00	\N	f	t	DOCTOR	32	PATIENT	\N	10	notRequired	online	notCompleted	2020-10-12 08:22:38.069	t
1794	5	5	2020-10-25	13:30:00	13:40:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-23 17:57:57.207	t
1778	5	164	2020-10-12	14:00:00	14:10:00	\N	f	t	PATIENT	\N	DOCTOR	32	10	directPayment	online	completed	2020-10-12 08:26:46.038	t
1795	5	5	2020-10-25	14:00:00	14:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-23 18:42:51.909	t
1780	13	166	2020-10-13	08:30:00	09:00:00	\N	t	f	PATIENT	166	\N	\N	30	directPayment	online	notCompleted	2020-10-12 10:00:29.11	t
1781	5	166	2020-10-12	15:40:00	15:50:00	\N	t	f	PATIENT	166	\N	\N	10	directPayment	online	notCompleted	2020-10-12 10:07:33.436	t
1782	11	166	2020-10-12	18:00:00	18:30:00	\N	t	f	PATIENT	166	\N	\N	30	directPayment	online	notCompleted	2020-10-12 10:18:11.888	t
1779	5	164	2020-10-12	14:10:00	14:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	completed	2020-10-12 08:39:02.021	t
1796	5	5	2020-10-25	14:10:00	14:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-23 18:45:28.522	t
1797	5	5	2020-10-27	09:10:00	09:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-24 05:28:57.574	t
1783	5	164	2020-10-12	16:00:00	16:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	paused	2020-10-12 10:34:12.284	t
1784	17	164	2020-10-15	08:00:00	08:30:00	\N	t	f	PATIENT	164	\N	\N	30	directPayment	online	notCompleted	2020-10-15 12:19:02.578	t
1785	5	164	2020-10-16	09:00:00	09:10:00	\N	t	f	PATIENT	164	\N	\N	10	directPayment	online	notCompleted	2020-10-16 06:24:24.906	t
1786	5	164	2020-10-16	11:50:00	12:00:00	\N	f	t	PATIENT	164	DOCTOR	32	10	directPayment	online	notCompleted	2020-10-16 06:32:09.638	t
1787	5	164	2020-10-16	12:50:00	13:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-16 06:59:04.187	t
1788	5	164	2020-10-23	10:00:00	10:10:00	\N	t	f	DOCTOR	32	\N	\N	10	notRequired	online	notCompleted	2020-10-21 07:35:08.956	t
1789	5	164	2020-10-22	18:00:00	19:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-10-22 06:00:30.932	t
1790	5	5	2020-10-24	10:30:00	10:40:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-23 15:51:43.557	t
1791	5	5	2020-10-25	10:10:00	10:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-23 15:52:13.642	t
1792	5	5	2020-10-27	17:49:00	17:59:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-23 17:11:43.261	t
1793	5	5	2020-10-25	10:00:00	10:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-23 17:44:19.242	t
1798	3	4	2020-10-25	05:00:00	05:15:00	\N	t	f	DOCTOR	30	\N	\N	15	directPayment	online	notCompleted	2020-10-24 11:51:10.797	t
1799	5	1	2020-10-26	14:00:00	14:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-26 13:07:14.3	t
1800	5	4	2020-10-27	09:20:00	09:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-26 13:08:06.997	t
1801	5	5	2020-10-27	09:50:00	10:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-26 13:08:48.266	t
1802	5	5	2020-10-28	02:10:00	02:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-26 15:59:05.308	t
1803	5	5	2020-10-28	02:30:00	02:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-10-26 16:03:57.185	t
1804	5	79	2020-10-27	09:00:00	09:10:00	\N	t	f	PATIENT	79	\N	\N	10	directPayment	online	notCompleted	2020-10-26 18:14:42.595	t
1805	5	5	2020-10-28	03:30:00	03:40:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-27 15:01:54.23	t
1806	5	5	2020-10-28	08:00:00	08:10:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-27 15:03:48.389	t
1807	5	5	2020-10-28	10:10:00	10:20:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-27 15:06:46.795	t
1808	5	5	2020-10-28	10:40:00	10:50:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-27 15:07:41.129	t
1809	5	5	2020-10-28	02:40:00	02:50:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-27 15:34:47.902	t
1810	5	5	2020-10-28	02:50:00	03:00:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-27 15:45:22.865	t
1811	5	5	2020-10-28	08:30:00	08:40:00	\N	t	f	PATIENT	5	\N	\N	10	directPayment	online	notCompleted	2020-10-27 16:16:35.373	t
1812	3	86	2020-11-02	12:00:00	12:15:00	\N	t	f	DOCTOR	30	\N	\N	15	directPayment	inHospital	notCompleted	2020-10-31 07:13:03.156	t
1813	3	180	2020-10-31	15:00:00	15:15:00	\N	t	f	DOCTOR	30	\N	\N	15	notRequired	online	completed	2020-10-31 07:14:37.93	t
1814	1	171	2020-11-02	09:00:00	10:00:00	\N	t	f	PATIENT	171	\N	\N	60	directPayment	online	completed	2020-11-02 06:50:01.776	t
1815	5	105	2020-11-02	14:50:00	15:00:00	\N	t	f	PATIENT	105	\N	\N	10	directPayment	online	notCompleted	2020-11-02 13:11:56.283	t
1816	5	160	2020-11-04	17:20:00	17:30:00	\N	t	f	PATIENT	160	\N	\N	10	directPayment	online	notCompleted	2020-11-04 12:22:39.781	t
1817	5	192	2020-11-24	15:00:00	15:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-24 15:05:45.082	t
1818	5	192	2020-11-24	15:15:00	15:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:06:11.66	t
1820	5	194	2020-11-24	15:30:00	15:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:10:04.799	t
1819	5	192	2020-11-24	15:15:00	15:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:06:56.402	t
1821	5	192	2020-11-24	15:15:00	15:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-24 15:15:29.545	t
1822	5	192	2020-11-24	15:30:00	15:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:22:01.726	t
1823	5	192	2020-11-24	15:30:00	15:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:22:44.654	t
1824	5	194	2020-11-24	15:45:00	16:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:22:59.527	t
1825	5	194	2020-11-24	15:30:00	15:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:23:54.871	t
1826	5	192	2020-11-24	15:30:00	15:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:24:19.701	t
1827	5	192	2020-11-25	02:00:00	02:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:24:31.924	t
1828	5	192	2020-11-30	11:00:00	11:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-24 15:25:32.538	t
1829	6	85	2020-11-24	20:00:00	20:30:00	\N	t	f	PATIENT	85	\N	\N	30	directPayment	online	notCompleted	2020-11-24 15:36:32.107	t
1830	5	385	2020-11-24	16:00:00	17:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-24 15:45:33.415	t
1831	5	385	2020-11-24	16:00:00	17:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-24 15:46:25.688	t
1832	5	192	2020-11-24	22:00:00	23:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-11-24 15:47:43.686	t
1833	5	194	2020-11-24	21:00:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-24 15:48:30.842	t
1835	4	192	2020-11-26	16:30:00	16:45:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-26 08:33:19.79	t
1836	4	192	2020-11-26	16:45:00	17:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-26 08:33:35.647	t
1837	4	192	2020-11-26	17:00:00	17:15:00	\N	f	t	ADMIN	53	ADMIN	53	\N	directPayment	online	notCompleted	2020-11-26 08:34:06.718	t
1838	2	192	2020-11-26	12:00:00	12:15:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-26 09:37:16.615	t
1839	45	192	2020-11-28	14:00:00	14:20:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-26 09:41:56.65	t
1840	5	196	2020-11-26	10:35:00	10:50:00	\N	t	f	PATIENT	196	\N	\N	15	directPayment	online	completed	2020-11-26 09:51:59.298	t
1854	5	83	2020-11-26	14:00:00	14:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 12:22:37.536	t
1841	5	196	2020-11-26	19:00:00	19:15:00	\N	t	f	PATIENT	196	\N	\N	15	directPayment	online	paused	2020-11-26 10:04:31.563	t
1834	5	194	2020-11-26	09:35:00	10:35:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	completed	2020-11-26 08:16:52.358	t
1842	5	192	2020-11-26	11:30:00	11:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 11:37:24.958	t
1843	5	192	2020-11-26	11:45:00	12:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 11:41:17.277	t
1844	5	194	2020-11-26	11:45:00	12:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 11:41:35.149	t
1845	5	194	2020-11-26	11:45:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 11:41:54.285	t
1846	5	192	2020-11-26	12:05:00	12:20:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 11:42:10.423	t
1847	5	198	2020-11-26	12:20:00	12:35:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 11:43:23.686	t
1849	5	200	2020-11-26	12:50:00	13:05:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 11:53:34.382	t
1848	5	194	2020-11-26	12:35:00	12:50:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 11:52:58.28	t
1853	5	206	2020-11-26	13:20:00	13:35:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 12:22:13.722	t
1852	5	204	2020-11-26	13:05:00	13:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 12:21:13.768	t
1851	5	202	2020-11-26	12:50:00	13:05:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 12:20:20.386	t
1850	5	140	2020-11-26	12:35:00	12:50:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 12:19:37.118	t
1855	5	192	2020-11-26	12:35:00	12:50:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 12:23:37.022	t
1858	5	192	2020-11-26	12:35:00	12:50:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 12:26:32.546	t
1856	5	140	2020-11-26	12:50:00	13:05:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 12:23:55.462	t
1857	5	208	2020-11-26	13:05:00	13:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 12:24:39.48	t
1859	5	210	2020-11-26	12:50:00	13:05:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 12:27:28.32	t
1860	5	149	2020-11-26	13:05:00	13:20:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 12:28:02.844	t
1861	5	211	2020-11-26	13:20:00	13:35:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 12:28:42.739	t
1862	5	213	2020-11-26	14:00:00	14:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 13:42:37.912	t
1864	5	215	2020-11-26	14:30:00	14:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 14:06:48.391	t
1865	5	192	2020-11-26	18:00:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 16:04:57.526	t
1868	5	221	2020-11-27	09:00:00	09:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 16:36:35.753	t
1867	5	219	2020-11-26	18:30:00	18:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 16:28:12.658	t
1866	5	217	2020-11-26	18:15:00	18:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 16:05:33.53	t
1869	5	224	2020-11-26	18:15:00	18:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 16:38:38.411	t
1870	5	226	2020-11-26	18:30:00	18:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 16:50:38.85	t
1871	5	227	2020-11-26	18:45:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-26 17:07:31.529	t
1874	5	119	2020-11-29	10:15:00	10:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 19:41:13.85	t
1873	5	192	2020-11-28	09:15:00	09:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 19:38:02.821	t
1877	5	192	2020-11-27	09:45:00	10:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-27 09:51:41.118	t
1878	5	192	2020-11-27	10:15:00	10:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-27 10:15:57.876	t
1879	5	235	2020-11-28	10:00:00	10:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 10:19:29.212	t
1875	5	231	2020-11-27	11:00:00	11:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 05:27:25.025	t
1876	5	233	2020-11-27	11:15:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 05:28:45.129	t
1882	5	239	2020-11-28	10:00:00	10:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 10:23:23.032	t
1881	5	192	2020-11-27	10:45:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 10:22:21.131	t
1880	5	237	2020-11-27	10:30:00	10:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 10:21:56.981	t
1883	5	387	2020-11-27	11:15:00	11:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 10:24:02.605	t
1884	5	192	2020-11-27	17:49:00	18:04:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 10:24:42.377	t
1885	5	192	2020-11-27	10:45:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 10:25:08.496	t
1872	5	84	2020-11-27	19:30:00	19:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-26 19:36:33.218	t
1886	5	192	2020-11-27	10:30:00	10:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-27 10:25:59.441	t
1887	5	241	2020-11-27	10:45:00	11:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	completed	2020-11-27 10:28:26.062	t
1888	5	243	2020-11-27	10:45:00	11:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2020-11-27 10:40:52.352	t
1904	5	247	2020-11-27	18:49:00	19:49:00	\N	f	t	PATIENT	247	DOCTOR	32	60	directPayment	online	completed	2020-11-27 12:23:37.627	t
1889	5	5	2020-11-27	22:45:00	23:00:00	\N	f	t	PATIENT	5	DOCTOR	32	15	directPayment	online	completed	2020-11-27 10:55:38.296	t
1906	5	253	2020-11-27	17:49:00	18:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-27 12:39:56.526	t
1901	5	192	2020-11-27	17:49:00	18:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-27 12:14:45.77	t
1896	5	249	2020-11-27	11:15:00	11:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-27 11:28:13.567	t
1897	5	251	2020-11-27	11:30:00	11:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-27 11:28:59.553	t
1898	5	400	2020-11-27	18:34:00	18:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 11:34:31.997	t
1900	5	5	2020-11-27	22:15:00	22:30:00	\N	f	t	PATIENT	5	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 11:43:52.783	t
1902	5	192	2020-11-27	21:00:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-27 12:15:05.979	t
1890	5	245	2020-11-27	17:49:00	18:04:00	\N	f	t	PATIENT	245	DOCTOR	32	15	directPayment	online	\N	2020-11-27 11:01:12.499	t
1893	5	245	2020-11-27	18:19:00	18:34:00	\N	f	t	PATIENT	245	DOCTOR	32	15	directPayment	online	\N	2020-11-27 11:09:47.132	t
1895	5	247	2020-11-27	18:49:00	19:04:00	\N	f	t	PATIENT	247	DOCTOR	32	15	directPayment	online	completed	2020-11-27 11:23:10.648	t
1894	5	247	2020-11-27	22:30:00	22:45:00	\N	f	t	PATIENT	247	DOCTOR	32	15	directPayment	online	paused	2020-11-27 11:15:07.619	t
1899	5	247	2020-11-27	19:04:00	19:19:00	\N	t	f	PATIENT	247	\N	\N	15	directPayment	online	paused	2020-11-27 11:34:55.305	t
1903	5	247	2020-11-27	22:00:00	23:00:00	\N	f	t	PATIENT	247	PATIENT	\N	60	directPayment	online	paused	2020-11-27 12:18:00.901	t
1905	13	247	2020-11-30	08:00:00	08:30:00	\N	t	f	PATIENT	247	\N	\N	30	onlineCollection	online	notCompleted	2020-11-27 12:36:53.598	t
1891	5	245	2020-11-27	18:04:00	18:19:00	\N	f	t	PATIENT	245	DOCTOR	32	15	directPayment	online	completed	2020-11-27 11:05:22.909	t
1907	5	245	2020-11-27	21:00:00	22:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-11-27 12:41:00.045	t
1910	6	85	2020-11-27	20:00:00	20:30:00	\N	t	f	PATIENT	85	\N	\N	30	onlineCollection	online	notCompleted	2020-11-27 13:35:59.605	t
1911	5	247	2020-11-27	22:00:00	23:00:00	\N	t	f	PATIENT	247	\N	\N	60	directPayment	online	notCompleted	2020-11-27 13:44:53.355	t
1909	5	85	2020-11-27	18:49:00	19:49:00	\N	f	t	PATIENT	85	DOCTOR	32	60	onlineCollection	online	notCompleted	2020-11-27 13:35:17.937	t
1912	5	382	2020-11-27	18:49:00	19:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-27 14:51:05.207	t
1913	5	258	2020-11-27	18:49:00	19:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	completed	2020-11-27 14:56:01.819	t
1914	5	258	2020-11-27	18:49:00	19:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	completed	2020-11-27 14:57:53.98	t
1908	5	254	2020-11-27	17:49:00	18:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-27 13:33:14.572	t
1892	5	5	2020-11-28	19:15:00	19:30:00	\N	f	t	PATIENT	5	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-27 11:06:14.853	t
1917	5	192	2020-11-28	11:00:00	12:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-11-28 08:10:38.586	t
1916	5	258	2020-11-28	12:00:00	13:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	completed	2020-11-28 07:53:46.232	t
1920	45	152	2020-11-28	14:20:00	14:40:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-28 12:39:37.161	t
1918	5	192	2020-11-28	17:00:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-28 08:11:14.313	t
1954	6	275	2020-12-01	16:00:00	16:30:00	\N	f	t	PATIENT	275	DOCTOR	33	30	directPayment	online	notCompleted	2020-12-01 09:46:33.083	t
1919	5	247	2020-11-28	18:00:00	19:00:00	\N	f	t	PATIENT	247	DOCTOR	32	60	directPayment	online	paused	2020-11-28 08:33:22.675	t
1943	5	5	2020-11-30	21:00:00	21:20:00	\N	f	t	PATIENT	5	DOCTOR	32	20	directPayment	online	paused	2020-11-30 14:43:04.65	t
1921	5	258	2020-11-28	17:00:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	paused	2020-11-28 13:42:38.709	t
1923	5	382	2020-11-28	18:00:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	60	directPayment	online	notCompleted	2020-11-28 13:49:46.694	t
1922	5	258	2020-11-28	16:00:00	17:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-28 13:49:05.182	t
1924	5	260	2020-11-28	16:00:00	17:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	60	directPayment	online	notCompleted	2020-11-28 13:53:27.126	t
1925	45	152	2020-11-28	15:00:00	15:20:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-28 15:11:05.064	t
1926	45	152	2020-11-28	18:00:00	18:20:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-28 15:11:27.628	t
1927	45	152	2020-11-28	18:20:00	18:40:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-28 15:11:41.573	t
1928	45	152	2020-11-28	15:40:00	16:00:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-28 15:12:04.784	t
1929	4	152	2020-11-28	15:43:00	15:58:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-28 15:12:40.569	t
1930	5	194	2020-11-30	10:35:00	10:50:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-11-30 08:05:20.575	t
1931	5	261	2020-11-30	13:05:00	13:20:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-30 08:06:29.133	t
1932	5	261	2020-11-30	10:50:00	11:05:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-11-30 08:07:36.154	t
1933	5	261	2020-11-30	11:20:00	11:35:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2020-11-30 08:08:08.915	t
1946	5	268	2020-11-30	21:00:00	21:20:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	paused	2020-11-30 15:05:20.171	t
1935	5	446	2020-11-30	16:20:00	16:35:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	notCompleted	2020-11-30 09:59:18.694	t
1936	5	194	2020-11-30	17:10:00	17:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-11-30 11:08:11.552	t
1934	5	262	2020-11-30	13:50:00	14:05:00	\N	f	t	PATIENT	262	DOCTOR	32	15	directPayment	online	completed	2020-11-30 08:13:11.89	t
1938	5	258	2020-11-30	17:10:00	17:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-11-30 12:02:18.085	t
1937	5	192	2020-11-30	19:10:00	19:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-11-30 11:10:09.096	t
1939	5	258	2020-11-30	17:40:00	18:10:00	\N	t	f	ADMIN	53	\N	\N	\N	directPayment	online	notCompleted	2020-11-30 13:08:11.99	t
1940	5	258	2020-11-30	20:20:00	20:40:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	paused	2020-11-30 19:22:13.42	t
1941	6	85	2020-11-30	20:00:00	20:30:00	\N	t	f	PATIENT	85	\N	\N	30	directPayment	online	notCompleted	2020-11-30 14:03:56.498	t
1942	5	85	2020-12-01	09:00:00	09:20:00	\N	f	t	PATIENT	85	PATIENT	\N	20	directPayment	online	notCompleted	2020-11-30 14:05:21.531	t
1944	5	85	2020-11-30	20:40:00	21:00:00	\N	t	f	PATIENT	\N	\N	\N	20	directPayment	online	notCompleted	2020-11-30 14:56:46.31	t
1947	5	194	2020-12-01	13:20:00	13:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	20	directPayment	online	notCompleted	2020-12-01 07:36:16.771	t
1948	5	194	2020-12-01	14:00:00	14:20:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	paused	2020-12-01 07:38:10.892	t
1945	5	268	2020-12-01	09:00:00	09:20:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	paused	2020-11-30 15:04:00.084	t
1956	6	269	2020-12-01	16:00:00	16:30:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	paused	2020-12-01 10:02:36.125	t
1961	5	247	2020-12-01	17:20:00	17:40:00	\N	t	f	PATIENT	247	\N	\N	20	directPayment	online	paused	2020-12-01 11:20:51.563	t
1950	1	194	2020-12-01	14:00:00	15:00:00	\N	t	f	DOCTOR	28	\N	\N	60	directPayment	online	notCompleted	2020-12-01 08:08:32.967	t
1953	6	247	2020-12-01	15:30:00	16:00:00	\N	t	f	PATIENT	247	\N	\N	30	directPayment	online	notCompleted	2020-12-01 09:46:12.597	t
1952	6	275	2020-12-01	22:00:00	22:30:00	\N	t	f	PATIENT	275	\N	\N	30	directPayment	online	paused	2020-12-01 09:44:26.254	t
1955	6	276	2020-12-01	17:00:00	17:30:00	\N	t	f	PATIENT	276	\N	\N	30	directPayment	online	notCompleted	2020-12-01 09:57:45.866	t
1957	5	269	2020-12-01	15:40:00	16:00:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	notCompleted	2020-12-01 10:05:10.503	t
1949	5	269	2020-12-01	13:20:00	13:40:00	\N	t	f	PATIENT	269	\N	\N	20	directPayment	online	paused	2020-12-01 07:42:26.207	t
1959	6	247	2020-12-01	17:30:00	18:00:00	\N	t	f	PATIENT	247	\N	\N	30	directPayment	online	notCompleted	2020-12-01 11:12:39.598	t
1958	5	269	2020-12-01	16:40:00	17:00:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	paused	2020-12-01 11:04:48.436	t
1963	5	247	2020-12-01	18:00:00	18:20:00	\N	t	f	PATIENT	247	\N	\N	20	directPayment	online	paused	2020-12-01 11:27:33.074	t
1951	5	85	2020-12-03	09:35:00	09:55:00	\N	f	t	PATIENT	85	PATIENT	\N	20	directPayment	online	notCompleted	2020-12-01 09:23:28.511	t
1962	5	269	2020-12-01	17:40:00	18:00:00	\N	t	f	PATIENT	269	\N	\N	20	directPayment	online	completed	2020-12-01 11:26:19.578	t
1964	5	192	2020-12-01	13:00:00	13:20:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	notCompleted	2020-12-01 12:08:19.136	t
1965	5	192	2020-12-01	12:20:00	12:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	20	directPayment	online	notCompleted	2020-12-01 12:09:02.48	t
1966	5	192	2020-12-01	13:40:00	14:00:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	notCompleted	2020-12-01 12:09:17.54	t
1967	5	276	2020-12-01	21:00:00	21:20:00	\N	t	f	PATIENT	276	\N	\N	20	directPayment	online	\N	2020-12-01 12:09:31.032	t
1968	6	279	2020-12-01	18:00:00	18:30:00	\N	f	t	PATIENT	279	PATIENT	\N	30	onlineCollection	online	notCompleted	2020-12-01 12:13:26.911	t
1969	6	279	2020-12-01	18:00:00	18:30:00	\N	f	t	PATIENT	279	PATIENT	\N	30	onlineCollection	online	notCompleted	2020-12-01 12:22:30.939	t
1960	5	247	2020-12-01	17:00:00	17:20:00	\N	t	f	PATIENT	247	\N	\N	20	directPayment	online	completed	2020-12-01 11:14:29.169	t
1971	6	279	2020-12-01	18:30:00	19:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-01 12:24:09.41	t
1972	6	279	2020-12-01	18:00:00	18:30:00	\N	t	f	PATIENT	\N	\N	\N	30	directPayment	online	notCompleted	2020-12-01 12:24:50.393	t
1973	5	202	2020-12-01	18:20:00	18:40:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	notCompleted	2020-12-01 12:37:27.081	t
1974	5	276	2020-12-01	19:20:00	19:40:00	\N	t	f	PATIENT	276	\N	\N	20	directPayment	online	\N	2020-12-01 12:38:54.004	t
1996	5	85	2020-12-04	00:00:00	00:10:00	\N	f	t	PATIENT	85	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-02 14:03:49.459	t
1995	5	85	2020-12-03	10:35:00	10:45:00	\N	f	t	PATIENT	85	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-02 14:00:36.105	t
1999	5	86	2020-12-02	19:50:00	20:00:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-12-02 14:11:37.415	t
2000	5	269	2020-12-02	20:00:00	20:10:00	\N	t	f	PATIENT	269	\N	\N	10	directPayment	online	notCompleted	2020-12-02 14:15:20.16	t
1997	5	85	2020-12-02	21:10:00	21:20:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	paused	2020-12-02 14:05:53.828	t
1977	6	269	2020-12-01	19:00:00	19:30:00	\N	t	f	PATIENT	269	\N	\N	30	directPayment	online	paused	2020-12-01 12:55:21.456	t
1976	6	279	2020-12-01	18:30:00	19:00:00	\N	t	f	PATIENT	279	\N	\N	30	onlineCollection	online	completed	2020-12-01 12:49:23.331	t
2001	5	85	2020-12-02	20:10:00	20:20:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	notCompleted	2020-12-02 14:28:39.971	t
2003	6	85	2020-12-03	09:00:00	09:30:00	\N	t	f	PATIENT	85	\N	\N	30	onlineCollection	online	notCompleted	2020-12-02 14:32:32.074	t
1979	5	85	2020-12-01	14:30:00	14:45:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	notCompleted	2020-12-01 13:21:56.677	t
1975	5	276	2020-12-01	20:40:00	21:00:00	\N	t	f	PATIENT	276	\N	\N	20	directPayment	online	paused	2020-12-01 12:42:59.735	t
1980	17	267	2020-12-03	08:00:00	08:30:00	\N	t	f	PATIENT	267	\N	\N	30	onlineCollection	online	notCompleted	2020-12-02 07:31:31.688	t
1978	6	267	2020-12-02	15:45:00	16:15:00	\N	f	t	PATIENT	267	PATIENT	\N	30	onlineCollection	online	notCompleted	2020-12-01 12:59:31.793	t
1981	6	267	2020-12-03	09:30:00	10:00:00	\N	t	f	PATIENT	\N	\N	\N	30	directPayment	online	notCompleted	2020-12-02 07:35:21.169	t
1982	5	194	2020-12-02	12:00:00	12:10:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-12-02 07:36:56.66	t
1983	5	194	2020-12-02	12:00:00	12:10:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-12-02 07:39:03.856	t
1984	5	194	2020-12-02	12:10:00	12:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-12-02 07:40:01.2	t
1985	5	269	2020-12-02	13:20:00	13:30:00	\N	t	f	PATIENT	269	\N	\N	10	directPayment	online	completed	2020-12-02 07:47:55.329	t
1986	5	269	2020-12-02	13:40:00	13:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	completed	2020-12-02 08:07:45.165	t
1987	5	276	2020-12-02	18:30:00	18:40:00	\N	t	f	PATIENT	276	\N	\N	10	directPayment	online	notCompleted	2020-12-02 09:32:31.434	t
1988	5	281	2020-12-02	18:10:00	18:20:00	\N	f	t	PATIENT	281	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-02 09:50:47.15	t
1989	5	194	2020-12-02	19:00:00	19:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-12-02 13:20:54.514	t
1990	5	192	2020-12-02	19:20:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-12-02 13:35:00.411	t
1991	5	85	2020-12-02	19:10:00	19:20:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-02 13:39:14.583	t
1992	5	85	2020-12-02	19:30:00	19:40:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	notCompleted	2020-12-02 13:43:37.795	t
1993	5	85	2020-12-02	19:40:00	19:50:00	\N	f	t	PATIENT	85	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-12-02 13:56:15.941	t
1994	5	85	2020-12-03	09:35:00	09:45:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	notCompleted	2020-12-02 13:56:55.537	t
2015	5	85	2020-12-03	16:00:00	16:30:00	\N	t	f	PATIENT	85	\N	\N	30	onlineCollection	online	completed	2020-12-03 13:56:58.854	t
2010	5	85	2020-12-03	14:00:00	14:30:00	\N	t	f	PATIENT	85	\N	\N	30	onlineCollection	online	completed	2020-12-03 13:10:53.013	t
2009	5	269	2020-12-03	13:30:00	14:00:00	\N	t	f	PATIENT	269	\N	\N	30	directPayment	online	completed	2020-12-03 13:08:43.08	t
2002	6	85	2020-12-02	20:30:00	21:00:00	\N	t	f	PATIENT	85	\N	\N	30	onlineCollection	online	paused	2020-12-02 14:31:30.672	t
2004	6	269	2020-12-02	21:00:00	21:30:00	\N	t	f	PATIENT	269	\N	\N	30	directPayment	online	paused	2020-12-02 14:34:01.628	t
2005	5	258	2020-12-02	21:20:00	21:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-12-02 15:44:26.802	t
2006	5	282	2020-12-03	12:35:00	12:45:00	\N	t	f	PATIENT	282	\N	\N	10	directPayment	online	notCompleted	2020-12-03 12:24:38.394	t
2007	5	192	2020-12-03	13:30:00	14:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-12-03 13:06:17.34	t
2008	5	192	2020-12-03	15:00:00	15:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-12-03 13:06:40.525	t
2011	6	194	2020-12-03	13:30:00	14:00:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	notCompleted	2020-12-03 13:30:15.635	t
2012	6	269	2020-12-03	14:00:00	14:30:00	\N	t	f	DOCTOR	33	\N	\N	30	directPayment	online	notCompleted	2020-12-03 13:30:52.306	t
2013	5	267	2020-12-03	14:30:00	15:00:00	\N	t	f	PATIENT	267	\N	\N	30	onlineCollection	online	notCompleted	2020-12-03 13:53:24.158	t
2016	5	85	2020-12-03	16:30:00	17:00:00	\N	t	f	PATIENT	85	\N	\N	30	onlineCollection	online	completed	2020-12-03 13:57:45.288	t
2014	5	269	2020-12-03	15:30:00	16:00:00	\N	t	f	PATIENT	269	\N	\N	30	directPayment	online	paused	2020-12-03 13:56:18.917	t
2022	5	86	2020-12-03	19:00:00	19:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-12-03 18:58:23.995	t
2020	5	4	2020-12-03	18:00:00	18:30:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-12-03 17:07:58.761	t
2018	5	381	2020-12-03	17:30:00	18:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	paused	2020-12-03 16:07:05.174	t
2019	3	105	2020-12-03	20:00:00	20:15:00	\N	t	f	PATIENT	105	\N	\N	15	directPayment	online	notCompleted	2020-12-03 16:52:08.483	t
2017	5	267	2020-12-03	17:00:00	17:30:00	\N	t	f	PATIENT	267	\N	\N	30	onlineCollection	online	paused	2020-12-03 15:59:08.001	t
2021	5	267	2020-12-03	18:30:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	paused	2020-12-03 17:15:35.269	t
2026	5	269	2020-12-03	19:40:00	19:50:00	\N	t	f	PATIENT	269	\N	\N	10	directPayment	online	notCompleted	2020-12-03 19:03:55.175	t
1998	5	85	2020-12-15	11:00:00	11:10:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-02 14:08:59.672	t
2025	5	85	2020-12-03	19:30:00	19:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	completed	2020-12-03 19:02:39.602	t
2024	5	85	2020-12-03	19:20:00	19:30:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	completed	2020-12-03 19:02:05.902	t
2036	5	269	2020-12-04	00:00:00	00:10:00	\N	f	t	DOCTOR	32	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-03 22:13:57.215	t
2049	5	269	2020-12-04	00:50:00	01:00:00	\N	f	t	PATIENT	269	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-03 23:22:58.786	t
2066	5	85	2020-12-07	21:30:00	21:40:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	notCompleted	2020-12-07 20:56:13.393	t
2056	5	306	2020-12-04	17:49:00	18:09:00	\N	f	t	PATIENT	306	PATIENT	\N	20	directPayment	online	paused	2020-12-04 13:41:04.611	t
2057	5	306	2020-12-04	18:09:00	18:29:00	\N	t	f	PATIENT	\N	\N	\N	20	directPayment	online	notCompleted	2020-12-04 13:56:49.639	t
2058	5	85	2020-12-04	19:09:00	19:29:00	\N	t	f	PATIENT	85	\N	\N	20	onlineCollection	online	notCompleted	2020-12-04 13:58:17.556	t
2047	5	305	2020-12-03	23:20:00	23:30:00	\N	t	f	PATIENT	305	\N	\N	10	onlineCollection	online	paused	2020-12-03 23:18:36.264	t
2027	5	267	2020-12-03	20:10:00	20:20:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	completed	2020-12-03 19:34:02.446	t
2028	5	267	2020-12-03	20:20:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	completed	2020-12-03 20:02:30.157	t
2029	5	283	2020-12-03	20:30:00	20:40:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-12-03 20:28:21.908	t
2030	5	269	2020-12-03	20:40:00	20:50:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	notCompleted	2020-12-03 20:28:42.904	t
2059	5	307	2020-12-04	18:29:00	18:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	20	directPayment	online	notCompleted	2020-12-04 18:12:16.673	t
2031	5	269	2020-12-03	21:00:00	21:10:00	\N	t	f	DOCTOR	32	\N	\N	10	directPayment	online	paused	2020-12-03 20:55:09.833	t
2050	5	269	2020-12-03	23:40:00	23:50:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	paused	2020-12-03 23:23:21.614	t
2032	5	269	2020-12-03	22:10:00	22:20:00	\N	t	f	PATIENT	269	\N	\N	10	directPayment	online	paused	2020-12-03 22:06:14.286	t
2048	5	269	2020-12-03	23:30:00	23:40:00	\N	t	f	PATIENT	269	\N	\N	10	directPayment	online	paused	2020-12-03 23:19:24.452	t
2033	5	283	2020-12-03	22:20:00	22:30:00	\N	f	t	PATIENT	283	DOCTOR	32	10	onlineCollection	online	paused	2020-12-03 22:07:29.462	t
2034	5	269	2020-12-04	00:00:00	00:10:00	\N	f	t	DOCTOR	32	DOCTOR	32	10	directPayment	online	notCompleted	2020-12-03 22:12:20.859	t
2035	5	269	2020-12-04	00:10:00	00:20:00	\N	f	t	DOCTOR	32	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-03 22:12:34.204	t
2037	5	283	2020-12-04	00:10:00	00:20:00	\N	f	t	PATIENT	283	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-12-03 22:16:33.075	t
2038	5	283	2020-12-03	22:20:00	22:30:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	notCompleted	2020-12-03 22:16:51.07	t
2039	5	267	2020-12-04	00:40:00	00:50:00	\N	f	t	PATIENT	267	PATIENT	\N	10	onlineCollection	online	notCompleted	2020-12-03 22:24:06.873	t
2040	5	267	2020-12-03	23:10:00	23:20:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-03 22:24:46.11	t
2041	5	267	2020-12-03	23:00:00	23:10:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-03 22:26:03.079	t
2042	5	267	2020-12-03	23:10:00	23:20:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-03 22:26:41.309	t
2043	5	267	2020-12-03	23:00:00	23:10:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-03 22:27:26.438	t
2044	5	267	2020-12-03	23:10:00	23:20:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-03 22:29:08.053	t
2045	5	267	2020-12-03	23:00:00	23:10:00	\N	t	f	PATIENT	\N	\N	\N	10	directPayment	online	notCompleted	2020-12-03 22:30:58.902	t
2046	5	85	2020-12-14	11:00:00	11:10:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-03 23:14:07.084	t
2053	17	267	2020-12-07	08:00:00	08:30:00	\N	t	f	PATIENT	267	\N	\N	30	onlineCollection	online	notCompleted	2020-12-04 13:01:51.235	t
2052	5	85	2020-12-04	17:49:00	17:59:00	\N	f	t	PATIENT	\N	PATIENT	\N	10	directPayment	online	notCompleted	2020-12-04 12:41:40.496	t
2054	5	194	2020-12-04	17:49:00	18:09:00	\N	f	t	DOCTOR	32	DOCTOR	32	20	directPayment	online	notCompleted	2020-12-04 13:36:22.02	t
2055	5	194	2020-12-04	18:09:00	18:29:00	\N	f	t	DOCTOR	32	DOCTOR	32	20	directPayment	online	notCompleted	2020-12-04 13:36:41.564	t
2060	5	307	2020-12-04	19:29:00	19:49:00	\N	f	t	DOCTOR	32	DOCTOR	32	20	directPayment	online	notCompleted	2020-12-04 18:12:39.508	t
2061	5	258	2020-12-05	12:20:00	12:40:00	\N	t	f	DOCTOR	32	\N	\N	20	notRequired	online	notCompleted	2020-12-05 12:18:22.795	t
2067	1	85	2020-12-08	13:00:00	14:00:00	\N	t	f	PATIENT	85	\N	\N	60	onlineCollection	online	notCompleted	2020-12-08 11:44:22.048	t
2051	5	269	2020-12-04	21:00:00	21:10:00	\N	t	f	PATIENT	269	\N	\N	10	directPayment	online	paused	2020-12-03 23:25:27.962	t
2068	5	194	2020-12-08	19:55:00	20:10:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-12-08 19:53:56.058	t
2062	5	258	2020-12-05	16:00:00	16:20:00	\N	t	f	DOCTOR	32	\N	\N	20	directPayment	online	\N	2020-12-05 14:28:27.742	t
2063	5	194	2020-12-07	21:00:00	21:25:00	\N	f	t	DOCTOR	32	DOCTOR	32	25	directPayment	online	notCompleted	2020-12-07 14:17:18.866	t
2064	5	194	2020-12-07	22:00:00	22:25:00	\N	f	t	DOCTOR	32	DOCTOR	32	25	directPayment	online	paused	2020-12-07 14:17:43.666	t
2065	5	85	2020-12-07	21:00:00	21:10:00	\N	t	f	PATIENT	85	\N	\N	10	onlineCollection	online	paused	2020-12-07 14:42:17.86	t
2069	5	194	2020-12-08	20:10:00	20:25:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-12-08 19:54:07.937	t
2070	5	310	2020-12-08	20:10:00	20:25:00	\N	t	f	PATIENT	310	\N	\N	15	directPayment	online	paused	2020-12-08 19:56:30.727	t
2071	5	310	2020-12-08	20:25:00	20:40:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2020-12-08 20:05:32.205	t
2073	5	404	2020-12-08	21:40:00	21:55:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-12-08 21:06:23.148	t
2072	5	404	2020-12-08	21:10:00	21:25:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-12-08 21:06:01.935	t
2074	5	311	2020-12-08	21:10:00	21:25:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-12-08 21:07:25.567	t
2075	5	311	2020-12-08	21:40:00	21:55:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-12-08 21:07:34.175	t
2076	5	311	2020-12-08	21:25:00	21:40:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-12-08 21:07:45.405	t
2079	6	312	2020-12-09	13:45:00	13:55:00	\N	t	f	PATIENT	312	\N	\N	10	onlineCollection	online	notCompleted	2020-12-08 21:14:08.168	t
2080	5	85	2020-12-08	21:55:00	22:10:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	completed	2020-12-08 21:19:35.45	t
2078	5	312	2020-12-08	21:40:00	21:55:00	\N	t	f	PATIENT	312	\N	\N	15	onlineCollection	online	completed	2020-12-08 21:11:52.295	t
2081	5	313	2020-12-11	12:15:00	12:45:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-12-11 12:15:25.346	t
2082	5	314	2020-12-11	12:45:00	13:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	30	directPayment	online	notCompleted	2020-12-11 12:16:03.455	t
2083	5	314	2020-12-11	13:15:00	13:45:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-12-11 12:20:43.94	t
2084	5	314	2020-12-11	15:15:00	15:45:00	\N	f	t	PATIENT	314	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 12:21:47.574	t
2085	5	314	2020-12-11	12:45:00	13:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 12:21:57.069	t
2087	5	314	2020-12-11	14:15:00	14:45:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-12-11 12:22:17.373	t
2086	5	314	2020-12-11	13:45:00	14:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 12:22:05.629	t
2088	5	314	2020-12-11	12:45:00	13:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 12:25:51.277	t
2089	5	314	2020-12-11	16:45:00	17:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 12:27:20.134	t
2090	5	314	2020-12-11	12:45:00	13:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 12:27:59.301	t
2091	5	5	2020-12-14	14:00:00	14:30:00	\N	f	t	PATIENT	5	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 14:26:13.73	t
2093	5	16	2020-12-11	18:15:00	18:45:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-12-11 14:37:47.114	t
2094	5	391	2020-12-11	17:45:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-12-11 14:38:30.813	t
2095	5	315	2020-12-11	18:45:00	19:15:00	\N	t	f	DOCTOR	32	\N	\N	30	directPayment	online	notCompleted	2020-12-11 14:40:38.458	t
2096	5	315	2020-12-14	15:30:00	16:00:00	\N	f	t	DOCTOR	32	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 14:41:15.062	t
2097	5	315	2020-12-29	22:55:00	23:25:00	\N	t	f	PATIENT	\N	\N	\N	30	directPayment	online	notCompleted	2020-12-11 15:04:04.707	t
2098	16	315	2020-12-29	10:00:00	10:30:00	\N	t	f	PATIENT	315	\N	\N	30	directPayment	online	notCompleted	2020-12-11 15:55:46.277	t
2100	5	315	2020-12-17	18:00:00	18:30:00	\N	t	f	PATIENT	315	\N	\N	30	directPayment	online	notCompleted	2020-12-11 15:56:30.106	t
2099	5	316	2020-12-11	16:15:00	16:45:00	\N	f	t	DOCTOR	32	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 15:55:52.808	t
2101	5	316	2020-12-21	14:00:00	14:30:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 15:58:41.631	t
2102	5	316	2020-12-11	16:15:00	16:45:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 16:00:46.849	t
2104	5	316	2020-12-21	14:00:00	14:30:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 16:03:33.36	t
2103	5	316	2020-12-11	16:45:00	17:15:00	\N	f	t	DOCTOR	32	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 16:03:22.145	t
2105	5	316	2020-12-21	14:30:00	15:00:00	\N	t	f	PATIENT	\N	\N	\N	30	directPayment	online	notCompleted	2020-12-11 16:04:02.161	t
2107	5	404	2020-12-11	19:30:00	19:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	notCompleted	2020-12-11 18:38:28.846	t
2108	5	404	2020-12-11	19:15:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-11 18:38:37.633	t
2109	5	317	2020-12-11	19:30:00	19:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-11 18:41:10.618	t
2110	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	85	PATIENT	\N	15	onlineCollection	online	notCompleted	2020-12-11 18:41:50.171	t
2111	5	85	2020-12-11	20:00:00	20:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:41:55.948	t
2112	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:42:01.209	t
2113	5	85	2020-12-11	20:00:00	20:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:42:08.901	t
2114	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:42:25.12	t
2115	5	85	2020-12-11	20:00:00	20:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:42:34.285	t
2116	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:42:54.521	t
2117	5	85	2020-12-11	20:00:00	20:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:43:05.132	t
2118	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:43:51.218	t
2119	5	85	2020-12-11	20:15:00	20:30:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:44:02.26	t
2120	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:44:23.855	t
2121	5	85	2020-12-11	20:00:00	20:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:48:27.699	t
2122	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:48:34.77	t
2123	5	85	2020-12-11	20:00:00	20:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:53:40.697	t
2124	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:54:04.849	t
2125	5	85	2020-12-11	20:00:00	20:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 18:59:31.71	t
2126	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 19:00:10.369	t
2127	5	85	2020-12-11	20:00:00	20:15:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 19:00:21.266	t
2128	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-11 19:00:29.181	t
2131	11	318	2020-12-14	08:00:00	08:30:00	\N	f	t	PATIENT	318	PATIENT	\N	30	onlineCollection	online	notCompleted	2020-12-11 19:22:50.532	t
2132	11	318	2020-12-15	08:00:00	08:30:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 19:23:16.588	t
2133	11	318	2020-12-14	08:00:00	08:30:00	\N	f	t	PATIENT	\N	PATIENT	\N	30	directPayment	online	notCompleted	2020-12-11 19:23:33.077	t
2130	5	85	2020-12-11	19:45:00	20:00:00	\N	f	t	PATIENT	85	DOCTOR	32	15	onlineCollection	online	notCompleted	2020-12-11 19:20:12.789	t
2129	5	85	2020-12-11	20:00:00	20:15:00	\N	f	t	PATIENT	\N	DOCTOR	32	15	directPayment	online	notCompleted	2020-12-11 19:19:57.172	t
2106	5	258	2020-12-11	20:45:00	21:15:00	\N	f	t	PATIENT	258	DOCTOR	32	30	directPayment	online	notCompleted	2020-12-11 17:50:04.949	t
2134	5	85	2020-12-11	20:00:00	20:15:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	paused	2020-12-11 19:44:41.426	t
2092	5	5	2020-12-22	21:25:00	21:55:00	\N	t	f	PATIENT	\N	\N	\N	30	directPayment	online	\N	2020-12-11 14:26:33.777	t
2135	5	258	2020-12-11	20:15:00	20:30:00	\N	t	f	PATIENT	258	\N	\N	15	directPayment	online	paused	2020-12-11 19:44:48.538	t
2136	5	319	2020-12-11	21:15:00	21:30:00	\N	t	f	PATIENT	319	\N	\N	15	onlineCollection	online	paused	2020-12-11 21:02:57.839	t
2161	5	446	2020-12-23	01:30:00	01:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-23 00:24:02.483	t
2137	5	320	2020-12-12	13:00:00	13:15:00	\N	t	f	PATIENT	320	\N	\N	15	directPayment	online	completed	2020-12-12 12:55:48.987	t
2138	5	320	2020-12-12	13:15:00	13:30:00	\N	t	f	PATIENT	320	\N	\N	15	onlineCollection	online	completed	2020-12-12 13:01:15.199	t
2162	5	326	2020-12-23	16:00:00	16:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-12-23 10:42:51.102	t
2140	5	321	2020-12-12	14:30:00	14:45:00	\N	t	f	PATIENT	321	\N	\N	15	onlineCollection	online	paused	2020-12-12 14:03:14.066	t
2139	5	320	2020-12-12	14:15:00	14:30:00	\N	t	f	PATIENT	320	\N	\N	15	onlineCollection	online	paused	2020-12-12 14:00:20.284	t
2141	5	320	2020-12-14	08:40:00	08:55:00	\N	f	t	PATIENT	320	PATIENT	\N	15	onlineCollection	online	notCompleted	2020-12-12 15:20:21.638	t
2142	5	321	2020-12-14	08:40:00	08:55:00	\N	f	t	PATIENT	321	PATIENT	\N	15	onlineCollection	online	notCompleted	2020-12-12 15:21:17.244	t
2143	5	321	2020-12-16	16:00:00	16:15:00	\N	f	t	PATIENT	321	PATIENT	\N	15	onlineCollection	online	notCompleted	2020-12-12 15:24:18.669	t
2144	5	321	2020-12-12	15:45:00	16:00:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-12 15:24:28.403	t
2146	5	320	2020-12-12	16:00:00	16:15:00	\N	t	f	PATIENT	320	\N	\N	15	onlineCollection	online	notCompleted	2020-12-12 15:32:26.002	t
2145	5	321	2020-12-12	15:45:00	16:00:00	\N	t	f	PATIENT	321	\N	\N	15	onlineCollection	online	paused	2020-12-12 15:31:43.835	t
2147	5	150	2020-12-12	17:15:00	17:30:00	\N	t	f	PATIENT	150	\N	\N	15	directPayment	online	notCompleted	2020-12-12 17:01:47.569	t
2149	5	150	2020-12-12	17:45:00	18:00:00	\N	t	f	PATIENT	150	\N	\N	15	directPayment	online	completed	2020-12-12 17:09:23.215	t
2148	5	320	2020-12-12	17:30:00	17:45:00	\N	t	f	PATIENT	320	\N	\N	15	onlineCollection	online	completed	2020-12-12 17:04:38.836	t
2150	5	85	2020-12-16	18:45:00	19:00:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	notCompleted	2020-12-16 18:35:03.62	t
2151	5	85	2020-12-17	12:15:00	12:30:00	\N	f	t	PATIENT	85	DOCTOR	32	15	onlineCollection	online	notCompleted	2020-12-17 11:28:20.965	t
2152	5	85	2020-12-17	21:00:00	21:15:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	notCompleted	2020-12-17 20:16:04.804	t
2153	5	85	2020-12-20	22:20:00	22:35:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	notCompleted	2020-12-18 10:14:48.896	t
2154	5	258	2020-12-19	13:15:00	13:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-19 12:13:34.113	t
2155	5	258	2020-12-19	16:00:00	16:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2020-12-19 15:11:54.128	t
2156	5	258	2020-12-19	16:45:00	17:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2020-12-19 15:12:04.517	t
2157	5	85	2020-12-24	12:00:00	12:15:00	\N	f	t	PATIENT	85	PATIENT	\N	15	onlineCollection	online	notCompleted	2020-12-19 16:33:41.305	t
2158	5	258	2020-12-22	21:10:00	21:25:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2020-12-22 17:54:41.342	t
2159	5	325	2020-12-22	23:10:00	23:25:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	inHospital	notCompleted	2020-12-22 23:07:50.88	t
2171	5	258	2020-12-23	17:15:00	17:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-23 17:04:28.94	t
2160	5	182	2020-12-23	01:15:00	01:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-23 00:18:06.042	t
2163	5	327	2020-12-23	16:00:00	16:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-12-23 12:19:18.633	t
2164	5	328	2020-12-23	16:00:00	16:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-12-23 12:45:41.798	t
2172	5	258	2020-12-23	17:45:00	18:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-23 17:09:39.583	t
2165	5	329	2020-12-23	16:00:00	16:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-12-23 12:55:41.48	t
2166	5	330	2020-12-23	16:15:00	16:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-12-23 12:56:43.381	t
2178	5	280	2020-12-23	19:15:00	19:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-23 17:44:44.814	t
2167	5	331	2020-12-23	16:00:00	16:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	completed	2020-12-23 13:37:59.059	t
2168	5	331	2020-12-23	16:15:00	16:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-23 13:47:35.136	t
2170	5	333	2020-12-23	16:30:00	16:45:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	\N	2020-12-23 14:41:37.926	t
2180	5	282	2020-12-23	21:00:00	21:15:00	\N	t	f	PATIENT	282	\N	\N	15	directPayment	online	\N	2020-12-23 17:49:20.798	t
2173	5	334	2020-12-23	18:00:00	18:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-12-23 17:28:28.632	t
2179	5	282	2020-12-23	19:30:00	19:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-23 17:46:23.827	t
2182	5	148	2020-12-23	18:00:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-23 17:59:08.41	t
2174	5	335	2020-12-23	18:15:00	18:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-12-23 17:32:43.578	t
2175	5	336	2020-12-23	18:30:00	18:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	notRequired	online	\N	2020-12-23 17:37:28.534	t
2176	5	280	2020-12-23	18:45:00	19:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-23 17:39:48.052	t
2181	5	331	2020-12-23	18:15:00	18:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-23 17:50:09.656	t
2177	5	322	2020-12-23	19:00:00	19:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-23 17:41:12.34	t
2184	5	331	2020-12-23	18:30:00	18:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-23 17:59:33.877	t
2185	5	144	2020-12-23	18:45:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-23 17:59:43.062	t
2183	5	104	2020-12-23	18:15:00	18:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-23 17:59:19.62	t
2186	5	560	2020-12-23	22:45:00	23:00:00	\N	t	f	PATIENT	560	\N	\N	15	directPayment	online	notCompleted	2020-12-23 20:16:56.223	t
2187	6	337	2020-12-23	21:50:00	22:00:00	\N	t	f	PATIENT	337	\N	\N	10	directPayment	online	notCompleted	2020-12-23 20:29:46.286	t
2188	5	258	2020-12-24	14:15:00	14:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-24 13:03:11.76	t
2189	5	258	2020-12-24	14:00:00	14:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-24 13:07:19.184	t
2191	5	150	2020-12-24	15:00:00	15:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2020-12-24 14:17:23.007	t
2190	5	258	2020-12-24	15:15:00	15:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-24 13:49:05.122	t
2192	5	258	2020-12-24	16:15:00	16:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-24 15:25:54.655	t
2194	5	409	2020-12-24	15:45:00	16:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-24 15:41:10.625	t
2193	5	142	2020-12-24	16:00:00	16:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-24 15:38:08.398	t
2195	5	427	2020-12-24	16:30:00	16:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-24 15:46:15.822	t
2222	5	339	2020-12-24	21:30:00	21:45:00	\N	f	t	PATIENT	339	PATIENT	\N	15	onlineCollection	online	paused	2020-12-24 21:05:27.117	t
2223	5	339	2020-12-24	22:15:00	22:30:00	\N	f	t	PATIENT	339	PATIENT	\N	15	onlineCollection	online	notCompleted	2020-12-24 21:07:24.386	t
2206	5	121	2020-12-24	19:00:00	19:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-24 17:44:41.149	t
2196	5	446	2020-12-24	16:00:00	16:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	completed	2020-12-24 15:49:13.251	t
2197	5	150	2020-12-24	16:45:00	17:00:00	\N	t	f	PATIENT	150	\N	\N	15	directPayment	online	completed	2020-12-24 15:50:22.685	t
2198	5	276	2020-12-24	17:00:00	17:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	completed	2020-12-24 16:10:35.392	t
2207	5	142	2020-12-24	19:15:00	19:30:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	completed	2020-12-24 17:51:29.82	t
2200	5	281	2020-12-24	17:30:00	17:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-24 16:14:30.728	t
2208	5	415	2020-12-24	19:30:00	19:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	completed	2020-12-24 17:51:52.538	t
2199	5	276	2020-12-24	17:15:00	17:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	completed	2020-12-24 16:10:53.086	t
2210	5	113	2020-12-24	19:45:00	20:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-24 18:46:22.687	t
2201	5	471	2020-12-24	17:45:00	18:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	completed	2020-12-24 16:14:45.257	t
2202	5	237	2020-12-24	17:45:00	18:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-24 17:37:07.114	t
2204	5	258	2020-12-24	18:30:00	18:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	completed	2020-12-24 17:40:49.685	t
2203	5	253	2020-12-24	18:00:00	18:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-24 17:37:20.969	t
2205	5	409	2020-12-24	18:45:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	completed	2020-12-24 17:44:22.479	t
2211	5	415	2020-12-24	20:00:00	20:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	completed	2020-12-24 18:46:56.506	t
2224	5	339	2020-12-24	21:30:00	21:45:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-24 21:13:21.857	t
2209	5	338	2020-12-24	20:30:00	20:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	completed	2020-12-24 18:13:02.827	t
2212	5	113	2020-12-24	19:15:00	19:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-24 19:00:54.558	t
2213	5	139	2020-12-24	19:30:00	19:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-24 19:01:13.796	t
2214	5	446	2020-12-24	19:45:00	20:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-24 19:01:44.533	t
2220	5	122	2020-12-24	22:30:00	22:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	paused	2020-12-24 20:38:01.919	t
2215	5	427	2020-12-24	20:15:00	20:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2020-12-24 19:53:33.098	t
2232	5	280	2020-12-29	21:10:00	21:25:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	paused	2020-12-28 17:06:02.655	t
2221	5	409	2020-12-24	22:45:00	23:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	paused	2020-12-24 20:48:28.306	t
2216	5	258	2020-12-24	21:15:00	21:30:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-24 19:53:49.174	t
2225	5	339	2020-12-24	22:15:00	22:30:00	\N	f	t	PATIENT	\N	PATIENT	\N	15	directPayment	online	notCompleted	2020-12-24 21:14:55.393	t
2228	5	85	2020-12-24	23:15:00	23:30:00	\N	f	t	PATIENT	85	DOCTOR	32	15	onlineCollection	online	paused	2020-12-24 21:18:54.977	t
2227	5	339	2020-12-24	23:00:00	23:15:00	\N	f	t	PATIENT	339	PATIENT	\N	15	onlineCollection	online	notCompleted	2020-12-24 21:16:08.55	t
2217	5	471	2020-12-24	21:30:00	21:45:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	paused	2020-12-24 20:25:04.055	t
2229	5	339	2020-12-24	23:30:00	23:45:00	\N	f	t	PATIENT	339	PATIENT	\N	15	onlineCollection	online	completed	2020-12-24 21:20:22.597	t
2226	5	339	2020-12-24	21:30:00	21:45:00	\N	t	f	PATIENT	339	\N	\N	15	onlineCollection	online	completed	2020-12-24 21:15:39.676	t
2218	5	119	2020-12-24	21:45:00	22:00:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-24 20:25:25.661	t
2219	5	258	2020-12-24	22:00:00	22:15:00	\N	f	t	DOCTOR	32	DOCTOR	32	15	directPayment	online	\N	2020-12-24 20:37:51.776	t
2230	5	339	2020-12-24	22:00:00	22:15:00	\N	t	f	PATIENT	339	\N	\N	15	onlineCollection	online	completed	2020-12-24 21:51:06.348	t
2231	5	339	2020-12-24	22:30:00	22:45:00	\N	t	f	PATIENT	339	\N	\N	15	onlineCollection	online	completed	2020-12-24 21:54:14.399	t
2233	5	142	2020-12-29	21:25:00	21:40:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-28 17:42:16.717	t
2234	5	142	2020-12-28	17:58:00	18:13:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-28 17:44:22.054	t
2235	4	150	2020-12-30	12:30:00	12:45:00	\N	t	f	DOCTOR	31	\N	\N	15	directPayment	online	notCompleted	2020-12-29 17:33:35.508	t
2237	5	85	2020-12-30	16:15:00	16:30:00	\N	t	f	DOCTOR	32	\N	\N	15	notRequired	online	completed	2020-12-30 16:07:34.661	t
2236	5	258	2020-12-30	17:00:00	17:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	completed	2020-12-30 11:30:48.652	t
2238	5	85	2020-12-30	16:30:00	16:45:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	completed	2020-12-30 16:23:36.796	t
2239	5	85	2020-12-30	18:45:00	19:00:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	completed	2020-12-30 18:39:08.155	t
2240	5	85	2020-12-31	12:00:00	12:15:00	\N	t	f	PATIENT	85	\N	\N	15	onlineCollection	online	notCompleted	2020-12-31 11:04:21.557	t
2242	5	85	2020-12-31	12:30:00	12:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	\N	2020-12-31 12:25:42.129	t
2241	5	258	2020-12-31	14:00:00	14:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2020-12-31 12:23:55.846	t
2282	5	258	2021-01-14	13:00:00	13:15:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	notCompleted	2021-01-13 07:38:53.709	f
2283	5	258	2021-01-13	16:30:00	16:45:00	\N	t	f	DOCTOR	32	\N	\N	15	directPayment	online	completed	2021-01-13 07:39:12.728	f
\.


--
-- Data for Name: appointment_cancel_reschedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointment_cancel_reschedule (appointment_cancel_reschedule_id, cancel_on, cancel_by, cancel_payment_status, cancel_by_id, reschedule, reschedule_appointment_id, appointment_id) FROM stdin;
\.


--
-- Data for Name: appointment_doc_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointment_doc_config (appointment_doc_config_id, appointment_id, consultation_cost, is_preconsultation_allowed, pre_consultation_hours, pre_consultation_mins, is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins) FROM stdin;
17	268	2000	\N	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
18	269	2000	\N	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
19	270	2000	\N	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
20	271	5000	\N	1	\N	t	2	3	\N	t	2	4	\N	1	3	\N
21	272	5000	\N	1	\N	t	2	3	\N	t	2	4	\N	1	3	\N
22	273	5000	\N	1	\N	t	2	3	\N	t	2	4	\N	1	3	\N
23	274	5000	\N	1	\N	t	2	3	\N	t	2	4	\N	1	3	\N
24	275	5000	\N	1	\N	t	2	3	\N	t	2	4	\N	1	3	\N
25	276	5000	\N	1	\N	t	2	3	\N	t	2	4	\N	1	3	\N
26	277	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
27	278	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
28	279	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
29	280	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
30	281	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
31	282	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
32	283	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
33	284	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
34	285	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
35	286	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
36	287	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
37	288	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
38	289	5000	\N	0	\N	t	2	3	\N	t	2	4	\N	1	3	\N
39	290	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
40	291	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
41	292	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
42	293	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
43	294	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
44	295	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
45	296	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
46	297	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
47	298	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
48	299	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
49	300	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
50	301	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
51	302	2000	\N	0	\N	t	3	4	\N	f	2	4	\N	1	3	\N
52	303	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
53	304	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
54	305	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
55	306	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
56	307	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
57	308	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
58	309	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
59	310	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
60	311	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
61	312	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
62	313	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
63	314	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
64	315	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
65	316	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
66	317	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
67	318	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
68	319	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
69	320	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
70	321	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
71	322	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
72	323	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
73	324	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
74	325	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
75	326	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
76	327	5000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
77	328	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
78	329	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
79	330	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
80	331	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
81	332	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
82	333	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
83	334	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
84	335	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
85	336	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
86	337	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
87	338	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
88	339	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
89	340	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
90	341	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
91	342	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
92	343	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
93	344	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
94	345	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
95	346	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
96	347	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
97	348	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
98	349	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
99	350	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
100	351	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
101	352	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
102	353	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
103	354	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
104	355	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
105	356	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
106	357	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
107	358	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
108	359	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
109	360	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
110	361	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
111	362	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
112	363	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
113	364	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
114	365	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
115	366	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
116	367	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
117	368	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
118	369	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
119	370	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
120	371	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
121	372	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
122	373	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
123	374	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
124	375	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
125	376	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
126	377	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
127	378	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
128	379	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
129	380	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
130	381	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
131	382	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
132	383	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
133	384	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
134	385	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
135	386	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
136	387	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
137	388	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
138	389	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
139	390	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
140	391	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
141	392	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
142	393	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
143	394	200	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
144	395	2000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
145	396	2000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
146	397	2000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
147	398	2000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
148	399	2000	\N	0	\N	t	3	5	\N	t	4	8	\N	2	4	\N
149	400	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
150	401	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
151	402	700	\N	1	\N	t	1	3	\N	t	1	3	\N	2	4	\N
152	403	700	\N	1	\N	t	1	3	\N	t	1	3	\N	2	4	\N
153	404	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
154	405	700	\N	1	\N	t	1	3	\N	t	1	3	\N	2	4	\N
155	406	5000	\N	2	\N	t	3	3	\N	t	2	10	\N	1	12	\N
156	407	2500	\N	0	\N	t	1	2	\N	t	1	2	\N	1	2	\N
157	408	2500	\N	0	\N	t	1	2	\N	t	1	2	\N	1	2	\N
158	409	2500	\N	0	\N	t	1	2	\N	t	1	2	\N	1	2	\N
159	410	2500	\N	0	\N	t	1	2	\N	t	1	2	\N	1	2	\N
160	411	2500	\N	0	\N	t	1	2	\N	t	1	2	\N	1	2	\N
161	412	2500	\N	0	\N	f	1	2	\N	t	1	2	\N	1	2	\N
162	413	3000	\N	1	\N	t	0	0	\N	t	2	3	\N	1	2	\N
163	414	3000	\N	1	\N	t	0	0	\N	t	2	3	\N	1	2	\N
164	415	3000	\N	1	\N	t	0	0	\N	t	2	3	\N	1	2	\N
165	416	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
166	417	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
167	418	2000	\N	2	\N	t	6	2	\N	t	12	11	\N	2	11	\N
168	419	2000	\N	2	\N	t	6	2	\N	t	12	11	\N	2	11	\N
169	420	2000	\N	2	\N	t	6	2	\N	t	12	11	\N	2	11	\N
170	421	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
171	422	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
172	423	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
173	424	300	\N	23	\N	t	0	0	\N	t	99	23	\N	00	0	\N
174	425	2000	\N	2	\N	t	6	2	\N	t	12	11	\N	2	11	\N
175	426	200	\N	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
176	427	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
177	428	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
178	429	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
179	430	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
180	431	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
181	432	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
182	433	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
183	434	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
184	435	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
185	436	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
186	437	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
187	438	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
188	439	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
189	440	500	\N	1	\N	t	0	2	\N	t	10	10	\N	0	1	\N
190	441	500	\N	1	\N	t	0	2	\N	t	10	10	\N	0	1	\N
191	442	200	\N	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
192	443	8000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
193	444	200	\N	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
194	445	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
195	446	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
196	447	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
197	448	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
198	449	8000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
199	450	500	\N	1	\N	t	0	2	\N	t	10	10	\N	0	1	\N
200	451	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
201	452	2000	\N	2	\N	t	6	2	\N	t	12	11	\N	2	11	\N
202	453	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
203	454	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
204	455	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
205	456	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
206	457	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
207	458	5000	\N	2	\N	t	0	0	\N	t	0	0	\N	1	12	\N
208	459	200	\N	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
209	460	200	\N	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
210	461	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
211	462	200	\N	10	\N	t	10	10	\N	t	1	3	\N	0	0	\N
212	463	200	\N	10	\N	t	10	10	\N	t	1	3	\N	0	0	\N
213	464	200	\N	10	\N	t	10	10	\N	t	1	3	\N	0	0	\N
214	465	5000	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
215	466	5000	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
216	467	5000	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
217	468	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
218	469	42000	\N	2	\N	t	1	5	\N	t	1	1	\N	0	1	\N
219	470	42000	\N	2	\N	t	1	5	\N	t	1	1	\N	0	1	\N
220	471	5000	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
221	472	5000	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
222	473	500	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
223	474	500	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
224	475	500	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
225	476	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
226	477	500	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
227	478	500	\N	10	\N	t	10	10	\N	t	1	5	\N	0	0	\N
228	479	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
229	480	500	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
230	481	500	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
231	482	500	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
232	483	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
233	484	5000	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
234	485	5000	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
235	486	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
236	487	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
237	488	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
238	489	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
239	490	5000	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
240	491	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
241	492	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
242	493	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
243	494	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
244	495	5000	\N	5	\N	t	2	3	\N	t	2	4	\N	1	3	\N
245	496	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
246	497	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
247	498	5000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
248	499	200	\N	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
249	500	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
250	501	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
251	502	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
252	503	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
253	504	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
254	505	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
255	506	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
256	507	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
257	508	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
258	509	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
259	510	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
260	511	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
261	512	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
262	513	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
263	514	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
264	515	500	\N	5	\N	t	2	3	\N	t	2	5	\N	1	4	\N
265	516	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
266	517	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
267	518	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
268	519	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
269	520	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
270	521	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
271	522	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
272	523	10000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
273	524	10000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
274	525	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
275	526	10000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
276	527	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
277	528	200	\N	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
278	529	300	\N	23	\N	t	0	0	\N	t	99	23	\N	00	0	\N
279	530	10000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
280	531	10000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
281	532	10000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
282	533	1000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
283	534	1000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
284	535	1000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
285	536	1000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
286	537	1000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
287	538	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
288	539	1000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
289	540	1000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
290	541	1000	\N	5	\N	f	2	3	\N	t	2	5	\N	1	4	\N
291	542	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
292	543	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
293	544	50000	\N	5	\N	t	3	3	\N	t	2	3	\N	2	2	\N
294	545	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
295	546	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
296	547	1000	\N	5	\N	t	2	3	\N	t	26	5	\N	1	4	\N
297	548	1000	\N	5	\N	t	2	3	\N	t	26	5	\N	1	4	\N
298	549	1000	\N	5	\N	t	2	3	\N	t	26	5	\N	1	4	\N
299	550	1000	\N	5	\N	t	2	3	\N	t	26	5	\N	1	4	\N
300	551	1000	\N	5	\N	t	2	3	\N	t	26	5	\N	1	4	\N
301	552	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
302	553	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
303	554	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
304	555	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
305	556	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
306	557	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
307	558	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
308	559	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
309	560	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
310	562	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
311	563	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
312	564	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
313	565	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
314	566	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
315	567	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
316	568	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
317	569	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
318	570	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
319	571	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
320	572	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
321	573	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
322	574	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
323	575	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
324	576	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
325	577	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
326	578	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
327	579	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
328	580	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
329	581	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
330	582	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
331	583	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
332	584	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
333	585	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
334	586	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
335	587	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
336	588	2500	\N	5	\N	t	1	2	\N	t	1	3	\N	2	2	\N
337	589	200	\N	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
338	590	6000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
339	591	6000	\N	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
340	592	2000	\N	2	\N	t	6	2	\N	t	12	11	\N	2	11	\N
341	593	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
342	594	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
343	595	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
344	596	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
345	597	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
346	598	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
347	599	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
348	600	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
349	601	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
350	602	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
351	603	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
352	604	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
353	605	5000	\N	5	\N	t	1	2	\N	t	2	4	\N	1	3	\N
354	606	5000	\N	5	\N	f	0	0	\N	f	2	4	\N	1	3	\N
355	607	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
356	608	50000	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
357	609	50000	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
358	610	50000	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
359	611	2500	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
360	612	2500	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
361	613	2500	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
362	614	2500	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
363	615	2500	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
364	616	2500	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
365	617	2500	\N	5	\N	t	0	2	\N	t	2	4	\N	1	3	\N
366	618	1000	\N	5	\N	t	2	3	\N	t	26	5	\N	1	4	\N
367	619	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	1	3	\N
368	620	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
369	621	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
370	622	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
371	623	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
372	624	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
373	625	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
374	626	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
375	627	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
376	628	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
377	629	5000	\N	5	\N	t	5	5	\N	t	5	5	\N	5	5	\N
378	630	2500	\N	5	\N	t	0	2	\N	t	5	5	\N	5	5	\N
379	631	3000	\N	5	\N	t	0	0	\N	t	0	0	\N	0	0	\N
380	632	100	\N	10	\N	t	1	10	\N	t	0	20	\N	3	3	\N
381	633	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
382	634	3000	\N	5	\N	t	0	0	\N	t	0	0	\N	0	0	\N
383	635	3000	\N	5	\N	t	0	0	\N	t	0	0	\N	0	0	\N
384	636	3000	\N	5	\N	t	0	0	\N	t	0	0	\N	0	0	\N
385	637	3000	\N	5	\N	t	0	0	\N	t	0	0	\N	0	0	\N
386	638	2000	\N	5	\N	t	0	0	\N	t	0	0	\N	0	0	\N
387	639	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	0	\N
388	640	1000	\N	5	\N	t	2	3	\N	t	26	5	\N	1	4	\N
389	641	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
390	642	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
391	643	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
392	644	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
393	645	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
394	646	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
395	647	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
396	648	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
397	649	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
398	650	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
399	651	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
400	652	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
401	653	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
402	654	200	\N	2	\N	f	2	2	\N	f	3	3	\N	2	3	\N
403	655	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
404	656	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
405	657	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
406	658	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
407	659	2500	\N	1	\N	t	1	1	\N	t	0	3	\N	0	1	\N
408	660	0	\N	1	\N	t	0	1	\N	f	0	3	\N	0	1	\N
409	661	0	\N	1	\N	t	0	1	\N	f	0	3	\N	0	1	\N
410	662	0	\N	1	\N	t	0	1	\N	f	0	3	\N	0	1	\N
411	663	3500	\N	1	\N	t	0	1	\N	t	0	3	\N	0	1	\N
412	664	3500	\N	1	\N	t	0	1	\N	t	0	3	\N	0	1	\N
413	665	3500	\N	1	\N	t	0	1	\N	t	0	3	\N	0	1	\N
414	666	3500	\N	1	\N	t	0	1	\N	t	0	3	\N	0	1	\N
1	251	5000	f	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
2	252	5000	f	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
3	253	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
4	254	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
5	255	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
6	256	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
7	258	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
8	259	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
9	260	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
10	261	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
11	262	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
12	263	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
13	264	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
14	265	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
15	266	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
16	267	2000	f	0	\N	f	0	3	\N	f	0	4	\N	1	3	\N
428	679	500	t	1	0	f	\N	\N	\N	f	\N	\N	\N	0	\N	\N
433	685	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
434	686	7.87949492e+15	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
435	687	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
436	688	2500	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
437	689	400	t	2	12	f	2	2	\N	f	3	2	\N	1	2	\N
438	690	2500	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
439	691	2500	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
440	692	2500	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
441	693	0	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
442	694	500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
443	695	500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
415	667	0	t	2	0	t	1	5	\N	t	1	1	\N	0	1	\N
416	668	3500	t	1	0	t	0	1	\N	t	0	3	\N	0	1	\N
417	669	3500	t	1	0	t	0	1	\N	t	0	3	\N	0	1	\N
418	670	3500	t	1	0	t	0	1	\N	t	0	3	\N	0	1	\N
419	671	3500	t	1	0	t	0	1	\N	t	0	3	\N	0	1	\N
420	672	3500	t	1	0	t	0	1	\N	t	0	3	\N	0	1	\N
421	673	3500	t	1	0	t	0	1	\N	t	0	3	\N	0	1	\N
422	674	3500	t	1	0	t	0	1	\N	t	0	3	\N	0	1	\N
423	675	2000	t	2	0	t	6	2	\N	t	12	11	\N	2	11	\N
424	676	2000	t	2	0	t	6	2	\N	t	12	11	\N	2	11	\N
425	677	2000	t	2	0	t	6	2	\N	t	12	11	\N	2	11	\N
426	678	2000	t	2	0	t	6	2	\N	t	12	11	\N	2	11	\N
427	680	5000	t	1	0	t	2	3	\N	t	2	0	\N	1	3	\N
429	681	5000	f	0	0	t	2	2	\N	t	2	0	\N	1	3	\N
430	682	5000	f	0	0	t	2	2	\N	t	2	0	\N	1	3	\N
431	683	5000	f	0	0	t	2	2	\N	t	2	0	\N	1	3	\N
432	684	5000	f	0	0	t	2	2	\N	t	2	0	\N	1	3	\N
444	696	500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
445	697	500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
446	698	500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
447	699	500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
448	700	500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
449	701	500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
450	702	500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
451	703	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
452	704	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
453	705	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
454	706	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
455	707	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
456	708	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
457	709	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
458	710	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
459	711	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
460	712	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
461	713	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
462	714	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
463	715	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
464	716	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
465	717	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
466	718	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
467	719	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
468	720	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
469	721	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
470	722	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
471	723	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
472	724	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
473	725	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
474	726	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
475	727	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
476	728	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
477	729	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
478	730	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
479	731	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
480	732	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
481	733	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
482	734	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
483	735	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
484	736	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
485	737	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
486	738	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
487	739	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
488	740	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
489	741	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
490	742	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
491	743	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
492	744	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
493	745	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
494	746	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
495	747	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
496	748	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
497	749	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
498	750	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
499	751	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
500	752	250	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
501	753	250	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
502	754	5000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
503	755	5000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
504	756	5000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
505	759	5000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
506	760	5000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
507	761	2000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
508	762	2000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
509	763	2000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
510	764	2000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
511	765	3500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
512	766	3500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
513	767	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
514	768	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
515	769	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
516	770	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
517	771	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
518	772	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
519	773	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
520	774	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
521	775	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
522	776	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
523	777	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
524	778	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
525	779	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
526	780	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
527	781	200	t	2	12	f	2	2	\N	f	3	3	\N	2	3	\N
528	782	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
529	783	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
530	784	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
531	785	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
532	786	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
533	787	400	t	2	12	f	2	2	\N	f	3	2	\N	1	2	\N
534	788	500	t	1	20	t	0	2	\N	t	10	10	\N	0	1	\N
535	789	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
536	790	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
537	791	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
538	792	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
539	793	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
540	794	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
541	795	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
542	796	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
543	797	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
544	798	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
545	799	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
546	800	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
547	801	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
548	802	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
549	803	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
550	804	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
551	805	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
552	806	500	t	2	10	t	1	0	\N	t	6	8	\N	5	3	\N
553	807	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
554	808	500	t	1	20	t	0	2	\N	t	10	10	\N	0	1	\N
555	809	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
556	810	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
557	811	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
558	812	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
559	813	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
560	814	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
561	815	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
562	816	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
563	817	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
564	818	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
565	819	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
566	820	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
567	821	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
568	822	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
569	823	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
570	824	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
571	825	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
572	826	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
573	827	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
574	828	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
575	829	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
576	830	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
577	831	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
578	832	5000	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
579	833	200	t	2	12	f	2	2	\N	f	3	3	\N	2	3	\N
580	834	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
581	835	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
582	836	2500	t	5	30	t	0	0	\N	t	0	0	\N	0	0	\N
583	837	5000	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
584	838	5000	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
585	839	5000	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
586	840	5000	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
587	841	5000	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
588	842	5000	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
589	843	5000	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
590	844	5000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
591	845	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
592	846	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
593	847	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
594	848	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
595	849	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
596	850	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
597	851	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
598	852	2500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
599	853	2500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
600	854	2500	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
601	855	5000	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
602	856	2500	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
603	857	2500	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
604	858	2500	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
605	859	2500	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
606	860	2500	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
607	861	2500	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
608	862	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
609	863	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
610	864	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
611	865	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
612	866	100	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
613	867	3500	t	23	59	t	1	2	\N	t	1	2	\N	1	2	\N
614	868	100	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
615	869	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
616	870	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
617	871	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
618	872	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
619	873	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
620	874	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
621	875	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
622	876	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
623	877	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
624	878	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
625	879	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
626	880	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
627	881	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
628	882	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
629	883	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
630	884	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
631	885	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
632	886	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
633	887	100	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
634	888	100	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
635	889	100	t	5	30	t	0	10	\N	t	0	0	\N	0	0	\N
636	890	5000	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
637	891	5000	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
638	892	5000	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
639	893	5000	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
640	894	5000	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
641	895	5000	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
642	896	5000	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
643	897	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
644	898	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
645	899	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
646	900	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
647	901	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
648	902	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
649	903	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
650	905	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
651	904	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
652	906	2500	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
653	907	9999	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
654	908	2533	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
655	909	2533	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
656	910	2533	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
657	911	2533	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
658	912	2533	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
659	913	100	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
660	914	100	t	5	30	t	2	3	\N	t	0	0	\N	0	0	\N
661	915	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
662	916	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
663	917	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
664	918	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
665	919	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
666	920	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
667	921	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
668	922	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
669	923	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
670	924	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
671	925	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
672	926	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
673	927	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
674	928	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
675	929	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
676	930	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
677	931	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
678	932	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
679	933	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
680	934	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
681	935	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
682	936	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
683	937	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
684	938	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
685	939	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
686	942	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
687	943	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
688	944	2000	t	5	30	t	2	3	\N	f	2	4	\N	1	3	\N
689	945	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
690	946	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
691	947	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
692	948	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
693	949	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
694	950	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
695	951	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
696	952	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
697	953	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
698	954	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
699	955	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
700	956	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
701	957	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
702	958	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
703	959	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
704	960	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
705	961	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
706	962	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
707	963	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
708	964	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
709	965	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
710	966	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
711	967	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
712	968	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
713	969	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
714	970	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
715	971	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
716	972	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
717	973	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
718	974	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
719	975	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
720	976	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
721	977	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
722	978	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
723	979	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
724	980	5000	t	5	30	t	2	3	\N	t	2	4	\N	1	3	\N
725	981	5000	t	5	30	t	0	0	\N	t	2	4	\N	1	3	\N
726	982	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
727	983	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
728	984	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
729	985	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
730	986	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
731	987	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
732	988	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
733	989	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
734	990	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
735	991	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
736	992	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
737	993	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
738	994	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
739	995	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
740	996	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
741	997	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
742	998	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
743	999	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
744	1000	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
745	1001	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
746	1002	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
747	1003	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
748	1004	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
749	1005	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
750	1006	3500	t	2	10	t	1	5	\N	f	0	0	\N	0	0	\N
751	1007	3500	t	2	10	t	1	5	\N	f	0	0	\N	0	0	\N
752	1008	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
753	1009	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
754	1010	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
755	1011	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
756	1012	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
757	1013	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
758	1014	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
759	1015	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
760	1016	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
761	1017	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
762	1018	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
763	1019	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
764	1020	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
765	1021	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
766	1022	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
767	1023	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
768	1025	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
769	1024	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
770	1026	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
771	1027	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
772	1028	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
773	1029	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
774	1030	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
775	1032	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
776	1031	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
777	1033	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
778	1034	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
779	1035	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
780	1036	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
781	1037	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
782	1038	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
783	1039	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
784	1040	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
785	1041	3500	t	23	59	t	1	2	\N	t	1	2	\N	1	2	\N
786	1042	3500	t	23	59	t	1	2	\N	t	1	2	\N	1	2	\N
787	1043	3500	t	23	59	t	1	2	\N	t	1	2	\N	1	2	\N
788	1044	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
789	1045	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
790	1046	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
791	1047	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
792	1048	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
793	1049	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
794	1050	5000	t	5	45	t	2	3	\N	t	2	4	\N	1	3	\N
795	1051	5000	t	5	45	t	0	0	\N	t	2	4	\N	1	3	\N
796	1052	5000	t	5	45	t	0	0	\N	t	2	4	\N	1	3	\N
797	1053	5000	t	5	45	t	0	0	\N	t	2	4	\N	1	3	\N
798	1054	5000	t	5	45	t	0	0	\N	t	2	4	\N	1	3	\N
799	1055	500	t	5	30	t	0	0	\N	f	0	0	\N	1	3	\N
800	1056	3500	t	2	10	t	1	5	\N	f	0	0	\N	0	0	\N
801	1057	500	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
802	1058	3500	t	2	10	t	1	5	\N	f	0	0	\N	0	0	\N
803	1059	3500	t	2	10	t	1	5	\N	f	0	0	\N	0	0	\N
804	1060	3500	t	2	10	t	1	5	\N	f	0	0	\N	0	0	\N
805	1061	3500	t	2	10	t	1	5	\N	f	0	0	\N	0	0	\N
806	1062	500	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
807	1063	500	t	5	30	f	0	0	\N	f	0	0	\N	1	3	\N
808	1064	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
809	1065	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
810	1066	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
811	1067	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
812	1068	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
813	1069	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
814	1070	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
815	1071	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
816	1072	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
817	1073	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
818	1074	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
819	1075	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
820	1076	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
821	1077	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
822	1078	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
823	1079	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
824	1080	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
825	1081	200	t	2	12	f	2	2	\N	f	3	3	\N	2	3	\N
826	1082	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
827	1083	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
828	1084	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
829	1085	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
830	1086	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
831	1087	500	t	2	10	t	1	0	\N	t	6	8	\N	5	3	\N
832	1088	500	t	2	10	t	1	0	\N	t	6	8	\N	5	3	\N
833	1089	500	t	1	20	t	0	2	\N	t	10	10	\N	0	1	\N
834	1090	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
835	1091	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
836	1092	500	t	1	20	t	0	2	\N	t	10	10	\N	0	1	\N
837	1093	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
838	1094	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
839	1095	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
840	1096	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
841	1097	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
842	1098	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
843	1099	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
844	1100	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
845	1101	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
846	1102	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
847	1103	500	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
848	1104	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
849	1105	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
850	1106	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
851	1107	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
852	1108	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
853	1109	3500	t	2	10	t	1	5	\N	t	0	0	\N	0	0	\N
854	1110	500	t	5	30	t	0	1	\N	t	0	0	\N	1	3	\N
855	1111	500	t	5	30	t	0	1	\N	t	0	0	\N	1	3	\N
856	1112	500	t	5	30	t	0	1	\N	t	0	0	\N	1	3	\N
857	1113	500	t	5	30	t	0	1	\N	t	0	0	\N	1	3	\N
858	1114	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
859	1115	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
860	1116	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
861	1117	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
862	1118	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
863	1119	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
864	1120	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
865	1121	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
866	1122	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
867	1123	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
868	1124	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
869	1125	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
870	1126	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
871	1127	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
872	1128	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
873	1129	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
874	1130	500	t	5	30	t	0	1	\N	t	0	0	\N	1	3	\N
875	1131	500	t	5	30	t	0	1	\N	t	0	0	\N	1	3	\N
876	1132	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
877	1133	3500	t	2	10	t	0	5	\N	t	1	0	\N	1	0	\N
878	1134	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
879	1135	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
880	1136	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
881	1137	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
882	1138	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
883	1139	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
884	1140	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
885	1141	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
886	1142	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
887	1143	500	t	5	30	f	0	0	\N	t	0	0	\N	1	3	\N
888	1144	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
889	1145	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
890	1146	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
891	1147	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
892	1148	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
893	1149	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
894	1150	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
895	1151	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
896	1152	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
897	1153	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
898	1154	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
899	1155	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
900	1156	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
901	1157	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
902	1158	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
903	1159	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
904	1160	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
905	1161	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
906	1162	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
907	1163	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
908	1164	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
909	1165	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
910	1166	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
911	1167	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
912	1168	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
913	1169	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
914	1170	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
915	1171	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
916	1172	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
917	1173	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
918	1174	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
919	1175	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
920	1176	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
921	1177	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
922	1178	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
923	1179	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
924	1180	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
925	1181	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
926	1182	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
927	1183	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
928	1184	4000	t	2	10	t	0	1	\N	t	0	0	\N	1	0	\N
929	1185	4000	t	2	10	t	0	1	\N	t	0	0	\N	1	0	\N
930	1186	4000	t	2	10	t	0	1	\N	t	0	0	\N	1	0	\N
931	1187	4000	t	2	10	t	0	1	\N	t	0	0	\N	1	0	\N
932	1188	4000	t	2	10	t	0	1	\N	t	0	0	\N	1	0	\N
933	1189	4000	t	2	10	t	0	1	\N	t	0	0	\N	1	0	\N
934	1190	4000	t	2	10	t	0	1	\N	t	0	0	\N	1	0	\N
935	1191	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
936	1192	3500	t	23	59	t	1	2	\N	t	1	2	\N	1	2	\N
937	1193	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
938	1194	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
939	1195	500	t	10	1	t	10	10	\N	t	1	5	\N	0	0	\N
940	1196	500	t	10	1	t	10	10	\N	t	1	5	\N	0	0	\N
941	1197	4000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
942	1198	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
943	1199	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
944	1200	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
945	1201	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
946	1202	1000	t	5	30	t	2	3	\N	t	26	5	\N	1	4	\N
947	1203	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
948	1204	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
949	1205	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
950	1206	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
951	1207	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
952	1208	3500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
953	1209	3500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
954	1210	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
955	1211	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
956	1212	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
957	1213	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
958	1214	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
959	1215	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
960	1216	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
961	1217	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
962	1218	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
963	1219	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
964	1220	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
965	1221	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
966	1222	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
967	1223	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
968	1224	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
969	1225	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
970	1226	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
971	1227	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
972	1228	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
973	1229	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
974	1230	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
975	1231	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
976	1232	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
977	1233	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
978	1234	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
979	1235	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
980	1236	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
981	1237	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
982	1238	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
983	1239	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
984	1240	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
985	1241	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
986	1242	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
987	1243	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
988	1244	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
989	1245	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
990	1246	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
991	1247	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
992	1248	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
993	1249	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
994	1250	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
995	1251	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
996	1252	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
997	1253	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
998	1254	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
999	1255	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1000	1256	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1001	1257	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1002	1258	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1003	1259	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1004	1260	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1005	1261	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1006	1262	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1007	1263	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1008	1264	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1009	1265	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1010	1266	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1011	1267	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1012	1268	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1013	1269	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1014	1270	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1015	1271	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1016	1272	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1017	1273	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1018	1274	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1019	1275	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1020	1276	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1021	1277	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1022	1278	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1023	1279	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1024	1280	500	t	10	1	t	10	10	\N	t	1	5	\N	0	0	\N
1025	1281	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1026	1282	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1027	1283	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1028	1284	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1029	1285	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1030	1286	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1031	1287	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1032	1288	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1033	1289	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1034	1290	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1035	1291	3500	t	23	59	t	1	0	\N	t	1	2	\N	1	2	\N
1036	1292	200	t	2	\N	t	5	2	\N	t	0	0	\N	5	3	\N
1037	1293	200	t	2	\N	t	5	2	\N	t	0	0	\N	5	3	\N
1038	1294	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1039	1295	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1040	1296	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1041	1297	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1042	1298	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1043	1299	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1044	1300	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1045	1301	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1046	1302	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1047	1303	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1048	1304	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1049	1305	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1050	1306	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1051	1307	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1052	1308	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1053	1309	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1054	1310	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1055	1311	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1056	1312	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1057	1313	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1058	1314	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1059	1315	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1060	1316	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1061	1317	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1062	1318	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1063	1319	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1064	1320	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1065	1321	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1066	1322	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1067	1323	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1068	1324	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1069	1325	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1070	1326	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1071	1327	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1072	1328	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1073	1329	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1074	1330	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1075	1331	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1076	1332	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1077	1333	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1078	1334	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1079	1335	5000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1080	1336	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1081	1337	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1082	1338	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1083	1339	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1084	1340	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1085	1341	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1086	1342	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1087	1343	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1088	1344	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1089	1345	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1090	1346	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1091	1347	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1092	1348	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1093	1349	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1094	1350	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1095	1351	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1096	1352	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1097	1353	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1098	1354	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1099	1355	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1100	1356	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1101	1357	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1102	1358	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1103	1359	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1104	1360	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1105	1361	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1106	1362	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1107	1363	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1108	1364	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1109	1365	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1110	1366	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1111	1367	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1112	1368	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1113	1369	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1114	1370	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1115	1371	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1116	1372	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1117	1373	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1118	1374	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1119	1375	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1120	1376	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1121	1377	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1122	1378	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1123	1379	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1124	1380	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1125	1381	1000	t	5	30	f	2	3	\N	t	0	0	\N	1	3	\N
1126	1382	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1127	1383	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1128	1384	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1129	1385	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1130	1386	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1131	1387	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1132	1388	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1133	1389	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1134	1390	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1135	1391	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1136	1392	2500	t	5	30	t	0	0	\N	t	0	0	\N	1	4	\N
1137	1393	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1138	1394	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1139	1395	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1140	1396	200	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1141	1397	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1142	1398	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1143	1399	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1144	1400	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1145	1401	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1146	1402	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1147	1403	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1148	1404	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1149	1405	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1150	1406	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1151	1407	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1152	1408	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1153	1409	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1154	1410	2500	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1155	1411	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1156	1412	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1157	1413	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1158	1414	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1159	1415	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1160	1416	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1161	1417	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1162	1418	123	t	5	12	f	2	4	\N	f	1	12	\N	5	1	\N
1163	1419	500	t	1	20	t	0	2	\N	t	10	10	\N	0	1	\N
1164	1420	500	t	1	20	t	0	2	\N	t	10	10	\N	0	1	\N
1165	1421	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1166	1422	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1167	1423	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1168	1424	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1169	1425	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1170	1426	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1171	1427	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1172	1428	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1173	1429	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1174	1430	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1175	1431	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1176	1432	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1177	1433	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1178	1434	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1179	1435	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1180	1436	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1181	1437	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1182	1438	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1183	1439	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1184	1440	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1185	1441	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1186	1442	5000	t	5	45	t	1	0	\N	t	2	4	\N	1	3	\N
1187	1443	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1188	1444	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1189	1445	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1190	1446	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1191	1447	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1192	1448	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1193	1449	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1194	1450	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1195	1451	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1196	1452	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1197	1453	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1198	1454	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1199	1455	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1200	1456	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1201	1457	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1202	1458	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1203	1459	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1204	1460	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1205	1461	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1206	1462	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1207	1463	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1208	1464	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1209	1465	2000	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1210	1466	2000	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1211	1467	2000	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1212	1468	2000	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1213	1469	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1214	1470	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1215	1471	5000	t	5	45	t	0	0	\N	t	2	4	\N	1	3	\N
1216	1472	5000	t	5	45	t	0	0	\N	t	2	4	\N	1	3	\N
1217	1473	5000	t	5	45	t	0	0	\N	t	2	4	\N	1	3	\N
1218	1474	5000	t	5	45	t	0	0	\N	t	2	4	\N	1	3	\N
1219	1475	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1220	1476	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1221	1477	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1222	1478	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1223	1479	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1224	1480	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1225	1481	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1226	1482	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1227	1483	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1228	1484	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1229	1485	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1230	1486	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1231	1487	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1232	1488	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1233	1489	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1234	1490	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1235	1491	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1236	1492	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1237	1493	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1238	1494	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1239	1495	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1240	1496	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1241	1497	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1242	1498	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1243	1499	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1244	1500	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1245	1501	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1246	1502	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1247	1503	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1248	1504	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1249	1505	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1250	1506	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1251	1507	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1252	1508	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1253	1509	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1254	1510	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1255	1511	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1256	1512	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1257	1513	2500	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1258	1514	2500	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1259	1515	2500	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1260	1516	2500	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1261	1517	2000	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1262	1518	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1263	1519	2000	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1264	1520	2000	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1265	1521	2000	t	2	\N	t	5	2	\N	t	6	8	\N	5	3	\N
1266	1522	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1267	1523	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1268	1524	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1269	1525	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1270	1526	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1271	1527	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1272	1528	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1273	1529	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1274	1530	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1275	1531	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1276	1532	2000	t	2	10	t	6	2	\N	t	12	11	\N	2	11	\N
1277	1533	2500	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1278	1534	2500	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1279	1535	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1280	1536	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1281	1538	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1282	1540	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1283	1541	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1284	1542	2000	t	2	10	t	0	0	\N	t	0	0	\N	1	0	\N
1285	1544	2000	t	2	10	t	0	0	\N	t	0	0	10	1	0	\N
1286	1545	2000	t	2	10	t	0	0	10	t	0	0	10	1	0	0
1287	1546	2000	t	2	10	t	0	0	10	t	0	0	10	1	0	0
1288	1547	2000	t	2	10	t	0	0	10	t	0	0	10	1	0	0
1289	1548	2000	t	2	10	t	0	0	10	t	0	0	10	1	0	0
1290	1549	2000	t	2	10	t	0	0	10	t	0	0	10	1	0	0
1291	1550	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1292	1551	2500	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1293	1552	2500	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1294	1553	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1295	1554	2000	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1296	1555	2000	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1297	1556	2000	t	2	\N	t	0	0	\N	t	0	0	\N	5	3	\N
1298	1557	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1299	1558	2000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1300	1559	2000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1301	1560	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1302	1561	2000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1303	1562	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1304	1563	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1305	1564	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1306	1565	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1307	1566	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1308	1567	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1309	1568	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1310	1569	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1311	1570	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1312	1571	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1313	1572	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1314	1573	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1315	1574	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1316	1575	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1317	1576	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1318	1577	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1319	1578	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1320	1579	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1321	1580	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1322	1581	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1323	1582	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1324	1583	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1325	1584	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1326	1585	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1327	1586	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1328	1587	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1329	1588	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1330	1589	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1331	1590	5000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1332	1591	2000	t	2	10	t	0	0	10	t	1	0	10	1	0	0
1333	1592	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1334	1593	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1335	1594	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1336	1595	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1337	1596	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1338	1597	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1339	1598	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1340	1599	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1341	1600	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1342	1601	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1343	1602	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1344	1603	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1345	1604	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1346	1605	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1347	1606	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1348	1607	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1349	1608	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1350	1609	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1351	1610	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1352	1611	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1353	1612	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1354	1613	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1355	1614	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1356	1615	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1357	1616	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1358	1617	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1359	1618	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1360	1619	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1361	1620	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1362	1621	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1363	1622	150	t	2	10	t	1	0	0	t	1	0	0	0	1	15
1364	1623	1500	t	1	0	t	0	3	10	t	2	20	10	0	0	20
1365	1624	1500	t	1	0	t	0	3	10	t	2	20	10	0	0	20
1366	1625	1500	t	1	0	t	0	3	10	t	2	20	10	0	0	20
1367	1626	1500	t	1	0	t	0	3	10	t	2	20	10	0	0	20
1368	1627	1500	t	1	0	t	0	3	10	t	2	20	10	0	0	20
1369	1628	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1370	1629	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1371	1630	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1372	1631	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1373	1632	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1374	1633	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1375	1634	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1376	1635	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1377	1636	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1378	1637	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1379	1638	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1380	1639	200	t	2	12	f	2	2	3	f	3	3	4	2	3	2
1381	1640	200	t	2	12	f	2	2	3	f	3	3	4	2	3	2
1382	1641	200	t	2	12	f	2	2	3	f	3	3	4	2	3	2
1383	1642	200	t	2	12	f	2	2	3	f	3	3	4	2	3	2
1384	1643	200	t	2	12	f	2	2	3	f	3	3	4	2	3	2
1385	1644	200	t	10	1	t	10	10	20	t	1	3	0	0	0	20
1386	1645	200	t	10	1	t	10	10	20	t	1	3	0	0	0	20
1387	1646	200	t	10	1	t	10	10	20	t	1	3	0	0	0	20
1388	1647	100	t	10	0	t	1	10	10	t	0	20	10	3	3	15
1389	1648	100	t	10	0	t	1	10	10	t	0	20	10	3	3	15
1390	1649	200	t	10	1	t	10	10	20	t	1	3	0	0	0	20
1391	1650	200	t	10	1	t	10	10	20	t	1	3	0	0	0	20
1392	1651	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1393	1652	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15
1394	1653	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1395	1654	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1396	1655	1000	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1397	1656	2500	t	5	30	t	0	0	10	t	0	0	10	1	4	15
1398	1657	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15
1399	1658	5000	t	5	45	t	0	0	10	t	2	4	15	1	3	18
1400	1659	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1401	1660	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1402	1661	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1403	1662	500	t	1	20	t	0	2	10	t	10	10	1	0	1	15
1404	1663	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1405	1664	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1406	1665	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1407	1666	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1408	1667	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1409	1668	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1410	1669	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1411	1670	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1412	1671	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1413	1672	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1414	1673	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1415	1674	1000	t	5	30	t	0	0	\N	t	0	0	\N	1	3	\N
1416	1675	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1417	1676	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1418	1677	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1419	1678	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1420	1679	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1421	1680	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1422	1681	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1423	1682	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1424	1683	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1425	1684	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1426	1685	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1427	1686	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1428	1687	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1429	1688	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1430	1689	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1431	1690	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1432	1691	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1433	1692	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1434	1693	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1435	1694	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1436	1695	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1437	1696	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1438	1697	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1439	1698	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1440	1699	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1441	1700	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1442	1701	5000	t	5	30	f	2	3	\N	f	2	4	\N	1	3	\N
1443	1702	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1444	1703	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1445	1704	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1446	1705	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1447	1706	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1448	1707	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1449	1708	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1450	1709	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1451	1710	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1452	1711	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1453	1712	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1454	1713	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1455	1714	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1456	1715	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1457	1716	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1458	1717	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1459	1718	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1460	1719	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1461	1720	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1462	1721	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1463	1722	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1464	1723	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1465	1724	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1466	1725	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1467	1726	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1468	1727	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1469	1728	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1470	1729	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1471	1730	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1472	1731	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1473	1732	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1474	1733	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1475	1734	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1476	1735	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1477	1736	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1478	1737	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1479	1738	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1480	1739	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1481	1740	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1482	1741	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1483	1742	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1484	1743	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1485	1744	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1486	1745	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1487	1746	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1488	1747	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1489	1748	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1490	1749	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1491	1750	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1492	1751	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1493	1752	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1494	1753	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1495	1754	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1496	1755	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1497	1756	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1498	1757	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1499	1758	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1500	1759	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1501	1760	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1502	1761	2000	t	2	10	t	6	2	\N	t	0	0	\N	2	11	\N
1503	1762	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1504	1763	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1505	1764	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1506	1765	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1507	1766	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1508	1767	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1509	1768	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1510	1769	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1511	1770	5000	t	5	\N	f	2	3	\N	f	2	4	\N	1	3	\N
1512	1771	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1513	1772	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1514	1773	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1515	1774	500	t	1	20	t	0	2	10	t	10	10	1	0	1	15
1516	1775	3500	t	23	59	t	1	0	0	t	1	2	3	1	2	3
1517	1776	3500	t	23	59	t	1	0	0	t	1	2	3	1	2	3
1518	1777	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1519	1778	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1520	1779	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1521	1780	200	t	10	1	t	10	10	20	t	1	3	0	0	0	20
1522	1781	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1523	1782	100	t	10	0	t	1	10	10	t	0	20	10	3	3	15
1524	1783	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1525	1784	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15
1526	1785	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1527	1786	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1528	1787	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1529	1788	500	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1530	1789	1000	t	5	30	t	0	1	10	t	0	0	10	1	3	15
1531	1790	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1532	1791	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1533	1792	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1534	1793	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1535	1794	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1536	1795	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1537	1796	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1538	1797	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1539	1798	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1540	1799	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1541	1800	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1542	1801	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1543	1802	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1544	1803	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1545	1804	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1546	1805	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1547	1806	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1548	1807	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1549	1808	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1550	1809	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1551	1810	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1552	1811	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1553	1812	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1554	1813	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1555	1814	2000	t	5	30	f	0	0	10	t	0	2	0	0	2	0
1556	1815	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1557	1816	5000	t	5	30	f	2	3	30	f	2	4	15	1	3	15
1558	1817	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1559	1818	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1560	1819	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1561	1820	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1562	1821	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1563	1822	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1564	1823	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1565	1824	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1566	1825	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1567	1826	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1568	1827	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1569	1828	500	t	5	30	t	0	0	10	t	0	0	10	1	3	15
1570	1829	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1571	1830	5000	t	5	30	t	0	0	20	t	0	0	10	1	3	15
1572	1831	5000	t	5	30	t	0	0	20	t	0	0	10	1	3	15
1573	1832	5000	t	5	30	t	0	0	20	t	0	0	10	1	3	15
1574	1833	5000	t	5	30	t	0	0	20	t	0	0	10	1	3	15
1575	1834	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1576	1835	5000	t	5	45	t	0	0	10	t	2	4	15	1	3	18
1577	1836	5000	t	5	45	t	0	0	10	t	2	4	15	1	3	18
1578	1837	5000	t	5	45	t	0	0	10	t	2	4	15	1	3	18
1579	1838	3500	t	23	59	t	1	0	0	t	1	2	3	1	2	3
1580	1839	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1581	1840	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1582	1841	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1583	1842	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1584	1843	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1585	1844	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1586	1845	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1587	1846	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1588	1847	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1589	1848	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1590	1849	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1591	1850	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1592	1851	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1593	1852	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1594	1853	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1595	1854	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1596	1855	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1597	1856	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1598	1857	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1599	1858	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1600	1859	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1601	1860	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1602	1861	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1603	1862	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1604	1863	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1605	1864	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1606	1865	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1607	1866	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1608	1867	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1609	1868	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1610	1869	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1611	1870	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1612	1871	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1613	1872	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1614	1873	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1615	1874	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1616	1875	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1617	1876	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1618	1877	5000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1619	1878	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1620	1879	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1621	1880	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1622	1881	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1623	1882	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1624	1883	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1625	1884	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1626	1885	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1627	1886	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1628	1887	10	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1629	1888	1000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1630	1889	1000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1631	1890	1000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1632	1891	1000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1633	1892	1000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1634	1893	1000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1635	1894	1000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1636	1895	1000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1637	1896	1000	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1638	1897	100	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1639	1898	100	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1640	1899	100	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1641	1900	100	t	5	30	t	1	0	0	t	0	1	0	1	0	15
1642	1901	100	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1643	1902	100	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1644	1903	100	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1645	1904	100	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1646	1905	200	t	10	1	t	10	10	20	t	1	3	0	0	0	20
1647	1906	100	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1648	1907	100	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1649	1908	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1650	1909	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1651	1910	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1652	1911	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1653	1912	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1654	1913	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1655	1914	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1656	1915	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1657	1916	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1658	1917	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1659	1918	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1660	1919	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1661	1920	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1662	1921	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1663	1922	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1664	1923	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1665	1924	1000	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1666	1925	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1667	1926	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1668	1927	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1669	1928	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
1670	1929	5000	t	5	45	t	0	0	10	t	2	4	15	1	3	18
1671	1930	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1672	1931	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1673	1932	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1674	1933	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1675	1934	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1676	1935	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1677	1936	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1678	1937	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1679	1938	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1680	1939	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1681	1940	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1682	1941	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1683	1942	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1684	1943	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1685	1944	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1686	1945	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1687	1946	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1688	1947	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1689	1948	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1690	1949	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1691	1950	2000	t	5	30	f	0	0	10	t	0	2	0	0	2	0
1692	1951	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1693	1952	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1694	1953	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1695	1954	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1696	1955	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1697	1956	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1698	1957	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1699	1958	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1700	1959	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1701	1960	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1702	1961	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1703	1962	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1704	1963	500	t	5	30	t	0	0	10	t	0	0	10	1	0	15
1705	1964	1000	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1706	1965	1000	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1707	1966	1000	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1708	1967	1000	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1709	1968	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1710	1969	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1711	1970	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1712	1971	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1713	1972	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1714	1973	1000	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1715	1974	1000	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1716	1975	1000	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1717	1976	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1718	1977	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1719	1978	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1720	1979	1000	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1721	1980	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15
1722	1981	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1723	1982	10	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1724	1983	10	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1725	1984	10	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1726	1985	10	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1727	1986	10	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1728	1987	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1729	1988	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1730	1989	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1731	1990	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1732	1991	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1733	1992	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1734	1993	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1735	1994	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1736	1995	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1737	1996	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1738	1997	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1739	1998	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1740	1999	500	t	5	30	t	0	0	10	t	0	0	11	0	0	0
1741	2000	500	t	5	30	t	0	0	14	f	0	0	11	0	0	0
1742	2001	500	t	5	30	t	0	11	14	f	0	0	11	0	0	0
1743	2002	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1744	2003	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1745	2004	2000	t	2	10	t	0	0	10	t	0	1	10	1	0	0
1746	2005	500	t	5	30	t	0	11	14	f	0	0	11	0	0	0
1747	2006	500	t	5	30	t	0	11	14	f	0	0	11	0	0	0
1748	2007	500	t	5	30	t	0	0	10	t	0	0	20	0	0	0
1749	2008	500	t	5	30	t	0	0	10	t	0	0	20	0	0	0
1750	2009	500	t	5	30	t	0	0	10	t	0	0	20	0	0	0
1751	2010	500	t	5	30	t	0	0	10	t	0	0	20	0	0	0
1752	2011	250	t	2	10	f	0	0	10	t	0	1	10	1	0	0
1753	2012	250	t	2	10	f	0	0	10	t	0	1	10	1	0	0
1754	2013	900	t	5	30	t	0	0	10	t	0	0	20	0	0	0
1755	2014	900	t	5	30	t	0	0	10	t	0	0	20	0	0	0
1756	2015	900	t	5	30	t	0	0	10	t	0	0	20	0	0	0
1757	2016	900	t	5	30	t	0	0	10	t	0	0	20	0	0	0
1758	2017	900	t	5	30	t	0	0	10	t	0	0	20	0	0	0
1759	2018	900	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1760	2019	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11
1761	2020	900	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1762	2021	900	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1763	2022	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1764	2023	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1765	2024	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1766	2025	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1767	2026	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1768	2027	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1769	2028	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1770	2029	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1771	2030	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1772	2031	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1773	2032	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1774	2033	100	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1775	2034	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1776	2035	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1777	2036	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1778	2037	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1779	2038	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1780	2039	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1781	2040	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1782	2041	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1783	2042	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1784	2043	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1785	2044	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1786	2045	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1787	2046	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1788	2047	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1789	2048	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1790	2049	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1791	2050	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1792	2051	500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1793	2052	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1794	2053	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15
1795	2054	1005	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1796	2055	1005	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1797	2056	1005	t	5	30	t	0	0	15	t	0	0	10	0	0	0
1798	2057	1005	t	5	30	t	0	0	15	t	0	0	10	0	0	0
1799	2058	1005	t	5	30	t	0	0	15	t	0	0	10	0	0	0
1800	2059	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1801	2060	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1802	2061	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1803	2062	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1804	2063	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1805	2064	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1806	2065	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1807	2066	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	0
1808	2067	2000	t	5	30	f	0	0	10	t	0	2	0	0	2	0
1809	2068	1500	t	5	30	t	0	0	10	t	0	0	15	0	0	0
1810	2069	1500	t	5	30	t	0	0	10	t	0	0	15	0	0	0
1811	2070	1500	t	5	30	t	0	0	10	t	0	0	15	0	0	0
1812	2071	1500	t	5	30	t	0	0	10	t	0	0	15	0	0	0
1813	2072	1000	t	5	30	t	0	0	15	t	0	0	15	0	0	0
1814	2073	1000	t	5	30	t	0	0	15	t	0	0	15	0	0	0
1815	2074	1000	t	5	30	t	0	0	15	t	0	0	15	0	0	0
1816	2075	1000	t	5	30	t	0	0	15	t	0	0	15	0	0	0
1817	2076	1000	t	5	30	t	0	0	15	t	0	0	15	0	0	0
1818	2077	1000	t	5	30	t	0	0	15	t	0	0	15	0	0	0
1819	2078	1000	t	5	30	t	0	0	15	t	0	0	15	0	0	0
1820	2079	2000	t	2	10	t	0	0	15	t	0	0	10	1	0	0
1821	2080	1000	t	5	30	t	0	0	15	t	0	0	15	0	0	0
1822	2081	2000	t	5	30	t	1	1	10	t	0	0	10	0	0	10
1823	2082	2000	t	5	30	t	1	1	10	t	0	0	10	0	0	10
1824	2083	2000	t	5	30	t	1	1	10	t	0	0	10	0	0	10
1825	2084	2000	t	5	30	t	1	1	10	t	0	0	10	0	0	10
1826	2085	2000	t	5	30	t	1	1	10	t	0	0	10	0	0	10
1827	2086	2000	t	5	30	t	1	1	10	t	0	0	10	0	0	10
1828	2087	2000	t	5	30	t	1	1	10	t	0	0	10	0	0	10
1829	2088	2000	t	5	30	t	1	1	10	t	0	0	10	0	0	10
1830	2089	2000	t	5	30	t	1	1	10	t	0	0	10	0	0	10
1831	2090	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1832	2091	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1833	2092	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1834	2093	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1835	2094	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1836	2095	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1837	2096	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1838	2097	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1839	2098	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15
1840	2099	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1841	2100	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1842	2101	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1843	2102	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1844	2103	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1845	2104	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1846	2105	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1847	2106	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1848	2107	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1849	2108	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1850	2109	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1851	2110	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1852	2111	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1853	2112	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1854	2113	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1855	2114	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1856	2115	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1857	2116	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1858	2117	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1859	2118	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1860	2119	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1861	2120	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1862	2121	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1863	2122	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1864	2123	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1865	2124	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1866	2125	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1867	2126	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1868	2127	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1869	2128	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1870	2129	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1871	2130	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1872	2131	100	t	10	0	t	1	10	10	t	0	20	10	3	3	15
1873	2132	100	t	10	0	t	1	10	10	t	0	20	10	3	3	15
1874	2133	100	t	10	0	t	1	10	10	t	0	20	10	3	3	15
1875	2134	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1876	2135	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1877	2136	1500	t	5	30	t	0	0	15	t	0	0	10	0	0	10
1878	2137	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1879	2138	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1880	2139	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1881	2140	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1882	2141	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1883	2142	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1884	2143	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1885	2144	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1886	2145	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1887	2146	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1888	2147	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1889	2148	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1890	2149	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1891	2150	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1892	2151	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1893	2152	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1894	2153	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1895	2154	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1896	2155	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1897	2156	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1898	2157	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1899	2158	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1900	2159	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1901	2160	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1902	2161	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1903	2162	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1904	2163	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1905	2164	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1906	2165	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1907	2166	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1908	2167	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1909	2168	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1910	2169	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1911	2170	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1912	2171	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1913	2172	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1914	2173	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1915	2174	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1916	2175	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1917	2176	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1918	2177	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1919	2178	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1920	2179	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1921	2180	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1922	2181	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1923	2182	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1924	2183	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1925	2184	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1926	2185	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1927	2186	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1928	2187	2000	t	2	10	t	0	0	15	t	0	0	10	1	0	0
1929	2188	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1930	2189	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1931	2190	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1932	2191	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1933	2192	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1934	2193	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1935	2194	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1936	2195	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1937	2196	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1938	2197	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1939	2198	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1940	2199	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1941	2200	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1942	2201	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1943	2202	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1944	2203	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1945	2204	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1946	2205	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1947	2206	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1948	2207	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1949	2208	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1950	2209	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1951	2210	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1952	2211	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1953	2212	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1954	2213	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1955	2214	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1956	2215	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1957	2216	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1958	2217	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1959	2218	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1960	2219	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1961	2220	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1962	2221	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1963	2222	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1964	2223	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1965	2224	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1966	2225	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1967	2226	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1968	2227	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1969	2228	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1970	2229	1500	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1971	2230	1	t	5	30	t	0	0	10	t	0	0	10	0	0	10
1972	2231	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1973	2232	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1974	2233	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1975	2234	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1976	2235	5000	t	5	45	t	0	0	10	t	0	0	10	1	3	18
1977	2236	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1978	2237	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1979	2238	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1980	2239	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1981	2240	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1982	2241	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1983	2242	1	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1984	2243	2000	t	2	10	t	0	0	15	t	0	0	10	1	0	0
1985	2244	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1986	2245	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1987	2246	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1988	2247	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1989	2248	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1990	2249	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1991	2250	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1992	2251	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1993	2252	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1994	2253	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1995	2254	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1996	2255	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1997	2256	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
1998	2257	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
1999	2258	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2000	2259	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2001	2260	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2002	2261	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2003	2262	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2004	2263	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2005	2264	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2006	2265	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2007	2266	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2008	2267	200	t	2	12	f	2	2	3	f	3	3	4	2	3	2
2009	2268	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2010	2269	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2011	2270	1000	t	5	30	f	0	0	10	f	0	0	10	0	0	10
2012	2271	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2013	2272	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2014	2273	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2015	2274	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2016	2275	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2017	2276	200	t	2	12	f	2	2	3	f	3	3	4	2	3	2
2018	2277	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2019	2278	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2020	2279	2000	t	5	30	f	0	0	10	t	0	2	0	0	2	0
2021	2280	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2022	2281	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15
2023	2282	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2024	2283	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2025	2284	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2026	2285	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2027	2286	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2028	2287	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2029	2288	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2030	2289	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2031	2290	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2032	2291	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2033	2292	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2034	2293	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2035	2294	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2036	2295	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2037	2296	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2038	2297	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2039	2298	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2040	2299	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2041	2300	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2042	2301	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2043	2302	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2044	2303	1000	t	5	30	t	0	0	10	f	0	0	10	0	0	10
2045	2304	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2046	2305	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2047	2306	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2048	2307	1000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2049	2308	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2050	2309	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2051	2310	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2052	2311	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2053	2312	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2054	2313	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2055	2314	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2056	2315	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2057	2316	1000	t	2	10	t	0	0	10	t	0	0	15	1	0	0
2058	2317	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2059	2318	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2060	2319	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2061	2320	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2062	2321	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
2063	2322	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10
\.


--
-- Data for Name: communication_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.communication_type (id, name) FROM stdin;
\.


--
-- Data for Name: doc_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, "overBookingCount", "overBookingEnabled", "overBookingType", "consultationSessionTimings") FROM stdin;
2	Doc_22	200	t	2	12	f	2	2	3	f	3	3	4	2	3	2	f	\N	\N	4	t	Per Hour	30
3	Doc_23	400	t	2	12	f	2	2	21	f	3	2	12	1	2	12	f	\N	\N	2	t	Per Hour	30
4	Doc_24	123	t	5	12	f	2	4	21	f	1	12	2	5	1	12	f	\N	\N	3	t	Per Hour	30
11	Doc_8	500	t	1	20	t	0	2	10	t	10	10	1	0	1	15	t	\N	\N	2	t	Per Hour	30
13	Doc_10	500	t	2	10	t	1	0	10	t	6	8	40	5	3	15	t	\N	\N	2	t	Per Hour	30
15	Doc_12	500	t	10	1	t	10	10	21	t	1	5	0	0	0	20	t	\N	\N	2	t	Per Hour	30
17	Doc_14	200	t	10	1	f	5	2	30	t	1	10	10	0	1	10	t	\N	\N	2	t	Per Hour	30
18	Doc_15	200	t	2	0	f	5	2	30	t	6	8	40	5	3	15	f	\N	\N	2	t	Per Hour	30
19	Doc_16	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	2	t	Per Hour	30
20	Doc_17	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	3	t	Per Hour	30
21	Doc_18	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	3	t	Per Hour	30
22	Doc_19	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	3	t	Per Hour	30
23	Doc_20	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	3	t	Per Hour	30
25	Doc_25	200	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	2	t	Per Hour	30
24	Doc_21	200	t	2	\N	t	5	2	30	t	0	0	30	5	3	15	f	\N	\N	3	t	Per Hour	30
12	Doc_9	150	t	2	10	t	1	0	0	t	1	0	0	0	1	15	t	\N	\N	2	t	Per Hour	45
42	Doc_55	3000	t	2	\N	t	0	0	10	t	0	0	10	5	3	15	f	\N	\N	\N	f	\N	15
46	Doc_57	100	f	2	\N	t	0	0	20	t	0	0	15	5	3	15	f	\N	\N	\N	f	\N	20
28	Doc_47	0	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
29	Doc_47	200	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
30	Doc_48	100	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
31	Doc_48	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
14	Doc_11	100	t	10	0	t	1	10	10	t	0	20	10	3	3	15	t	\N	\N	10	t	Per day	30
6	Doc_2	3500	t	23	59	t	1	0	0	t	1	2	3	1	2	3	f	\N	\N	6	t	Per Hour	15
43	Doc_55	3000	f	2	\N	t	0	0	10	t	0	0	10	5	3	15	f	\N	\N	\N	f	\N	15
16	Doc_13	200	t	10	1	t	10	10	20	t	1	3	0	0	0	20	t	\N	\N	2	t	Per day	30
32	Doc_49	2000	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	\N	f	\N	30
33	Doc_49	2000	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	30
36	Doc_52	1200	t	2	\N	t	0	0	10	t	0	0	10	5	3	15	f	\N	\N	\N	f	\N	\N
47	Doc_58	0	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
48	Doc_58	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
7	Doc_3	2000	t	2	10	t	6	2	30	t	0	0	10	2	11	11	t	\N	\N	4	t	Per day	15
10	Doc_7	1500	t	1	0	t	0	3	10	t	2	20	10	0	0	20	t	\N	\N	3	t	Per Hour	30
57	Doc_111	5000	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
27	Doc_46	0	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	\N	f	\N	15
58	Doc_82	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
59	Doc_83	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
60	Doc_84	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
61	Doc_112	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
62	Doc_113	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
63	Doc_114	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
64	Doc_115	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
65	Doc_69	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
66	Doc_71	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
67	Doc_72	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
5	Doc_1	2000	t	5	30	f	0	0	10	t	0	2	0	0	2	0	t	\N	\N	5	t	Per day	60
68	Doc_86	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
69	Doc_89	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
44	Doc_56	0	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	\N	f	\N	15
45	Doc_56	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	15
26	Doc_45	0	t	2	\N	t	0	0	30	t	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
70	Doc_90	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
49	Doc_91	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
50	Doc_27	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
51	Doc_92	500	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
52	Doc_93	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
53	Doc_95	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
54	Doc_108	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
80	Doc_117	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
55	Doc_109	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
56	Doc_110	200	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
71	Doc_97	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
72	Doc_99	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
73	Doc_100	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
74	Doc_101	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
75	Doc_104	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
76	Doc_105	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
77	Doc_106	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
78	Doc_107	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
79	Doc_116	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
81	Doc_118	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
82	Doc_119	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
83	Doc_121	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
84	Doc_122	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
85	Doc_123	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
86	Doc_127	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	10
38	Doc_53	1	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
39	Doc_53	1	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
34	Doc_50	2500	t	2	\N	t	0	0	10	t	0	0	10	5	3	15	f	\N	\N	\N	f	\N	\N
35	Doc_50	2500	f	2	\N	t	0	0	10	t	0	0	10	5	3	15	f	\N	\N	\N	f	\N	\N
37	Doc_52	1200	f	2	\N	t	0	0	10	t	0	0	10	5	3	15	f	\N	\N	\N	f	\N	\N
9	Doc_6	1000	t	2	10	t	0	0	10	t	0	0	10	1	0	0	t	\N	\N	5	f	Per Hour	10
40	Doc_54	0	t	2	\N	t	5	2	30	t	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
41	Doc_54	100	f	2	\N	f	5	2	30	f	6	8	40	5	3	15	f	\N	\N	\N	f	\N	\N
8	Doc_4	5000	t	5	45	t	0	0	10	t	0	0	10	1	3	18	f	\N	\N	2	t	Per Hour	15
1	Doc_5	2000	t	5	30	t	0	0	10	t	0	0	10	0	0	10	f	\N	\N	5	f	Per Hour	20
\.


--
-- Data for Name: doc_config_schedule_day; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doc_config_schedule_day (doctor_id, "dayOfWeek", id, doctor_key) FROM stdin;
15	Wednesday	101	Doc_15
15	Thursday	102	Doc_15
15	Friday	103	Doc_15
5	Monday	1	Doc_5
5	Tuesday	2	Doc_5
5	Wednesday	3	Doc_5
5	Thursday	4	Doc_5
5	Friday	5	Doc_5
5	Saturday	6	Doc_5
5	Sunday	7	Doc_5
1	Monday	8	Doc_1
1	Tuesday	9	Doc_1
1	Wednesday	10	Doc_1
1	Thursday	11	Doc_1
1	Friday	12	Doc_1
1	Saturday	13	Doc_1
1	Sunday	14	Doc_1
2	Monday	15	Doc_2
2	Tuesday	16	Doc_2
2	Wednesday	17	Doc_2
2	Thursday	18	Doc_2
2	Friday	19	Doc_2
2	Saturday	20	Doc_2
2	Sunday	21	Doc_2
3	Monday	22	Doc_3
3	Tuesday	23	Doc_3
3	Wednesday	24	Doc_3
3	Thursday	25	Doc_3
3	Friday	26	Doc_3
3	Saturday	27	Doc_3
3	Sunday	28	Doc_3
4	Monday	29	Doc_4
4	Tuesday	30	Doc_4
4	Wednesday	31	Doc_4
4	Thursday	32	Doc_4
4	Friday	33	Doc_4
4	Saturday	34	Doc_4
4	Sunday	35	Doc_4
6	Monday	36	Doc_6
6	Tuesday	37	Doc_6
6	Wednesday	38	Doc_6
6	Thursday	39	Doc_6
6	Friday	40	Doc_6
6	Saturday	41	Doc_6
6	Sunday	42	Doc_6
7	Monday	43	Doc_7
7	Tuesday	44	Doc_7
7	Wednesday	45	Doc_7
7	Thursday	46	Doc_7
7	Friday	47	Doc_7
7	Saturday	48	Doc_7
7	Sunday	49	Doc_7
8	Monday	50	Doc_8
8	Tuesday	51	Doc_8
8	Wednesday	52	Doc_8
8	Thursday	53	Doc_8
8	Friday	54	Doc_8
8	Saturday	55	Doc_8
8	Sunday	56	Doc_8
9	Monday	57	Doc_9
9	Tuesday	58	Doc_9
9	Wednesday	59	Doc_9
9	Thursday	60	Doc_9
9	Friday	61	Doc_9
9	Saturday	62	Doc_9
9	Sunday	63	Doc_9
10	Monday	64	Doc_10
10	Tuesday	65	Doc_10
10	Wednesday	66	Doc_10
10	Thursday	67	Doc_10
10	Friday	68	Doc_10
10	Saturday	69	Doc_10
10	Sunday	70	Doc_10
11	Monday	71	Doc_11
11	Tuesday	72	Doc_11
11	Wednesday	73	Doc_11
11	Thursday	74	Doc_11
11	Friday	75	Doc_11
11	Saturday	76	Doc_11
11	Sunday	77	Doc_11
12	Monday	78	Doc_12
12	Tuesday	79	Doc_12
12	Wednesday	80	Doc_12
12	Thursday	81	Doc_12
12	Friday	82	Doc_12
12	Saturday	83	Doc_12
12	Sunday	84	Doc_12
13	Monday	85	Doc_13
13	Tuesday	86	Doc_13
13	Wednesday	87	Doc_13
13	Thursday	88	Doc_13
13	Friday	89	Doc_13
13	Saturday	90	Doc_13
13	Sunday	91	Doc_13
14	Monday	92	Doc_14
14	Tuesday	93	Doc_14
14	Wednesday	94	Doc_14
14	Thursday	95	Doc_14
14	Friday	96	Doc_14
14	Saturday	97	Doc_14
14	Sunday	98	Doc_14
15	Monday	99	Doc_15
15	Tuesday	100	Doc_15
15	Saturday	104	Doc_15
15	Sunday	105	Doc_15
16	Monday	106	Doc_16
16	Tuesday	107	Doc_16
16	Wednesday	108	Doc_16
16	Thursday	109	Doc_16
16	Friday	110	Doc_16
16	Saturday	111	Doc_16
16	Sunday	112	Doc_16
17	Monday	113	Doc_17
17	Tuesday	114	Doc_17
17	Wednesday	115	Doc_17
17	Thursday	116	Doc_17
17	Friday	117	Doc_17
17	Saturday	118	Doc_17
17	Sunday	119	Doc_17
18	Monday	120	Doc_18
18	Tuesday	121	Doc_18
18	Wednesday	122	Doc_18
18	Thursday	123	Doc_18
18	Friday	124	Doc_18
18	Saturday	125	Doc_18
18	Sunday	126	Doc_18
19	Monday	127	Doc_19
19	Tuesday	128	Doc_19
19	Wednesday	129	Doc_19
19	Thursday	130	Doc_19
19	Friday	131	Doc_19
19	Saturday	132	Doc_19
19	Sunday	133	Doc_19
20	Monday	134	Doc_20
20	Tuesday	135	Doc_20
20	Wednesday	136	Doc_20
20	Thursday	137	Doc_20
20	Friday	138	Doc_20
20	Saturday	139	Doc_20
20	Sunday	140	Doc_20
21	Monday	141	Doc_21
21	Tuesday	142	Doc_21
21	Wednesday	143	Doc_21
21	Thursday	144	Doc_21
21	Friday	145	Doc_21
21	Saturday	146	Doc_21
21	Sunday	147	Doc_21
22	Monday	148	Doc_22
22	Tuesday	149	Doc_22
22	Wednesday	150	Doc_22
22	Thursday	151	Doc_22
22	Friday	152	Doc_22
22	Saturday	153	Doc_22
22	Sunday	154	Doc_22
23	Monday	155	Doc_23
23	Tuesday	156	Doc_23
23	Wednesday	157	Doc_23
23	Thursday	158	Doc_23
23	Friday	159	Doc_23
23	Saturday	160	Doc_23
23	Sunday	161	Doc_23
24	Monday	162	Doc_24
24	Tuesday	163	Doc_24
24	Wednesday	164	Doc_24
24	Thursday	165	Doc_24
24	Friday	166	Doc_24
24	Saturday	167	Doc_24
24	Sunday	168	Doc_24
25	Monday	169	Doc_25
25	Tuesday	170	Doc_25
25	Wednesday	171	Doc_25
25	Thursday	172	Doc_25
25	Friday	173	Doc_25
25	Saturday	174	Doc_25
25	Sunday	175	Doc_25
35	Sunday	177	Doc_46
36	Sunday	178	Doc_47
36	Monday	179	Doc_47
36	Tuesday	180	Doc_47
36	Wednesday	181	Doc_47
36	Thursday	182	Doc_47
36	Friday	183	Doc_47
36	Saturday	184	Doc_47
37	Sunday	185	Doc_48
37	Monday	186	Doc_48
37	Tuesday	187	Doc_48
37	Wednesday	188	Doc_48
37	Thursday	189	Doc_48
37	Friday	190	Doc_48
37	Saturday	191	Doc_48
38	Sunday	192	Doc_49
38	Monday	193	Doc_49
38	Tuesday	194	Doc_49
38	Wednesday	195	Doc_49
38	Thursday	196	Doc_49
38	Friday	197	Doc_49
38	Saturday	198	Doc_49
39	Sunday	199	Doc_50
39	Monday	200	Doc_50
39	Tuesday	201	Doc_50
39	Wednesday	202	Doc_50
39	Thursday	203	Doc_50
39	Friday	204	Doc_50
39	Saturday	205	Doc_50
40	Sunday	206	Doc_52
40	Monday	207	Doc_52
40	Tuesday	208	Doc_52
40	Wednesday	209	Doc_52
40	Thursday	210	Doc_52
40	Friday	211	Doc_52
40	Saturday	212	Doc_52
41	Sunday	213	Doc_53
41	Monday	214	Doc_53
41	Tuesday	215	Doc_53
41	Wednesday	216	Doc_53
41	Thursday	217	Doc_53
41	Friday	218	Doc_53
41	Saturday	219	Doc_53
42	Sunday	220	Doc_54
42	Monday	221	Doc_54
42	Tuesday	222	Doc_54
42	Wednesday	223	Doc_54
42	Thursday	224	Doc_54
42	Friday	225	Doc_54
42	Saturday	226	Doc_54
43	Sunday	227	Doc_55
43	Monday	228	Doc_55
43	Tuesday	229	Doc_55
43	Wednesday	230	Doc_55
43	Thursday	231	Doc_55
43	Friday	232	Doc_55
43	Saturday	233	Doc_55
44	Sunday	234	Doc_56
44	Monday	235	Doc_56
44	Tuesday	236	Doc_56
44	Wednesday	237	Doc_56
44	Thursday	238	Doc_56
44	Friday	239	Doc_56
44	Saturday	240	Doc_56
45	Sunday	241	Doc_57
45	Monday	242	Doc_57
45	Tuesday	243	Doc_57
45	Wednesday	244	Doc_57
45	Thursday	245	Doc_57
45	Friday	246	Doc_57
45	Saturday	247	Doc_57
46	Sunday	248	Doc_58
46	Monday	249	Doc_58
46	Tuesday	250	Doc_58
46	Wednesday	251	Doc_58
46	Thursday	252	Doc_58
46	Friday	253	Doc_58
46	Saturday	254	Doc_58
48	Sunday	255	Doc_91
48	Monday	256	Doc_91
48	Tuesday	257	Doc_91
48	Wednesday	258	Doc_91
48	Thursday	259	Doc_91
48	Friday	260	Doc_91
48	Saturday	261	Doc_91
49	Sunday	262	Doc_27
49	Monday	263	Doc_27
49	Tuesday	264	Doc_27
49	Wednesday	265	Doc_27
49	Thursday	266	Doc_27
49	Friday	267	Doc_27
49	Saturday	268	Doc_27
50	Sunday	269	Doc_92
50	Monday	270	Doc_92
50	Tuesday	271	Doc_92
50	Wednesday	272	Doc_92
50	Thursday	273	Doc_92
50	Friday	274	Doc_92
50	Saturday	275	Doc_92
51	Sunday	276	Doc_93
51	Monday	277	Doc_93
51	Tuesday	278	Doc_93
51	Wednesday	279	Doc_93
51	Thursday	280	Doc_93
51	Friday	281	Doc_93
51	Saturday	282	Doc_93
52	Sunday	283	Doc_95
52	Monday	284	Doc_95
52	Tuesday	285	Doc_95
52	Wednesday	286	Doc_95
52	Thursday	287	Doc_95
52	Friday	288	Doc_95
52	Saturday	289	Doc_95
56	Sunday	290	Doc_108
56	Monday	291	Doc_108
56	Tuesday	292	Doc_108
56	Wednesday	293	Doc_108
56	Thursday	294	Doc_108
56	Friday	295	Doc_108
56	Saturday	296	Doc_108
57	Sunday	297	Doc_109
57	Monday	298	Doc_109
57	Tuesday	299	Doc_109
57	Wednesday	300	Doc_109
57	Thursday	301	Doc_109
57	Friday	302	Doc_109
57	Saturday	303	Doc_109
58	Sunday	304	Doc_110
58	Monday	305	Doc_110
58	Tuesday	306	Doc_110
58	Wednesday	307	Doc_110
58	Thursday	308	Doc_110
58	Friday	309	Doc_110
58	Saturday	310	Doc_110
59	Sunday	311	Doc_111
59	Monday	312	Doc_111
59	Tuesday	313	Doc_111
59	Wednesday	314	Doc_111
59	Thursday	315	Doc_111
59	Friday	316	Doc_111
59	Saturday	317	Doc_111
63	Sunday	318	Doc_82
63	Monday	319	Doc_82
63	Tuesday	320	Doc_82
63	Wednesday	321	Doc_82
63	Thursday	322	Doc_82
63	Friday	323	Doc_82
63	Saturday	324	Doc_82
64	Sunday	325	Doc_83
64	Monday	326	Doc_83
64	Tuesday	327	Doc_83
64	Wednesday	328	Doc_83
64	Thursday	329	Doc_83
64	Friday	330	Doc_83
64	Saturday	331	Doc_83
65	Sunday	332	Doc_84
65	Monday	333	Doc_84
65	Tuesday	334	Doc_84
65	Wednesday	335	Doc_84
65	Thursday	336	Doc_84
65	Friday	337	Doc_84
65	Saturday	338	Doc_84
66	Sunday	339	Doc_112
66	Monday	340	Doc_112
66	Tuesday	341	Doc_112
66	Wednesday	342	Doc_112
66	Thursday	343	Doc_112
66	Friday	344	Doc_112
66	Saturday	345	Doc_112
67	Sunday	346	Doc_113
67	Monday	347	Doc_113
67	Tuesday	348	Doc_113
67	Wednesday	349	Doc_113
67	Thursday	350	Doc_113
67	Friday	351	Doc_113
67	Saturday	352	Doc_113
68	Sunday	353	Doc_114
68	Monday	354	Doc_114
68	Tuesday	355	Doc_114
68	Wednesday	356	Doc_114
68	Thursday	357	Doc_114
68	Friday	358	Doc_114
68	Saturday	359	Doc_114
69	Sunday	360	Doc_115
69	Monday	361	Doc_115
69	Tuesday	362	Doc_115
69	Wednesday	363	Doc_115
69	Thursday	364	Doc_115
69	Friday	365	Doc_115
69	Saturday	366	Doc_115
70	Sunday	367	Doc_69
70	Monday	368	Doc_69
70	Tuesday	369	Doc_69
70	Wednesday	370	Doc_69
70	Thursday	371	Doc_69
70	Friday	372	Doc_69
70	Saturday	373	Doc_69
71	Sunday	374	Doc_71
71	Monday	375	Doc_71
71	Tuesday	376	Doc_71
71	Wednesday	377	Doc_71
71	Thursday	378	Doc_71
71	Friday	379	Doc_71
71	Saturday	380	Doc_71
72	Sunday	381	Doc_72
72	Monday	382	Doc_72
72	Tuesday	383	Doc_72
72	Wednesday	384	Doc_72
72	Thursday	385	Doc_72
72	Friday	386	Doc_72
72	Saturday	387	Doc_72
73	Sunday	388	Doc_86
73	Monday	389	Doc_86
73	Tuesday	390	Doc_86
73	Wednesday	391	Doc_86
73	Thursday	392	Doc_86
73	Friday	393	Doc_86
73	Saturday	394	Doc_86
74	Sunday	395	Doc_89
74	Monday	396	Doc_89
74	Tuesday	397	Doc_89
74	Wednesday	398	Doc_89
74	Thursday	399	Doc_89
74	Friday	400	Doc_89
74	Saturday	401	Doc_89
79	Sunday	402	Doc_90
79	Monday	403	Doc_90
79	Tuesday	404	Doc_90
79	Wednesday	405	Doc_90
79	Thursday	406	Doc_90
79	Friday	407	Doc_90
79	Saturday	408	Doc_90
84	Sunday	409	Doc_97
84	Monday	410	Doc_97
84	Tuesday	411	Doc_97
84	Wednesday	412	Doc_97
84	Thursday	413	Doc_97
84	Friday	414	Doc_97
84	Saturday	415	Doc_97
85	Sunday	416	Doc_99
85	Monday	417	Doc_99
85	Tuesday	418	Doc_99
85	Wednesday	419	Doc_99
85	Thursday	420	Doc_99
85	Friday	421	Doc_99
85	Saturday	422	Doc_99
86	Sunday	423	Doc_100
86	Monday	424	Doc_100
86	Tuesday	425	Doc_100
86	Wednesday	426	Doc_100
86	Thursday	427	Doc_100
86	Friday	428	Doc_100
86	Saturday	429	Doc_100
87	Sunday	430	Doc_101
87	Monday	431	Doc_101
87	Tuesday	432	Doc_101
87	Wednesday	433	Doc_101
87	Thursday	434	Doc_101
87	Friday	435	Doc_101
87	Saturday	436	Doc_101
88	Sunday	437	Doc_104
88	Monday	438	Doc_104
88	Tuesday	439	Doc_104
88	Wednesday	440	Doc_104
88	Thursday	441	Doc_104
88	Friday	442	Doc_104
88	Saturday	443	Doc_104
89	Sunday	444	Doc_105
89	Monday	445	Doc_105
89	Tuesday	446	Doc_105
89	Wednesday	447	Doc_105
89	Thursday	448	Doc_105
89	Friday	449	Doc_105
89	Saturday	450	Doc_105
90	Sunday	451	Doc_106
90	Monday	452	Doc_106
90	Tuesday	453	Doc_106
90	Wednesday	454	Doc_106
90	Thursday	455	Doc_106
90	Friday	456	Doc_106
90	Saturday	457	Doc_106
91	Sunday	458	Doc_107
91	Monday	459	Doc_107
91	Tuesday	460	Doc_107
91	Wednesday	461	Doc_107
91	Thursday	462	Doc_107
91	Friday	463	Doc_107
91	Saturday	464	Doc_107
99	Sunday	465	Doc_116
99	Monday	466	Doc_116
99	Tuesday	467	Doc_116
99	Wednesday	468	Doc_116
99	Thursday	469	Doc_116
99	Friday	470	Doc_116
99	Saturday	471	Doc_116
103	Sunday	472	Doc_117
103	Monday	473	Doc_117
103	Tuesday	474	Doc_117
103	Wednesday	475	Doc_117
103	Thursday	476	Doc_117
103	Friday	477	Doc_117
103	Saturday	478	Doc_117
104	Sunday	479	Doc_118
104	Monday	480	Doc_118
104	Tuesday	481	Doc_118
104	Wednesday	482	Doc_118
104	Thursday	483	Doc_118
104	Friday	484	Doc_118
104	Saturday	485	Doc_118
105	Sunday	486	Doc_119
105	Monday	487	Doc_119
105	Tuesday	488	Doc_119
105	Wednesday	489	Doc_119
105	Thursday	490	Doc_119
105	Friday	491	Doc_119
105	Saturday	492	Doc_119
106	Sunday	493	Doc_121
106	Monday	494	Doc_121
106	Tuesday	495	Doc_121
106	Wednesday	496	Doc_121
106	Thursday	497	Doc_121
106	Friday	498	Doc_121
106	Saturday	499	Doc_121
107	Sunday	500	Doc_122
107	Monday	501	Doc_122
107	Tuesday	502	Doc_122
107	Wednesday	503	Doc_122
107	Thursday	504	Doc_122
107	Friday	505	Doc_122
107	Saturday	506	Doc_122
108	Sunday	507	Doc_123
108	Monday	508	Doc_123
108	Tuesday	509	Doc_123
108	Wednesday	510	Doc_123
108	Thursday	511	Doc_123
108	Friday	512	Doc_123
108	Saturday	513	Doc_123
109	Sunday	514	Doc_127
109	Monday	515	Doc_127
109	Tuesday	516	Doc_127
109	Wednesday	517	Doc_127
109	Thursday	518	Doc_127
109	Friday	519	Doc_127
109	Saturday	520	Doc_127
\.


--
-- Data for Name: doc_config_schedule_interval; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doc_config_schedule_interval ("startTime", "endTime", "docConfigScheduleDayId", id, doctorkey) FROM stdin;
18:55:00	23:50:00	3	578	\N
00:00:00	12:00:00	42	187	\N
05:00:00	06:00:00	13	162	\N
18:00:00	23:00:00	33	179	\N
02:00:00	06:00:00	12	109	Doc_1
08:00:00	12:00:00	81	221	\N
08:00:00	12:00:00	80	222	\N
08:00:00	12:00:00	79	223	\N
08:00:00	12:00:00	85	224	\N
16:13:00	17:13:00	30	367	\N
08:00:00	12:00:00	86	225	\N
08:00:00	12:00:00	88	226	\N
08:00:00	12:00:00	89	227	\N
16:00:00	22:00:00	86	228	\N
08:00:00	12:00:00	99	229	\N
08:00:00	12:00:00	100	230	\N
08:00:00	12:00:00	101	231	\N
08:00:00	12:00:00	103	232	\N
08:00:00	12:00:00	106	233	\N
08:00:00	12:00:00	107	234	\N
08:00:00	12:00:00	110	235	\N
08:00:00	12:00:00	113	236	\N
08:00:00	12:00:00	114	237	\N
08:00:00	12:00:00	116	238	\N
08:00:00	12:00:00	120	239	\N
08:00:00	12:00:00	121	240	\N
08:00:00	12:00:00	125	241	\N
08:00:00	12:00:00	126	242	\N
15:00:00	20:00:00	27	173	\N
08:00:00	12:00:00	123	243	\N
12:00:00	23:50:00	4	541	\N
08:00:00	12:00:00	128	244	\N
08:00:00	12:00:00	129	245	\N
08:00:00	12:00:00	130	246	\N
15:00:00	21:00:00	16	166	\N
15:00:00	20:00:00	25	172	\N
09:00:00	11:00:00	15	164	\N
09:00:00	11:00:00	16	165	\N
12:00:00	19:00:00	18	167	\N
13:00:00	23:55:00	6	562	\N
09:00:00	12:00:00	19	168	\N
15:00:00	21:00:00	21	169	\N
08:00:00	12:00:00	132	247	\N
08:00:00	12:00:00	134	248	\N
16:00:00	22:00:00	134	249	\N
16:00:00	22:00:00	135	250	\N
16:00:00	22:00:00	136	251	\N
16:00:00	22:00:00	138	252	\N
16:00:00	22:00:00	141	253	\N
09:00:00	14:00:00	29	176	\N
12:00:00	15:00:00	31	177	\N
18:00:00	21:00:00	31	178	\N
09:00:00	12:00:00	35	180	\N
14:00:00	21:00:00	35	181	\N
12:00:00	21:00:00	40	467	\N
14:00:00	19:00:00	49	194	\N
15:00:00	20:00:00	42	188	\N
09:00:00	14:00:00	43	189	\N
09:00:00	12:00:00	50	195	\N
15:00:00	21:00:00	51	196	\N
10:00:00	14:00:00	51	197	\N
10:00:00	14:00:00	53	198	\N
16:00:00	22:00:00	53	199	\N
16:00:00	22:00:00	54	200	\N
16:00:00	22:00:00	55	201	\N
09:00:00	12:00:00	55	202	\N
14:00:00	16:00:00	55	203	\N
14:00:00	16:00:00	56	204	\N
14:00:00	16:00:00	57	205	\N
09:00:00	15:00:00	58	206	\N
18:00:00	21:00:00	58	207	\N
18:00:00	21:00:00	60	208	\N
09:00:00	14:00:00	61	209	\N
16:00:00	23:00:00	61	210	\N
16:00:00	23:00:00	64	211	\N
09:00:00	12:00:00	64	212	\N
17:00:00	22:00:00	65	213	\N
09:00:00	12:00:00	66	214	\N
16:00:00	19:00:00	66	215	\N
16:00:00	19:00:00	69	216	\N
16:00:00	19:00:00	71	217	\N
08:00:00	12:00:00	71	218	\N
08:00:00	12:00:00	72	219	\N
08:00:00	12:00:00	75	220	\N
16:00:00	22:00:00	142	254	\N
16:00:00	22:00:00	143	255	\N
16:00:00	22:00:00	144	256	\N
16:00:00	22:00:00	146	257	\N
16:00:00	22:00:00	148	258	\N
16:00:00	22:00:00	149	259	\N
16:00:00	22:00:00	150	260	\N
16:00:00	22:00:00	151	261	\N
16:00:00	22:00:00	153	262	\N
16:00:00	22:00:00	155	263	\N
16:00:00	22:00:00	156	264	\N
16:00:00	22:00:00	157	265	\N
16:00:00	22:00:00	158	266	\N
16:00:00	22:00:00	162	267	\N
16:00:00	22:00:00	163	268	\N
16:00:00	22:00:00	164	269	\N
16:00:00	22:00:00	165	270	\N
16:00:00	22:00:00	169	271	\N
16:00:00	22:00:00	45	191	\N
14:00:00	19:00:00	47	193	\N
09:00:00	14:00:00	45	190	\N
12:00:00	15:00:00	22	148	\N
22:00:00	00:00:00	17	465	\N
17:00:00	23:50:00	38	463	\N
14:00:00	18:00:00	8	427	\N
09:00:00	12:00:00	8	105	Doc_1
03:00:00	06:00:00	41	471	\N
19:55:00	22:30:00	198	477	\N
16:00:00	22:00:00	170	273	\N
16:00:00	22:00:00	171	274	\N
16:00:00	22:00:00	172	275	\N
09:00:00	12:00:00	47	192	\N
19:55:00	08:54:00	47	276	\N
17:00:00	21:00:00	23	171	\N
10:00:00	12:00:00	7	419	\N
16:00:00	17:00:00	7	448	\N
12:40:00	20:40:00	1	576	\N
16:30:00	23:30:00	36	574	\N
01:00:00	02:00:00	1	570	\N
16:00:00	22:00:00	173	280	\N
16:00:00	22:00:00	174	281	\N
23:00:00	24:00:00	170	282	\N
16:13:00	17:13:00	30	368	\N
15:13:00	17:13:00	34	369	\N
20:00:00	22:00:00	34	478	\N
22:00:00	00:00:00	34	480	\N
13:00:00	23:00:00	39	542	\N
21:30:00	23:58:00	16	451	\N
14:35:00	20:35:00	199	484	\N
15:25:00	19:35:00	213	487	\N
18:30:00	23:00:00	228	488	\N
13:45:00	16:45:00	38	459	\N
20:00:00	23:00:00	15	428	\N
12:00:00	13:00:00	24	338	\N
18:30:00	23:55:00	24	490	\N
20:55:00	23:55:00	2	554	\N
00:00:00	03:00:00	17	455	\N
16:00:00	21:00:00	17	462	\N
14:45:00	17:49:00	196	492	\N
20:00:00	23:55:00	25	493	\N
00:22:00	05:22:00	11	466	\N
13:40:00	21:40:00	232	495	\N
20:00:00	21:00:00	8	411	\N
23:00:00	00:00:00	228	498	\N
16:15:00	23:22:00	11	438	\N
14:00:00	16:00:00	247	496	\N
21:00:00	23:00:00	247	497	\N
18:00:00	20:00:00	247	500	\N
15:00:00	18:00:00	233	499	\N
20:30:00	23:30:00	233	501	\N
20:00:00	23:55:00	27	502	\N
20:00:00	23:00:00	49	503	\N
16:30:00	20:30:00	32	360	\N
09:00:00	11:00:00	229	491	\N
14:45:00	20:45:00	229	504	\N
00:20:00	04:00:00	40	442	\N
23:00:00	00:00:00	33	469	\N
09:00:00	10:30:00	230	489	\N
17:00:00	23:50:00	41	476	\N
15:00:00	23:55:00	22	506	\N
21:00:00	11:00:00	10	430	\N
09:00:00	11:00:00	10	507	\N
00:00:00	01:00:00	228	563	\N
13:00:00	19:35:00	9	525	\N
10:00:00	12:00:00	37	483	\N
15:00:00	21:00:00	37	527	\N
11:00:00	16:00:00	2	575	\N
00:00:00	01:00:00	1	569	\N
02:00:00	04:00:00	1	573	\N
16:00:00	22:00:00	5	577	\N
15:00:00	15:30:00	237	512	\N
18:00:00	18:30:00	202	513	\N
20:00:00	20:30:00	201	514	\N
21:00:00	23:55:00	23	505	\N
13:00:00	15:00:00	7	447	\N
17:30:00	18:00:00	7	449	\N
21:35:00	22:35:00	7	515	\N
16:20:00	19:20:00	243	530	\N
16:22:00	19:22:00	179	531	\N
16:25:00	22:25:00	181	532	\N
16:27:00	17:27:00	190	533	\N
16:28:00	12:28:00	187	534	\N
16:45:00	21:45:00	222	535	\N
\.


--
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor ("doctorId", doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email, live_status, last_active) FROM stdin;
14	K Kalaiselvi	Acc_3	Doc_14	10	Oncology	MD DM	https://image.freepik.com/free-photo/front-view-doctor-with-copy-space_23-2148538573.jpg	9556424899	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	KalaiSelvi	K	RegD_14	kalaiselvi@gmail.com	online	\N
16	Maheshkumar N Upasani	Acc_4	Doc_16	20	Radiation oncologist	MD,PDCR	https://t4.ftcdn.net/jpg/03/20/74/45/240_F_320744554_7xVHrC9NEX6Bs0jhTObXki0YNMaGFiaD.jpg	9556724899	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Maheshkumar N	Upasani	RegD_16	maheshkumar@gmail.com	offline	\N
18	Murugesh\tDMRT	Acc_4	Doc_18	21	Radiation oncologist	DNB	https://image.freepik.com/free-photo/cheerful-young-doctor-making-notes_23-2147896147.jpg	9556728899	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Murugesh	DMRT	RegD_18	murugesh@gmail.com	offline	\N
8	Kumar ThulasiDass	Acc_2	Doc_8	12	Diabetology & Endocrinologist	MBBS MD	https://t3.ftcdn.net/jpg/02/94/22/64/240_F_294226407_Qs2FkZ96A6CQXFvuScJLqssEj5cIjglz.jpg	9856425885	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Kumar	Thuasi Dass	RegD_8	thulasidass@gmail.com	offline	\N
9	Rajeshwari  Ramachandran	Acc_2	Doc_9	17	Neurology	MBBS MD.DM	https://image.freepik.com/free-photo/beautiful-doctor-who-can-be-both-dentist-surgeon-beauty-doctor_42416-108.jpg	9856425889	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Rajeshwari	Ramachandran	RegD_9	rajeshwari@gmail.com	offline	\N
13	Parthasarathy Srinivasan	Acc_3	Doc_13	10	Orthopaedics	D Ortho, DNB Ortho, FNB Spine	https://t3.ftcdn.net/jpg/02/98/18/02/240_F_298180242_Llf0dK7UaycXV8dYV4mTMEzA9tA3vK36.jpg	9556424879	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Parthasarathy	Srinivasan	RegD_13	parthasarathy@gmail.com	offline	\N
25	 Balaji Srimurugan	Acc_6	Doc_25	16	Staff Cardiac Surgeon	MBBS, MS, M.Ch	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTatneAuqWZ6unmJLzlwSTHoQ88uccSjYqYnA&usqp=CAU	9556728906	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Balaji	Srimurugan	RegD_25	balajisrimurugan@gmail.com	offline	\N
21	Balamurali	Acc_5	Doc_21	11	Spine Surgery	MBBS.,MRCS.,MD.,FRCS	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSWr_rd-NMl-c8cllih3pgSwTPkDlmOQs-j6Q&usqp=CAU	9556728999	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Bala	Murali	RegD_21	balamurali@gmail.com	offline	2020-09-12 10:40:40.051
15	S Jayaraman	Acc_3	Doc_15	10	Pulmonology	MBBS DTCD DNB	https://t4.ftcdn.net/jpg/00/42/25/17/240_F_42251783_z2eHP60UJAjbRwLzV2RZOLY6TwqRB761.jpg	9556424899	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Jayaraman	S	RegD_15	jayaraman@gmail.com	offline	\N
12	 Sarala Rajajee	Acc_3	Doc_12	12	Paediatric Haematology	MD DCH DNB PhD	https://image.freepik.com/free-photo/beautiful-young-doctor-holding-clipboard_23-2148396668.jpg	9856424879	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Sarala	Rajajee	RegD_12	saralarajajee@gmail.com	offline	\N
22	Raghavan Subramanyan	Acc_6	Doc_22	21	Sr Consultant Cardiologist	MBBS, MD, DM, FRCPI, FSCAI, FSCI	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTNuHAV6Xra4T2sOweaPiXQB8ykz2VyuwxZBw&usqp=CAU	9556728909	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Raghavan	Subramanyan	RegD_22	raghavansubramaniyan@gmail.com	offline	\N
11	Usha Shukla	Acc_3	Doc_11	14	Family Medicine	MD	https://image.freepik.com/free-photo/beautiful-doctor-holding-folder-with-copy-space_23-2148396650.jpg	9856428879	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Usha	Shukla	RegD_11	ushashukla@gmail.com	offline	\N
43	Sekhar Kasi	Acc_1	Doc_55	5	GeneralPhysician	MBBS	\N	7845127845	\N	Sekhar	Kasi	RegD_42	sekharkasi@gmail.com	offline	2020-09-23 17:18:23.58
38	Thiru K	Acc_3	Doc_49	2	ENT	MBBS	\N	7845128956	\N	Thiru	K	RegD_37	\N	offline	2020-09-17 19:48:15.38
24	Sowmya Ramanan V	Acc_6	Doc_24	14	Paediatric Cardiac Surgery	MBBS, MS, M.Ch,MRCS	https://image.freepik.com/free-photo/smiley-female-doctor_23-2148453488.jpg	9556728901	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Sowmya	Ramanan V	RegD_24	sowmyaramananv@gmail.com	online	\N
39	Sekhar Kasi 1	Acc_1	Doc_50	\N	General Physician	MBBS	\N	\N	\N	Sekhar	Kasi 1	RegD_38	\N	online	2020-09-16 13:51:16.356
19	Mohammed Ibrahinm	Acc_4	Doc_19	21	Surgical oncologist	MS(Gen.Surg.), DNB(Gen.Surg.), DNB(Surg.Oncology),MRCSEd(UK), FMAS	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTObhsz227nveWHcnP5UWpBAo-l1zG0iYo3dg&usqp=CAU	9556728899	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Mohammed	Ibrahim	RegD_19	mohammedibrahim@gmail.com	offline	\N
20	Aravindan Selvaraj	Acc_5	Doc_20	11	Orthopaedic Surgery	MBBS.,MS.,FRCS( UK & IRELAND)	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcStWKOcMDsf6rK5Dr_Tda007t2NW3_AX5-gDA&usqp=CAU	9556728899	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Aravindan	Selvaraj	RegD_20	aravindanselvaraj@gmail.com	offline	\N
23	Anto sahayaraj. R	Acc_6	Doc_23	15	Paediatric Cardiac Surgery	MBBS, MS, M.Ch	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRooodIbehGBC70QAES8IE1wqGhmY3gloC0PQ&usqp=CAU	9556728901	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Anto	Sahayaraj R	RegD_23	antosahayaraj@gmail.com	offline	\N
26	Dharani Antharvedi	Acc_1	Doc_34	\N	\N	\N	\N	\N	\N	Dharani	Antharvedi	\N	\N	offline	\N
10	Vijay  Iyer	Acc_2	Doc_10	20	Neuro Surgery & Trauma Care	MS Mch	https://t3.ftcdn.net/jpg/00/84/20/24/240_F_84202401_5m1l13QaTo9G4i8vK5ZAs22JdKqGhjXc.jpg	9856425879	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Vijay	Iyer	RegD_10	vijayiyer@gmail.com	online	2020-10-08 13:58:02.477
40	Sekhar Kasi 2	Acc_1	Doc_52	\N	General Physician	MBBS	\N	\N	\N	Sekhar	Kasi 2	RegD_39	\N	offline	\N
7	Indhumathi R	Acc_2	Doc_7	7	Internal Medicine and masterhealth checkup	MBBS MD	https://image.freepik.com/free-photo/front-view-young-female-doctor-white-medical-suit-with-stethoscope-smiling-white_140725-16521.jpg	9856425889	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	indhumathi	R	RegD_7	indhumathir@gmail.com	online	2020-10-26 10:53:13.117
46	Dharani1 Antharvedi	Acc_1	Doc_58	5	ENT	MBBS	\N	7845127848	\N	Dharani1	Antharvedi	RegD_45	dharani1@gmail.com	offline	\N
41	Dharani Antharvedi	Acc_1	Doc_53	5	ENT	MBBS	\N	\N	\N	Dharani	Antharvedi	RegD_40	test22@gmail.com	online	2020-10-07 17:55:52.929
27	Dharani Antharvedi	Acc_1	Doc_37	\N	\N	\N	\N	\N	\N	Dharani	Antharvedi	RegD_26	\N	offline	\N
44	Madhu K	Acc_1	Doc_56	5	ENT	MBBS	\N	7845127845	\N	Madhu	K	RegD_43	madhu@gmail.com	offline	2020-09-18 20:04:59.535
42	Dharani Antharvedi	Acc_1	Doc_54	5	ENT	MBBS	\N	\N	\N	Dharani	Antharvedi	RegD_41	tests22@gmail.com	offline	\N
28	Dharani Antharvedi	Acc_1	Doc_38	\N	\N	\N	\N	\N	\N	Dharani	Antharvedi	RegD_27	\N	offline	\N
45	Ponni Dharani	Acc_1	Doc_57	5	ENT Special	MBBS	\N	7845760422	\N	Ponni	Dharani	RegD_44	ponni32@gmail.com	offline	2020-09-19 19:12:24.586
34	Ponni Doctor	Acc_1	Doc_45	\N	\N	\N	\N	\N	\N	Ponni	Doctor	RegD_33	\N	offline	2020-09-12 15:19:30.358
35	Ponni Doctor	Acc_1	Doc_46	\N	\N	\N	\N	\N	\N	Ponni	Doctor	RegD_34	\N	offline	\N
29	Dharani Antharvedi	Acc_1	Doc_40	\N	\N	\N	\N	\N	\N	Dharani	Antharvedi	RegD_28	\N	offline	\N
30	Dharani Antharvedi	Acc_1	Doc_41	\N	\N	\N	\N	\N	\N	Dharani	Antharvedi	RegD_29	\N	offline	\N
36	Ponni Doctor	Acc_1	Doc_47	\N	\N	\N	\N	\N	\N	Ponni	Doctor	RegD_35	\N	offline	2020-09-12 16:05:42.866
37	Ponni Doctor	Acc_1	Doc_48	\N	\N	MBBS	\N	\N	\N	Ponni	Doctor	RegD_36	\N	offline	2020-09-12 21:18:37.465
31	Dharani Antharvedi	Acc_1	Doc_42	\N	\N	\N	\N	\N	\N	Dharani	Antharvedi	RegD_30	\N	offline	\N
32	Dharani Antharvedi	Acc_1	Doc_43	\N	\N	\N	\N	\N	\N	Dharani	Antharvedi	RegD_31	\N	offline	\N
33	Ponni Doctor	Acc_1	Doc_44	\N	\N	\N	\N	\N	\N	Ponni	Doctor	RegD_32	\N	offline	2020-09-19 07:33:38.823
6	Sreeram Valluri	Acc_1	Doc_6	7	ENT	MBBS MD ENT	https://image.freepik.com/free-photo/portrait-cheerful-smiling-young-doctor-with-stethoscope-neck-medical-coat_255757-1414.jpg	9856425889	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Sreeram	Valluri	RegD_6	sreeram@apollo.com	offline	2021-01-22 14:43:12.556
56	Dharani Antharvedi	Acc_1	Doc_108	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_51	dharani1@gmail.com	offline	\N
4	Sree Kumar Reddy	Acc_1	Doc_4	26	Ophthamologist	MBBS MD Ophthamology	https://image.freepik.com/free-photo/handsome-smiling-medicine-doctor-sitting-office_151013-2102.jpg	9856425887	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Sree Kumar	Reddy	RegD_4	sreekumarreddy@apollo.com	offline	2021-01-11 21:31:49.694
3	Sheetal Desai	Acc_1	Doc_3	7	General Physician	MBBS	https://image.freepik.com/free-photo/beautiful-young-female-doctor-looking-camera-office_1301-7781.jpg	9856425847	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Sheetal	Desai	RegD_3	sheetal@gmail.com	offline	2020-10-31 15:04:36.452
1	Adithya K	Acc_1	Doc_1	7	Cardiologist	MBBS MD Cardiology	https://image.freepik.com/free-photo/portrait-smiling-handsome-male-doctor-man_171337-5055.jpg	9856325647	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Adithya	K	RegD_1	adithya@apollo.com	offline	2020-12-01 08:52:05.498
17	Balaji.J	Acc_4	Doc_17	21	Medical oncologist	DMRT, DNB(RT),DM (ONCOLOGY)	https://img.freepik.com/free-photo/friendly-afro-american-doctor-holding-clipboard-smiling-camera-isolated-gray-background_231208-2232.jpg?size=626&ext=jpg&ga=GA1.2.335809809.1576926003	9556727899	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Balaji	J	RegD_17	balajij@gmail.com	offline	2020-10-16 06:09:33.952
48	dsfd dfsd	Acc_1	Doc_91	5	ENT	MBBS	\N	7845127845	\N	dsfd	dfsd	RegD_46	test135@gmail.com	offline	\N
49	dsfd dfsd	Acc_1	Doc_27	5	ENT	MBBS	\N	7845127845	\N	dsfd	dfsd	RegD_47	test19835@gmail.com	offline	\N
2	Prof Narendranath Kanna	Acc_1	Doc_2	28	Cardiologist	MBBS MD Cardiology	https://us.123rf.com/450wm/dolgachov/dolgachov1712/dolgachov171201323/92019175-happy-doctor-with-clipboard-at-clinic.jpg?ver=6	9856325847	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Narendranath	Kanna	RegD_2	narendranath@apollo.com	offline	2020-12-09 14:48:35.6
50	Gayatri Anand	Acc_1	Doc_92	5	ENT	MBBS	\N	8956230147	\N	Gayatri	Anand	RegD_48	retdrfbvdgtgd@gmail.com	offline	\N
52	Dharani Antharvedi	Acc_1	Doc_95	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_50	asdasdsa@gmail.com	offline	\N
51	Dharani Antharvedi	Acc_1	Doc_93	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_49	dharani11@gmail.com	offline	\N
57	Dharani Antharvedi	Acc_1	Doc_109	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_52	test33@gmail.com	offline	\N
58	Dr. TEST	Acc_1	Doc_110	5	ENT	MBBS	\N	7845127845	\N	Dr.	TEST	RegD_53	test32@gmail.com	offline	\N
59	Dr. Edward	Acc_2	Doc_111	5	Cardiologist	MBBS	\N	8787878752	\N	Dr.	Edward	RegD_54	edward@gmail.com	offline	\N
5	Shalini Shetty	Acc_1	Doc_5	6	Ophthamologist	MBBS MD Ophthamology	https://image.freepik.com/free-photo/beautiful-doctor-raising-his-hands_23-2148396672.jpg	9856425888	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Shalini	Shetty	RegD_5	test@apollo.com	online	2021-01-22 16:47:34.67
88	firstName lastName	Acc_2	Doc_104	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_72	rtergdrrrr@gmail.com	offline	\N
89	firstName lastName	Acc_2	Doc_105	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_73	trtwetw@gmail.com	offline	\N
90	firstName lastName	Acc_2	Doc_106	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_74	asdasd@gmail.com	offline	\N
91	firstName lastName	Acc_2	Doc_107	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_75	efrf@gmail.com	offline	\N
109	Dharani Antharvedi	Acc_1	Doc_127	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_83	fgdgrfgd@gmail.com	offline	\N
73	Dharani Antharvedi	Acc_1	Doc_86	5	ENT	MBBS	photo.jpg	7845127845	signature	Dharani	Antharvedi	RegD_65	dsfdfsdf@gmail.com	offline	\N
74	Dharani Antharvedi	Acc_1	Doc_89	5	ENT	MBBS	photo.jpg	7845127845	signature	Dharani	Antharvedi	RegD_66	hjgjhfgj@gmail.com	offline	\N
63	Dharani Antharvedi	Acc_1	Doc_82	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_55	dhardgdani@gmail.com	offline	\N
64	Dharani Antharvedi	Acc_1	Doc_83	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_56	fdfd@gmail.com	offline	\N
66	Dharani Antharvedi	Acc_1	Doc_112	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_58	fgsgtrdrg@gmail.com	offline	\N
67	Dharani Antharvedi	Acc_1	Doc_113	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_59	dfdg@gmail.com	offline	\N
65	Anand k	Acc_1	Doc_84	5	General Physician	MBBS	\N	7845127845	\N	Anand	k	RegD_57	sdfdg@gmail.com	offline	\N
68	Dharani Antharvedi	Acc_1	Doc_114	5	ENT	MBBS	\N	7845127845	\N	Dharani	Antharvedi	RegD_60	dfdfdfdg@gmail.com	offline	\N
69	Dharani Antharvedi	Acc_1	Doc_115	5	ENT	MBBS	photo.jpg	7845127845	signature	Dharani	Antharvedi	RegD_61	gaytri@gmail.com	offline	\N
70	test 1	Acc_1	Doc_69	5	ENT	MBBS	photo.jpg	7845127845	signature	test	1	RegD_62	example1@gmail.com	offline	\N
71	test 1	Acc_1	Doc_71	5	ENT	MBBS	photo.jpg	7845127845	signature	test	1	RegD_63	example3@gmail.com	offline	\N
72	test 1	Acc_1	Doc_72	5	ENT	MBBS	photo.jpg	7845127845	signature	test	1	RegD_64	example4@gmail.com	offline	\N
79	Dharani Antharvedi	Acc_1	Doc_90	5	ENT	MBBS	photo.jpg	7845127845	signature	Dharani	Antharvedi	RegD_67	frewefwef@gmail.com	offline	\N
84	Dharani Antharvedi	Acc_1	Doc_97	5	ENT	MBBS	photo.jpg	7845127845	signature	Dharani	Antharvedi	RegD_68	sdfsdgdfsdf@gmail.com	offline	\N
85	Dharani Antharvedi	Acc_1	Doc_99	5	ENT	MBBS	photo.jpg	7845127845	signature	Dharani	Antharvedi	RegD_69	sdfsfsfwefsdf@gmail.com	offline	\N
86	firstName lastName	Acc_2	Doc_100	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_70	sdfgdrgrg@gmail.com	offline	\N
87	firstName lastName	Acc_2	Doc_101	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_71	sfdfsssssssssssgd@gmail.com	offline	\N
99	firstName lastName	Acc_2	Doc_116	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_76	dfsgsdv@gmail.com	offline	\N
103	firstName lastName	Acc_2	Doc_117	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_77	dsfdsf@gmail.com	offline	\N
104	firstName lastName	Acc_2	Doc_118	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_78	ytyr@gmail.com	offline	\N
105	firstName lastName	Acc_2	Doc_119	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_79	rtergdr4t@gmail.com	offline	\N
106	firstName lastName	Acc_2	Doc_121	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_80	eetrt@gmail.com	offline	\N
107	firstName lastName	Acc_2	Doc_122	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_81	anand12@gmail.com	offline	\N
108	firstName lastName	Acc_2	Doc_123	5	ENT	MBBS	photo.jpg	7845127845	signature	firstName	lastName	RegD_82	anand1345@gmail.com	offline	\N
\.


--
-- Data for Name: doctor_config_can_resch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor_config_can_resch (doc_config_can_resch_id, doc_key, is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_resch_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, is_active, created_on, modified_on) FROM stdin;
1	Doc_1	f	1	10	10	f	2	2	3	0	3	10	f	\N	2020-06-08
2	Doc_5	f	1	10	10	f	2	2	3	0	3	10	f	\N	2020-06-20
\.


--
-- Data for Name: doctor_config_pre_consultation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor_config_pre_consultation (doctor_config_id, doctor_key, consultation_cost, is_preconsultation_allowed, preconsultation_hours, preconsultation_minutes, is_active, created_on, modified_on) FROM stdin;
7	doc_1	1000	f	1	10	t	\N	2020-06-08
8	doc_1	1000	f	1	10	t	\N	2020-06-08
9	doc_1	1000	f	1	10	t	\N	2020-06-08
\.


--
-- Data for Name: interval_days; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interval_days (interval_days_id, start_time, end_time, wrk_sched_id) FROM stdin;
\.


--
-- Data for Name: medicine; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicine (id, prescription_id, name_of_medicine, frequency_of_each_dose, count_of_medicine_for_each_dose, type_of_medicine, dose_of_medicine, count_of_days) FROM stdin;
609	392	Fhjii	\N	0	\N	Vghjj	566
10	16	Chrosin	\N	0	\N	10ml/ 2	Morning only
11	16	Paracetomal	\N	0	\N	20ml/2	After food
12	16	dxcfd	\N	0	\N	fdfdfdfd	fdfdf
13	17	dfj	\N	0	\N	cfgfhj	56
14	18	hghg	\N	0	\N	xfhdgh	56
15	19	hjhgj	\N	0	\N	ghjghj	23
16	20	jhjh	\N	0	\N	gfgvj	4
17	21	gvjgj	\N	0	\N	fdhfhf	5
18	22	ghjhj	\N	0	\N	ghghb	56
19	23	gjh	\N	0	\N	jgvjh	567
20	24	hgvhg	\N	0	\N	ghb	4
21	25	syrup	\N	0	\N	10 ml, morning	30
22	26	syrup	\N	0	\N	10 ml, morning	30
23	27	syrup	\N	0	\N	10 ml, morning	30
24	28	syrup	\N	0	\N	10 ml, morning	30
25	29	syrup	\N	0	\N	10 ml, morning	30
26	30	syrup	\N	0	\N	10 ml, morning	30
27	31	test	\N	0	\N	dshjdhsj	2
28	32	test	\N	0	\N	dsds	3
29	33	test	\N	0	\N	dsds	3
30	34	test	\N	0	\N	dsds	3
31	35	dsds	\N	0	\N	dsdsdsds	dcsds45
32	35	xsds	\N	0	\N	sdsdsds	sdsd
33	36	dfgdfg	\N	0	\N	fgsdfgdfg	354
34	37	dghfj	\N	0	\N	gfhdj	56
35	38	htghgh	\N	0	\N	ghdfg	45
36	39	dhdfh	\N	0	\N	hdfhd	6456
37	40	rgg	\N	0	\N	fdgdfhg	454
38	41	rgg	\N	0	\N	fdgdfhg	454
39	41	ghdfh	\N	0	\N	hgh	\N
40	42	rgg	\N	0	\N	fdgdfhg	454
41	42	ghdfh	\N	0	\N	hgh	\N
42	43	dghg	\N	0	\N	gfhdfh	\N
43	44	sgs	\N	0	\N	sdgsfg	34534
44	44	sfgf	\N	0	\N	fsgshg	\N
45	45	sgs	\N	0	\N	sdgsfg	34534
46	45	sfgf	\N	0	\N	fsgshg	\N
47	45	thrh	\N	0	\N		rthrth
48	46	sgs	\N	0	\N	sdgsfg	34534
49	46	sfgf	\N	0	\N	fsgshg	\N
50	46	thrh	\N	0	\N		rthrth
51	47	gfhdgh	\N	0	\N		4
52	48	gfhdgh	\N	0	\N		4
53	48	jhj	\N	0	\N	ghdfgh	6
54	49	gfhdgh	\N	0	\N		4
55	49	jhj	\N	0	\N	ghdfgh	6
56	50	gfhdgh	\N	0	\N		4
57	50	jhj	\N	0	\N	ghdfgh	6
58	50	ghk	\N	0	\N	fjhghj	67
59	51	fgfd	\N	0	\N	fgdhf	45
60	52	fgfd	\N	0	\N	fgdhf	45
61	52	dhg	\N	0	\N	dghdgh	456
62	53	adsdsdsd	\N	0	\N	dfdddddd	333
63	53	jjjjjjjjjj	\N	0	\N	99999999	jjjjjj
64	54	gg	\N	0	\N	dfghdgh	46
65	54	dfhg	\N	0	\N	dfgdgh	46
66	55	hgdhd	\N	0	\N	sfgsfdhd	4
67	56	,gklg	\N	0	\N	fhkgk	fukj
68	57	syrup	\N	0	\N	10 ml	30
69	58	syrup	\N	0	\N	10 ml	30
70	59	syrup	\N	0	\N	10 ml	30
71	60	Hdhh	\N	0	\N	Fsfkgg	9
72	61	444	\N	0	\N	44	44
73	62	ghkc	\N	0	\N	gckugk	kg
74	63	ghkc	\N	0	\N	gckugk	kg
75	62	,vhj	\N	0	\N	khlkhl	hk
76	64	ghkc	\N	0	\N	gckugk	kg
77	62	,v	\N	0	\N	khlkhl	hk
78	64	,vhj	\N	0	\N	khlkhl	hk
79	65	ghkc	\N	0	\N	gckugk	kg
80	66	ghkc	\N	0	\N	gckugk	kg
81	65	,vhj	\N	0	\N	khlkhl	hk
82	66	,vhj	\N	0	\N	khlkhl	hk
83	65	,v	\N	0	\N	khlkhl	hk
84	67	ghkc	\N	0	\N	gckugk	kg
85	67	,vhj	\N	0	\N	khlkhl	hk
86	67	,v	\N	0	\N	khlkhl	hk
87	68	Paracitamol	\N	0	\N	after dinner	12
88	69	fghg	\N	0	\N	fhgfg	56
89	70		\N	0	\N		\N
90	71		\N	0	\N		\N
91	71		\N	0	\N		\N
92	71		\N	0	\N		\N
93	71		\N	0	\N		\N
94	72	dsfsdf	\N	0	\N	dfdfsdg	dfdf
95	73	sadsadasf	\N	0	\N	sdffdasfsadfafjhkjfkasfjlkasfjlkfjlfkklakflkflakf;lk	sfasf
96	74	xdfvf	\N	0	\N	xcbxcbc	xcvxcb
97	75		\N	0	\N		\N
98	75		\N	0	\N		\N
99	75		\N	0	\N		\N
100	75		\N	0	\N		\N
101	75		\N	0	\N		\N
102	75	sfdasf	\N	0	\N	sfdasf	sfdasf
103	75	sfdasf	\N	0	\N	sfdasf	sfdasf
104	75	sfdasf	\N	0	\N	sfdasf	sfdasf
105	75	SDFDF	\N	0	\N	DFSDFDG	DFSF
106	76	ghg	\N	0	\N	The 200 status code is by far the most common returned. It means, simply, that the request was received and understood and is being processed. A 201 status code indicates that a request was successful and as a result, a resource has been created (for example a new page).	56
107	77	Sdfg	\N	0	\N	Do hgg	11
108	77	Can hi u	\N	0	\N	Do hug week go from	12
109	78	Dhj	\N	0	\N	Do the to	11
110	78	Dgmv	\N	0	\N	Sh has to use to go at	12
111	79	Dhj	\N	0	\N	Do the to	11
112	79	Dgmv	\N	0	\N	Sh has to use to go at	12
113	79	Do j it t	\N	0	\N	So the food he f	11
114	79	Ggc	\N	0	\N	Dfdufu	12
115	80	Dhj	\N	0	\N	Do the to	11
116	80	Dgmv	\N	0	\N	Sh has to use to go at	12
117	80	Do j it t	\N	0	\N	So the food he f	11
118	80	Ggc	\N	0	\N	Dfdufu	12
119	81	Do no it fr	\N	0	\N	An odd as he g	11
120	81	Do kk	\N	0	\N	F have eh hi I've seen	12
121	82	Do no it fr	\N	0	\N	An odd as he g	11
122	82	Do kk	\N	0	\N	F have eh hi I've seen	12
123	83	So the so I j	\N	0	\N	Do yt	21
124	83	So hh	\N	0	\N	So in so it to g	22
125	84	So be he do hh	\N	0	\N	Ed j he Dr	11
126	84	So he do	\N	0	\N	So he ha j	12
127	85	So be he do hh	\N	0	\N	Ed j he Dr	11
128	85	So he do	\N	0	\N	So he ha j	12
129	86	Do gh	\N	0	\N	Do j if g hg	21
130	86	To us so	\N	0	\N	An hour so j	22
131	87	TEst	\N	0	\N	dsds	5
132	87	fdd	\N	0	\N	fdfd	555
133	88	dsfsd	\N	0	\N	The 200 status code is by far the most common returned. It means, simply, that the request was received and understood and is being processed. A 201 status code indicates that a request was successful and as a result, a resource has been created (for example a new page).	6
134	89	Do you j	\N	0	\N	To add dg	111
135	89	An hg	\N	0	\N	To f	112
136	89	Do if f	\N	0	\N	Go if r	113
137	90	Do you j	\N	0	\N	To add dg	111
138	90	An hg	\N	0	\N	To f	112
139	90	Do if f	\N	0	\N	Go if r	113
140	91	Do you	\N	0	\N	Fuyy	121
141	91	Do if	\N	0	\N	An hour d	122
142	91	G gg	\N	0	\N	So good day	123
143	92	Do you j	\N	0	\N	To add dg	111
144	92	An hg	\N	0	\N	To f	112
145	92	Do if f	\N	0	\N	Go if r	113
146	93	Do you	\N	0	\N	Fuyy	121
147	93	Do if	\N	0	\N	An hour d	122
148	93	G gg	\N	0	\N	So good day	123
149	94	Sh had an	\N	0	\N	See the u	131
150	94	Do it	\N	0	\N	So to h	132
151	95	fgc	\N	0	\N	The 200 status code is by far the most common returned. It means, simply, that the request was received and understood and is being processed. A 201 status code indicates that a request was successful and as a result, a resource has been created (for example a new page).	56
152	95	erfd	\N	0	\N	ccccc	66
153	96	Thio	\N	0	\N	Gjkko	66
154	96	Thio	\N	0	\N	Gjkko	66
155	96	Thio	\N	0	\N	Gjkko	66
156	97	Thio	\N	0	\N	Gjkko	66
157	97	Thio	\N	0	\N	Gjkko	66
158	97	Thio	\N	0	\N	Gjkko	66
159	97	Thio	\N	0	\N	Gjkko	66
160	98	Thio	\N	0	\N	Gjkko	66
161	98	Thio	\N	0	\N	Gjkko	66
162	98	Thio	\N	0	\N	Gjkko	66
163	98	Thio	\N	0	\N	Gjkko	66
164	99	Thio	\N	0	\N	Gjkko	66
165	99	Thio	\N	0	\N	Gjkko	66
166	99	Thio	\N	0	\N	Gjkko	66
167	99	Thio	\N	0	\N	Gjkko	66
168	99	Thio	\N	0	\N	Gjkko	66
169	100	Thio	\N	0	\N	Gjkko	66
170	100	Thio	\N	0	\N	Gjkko	66
171	100	Thio	\N	0	\N	Gjkko	66
172	100	Thio	\N	0	\N	Gjkko	66
173	100	Thio	\N	0	\N	Gjkko	66
174	101	Thio	\N	0	\N	Gjkko	66
175	101	Thio	\N	0	\N	Gjkko	66
176	101	Thio	\N	0	\N	Gjkko	66
177	101	Thio	\N	0	\N	Gjkko	66
178	101	Thio	\N	0	\N	Gjkko	66
179	102	Thio	\N	0	\N	Gjkko	66
180	102	Thio	\N	0	\N	Gjkko	66
181	102	Thio	\N	0	\N	Gjkko	66
182	102	Thio	\N	0	\N	Gjkko	66
183	102	Thio	\N	0	\N	Gjkko	66
184	102		\N	0	\N		\N
185	103	Thio	\N	0	\N	Gjkko	66
186	103	Thio	\N	0	\N	Gjkko	66
187	103	Thio	\N	0	\N	Gjkko	66
188	103	Thio	\N	0	\N	Gjkko	66
189	103	Thio	\N	0	\N	Gjkko	66
190	103		\N	0	\N		\N
191	104	Thio	\N	0	\N	Gjkko	66
192	104	Thio	\N	0	\N	Gjkko	66
193	104	Thio	\N	0	\N	Gjkko	66
194	104	Thio	\N	0	\N	Gjkko	66
195	104	Thio	\N	0	\N	Gjkko	66
196	104		\N	0	\N		\N
197	105	Thio	\N	0	\N	Gjkko	66
198	105	Thio	\N	0	\N	Gjkko	66
199	105	Thio	\N	0	\N	Gjkko	66
200	105	Thio	\N	0	\N	Gjkko	66
201	105	Thio	\N	0	\N	Gjkko	66
202	105		\N	0	\N		\N
203	106	Fhji	\N	0	\N	Tuo	56
204	106	Fhji	\N	0	\N	Tuo	56
205	106	Fhji	\N	0	\N	Tuo	56
206	106	Fhji	\N	0	\N	Tuo	56
207	107	Fhji	\N	0	\N	Tuo	56
208	107	Fhji	\N	0	\N	Tuo	56
209	107	Fhji	\N	0	\N	Tuo	56
210	107	Fhji	\N	0	\N	Tuo	56
211	107	Ghk	\N	0	\N	Hjj	99
212	107	Ghk	\N	0	\N	Hjj	99
213	107	Hh	\N	0	\N	Hjj	99
214	108	Fhji	\N	0	\N	Tuo	56
215	108	Fhji	\N	0	\N	Tuo	56
216	108	Fhji	\N	0	\N	Tuo	56
217	108	Fhji	\N	0	\N	Tuo	56
218	108	Ghk	\N	0	\N	Hjj	99
219	108	Ghk	\N	0	\N	Hjj	99
220	108	Hh	\N	0	\N	Hjj	99
221	109	Fhji	\N	0	\N	Tuo	56
222	109	Fhji	\N	0	\N	Tuo	56
223	109	Fhji	\N	0	\N	Tuo	56
224	109	Fhji	\N	0	\N	Tuo	56
225	109	Ghk	\N	0	\N	Hjj	99
226	109	Ghk	\N	0	\N	Hjj	99
227	109	Hh	\N	0	\N	Hjj	99
228	109	Abc	\N	0	\N	Hjj	99
229	110	Fhji	\N	0	\N	Tuo	56
230	110	Fhji	\N	0	\N	Tuo	56
231	110	Fhji	\N	0	\N	Tuo	56
232	110	Fhji	\N	0	\N	Tuo	56
233	110	Ghk	\N	0	\N	Hjj	99
234	110	Ghk	\N	0	\N	Hjj	99
235	110	Hh	\N	0	\N	Hjj	99
236	110	Abc	\N	0	\N	Hjj	99
237	111	Fhji	\N	0	\N	Tuo	56
238	111	Fhji	\N	0	\N	Tuo	56
239	111	Fhji	\N	0	\N	Tuo	56
240	111	Fhji	\N	0	\N	Tuo	56
241	111	Ghk	\N	0	\N	Hjj	99
242	111	Ghk	\N	0	\N	Hjj	99
243	111	Hh	\N	0	\N	Hjj	99
244	111	Abc	\N	0	\N	Hjj	99
245	112	Fhji	\N	0	\N	Tuo	56
246	112	Fhji	\N	0	\N	Tuo	56
247	112	Fhji	\N	0	\N	Tuo	56
248	112	Fhji	\N	0	\N	Tuo	56
249	112	Ghk	\N	0	\N	Hjj	99
250	112	Ghk	\N	0	\N	Hjj	99
251	112	Hh	\N	0	\N	Hjj	99
252	112	Abc	\N	0	\N	Hjj	99
253	112	Abc	\N	0	\N	Hjj	99
254	113	Fhji	\N	0	\N	Tuo	56
255	113	Fhji	\N	0	\N	Tuo	56
256	113	Fhji	\N	0	\N	Tuo	56
257	113	Fhji	\N	0	\N	Tuo	56
258	113	Ghk	\N	0	\N	Hjj	99
259	113	Ghk	\N	0	\N	Hjj	99
260	113	Hh	\N	0	\N	Hjj	99
261	113	Abc	\N	0	\N	Hjj	99
262	113	Abc	\N	0	\N	Hjj	99
263	114	Fhji	\N	0	\N	Tuo	56
264	114	Fhji	\N	0	\N	Tuo	56
265	114	Fhji	\N	0	\N	Tuo	56
266	114	Fhji	\N	0	\N	Tuo	56
267	114	Ghk	\N	0	\N	Hjj	99
268	114	Ghk	\N	0	\N	Hjj	99
269	114	Hh	\N	0	\N	Hjj	99
270	114	Abc	\N	0	\N	Hjj	99
271	114	Abc	\N	0	\N	Hjj	99
272	115	Fhji	\N	0	\N	Tuo	56
273	115	Fhji	\N	0	\N	Tuo	56
274	115	Fhji	\N	0	\N	Tuo	56
275	115	Fhji	\N	0	\N	Tuo	56
276	115	Ghk	\N	0	\N	Hjj	99
277	115	Ghk	\N	0	\N	Hjj	99
278	115	Hh	\N	0	\N	Hjj	99
279	115	Abc	\N	0	\N	Hjj	99
280	115	Abc	\N	0	\N	Hjj	99
281	116	hgfhgf	\N	0	\N	var id=appointmentId	45f
282	117	Do jj	\N	0	\N	Fhhg	11
283	117	Do hgf	\N	0	\N	So is so	12
284	118	So ogg	\N	0	\N	Do c	11
285	119	She	\N	0	\N	So he doesn't	95
286	120	nvm,j	\N	0	\N	,hj,	22
287	121	fdhgf	\N	0	\N	ftfg	565
288	121	hvg	\N	0	\N	tfhgfgh	yfyj
289	122	nvm,j	\N	0	\N	,hj,	22
290	123	nvm,j	\N	0	\N	,hj,	22
291	124	rthdrthd	\N	0	\N	jhjhjjg	67
292	124	sgsdf	\N	0	\N	jgfgj	7567
293	125	rthdrthd	\N	0	\N	jhjhjjg	67
294	125	sgsdf	\N	0	\N	jgfgj	7567
295	126	hii	\N	0	\N	mrng	10
296	127	again	\N	0	\N	after food only okay ah kkkkk	10 m
297	127	chrosin	\N	0	\N		555
298	128	fsgfd	\N	0	\N	vgj	46
299	129	hhbhbh	\N	0	\N	fghj	77
300	129	as	\N	0	\N	thfdhg	6
301	130	ggg	\N	0	\N	ggguuuuuuuuuu	gggg
302	130	gggg	\N	0	\N	gggggggg	gggg
303	131	hdfgdgf	\N	0	\N	dtfdhgf	45
304	131	jhhgfhgf	\N	0	\N	fgjgfhg	56
305	132	fhtgfhh	\N	0	\N	tgfht	6464
306	133	hfjggh	\N	0	\N	fghfghfdhg	454
307	133	jgj	\N	0	\N	fgfgh	656
308	133	fyyj	\N	0	\N	fyfhg	56
309	134	sgdsfg	\N	0	\N	erehd	545
310	134	tfthfht	\N	0	\N	dtfhgfgh	4564
311	135	Crosin	\N	0	\N	after food	3
312	135	Paracetomal	\N	0	\N	morning dsk	\N
313	135	ddddddddddd	\N	0	\N		\N
314	136	Fwhhj	\N	0	\N	Hu	5
315	136	Fwhhj	\N	0	\N	Hu	5
316	137	dddddd4	\N	0	\N	dsds	4
317	138	ddddddd4	\N	0	\N	bbjjhjhj	6767
318	139	fgdvfdd5dd	\N	0	\N	safdgssafdgb	4
319	140	dddddd	\N	0	\N	dsds	333
320	141	ytftyhf	\N	0	\N	trdrfg	5
321	142	ddd	\N	0	\N	sxxzxz	sasa
322	143	dddddddd	\N	0	\N	dsdsdsds	ds
323	144	ddd	\N	0	\N	dsdsdsds	dsds
324	144	dddd	\N	0	\N	55555555	fdfdfd
325	145	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
326	145	Dolo1	\N	0	\N	Gdrbbrb	10
327	145	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
328	146	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
329	146	Dolo1	\N	0	\N	Gdrbbrb	10
330	146	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
331	148	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
332	148	Dolo1	\N	0	\N	Gdrbbrb	10
333	148	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
334	151	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
335	151	Dolo1	\N	0	\N	Gdrbbrb	10
336	151	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
337	155	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
338	155	Dolo1	\N	0	\N	Gdrbbrb	10
339	155	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
340	160	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
341	160	Dolo1	\N	0	\N	Gdrbbrb	10
342	160	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
343	165	Dolo1	\N	0	\N	Dhr	59955992
344	166	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
345	166	Dolo1	\N	0	\N	Gdrbbrb	10
346	166	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
347	171	Dolo1	\N	0	\N	Dhr	59955992
348	173	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
349	173	Dolo1	\N	0	\N	Gdrbbrb	10
350	173	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
351	178	Dolo1	\N	0	\N	Dhr	59955992
352	181	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
353	181	Dolo1	\N	0	\N	Gdrbbrb	10
354	181	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
355	186	Dolo1	\N	0	\N	Dhr	59955992
356	190	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
357	190	Dolo1	\N	0	\N	Gdrbbrb	10
358	190	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
359	195	Dolo1	\N	0	\N	Dhr	59955992
360	199	Dolo1jfhrhrj	\N	0	\N	Dhrjrjrj	59955992
361	200	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
362	201	Dolo	\N	0	\N	Test tesy gsbsbbd d bdhdd ddhd d jdbd djd did d jrbrbr d  rjr f ff f jrr rf  r rijrh r r r rjrjjrjrjrrjrjjrjrjrjr fjrjrjrjr r r rrnjrjrjrjrjr jrjrjrjrnr fjrjrjrjrjrjr krkrkrkrjrjrjr rnrjkrkrkrr tktkktkr	10
363	200	Dolo1	\N	0	\N	Gdrbbrb	10
364	201	Dolo1	\N	0	\N	Gdrbbrb	10
365	200	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
366	201	Hdhrhr	\N	0	\N	Dhrbrbbrbr4b	59955992
367	210	Dolo1	\N	0	\N	Dhr	59955992
368	211	Dolo1	\N	0	\N	Dhr	59955992
369	218	Dolo1jfhrhrj	\N	0	\N	Dhrjrjrj	59955992
370	219	Dolo1jfhrhrj	\N	0	\N	Dhrjrjrj	59955992
371	223	I hhg	\N	0	\N	So glad he\nFf do jnd\nDo H I f for\nC hid I\nDo jjh	5
372	224	I hhg	\N	0	\N	So glad he\nFf do jnd\nDo H I f for\nC hid I\nDo jjh	5
373	226	Dolo	\N	0	\N	Hgq\nS b ngj\nGf can jk\nFd he\nS go j	5
374	227	I Jhf	\N	0	\N	Do it if	5
375	228	Do j in	\N	0	\N	J do so do seem to go do all set to see em	6
376	229	Do j in	\N	0	\N	J do so do seem to go do all set to see em	6
377	230	paracetmol	\N	0	\N	eth dkljgnvsnklf ppgjghth\nhante ipbejyph\n tpoykpot sby\nrbn yjptojy\nmorbyjeijygpoebgojerotg  jebyiotjyoi hsty\netjyo	70
378	231	Do hfh	\N	0	\N	I ha as ftdsg to e to cf f\nG Hj\nDo G hi\nC A wee tj\nDfgjj	8
379	232	I J	\N	0	\N	So do\nG hi fee do\nRjjh\nF hi he e	6
380	233	yhmkjygk	\N	0	\N	j,jg.,\nhfjfh\nkhk\njgk\njk\nj\nk	547
381	234	An do	\N	0	\N	jgv\nhol'h\nill\nyiofilo\nyioiyfo\niyoyio	87
382	235	jhkjhk785	\N	0	\N	ghjfg\n'kj;\n;\nuyu\nyjiykygk\nkg	80-
383	236	bgj,kj,	\N	0	\N	gjkdgjk\ngjkjfk\njgkjfk\njkfjkm\njfmk\njk mcnjdt	76
384	237	hdjhg	\N	0	\N	ghk\ngjkjg\njgkgm\ngjkfk\ngjmkgfk\nghkjgk\nfxggggggggs\nfgn xnjnjktudxxa	57
385	238	fghnfg	\N	0	\N	nhj\nghkjmgc\nhgmjhg\nfxhjx\nhkxhk\nhxkxhkf	65
386	239	fghnfg	\N	0	\N	nhj\nghkjmgc\nhgmjhg\nfxhjx\nhkxhk\nhxkxhkf	65
387	240	Dolodgbhsdgjkbdkbjsldkbjodsfjbdljbndnbvnb	\N	0	\N	dhsg\nfhgsh\ndhdg\ndghgn\nghkm vl;	53
388	241	fghnfg	\N	0	\N	nhj\nghkjmgc\nhgmjhg\nfxhjx\nhkxhk\nhxkxhkf	65
389	242	Dolodgbhsdgjkbdkbjsldkbjodsfjbdljbndnbvnb	\N	0	\N	dhsg\nfhgsh\ndhdg\ndghgn\nghkm vl;	53
390	243	mjghk gjkuuk jporhjpor ihjijop ijhp	\N	0	\N	nkfmnf nokfnkf nklbds iofvha;gvfbgouafgvoihgiodfhgaiodhgiod\n diubgdobgdi\ndbuihgdiobgdjibfdjosthijoigjhgkbiopsbz ls	65
391	244	nxfhmh mjgfsgbsjukjhmxbv eyagezjysjku	\N	0	\N	jj ldbnlknbhshSh\neblkdgn bkhiptebjps\npbgk;hnhnhnhnhnhnhnhnhnhnhnhnhnhnhnhnhnhnhngbdgbdgbdgbdgbdhzg, bnihpteaaaaakjb 	45
392	245	abcdefghijklmnopqrstuvwxyz	\N	0	\N	aaaaaaaaabbbbbbbbbbbbbbcccccccccccccddddddddddddeeeeeeeeefffffffffggggggggghhhhhhhiiiijjjjjjkkkkkllmmmnnnnnoooopppppppqqqqrsssttt	1234567890
393	246	abcdefghijklmnopqrstuvwxyz	\N	0	\N	aaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccdeffgggggggghhhhhhhhiiiijjjjjjjjkkkkkkkkkllllllmmmnnnooppppppqqqqq	1234567890
394	247	asdfghjklqwertyuiopzxcvbnm	\N	0	\N	awgdjgbkhvlpim'ln , xzchkpuytutdedfvhlno  jinvcmkb lnvcb nvclknbcvlnblvcnbijfgpjgbfnbifgjndsfl;agnbpd	1234567890
395	248	fhjydhj     mhhggggggggggggggggggggggggggmj	\N	0	\N	qwertyuiopasdfghjklzxcvbnmqwertghjkm.,, mnvnbjhbkjhblkjl	1234567890
396	249	fhjydhj     mhhggggggggggggggggggggggggggmj	\N	0	\N	qwertyuiopasdfghjklzxcvbnmqwertghjkm.,, mnvnbjhbkjhblkjl	1234567890
397	250	qwertyuiopasdfghjklzxcvbnmqwertyuiop	\N	0	\N	qwertyuiopqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnm....qwertyuiopasdfghjklzxcvbnm	1234567890
398	251	qwertyuiopasdfghjklzxcvbnm...asdfghjkl	\N	0	\N	qwertyuiopqwertyuiopqwertyuiop...asdfghjklasdfghjklasdfghjkl...zxcvbnmzxcvbnmzxcvbnm	1234567890
399	252	qwertyuiopasdfghjklzxcvbnmasdfghjkl123456789	\N	0	\N	qwertyuiopasdfghjklzxcvbnm1234567890qwertyuiopasdfghjklzxcvbnm1234567890	1234567890
400	253	qwertyuiopasdfghjklzxcvbnm1234567890	\N	0	\N	qwertyuiopasdfghjklzxcvbnm1234567890qwertyuiopasdfghjklzxcvbnm	1234567890
401	254	qwertyuiopasdfghjklzxcvbnm	\N	0	\N	1234567890qwertyuiopsdfghjklzxcvbnm1234567890	1234567890
402	255	qwertyuiop	\N	0	\N	aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb	1234567890
403	256	qwertyuiopasdfghjkl	\N	0	\N	aaaaaaaaaaaaaaassssssssddddddfffffffffgggghhhjjkkkkllllllllll	1234567890
404	257	qwertyuiop	\N	0	\N	aaaaaaaaaaaaaaassssssddddddddddfffffffffggggggggggggggggggghhhhhhhhhhjkkkkkkkkkkkkkkkkkkkklllllllll	1234567890123456789021234567890
405	258	qwertyuiiopasdfghjklzxcvbnm	\N	0	\N	aaaaaaaaaaaaasssssssssssssssddddddddddddddfffffffffffffggggggggggggggggggggggggghhhhhhhhhhhhhjjjjjjjjjjjjjjjjjjjjjjjkkkkkkkkkkkkkkkkkkkkkkkkkklllllllllllllllllllllllllllll	1234567890
406	259	123456789qwertyuiop[asdfghjkl;zxcvbnm	\N	0	\N	aaaaaaaaaaaaaaaabbbbbbbbcccccccccccccccccddddddddddddddddddddeeeeeeeeeeeeeefffffffffffffffffgggggggggggggghhhhhhhhhhhhhiiiiiiijjjjjjjjkkkkkkkkkkkkklllllllllllllllll	12345678901234567890
407	260	qwwertyuiop[sasdfgjlkzxcvbnm	\N	0	\N	aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccfffffffffffffffffffffffffjjjjjjjjjjjjjj;;;;;;;;;;;;;;;;;;;;nb sdddddddddddddddddjnnnnnnnnnnnnn	123456
408	261	qwwertyuiop[sasdfgjlkzxcvbnm	\N	0	\N	aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccfffffffffffffffffffffffffjjjjjjjjjjjjjj;;;;;;;;;;;;;;;;;;;;nb sdddddddddddddddddjnnnnnnnnnnnnn	123456
409	262	,l.kbhj	\N	0	\N	fhjhfjnklngjlg	65
410	263	dsbgfdbgjf	\N	0	\N	vbjvafjdlb;jl bj'\nglkbns kgaaaaaaaaaaaa\nbbbbbbbbbbbbbbbbbbbbbbbbccccccccccccccccdddddddddddddddeeeeeeeeeeeeeefff	320
411	264	xfkghc	\N	0	\N	flchchkvhk	54759
412	265	flexon	\N	0	\N	everday evening	10
413	266	paracetmol 650mg	\N	0	\N	daily twice for 5 days	10
414	267	paracetmol 650 mg	\N	0	\N	every day morning and evening for 5 days	10
415	267	cetrizine 5 mg	\N	0	\N	every day 1 tablet before sleeping tonight for 5 days	5
416	268	paracetmol 650 mg	\N	0	\N	every day morning and evening for 5 days	10
417	268	cetrizine 5 mg	\N	0	\N	every day 1 tablet before sleeping tonight for 5 days	5
418	269	expectorant 	\N	0	\N	5 ml thrice a day for 10 days	1
419	270	,mhc	\N	0	\N	v lhlvjb;jlb;jb\nbhgcjvhk	90
420	270	mgf	\N	0	\N	jhjhg\nhnjh lknkgnoisbngf\nndfokhgnm	46
421	271	paracet 650 mg	\N	0	\N	bjlnjgf	10
422	271	gdhgf	\N	0	\N	bfhgmhgm	11
423	272	paracet 650 mg	\N	0	\N	bjlnjgf	10
424	272	gdhgf	\N	0	\N	bfhgmhgm	11
425	273	presc2	\N	0	\N	dkjbnolkbn	20
426	273	presc21	\N	0	\N	fgjfldnljnb	21
427	274	paracet 650 mg	\N	0	\N	bjlnjgf	10
428	274	gdhgf	\N	0	\N	bfhgmhgm	11
429	275	presc2	\N	0	\N	dkjbnolkbn	20
430	275	presc21	\N	0	\N	fgjfldnljnb	21
431	277	fhjhg	\N	0	\N	dghfgj	10
432	278	fhjhg	\N	0	\N	dghfgj	10
433	280	hjghm	\N	0	\N	hgmkghmh	10
434	280	jnfn	\N	0	\N	hmv,bvm,	11
435	281	hjghm	\N	0	\N	hgmkghmh	10
436	281	jnfn	\N	0	\N	hmv,bvm,	11
437	282		\N	0	\N		11
438	283	hjghm	\N	0	\N	hgmkghmh	10
439	283	jnfn	\N	0	\N	hmv,bvm,	11
440	284		\N	0	\N		11
441	285		\N	0	\N		11
442	286	fgjghkg	\N	0	\N	fjxmxhxm	10
443	286	fymumy	\N	0	\N	fkmfmjf	11
444	287	fgjghkg	\N	0	\N	fjxmxhxm	10
445	287	fymumy	\N	0	\N	fkmfmjf	11
446	288		\N	0	\N		11
447	289	jjyky	\N	0	\N	hmdnhpmn	10
448	289	hks hk 	\N	0	\N	jnhkm	11
449	290	jjyky	\N	0	\N	hmdnhpmn	10
450	290	hks hk 	\N	0	\N	jnhkm	11
451	291		\N	0	\N		11
452	292	ykufk	\N	0	\N	hgkgk	10
453	293	ykufk	\N	0	\N	hgkgk	10
454	294		\N	0	\N		10
455	295	fjdhd	\N	0	\N	kes gjhmlkh	10
456	296	fjdhd	\N	0	\N	kes gjhmlkh	10
457	297		\N	0	\N		\N
458	298	vkn jb; l/k n	\N	0	\N	fckgujtlouyftgckgcgc	10
459	298	vhkbk	\N	0	\N	yfvyhv hkvjhc	11
460	299	vkn jb; l/k n	\N	0	\N	fckgujtlouyftgckgcgc	10
461	299	vhkbk	\N	0	\N	yfvyhv hkvjhc	11
462	301	vkn jb; l/k n	\N	0	\N	fckgujtlouyftgckgcgc	10
463	301	vhkbk	\N	0	\N	yfvyhv hkvjhc	11
464	304	fhbvjkfd	\N	0	\N	fjbvdjzbuosgnj	10
465	304	gnjnhlj	\N	0	\N	ngjbgnh;	11
466	305	hmjhgck	\N	0	\N	hmjkjk	10
467	305	fhjmhfkxhm	\N	0	\N	hmxhkxgkmhxjmhf fy	11
468	306	jyjhjhg	\N	0	\N	jhjhgj	10
469	306	gjnfxhkhfjk	\N	0	\N	hxjxhmvm ngzn gdjsdbgjhgncbnxf	11
470	307	gdjhfj	\N	0	\N	fgnjhfxjxh	10
471	307	jhkjhk	\N	0	\N	hfmjgkjg gmghc nxf	11
472	308	dgdg	\N	0	\N	cfjhjnhfjjgh	10
473	308	hgcjghjj	\N	0	\N	jhgmj,m nb vb,gkfxmhjkychmh	11
474	309	dgdg	\N	0	\N	cfjhjnhfjjgh	10
475	309	hgcjghjj	\N	0	\N	jhgmj,m nb vb,gkfxmhjkychmh	11
476	311	dgdg	\N	0	\N	cfjhjnhfjjgh	10
477	311	hgcjghjj	\N	0	\N	jhgmj,m nb vb,gkfxmhjkychmh	11
478	314	dzgjhjydrj	\N	0	\N	rsjnhsjmhfm	10
479	315	dzgjhjydrj	\N	0	\N	rsjnhsjmhfm	10
480	317	gjhjk	\N	0	\N	fhmhxmkxhm	10
481	317	jhhxjkxh	\N	0	\N	hmhgmjgc	11
482	318	gjhjk	\N	0	\N	fhmhxmkxhm	10
483	318	jhhxjkxh	\N	0	\N	hmhgmjgc	11
484	319	nhjhcgm	\N	0	\N	hmmcmc 	20
485	319	rshyfkhk	\N	0	\N	 ,hk,jgm nbmjhv,jvb	21
486	320	cfuuuuuuuuuuuuuuuuuuuybhgcf	\N	0	\N	vb vghv   cf mgg fc chjf	10
487	320	vyubn 	\N	0	\N	ftukhftudxcfvjhbtul,mbm fdhm cdxr,mb ncxdrug,rdu,mdr,mc xbdr xc	11
488	321	cfuuuuuuuuuuuuuuuuuuuybhgcf	\N	0	\N	vb vghv   cf mgg fc chjf	10
489	321	vyubn 	\N	0	\N	ftukhftudxcfvjhbtul,mbm fdhm cdxr,mb ncxdrug,rdu,mdr,mc xbdr xc	11
490	322	vh bfv,j	\N	0	\N	ddvggggggggggggggggggggggggggggsxejkn mbmnjknm ju	20
491	322	xdvhmmhgbh	\N	0	\N	b fhsw bh,kws3 bhuwes bhjsej	21
492	323	cykigfigc	\N	0	\N	o7tgt hngik,drtfkmgfvbc dfth cbfyrkhbc f	10
493	323	gckutctgkutcty	\N	0	\N	d7ykkkkkkrkur7kdc	11
494	324	cykigfigc	\N	0	\N	o7tgt hngik,drtfkmgfvbc dfth cbfyrkhbc f	10
495	324	gckutctgkutcty	\N	0	\N	d7ykkkkkkrkur7kdc	11
496	325	tufldk8	\N	0	\N	urdoudco7f7tujo	20
497	325	ihvltilvtguc	\N	0	\N	oflt8d5l ft7ugjvfty6idcrgciyhd6cidgg   yrjcftjucj dytcr	21
498	326	vhkg	\N	0	\N	dttuf	10
499	326	fjyu	\N	0	\N	kujkjmjvhku	11
500	327	vhkg	\N	0	\N	dttuf	10
501	327	fjyu	\N	0	\N	kujkjmjvhku	11
502	328	jvkjhv	\N	0	\N	hgkmghmkg ck	20
503	328	fckkck	\N	0	\N	yjydrjyhfjndj	21
504	329	vhkg	\N	0	\N	dttuf	10
505	329	fjyu	\N	0	\N	kujkjmjvhku	11
506	330	jvkjhv	\N	0	\N	hgkmghmkg ck	20
507	330	fckkck	\N	0	\N	yjydrjyhfjndj	21
508	332	gjnhfx	\N	0	\N	hjmhgckjcgjmj	10
509	332	kmcjcgkjcg	\N	0	\N	kjgckjgm jgmk	11
510	333	gjnhfx	\N	0	\N	hjmhgckjcgjmj	10
511	333	kmcjcgkjcg	\N	0	\N	kjgckjgm jgmk	11
512	334	cgjhcfkhxf	\N	0	\N	jkhgkhkghc	20
513	334	mjjkjhkjm,	\N	0	\N	mkcgjkxhkxk	21
514	335	hj chjcjghn hc g n	\N	0	\N	jmmkbcnmogfbgzb	10
515	335	nggngfx	\N	0	\N	Eh it to V I njd go kbgurr	11
516	336	I eeddghkdcvbn	\N	0	\N	Do kkvxnm eh up o ok if a as fg	10
517	336	Hjd I hhddhnnnnk	\N	0	\N	I'm uifd do h As ko it rj	11
518	337	I eeddghkdcvbn	\N	0	\N	Do kkvxnm eh up o ok if a as fg	10
519	337	Hjd I hhddhnnnnk	\N	0	\N	I'm uifd do h As ko it rj	11
520	338	hfjdhfjhd	\N	0	\N	hmxmc,c	20
521	338	cgkjcjcgk	\N	0	\N	kmjcg,jgckcgj 	21
522	339	hyktk	\N	0	\N	fjhjyhxjry	11
523	339	yjxmykxmjk	\N	0	\N	hmjcg,g  b,jcg jgcjm	12
524	340	hyktk	\N	0	\N	fjhjyhxjry	11
525	340	yjxmykxmjk	\N	0	\N	hmjcg,g  b,jcg jgcjm	12
526	341	hmfxhmhxm	\N	0	\N	fxhmghcm m	21
527	341	jmgcj	\N	0	\N	jckjdkicm ,dm,di	22
528	342	hkvh	\N	0	\N	gchc jyc	11
529	343	fhnjhfj	\N	0	\N	fjmnjmgx m, nvbv	11
530	343	nfhxmnjgxmxfg	\N	0	\N	fghmfxhmxv vnhcjkm yr hxyfnx 	12
531	344	medi	\N	0	\N		\N
532	344	fdfd	\N	0	\N		222
533	344		\N	0	\N		\N
534	345	gcjkgcjhckgu	\N	0	\N	trdcukcyilhvhcut	11
535	345	h vlhvihv	\N	0	\N	vgjkcutkds7i5sfjugooub	12
536	346	hfjmhdxkutkd	\N	0	\N	xfjnhfxm,u,f xfu,xf	11
537	346	dyjtdkutk	\N	0	\N	ghfkhgc,kjgc,ll	12
538	347	xfjyxrjyfrxk	\N	0	\N	zdyzkzk	11
539	347	fh,kiyflifyl	\N	0	\N	dkdtukudtkudtk	12
540	347	ejsysktsyky	\N	0	\N	jg,khc,.lkhc. khyifl	13
541	348	fhmjhmk	\N	0	\N	gdnhxjghk,jgxgjvn mjxg	10
542	349	fhdfgjfj	\N	0	\N	j ,gjg ,j	12
543	350	jxeytd	\N	0	\N	fxjyxmkyrf	10
544	350	yjzcnyu6zxj	\N	0	\N	 bmhf mbhfyz	12
545	351	mdku	\N	0	\N	gcdmc mz	10
546	352	hugip;ug	\N	0	\N	hyv;ouvu;	11
547	352	hk.v kvi;bu	\N	0	\N	cjiglvbliubuofytdvlvbhj,v 	12
548	353	jjuyfcgj	\N	0	\N	fghfsjj	11
549	353	hjmhfmjgx,j	\N	0	\N	hmjgcklhj.,kh vnfx 	12
550	354	jhlv hknv l	\N	0	\N	vjcl, hjcvyihlvgj	10
551	354	gjbvc .khv 	\N	0	\N	uvlgcv hkcv ihk.v 	20
552	355	6t4uyrujy	\N	0	\N	gfjhfxk	11
553	355	hgmhgmg	\N	0	\N	dg mgmxjg,	12
554	356	ghfzjnhfnjxfh	\N	0	\N	gdngfxjhf	11
555	356	dxjhfmhcmk	\N	0	\N	vmxhgh,mgm	12
556	357	ngjhfxn	\N	0	\N	gjnhjhfvhng	11
557	357	ghfjdhgkdhgm	\N	0	\N	hgmjgckjgc,gjcm	12
558	358	gcgjhgm	\N	0	\N	rhjjhd	11
559	358	ghmhgdm	\N	0	\N	hmgjmjgcm	12
560	359	tukuykflk	\N	0	\N	gkmjgkjgcmk	11h
561	360	gjhghjghcm ,m	\N	0	\N	fgjnhgm jgm ggcjm gcmxj	11
562	361	jjmjm	\N	0	\N	fhnhgmh	11
563	362	fhmkgj,kj	\N	0	\N	111111111111111111111	11
564	362	ghkmjvh,	\N	0	\N	trhmhjo8909up098-	22222222222
565	363	cetrizine 5 mg	\N	0	\N	tonight	10
566	363	paracetmol	\N	0	\N	morning and evening	20
567	364	flexon	\N	0	\N	evening	10
568	364	cetrizine	\N	0	\N	to night	10
569	365	jkfk	\N	0	\N	jnhmh;	21
570	366	hhgh	\N	0	\N	fhjnghjmgm	213
571	367	ryjutjkt	\N	0	\N	hjghjhgjgj	12
572	368	hgkuihlg	\N	0	\N	vnmbn,bm,	43
573	369	Dhi	\N	0	\N	Sgikdujg	22
574	370	Cetrizine	\N	0	\N	Daily 1 tablet before sleep	5
575	371	Cetrizine	\N	0	\N	Dugfukvgij	5
576	372	Duhf	\N	0	\N	Dhvg	8
577	372	Djiff	\N	0	\N	Synxhn	26
578	373	Ftic	\N	0	\N	Suhdh	11
579	373	Cyjv	\N	0	\N	Dvidg	8
580	373	Duhv	\N	0	\N	Dsgj	89
581	374	Dhhc	\N	0	\N	Xjf6u	11
582	374	Eyhh	\N	0	\N	Xubfj	16
583	375	Chh	\N	0	\N	Sthh	58
584	375	Rib	\N	0	\N	Xbfih	89
585	376	Asdf	\N	0	\N	Gshsj	97
586	376	Hdu	\N	0	\N	Hsjs	64
587	377	Hsusi	\N	0	\N	Ysusik	676
588	377	Tsuwu	\N	0	\N	Hsjs	34
589	378	Hsusi	\N	0	\N	Hsusj	646
590	378	Gshs	\N	0	\N	Gsjsj	646
591	379	Succ	\N	0	\N	Eudy g	12
592	379	Djc	\N	0	\N	Ctch 	88
593	380	hnjkk	\N	0	\N	h,kn.lkm.,/, 	14
594	381	Hsjsj	\N	0	\N	Gshskak	976
595	382	Hshaiai	\N	0	\N	Bsjskao	6764
596	383	Eivdj	\N	0	\N	Enfkv	56
597	384	Cetrizine	\N	0	\N	Before going to sleep	10
598	384	Paracetamol	\N	0	\N	Morning and evening	10
599	385	Rhh	\N	0	\N	Duncu	59
600	386	Fudbsb	\N	0	\N	Ffibrvomf	12
601	387	cetrizine	\N	0	\N	before going to sleep	5
602	388	Eygc	\N	0	\N	Sujdij	1
603	389	Paracetamol	\N	0	\N	After food	3
604	389	Crosin	\N	0	\N	After lunch	3
605	390	paracetmal	\N	0	\N	After lunch	3
606	390	cetric	\N	0	\N	Before sleep	5
607	391	Medicine1	\N	0	\N	Comment1	1
608	391	Medicine2	\N	0	\N	Comment2	2
\.


--
-- Data for Name: message_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message_metadata (id, message_type_id, communication_type_id, message_template_id) FROM stdin;
\.


--
-- Data for Name: message_template; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message_template (id, sender, subject, body) FROM stdin;
\.


--
-- Data for Name: message_template_placeholders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message_template_placeholders (id, message_template_id, placeholder_name, message_type_id) FROM stdin;
\.


--
-- Data for Name: message_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message_type (id, name) FROM stdin;
\.


--
-- Data for Name: openvidu_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.openvidu_session (openvidu_session_id, doctor_key, session_name, session_id) FROM stdin;
2270	Doc_49	Thiru K_1600338314723	ses_YuNRjlH2KF
2177	Doc_53	Dharani Antharvedi_1600250144786	ses_YSm69hBqlO
2710	Doc_57	Ponni Dharani_1600518262209	ses_Pon2q0zKrA
1621	Doc_48	Ponni Doctor_1599920413099	ses_D5JI9MBEsU
3017	Doc_55	Sekhar Kasi_1600857714180	ses_LC5nE8Y3AI
10482	Doc_6	Sreeram Valluri_1611299457986	ses_R3ekYB1Ink
1989	Doc_50	Sekhar Kasi_1600160725196	ses_Xh7l3bRMoS
2534	Doc_56	Madhu K_1600439634799	ses_GpeyvHxFeU
5193	Doc_2	Prof Narendranath Kanna_1607505481881	ses_A5WwcMQ18C
3934	Doc_3	Sheetal Desai_1604151598908	ses_Z1yRUplgK4
2987	Doc_7	Indhumathi R_1600802859943	ses_RQ5zg3Z10g
3890	Doc_17	Balaji.J_1602828557162	ses_STLqoOWYvW
9750	Doc_4	Sree Kumar Reddy_1610379803491	ses_WZN6v7KGNb
10522	Doc_5	Shalini Shetty_1611314246721	ses_DKXHb7jvmH
4504	Doc_1	Adithya K_1606812621974	ses_BOLZuGMstP
\.


--
-- Data for Name: openvidu_session_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.openvidu_session_token (openvidu_session_token_id, openvidu_session_id, token, doctor_id, patient_id) FROM stdin;
3861	2710	wss://devideo.virujh.com?sessionId=ses_Pon2q0zKrA&token=tok_IOKhDTzCoiNaHcrW&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=3HCK4Z&turnCredential=s3nsfy	45	\N
3034	1989	wss://devideo.virujh.com?sessionId=ses_Xh7l3bRMoS&token=tok_GOqfDghMcHfMvZlh&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=YQXJ5R&turnCredential=vwncbe	39	\N
3346	2270	wss://devideo.virujh.com?sessionId=ses_YuNRjlH2KF&token=tok_ZupVzZ9FeOb0K3pb&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=LLXA5U&turnCredential=8o4aht	38	\N
4180	2987	wss://devideo.virujh.com?sessionId=ses_RQ5zg3Z10g&token=tok_DmQtIh2jdt5C0V3u&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=MTGZPT&turnCredential=up1ff9	7	\N
12546	10522	wss://devideo.virujh.com?sessionId=ses_DKXHb7jvmH&token=tok_PPQcz6L5GmI3OhOL&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=72DZRY&turnCredential=nijgr9	5	\N
3667	2534	wss://devideo.virujh.com?sessionId=ses_GpeyvHxFeU&token=tok_Xi3QCdbimQmaGniI&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=3SMTUL&turnCredential=zxm5md	44	\N
2602	1621	wss://devideo.virujh.com?sessionId=ses_D5JI9MBEsU&token=tok_AZuewAR5PFugYYd3&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=FQUMHZ&turnCredential=lc4d4m	37	\N
4210	3017	wss://devideo.virujh.com?sessionId=ses_LC5nE8Y3AI&token=tok_VikUKM2pwF14ZLYE&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=DNTZOJ&turnCredential=3fw9d8	43	\N
3229	2177	wss://devideo.virujh.com?sessionId=ses_YSm69hBqlO&token=tok_YoDpDf7HPgiwhLQP&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=Y8MRPT&turnCredential=ffhgzt	41	\N
12499	10482	wss://devideo.virujh.com?sessionId=ses_R3ekYB1Ink&token=tok_WAihdmpvOWJmyyNg&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=BGAEML&turnCredential=cn3sc5	6	\N
5847	4504	wss://devideo.virujh.com?sessionId=ses_BOLZuGMstP&token=tok_K2XoHfKHp5svRQJT&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=FGIEHE&turnCredential=5guw6y	1	\N
5221	3934	wss://devideo.virujh.com?sessionId=ses_Z1yRUplgK4&token=tok_Ku6cM8f77aSouwLK&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=JCSCED&turnCredential=yt9szl	3	\N
6718	5193	wss://devideo.virujh.com?sessionId=ses_A5WwcMQ18C&token=tok_XfCX3MnHX2YtaS58&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=OW9TUC&turnCredential=msusfw	2	\N
5175	3890	wss://devideo.virujh.com?sessionId=ses_STLqoOWYvW&token=tok_KyrOhQ1Qgl0pzXyl&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=G7LFY6&turnCredential=5gfsgy	17	\N
11495	9750	wss://devideo.virujh.com?sessionId=ses_WZN6v7KGNb&token=tok_A5E5vRcig3T4jICx&role=PUBLISHER&version=2.14.0&coturnIp=3.7.245.106&turnUsername=3WZRVM&turnCredential=zpk4vv	4	\N
\.


--
-- Data for Name: patient_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id, "firstName", "lastName", "dateOfBirth", "alternateContact", age, live_status, last_active) FROM stdin;
28	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	75	bhavya	bhavya	26-08-1999	\N	\N	online	\N
29	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	76	bhavya	bhavya	26-08-1999	\N	\N	online	\N
30	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	77	bhavya	bhavya	26-08-1999	\N	\N	online	\N
671	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8763544352	446	firstName	lastName	DOB	alternateContact	21	online	\N
530	\N	\N	\N	\N	Dghhj	\N	\N	\N	\N	3333333333	420	Fgg	Vgv	25-01-1985	5633555555	35	online	2020-09-24 15:07:33.425
12	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	106	chaitanya	Antharvedi	26-08-1999	\N	\N	online	\N
816	changedd	porur	India	-	porur,chennai	ap	532242	example@gmai.com	\N	8888888888	182	aaaa	cccc	2017-10-04T13:40:00.000Z	9999989890	3	offline	2020-10-30 15:25:47.201
13	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	107	yogendra	Antharvedi	26-08-1999	\N	\N	online	\N
38	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	185	yamini	Antharvedi	26-08-1999	\N	\N	online	\N
23	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	61	Cherry	Cherry	26-08-1999	\N	\N	online	\N
24	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	60	Cherry	Cherry	26-08-1999	\N	\N	online	\N
26	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	56	Cherry	Cherry	26-08-1999	\N	\N	online	\N
27	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	73	bhavya	bhavya	26-08-1999	\N	\N	online	\N
11	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	23	chaitanya	Antharvedi	26-08-1999	\N	\N	online	\N
22	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	64	suresh	suresh	26-08-1999	\N	\N	online	\N
14	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	108	yogendra	Antharvedi	26-08-1999	\N	\N	online	\N
15	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	70	yogendra	Antharvedi	26-08-1999	\N	\N	online	\N
16	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	69	yogendra	Antharvedi	26-08-1999	\N	\N	online	\N
17	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	68	Bunny	Antharvedi	26-08-1999	\N	\N	online	\N
18	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	67	Gopi	Antharvedi	26-08-1999	\N	\N	online	\N
579	\N	\N	\N	\N	st	\N	\N	\N	\N	4545454545	427	ranjasn	raa	\N	4545554554	26	online	\N
875	\N	\N	\N	\N	Porur	\N	\N	\N	\N	9292929292	277	Vijaya	Lakshmi	01-01-1987	9393939393	33	online	\N
880	\N	\N	\N	\N	chennai	\N	\N	\N	\N	7788990011	281	santhosh	devan	2020-12-01T09:49:00.000Z	8899001122	0	offline	2020-12-02 10:13:22.254
686	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970235	471	firstName	lastName	DOB	alternateContact	21	online	\N
695	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970485	493	firstName	lastName	DOB	alternateContact	21	online	\N
9	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	9	chaitanya	Antharvedi	26-08-1999	\N	\N	online	\N
10	name	landmark	country	\N	address	state	pincode	nirmala123@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	10	chaitanya	Antharvedi	26-08-1999	\N	\N	online	\N
4	Amrutha	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999995	4	Amrutha	Akhila	26-08-1999	\N	\N	online	\N
25	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	50	Cherry	Cherry	26-08-1999	\N	\N	online	\N
105	kavin kavin	\N	\N	\N	\N	\N	\N	kavin@gmail.com	\N	8978978971	140	kavin	kavin	2020-07-30T13:02:00.000Z	\N	\N	online	\N
19	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	66	Gopi	Antharvedi	26-08-1999	\N	\N	online	\N
109	Dharani Antharvedi	\N	\N	\N	\N	\N	\N	dharan@softsuave.com	\N	9873535252	144	Dharani	Antharvedi	1994-01-19	\N	\N	online	\N
828	HSGDF sakjF	\N	\N	\N	\N	\N	\N	SDKFh@gmail.com	\N	8781374185	204	HSGDF	sakjF	1984-11-26T12:20:39.974Z	\N	\N	online	\N
32	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	79	Dharani	Dharani	26-08-1999	\N	\N	online	2020-10-27 11:12:36.789
876	\N	\N	\N	\N	porur	\N	\N	\N	\N	9393939392	278	vijaya	lakshmi	23-01-1985	9292929293	35	online	2020-12-01 11:33:17.748
937	arun de	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	9164079432	338	arun	de	2019-12-24T12:42:27.280Z	\N	\N	online	\N
878	\N	\N	\N	\N	chennai	\N	\N	\N	\N	7892709919	280	abhilash	c	1997-12-01T12:26:46.008Z	1892709910	23	online	2020-12-01 12:30:48.2
882	V K	\N	\N	\N	Chennai 	\N	\N	askfhsj@gmail.com	\N	9547845245	283	V	K	01-01-1985	9467845764	35	offline	2020-12-03 22:26:56.714
892	\N	\N	\N	\N	Chennai 	\N	\N	\N	\N	9422255555	293	C	S	01-01-1985	9457348454	35	offline	2020-12-03 21:23:31.772
874	\N	\N	\N	\N	chennai	\N	\N	\N	\N	6277889900	276	varun	kumar	2020-12-01T09:56:00.000Z	6543217890	0	offline	2020-12-04 15:12:16.966
905	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	9654785454	306	Kevin	K	1995-12-04T08:08:00.000Z	7584564124	25	offline	2020-12-04 14:06:32.732
908	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	9545545845	309	D	S P	01-01-2002	9547542654	18	offline	2020-12-07 14:11:56.809
912	Kevin K C	\N	\N	\N	\N	\N	\N	sekhar@softsuave.com	\N	9541256324	313	Kevin	K C	1989-12-11T06:44:37.239Z	\N	\N	online	\N
916	Gdgs Vsnsk	\N	\N	\N	\N	\N	\N	Gshsj@gmail.com	\N	9454815134	317	Gdgs	Vsnsk	1994-01-05	\N	\N	online	\N
20	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	63	Gopi	Gopi	26-08-1999	\N	\N	online	\N
50	\N	\N	\N	\N	12, Grand street, 	\N	\N	\N	\N	9999988888	82	New	Test	13-08-1989	9988776655	32	online	\N
51	\N	\N	\N	\N	21, Get	\N	\N	\N	\N	7777766666	83	John	Carter	16-11-1988	8989898989	34	online	\N
52	\N	\N	\N	\N	12, Great Yard	\N	\N	\N	\N	6666688888	84	New	Test	17-01-1985	8888800000	35	online	\N
53	\N	\N	\N	\N	Sgjvduob, fhklnv	\N	\N	\N	\N	9999999999	86	Fjk	Cjk	01-09-2021		\N	online	\N
386	\N	\N	\N	\N	Madiwala	\N	\N	\N	\N	9550184647	408	Johny	Doe	01-01-1985	8363826382	35	online	\N
55	\N	\N	\N	\N	Afjjv	\N	\N	\N	\N	8594236789	87	Dhkk	Chkl	01-01-1985		\N	online	\N
56	\N	\N	\N	\N	Jtxoudodu	\N	\N	\N	\N	9543684236	88	Txoyxkyx	Urzitxiiy	01-01-1985		\N	online	\N
58	\N	\N	\N	\N	12, wfhwjfh	\N	\N	\N	\N	8877665544	90	Thirunew	new	16-01-1985	2423434242	35	online	\N
60	\N	\N	\N	\N	\N	\N	\N	john@gmail.com	\N	9888888888	92	John	Wick	1994-01-25	\N	\N	online	\N
61	\N	\N	\N	\N	\N	\N	\N	wick@gmail.com	\N	9191919191	93	Wick	John	1994-01-29	\N	\N	online	\N
62	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999990000	94	littleSingam	chotaBheem	1999-10-26	\N	\N	online	\N
63	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900000	95	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
64	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900001	96	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
65	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900002	97	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
66	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900003	98	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
67	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900004	99	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
68	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900005	100	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
69	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900006	101	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
70	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900007	102	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
71	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900008	103	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
72	\N	\N	\N	\N	\N	\N	\N	jack@gmail.com	\N	9666666666	104	Jack	J	1993-12-23	\N	\N	online	\N
856	\N	\N	\N	\N	Hshau	\N	\N	\N	\N	7569646041	256	J	K	01-01-1985	7649464976	35	online	\N
74	name	landmark	country	\N	address	state	12346	nirm8968@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999900466	109	firstName123	lastName	DOB	alternateContact	21	online	\N
75	\N	\N	\N	\N	\N	\N	\N	rudra@nobitha.com	\N	9999900015	110	littleSingam	chotaBheem	1999-10-28	\N	\N	online	\N
76	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999461	111	firstName	lastName	DOB	alternateContact	21	online	\N
77	\N	\N	\N	\N	\N	\N	\N	email@gmail.com	\N	9999999980	112	nirmala@gmail.com	lastName	1999-10-26	\N	\N	online	\N
78	\N	\N	\N	\N	wall st	\N	\N	\N	\N	5456465456	113	asdfasd		2020-07-15T20:13:00.000Z		23	online	\N
79	\N	\N	\N	\N	sadf	\N	\N	\N	\N	2342323434	114	asfdasdf	sadfasdf	2020-07-01T20:16:00.000Z		234	online	\N
80	\N	\N	\N	\N	hdgfhdf	\N	\N	\N	\N	2342342343	115	asdfasdf	asdf	2020-07-07T20:17:00.000Z		23	online	\N
81	\N	\N	\N	\N	asdf	\N	\N	\N	\N	2432342342	116	dfsadfasfasd		2020-07-08T20:19:00.000Z		23	online	\N
82	\N	\N	\N	\N	asdfas	\N	\N	\N	\N	2342342333	117	asdfasdf	asdfasd	2020-07-07T20:23:00.000Z		23	online	\N
83	\N	\N	\N	\N	asdfa	\N	\N	\N	\N	2342342222	118	asdfasd		2020-07-08T20:25:00.000Z		23	online	\N
84	\N	\N	\N	\N	test1@apollo.com	\N	\N	\N	\N	7358916662	119	udhaya	Kumar	2018-04-16T20:47:00.000Z	7358916662	12	online	\N
85	\N	\N	\N	\N	test2@apollo.com	\N	\N	\N	\N	7358916682	120	udhaya	Kumar	2020-06-30T20:50:00.000Z	7358916682	12	online	\N
86	\N	\N	\N	\N	\N	\N	\N	sunil@gmail.com	\N	8499678498	121	sunil	kimar	2020-07-29T14:37:00.000Z	\N	\N	online	\N
87	sunil jay	\N	\N	\N	\N	\N	\N	jay@gmail.com	\N	9875647499	122	sunil	jay	2020-07-30T15:29:00.000Z	\N	\N	online	\N
88	sijut tam	\N	\N	\N	\N	\N	\N	john@gmail.com	\N	9867858989	123	sijut	tam	2020-07-30T17:33:00.000Z	\N	\N	online	\N
89	just once	\N	\N	\N	\N	\N	\N	just@gmail.com	\N	9879879876	124	just	once	2020-07-30T18:10:00.000Z	\N	\N	online	\N
90	\N	\N	\N	\N	madiwala	\N	\N	\N	\N	9634578524	125	Dom	nic	2020-07-27T08:36:00.000Z		33	online	\N
91	\N	\N	\N	\N	Tirupati	\N	\N	\N	\N	9999999997	126	Win	Diesel	2020-07-27T08:51:00.000Z		33	online	\N
93	\N	\N	\N	\N	Fxicoycoycpuv	\N	\N	\N	\N	9999999990	128	Ititxotxo	Ruogcoyc	16-01-1985		35	online	\N
94	\N	\N	\N	\N	Itcoycoyc	\N	\N	\N	\N	9999999998	129	Occp7c	Jf oy oy 	23-01-1985		35	online	\N
95	\N	\N	\N	\N	Skydluxlhx	\N	\N	\N	\N	9999966666	130	Jrzkyxkyd	Utzitdky	16-01-1985		35	online	\N
96	Dom Nick	\N	\N	\N	\N	\N	\N	dom@gmail.com	\N	9966884471	131	Dom	Nick	1994-01-28	\N	\N	online	\N
97	Win Diesel	\N	\N	\N	\N	\N	\N	win@gmail.com	\N	9966448875	132	Win	Diesel	1994-01-12	\N	\N	online	\N
98	The Rock	\N	\N	\N	\N	\N	\N	rock@gmail.com	\N	9966884476	133	The	Rock	1994-01-13	\N	\N	online	\N
99	Roman Reigns	\N	\N	\N	\N	\N	\N	roman@gmail.com	\N	9966884477	134	Roman	Reigns	1994-01-15	\N	\N	online	\N
100	Rock Man	\N	\N	\N	\N	\N	\N	rocker@gmail.com	\N	7777788888	135	Rock	Man	1994-01-12	\N	\N	online	\N
531	\N	\N	\N	\N	\N	\N	\N	\N	\N	9696969696	421	asas	assasasa	\N	\N	\N	online	\N
377	\N	\N	\N	\N	sdasfdsfsdf	\N	\N	\N	\N	9632587410	398	Harley	Davidson	2020-09-17T14:08:00.000Z	9874563214	35	offline	2020-09-18 14:16:20.732
7	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	7	Suresh Antharvedi	Suresh Antharvedi	26-08-1999	\N	\N	online	\N
101	\N	\N	\N	\N	Oxoyxpucpu	\N	\N	\N	\N	6666655555	136	Tsodpuc	Izrxoyxl	08-01-1985		35	online	\N
102	Brock Lesnar	\N	\N	\N	\N	\N	\N	brock@gmail.com	\N	7766889944	137	Brock	Lesnar	1994-01-13	\N	\N	online	\N
103	Under Taker	\N	\N	\N	\N	\N	\N	taker@gmail.com	\N	9638527410	138	Under	Taker	1994-01-10	\N	\N	online	\N
104	arul prakash	\N	\N	\N	\N	\N	\N	arul@gmail.com	\N	9898989898	139	arul	prakash	2020-07-31T12:09:00.000Z	\N	\N	online	\N
106	udhaya kumar	\N	\N	\N	\N	\N	\N	udhayakumar@softsuave.com	\N	8798121212	141	udhaya	kumar	2020-07-29T13:14:00.000Z	\N	\N	online	\N
107	Dean Ambrose	\N	\N	\N	\N	\N	\N	dean@gmail.com	\N	7896541230	142	Dean	Ambrose	2021-10-20T15:34:00.000Z	\N	\N	online	\N
108	Thiru Newupload	\N	\N	\N	\N	\N	\N	thiru@softsuave1.com	\N	9996667777	143	Thiru	Newupload	1994-01-13	\N	\N	online	\N
57	\N	\N	\N	\N	Gdjgxkhxkhxx	\N	\N	\N	\N	6576579579	89	Tuwiydoudud	Utzjgxkyxk	01-01-1985		\N	online	\N
59	\N	\N	\N	\N	Eeeeeyyyy	\N	\N	\N	\N	7766554433	91	New	Thiru	08-01-1985	6325625362	34	online	\N
906	Chj Cbk	\N	\N	\N	\N	\N	\N	Chj@gmail.com	\N	9545845454	307	Chj	Cbk	1994-01-01	\N	\N	online	\N
110	udhaya kumar	\N	\N	\N	\N	\N	\N	admin2@gmail.com	\N	9898989891	145	udhaya	kumar	2020-07-07T19:02:00.000Z	\N	\N	online	\N
111	udhaya kumar	\N	\N	\N	\N	\N	\N	udhayakumar@softsuave.com	\N	9111111111	146	udhaya	kumar	2020-07-19T19:05:00.000Z	\N	\N	online	\N
112	Harish Gowda	\N	\N	\N	\N	\N	\N	koustav@softsuave.com	\N	9895969595	147	Harish	Gowda	2020-07-28T19:28:00.000Z	\N	\N	online	\N
113	Seth Rollins	\N	\N	\N	\N	\N	\N	rollins@gmail.com	\N	8527419632	148	Seth	Rollins	2019-12-27T08:14:00.000Z	\N	\N	online	\N
114	Kim young	\N	\N	\N	\N	\N	\N	kim@gmail.com	\N	7893214562	149	Kim	young	2020-07-30T17:08:30.791Z	\N	\N	online	\N
118	\N	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9398341783	153	firstName	lastName	DOB	alternateContact	21	online	\N
119	\N	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9398341784	154	firstName	lastName	DOB	alternateContact	21	online	\N
120	\N	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9398341785	155	firstName	lastName	DOB	alternateContact	21	online	\N
121	\N	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9398341786	156	firstName	lastName	DOB	alternateContact	21	online	\N
122	\N	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9398341787	157	firstName	lastName	DOB	alternateContact	21	online	\N
123	\N	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9398341789	159	firstName	lastName	DOB	alternateContact	21	online	\N
362	\N	\N	\N	\N	chennai	\N	\N	\N	\N	8870555888	383	john	john	2020-06-08T19:51:00.000Z	9870987789	1	offline	2020-09-10 19:43:44.17
371	\N	landmark	country	\N	address	state	212121	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9677567234	392	firstName	lastName	DOB	alternateContact	21	online	\N
373	\N	\N	\N	\N	Xutxiyxicy	\N	\N	\N	\N	9999991111	394	Khckhc	Itdkgx	17-01-1985	9999999997	35	offline	2020-09-14 18:59:02.971
365	\N	\N	\N	\N	rgdsgsdgd	\N	\N	\N	\N	9874521458	386	asffg	gagag	2020-09-11T09:27:00.000Z	9674125489	35	offline	2020-09-11 16:24:40.439
375	\N	\N	\N	\N	Igxticiy	\N	\N	\N	\N	8755789856	396	Jfxgkxyoc	Jfxkgxkgx	17-01-1985	6447975368	\N	online	\N
359	\N	\N	\N	\N	13,5-efg	\N	\N	\N	\N	9487124855	380	Thiruvarasan	K	09-01-1985	9984269655	35	online	2020-09-16 03:10:21.361
382	\N	\N	\N	\N	KTPO	\N	\N	\N	\N	9550184644	404	Joshua	Cobb	1989-09-18T16:01:00.000Z	9550184644	31	offline	2020-09-18 22:13:32.7
378	Jaguar	\N	\N	\N	sdfszdf	\N	\N	\N	\N	8963251478	400	dgsdg	dfgsdg	1986-09-18T08:41:00.000Z	9875412563	34	offline	2020-09-18 14:51:02.51
397	\N	\N	\N	\N	Test 123	\N	\N	\N	\N	9894229677	419	Sriraman	S	06-05-1984	9994212674	36	offline	2020-09-20 20:58:22.826
92	\N	\N	\N	\N	andhra	\N	\N	\N	\N	9999999991	127	domnick		2020-07-14T08:57:00.000Z		33	offline	2020-09-12 20:48:11.642
389	\N	\N	\N	\N	12,goreges	\N	\N	\N	\N	8765876544	411	Geaorge	Bush	20-03-1987	7256353784	33	online	\N
364	\N	\N	\N	\N	Sarojini Devi Road	\N	\N	\N	\N	9791946880	385	Madhuq	sd	1989-09-14T15:15:00.000Z	6456456456	35	offline	2020-09-11 20:36:37.221
387	\N	\N	\N	\N	Gdhdjdk	\N	\N	\N	\N	5464545461	409	Hdjdjk	Hdjdk	01-01-1985	5461648754	35	offline	2020-09-19 14:58:59.592
380	\N	\N	\N	\N	Porur	\N	\N	\N	\N	9585858585	402	Maddhu	K	19-09-1983	9585082757	36	offline	2020-09-18 17:40:42.24
381	\N	\N	\N	\N	Whitefield	\N	\N	\N	\N	9550184643	403	Will	Jacks	1983-09-18T14:56:00.000Z	9852478546	37	offline	2020-09-18 21:30:58.58
21	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	62	suresh	suresh	26-08-1999	\N	\N	online	\N
33	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	71	Dharani	Dharani	26-08-1999	\N	\N	online	\N
393	\N	\N	\N	\N	Forst	\N	\N	\N	\N	6788766788	415	Goku	G	21-03-1984	6546789977	36	offline	2020-09-19 16:12:48.817
34	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	72	Dharani	Dharani	26-08-1999	\N	\N	online	\N
35	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	158	yamini	Dharani	26-08-1999	\N	\N	online	\N
817	Abc2 Def2	chennai	India	-	porur,chennai	ap	523322	abc@gmail.com	\N	9090909090	184	Abc	Def	2017-10-03T15:25:00.000Z	9898989898	3	offline	2020-10-31 07:11:27.238
370	\N	\N	\N	\N	kovai	\N	\N	\N	\N	6677889900	391	senthil	kumar	2020-09-01T14:25:00.000Z	7788990011	12	online	2020-10-05 23:28:08.059
372	\N	landmark	country	\N	address	state	212121	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9677567234	392	firstName	lastName	DOB	alternateContact	21	online	\N
374	\N	\N	\N	\N	Igxticiy	\N	\N	\N	\N	8755789856	395	Jfxgkxyoc	Jfxkgxkgx	17-01-1985	6447975368	\N	offline	2020-09-14 18:59:02.851
868	\N	\N	\N	\N	Porur	\N	\N	\N	\N	7995262232	270	Vijaya	Lakshmi	01-01-1985	7995262233	35	offline	2020-12-01 10:27:13.213
37	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	81	yamini	Antharvedi	26-08-1999	\N	\N	online	\N
360	\N	\N	\N	\N	13,5-efg	\N	\N	\N	\N	9487124855	381	Thiruvarasan	K	09-01-1985	9984269655	35	offline	2020-09-09 21:02:48.969
883	\N	\N	\N	\N	wwefrw	\N	\N	\N	\N	1234567890	284	viays	fdgfdg	16-01-1985	0987654321	35	offline	2020-12-03 21:06:03.905
893	\N	\N	\N	\N	Gshwu	\N	\N	\N	\N	9955555555	294	C	S	01-01-1985	9457213454	35	offline	2020-12-03 21:23:31.771
829	subha mishra	\N	\N	\N	\N	\N	\N	subhadarshi@softsuave.co	\N	9164079736	206	subha	mishra	1988-11-26T12:21:55.792Z	\N	\N	online	\N
830	afyt asdg	\N	\N	\N	\N	\N	\N	aaaf@gmail.com	\N	9878136153	208	afyt	asdg	1985-11-26T12:24:12.416Z	\N	\N	online	\N
907	\N	\N	\N	\N	Fgh	\N	\N	\N	\N	9454345484	308	Fhj	Chk	01-01-1985	9454543494	35	offline	2020-12-04 18:18:36.202
913	Kevin KC	\N	\N	\N	Chennai	\N	\N	sekhar@softsuave.com	\N	9542145245	314	Kevin	KC	2003-12-11T06:47:00.000Z	6587451248	17	offline	2020-12-11 12:56:32.952
917	\N	\N	\N	\N	Chennai 	\N	\N	\N	\N	9542457694	318	Chris	K C	01-01-1985	9547842345	35	offline	2020-12-11 19:24:34.575
921	\N	\N	\N	\N	test@apollo.com	\N	\N	\N	\N	7451236548	322	hardf	yu	2013-06-09T18:19:00.000Z	7451236549	7	offline	2020-12-17 23:59:18.885
922	\N	\N	\N	\N	test@apollo.com	\N	\N	\N	\N	9999888874	323	Sundar	Haran	2012-12-13T12:27:00.000Z	9999888875	8	offline	2020-12-21 18:00:44.124
947	\N	\N	\N	\N	Amphitheatre	\N	\N	\N	\N	6366786973	348	John	Doe	07-01-1994	9605535288	27	offline	2021-01-08 21:25:11.561
388	\N	\N	\N	\N	Gdhjeiw	\N	\N	\N	\N	6838376372	410	Hejej	Hsjsi	01-01-1985	9363628637	35	offline	2020-09-19 14:54:50.469
390	\N	\N	\N	\N	Theiw,sgs	\N	\N	\N	\N	8642864286	412	Frost	Bio	16-01-1985	8745363728	35	offline	2020-09-19 15:59:48.983
869	\N	\N	\N	\N	porur	\N	\N	\N	\N	7995262234	271	vijaya	lakshmi	10-01-1985	7995262233	35	online	2020-12-01 09:26:12.35
116	\N	\N	\N	\N	gnanaguru@softsuave.com	\N	\N	\N	\N	8870527821	151	guru	guru	2020-07-06T20:11:00.000Z		20	offline	2020-09-17 18:48:12.619
358	\N	\N	\N	\N	12,gsgshs	\N	\N	\N	\N	9487124844	379	Thiru	K	1978-09-08T13:29:00.000Z	9876543210	35	offline	2020-09-17 18:34:52.219
383	\N	\N	\N	\N	Chadalawada	\N	\N	\N	\N	9550184645	405	Jeevan	Patil	01-01-1985	9735472547	35	offline	2020-09-18 22:38:32.533
366		\N	\N	\N	dsfsgdsg	\N	\N	\N	\N	9654120789	387	aefagrg	dgfsdgdsg	2020-09-11T10:54:00.000Z	9654120789	35	offline	2020-09-11 16:39:47.416
379	\N	\N	\N	\N	12,GandhiNagar	\N	\N	\N	\N	8765876587	401	Musheer	A	08-01-1985	8765432198	35	offline	2020-09-18 14:35:44.019
532	\N	\N	\N	\N		\N	\N	\N	\N	1212121212	422	aasasa	assasasa	\N	1212121213	26	online	\N
580	\N	\N	\N	\N	dd	\N	\N	\N	\N	8888888866	428	sa	aa	\N	1111111122	26	online	\N
384	\N	\N	\N	\N	12,,,,,,garfield	\N	\N	\N	\N	8989878789	406	Daniel	Raine	14-10-1981	8273536271	38	offline	2020-09-19 02:47:56.693
920	Henry N 	porur	india	\N	porur	tamilnadu	522001	vijya@gmail.com		9643142514	321	Henry N			9154213484	35	offline	2020-12-14 13:15:09.558
938	\N	\N	Nitya nanda	\N	Porur Cjenai 	Nitya nanda	\N	\N		9585082757	339	\N	K		9840502333	36	offline	2020-12-24 22:10:22.553
884	\N	\N	\N	\N	feyyweg	\N	\N	\N	\N	7383747484	285	Thiru	K	05-11-1984	3453454544	36	online	\N
885	\N	\N	\N	\N	12, dhame	\N	\N	\N	\N	9574754485	286	harley	D	08-01-1985	3456764343	35	online	2020-12-03 20:43:40.027
395	\N	\N	\N	\N	P 303 bp	\N	\N	\N	\N	9701322000	417	Anand	P	17-09-1976	9445409137	44	offline	2020-09-20 21:26:13.978
369	\N	\N	\N	\N	12, hgsjs, ahsj	\N	\N	\N	\N	9487124866	390	Edison	A	1979-09-12T14:19:53.693Z	9873545367	35	offline	2020-09-12 21:21:12.788
385	\N	\N	\N	\N	Marathahalli	\N	\N	\N	\N	9550184646	407	John	Doe	01-01-1985	9373628273	35	offline	2020-09-19 13:18:22.057
363	karthika	\N	\N	\N	9999999996	\N	\N	\N	\N	6667778881	384	jersy	jersy	2020-09-02T14:13:00.000Z	9998887771	21	offline	2020-09-10 20:06:19.442
394	\N	\N	\N	\N	Hsjsjwjkwjqj	\N	\N	\N	\N	9550184649	416	John Welch	Field	01-01-1985	7362726382	31	offline	2020-09-19 17:28:44.971
533	\N	\N	\N	\N		\N	\N	\N	\N	1231234123	423	qqqqasas	qqqasas	\N	1313142425	23	online	\N
391	\N	\N	\N	\N	12,good	\N	\N	\N	\N	8642086420	413	John	Carter	16-01-1985	9753197531	35	online	\N
396	\N	\N	\N	\N	abcd	\N	\N	\N	\N	1234567891	418	Aravind	Parama	2020-09-20T14:17:00.000Z	1234567892	0	offline	2020-09-21 15:01:05.566
865	\N	\N	\N	\N	Guntur	\N	\N	\N	\N	6301303196	267	Vijayalakshmi	Tatiparthi	01-01-1999	7995262232	21	offline	2020-12-04 18:51:02.359
894	\N	\N	\N	\N	Hsha	\N	\N	\N	\N	9855555555	295	S	R H	01-01-1985	9457213484	35	offline	2020-12-03 21:25:25.52
914	\N	\N	\N	\N	chennai	\N	\N	\N	\N	6677889901	315	varun	kumar	2020-12-09T09:09:00.000Z	7689012341	0	offline	2020-12-19 15:09:16.925
909	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	9542786666	310	Jay	P	1984-12-08T14:24:00.000Z	9542147854	36	offline	2020-12-08 21:19:39.296
73	stest 	\N	\N	\N	d	\N	\N	artemis@gmail.com	\N	9876543210	105	stest	s	2014-11-12T08:02:00.000Z	9876543210	5	offline	2021-01-22 16:22:51.982
923	\N	\N	\N	\N	test@apollo.com	\N	\N	\N	\N	9623456259	324	Hari	balaji	2010-12-21T14:24:22.004Z	9623456258	10	offline	2020-12-21 19:59:43.047
948	\N	\N	\N	\N	P 303 Bhaggyam Pragathi 	\N	\N	\N	\N	9701322000	349	Anand	Paramasivan	17-06-1976	9445409137	44	offline	2021-01-11 15:35:39.168
955	\N	\N	\N	\N	Porur	\N	\N	\N	\N	8072389917	356	Ramesh 2	Patient	01-01-1985	8682866222	36	offline	2021-01-15 17:34:58.521
886	\N	\N	\N	\N	133,uauah	\N	\N	\N	\N	8764649485	287	Seem	T	01-01-1975	4554646488	45	online	2020-12-03 20:50:38.036
904	\N	\N	\N	\N	Gxhxj	\N	\N	\N	\N	9457842434	305	Hsks	Tsusi	01-01-1985	9457843494	35	offline	2020-12-03 23:28:42.436
946	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	9456454216	347	Gdhs	Gsjs	01-01-1985	9457215487	36	offline	2021-01-06 19:25:14.98
918	\N	\N	\N	\N	KhclgclHciiv	\N	\N	\N	\N	9544525664	319	Txhcuc	Ufuvi	01-01-1985	6554654566	35	offline	2020-12-11 21:04:21.193
910	Vhj Ghk	\N	\N	\N	\N	\N	\N	Fhj@gmail.com	\N	6254856845	311	Vhj	Ghk	1994-01-01	\N	\N	online	\N
850	\N	\N	\N	\N	madurai	\N	\N	\N	\N	6577889900	247	Ram	kumar	2017-11-02T11:13:00.000Z	6576890123	3	offline	2020-12-09 22:26:18.711
831	jtgs mishra	\N	\N	\N	\N	\N	\N	subhadardjgdfg@softsuave.com	\N	9957217317	210	jtgs	mishra	2006-11-26T12:27:01.008Z	\N	\N	online	\N
887	\N	\N	\N	\N	12,4554	\N	\N	\N	\N	9848477443	288	Hero	F	07-11-1984	3434345645	36	offline	2020-12-03 21:00:31.04
870	\N	\N	\N	\N	porur	\N	\N	\N	\N	7995262234	272	vijaya	lakshmi	10-01-1985	7995262233	35	offline	2020-12-01 10:50:41.863
949	\N	\N	\N	\N	Guruparadise Apartments, Hindu Colony, Nanganallur  Chennai 	\N	\N	\N	\N	9894229677	350	Sriraman 	Santhanam	06-05-1974	9994212674	46	offline	2021-01-11 15:22:49.314
939	\N	\N	\N	\N	porur	\N	\N	\N	\N	9685745263	340	jacky	jan	2000-12-30T05:04:00.000Z	9685746352	20	offline	2020-12-30 11:24:45.824
879	Chethan pujar	\N	\N	\N	chennai	\N	\N	chethanpn@gmail.com	\N	7892709915	202	Chethan	pujar	1998-12-01T12:38:32.319Z	9164079736	22	offline	2021-01-16 11:04:45.198
361	ponni	\N	\N	\N	softsuave technologies	\N	\N	\N	\N	8122977247	382	Ponni	Durai	1996-07-29T15:19:00.000Z	8122977247	24	offline	2020-09-19 18:33:25.985
115	Ramesh V	\N	\N	\N	ewrere	\N	\N	ramesh@softsuave.com	\N	8682866222	150	Ramesh	V	16-01-1985		33	online	2021-01-11 21:21:21.568
392	\N	\N	\N	\N	As, good	\N	\N	\N	\N	9879879879	414	Don	Konojee	19-12-1984	8979879879	35	online	\N
818	\N	\N	\N	\N	dddd	\N	\N	\N	\N	8888888889	186	aaaa	bbbb	2017-10-11T14:33:00.000Z	9990876543	3	offline	2020-11-02 14:58:31.025
845	K M	\N	\N	\N	\N	\N	\N	sekhar1@softsuave.com	\N	4578545545	237	K	M	2020-11-27T10:21:00.000Z	\N	\N	online	\N
895	\N	\N	\N	\N	Vzbsj	\N	\N	\N	\N	9755555555	296	R	J	01-01-1985	9457213459	35	offline	2020-12-03 21:53:44.994
924	rre wef	\N	\N	\N	\N	\N	\N	test@apollo.com	\N	7889655465	325	rre	wef	2017-12-22T17:36:52.965Z	\N	\N	online	\N
956	abcd 	\N	india	\N	abcd	tamilnadu	600016	\N	\N	9555544447	357	abcd		2011-01-20T12:06:16.335Z		10	offline	2021-01-20 17:47:37.432
915	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	6542789456	316	John	D	1994-12-11T10:24:00.000Z	9547854124	26	offline	2020-12-11 16:25:21.335
888	\N	\N	\N	\N	12,fgyf	\N	\N	\N	\N	4342342345	289	hgeg	we	08-01-1985	4545453453	35	online	\N
368	\N	\N	\N	\N	madurai	\N	\N	\N	\N	6678777123	389	Kumar	Kumar	2020-09-01T13:47:00.000Z	7766684561	12	offline	2020-09-23 15:46:01.746
925	gf gfg	\N	\N	\N	\N	\N	\N	test@apollo.com	\N	9988774411	326	gf	gfg	1993-12-23T05:12:07.289Z	\N	\N	online	\N
919	David D	Lake View Estate	India	123456	Chennai	T N	524132	david@gmail.com	\N	9547845214	320	David	D	1995-12-12T07:23:00.000Z	9578452145	25	offline	2020-12-12 17:11:06.337
896	\N	\N	\N	\N	Vzbsj	\N	\N	\N	\N	9454675464	297	Vahaj	Hahai	01-01-1985	6457945784	35	offline	2020-12-04 18:58:45.877
957	Fshsj Gshsj	\N	\N	\N	\N	\N	\N	Gshsj@gmail.com	\N	9995243654	358	Fshsj	Gshsj	1994-01-01	\N	\N	online	\N
911	\N	\N	\N	\N	Hhsjs	\N	\N	\N	\N	9457243154	312	A	P K	01-01-1985	9124548721	35	offline	2020-12-09 10:20:46.733
871	\N	\N	\N	\N	chennai	\N	\N	\N	\N	7892709916	273	anbhu	mani	1998-05-14T09:31:00.000Z	9164079737	22	offline	2020-12-01 09:35:23.878
862	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	9550185642	264	sdfsdf	sdfds	2005-11-30T13:09:00.000Z	6547854124	15	online	\N
940	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	9963254275	341	Goerge	Worker	01-01-1985	9154243457	36	offline	2021-01-04 16:59:04.747
577	\N	\N	\N	\N	State	\N	\N	\N	\N	1212111212	425	asasas	saassa	\N	2121212222	22	online	\N
950	\N	\N	\N	\N	50 jr street	\N	\N	\N	\N	9384051551	351	Mukundh	B	11-08-1974	9840027655	46	offline	2021-01-11 15:30:04.657
832	fdh jhgf	\N	\N	\N	\N	\N	\N	jhsd@gmail.com	\N	8522222224	211	fdh	jhgf	1995-11-26T12:28:18.989Z	\N	\N	online	\N
846	xcvxcb xcbcxbb	\N	\N	\N	\N	\N	\N	sekhar1@softsuave.com	\N	9854422145	239	xcvxcb	xcbcxbb	2020-11-27T10:23:08.020Z	\N	\N	online	\N
872	\N	\N	\N	\N	chennai	\N	\N	\N	\N	7892709914	274	nithish	b	1998-12-01T09:35:25.492Z	9164079735	22	online	2020-12-01 09:36:52.949
926	gfg fgfgb	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	7845512255	327	gfg	fgfgb	2007-12-23T06:48:59.723Z	\N	\N	online	\N
889	\N	\N	\N	\N	23,fgd	\N	\N	\N	\N	7367467334	290	Tud	ere	08-01-1985	3454635645	35	offline	2020-12-03 21:16:19.516
901	\N	\N	\N	\N	12,44453	\N	\N	\N	\N	2452454345	302	New	User	08-01-1985	3535353513	35	offline	2020-12-03 21:57:04.734
941	Win 	Lake	\N	\N	Chennai	\N	\N	\N		9521432547	342	Win			9524687452	36	offline	2021-01-04 17:11:57.565
897	\N	\N	\N	\N	Gshsj	\N	\N	\N	\N	9454845731	298	Shsj	Ysuwi	01-01-1985	8457648454	35	offline	2020-12-03 21:57:48.095
900	\N	\N	\N	\N	Fhu	\N	\N	\N	\N	8845985998	301	Ryu	Tyu	01-01-1985	8856885655	35	offline	2020-12-03 21:57:48.106
899	\N	\N	\N	\N	Gshsh	\N	\N	\N	\N	9457845724	300	Hshs	Ysuw	01-01-1985	9457846784	35	offline	2020-12-03 21:57:48.106
898	\N	\N	\N	\N	Gahwiw	\N	\N	\N	\N	9457645721	299	Hdhei	Ysuwi	01-01-1985	9457548754	35	offline	2020-12-03 21:57:48.107
687	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970235	471	firstName	lastName	DOB	alternateContact	21	online	\N
734	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560443	40	gayatri	anand	16-06-1995	alternateContact	21	online	\N
673	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970000	450	firstName	lastName	DOB	alternateContact	21	online	\N
679	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970221	462	firstName	lastName	DOB	alternateContact	21	online	\N
688	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970235	471	firstName	lastName	DOB	alternateContact	21	online	\N
696	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970486	497	firstName	lastName	DOB	alternateContact	21	online	\N
703	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970988	505	firstName	lastName	DOB	alternateContact	21	online	\N
728	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7098926439	34	gayatri	anand	16-06-1995	alternateContact	21	online	\N
741	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560603	47	gayatri	anand	16-06-1995	alternateContact	21	online	\N
763	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9898523100	3	gayatri	anand	16-06-1995	alternateContact	21	online	\N
833	dgfds sbbs	\N	\N	\N	\N	\N	\N	ssss@gmail.com	\N	9178365147	213	dgfds	sbbs	1986-11-26T13:41:59.342Z	\N	\N	online	\N
847	v sdgsdg	\N	\N	\N	\N	\N	\N	sekhar@softsuave.com	\N	6478541254	241	v	sdgsdg	2020-11-27T10:28:17.957Z	\N	\N	online	\N
958	John 	M	M	\N	John	M	\N	\N		9456242154	359	John			9157243154	36	offline	2021-01-20 19:47:36.998
951		\N	\N	\N		\N	\N	\N		8940833838	352		Viju		8940852360	23	offline	2021-01-13 00:32:03.914
762	\N	landmark	India	\N	address	state	826004	abcd@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8529631470	2	gayatri	A	16-06-1995	alternateContact	21	online	\N
755	\N	landmark	India	\N	address	state	826004	abcd@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8765431001	11	gayatri	A	16-06-1995	alternateContact	21	online	\N
367	\N	\N	\N	\N	Tirupati	\N	\N	\N	\N	6302293359	388	Prasad	Guru	2020-09-11T12:40:00.000Z	9854789654	35	offline	2020-09-24 01:23:43.492
927	fgh jj	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	7788994455	328	fgh	jj	2005-12-23T07:15:27.775Z	\N	\N	online	\N
942	Hhshsh Gshsi	\N	\N	\N	\N	\N	\N	Gshsh@gmail.com	\N	9999464578	343	Hhshsh	Gshsi	1994-01-01	\N	\N	online	\N
902	\N	\N	\N	\N	12,shfdfssd,sdjs	\N	\N	\N	\N	9884637343	303	 Caer	FGf	15-01-1985	2323423423	35	offline	2020-12-03 22:22:05.624
46	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	65	Thanu	Thanu	26-08-1999	\N	\N	online	\N
39	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	187	yamini	Antharvedi	26-08-1999	\N	\N	online	\N
40	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	55	kalyani	kalyani	26-08-1999	\N	\N	online	\N
41	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	74	kalyani	Antharvedi	26-08-1999	\N	\N	online	\N
42	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	162	kalyani	Antharvedi	26-08-1999	\N	\N	online	\N
43	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	205	kalyani	kalyani	26-08-1999	\N	\N	online	\N
45	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	145	Thanu	Thanu	26-08-1999	\N	\N	online	\N
47	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	187	Apple	Apple	26-08-1999	\N	\N	online	\N
903	\N	\N	\N	\N	Fho	\N	\N	\N	\N	9548755658	304	Dfg	Dtu	01-01-1985	5656984669	35	offline	2020-12-03 22:04:50.32
819	\N	\N	\N	\N	porur,chennai	\N	\N	\N	\N	9640564077	188	First	Last	2017-11-08T15:00:00.000Z	9640564072	2	online	2020-11-27 12:06:29.388
890	\N	\N	\N	\N	Chennai 	\N	\N	\N	\N	9423155555	291	D	C	01-01-1985	5467845467	35	offline	2020-12-03 21:19:44.204
834	fdvgh dfhbj	\N	\N	\N	\N	\N	\N	subhadarshi@softsuave.co	\N	7235251546	215	fdvgh	dfhbj	1983-11-26T14:06:29.921Z	\N	\N	online	\N
848	Sivaji P	\N	\N	\N	\N	\N	\N	sivaji@softsuave.com	\N	9618994958	243	Sivaji	P	1999-11-27T10:40:30.388Z	\N	\N	online	\N
873	\N	\N	\N	\N	chennai	\N	\N	\N	\N	6377889900	275	Arul	kumar	2020-11-02T09:42:00.000Z	6578901234	0	offline	2020-12-01 10:01:09.269
928	hth hxvb	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	7788994452	329	hth	hxvb	2004-12-23T07:25:24.522Z	\N	\N	online	\N
891	\N	\N	\N	\N	Chennai 	\N	\N	\N	\N	9423115555	292	C	S K	01-01-1985	8404648764	35	offline	2020-12-03 21:23:14.426
867	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	7564896412	269	Kelvin	C	1996-12-01T07:39:00.000Z	9547845214	24	online	2021-01-18 17:47:44.995
943	\N	\N	\N	\N	132,jhjhvuuhsd,cnjhuihsf	\N	\N	\N	\N	8754945148	344	abc	xyz	2018-01-02T11:21:00.000Z	8546354846	3	offline	2021-01-04 17:08:57.867
54	vijaya lakshmi 	rado labs	chennai	-	lake view estates	tamil nadu	600116	vijyalakshmi@gmail.com		9999999999	85	vijaya lakshmi				\N	online	2021-01-22 15:06:33.401
877	\N	\N	\N	\N	Fghu	\N	\N	\N	\N	7568456855	279	K	P	01-01-1985	5688598458	35	offline	2020-12-01 13:00:26.51
567	\N	\N	\N	\N		\N	\N	\N	\N	1231234167	424	qqqqasas	qqqasas	\N	1313142498	23	online	\N
952	Chakka 	\N	\N	\N	Kundrathur Main Road	\N	600116	\N		7894561239	353	Chakka				22	offline	2021-01-15 15:00:59.947
929	sdd bvv	\N	\N	\N	\N	\N	\N	test@apollo.com	\N	7896321452	330	sdd	bvv	1996-12-23T07:26:24.705Z	\N	\N	online	\N
672	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970000	450	firstName	lastName	DOB	alternateContact	21	online	\N
729	\N	landmark	India	\N	address	state	826004	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8752369140	35	gayatri	anand	16-06-1995	alternateContact	21	online	\N
680	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970231	465	firstName	lastName	DOB	alternateContact	21	online	\N
689	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970464	478	firstName	lastName	DOB	alternateContact	21	online	\N
697	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970486	497	firstName	lastName	DOB	alternateContact	21	online	\N
704	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9089765432	509	firstName	lastName	DOB	alternateContact	21	online	\N
722	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9845632172	28	firstName	lastName	DOB	alternateContact	21	online	\N
735	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560553	41	gayatri	anand	16-06-1995	alternateContact	21	online	\N
742	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560613	48	gayatri	anand	16-06-1995	alternateContact	21	online	\N
743	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560623	49	gayatri	anand	16-06-1995	alternateContact	21	online	\N
756	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8888888866	12	gayatri	anand	16-06-1995	alternateContact	21	online	\N
779	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999995	3	firstName	lastName	DOB	alternateContact	21	online	\N
716	\N	landmark	country	\N	address	state	826004	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999997	8	firstName	lastName	DOB	alternateContact	21	online	\N
944	\N	\N	\N	\N	asd,456	\N	\N	\N	\N	8956232154	345	jaya	prakash	2001-01-01T11:32:00.000Z	7845895645	20	online	2021-01-05 17:03:10.18
953	\N	\N	\N	\N	kundrathur Main Road	\N	600116	\N	\N	7418529637	354	Sasanka	chakka	01-01-1999		22	offline	2021-01-15 15:04:56.532
930	err nn	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	7456321895	331	err	nn	1993-12-23T08:07:36.921Z	\N	\N	online	\N
945	\N	\N	\N	\N	asd,456	\N	\N	\N	\N	8547965412	346	prakash	jaya	1998-01-06T11:37:00.000Z	7426685625	22	online	2021-01-05 17:29:36.367
954	\N	\N	\N	\N	Kundhrathur Main road	\N	600116	\N	\N	7418529639	355	Vijaya	Lakshmi	01-01-1999		22	offline	2021-01-15 19:28:35.417
715	\N	\N	\N	\N	\N	\N	\N	nirmala@gmail.com	\N	9999999993	7	\N	\N	\N	\N	\N	online	\N
674	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970011	453	firstName	lastName	DOB	alternateContact	21	online	\N
736	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560663	42	gayatri	anand	16-06-1995	alternateContact	21	online	\N
681	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970231	465	firstName	lastName	DOB	alternateContact	21	online	\N
690	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970444	481	firstName	lastName	DOB	alternateContact	21	online	\N
744	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7777766666	50	gayatri	anand	16-06-1995	alternateContact	21	online	\N
698	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970487	499	firstName	lastName	DOB	alternateContact	21	online	\N
705	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9089097890	511	firstName	lastName	DOB	alternateContact	21	online	\N
376	\N	\N	\N	\N	342,ffhhjjk	\N	\N	\N	\N	8870366137	397	John wick	Jnr	24-02-1981	9877655454	39	offline	2020-09-24 22:49:23.632
723	\N	landmark	country	\N	address	state	826004	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999002	29	firstName	lastName	DOB	alternateContact	21	online	\N
730	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874561230	36	gayatri	anand	16-06-1995	alternateContact	21	online	\N
578	\N	\N	\N	\N	2www	\N	\N	\N	\N	2222111212	426	Prabhas	das	\N	2222121212	22	online	\N
863	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	9550185643	265	sdfsdf	sdfds	2005-11-30T13:09:00.000Z	6547854124	15	online	\N
931	hb fgh	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	9988884512	332	hb	fgh	1998-12-23T08:21:43.613Z	\N	\N	online	\N
791	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999999	11	firstName	lastName	DOB	alternateContact	21	online	\N
793	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8594236789	12	firstName	lastName	DOB	alternateContact	21	online	\N
771	\N	landmark	country	\N	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999912	3	firstName	lastName	DOB	alternateContact	21	online	\N
751	\N	landmark	India	\N	address	state	826004	abcd@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999999	7	gayatri	A	16-06-1995	alternateContact	21	online	\N
710	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7984561300	2	firstName	lastName	DOB	alternateContact	21	online	\N
780	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999995	3	firstName	lastName	DOB	alternateContact	21	online	\N
717	\N	landmark	country	\N	address	state	826004	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999998	9	firstName	lastName	DOB	alternateContact	21	online	\N
675	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970031	457	firstName	lastName	DOB	alternateContact	21	online	\N
794	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8594236789	12	firstName	lastName	DOB	alternateContact	21	online	\N
682	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970231	465	firstName	lastName	DOB	alternateContact	21	online	\N
691	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970444	481	firstName	lastName	DOB	alternateContact	21	online	\N
699	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970487	499	firstName	lastName	DOB	alternateContact	21	online	\N
706	\N	landmark	country	\N	address	state	533274	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9089097811	512	firstName	lastName	DOB	alternateContact	21	online	\N
724	\N	landmark	India	\N	address	state	826004	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999005	30	gayatri	anand	16-06-1995	alternateContact	21	online	\N
731	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560321	37	gayatri	anand	16-06-1995	alternateContact	21	online	\N
737	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560773	43	gayatri	anand	16-06-1995	alternateContact	21	online	\N
757	\N	landmark	India	\N	address	state	826004	abcd@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9191919196	13	gayatri	A	16-06-1995	alternateContact	21	online	\N
758	\N	landmark	India	\N	address	state	826004	abcd@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9461325870	14	gayatri	A	16-06-1995	alternateContact	21	online	\N
800	\N	landmark	country	\N	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874563210	15	firstName	lastName	DOB	alternateContact	21	online	\N
2	Ashok Gajapathi Raj	Mysore Palace	India	Reg_2	Bangalore	Karnataka	530068	ashok@gmail.com	testImageUrl	9999999992	2	Ashok	Gajapathi Raj	26-10-1999	\N	\N	online	\N
711	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7984561300	2	firstName	lastName	DOB	alternateContact	21	online	\N
781	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999982	4	firstName	lastName	DOB	alternateContact	21	online	\N
772	\N	landmark	country	\N	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9856231470	4	firstName	lastName	DOB	alternateContact	21	online	\N
785	\N	landmark	country	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999988888	8	firstName	lastName	DOB	alternateContact	21	online	\N
8	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	8	Suresh Antharvedi	Suresh Antharvedi	26-08-1999	\N	\N	online	\N
803	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999966	17	firstName	lastName	DOB	alternateContact	21	online	2020-10-05 11:59:29.489
718	\N	landmark	country	\N	address	state	826004	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999900	10	firstName	lastName	DOB	alternateContact	21	online	\N
792	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999999	11	firstName	lastName	DOB	alternateContact	21	online	\N
835	khbtu uijhy7	\N	\N	\N	\N	\N	\N	subhadarshi@softsuave.com	\N	9865764653	217	khbtu	uijhy7	1993-11-26T16:05:09.126Z	\N	\N	online	\N
676	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970031	457	firstName	lastName	DOB	alternateContact	21	online	\N
683	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970235	469	firstName	lastName	DOB	alternateContact	21	online	\N
692	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970464	478	firstName	lastName	DOB	alternateContact	21	online	\N
700	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970488	502	firstName	lastName	DOB	alternateContact	21	online	\N
707	\N	landmark	country	\N	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7412365890	546	firstName	lastName	DOB	alternateContact	21	online	\N
725	\N	landmark	India	\N	address	state	826004	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999007	31	gayatri	anand	16-06-1995	alternateContact	21	online	\N
932	tyty lgg	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	7788899665	333	tyty	lgg	1993-12-23T09:11:12.424Z	\N	\N	online	\N
738	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560673	44	gayatri	anand	16-06-1995	alternateContact	21	online	\N
746	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999995	2	gayatri	anand	16-06-1995	alternateContact	21	online	\N
712	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7984561301	3	firstName	lastName	DOB	alternateContact	21	online	\N
764	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999992	4	firstName	lastName	DOB	alternateContact	21	online	\N
804	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999966	17	firstName	lastName	DOB	alternateContact	21	online	2020-10-05 11:59:29.489
786	\N	landmark	country	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999988888	8	firstName	lastName	DOB	alternateContact	21	online	\N
752	\N	landmark	India	\N	address	state	826004	abcd@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999900002	8	gayatri	A	16-06-1995	alternateContact	21	online	\N
767	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7896541230	7	firstName	lastName	DOB	alternateContact	21	online	\N
777	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999992	2	firstName	lastName	DOB	alternateContact	21	online	\N
797	\N	landmark	india	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9191919196	14	gayatri	anand	16-06-1995	alternateContact	21	online	\N
759	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	6302293359	15	gayatri	anand	16-06-1995	alternateContact	21	online	\N
770	\N	landmark	country	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9857461221	2	firstName	lastName	DOB	alternateContact	21	online	\N
719	\N	landmark	country	\N	address	state	826004	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999901	11	firstName	lastName	DOB	alternateContact	21	online	\N
677	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970221	462	firstName	lastName	DOB	alternateContact	21	online	\N
684	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970235	469	firstName	lastName	DOB	alternateContact	21	online	\N
693	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970474	486	firstName	lastName	DOB	alternateContact	21	online	\N
701	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970488	502	firstName	lastName	DOB	alternateContact	21	online	\N
726	\N	landmark	India	\N	address	state	826004	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8956321470	32	gayatri	anand	16-06-1995	alternateContact	21	online	\N
732	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560322	38	gayatri	anand	16-06-1995	alternateContact	21	online	\N
739	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560683	45	gayatri	anand	16-06-1995	alternateContact	21	online	\N
774	\N	landmark	country	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999996	7	firstName	lastName	DOB	alternateContact	21	online	\N
3	Shrushti Jayanth Deshmukh	Van Vihar National Park	India	Reg_3	Bhopal	Madhya Pradesh	462023	shrushti@gmail.com	testImageUrl	9999999993	3	Shrushti Jayanth	Deshmukh	26-10-1999	\N	\N	online	\N
747	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999992	3	gayatri	anand	16-06-1995	alternateContact	21	online	\N
773	anthervedi	landmark	country	-	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9632587411	6	firstName	lastName	DOB	alternateContact	21	offline	2020-10-30 11:50:48.998
823	Dom Nick	\N	\N	\N	\N	\N	\N	sekhar@softsuave.com	\N	9550184642	194	Dom	Nick	1996-08-31T15:09:00.000Z	\N	\N	online	\N
836	ghdgf jdj	\N	\N	\N	\N	\N	\N	ghtr@gmail.com	\N	8743673468	219	ghdgf	jdj	2003-11-26T16:27:28.454Z	\N	\N	online	\N
782	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999982	4	firstName	lastName	DOB	alternateContact	21	online	\N
720	\N	landmark	country	\N	address	state	826004	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999981	12	firstName	lastName	DOB	alternateContact	21	online	\N
795	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9543684236	13	firstName	lastName	DOB	alternateContact	21	online	\N
798	\N	landmark	india	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9191919196	14	gayatri	anand	16-06-1995	alternateContact	21	online	\N
768	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7896541255	8	firstName	lastName	DOB	alternateContact	21	online	\N
787	\N	landmark	country	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7777766666	9	firstName	lastName	DOB	alternateContact	21	online	\N
753	\N	landmark	India	\N	address	state	826004	abcd@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9634578524	9	gayatri	A	16-06-1995	alternateContact	21	online	\N
789	\N	landmark	country	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	6666688888	10	firstName	lastName	DOB	alternateContact	21	online	\N
760	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7979797920	16	gayatri	anand	16-06-1995	alternateContact	21	online	2020-10-05 11:56:59.989
801	\N	landmark	india	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999996	16	gayatri	anand	16-06-1995	alternateContact	21	online	2020-10-05 11:56:59.989
733	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560323	39	gayatri	anand	16-06-1995	alternateContact	21	online	\N
740	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874560693	46	gayatri	anand	16-06-1995	alternateContact	21	online	\N
778	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999992	2	firstName	lastName	DOB	alternateContact	21	online	\N
754	\N	landmark	India	\N	address	state	826004	abcd@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	1212121222	10	gayatri	A	16-06-1995	alternateContact	21	online	\N
713	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7984561301	3	firstName	lastName	DOB	alternateContact	21	online	\N
796	\N	landmark	country	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9543684236	13	firstName	lastName	DOB	alternateContact	21	online	\N
748	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999982	4	gayatri	anand	16-06-1995	alternateContact	21	online	\N
721	\N	landmark	country	\N	address	state	826004	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999971	13	firstName	lastName	DOB	alternateContact	21	online	\N
799	\N	landmark	country	\N	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9874563210	15	firstName	lastName	DOB	alternateContact	21	online	\N
678	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970221	462	firstName	lastName	DOB	alternateContact	21	online	\N
788	\N	landmark	country	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7777766666	9	firstName	lastName	DOB	alternateContact	21	online	\N
790	\N	landmark	country	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	6666688888	10	firstName	lastName	DOB	alternateContact	21	online	\N
685	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970235	469	firstName	lastName	DOB	alternateContact	21	online	\N
802	\N	landmark	india	\N	address	state	\N	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999996	16	gayatri	anand	16-06-1995	alternateContact	21	online	2020-10-05 11:56:59.989
694	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970475	489	firstName	lastName	DOB	alternateContact	21	online	\N
702	\N	landmark	country	\N	address	state	533274	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9098970988	505	firstName	lastName	DOB	alternateContact	21	online	\N
727	\N	landmark	India	\N	address	state	\N	gayatri@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8974561230	33	gayatri	anand	16-06-1995	alternateContact	21	online	\N
837	rthdf djddddddddddd	\N	\N	\N	\N	\N	\N	qgs@gmail.com	\N	8674373777	221	rthdf	djddddddddddd	1997-11-26T16:35:56.744Z	\N	\N	online	\N
761	nirmala S	landmark	India	\N	address	state	826004	nirmala@gmail.com	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU	9461325870	1	gayatri	A	dateOfBirth	alternateContact	21	online	2020-10-08 19:41:32.773
709	nirmala S	landmark	India	\N	address	state	533274	nirmala@gmail.com	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU	7984561299	1	firstName	lastName	dateOfBirth	alternateContact	21	online	2020-10-08 19:41:32.773
822	Dom Nick	\N	\N	\N	Chennai	\N	\N	sekhar@softsuave.com	\N	7569646045	192	Dom	Nick	1996-11-24T15:38:00.000Z	9550184642	24	offline	2020-11-24 16:25:27.328
838	bcb bbcx	\N	\N	\N	\N	\N	\N	abs@gmail.com	\N	8363422222	224	bcb	bbcx	1997-10-14T16:37:00.000Z	\N	\N	online	\N
933	hgh ss	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	7485964152	334	hgh	ss	1997-12-23T11:57:57.972Z	\N	\N	online	\N
864	\N	\N	\N	\N	chennai	\N	\N	\N	\N	8765432109	266	santhosh	devan	2020-11-04T13:12:00.000Z	8765849012	0	online	\N
934	jack jan	\N	\N	\N	porur	\N	\N	abc@gmail.com	\N	9685744152	335	jack	jan	2000-12-30T04:57:00.000Z	9685745263	20	online	\N
117	\N	HighSchool	India	\N	Ganti	Andhra Pradesh	533274	dharani@softsuave.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9652147787	152	Dharani	Antharvedi	26-10-1999	9398341783	21	offline	2021-01-06 23:23:39.358
745	nirmala S	landmark	India	\N	address	state	\N	nirmala@gmail.com	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU	9999999994	1	gayatri	anand	dateOfBirth	alternateContact	21	online	2020-10-08 19:41:32.773
708	nirmala S	landmark	India	\N	address	state	533274	nirmala@gmail.com	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU	7984561299	1	firstName	lastName	dateOfBirth	alternateContact	21	online	2020-10-08 19:41:32.773
1	nirmala S	landmark	India	Reg_1	address	state	12346	nirmala@gmail.com	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU	9999999991	1	Nirmala	Seetharaman	dateOfBirth	\N	\N	online	2020-10-08 19:41:32.773
820	\N	landmark	country	\N	address	state	560066	hgfthfgh@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999000	89	firstName	lastName	DOB	alternateContact	21	online	\N
476	Dom Nick	High school	India	\N	Chennai	Andhra Pradesh	533274	dilip@naidu.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7569646045	192	Dom	Nick	1996-11-24T15:38:00.000Z	9550184642	24	offline	2020-11-24 15:41:27.069
839	subha mishra	\N	\N	\N	\N	\N	\N	subhadarshi@softsuave.co	\N	8976634577	226	subha	mishra	2003-11-26T16:50:27.320Z	\N	\N	online	\N
935	j jhj	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	7785964152	336	j	jhj	1995-12-23T12:07:16.937Z	\N	\N	online	\N
821	\N	landmark	country	\N	address	state	560066	hgfthfgh@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999001	91	firstName	lastName	DOB	alternateContact	21	online	\N
849	\N	\N	\N	\N	Chennai	\N	\N	\N	\N	7569646047	245	John	K	1994-11-27T10:59:00.000Z	7854125478	26	offline	2020-11-27 11:13:29.803
824	\N	\N	\N	\N	hghgj	\N	\N	\N	\N	7569646046	196	Dom	K	1998-11-26T09:46:00.000Z	8745214587	22	offline	2020-11-26 10:52:06.221
840	subhaug mishrasgu	\N	\N	\N	\N	\N	\N	subhadarshi@softsuave.co	\N	8554784626	227	subhaug	mishrasgu	1990-11-26T17:07:14.646Z	\N	\N	online	\N
806	\N	\N	\N	\N	9791946880	\N	\N	\N	\N	9791946880	166	kani	kumar	1993-12-14T09:55:00.000Z	9791946881	26	offline	2020-10-12 12:28:51.555
805	\N	\N	\N	\N	fgk, kjkjlk jijihghjgggggggggggggggggghjbb 	\N	\N	\N	\N	9513471534	164	Sangeetha	Sathiyanarayanan	1984-03-04T05:35:00.000Z	1243565223	36	offline	2020-10-23 13:09:59.708
807	\N	\N	\N	\N	test	\N	\N	\N	\N	9513471536	168	Sangeetha	Balaji	1984-03-04T11:23:00.000Z	4425464653	36	offline	2020-10-20 11:43:19.725
36	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	160	yamini	Antharvedi	26-08-1999	\N	\N	offline	2020-11-27 14:53:20.223
809	\N	\N	\N	\N	1231, sdsd, 21	\N	\N	\N	\N	9513467234	171	Sangeetha	Balaji	1996-10-02T13:10:00.000Z	9365984755	24	offline	2020-11-02 08:02:20.894
853	Haha Gaha	\N	\N	\N	\N	\N	\N	Gahau@gmail.com	\N	6767976494	253	Haha	Gaha	1994-01-01	\N	\N	online	\N
841	anbu kumar	\N	\N	\N	\N	\N	\N	anb@gmail.com	\N	8764334356	229	anbu	kumar	1969-11-26T19:38:33.237Z	\N	\N	online	\N
31	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	78	Dharani	Dharani	26-08-1999	\N	\N	online	\N
808	TEST 3	landmark	INDIA	\N	address	KARNATAKA	\N	test3@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7878787870	78	test	3	1994-10-09	6567676767	21	online	\N
815	Dilip Naidu	ddd	ffff	-	ccc	eee	532242	gowthami@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9640564099	180	aaaa	bbbb	2017-10-03T07:57:00.000Z	9640564077	3	offline	2020-11-02 15:00:21.582
776	nirmala S	landmark	India	\N	address	state	560066	nirmala@gmail.com	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU	6201002989	1	firstName	lastName	dateOfBirth	alternateContact	21	online	2020-10-08 19:41:32.773
769	nirmala S	landmark	India	\N	address	state	\N	nirmala@gmail.com	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU	9857461220	1	firstName	lastName	dateOfBirth	alternateContact	21	online	2020-10-08 19:41:32.773
775	nirmala S	landmark	India	\N	address	state	560066	nirmala@gmail.com	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU	6201002989	1	firstName	lastName	dateOfBirth	alternateContact	21	online	2020-10-08 19:41:32.773
881	\N	\N	\N	\N	chennai	\N	\N	\N	\N	7892709911	282	srinivas	yadav	1996-12-03T06:44:32.730Z	7892709912	24	offline	2021-01-18 17:36:00.381
861	\N	\N	\N	\N	sdsdafsdf	\N	\N	\N	\N	7894561230	263	Kevin	O	1991-11-30T12:57:00.000Z	5784214789	29	online	\N
857	Ponni	Kundrathur	\N	\N	softsuave technologies			\N		7894561237	258	Ponni	pa		9876543219	0	offline	2021-01-22 12:54:43.109
825	D K	\N	\N	\N	\N	\N	\N	sekhar@softsuave.com	\N	9874512456	198	D	K	1997-11-26T11:43:07.791Z	\N	\N	online	\N
842	abc def	\N	\N	\N	\N	\N	\N	abc@gmail.com	\N	8732765832	231	abc	def	1998-11-27T05:26:49.017Z	\N	\N	online	\N
854	Haua Bshau	\N	\N	\N	\N	\N	\N	Gahau@gmail.com	\N	9464976464	254	Haua	Bshau	1994-01-20	\N	\N	online	\N
44	name	landmark	country	\N	address	state	12346	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	\N	173	Thanu	Thanu	26-08-1999	\N	\N	online	\N
810	\N	\N	\N	\N	dddd	\N	\N	\N	\N	9888888889	173	aaaa	bbbb	2017-10-04T05:05:00.000Z	9789098765	3	online	\N
811	\N	\N	\N	\N	dddd	\N	\N	\N	\N	9888888889	176	aaaa	bbbb	2017-10-04T05:05:00.000Z	9789098765	3	offline	2020-10-24 05:11:37.515
714	anthervedi	landmark	country	-	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999992	6	firstName	lastName	DOB	alternateContact	21	offline	2020-10-30 11:50:48.998
750	anthervedi	landmark	country	-	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7777766666	6	gayatri	anand	16-06-1995	alternateContact	21	offline	2020-10-30 11:50:48.998
766	anthervedi	landmark	country	-	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999933	6	firstName	lastName	DOB	alternateContact	21	offline	2020-10-30 11:50:48.998
858	\N	\N	\N	\N	ponni@test.dlp	\N	\N	\N	\N	7534216895	260	check	dlip	2020-11-11T13:51:00.000Z	9867534218	0	online	\N
936	\N	\N	\N	\N	chennai	\N	\N	\N	\N	7892709912	337	srinivas	yadav	1986-12-03T14:56:00.000Z	7892706911	34	offline	2020-12-24 12:09:37.301
826	A P	\N	\N	\N	\N	\N	\N	dff@gmail.com	\N	9874521452	200	A	P	1998-11-26T11:53:15.267Z	\N	\N	online	\N
843	gfd sa	\N	\N	\N	\N	\N	\N	gfd@gmail.com	\N	8732884326	233	gfd	sa	1998-11-17T05:28:00.000Z	\N	\N	online	\N
813	Shruti A	ABC Colony	India	\N	abc Street	Karnataka	\N	shruti@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	7896523014	79	shruti	Aggarwal	2001-09-12	7896523014	19	online	2020-10-27 11:12:36.789
814	\N	\N	\N	\N		\N	\N	\N	\N	9999999998	80	aaaa	sss	2020-08-21T23:15:30.000Z		\N	online	\N
48	name	landmark	country	\N	address	state	12346	12345	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	8524698522	80	firstName	lastName	DOB	alternateContact	21	online	\N
851	xvcxv xvcxv	\N	\N	\N	\N	\N	\N	sekhar1@softsuave.com	\N	9458745654	249	xvcxv	xvcxv	2020-11-27T11:28:01.957Z	\N	\N	online	\N
812	\N	\N	\N	\N	dddd	\N	\N	\N	\N	9989074099	177	aaaa	bbbb	2017-10-12T09:41:00.000Z	9989074076	3	offline	2020-10-24 11:49:15.654
859	K G F	\N	\N	\N	\N	\N	\N	hsdfkdgh@gmail.com	\N	6324578451	261	K	G F	1995-11-30T08:05:00.000Z	\N	\N	online	\N
855	Haua Bshau	\N	\N	\N	\N	\N	\N	Gahau@gmail.com	\N	9464976464	254	Haua	Bshau	1994-01-20	\N	\N	online	\N
6	anthervedi	landmark	country	-	address	state	560066	nirmala@gmail.com	https://homepages.cae.wisc.edu/~ece533/images/airplane.png	9999999994	6	Divya Gopi	Divya Gopi	26-08-1999	\N	\N	offline	2020-10-30 11:50:48.998
844	K L M	\N	\N	\N	\N	\N	\N	sdfsdf@gmail.com	\N	7854124789	235	K	L M	2011-11-27T10:18:59.038Z	\N	\N	online	\N
827	Chethan pujar	\N	\N	\N	chennai	\N	\N	subhadarshi@softsuave.co	\N	7892709915	202	Chethan	pujar	1998-12-01T12:38:32.319Z	9164079736	22	offline	2021-01-16 11:04:45.198
852	zxzv xvxcv	\N	\N	\N	\N	\N	\N	sekhar11@softsuave.com	\N	9875412447	251	zxzv	xvxcv	2020-11-27T11:28:48.723Z	\N	\N	online	\N
860	\N	\N	\N	\N	csfsf	\N	\N	\N	\N	9623456256	262	Dom	zsc	2007-11-30T08:10:00.000Z	5465466465	13	online	2020-11-30 08:43:20.625
866	D L	\N	\N	\N	\N	\N	\N	sfsdf@gmail.com	\N	9654785412	268	D	L	2007-11-30T15:03:37.779Z	\N	\N	online	\N
5	Gowthami	bcd	india	-	address	karnataka	560066	divya@gmail.com	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU	1234567890	5	Jack	Reacher	2020-08-02T23:15:30.000Z	\N	\N	online	2021-01-11 14:05:57.259
\.


--
-- Data for Name: patient_report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_report (id, patient_id, appointment_id, file_name, file_type, report_url, comments, report_date) FROM stdin;
3	258	\N	appointment.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/appointment.jpg	Lab report	2021-01-05
4	85	\N	Screenshot 2021-01-05 at 4.43.23 PM.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%202021-01-05%20at%204.43.23%20PM.png	egfjdgkur	2021-01-07
5	258	\N	Group 514.svg	image/svg+xml	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Group%20514.svg	\N	2021-01-07
6	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-08
7	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-08
8	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-08
9	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-08
10	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-08
11	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-08
12	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-08
13	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-08
14	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-08
15	85	\N	1596645809338.JPEG	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/1596645809338.JPEG	jkxashdis	2021-01-08
16	85	\N	about_icon.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/about_icon.jpg	cvxv	2021-01-08
17	85	\N	60.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/60.png	zxcfzxf	2021-01-08
18	269	\N	newlogo_icon.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/newlogo_icon.png	report1	2021-01-08
19	269	\N	lotus.pdf	application/pdf	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/lotus.pdf	\N	2021-01-08
20	269	\N	newlogo_icon.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/newlogo_icon.png	report2	2021-01-08
21	560	\N	Screenshot_1609152663.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot_1609152663.png	\N	2021-01-08
22	560	\N	Screenshot_1609152663.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot_1609152663.png	\N	2021-01-08
23	560	\N	Screenshot 2020-12-28 at 3.41.52 PM.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%202020-12-28%20at%203.41.52%20PM.png	\N	2021-01-08
24	560	\N	Screenshot 2021-01-05 at 4.43.23 PM.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%202021-01-05%20at%204.43.23%20PM.png	\N	2021-01-08
25	85	\N	newlogo_icon.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/newlogo_icon.png	\N	2021-01-08
26	85	\N	Dec14-19.PNG	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Dec14-19.PNG	\N	2021-01-09
27	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-09
28	85	\N	Screenshot (1).png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot%20%281%29.png	\N	2021-01-09
29	258	\N	vivant_Utiliko Test_project_The Kartik Shetty_project attachments_1609398540485-Vendor Details.pdf	application/pdf	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/vivant_Utiliko%20Test_project_The%20Kartik%20Shetty_project%20attachments_1609398540485-Vendor%20Details.pdf	testing report	2021-01-09
30	85	\N	Employee Handbook updateDD.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Employee%20Handbook%20updateDD.docx	\N	2021-01-09
31	85	\N	water_lotus.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/water_lotus.jpg	\N	2021-01-09
32	85	\N	lotus.pdf	application/pdf	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/lotus.pdf	\N	2021-01-09
33	85	\N	water_lotus.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/water_lotus.jpg	\N	2021-01-09
34	85	\N	water_lotus.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/water_lotus.jpg	\N	2021-01-09
35	85	\N	water_lotus.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/water_lotus.jpg	\N	2021-01-09
36	85	\N	water_lotus.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/water_lotus.jpg	\N	2021-01-09
37	85	\N	lotus.pdf	application/pdf	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/lotus.pdf	\N	2021-01-09
38	85	\N	water_lotus.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/water_lotus.jpg	\N	2021-01-09
39	85	\N	water_lotus.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/water_lotus.jpg	\N	2021-01-09
40	85	\N	lotus.pdf	application/pdf	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/lotus.pdf	\N	2021-01-09
41	85	\N	water_lotus.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/water_lotus.jpg	\N	2021-01-09
42	85	\N	Employee Handbook updateDD.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Employee%20Handbook%20updateDD.docx	\N	2021-01-09
43	85	\N	Employee Handbook updateDD.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Employee%20Handbook%20updateDD.docx	\N	2021-01-09
44	85	\N	water_lotus.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/water_lotus.jpg	comment-1 on lotus.png	2021-01-09
45	85	\N	newlogo_icon.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/newlogo_icon.png	logo	2021-01-13
46	85	\N	Employee Handbook updateDD.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Employee%20Handbook%20updateDD.docx	sample	2021-01-13
47	85	\N	newlogo_icon.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/newlogo_icon.png	sample file	2021-01-13
48	85	\N	Employee Handbook updateDD.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Employee%20Handbook%20updateDD.docx	sample docx	2021-01-13
49	85	\N	lotus.pdf	application/pdf	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/lotus.pdf	sample pdf	2021-01-13
50	85	\N	newlogo_icon.png	image/png	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/newlogo_icon.png	new sample	2021-01-13
51	355	\N	Screenshot_2021-01-12-19-42-47-24_fe17db75bd4bba1afb1fb660cf625e79.jpg	image/jpeg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/testreport/Screenshot_2021-01-12-19-42-47-24_fe17db75bd4bba1afb1fb660cf625e79.jpg	Report 1	2021-01-15
\.


--
-- Data for Name: payment_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_details (id, appointment_id, order_id, receipt_id, amount, payment_status) FROM stdin;
52	113	\N	\N	\N	notPaid
53	114	\N	\N	\N	notPaid
54	115	\N	\N	\N	notPaid
55	116	\N	\N	\N	notPaid
56	117	\N	\N	\N	notPaid
57	118	\N	\N	\N	notPaid
58	119	\N	\N	\N	notPaid
59	120	\N	\N	\N	notPaid
60	121	\N	\N	\N	notPaid
61	122	\N	\N	\N	notPaid
62	123	\N	\N	\N	notPaid
63	124	\N	\N	\N	notPaid
64	125	\N	\N	\N	notPaid
65	126	\N	\N	\N	notPaid
66	127	\N	\N	\N	notPaid
67	128	\N	\N	\N	notPaid
68	129	\N	\N	\N	notPaid
69	130	\N	\N	\N	notPaid
70	131	\N	\N	\N	notPaid
71	132	\N	\N	\N	notPaid
72	133	\N	\N	\N	notPaid
73	134	\N	\N	\N	notPaid
74	135	\N	\N	\N	notPaid
75	136	\N	\N	\N	notPaid
76	137	\N	\N	\N	notPaid
77	138	\N	\N	\N	notPaid
78	139	\N	\N	\N	notPaid
79	140	\N	\N	\N	notPaid
80	141	\N	\N	\N	notPaid
81	142	\N	\N	\N	notPaid
82	143	\N	\N	\N	notPaid
83	144	\N	\N	\N	notPaid
84	145	\N	\N	\N	notPaid
85	146	\N	\N	\N	notPaid
86	147	\N	\N	\N	notPaid
87	148	\N	\N	\N	notPaid
88	149	\N	\N	\N	notPaid
89	150	\N	\N	\N	notPaid
90	151	\N	\N	\N	notPaid
91	152	\N	\N	\N	notPaid
92	153	\N	\N	\N	notPaid
93	154	\N	\N	\N	notPaid
94	155	\N	\N	\N	notPaid
95	156	\N	\N	\N	notPaid
96	157	\N	\N	\N	notPaid
97	158	\N	\N	\N	notPaid
98	159	\N	\N	\N	notPaid
99	160	\N	\N	\N	notPaid
100	161	\N	\N	\N	notPaid
101	162	\N	\N	\N	notPaid
102	163	\N	\N	\N	notPaid
103	164	\N	\N	\N	notPaid
104	165	\N	\N	\N	notPaid
105	166	\N	\N	\N	notPaid
106	167	\N	\N	\N	notPaid
107	168	\N	\N	\N	notPaid
108	169	\N	\N	\N	notPaid
109	170	\N	\N	\N	notPaid
110	171	\N	\N	\N	notPaid
111	172	\N	\N	\N	notPaid
112	173	\N	\N	\N	notPaid
113	174	\N	\N	\N	notPaid
114	175	\N	\N	\N	notPaid
115	176	\N	\N	\N	notPaid
116	177	\N	\N	\N	notPaid
117	178	\N	\N	\N	notPaid
118	179	\N	\N	\N	notPaid
119	180	\N	\N	\N	notPaid
120	181	\N	\N	\N	notPaid
121	182	\N	\N	\N	notPaid
122	183	\N	\N	\N	notPaid
123	184	\N	\N	\N	notPaid
124	185	\N	\N	\N	notPaid
125	186	\N	\N	\N	notPaid
126	187	\N	\N	\N	notPaid
127	188	\N	\N	\N	notPaid
128	189	\N	\N	\N	notPaid
129	190	\N	\N	\N	notPaid
130	191	\N	\N	\N	notPaid
131	192	\N	\N	\N	notPaid
132	193	\N	\N	\N	notPaid
133	194	\N	\N	\N	notPaid
134	195	\N	\N	\N	notPaid
135	196	\N	\N	\N	notPaid
136	197	\N	\N	\N	notPaid
137	198	\N	\N	\N	notPaid
138	199	\N	\N	\N	notPaid
139	200	\N	\N	\N	notPaid
140	201	\N	\N	\N	notPaid
141	202	\N	\N	\N	notPaid
142	203	\N	\N	\N	notPaid
143	204	\N	\N	\N	notPaid
144	205	\N	\N	\N	notPaid
145	206	\N	\N	\N	notPaid
146	207	\N	\N	\N	notPaid
147	208	\N	\N	\N	notPaid
148	209	\N	\N	\N	notPaid
149	210	\N	\N	\N	notPaid
150	211	\N	\N	\N	notPaid
151	212	\N	\N	\N	notPaid
152	213	\N	\N	\N	notPaid
153	214	\N	\N	\N	notPaid
154	215	\N	\N	\N	notPaid
155	216	\N	\N	\N	notPaid
156	217	\N	\N	\N	notPaid
157	218	\N	\N	\N	notPaid
158	219	\N	\N	\N	notPaid
159	220	\N	\N	\N	notPaid
160	221	\N	\N	\N	notPaid
161	222	\N	\N	\N	notPaid
162	223	\N	\N	\N	notPaid
163	224	\N	\N	\N	notPaid
164	225	\N	\N	\N	notPaid
165	226	\N	\N	\N	notPaid
166	227	\N	\N	\N	notPaid
167	228	\N	\N	\N	notPaid
168	229	\N	\N	\N	notPaid
169	230	\N	\N	\N	notPaid
170	231	\N	\N	\N	notPaid
171	232	\N	\N	\N	notPaid
172	233	\N	\N	\N	notPaid
173	234	\N	\N	\N	notPaid
174	235	\N	\N	\N	notPaid
175	236	\N	\N	\N	notPaid
177	238	\N	\N	\N	notPaid
178	239	\N	\N	\N	notPaid
179	240	\N	\N	\N	notPaid
180	241	\N	\N	\N	notPaid
181	242	\N	\N	\N	notPaid
182	243	\N	\N	\N	notPaid
183	244	\N	\N	\N	notPaid
184	245	\N	\N	\N	notPaid
185	246	\N	\N	\N	notPaid
186	247	\N	\N	\N	notPaid
187	248	\N	\N	\N	notPaid
188	249	\N	\N	\N	notPaid
189	250	\N	\N	\N	notPaid
190	251	\N	\N	\N	notPaid
191	252	\N	\N	\N	notPaid
192	253	\N	\N	\N	notPaid
193	254	\N	\N	\N	notPaid
194	255	\N	\N	\N	notPaid
195	256	\N	\N	\N	notPaid
196	257	\N	\N	\N	notPaid
197	258	\N	\N	\N	notPaid
198	259	\N	\N	\N	notPaid
199	260	\N	\N	\N	notPaid
200	261	\N	\N	\N	notPaid
201	262	\N	\N	\N	notPaid
202	263	\N	\N	\N	notPaid
203	264	\N	\N	\N	notPaid
204	265	\N	\N	\N	notPaid
205	266	\N	\N	\N	notPaid
206	267	\N	\N	\N	notPaid
207	268	\N	\N	\N	notPaid
208	269	\N	\N	\N	notPaid
209	270	\N	\N	\N	notPaid
210	271	\N	\N	\N	notPaid
211	272	\N	\N	\N	notPaid
212	273	\N	\N	\N	notPaid
213	274	\N	\N	\N	notPaid
214	275	\N	\N	\N	notPaid
215	276	\N	\N	\N	notPaid
216	277	\N	\N	\N	notPaid
217	278	\N	\N	\N	notPaid
218	279	\N	\N	\N	notPaid
219	280	\N	\N	\N	notPaid
220	281	\N	\N	\N	notPaid
221	282	\N	\N	\N	notPaid
222	283	\N	\N	\N	notPaid
223	284	\N	\N	\N	notPaid
224	285	\N	\N	\N	notPaid
225	286	\N	\N	\N	notPaid
226	287	\N	\N	\N	notPaid
227	288	\N	\N	\N	notPaid
228	289	\N	\N	\N	notPaid
229	290	\N	\N	\N	notPaid
230	291	\N	\N	\N	notPaid
231	292	\N	\N	\N	notPaid
232	293	\N	\N	\N	notPaid
233	294	\N	\N	\N	notPaid
234	295	\N	\N	\N	notPaid
235	296	\N	\N	\N	notPaid
236	297	\N	\N	\N	notPaid
237	298	\N	\N	\N	notPaid
238	299	\N	\N	\N	notPaid
239	300	\N	\N	\N	notPaid
240	301	\N	\N	\N	notPaid
241	302	\N	\N	\N	notPaid
242	303	\N	\N	\N	notPaid
243	304	\N	\N	\N	notPaid
244	305	\N	\N	\N	notPaid
245	306	\N	\N	\N	notPaid
246	307	\N	\N	\N	notPaid
247	308	\N	\N	\N	notPaid
248	309	\N	\N	\N	notPaid
249	310	\N	\N	\N	notPaid
250	311	\N	\N	\N	notPaid
251	312	\N	\N	\N	notPaid
252	313	\N	\N	\N	notPaid
253	314	\N	\N	\N	notPaid
254	315	\N	\N	\N	notPaid
255	316	\N	\N	\N	notPaid
256	317	\N	\N	\N	notPaid
257	318	\N	\N	\N	notPaid
258	319	\N	\N	\N	notPaid
259	320	\N	\N	\N	notPaid
260	321	\N	\N	\N	notPaid
261	322	\N	\N	\N	notPaid
262	323	\N	\N	\N	notPaid
263	324	\N	\N	\N	notPaid
264	325	\N	\N	\N	notPaid
265	326	\N	\N	\N	notPaid
266	327	\N	\N	\N	notPaid
267	328	\N	\N	\N	notPaid
268	329	\N	\N	\N	notPaid
269	330	\N	\N	\N	notPaid
270	331	\N	\N	\N	notPaid
271	332	\N	\N	\N	notPaid
272	333	\N	\N	\N	notPaid
273	334	\N	\N	\N	notPaid
274	335	\N	\N	\N	notPaid
275	336	\N	\N	\N	notPaid
276	337	\N	\N	\N	notPaid
277	338	\N	\N	\N	notPaid
278	339	\N	\N	\N	notPaid
279	340	\N	\N	\N	notPaid
280	341	\N	\N	\N	notPaid
281	342	\N	\N	\N	notPaid
282	343	\N	\N	\N	notPaid
283	344	\N	\N	\N	notPaid
284	345	\N	\N	\N	notPaid
285	346	\N	\N	\N	notPaid
286	347	\N	\N	\N	notPaid
287	348	\N	\N	\N	notPaid
288	349	\N	\N	\N	notPaid
289	350	\N	\N	\N	notPaid
290	351	\N	\N	\N	notPaid
291	352	\N	\N	\N	notPaid
292	353	\N	\N	\N	notPaid
293	354	\N	\N	\N	notPaid
294	355	\N	\N	\N	notPaid
295	356	\N	\N	\N	notPaid
296	357	\N	\N	\N	notPaid
297	358	\N	\N	\N	notPaid
298	359	\N	\N	\N	notPaid
299	360	\N	\N	\N	notPaid
300	361	\N	\N	\N	notPaid
301	362	\N	\N	\N	notPaid
302	363	\N	\N	\N	notPaid
303	364	\N	\N	\N	notPaid
304	365	\N	\N	\N	notPaid
305	366	\N	\N	\N	notPaid
306	367	\N	\N	\N	notPaid
307	368	\N	\N	\N	notPaid
308	369	\N	\N	\N	notPaid
309	370	\N	\N	\N	notPaid
310	371	\N	\N	\N	notPaid
311	372	\N	\N	\N	notPaid
312	373	\N	\N	\N	notPaid
313	374	\N	\N	\N	notPaid
314	375	\N	\N	\N	notPaid
315	376	\N	\N	\N	notPaid
316	377	\N	\N	\N	notPaid
317	378	\N	\N	\N	notPaid
318	379	\N	\N	\N	notPaid
319	380	\N	\N	\N	notPaid
320	381	\N	\N	\N	notPaid
321	382	\N	\N	\N	notPaid
322	383	\N	\N	\N	notPaid
323	384	\N	\N	\N	notPaid
324	385	\N	\N	\N	notPaid
325	386	\N	\N	\N	notPaid
326	387	\N	\N	\N	notPaid
327	388	\N	\N	\N	notPaid
328	389	\N	\N	\N	notPaid
329	390	\N	\N	\N	notPaid
330	391	\N	\N	\N	notPaid
331	392	\N	\N	\N	notPaid
332	393	\N	\N	\N	notPaid
333	394	\N	\N	\N	notPaid
334	395	\N	\N	\N	notPaid
335	396	\N	\N	\N	notPaid
336	397	\N	\N	\N	notPaid
337	398	\N	\N	\N	notPaid
338	399	\N	\N	\N	notPaid
339	400	\N	\N	\N	notPaid
340	401	\N	\N	\N	notPaid
341	402	\N	\N	\N	notPaid
342	403	\N	\N	\N	notPaid
343	404	\N	\N	\N	notPaid
344	405	\N	\N	\N	notPaid
345	406	\N	\N	\N	notPaid
346	407	\N	\N	\N	notPaid
347	408	\N	\N	\N	notPaid
348	409	\N	\N	\N	notPaid
349	410	\N	\N	\N	notPaid
350	411	\N	\N	\N	notPaid
351	412	\N	\N	\N	notPaid
352	413	\N	\N	\N	notPaid
353	414	\N	\N	\N	notPaid
354	415	\N	\N	\N	notPaid
355	416	\N	\N	\N	notPaid
356	417	\N	\N	\N	notPaid
357	418	\N	\N	\N	notPaid
358	419	\N	\N	\N	notPaid
359	420	\N	\N	\N	notPaid
360	421	\N	\N	\N	notPaid
361	422	\N	\N	\N	notPaid
362	423	\N	\N	\N	notPaid
363	424	\N	\N	\N	notPaid
364	425	\N	\N	\N	notPaid
365	426	\N	\N	\N	notPaid
366	427	\N	\N	\N	notPaid
367	428	\N	\N	\N	notPaid
368	429	\N	\N	\N	notPaid
369	430	\N	\N	\N	notPaid
370	431	\N	\N	\N	notPaid
371	432	\N	\N	\N	notPaid
372	433	\N	\N	\N	notPaid
373	434	\N	\N	\N	notPaid
374	435	\N	\N	\N	notPaid
375	436	\N	\N	\N	notPaid
376	437	\N	\N	\N	notPaid
377	438	\N	\N	\N	notPaid
378	439	\N	\N	\N	notPaid
379	440	\N	\N	\N	notPaid
380	441	\N	\N	\N	notPaid
381	442	\N	\N	\N	notPaid
382	443	\N	\N	\N	notPaid
383	444	\N	\N	\N	notPaid
384	445	\N	\N	\N	notPaid
385	446	\N	\N	\N	notPaid
386	447	\N	\N	\N	notPaid
387	448	\N	\N	\N	notPaid
388	449	\N	\N	\N	notPaid
389	450	\N	\N	\N	notPaid
390	451	\N	\N	\N	notPaid
391	452	\N	\N	\N	notPaid
392	453	\N	\N	\N	notPaid
393	454	\N	\N	\N	notPaid
394	455	\N	\N	\N	notPaid
395	456	\N	\N	\N	notPaid
396	457	\N	\N	\N	notPaid
397	458	\N	\N	\N	notPaid
398	459	\N	\N	\N	notPaid
399	460	\N	\N	\N	notPaid
400	461	\N	\N	\N	notPaid
401	462	\N	\N	\N	notPaid
402	463	\N	\N	\N	notPaid
403	464	\N	\N	\N	notPaid
404	465	\N	\N	\N	notPaid
405	466	\N	\N	\N	notPaid
406	467	\N	\N	\N	notPaid
407	468	\N	\N	\N	notPaid
408	469	\N	\N	\N	notPaid
409	470	\N	\N	\N	notPaid
410	471	\N	\N	\N	notPaid
411	472	\N	\N	\N	notPaid
412	473	\N	\N	\N	notPaid
413	474	\N	\N	\N	notPaid
414	475	\N	\N	\N	notPaid
415	476	\N	\N	\N	notPaid
416	477	\N	\N	\N	notPaid
417	478	\N	\N	\N	notPaid
418	479	\N	\N	\N	notPaid
419	480	\N	\N	\N	notPaid
420	481	\N	\N	\N	notPaid
421	482	\N	\N	\N	notPaid
422	483	\N	\N	\N	notPaid
423	484	\N	\N	\N	notPaid
424	485	\N	\N	\N	notPaid
425	486	\N	\N	\N	notPaid
426	487	\N	\N	\N	notPaid
427	488	\N	\N	\N	notPaid
428	489	\N	\N	\N	notPaid
429	490	\N	\N	\N	notPaid
430	491	\N	\N	\N	notPaid
431	492	\N	\N	\N	notPaid
432	493	\N	\N	\N	notPaid
433	494	\N	\N	\N	notPaid
434	495	\N	\N	\N	notPaid
435	496	\N	\N	\N	notPaid
436	497	\N	\N	\N	notPaid
437	498	\N	\N	\N	notPaid
438	499	\N	\N	\N	notPaid
439	500	\N	\N	\N	notPaid
440	501	\N	\N	\N	notPaid
441	502	\N	\N	\N	notPaid
442	503	\N	\N	\N	notPaid
443	504	\N	\N	\N	notPaid
444	505	\N	\N	\N	notPaid
445	506	\N	\N	\N	notPaid
446	507	\N	\N	\N	notPaid
447	508	\N	\N	\N	notPaid
448	509	\N	\N	\N	notPaid
449	510	\N	\N	\N	notPaid
450	511	\N	\N	\N	notPaid
451	512	\N	\N	\N	notPaid
452	513	\N	\N	\N	notPaid
453	514	\N	\N	\N	notPaid
454	515	\N	\N	\N	notPaid
455	516	\N	\N	\N	notPaid
456	517	\N	\N	\N	notPaid
457	518	\N	\N	\N	notPaid
458	519	\N	\N	\N	notPaid
459	520	\N	\N	\N	notPaid
460	521	\N	\N	\N	notPaid
461	522	\N	\N	\N	notPaid
462	523	\N	\N	\N	notPaid
463	524	\N	\N	\N	notPaid
464	525	\N	\N	\N	notPaid
465	526	\N	\N	\N	notPaid
466	527	\N	\N	\N	notPaid
467	528	\N	\N	\N	notPaid
468	529	\N	\N	\N	notPaid
469	530	\N	\N	\N	notPaid
470	531	\N	\N	\N	notPaid
471	532	\N	\N	\N	notPaid
472	533	\N	\N	\N	notPaid
473	534	\N	\N	\N	notPaid
474	535	\N	\N	\N	notPaid
475	536	\N	\N	\N	notPaid
476	537	\N	\N	\N	notPaid
477	538	\N	\N	\N	notPaid
478	539	\N	\N	\N	notPaid
479	540	\N	\N	\N	notPaid
480	541	\N	\N	\N	notPaid
481	542	\N	\N	\N	notPaid
482	543	\N	\N	\N	notPaid
483	544	\N	\N	\N	notPaid
484	545	\N	\N	\N	notPaid
485	546	\N	\N	\N	notPaid
486	547	\N	\N	\N	notPaid
487	548	\N	\N	\N	notPaid
488	549	\N	\N	\N	notPaid
489	550	\N	\N	\N	notPaid
490	551	\N	\N	\N	notPaid
491	552	\N	\N	\N	notPaid
492	553	\N	\N	\N	notPaid
493	554	\N	\N	\N	notPaid
494	555	\N	\N	\N	notPaid
495	556	\N	\N	\N	notPaid
496	557	\N	\N	\N	notPaid
497	558	\N	\N	\N	notPaid
498	559	\N	\N	\N	notPaid
499	560	\N	\N	\N	notPaid
500	562	\N	\N	\N	notPaid
501	563	\N	\N	\N	notPaid
502	564	\N	\N	\N	notPaid
503	565	\N	\N	\N	notPaid
504	566	\N	\N	\N	notPaid
505	567	\N	\N	\N	notPaid
506	568	\N	\N	\N	notPaid
507	569	\N	\N	\N	notPaid
508	570	\N	\N	\N	notPaid
509	571	\N	\N	\N	notPaid
510	572	\N	\N	\N	notPaid
511	573	\N	\N	\N	notPaid
512	574	\N	\N	\N	notPaid
513	575	\N	\N	\N	notPaid
514	576	\N	\N	\N	notPaid
515	577	\N	\N	\N	notPaid
516	578	\N	\N	\N	notPaid
517	579	\N	\N	\N	notPaid
518	580	\N	\N	\N	notPaid
519	581	\N	\N	\N	notPaid
520	582	\N	\N	\N	notPaid
521	583	\N	\N	\N	notPaid
522	584	\N	\N	\N	notPaid
523	585	\N	\N	\N	notPaid
524	586	\N	\N	\N	notPaid
525	587	\N	\N	\N	notPaid
526	588	\N	\N	\N	notPaid
527	589	\N	\N	\N	notPaid
528	590	\N	\N	\N	notPaid
529	591	\N	\N	\N	notPaid
530	592	\N	\N	\N	notPaid
531	593	\N	\N	\N	notPaid
532	594	\N	\N	\N	notPaid
533	595	\N	\N	\N	notPaid
534	596	\N	\N	\N	notPaid
535	597	\N	\N	\N	notPaid
536	598	\N	\N	\N	notPaid
537	599	\N	\N	\N	notPaid
538	600	\N	\N	\N	notPaid
539	601	\N	\N	\N	notPaid
540	602	\N	\N	\N	notPaid
541	603	\N	\N	\N	notPaid
542	604	\N	\N	\N	notPaid
543	605	\N	\N	\N	notPaid
544	606	\N	\N	\N	notPaid
545	607	\N	\N	\N	notPaid
546	608	\N	\N	\N	notPaid
547	609	\N	\N	\N	notPaid
548	610	\N	\N	\N	notPaid
549	611	\N	\N	\N	notPaid
550	612	\N	\N	\N	notPaid
551	613	\N	\N	\N	notPaid
552	614	\N	\N	\N	notPaid
553	615	\N	\N	\N	notPaid
554	616	\N	\N	\N	notPaid
555	617	\N	\N	\N	notPaid
556	618	\N	\N	\N	notPaid
557	619	\N	\N	\N	notPaid
558	620	\N	\N	\N	notPaid
559	621	\N	\N	\N	notPaid
560	622	\N	\N	\N	notPaid
561	623	\N	\N	\N	notPaid
562	624	\N	\N	\N	notPaid
563	625	\N	\N	\N	notPaid
564	626	\N	\N	\N	notPaid
565	627	\N	\N	\N	notPaid
566	628	\N	\N	\N	notPaid
567	629	\N	\N	\N	notPaid
568	630	\N	\N	\N	notPaid
569	631	\N	\N	\N	notPaid
570	632	\N	\N	\N	notPaid
571	633	\N	\N	\N	notPaid
572	634	\N	\N	\N	notPaid
573	635	\N	\N	\N	notPaid
574	636	\N	\N	\N	notPaid
575	637	\N	\N	\N	notPaid
576	638	\N	\N	\N	notPaid
577	639	\N	\N	\N	notPaid
578	640	\N	\N	\N	notPaid
579	641	\N	\N	\N	notPaid
580	642	\N	\N	\N	notPaid
581	643	\N	\N	\N	notPaid
582	644	\N	\N	\N	notPaid
583	645	\N	\N	\N	notPaid
584	646	\N	\N	\N	notPaid
585	647	\N	\N	\N	notPaid
586	648	\N	\N	\N	notPaid
587	649	\N	\N	\N	notPaid
588	650	\N	\N	\N	notPaid
589	651	\N	\N	\N	notPaid
590	652	\N	\N	\N	notPaid
591	653	\N	\N	\N	notPaid
592	654	\N	\N	\N	notPaid
593	655	\N	\N	\N	notPaid
594	656	\N	\N	\N	notPaid
595	657	\N	\N	\N	notPaid
596	658	\N	\N	\N	notPaid
597	659	\N	\N	\N	notPaid
598	660	\N	\N	\N	notPaid
599	661	\N	\N	\N	notPaid
600	662	\N	\N	\N	notPaid
601	663	\N	\N	\N	notPaid
602	664	\N	\N	\N	notPaid
603	665	\N	\N	\N	notPaid
604	666	\N	\N	\N	notPaid
605	667	\N	\N	\N	notPaid
606	668	\N	\N	\N	notPaid
607	669	\N	\N	\N	notPaid
608	670	\N	\N	\N	notPaid
609	671	\N	\N	\N	notPaid
610	672	\N	\N	\N	notPaid
611	673	\N	\N	\N	notPaid
612	674	\N	\N	\N	notPaid
613	675	\N	\N	\N	notPaid
614	676	\N	\N	\N	notPaid
615	677	\N	\N	\N	notPaid
616	678	\N	\N	\N	notPaid
617	679	\N	\N	\N	notPaid
618	680	\N	\N	\N	notPaid
619	681	\N	\N	\N	notPaid
620	682	\N	\N	\N	notPaid
621	683	\N	\N	\N	notPaid
622	684	\N	\N	\N	notPaid
623	685	\N	\N	\N	notPaid
624	686	\N	\N	\N	notPaid
625	687	\N	\N	\N	notPaid
626	688	\N	\N	\N	notPaid
627	689	\N	\N	\N	notPaid
628	690	\N	\N	\N	notPaid
629	691	\N	\N	\N	notPaid
630	692	\N	\N	\N	notPaid
631	693	\N	\N	\N	notPaid
632	694	\N	\N	\N	notPaid
633	695	\N	\N	\N	notPaid
634	696	\N	\N	\N	notPaid
635	697	\N	\N	\N	notPaid
636	698	\N	\N	\N	notPaid
637	699	\N	\N	\N	notPaid
638	700	\N	\N	\N	notPaid
639	701	\N	\N	\N	notPaid
640	702	\N	\N	\N	notPaid
641	703	\N	\N	\N	notPaid
642	704	\N	\N	\N	notPaid
643	705	\N	\N	\N	notPaid
644	706	\N	\N	\N	notPaid
645	707	\N	\N	\N	notPaid
646	708	\N	\N	\N	notPaid
647	709	\N	\N	\N	notPaid
648	710	\N	\N	\N	notPaid
649	711	\N	\N	\N	notPaid
650	712	\N	\N	\N	notPaid
651	713	\N	\N	\N	notPaid
652	714	\N	\N	\N	notPaid
653	715	\N	\N	\N	notPaid
654	716	\N	\N	\N	notPaid
655	717	\N	\N	\N	notPaid
656	718	\N	\N	\N	notPaid
657	719	\N	\N	\N	notPaid
658	720	\N	\N	\N	notPaid
659	721	\N	\N	\N	notPaid
660	722	\N	\N	\N	notPaid
661	723	\N	\N	\N	notPaid
662	724	\N	\N	\N	notPaid
663	725	\N	\N	\N	notPaid
664	726	\N	\N	\N	notPaid
665	727	\N	\N	\N	notPaid
666	728	\N	\N	\N	notPaid
667	729	\N	\N	\N	notPaid
668	730	\N	\N	\N	notPaid
669	731	\N	\N	\N	notPaid
670	732	\N	\N	\N	notPaid
671	733	\N	\N	\N	notPaid
672	734	\N	\N	\N	notPaid
673	735	\N	\N	\N	notPaid
674	736	\N	\N	\N	notPaid
675	737	\N	\N	\N	notPaid
676	738	\N	\N	\N	notPaid
677	739	\N	\N	\N	notPaid
678	740	\N	\N	\N	notPaid
679	741	\N	\N	\N	notPaid
680	742	\N	\N	\N	notPaid
681	743	\N	\N	\N	notPaid
682	744	\N	\N	\N	notPaid
683	745	\N	\N	\N	notPaid
684	746	\N	\N	\N	notPaid
685	747	\N	\N	\N	notPaid
686	748	\N	\N	\N	notPaid
687	749	\N	\N	\N	notPaid
688	\N	order_FVlPhgTp5dXRLo	i_1gVdYhS	25000	notPaid
689	\N	order_FVlYAzkINlNHyn	tWU2wP-L1	25000	notPaid
690	\N	order_FVlaYMmmnmHI52	rBPpcWRN8	25000	notPaid
691	\N	order_FVmXUhjMQt5yH1	WdCrvHaky	12300	notPaid
692	\N	order_FVmXWHnTbAhW18	RBd-K_MGB	12300	notPaid
693	\N	order_FVmXtA9F8y1OWm	Vl3GD528U	12300	notPaid
694	\N	order_FVn0LGEndzLzfY	Os7pJc8DW	25000	fullyPaid
695	\N	order_FVnA2GuWjf2ps7	ZJQPYVTg-	25000	notPaid
696	\N	order_FVnP0llBNTkb2i	jQDVyQf19	25000	fullyPaid
697	\N	order_FVnU3fkF2oQcIg	m1DXdAO9m	25000	notPaid
698	\N	order_FVp8HvcckC1Gs4	sH0KyrtMm	500000	fullyPaid
751	793	order_FWCgQBDK3j8iJa	L6rt-LKAC	5000	fullyPaid
699	754	order_FVp9XfAFaPGmKe	d5NJYr-34	500000	fullyPaid
700	\N	order_FVpML0aGaLrI7p	LmSP2jvRR	500000	fullyPaid
735	773	order_FWAKNmX1cPKFU0	l_Za-SpF7	2500	fullyPaid
701	755	order_FVpN6UbNrsAf5g	PxYz6gL3W	500000	fullyPaid
702	\N	order_FVrswo6G2jxYTJ	j9ro7bOnp	5000	notPaid
703	\N	order_FVsK8tKyu7jvZJ	FPGpI1Rg3	5000	notPaid
704	\N	order_FVsKxCu7s0zvA4	4FGxndVTo	500000	notPaid
705	\N	order_FVsKxCri24Exa1	3FHWrVNUyg	500000	notPaid
706	\N	order_FVsOv1RSp5mgBG	PNJGwS8jL	5000	notPaid
707	\N	order_FVsP5Hbd01BUKg	3mqDOfO-n	500000	notPaid
708	\N	order_FVt5r4KmYtnJ9b	OPIpJXZcc	500000	notPaid
709	\N	order_FVtiqOSRnFj8xH	yClv1l_dR	5000	notPaid
710	759	order_FVtjVGZzK5qRgC	4pphdfTJF	5000	fullyPaid
711	\N	order_FVtkMocjYm7CPL	p5Yz_QhcY	5000	notPaid
736	\N	order_FWAVJHVgKRtIp8	x0X_D1Kfb	2500	fullyPaid
712	760	order_FVtlPgtc99nDG3	Mij-VJkgo	5000	fullyPaid
713	\N	order_FVvJGe89KxZOFt	1Ja1KAA_d	2000	fullyPaid
714	\N	order_FVvL12ErbQamad	JE20Cnp3A	2000	fullyPaid
715	\N	order_FVvLW2DDs5aUFZ	DfPjGTUM8	2000	notPaid
716	\N	order_FW7T2pRNquYQot	kjp-37Mct	12300	notPaid
717	\N	order_FW7TKnek50XPOi	qxqPtFGFR	12300	notPaid
718	\N	order_FW7TtjK6gy06uF	13vIoxua4h	40000	notPaid
719	\N	order_FW7TtlInyVNMge	y_nWuTG7p	40000	notPaid
720	\N	order_FW8GrgJKkCFen3	ZRNWcAT__	2000	fullyPaid
721	\N	order_FW8Hgf36EBvueo	kOPHsX1Vw	2000	notPaid
722	\N	order_FW8W5AR3idnUd9	xjZD2s_P8	2000	fullyPaid
723	\N	order_FW91AQC5u8IK6x	-HeQRCP6R	3500	fullyPaid
724	\N	order_FW94yYxC64kkmd	IZoCXS1fa	3500	fullyPaid
725	\N	order_FW9ADiM7LLn3wV	T9NFC1ioC	3500	fullyPaid
726	\N	order_FW9DToh4SpIwPB	vqP91GDeL	3500	fullyPaid
727	766	order_FW9FZoqz6hFn5C	WbPx315Ho	3500	fullyPaid
737	\N	order_FWAhCge4tUPMzl	IglEgWsbu	2500	fullyPaid
728	767	order_FW9LZ3j1vg3UGI	dg3xzFvB6	2500	fullyPaid
738	778	\N	\N	5000	fullyPaid
729	768	order_FW9OJcYMi6XKro	NmiJ9zafQ	2500	fullyPaid
730	\N	order_FW9QwekUnQ9j34	yh5kU5PKm	2500	notPaid
739	\N	order_FWC4JkI3pOfMkO	ginvxLgsb	1000	notPaid
731	769	order_FW9jPEFPxHKQYb	f8ncXsYfo	2500	fullyPaid
740	\N	order_FWC4fSi0EKqkH5	Imkv-_vkj	1000	notPaid
733	771	order_FW9u1sZgj4pFM4	jv5_1ioNp	2500	fullyPaid
742	\N	order_FWC9YUD86XbDnK	iHUKWIW0F	400	notPaid
734	772	order_FW9vHBH7vCWOG3	WB5PuxRVP	2500	fullyPaid
741	781	order_FWC9SFvDKp4zs4	GmeHgDsb0	200	fullyPaid
743	\N	order_FWCGHTuoa1Rcqa	TUYO3vd0I	5000	notPaid
744	\N	order_FWCGooit70jSME	GxZSIHsXE	5000	fullyPaid
745	\N	order_FWCRyptUbru1MB	yPYxZKO1N	200	notPaid
757	806	order_FWD2hPw2nQCw96	7d_63bg4R	500	fullyPaid
746	785	order_FWCScfM77ErWCu	V7rZQXGSp	200	fullyPaid
752	794	order_FWClLDWImbWVIT	yBzweucrm	5000	fullyPaid
747	787	order_FWCWKCjHv0wnQ5	E_30iW8-Y	400	fullyPaid
748	788	order_FWCY8j4iFpKJEs	hGABr_9-s	500	fullyPaid
749	789	order_FWCa3qQqtKs6jY	Kt5mZ7VnC	5000	fullyPaid
750	792	\N	\N	5000	fullyPaid
762	814	order_FWE2qmZF38SQ5I	Lb9GJ8FA-	5000	fullyPaid
753	796	order_FWCq9irNkcMZua	gMg_8UsI8	5000	fullyPaid
758	808	order_FWD6LPLjM81x7X	W5KhcDaML	500	fullyPaid
754	799	order_FWCsOATP5yAuSE	1I-USsTyE	5000	fullyPaid
755	\N	order_FWCtU4Edyl2Icd	jN3c6eLPb	500	notPaid
759	811	\N	\N	5000	fullyPaid
756	803	order_FWCyBAw02IRvm8	QuE3Kb9ic	5000	fullyPaid
763	\N	order_FWE5LGAauD3E4V	zfXqPOAuo	5000	notPaid
760	812	\N	\N	5000	fullyPaid
761	\N	order_FWDw4odmVjNgjc	CEuqDrkiO	5000	notPaid
766	\N	order_FWFDaXSYGR1SrW	Vml5xR1dv	5000	notPaid
764	\N	order_FWE5ky3iMAwF25	4qDprvTDk	5000	notPaid
765	818	order_FWEwRTcy44vKQc	Ph6Sm7qk6	5000	fullyPaid
768	821	\N	\N	5000	fullyPaid
767	819	order_FWFDfXzvSodp9T	TACf19TfH	5000	fullyPaid
769	822	\N	\N	5000	fullyPaid
771	826	\N	\N	5000	fullyPaid
770	823	order_FWG6t4zHFtPLze	w3APiRx30	5000	fullyPaid
772	828	\N	\N	5000	fullyPaid
773	830	\N	\N	5000	fullyPaid
774	831	\N	\N	5000	fullyPaid
775	\N	order_FWKzoMdGNxaNh9	vwsqB9FlU	5000	notPaid
776	832	\N	\N	5000	fullyPaid
846	884	\N	\N	2000	fullyPaid
777	833	order_FWTz3tenvSRZiK	nw1Eo9x2j	200	fullyPaid
778	834	\N	\N	2500	fullyPaid
779	835	\N	\N	2500	fullyPaid
780	837	\N	\N	5000	fullyPaid
781	839	\N	\N	5000	fullyPaid
782	840	\N	\N	5000	fullyPaid
783	842	\N	\N	5000	fullyPaid
784	843	\N	\N	5000	fullyPaid
785	844	\N	\N	5000	fullyPaid
786	845	\N	\N	1000	fullyPaid
847	885	\N	\N	2000	fullyPaid
787	846	order_FWXs3egozBbmDe	HueLuOm7x	5000	fullyPaid
848	886	\N	\N	2000	fullyPaid
788	847	order_FWY1ysUGp363Zm	kfFz3fxsH	5000	fullyPaid
789	\N	order_FWYKZ4A1OQp65Q	XhWhsNBZS	5000	notPaid
790	848	\N	\N	5000	fullyPaid
791	\N	order_FWYM06NTTREnrG	MvuM6X7uT	5000	notPaid
792	849	\N	\N	5000	fullyPaid
849	887	\N	\N	100	fullyPaid
793	850	order_FWYQG1nxhyKHSI	atFUSUS8R	200	fullyPaid
850	888	\N	\N	100	fullyPaid
794	851	order_FWYRPXgy1bxBRS	wBPHrixJq	200	fullyPaid
795	\N	order_FWYRwmAr6mS830	E_I8v2ftW	5000	notPaid
796	\N	order_FWYUvjXPRg7P00	-JvHO3PjX	5000	notPaid
797	\N	order_FWYZnXpQqwn5n5	wCRt6TkfR	5000	notPaid
798	\N	order_FWYfIe6eoyYcaB	qWco6kCd_	5000	notPaid
799	\N	order_FWYkxYpniFAjjZ	BG38xhi2U	5000	notPaid
800	\N	order_FWYobKNLIMgDTq	HcB6sFHyo	5000	notPaid
801	\N	order_FWYqEZrG4VsS7b	d37Egw_Eu	5000	notPaid
802	\N	order_FWYscLcWhlATLv	P_a0qh1uV	5000	notPaid
803	\N	order_FWYtLXDlLLpxni	_wJiWJpm_	5000	notPaid
804	\N	order_FWYuZzvrDv3rNg	NIbaUQ6kz	1000	notPaid
805	\N	order_FWYx71eiNyocqW	rFOstJVsU	5000	notPaid
806	\N	order_FWYxGMe3YB8W6S	DBE92I5KJ	1000	notPaid
807	\N	order_FWZ19GrNsAO0Pv	jA_U5eYK7	1000	notPaid
808	\N	order_FWZ2nAiVKsNttD	JjSc8HdZ3	1000	notPaid
809	\N	order_FWZ46atLkPF0ux	PKaNtG1S7	1000	notPaid
810	\N	order_FWZ4JtbyCSignL	RrnhZX2om	5000	notPaid
811	\N	order_FWZ5OishJTVm5k	CXF42_HkI	5000	notPaid
812	\N	order_FWZ6ZIv0goJybJ	JbxsWSaCv	5000	notPaid
813	\N	order_FWZQFBjGrtakyW	6BXhI_wdF	1000	notPaid
814	\N	order_FWZR1jI91K6aAC	hoZK7VP95	1000	notPaid
815	\N	order_FWZaqZ7HLJzNLV	-bJqbbvli	5000	notPaid
816	852	\N	\N	2500	fullyPaid
817	853	\N	\N	2500	fullyPaid
818	\N	order_FWZzqyRzrLIoIp	K6X7Ahg3N	250000	notPaid
851	\N	order_FXLkVkoGaQE4pH	jl4v6i9Kj	100	notPaid
819	855	order_FWb02P2HengH0Z	lDxRkGL3G	5000	fullyPaid
852	\N	order_FXLmYeWjedR8RQ	4FAA_0ogz	2500	notPaid
820	856	order_FWc7esKulivA8r	3uD7SCiFy	2500	fullyPaid
821	857	\N	\N	2500	fullyPaid
853	\N	order_FXLmghGO1IVPc2	5mygonpuN	9999	notPaid
822	858	order_FWunblvEFbGrSy	dGwfYMdg_	2500	fullyPaid
854	\N	order_FXLmnNAXv7mW7u	njbaluDy3	99999	notPaid
823	859	order_FWuqfaiVigm0V1	4PCVzyM7s	2500	fullyPaid
855	\N	order_FXML9ElaQ2R07S	xAFQ-0GZA	5000	notPaid
824	860	order_FWv0VgZd84HjRg	ZTohObxU9	2500	fullyPaid
825	862	\N	\N	2000	fullyPaid
826	863	\N	\N	2000	fullyPaid
827	864	\N	\N	2000	fullyPaid
828	865	\N	\N	2000	fullyPaid
829	866	order_FWwsu4kQ92QfU5	LH3m15ah7	100	fullyPaid
862	\N	order_FXl0idXpXkFjBu	gMyi-VWeA	200	notPaid
830	867	order_FWyfHAzxrSCAsj	GLQS3Saz3	3500	fullyPaid
831	869	\N	\N	2000	fullyPaid
832	870	\N	\N	2000	fullyPaid
833	871	\N	\N	2000	fullyPaid
834	872	\N	\N	2000	fullyPaid
835	873	\N	\N	2000	fullyPaid
836	874	\N	\N	2000	fullyPaid
837	875	\N	\N	2000	fullyPaid
838	876	\N	\N	2000	fullyPaid
839	877	\N	\N	2000	fullyPaid
840	878	\N	\N	2000	fullyPaid
841	879	\N	\N	2000	fullyPaid
842	880	\N	\N	2000	fullyPaid
843	881	\N	\N	2000	fullyPaid
844	882	\N	\N	2000	fullyPaid
845	883	\N	\N	2000	fullyPaid
863	\N	order_FXl0iejLpWECzP	lwQfFrNJF	200	notPaid
856	891	order_FXMLBlgaXmIBSl	FhlFt4elg	5000	fullyPaid
864	901	\N	\N	2500	fullyPaid
857	892	order_FXMMpFfr8FkS5G	kMhzpz1b1	5000	fullyPaid
858	897	\N	\N	2500	fullyPaid
859	898	\N	\N	2500	fullyPaid
861	\N	order_FXi6a6Sa6XpJJw	gWN481MAy	2500	notPaid
865	902	\N	\N	2500	fullyPaid
860	900	order_FXi6a6xJAsrjlY	XWvjqovqh	2500	fullyPaid
866	903	\N	\N	2500	fullyPaid
867	905	\N	\N	2500	fullyPaid
868	904	\N	\N	2500	fullyPaid
869	907	\N	\N	9999	fullyPaid
870	912	\N	\N	2533	fullyPaid
872	\N	order_FY8NJDyfb31N4s	gfYayTY3D	100	notPaid
871	914	order_FY8NJ9dbAGR0tG	2SU0FcRPP	100	fullyPaid
874	\N	order_FY8PkkAQU5u2Yx	vpZiIGh4S	1000	notPaid
877	917	order_FY8SXMRq6aJ4X9	60QJgz_zQ	1000	fullyPaid
873	915	order_FY8PkhgU7jHRog	8uUKmKI26	1000	fullyPaid
876	\N	order_FY8QLxzyh9BBe3	FjYdRqe2N	1000	notPaid
875	\N	order_FY8QLwPFnngQU7	ucuYbTYZV	1000	fullyPaid
878	\N	order_FY8SXN00KGiRAf	_2W_CpIPd	1000	notPaid
880	\N	order_FY8YGm4dtV9raO	gWF03ch9i	1000	notPaid
944	1422	order_FYG1vPNcfKkxYc	hqYzE3TdS	5000	fullyPaid
879	919	order_FY8YGlFvDjsG2E	QLJSn5vji	1000	fullyPaid
882	\N	order_FY8kGi9G9QARXl	Q5d_4o26x	1000	notPaid
918	\N	order_FYBrxjqPOpKk13	2q3PdLVgA	5000	notPaid
913	977	\N	\N	5000	fullyPaid
881	921	order_FY8kGh7eZbRhi2	N6uLqFYzu	1000	fullyPaid
883	\N	order_FY8l3DDAyJpkjX	lLexld4cX	1000	notPaid
884	\N	order_FY8l3DzlrWyAsr	SuOZUU7yD	1000	notPaid
886	\N	order_FY8lvlgzFAzvdY	lEb6W-x_l	1000	notPaid
947	978	\N	\N	5000	fullyPaid
885	\N	order_FY8lvkndFauafi	I37vvGVFR	1000	fullyPaid
888	\N	order_FY8mYkLFhrFYNe	9sStk_x7a	1000	notPaid
887	\N	order_FY8mYjlF8wfHnA	QGbW3oo3N	1000	fullyPaid
890	\N	order_FY8nK4DaW1Ftqw	sWjBlMLAR	1000	notPaid
917	953	order_FYBrxjF9q3RTot	6JgVlTX36	5000	fullyPaid
889	923	order_FY8nK2cl84QHDz	dYQvsRoKQ	1000	fullyPaid
2252	2282	\N	\N	1000	fullyPaid
892	\N	order_FY8pLKedykJQ81	zoTS3P_Xh	1000	notPaid
920	\N	order_FYCJWmkGOpnkCF	sY4VbpXL2	5000	notPaid
891	924	order_FY8pLKWqq9K0va	8A2_Cv2_O	1000	fullyPaid
894	\N	order_FY8pjEnRmHiEC9	6ZYkMihFd	1000	notPaid
937	966	order_FYF2VHIuMQ1Yrp	Hm3xtogqa	5000	fullyPaid
893	926	order_FY8pjEPLfSUUPT	UBNjfY8Pi	1000	fullyPaid
895	929	\N	\N	2000	fullyPaid
897	\N	order_FY9bsLZWgMrwYy	GTHjiqaNS	2000	notPaid
919	955	order_FYCJWm47dageuS	7N6zYV_lV	5000	fullyPaid
896	933	order_FY9bsKq4PSOVA4	uczSbvuT_	2000	fullyPaid
899	\N	order_FY9m0IfghRG6mX	ofDi50pY2	2000	notPaid
922	\N	order_FYDzOQXsBx3UW8	LiKqse3tA	5000	notPaid
939	967	\N	\N	5000	fullyPaid
898	935	order_FY9m0IoxbinbMT	kmmxndTBV	2000	fullyPaid
900	\N	order_FY9obkdMAY9dQo	X5jGAolb5	2000	notPaid
940	968	\N	\N	5000	fullyPaid
901	937	order_FY9obkl2U7EmHo	nevd_qCjA	2000	fullyPaid
903	\N	order_FYA40i1G3zF2ut	SKcq7hY12	2000	notPaid
921	957	order_FYDzOQSnLGbNKj	ao2fLBRCI	5000	fullyPaid
902	939	order_FYA40ha0eQSSUG	2ZqjG6Bif	2000	fullyPaid
905	\N	order_FYAuxmGQZ5siMd	fBVuQQsCn	2000	notPaid
924	\N	order_FYE0TWzOQrZtN8	hvCKUtJvZ	5000	notPaid
904	943	order_FYAuxlvHQduS5t	pUaLS1uPs	2000	fullyPaid
907	\N	order_FYAwmAhh62aBDQ	zLxGtfAs9	2000	notPaid
948	981	\N	\N	5000	fullyPaid
906	944	order_FYAwmASwSNlt3h	mPfjA6lJQ	2000	fullyPaid
909	\N	order_FYAxmaVZQjJ7ye	Kd1p3wXgR	2000	notPaid
908	\N	order_FYAxmZYrWrr5hy	Rc98h8TAx	2000	fullyPaid
910	\N	order_FYBWBUZr7ZgZUa	uBdFPP_9l	500	notPaid
923	959	order_FYE0TVyXgCA7Fu	Epy-jQ064	5000	fullyPaid
911	946	order_FYBWBVgc1tRSv4	8CsM2APXA	500	fullyPaid
912	947	\N	\N	5000	fullyPaid
915	950	\N	\N	5000	fullyPaid
916	951	\N	\N	5000	fullyPaid
926	\N	order_FYEMeWFXndleHl	ngg50tMf5	5000	notPaid
941	969	order_FYFbRz1yBJVQC3	QyZDwDDL8	5000	fullyPaid
925	961	order_FYEMeVT748yBGM	8NDh21J72	5000	fullyPaid
927	\N	order_FYEsoLAtOsLmT2	pVAblSNZR	1000	notPaid
928	\N	order_FYEsoL3I6dziNP	g93Kjgqtk	1000	notPaid
929	\N	order_FYEtM8yQiJtZbJ	U-_tOqjdb	1000	notPaid
930	\N	order_FYEtM9Y5mFzc3r	cb6wiPZT-	1000	notPaid
931	\N	order_FYEtWL9sNdKKPX	CyeX22Fra	1000	notPaid
932	\N	order_FYEtWLjDQbjGCn	UeyZqWPCD	1000	notPaid
934	\N	order_FYExxG9SnOwx61	KAhKa6SAy	5000	notPaid
942	970	order_FYFlL9KqySSlBs	LlILOU4z4	5000	fullyPaid
933	962	order_FYExxFU6gwsol3	Csq_tP-Qc	5000	fullyPaid
936	\N	order_FYF1G5M9e3nDUj	t585SazBl	5000	notPaid
950	\N	order_FYVlgFnc4lNshq	XnnrLveUt	2500	notPaid
938	\N	order_FYF2VHjcgE5tLm	4IuR5vI1N	5000	notPaid
943	971	order_FYFzLiJBL8kOPB	QD3Zbw2QO	5000	fullyPaid
946	\N	order_FYGCOqFGQXvq57	wmZm__CkU	5000	notPaid
959	987	order_FYW7cLadySve9c	RUb2-0bCa	2500	fullyPaid
945	974	order_FYGCOqXxv6I9XN	SN-D3C7i8	5000	fullyPaid
949	983	order_FYVlgEXD3mnBfn	V-kPLVSyi	2500	fullyPaid
952	\N	order_FYVr6Wphg1OYA1	Avdh1FksU	2500	notPaid
953	986	order_FYW2whcquIHn6d	vUNbJJ1Wk	2500	fullyPaid
955	\N	order_FYW3iLX1QI2XVT	fJseJ2z0C	2500	notPaid
951	985	order_FYVr6W5yGvsN4D	06YnFHTDJ	2500	fullyPaid
954	\N	order_FYW2wiq7fTMUCH	hCYfsDWhR	2500	notPaid
956	\N	order_FYW3iLZi1BP22j	qKY27E9Gj	2500	notPaid
957	\N	order_FYW4JTwg3jAU2L	DPMcj5nO5	2500	notPaid
958	\N	order_FYW4JVkyT1ewKP	ZZtTz5FLk	2500	notPaid
960	\N	order_FYW7cM7JEMbHAc	ebtBDznWy	2500	notPaid
962	\N	order_FYWA92ooCPSHDm	KcQwnD66c	2500	notPaid
961	989	order_FYWA92F4eGEZUi	8ui6Ighv9	2500	fullyPaid
964	\N	order_FYWKPrFfYiWBTk	N7V3Xxtcp	2500	notPaid
963	991	order_FYWKPksCDfGyD4	XRoExeqVa	2500	fullyPaid
966	\N	order_FYWMLErmZ2BEZ5	hz7u3FfPG	2500	notPaid
965	993	order_FYWMLEc4gNPcTs	xsxqDTH2x	2500	fullyPaid
967	995	\N	\N	5000	fullyPaid
968	996	\N	\N	5000	fullyPaid
969	997	\N	\N	5000	fullyPaid
970	\N	order_FYXHrhVVG1asce	HZRFS3rqV	5000	notPaid
914	1110	\N	\N	5000	fullyPaid
979	1120	order_FYZ1kZkCwhhYCs	N6HWT581Y	3500	fullyPaid
1062	1094	\N	\N	1000	fullyPaid
971	998	order_FYXHrhBvZfQs1G	J7V7bZmnK	5000	fullyPaid
972	\N	order_FYYGjHKzOTdS7n	qGWcuBZoT	2500	notPaid
1092	1124	\N	\N	3500	fullyPaid
1040	1082	order_FYxYg4rPjht65u	gpzh-ycro	200	fullyPaid
973	1000	order_FYYGjHzQLKJlCY	pmCTAA-Yx	2500	fullyPaid
974	1001	\N	\N	2500	fullyPaid
975	1002	\N	\N	2500	fullyPaid
976	1003	\N	\N	2500	fullyPaid
977	1004	\N	\N	5000	fullyPaid
978	1005	\N	\N	5000	fullyPaid
980	\N	order_FYZ1kaLDSx2Mnf	isT7aDF2r	3500	notPaid
1043	\N	order_FYxaZhmytMLfW0	ggx_9vh-s	200	notPaid
1052	\N	order_FYy19YCKJt5pR8	447d_M5SJ	500	fullyPaid
981	1014	\N	\N	1000	fullyPaid
982	1015	\N	\N	1000	fullyPaid
984	\N	order_FYaCALnKyBS6gr	6kArRS3wX	2500	notPaid
983	1016	order_FYaCALhv2tRQCp	mq9H-aO5u	2500	fullyPaid
985	\N	order_FYaEJTEnvZTzz4	tVLG_Cnll	2500	notPaid
986	\N	order_FYaEJU856eStTi	EREZ7OcO8	2500	notPaid
987	1017	\N	\N	2500	fullyPaid
988	1018	\N	\N	2500	fullyPaid
989	1019	\N	\N	2500	fullyPaid
990	1020	\N	\N	2500	fullyPaid
991	1021	\N	\N	2500	fullyPaid
992	1022	\N	\N	2500	fullyPaid
993	1023	\N	\N	2500	fullyPaid
994	1025	\N	\N	2500	fullyPaid
995	1024	\N	\N	2500	fullyPaid
996	1026	\N	\N	2500	fullyPaid
997	1027	\N	\N	2500	fullyPaid
998	1028	\N	\N	2500	fullyPaid
999	1029	\N	\N	500	fullyPaid
1000	1030	\N	\N	500	fullyPaid
1001	1032	\N	\N	500	fullyPaid
1002	1031	\N	\N	500	fullyPaid
1003	1033	\N	\N	500	fullyPaid
1004	1034	\N	\N	500	fullyPaid
1005	1035	\N	\N	500	fullyPaid
1006	1036	\N	\N	500	fullyPaid
1007	1037	\N	\N	500	fullyPaid
1008	1038	\N	\N	500	fullyPaid
1009	1039	\N	\N	500	fullyPaid
1011	1041	\N	\N	3500	fullyPaid
1012	1042	\N	\N	3500	fullyPaid
1013	1043	\N	\N	3500	fullyPaid
1014	1047	\N	\N	1000	fullyPaid
1015	1048	\N	\N	5000	fullyPaid
1016	1049	\N	\N	5000	fullyPaid
1017	1050	\N	\N	5000	fullyPaid
1018	1051	\N	\N	5000	fullyPaid
1019	1052	\N	\N	5000	fullyPaid
1020	1053	\N	\N	5000	fullyPaid
1021	1054	\N	\N	5000	fullyPaid
1022	1055	\N	\N	500	fullyPaid
1023	1056	\N	\N	3500	fullyPaid
1024	1057	\N	\N	500	fullyPaid
1025	1058	\N	\N	3500	fullyPaid
1026	1059	\N	\N	3500	fullyPaid
1028	\N	order_FYgmSlGvFFQHj0	wdYHyWIjn	3500	notPaid
1042	1084	order_FYxaZhSi9DWiVY	-jJt21fKA	200	fullyPaid
1027	1061	order_FYgmSl7jXTe8PG	OBj288fly	3500	fullyPaid
1030	\N	order_FYgsLd3xWeTb3C	9eKJynfY-	500	notPaid
1045	\N	order_FYxbLnm7lFzWvy	c3Hw2izhn	200	notPaid
1057	\N	order_FYy1scaPS5wWMW	LR0PG3vl6	500	notPaid
1029	1063	order_FYgsLdJFKAdLEn	0mh_kBB9_	500	fullyPaid
1031	1066	\N	\N	3500	fullyPaid
1032	1067	\N	\N	3500	fullyPaid
1033	1068	\N	\N	3500	fullyPaid
1034	1069	\N	\N	3500	fullyPaid
1035	1071	\N	\N	3500	fullyPaid
1037	\N	order_FYx8A43Q12TILn	Q_KlU3NQd	500	notPaid
1036	1080	order_FYx8A3tWpFvcxL	9URik2nEd	500	fullyPaid
1039	\N	order_FYxW5Syyo6OhvQ	RY-aWHZ_T	200	notPaid
1044	1086	order_FYxbLn0CW7sxZX	51WJ9pWRt	200	fullyPaid
1038	1081	order_FYxW5Tb55YCRGu	kCrQLNbdt	200	fullyPaid
1041	\N	order_FYxYg5S7xG8vGf	IhZVF_sXg	200	notPaid
1047	\N	order_FYxxJhCLap0a0O	mkULcFoQb	500	notPaid
1054	1091	order_FYy1KDLG3K1vR3	yIyyI2AFX	3500	fullyPaid
1046	1088	order_FYxxJggDa1Y5sk	7LmWqxOLB	500	fullyPaid
1048	\N	order_FYxzMLt3Wj7xbE	ftbQ4PzS6	200	notPaid
1049	\N	order_FYxzMM522xcQ9g	pWEXnUoU_	200	notPaid
1051	\N	order_FYy03BinV2U68n	oncqEy3vV	500	notPaid
1056	1089	order_FYy1saRzKl3U7r	NtmsBcKL0	500	fullyPaid
1050	\N	order_FYy039fSnPOvrq	-ghiICQEv	500	fullyPaid
1053	\N	order_FYy19byxxX9WWG	6ejzXcu9I	500	notPaid
1055	\N	order_FYy1KDZWkG1uNQ	v93DA9XKL	3500	notPaid
1058	\N	order_FYy2XsGi9HBe5G	uGM6Y_GBx	500	notPaid
1059	\N	order_FYy2Xt3rG1s235	eogZoEmq3	500	notPaid
1061	\N	order_FYy2gSuOOQmaBP	nsStNDxHz	500	notPaid
1063	1096	\N	\N	3500	fullyPaid
1060	1092	order_FYy2gSWtG32nFn	Zohjkut6D	500	fullyPaid
1066	\N	order_FZ1aJcISIMz6LD	TI1RNF7Py	500	notPaid
1065	1099	order_FZ1aJcDYn34N74	1eVk53FxH	500	fullyPaid
1067	\N	order_FZ25VRLGmdv2tB	KqWm-CUdn	500	notPaid
1068	\N	order_FZ25VS5U7OJR8o	L5RGt9_bj	500	notPaid
1070	\N	order_FZ2RV3TSj9tWh5	JJofzAkUx	500	notPaid
1069	1101	order_FZ2RV2zJ1vpgrO	-WAkXRnjq	500	fullyPaid
1072	\N	order_FZHWt2X0S8AjDq	npDpstNnM	100	notPaid
1071	\N	order_FZHWt2s03LZkb5	K8E6kgSaQ	100	fullyPaid
1074	\N	order_FZHb2irQFl1CNI	z_PK-6xXw	200	notPaid
1073	\N	order_FZHb2iSqkrkJlS	NcVgnlLXR	200	fullyPaid
1076	1103	\N	\N	500	fullyPaid
1075	1111	\N	\N	500	fullyPaid
1010	1112	\N	\N	500	fullyPaid
1064	1104	\N	\N	3500	fullyPaid
1078	1121	\N	\N	3500	fullyPaid
1077	1106	\N	\N	3500	fullyPaid
1085	\N	order_FZMAHNZSNMj48U	zaYOPDyfM	500	fullyPaid
1079	1113	\N	\N	500	fullyPaid
1080	1114	\N	\N	2000	fullyPaid
1082	\N	order_FZKhWBqE6aGFd3	0VgmFxru2	200	notPaid
1083	\N	order_FZKhXo3rNaRm8a	nal3vq0oE	200	notPaid
1086	\N	order_FZMAwR7nON8aEA	lPOGweIdn	500	fullyPaid
1084	1118	\N	\N	3500	fullyPaid
1087	\N	order_FZMD3VyO6194dZ	Kde_tH2-p	500	fullyPaid
1088	\N	order_FZMDYOPbuVf91Y	YpwCNoTCk	1000	fullyPaid
1089	\N	order_FZMEOq2Il6NePe	5BGvYPPr5	1000	fullyPaid
1090	\N	order_FZMGlR0zCCTu2n	ZeVD_d5Kc	500	fullyPaid
1094	1129	\N	\N	3500	fullyPaid
1095	1130	\N	\N	500	fullyPaid
1096	1131	order_FZNWdDCxhgWAM8	8ZKMSCYpO	500	fullyPaid
1098	1134	\N	\N	500	fullyPaid
732	1138	order_FW9pJVHU3FogsL	vi3fdEOwZ	2500	fullyPaid
1099	1139	\N	\N	500	fullyPaid
1100	\N	order_FZRVTbi66HjTlE	Zxoqxz3jI	500	notPaid
1101	\N	order_FZRWicOk8N1pEw	QDhiEzVr8	500	notPaid
1148	\N	order_Fa7BRJCRNqMSXd	s1Wi1oktO	4000	fullyPaid
1102	1143	order_FZRWr0uFyyIgAm	X3ziwpkSD	500	fullyPaid
1103	\N	order_FZW7LjLRMJ6jIg	Cotwal9ch	200	notPaid
1104	1144	\N	\N	2000	fullyPaid
1105	1145	\N	\N	2000	fullyPaid
1106	1146	\N	\N	2000	fullyPaid
1107	1147	\N	\N	2000	fullyPaid
1108	1148	\N	\N	2000	fullyPaid
1109	1149	\N	\N	2000	fullyPaid
1110	1150	\N	\N	2000	fullyPaid
1111	1151	\N	\N	2000	fullyPaid
1112	1152	\N	\N	2000	fullyPaid
1113	1153	\N	\N	2000	fullyPaid
1114	1154	\N	\N	2000	fullyPaid
1115	1155	\N	\N	2000	fullyPaid
1116	1156	\N	\N	2000	fullyPaid
1117	1157	\N	\N	2000	fullyPaid
1118	1158	\N	\N	2000	fullyPaid
1119	1159	\N	\N	2000	fullyPaid
1120	1160	\N	\N	2000	fullyPaid
1121	1161	\N	\N	2000	fullyPaid
1122	1162	\N	\N	2000	fullyPaid
1123	1163	\N	\N	2000	fullyPaid
1124	1164	\N	\N	2000	fullyPaid
1125	1165	\N	\N	2000	fullyPaid
1126	1166	\N	\N	1000	fullyPaid
1127	1167	\N	\N	2000	fullyPaid
1128	1168	\N	\N	2000	fullyPaid
1129	1169	\N	\N	2000	fullyPaid
1130	1170	\N	\N	2000	fullyPaid
1131	1171	\N	\N	2000	fullyPaid
1132	1172	\N	\N	2000	fullyPaid
1133	1173	\N	\N	2000	fullyPaid
1134	1174	\N	\N	2000	fullyPaid
1135	1175	\N	\N	2000	fullyPaid
1136	1176	\N	\N	2000	fullyPaid
1137	1177	\N	\N	2000	fullyPaid
1138	1178	\N	\N	2000	fullyPaid
1139	1179	\N	\N	1000	fullyPaid
1140	1180	\N	\N	2500	fullyPaid
1141	1181	\N	\N	2500	fullyPaid
1142	1182	\N	\N	2000	fullyPaid
1149	\N	order_Fa7DVK2pH8i1i0	SXCkxRpWQ	4000	notPaid
1260	1309	\N	\N	2500	fullyPaid
1143	1183	order_Fa68NKFTISwyGM	wp7EW9Nkk	1000	fullyPaid
1150	\N	order_Fa7DghGOScpcqx	70n85ynfg	4000	notPaid
1144	1184	order_Fa6YJgFtaYJ0Un	3Q0PM--Ak	4000	fullyPaid
1151	\N	order_Fa7DqtAAoKtfDC	1thR-CSAf	4000	notPaid
1146	\N	order_Fa6roOkkPHVL2o	5y7HsNe_t	4000	fullyPaid
1147	\N	order_Fa75RZY7Q9HEio	qwwKZB7N0	4000	fullyPaid
1152	\N	order_Fa7EKxQd5csrSQ	JRdWuByN_	4000	notPaid
1153	\N	order_Fa7OayuvLaqNgZ	JacTX-VBv	4000	fullyPaid
1169	1209	\N	\N	3500	fullyPaid
1154	1186	order_Fa7qM1CcWHPLaL	HU6_kpDJu	4000	fullyPaid
1160	1195	order_Fa9NjPgb6Cu7xa	scPT5Qo1-	500	fullyPaid
1155	1187	order_Fa80BVXEopmgXO	o0hmesxXY	4000	fullyPaid
1156	1188	order_Fa89qPDBxjffl7	k3xCj2fAH	4000	fullyPaid
1157	1190	\N	\N	4000	fullyPaid
1166	1204	order_FaCQpgRjjZPJki	g_bPH50ov	2500	fullyPaid
1158	1191	order_Fa8JCbEliwbmjq	Jxyq7u_DZ	1000	fullyPaid
1159	1192	\N	\N	3500	fullyPaid
1091	1193	\N	\N	1000	fullyPaid
1081	1194	\N	\N	1000	fullyPaid
1161	1196	order_Fa9OYkJD4VTdr5	AFuVaSyZH	500	fullyPaid
1145	1197	order_Fa6rCCzf4XOeEN	J1ifeJc8i	4000	fullyPaid
1163	1200	\N	\N	1000	fullyPaid
1164	1201	\N	\N	1000	fullyPaid
1165	1202	\N	\N	1000	fullyPaid
1162	1203	\N	\N	5000	fullyPaid
1168	1206	order_FaCVevh4xJT8nf	Jr8tM6f0K	2500	fullyPaid
1167	1205	order_FaCUoJoYc9bGAM	I8sLfrm4F	200	fullyPaid
1097	1207	\N	\N	3500	fullyPaid
1171	1211	\N	\N	3500	fullyPaid
1170	1210	order_FaDbuPEXkCTXiw	ikpGPEXe3	200	fullyPaid
1172	1212	\N	\N	5000	fullyPaid
1173	1213	\N	\N	3500	fullyPaid
1174	1214	\N	\N	3500	fullyPaid
1175	1215	\N	\N	2500	fullyPaid
1176	1216	\N	\N	2500	fullyPaid
1177	1217	\N	\N	2500	fullyPaid
1178	1220	\N	\N	2500	fullyPaid
1180	1222	\N	\N	3500	fullyPaid
1181	1223	\N	\N	2500	fullyPaid
1182	1224	\N	\N	2500	fullyPaid
1179	1335	order_FaV72iT1kMgl8V	MqOdzf6Dj	5000	fullyPaid
1183	1225	\N	\N	2500	fullyPaid
1184	1226	\N	\N	2500	fullyPaid
1185	1227	\N	\N	2000	fullyPaid
1186	1228	\N	\N	3500	fullyPaid
1187	1229	\N	\N	3500	fullyPaid
1188	1230	\N	\N	3500	fullyPaid
1189	1231	\N	\N	3500	fullyPaid
1093	1232	\N	\N	3500	fullyPaid
1250	1298	\N	\N	5000	fullyPaid
1190	1233	order_FaYZycdmfRHum4	12hcMQ-Ct	2500	fullyPaid
1191	\N	order_FaYjWz1cXbgqbf	zRDX0a_VR	2500	notPaid
1193	1235	\N	\N	5000	fullyPaid
1194	1236	\N	\N	2000	fullyPaid
1195	1237	\N	\N	3500	fullyPaid
1196	1238	\N	\N	2000	fullyPaid
1197	1239	\N	\N	2000	fullyPaid
1198	1240	\N	\N	2000	fullyPaid
1199	1241	\N	\N	2000	fullyPaid
1200	1242	\N	\N	3500	fullyPaid
1201	1243	\N	\N	3500	fullyPaid
1192	1244	order_FaYnUVZfHSQI7R	UfPaiQ3-R	2500	fullyPaid
1277	1328	\N	\N	2500	fullyPaid
1202	1247	order_FaarxR4O3yx7eK	w8D-r3Jgk	2500	fullyPaid
1251	1299	order_FavCuJhubMhwn3	aJHcsOtAY	2500	fullyPaid
1203	1249	order_Faaw3XJl4LlX07	g3A0wA2q6	2500	fullyPaid
1204	\N	order_Faaxi6jzxvYYa0	m5TyeEG-5	2500	notPaid
1252	1300	\N	\N	2500	fullyPaid
1205	1251	order_Faays6QJYO81Wp	Prxfcwi56	2500	fullyPaid
1206	1252	\N	\N	2500	fullyPaid
1207	1253	\N	\N	2500	fullyPaid
1208	1254	\N	\N	2500	fullyPaid
1209	1255	\N	\N	2500	fullyPaid
1210	1256	\N	\N	2500	fullyPaid
1211	1257	\N	\N	2500	fullyPaid
1253	1301	\N	\N	2500	fullyPaid
1212	1258	order_FabY2DYVLozPJh	i8S-XXt08	2500	fullyPaid
1213	1259	\N	\N	2500	fullyPaid
1214	1260	\N	\N	2500	fullyPaid
1215	1261	\N	\N	2500	fullyPaid
1216	1262	\N	\N	3500	fullyPaid
1217	1263	\N	\N	3500	fullyPaid
1218	1264	\N	\N	3500	fullyPaid
1219	1265	\N	\N	3500	fullyPaid
1220	1266	\N	\N	3500	fullyPaid
1221	1267	\N	\N	3500	fullyPaid
1222	1268	\N	\N	3500	fullyPaid
1223	1269	\N	\N	3500	fullyPaid
1224	1270	\N	\N	5000	fullyPaid
1225	1271	\N	\N	5000	fullyPaid
1226	1272	\N	\N	3500	fullyPaid
1227	1273	\N	\N	5000	fullyPaid
1228	1274	\N	\N	3500	fullyPaid
1229	1275	\N	\N	3500	fullyPaid
1230	1276	\N	\N	3500	fullyPaid
1231	1277	\N	\N	5000	fullyPaid
1232	1278	\N	\N	3500	fullyPaid
1233	1279	\N	\N	5000	fullyPaid
1254	1302	\N	\N	2500	fullyPaid
1234	1280	order_FaqSLWTECv00cc	b4TNFvD_Z	500	fullyPaid
1236	1281	\N	\N	2500	fullyPaid
1255	1303	\N	\N	2500	fullyPaid
1235	1282	order_Faqr1hzDbAl5NC	OG1TgQqCC	200	fullyPaid
1237	1284	\N	\N	2500	fullyPaid
1256	1304	\N	\N	2500	fullyPaid
1238	1285	order_Fas3NEqhySeFYw	bkrBdxKEs	2500	fullyPaid
1239	1286	order_Fas87ugZkSvoyv	lMRjogDPi	2500	fullyPaid
1240	1287	\N	\N	5000	fullyPaid
1241	1288	\N	\N	5000	fullyPaid
1242	1289	\N	\N	5000	fullyPaid
1243	1290	\N	\N	5000	fullyPaid
1244	1291	\N	\N	3500	fullyPaid
1245	1293	\N	\N	200	fullyPaid
1273	1324	order_Fayk3qhTs2yOGh	OKHII8liH	2500	fullyPaid
1246	1294	order_Faux1CFWxWL5Tm	Gzkt78a9_	2500	fullyPaid
1247	1295	\N	\N	5000	fullyPaid
1248	1296	\N	\N	5000	fullyPaid
1249	1297	\N	\N	2500	fullyPaid
1257	1305	order_Favtl5b6EVTXxO	G3_n_9CiD	5000	fullyPaid
1274	1325	\N	\N	2500	fullyPaid
1258	1307	order_FawWkEQ5VSxFqY	59NHN7RJS	5000	fullyPaid
1259	1308	\N	\N	5000	fullyPaid
1261	1310	\N	\N	2500	fullyPaid
1262	1311	\N	\N	5000	fullyPaid
1263	1312	\N	\N	2500	fullyPaid
1264	1313	\N	\N	2500	fullyPaid
1265	1314	\N	\N	2500	fullyPaid
1266	1315	\N	\N	2500	fullyPaid
1267	1316	\N	\N	5000	fullyPaid
1268	1317	\N	\N	5000	fullyPaid
1269	1318	\N	\N	2500	fullyPaid
1270	1319	\N	\N	2500	fullyPaid
935	1320	order_FYF1G42324zneK	BGdmMqtds	5000	fullyPaid
1271	1321	\N	\N	2500	fullyPaid
1272	1323	\N	\N	5000	fullyPaid
1278	1329	\N	\N	2500	fullyPaid
1276	1327	\N	\N	5000	fullyPaid
1279	1330	\N	\N	2500	fullyPaid
1280	1332	\N	\N	5000	fullyPaid
1275	1333	order_Fayp93DX21zWaJ	IbcO6-1A2	5000	fullyPaid
1281	1334	\N	\N	2500	fullyPaid
1282	1336	\N	\N	2500	fullyPaid
1283	1337	\N	\N	2500	fullyPaid
1284	1338	\N	\N	1000	fullyPaid
1285	1339	\N	\N	2500	fullyPaid
1286	1340	\N	\N	2500	fullyPaid
1287	1341	\N	\N	2500	fullyPaid
1288	1342	\N	\N	2500	fullyPaid
1289	1343	\N	\N	2500	fullyPaid
1290	1344	\N	\N	2500	fullyPaid
1291	1345	\N	\N	2500	fullyPaid
1292	1346	\N	\N	2500	fullyPaid
1293	1347	\N	\N	2500	fullyPaid
1294	1348	\N	\N	2500	fullyPaid
1295	1349	\N	\N	2500	fullyPaid
1296	1350	\N	\N	2500	fullyPaid
1297	1351	\N	\N	2500	fullyPaid
1298	1352	\N	\N	1000	fullyPaid
1299	1353	\N	\N	1000	fullyPaid
1300	1354	\N	\N	1000	fullyPaid
1301	1355	\N	\N	1000	fullyPaid
1302	1356	\N	\N	1000	fullyPaid
1303	1357	\N	\N	1000	fullyPaid
1304	1358	\N	\N	2500	fullyPaid
1305	1359	\N	\N	1000	fullyPaid
1306	1360	\N	\N	1000	fullyPaid
1307	1361	\N	\N	2500	fullyPaid
1308	1362	\N	\N	1000	fullyPaid
1309	1363	\N	\N	2000	fullyPaid
1310	1364	\N	\N	1000	fullyPaid
1311	1365	\N	\N	1000	fullyPaid
1312	1366	\N	\N	2500	fullyPaid
1313	1367	\N	\N	1000	fullyPaid
1314	1368	\N	\N	1000	fullyPaid
1315	1369	\N	\N	2000	fullyPaid
1316	1370	\N	\N	2000	fullyPaid
1317	1371	\N	\N	2000	fullyPaid
1318	1372	\N	\N	1000	fullyPaid
1319	1373	\N	\N	1000	fullyPaid
1320	1374	\N	\N	2500	fullyPaid
1321	1375	\N	\N	2000	fullyPaid
1322	1376	\N	\N	2000	fullyPaid
1323	1377	\N	\N	2500	fullyPaid
1324	1378	\N	\N	2500	fullyPaid
1325	1379	\N	\N	1000	fullyPaid
1326	1380	\N	\N	2500	fullyPaid
1327	1381	\N	\N	1000	fullyPaid
1328	1382	\N	\N	2500	fullyPaid
1371	1425	\N	\N	5000	fullyPaid
1329	1383	order_FbJXoCBHQsfw5N	o7vsFxzM_	2500	fullyPaid
1330	1384	\N	\N	1000	fullyPaid
1331	1385	\N	\N	2500	fullyPaid
1372	1426	\N	\N	5000	fullyPaid
1332	1386	order_FbJhoIQKmrkHgQ	mrB5r8Upu	2500	fullyPaid
1333	1387	\N	\N	2500	fullyPaid
1334	1388	\N	\N	1000	fullyPaid
1335	1389	\N	\N	1000	fullyPaid
1336	1390	\N	\N	2500	fullyPaid
1337	1391	\N	\N	2500	fullyPaid
1338	1392	\N	\N	2500	fullyPaid
1339	1393	\N	\N	2500	fullyPaid
1340	1394	\N	\N	1000	fullyPaid
1373	1427	\N	\N	5000	fullyPaid
1341	1395	order_FbN8p4It2HJnQo	reiGW1eC5	200	fullyPaid
1342	\N	order_FbNGV6ZkCrRTML	Ba9Af14Mz	200	notPaid
1374	1428	\N	\N	1000	fullyPaid
1343	1396	order_FbNIUlqVlXQhR3	bMZqB5DLh	200	fullyPaid
1344	\N	order_FbNLwijMOTkrCv	ojcjHvjpa	2500	notPaid
1345	\N	order_FbNMhfamy9T4Hz	-eImdMfgW	200	notPaid
1346	\N	order_FbNNk5mqkuUFBm	sawpnhQWM	2500	notPaid
1375	1429	\N	\N	1000	fullyPaid
1347	1398	order_FbNOHtalXwMknk	wpoNzj9jN	2500	fullyPaid
1348	1400	order_FbNZT7tdSehIOZ	D92cb8wRz	2500	fullyPaid
1349	1401	\N	\N	2500	fullyPaid
1350	1402	\N	\N	2500	fullyPaid
1351	1403	\N	\N	2500	fullyPaid
1352	1404	\N	\N	2500	fullyPaid
1353	1405	\N	\N	2500	fullyPaid
1354	1406	\N	\N	2500	fullyPaid
1355	1407	\N	\N	2500	fullyPaid
1356	1408	\N	\N	2500	fullyPaid
1357	1409	\N	\N	2500	fullyPaid
1358	1410	\N	\N	2500	fullyPaid
1359	1411	\N	\N	1000	fullyPaid
1360	1412	\N	\N	1000	fullyPaid
1361	1413	\N	\N	1000	fullyPaid
1362	1414	\N	\N	1000	fullyPaid
1363	1415	\N	\N	1000	fullyPaid
1364	\N	order_Fbf5rj3hKvJBya	CHD7yEt59	100	notPaid
1365	1416	\N	\N	1000	fullyPaid
1366	1417	\N	\N	1000	fullyPaid
1388	1442	order_FblPk2Wtd9WKlt	hk22TA8B2	5000	fullyPaid
1367	1418	order_FbhzNnTiZ1Tt5S	s6brARcnC	123	fullyPaid
1376	1430	order_FbkRSUMAeH9lCd	SaqIkXaOo	5000	fullyPaid
1368	1420	order_Fbij1t5xhud9px	h5xzQzIVY	500	fullyPaid
1369	1423	\N	\N	1000	fullyPaid
1370	1424	order_FbjE84uKciY3Ge	iAWR-cw8Z	1000	fullyPaid
1389	1443	\N	\N	1000	fullyPaid
1377	1431	order_FbkRzCaa4tDeoo	qBbaHg5p6	5000	fullyPaid
1378	1432	\N	\N	5000	fullyPaid
1379	1433	\N	\N	5000	fullyPaid
1380	1434	\N	\N	5000	fullyPaid
1381	1435	\N	\N	1000	fullyPaid
1382	1436	\N	\N	1000	fullyPaid
1383	1437	\N	\N	1000	fullyPaid
1384	1438	\N	\N	1000	fullyPaid
1385	1439	\N	\N	5000	fullyPaid
1386	1440	\N	\N	5000	fullyPaid
1387	1441	\N	\N	5000	fullyPaid
1394	1448	\N	\N	1000	fullyPaid
1390	1444	\N	\N	1000	fullyPaid
1391	1445	\N	\N	1000	fullyPaid
1392	1446	\N	\N	1000	fullyPaid
1393	1447	\N	\N	1000	fullyPaid
1395	1449	\N	\N	1000	fullyPaid
1396	1450	\N	\N	1000	fullyPaid
1397	1451	\N	\N	2000	fullyPaid
1398	1452	\N	\N	2000	fullyPaid
1399	\N	order_Fc073P5J8qhHiI	HsDH2yfuQ	5000	fullyPaid
1400	1453	\N	\N	1000	fullyPaid
1401	1454	\N	\N	1000	fullyPaid
1402	1455	\N	\N	1000	fullyPaid
1403	1456	\N	\N	1000	fullyPaid
1404	1457	\N	\N	1000	fullyPaid
1405	1458	\N	\N	1000	fullyPaid
1406	1459	\N	\N	2000	fullyPaid
1407	1460	\N	\N	1000	fullyPaid
1408	1461	\N	\N	1000	fullyPaid
1409	1462	\N	\N	2000	fullyPaid
1410	1463	\N	\N	2000	fullyPaid
1411	1464	\N	\N	2000	fullyPaid
1412	1465	\N	\N	2000	fullyPaid
1413	1466	\N	\N	2000	fullyPaid
1414	1467	\N	\N	2000	fullyPaid
1487	\N	order_Fe7piU0AzcZ0J2	4OiOcIRYE	2500	fullyPaid
1415	1468	order_Fc9TrDarig0LYN	9zpDVTb0B	2000	fullyPaid
1416	1469	\N	\N	1000	fullyPaid
1417	1470	\N	\N	1000	fullyPaid
1418	1471	\N	\N	5000	fullyPaid
1488	\N	order_FeCDoxZ4tpM1WY	ts0ViJoth	2000	notPaid
1419	1472	order_FcAHKhhQbTfb4q	fFyr3JElr	5000	fullyPaid
1489	\N	order_FeCDoxmvVw63O8	GlCgnigZb	2000	notPaid
1420	1473	order_FcAQVLxTPmH2Ii	JidaIgI6R	5000	fullyPaid
1421	1474	order_FcARlfnJdghBLb	4rcBoLL0Z	5000	fullyPaid
1422	1475	\N	\N	2000	fullyPaid
1423	1476	\N	\N	2000	fullyPaid
1424	1477	\N	\N	2000	fullyPaid
1425	1478	\N	\N	2000	fullyPaid
1426	1479	\N	\N	2000	fullyPaid
1427	1480	\N	\N	2000	fullyPaid
1428	1481	\N	\N	2000	fullyPaid
1429	1482	\N	\N	2000	fullyPaid
1430	1483	\N	\N	2000	fullyPaid
1431	1484	\N	\N	2000	fullyPaid
1432	1485	\N	\N	2000	fullyPaid
1433	1486	\N	\N	2000	fullyPaid
1434	1487	\N	\N	2000	fullyPaid
1435	1488	\N	\N	2000	fullyPaid
1436	1489	\N	\N	2000	fullyPaid
1437	1490	\N	\N	2000	fullyPaid
1438	1491	\N	\N	2000	fullyPaid
1439	1492	\N	\N	2000	fullyPaid
1440	1493	\N	\N	2000	fullyPaid
1441	1494	\N	\N	2000	fullyPaid
1442	1495	\N	\N	2000	fullyPaid
1443	1496	\N	\N	2000	fullyPaid
1444	1497	\N	\N	2000	fullyPaid
1445	1498	\N	\N	2000	fullyPaid
1446	1499	\N	\N	1000	fullyPaid
1447	1500	\N	\N	1000	fullyPaid
1448	1501	\N	\N	2000	fullyPaid
1449	1502	\N	\N	2000	fullyPaid
1450	1503	\N	\N	2000	fullyPaid
1451	1504	\N	\N	2000	fullyPaid
1452	1505	\N	\N	2000	fullyPaid
1453	1506	\N	\N	2000	fullyPaid
1454	1507	\N	\N	2000	fullyPaid
1455	1508	\N	\N	1000	fullyPaid
1456	1509	\N	\N	1000	fullyPaid
1457	1510	\N	\N	1000	fullyPaid
1458	1511	\N	\N	2000	fullyPaid
1459	\N	order_FdNz20zENhqn0d	uR9a49fLl	2000	notPaid
1460	1512	order_FdNz2VUPNUK1YB	d5Q6LrOqW	2000	fullyPaid
1461	1513	\N	\N	2500	fullyPaid
1462	1514	\N	\N	2500	fullyPaid
1463	1515	\N	\N	2500	fullyPaid
1464	1516	\N	\N	2500	fullyPaid
1465	\N	order_FdojRISrFdv7Ms	zqaD7ZZGD	1000	notPaid
1466	\N	order_FdorQxTjLR4FR5	ffdxWUrp2	1000	notPaid
1467	\N	order_FdorQxNCxHAXpY	_jKRi_AVe	1000	notPaid
1468	\N	order_FdorRiwulYzrym	Jye3HHUdZ	1000	notPaid
1469	1517	\N	\N	2000	fullyPaid
1470	1518	\N	\N	2000	fullyPaid
1471	1519	\N	\N	2000	fullyPaid
1472	1520	\N	\N	2000	fullyPaid
1473	1521	\N	\N	2000	fullyPaid
1474	1522	\N	\N	2000	fullyPaid
1475	1523	\N	\N	2000	fullyPaid
1476	1525	\N	\N	2000	fullyPaid
1477	1526	\N	\N	2000	fullyPaid
1478	1527	\N	\N	2000	fullyPaid
1479	1528	order_Fe5p8052o9SrLT	JHtohS5YI	2000	fullyPaid
1480	1529	\N	\N	2000	fullyPaid
1481	1530	\N	\N	2000	fullyPaid
1482	1531	\N	\N	2000	fullyPaid
1483	1532	\N	\N	2000	fullyPaid
1494	\N	order_FeOZxjafKWYxYA	rdX8ld4Wf	2000	fullyPaid
1491	1536	order_FeNEnUs2xCVJcB	K5yAR1xRC	2000	fullyPaid
1485	1534	order_Fe7oKmTBIszB89	uQJXeP8MY	2500	fullyPaid
1486	\N	order_Fe7ov5A6MQhBy8	G6bRaN4Il	2500	fullyPaid
1492	1538	order_FeNZEkeuqF0kwr	H9baqWhUQ	2000	fullyPaid
1495	1548	order_FeObzOtvwTX81i	jXt1GNarC	2000	fullyPaid
1493	1540	order_FeNazwY0kUMrMK	hd68nOk2B	2000	fullyPaid
1496	1546	order_FeOi0dCFl4srVC	uk3HWA1CZ	2000	fullyPaid
1490	1547	order_FeCDoyckHScFmV	KR8LVfNx0	2000	fullyPaid
1499	1551	order_FePlv89m6ORE72	5znxuEWIe	2500	fullyPaid
1497	1549	order_FePAJzHoCdGUNx	sIj3kH6xV	2000	fullyPaid
1498	1550	\N	\N	2000	fullyPaid
1501	\N	order_FeQr0gLvxxC4So	4XqIyB8x8	2000	notPaid
1484	1554	order_Fe7RkV4xCiLo6C	xN4Bg0DZL	2500	fullyPaid
1502	1553	order_FeQrB1wzvkk1jJ	cVLgHVSYx	2000	fullyPaid
1504	1556	\N	\N	2000	fullyPaid
1503	1555	order_FeRU8akUZ7KLgs	R2iALnu0M	2000	fullyPaid
1505	1557	\N	\N	2000	fullyPaid
1507	1559	\N	\N	2000	fullyPaid
1506	1558	order_FeSy9e6tqpVW3D	uOiMKUTWK	2000	fullyPaid
1508	1560	\N	\N	2000	fullyPaid
1509	1561	\N	\N	2000	fullyPaid
1510	\N	order_FeTxVlSyB7nemx	We-7Dbikn	2000	notPaid
1511	\N	order_FeTxXk2WxJAOaL	FulCJq9d6	2000	notPaid
1512	\N	order_FeTzovdtJansWk	x-_cPPUf1	2000	notPaid
1723	1748	\N	\N	5000	fullyPaid
1725	1750	\N	\N	5000	fullyPaid
1513	1562	order_FeU3V2VH6kTpgo	mxvqczttq	2000	fullyPaid
1876	1902	\N	\N	100	fullyPaid
1514	1563	order_FeU6Aqf0RliMIE	FH0FsEm_d	2000	fullyPaid
1559	1599	order_Fesn9NKEp5IOIJ	xT7cFxyxt	100	fullyPaid
1515	1564	order_FeU9tWbISwZvVr	RzuQAd1G6	2000	fullyPaid
1516	1565	\N	\N	2000	fullyPaid
1517	1566	\N	\N	2000	fullyPaid
1518	1567	\N	\N	5000	fullyPaid
1519	1568	\N	\N	5000	fullyPaid
1520	1569	order_FeUzUx2WasaFzp	5BXMJvovK	5000	fullyPaid
1521	1570	\N	\N	2000	fullyPaid
1522	1571	\N	\N	2000	fullyPaid
1597	\N	order_Fg9056qXMrJkWm	MXBD6Ht9Y	3000	fullyPaid
1523	1572	order_FeW8M6g2cKC0iL	RcqT9UR7i	5000	fullyPaid
1560	1600	order_FesuN7lGHt7wIy	kQ1vse-Is	100	fullyPaid
1524	1573	order_FeWBsceJANtSLi	mGh7PpqKa	5000	fullyPaid
1525	1574	\N	\N	2000	fullyPaid
1526	1575	order_FeXAWMpU9NVoIC	CO0Ec8TKJ	5000	fullyPaid
1588	1626	order_FfKaskgbLYw2Gx	d5gz2-uhm	1500	fullyPaid
1527	1576	order_FeXB0nFyPiUGQ3	pWqn4CDng	5000	fullyPaid
1561	1601	order_Fet20EMZGSPmbK	SV4yGggDN	2000	fullyPaid
1528	1577	order_FeXGlwwUGi0VGL	HrkRJ3d7Z	5000	fullyPaid
1529	1578	\N	\N	2000	fullyPaid
1530	1579	\N	\N	5000	fullyPaid
1531	1580	order_FeXUPAnDI1SPAe	IKqTikB9P	5000	fullyPaid
1587	\N	order_FfKae8Mx8wUhpj	DmeydHWhE	1500	fullyPaid
1532	1581	order_FeYKGpFhK7jJPl	v23BDlPK4	5000	fullyPaid
1562	1602	order_Fet90g1k9BPdHX	sdHozqjGh	100	fullyPaid
1533	1582	order_FeZMrgNNMrhDlc	C28s7jPEI	5000	fullyPaid
1534	1583	\N	\N	2000	fullyPaid
1535	\N	order_FeaO3lV5PrRgnE	cVynYsu0c	2000	notPaid
1536	\N	order_FeaT4LqCrFThix	SFzyTUORF	2000	notPaid
1537	\N	order_FeaazAOYo3STeT	BC5PCt10S	5000	fullyPaid
1563	1603	\N	\N	3000	fullyPaid
1538	1584	order_FeacWSkDh5Vojo	WuAkgVeU4	5000	fullyPaid
1539	1585	\N	\N	2000	fullyPaid
1540	\N	order_Feaf2wiKh3iGXH	UXn7d39_y	2000	notPaid
1564	1604	\N	\N	2000	fullyPaid
1565	1605	\N	\N	2000	fullyPaid
1541	1586	order_Feaf3I2M7sc3j2	dZ4M8G0wk8	2000	fullyPaid
1566	1606	\N	\N	2000	fullyPaid
1542	1587	order_FeaoKwhlHDPc0Y	mxXXvN7y0	2000	fullyPaid
1567	1607	\N	\N	2000	fullyPaid
1543	1590	order_Fen07IudXn8h3j	arSa_ZFlY	5000	fullyPaid
1544	\N	order_FenTiMitUNpVlD	fs4pzHjno	5000	notPaid
1545	\N	order_FenW6oSJjjs7z9	Rgjb6D_D8	5000	notPaid
1546	\N	order_FenWg7LgBAW3JL	sC1ztzV_o	5000	notPaid
1547	1591	\N	\N	2000	fullyPaid
1548	\N	order_FeoNsJHPFhlBOE	HU4CJeIIo	5000	notPaid
1549	\N	order_FepTjFVIaRAbFY	gtqMBv_WU	5000	notPaid
1550	\N	order_FepfX1TWsNVmJh	uLvqNfk3S	5000	notPaid
1551	\N	order_FepjdUvHwFUXEr	OZ2ekgxF2	5000	notPaid
1552	\N	order_FepkaaBEmmGGHV	kJ6rLAFXc	5000	notPaid
1500	1592	order_FePpggShW0guEf	Z_kUn32mc	2500	fullyPaid
1553	1593	\N	\N	3000	fullyPaid
1554	1594	\N	\N	3000	fullyPaid
1555	1595	\N	\N	3000	fullyPaid
1568	1608	\N	\N	3000	fullyPaid
1556	1596	order_Ferkpd1kIRpVwY	nlm6BgAPM	2000	fullyPaid
1569	1609	\N	\N	3000	fullyPaid
1557	1597	order_FesR2sRJUAA8z5	_CMMyH6Sk	3000	fullyPaid
1570	1610	\N	\N	3000	fullyPaid
1558	1598	order_FesZybbLqI1tBc	iMBtqjjS0	100	fullyPaid
1571	1611	\N	\N	3000	fullyPaid
1572	1612	\N	\N	3000	fullyPaid
1573	1613	\N	\N	2000	fullyPaid
1574	1614	\N	\N	2000	fullyPaid
1575	1615	\N	\N	2000	fullyPaid
1576	1616	\N	\N	2000	fullyPaid
1577	1617	\N	\N	2000	fullyPaid
1578	1618	\N	\N	2000	fullyPaid
1580	\N	order_FfJ2bygjtwH2Fp	BbY8WUaO8	2000	notPaid
1589	\N	order_FfKc9GMifwpSkL	klK4jmV1b	1500	notPaid
1581	1620	order_FfJ7ZzDgSVABbC	6e_QnkpdB	2000	fullyPaid
1582	\N	order_FfJ8s6e7zoqWa2	CcG-yzlil	5000	notPaid
1579	1621	\N	\N	2000	fullyPaid
1583	1622	order_FfJbLZjbNzCDTa	o_zoGwF--	150	fullyPaid
1584	1623	\N	\N	1500	fullyPaid
1585	1624	\N	\N	1500	fullyPaid
1586	1625	order_FfKXPNepbJUd5J	CsrWf9h33	1500	fullyPaid
1590	1627	order_FfKd4TcYeIRnhf	oEOwihecj	1500	fullyPaid
1591	1628	\N	\N	3000	fullyPaid
1592	1629	\N	\N	3000	fullyPaid
1593	1630	\N	\N	2000	fullyPaid
1594	1631	\N	\N	2000	fullyPaid
1595	1632	\N	\N	2000	fullyPaid
1596	1633	\N	\N	2000	fullyPaid
1598	\N	order_Fg91CjQ2gbAWCp	f-STp8iat	3000	fullyPaid
1599	1634	\N	\N	2000	fullyPaid
1600	1635	\N	\N	2000	fullyPaid
1601	1636	\N	\N	2000	fullyPaid
1603	1638	\N	\N	2000	fullyPaid
1602	1637	order_Fg9l6vYhsefSBI	fH4WVhwoT	2000	fullyPaid
1604	1639	order_FgQFGNlOXaDYeO	tSYRylki7	200	fullyPaid
1605	1640	order_FgQHWoNWiQAUDu	wbVlc1W01	200	fullyPaid
1606	1641	order_FgQIsi5QNMBOM2	gBeywxfGv	200	fullyPaid
1607	1642	order_FgQJU4ZyX6On0H	p-RWf7sC7	200	fullyPaid
1608	1643	order_FgQK6WJbL5ympq	hFScVDHvN	200	fullyPaid
1609	1649	order_FgQKefAJeHQS9c	C1Lo4BHMn	200	fullyPaid
1724	1749	\N	\N	5000	fullyPaid
1726	1751	\N	\N	2000	fullyPaid
1691	1716	\N	\N	2000	fullyPaid
1611	1646	order_FgQLj19HdYqjd6	nTwB4DRcG	200	fullyPaid
1692	1717	\N	\N	2000	fullyPaid
1612	1647	order_FgQMHBV7KxKLgV	nLYHacgyz	100	fullyPaid
1693	1718	\N	\N	5000	fullyPaid
1613	1648	order_FgQN00VavKalgv	kDZrOhu9Q	100	fullyPaid
1610	1650	order_FgQL9IipvL3NzB	wEZzf7cmV	200	fullyPaid
1614	1651	\N	\N	3000	fullyPaid
1694	1719	\N	\N	5000	fullyPaid
1615	1652	order_FgRg2iz98w7pZi	AAYWLAvJI	3000	fullyPaid
1616	1653	\N	\N	2000	fullyPaid
1617	1654	\N	\N	2000	fullyPaid
1618	\N	order_FhDtaqwjdt04Lq	jbXoqiBHM	1000	notPaid
1619	\N	order_FhDtaqSqEVOX6Y	GYoJjWTBl	1000	notPaid
1620	\N	order_FhDtaqNMprMt4t	SpO3J0Q46	1000	notPaid
1621	\N	order_FhDtaqoexYjCsE	FRgX4aBUV	1000	notPaid
1622	\N	order_FhDtbaETvkOsVl	Hbsv3QavF	1000	notPaid
1695	1720	\N	\N	5000	fullyPaid
1623	1655	order_FhDtbh9deFGwP3	AI5mr6ntDk	1000	fullyPaid
1624	\N	order_FhEcXbKn1G4kP1	Ox_N84E1_	2500	notPaid
1625	\N	order_FhEcXnAFUPL12a	neUzPH_Qt	2500	notPaid
1696	1721	\N	\N	5000	fullyPaid
1626	1656	order_FhEcXdajcOANgi	qgomVOPza	2500	fullyPaid
1627	\N	order_FhEe7dibA01Qw8	icnzFaxpu	200	notPaid
1628	\N	order_FhEe7e4gqXoqge	iNvN-QwrP	200	notPaid
1629	\N	order_FhEe7f9ttobSkl	qlFKQ21hGI	200	notPaid
1630	\N	order_FhEe7eY0kcaSPl	K6WQr9V2L	200	notPaid
1697	1722	\N	\N	2000	fullyPaid
1631	1657	order_FhEe7etGDWxJWv	v_5VzK1dIU	200	fullyPaid
1632	\N	order_FhFKwr3cXF39P7	G9bDd3CZ4	200	notPaid
1633	1658	\N	\N	5000	fullyPaid
1634	1659	\N	\N	2000	fullyPaid
1635	1660	\N	\N	2000	fullyPaid
1636	1661	\N	\N	2000	fullyPaid
1698	1723	\N	\N	2000	fullyPaid
1637	1662	order_FiTtPrEIN3T8SU	69k8IpNPJ	500	fullyPaid
1638	1663	\N	\N	2000	fullyPaid
1639	1664	\N	\N	2000	fullyPaid
1640	1665	\N	\N	2000	fullyPaid
1641	1666	\N	\N	2000	fullyPaid
1642	1667	\N	\N	2000	fullyPaid
1643	1668	\N	\N	2000	fullyPaid
1644	1669	\N	\N	1000	fullyPaid
1645	1670	\N	\N	1000	fullyPaid
1646	1671	\N	\N	1000	fullyPaid
1647	1672	\N	\N	1000	fullyPaid
1648	1673	\N	\N	1000	fullyPaid
1649	1674	\N	\N	1000	fullyPaid
1650	1675	\N	\N	2000	fullyPaid
1651	1676	\N	\N	5000	fullyPaid
1652	1677	\N	\N	5000	fullyPaid
1653	1678	\N	\N	5000	fullyPaid
1654	1679	\N	\N	5000	fullyPaid
1655	1680	\N	\N	5000	fullyPaid
1656	1681	\N	\N	5000	fullyPaid
1657	1682	\N	\N	5000	fullyPaid
1658	1683	\N	\N	5000	fullyPaid
1659	1684	\N	\N	5000	fullyPaid
1660	1685	\N	\N	5000	fullyPaid
1661	1686	\N	\N	5000	fullyPaid
1662	1687	\N	\N	5000	fullyPaid
1663	1688	\N	\N	5000	fullyPaid
1664	1689	\N	\N	5000	fullyPaid
1665	1690	\N	\N	5000	fullyPaid
1666	1691	\N	\N	5000	fullyPaid
1667	1692	\N	\N	5000	fullyPaid
1668	1694	\N	\N	5000	fullyPaid
1669	1693	\N	\N	5000	fullyPaid
1670	1695	\N	\N	5000	fullyPaid
1671	1696	\N	\N	5000	fullyPaid
1672	1697	\N	\N	5000	fullyPaid
1673	1698	\N	\N	5000	fullyPaid
1674	1699	\N	\N	5000	fullyPaid
1675	1700	\N	\N	5000	fullyPaid
1676	1701	\N	\N	5000	fullyPaid
1677	1702	\N	\N	5000	fullyPaid
1678	1703	\N	\N	5000	fullyPaid
1679	1705	\N	\N	5000	fullyPaid
1680	1704	\N	\N	5000	fullyPaid
1681	1706	\N	\N	5000	fullyPaid
1682	1707	\N	\N	5000	fullyPaid
1683	1708	\N	\N	5000	fullyPaid
1684	1709	\N	\N	5000	fullyPaid
1685	1710	\N	\N	5000	fullyPaid
1686	1711	\N	\N	5000	fullyPaid
1687	1712	\N	\N	5000	fullyPaid
1688	1713	\N	\N	5000	fullyPaid
1689	1714	\N	\N	5000	fullyPaid
1690	1715	\N	\N	5000	fullyPaid
1699	1724	\N	\N	2000	fullyPaid
1700	1725	\N	\N	5000	fullyPaid
1701	1726	\N	\N	5000	fullyPaid
1702	1727	\N	\N	5000	fullyPaid
1703	1728	\N	\N	5000	fullyPaid
1704	1729	\N	\N	5000	fullyPaid
1705	1730	\N	\N	5000	fullyPaid
1706	1731	\N	\N	5000	fullyPaid
1707	1732	\N	\N	5000	fullyPaid
1708	1733	\N	\N	2000	fullyPaid
1709	1734	\N	\N	2000	fullyPaid
1710	1735	\N	\N	2000	fullyPaid
1711	1736	\N	\N	2000	fullyPaid
1712	1737	\N	\N	2000	fullyPaid
1713	1738	\N	\N	2000	fullyPaid
1714	1739	\N	\N	2000	fullyPaid
1715	1740	\N	\N	2000	fullyPaid
1716	1741	\N	\N	2000	fullyPaid
1717	1742	\N	\N	2000	fullyPaid
1718	1743	\N	\N	2000	fullyPaid
1719	1744	\N	\N	2000	fullyPaid
1720	1745	\N	\N	2000	fullyPaid
1721	1746	\N	\N	2000	fullyPaid
1722	1747	\N	\N	5000	fullyPaid
1727	1752	\N	\N	5000	fullyPaid
1728	1753	\N	\N	2000	fullyPaid
1729	1754	\N	\N	5000	fullyPaid
1730	1755	\N	\N	5000	fullyPaid
1731	1756	\N	\N	5000	fullyPaid
1732	1757	\N	\N	5000	fullyPaid
1733	1758	\N	\N	5000	fullyPaid
1734	1759	\N	\N	2000	fullyPaid
1735	1760	\N	\N	2000	fullyPaid
1736	1761	\N	\N	2000	fullyPaid
1737	1763	\N	\N	5000	fullyPaid
1738	1762	\N	\N	5000	fullyPaid
1739	1764	\N	\N	5000	fullyPaid
1740	\N	order_FmmUtm0jbCycZp	Uc_m1mz_J	5000	notPaid
1741	1771	\N	\N	500	fullyPaid
1742	1772	\N	\N	500	fullyPaid
1743	1773	\N	\N	500	fullyPaid
1744	\N	order_Fnt4FrbfAqQa1Y	xyhBZpRRf	500	notPaid
1745	\N	order_Fnt4G3a6ciYVVd	aOxzV24Ssb	500	notPaid
1746	\N	order_Fnt4GHhQguxk2R	CJvCmIKau	500	notPaid
1747	\N	order_Fnt4GWYFvBA73p	AdLDJVLB4u	500	notPaid
2253	2283	\N	\N	1000	fullyPaid
1748	1774	order_FntCZhTw4jNQXO	u1OAINtiU	500	fullyPaid
1750	\N	order_FntkeaGVbC4eb6	sxuGM3i32	3500	notPaid
1749	1775	order_FntfiIwxTtS7mS	KEIUpZJFl	3500	fullyPaid
1751	1776	order_Fntv756QbVIGpi	nKl_Yee1i	3500	fullyPaid
1753	1780	order_FnwtJylXqtqwGI	RgbQGpt33	200	fullyPaid
1754	1781	order_Fnx1JD94JoXv4S	0a8xShK_6	500	fullyPaid
1752	1783	\N	\N	500	fullyPaid
2211	2247	\N	\N	1000	fullyPaid
2258	2288	\N	\N	1000	fullyPaid
1755	1782	order_FnxCMgFaHI0Oy8	jPYIxY7bV	100	fullyPaid
1756	\N	order_FnzNuwEQVTV9gP	Er3fzKVzP	2000	notPaid
1757	\N	order_FnzOxfvotaLiGu	9pojxvXW9	2000	notPaid
1758	\N	order_FnzR6hV9QgmMiS	wJy6jQG-t	2000	notPaid
1829	1856	\N	\N	5000	fullyPaid
1759	1784	order_FpAr3i8reJLM5B	gARqd5qak	200	fullyPaid
1830	1857	\N	\N	5000	fullyPaid
1760	1785	order_FpTMGMWmQWRNK8	hsDfC5z4V	500	fullyPaid
1831	1858	\N	\N	5000	fullyPaid
1762	\N	order_FpTaTgw8VS9gdA	MjzUwDayQ	3500	notPaid
1763	\N	order_FpTkFqjs5VPbWb	3AK6nagnx	3500	notPaid
1761	1787	order_FpTQGN2EJd2J74	ybhcUH2z2	500	fullyPaid
1764	1788	\N	\N	500	fullyPaid
1765	1789	\N	\N	1000	fullyPaid
1832	1859	\N	\N	5000	fullyPaid
1766	1797	order_Fscg0dYbGvRf7O	_6tv6cPp8	5000	fullyPaid
1767	1798	\N	\N	2000	fullyPaid
1768	1799	\N	\N	5000	fullyPaid
1769	1800	\N	\N	5000	fullyPaid
1770	1801	\N	\N	5000	fullyPaid
1771	1803	\N	\N	5000	fullyPaid
176	1811	\N	\N	\N	notPaid
1772	1812	\N	\N	2000	fullyPaid
1773	1813	\N	\N	2000	fullyPaid
1774	\N	order_FvQKWQg320ylik	aatTZ18oB	2000	notPaid
1775	\N	order_FvQM9i6vjEoeUO	Gg0M8GJUR	2000	notPaid
1776	\N	order_FvQMAABOYxLTda	B09v_U91Qc	2000	notPaid
1777	\N	order_FvQRuQczUzMNj3	xOUZu0FQS	2000	notPaid
1778	\N	order_FvQTFiJpScYlDg	nFrZE2A_A	2000	notPaid
1779	\N	order_FvQdYXmp0pwRF6	_UULTkMmP	2000	notPaid
1780	\N	order_FvUqBKD77seoS9	JMMF4fyIX	2000	notPaid
1781	\N	order_FvUqwcfvUxHwMY	ceq-FQCt5	5000	notPaid
1782	\N	order_FvUsNTquDe9Zin	IdOrTZr7j	5000	notPaid
1783	\N	order_FvUssWVbdx1ysO	uZgdFB4xA	5000	notPaid
1784	\N	order_FvUsseilzIKtKC	82zfz9HIF_	5000	notPaid
1785	\N	order_FvUuahBmIYsvrc	qfAZ8ukxJ	5000	notPaid
1833	1860	\N	\N	5000	fullyPaid
1786	1814	order_FwCnvXSGFPquma	E-5WGFRxN	2000	fullyPaid
1834	1861	\N	\N	5000	fullyPaid
1787	1815	order_FwJNbfTUn7LkqM	N8XBtYP7-	5000	fullyPaid
1835	1862	\N	\N	5000	fullyPaid
1788	1816	order_Fx5cB0DOnwuHnW	JgzKDp-Ts	5000	fullyPaid
1789	1817	\N	\N	500	fullyPaid
1790	1818	\N	\N	500	fullyPaid
1791	1819	\N	\N	500	fullyPaid
1792	1820	\N	\N	500	fullyPaid
1793	1821	\N	\N	500	fullyPaid
1794	1822	\N	\N	500	fullyPaid
1795	1823	\N	\N	500	fullyPaid
1796	1824	\N	\N	500	fullyPaid
1797	1825	\N	\N	500	fullyPaid
1798	1827	\N	\N	500	fullyPaid
1799	1828	\N	\N	500	fullyPaid
1800	\N	order_G53ZVuJrYQ0xRh	g041U6ptQ	2000	notPaid
1836	1863	\N	\N	5000	fullyPaid
1801	1829	order_G53bJg3vXLdUjj	slQxpznT2	2000	fullyPaid
1802	\N	order_G53dPBKrX78eNL	wvIvIE8U-	3000	notPaid
1803	1830	\N	\N	5000	fullyPaid
1804	1831	\N	\N	5000	fullyPaid
1805	1832	\N	\N	5000	fullyPaid
1806	1833	\N	\N	5000	fullyPaid
1807	1834	\N	\N	5000	fullyPaid
1808	1835	\N	\N	5000	fullyPaid
1809	1836	\N	\N	5000	fullyPaid
1810	1837	\N	\N	5000	fullyPaid
1811	1838	\N	\N	3500	fullyPaid
1812	1839	\N	\N	100	fullyPaid
1837	1864	\N	\N	5000	fullyPaid
1813	1840	order_G5knd2ECuLvCrY	-iCjw4umX	5000	fullyPaid
1838	1865	\N	\N	5000	fullyPaid
1814	1841	order_G5l11atdFTCClC	rKqXXYbBS	5000	fullyPaid
1815	1842	\N	\N	5000	fullyPaid
1816	1843	\N	\N	5000	fullyPaid
1817	1844	\N	\N	5000	fullyPaid
1818	1845	\N	\N	5000	fullyPaid
1819	1846	\N	\N	5000	fullyPaid
1820	1847	\N	\N	5000	fullyPaid
1821	1848	\N	\N	5000	fullyPaid
1822	1849	\N	\N	5000	fullyPaid
1823	1850	\N	\N	5000	fullyPaid
1824	1851	\N	\N	5000	fullyPaid
1825	1852	\N	\N	5000	fullyPaid
1826	1853	\N	\N	5000	fullyPaid
1827	1854	\N	\N	5000	fullyPaid
1828	1855	\N	\N	5000	fullyPaid
1839	1866	\N	\N	5000	fullyPaid
1840	1867	\N	\N	5000	fullyPaid
1841	1868	\N	\N	5000	fullyPaid
1842	1869	\N	\N	5000	fullyPaid
1843	1870	\N	\N	5000	fullyPaid
1844	1871	\N	\N	5000	fullyPaid
1845	1872	\N	\N	5000	fullyPaid
1846	1873	\N	\N	5000	fullyPaid
1847	1874	\N	\N	5000	fullyPaid
1848	1875	\N	\N	5000	fullyPaid
1849	1876	\N	\N	5000	fullyPaid
1850	1877	\N	\N	5000	fullyPaid
1851	1878	\N	\N	10	fullyPaid
1852	1879	\N	\N	10	fullyPaid
1853	1880	\N	\N	10	fullyPaid
1854	1881	\N	\N	10	fullyPaid
1855	1882	\N	\N	10	fullyPaid
1856	1883	\N	\N	10	fullyPaid
1857	1884	\N	\N	10	fullyPaid
1858	1885	\N	\N	10	fullyPaid
1859	1886	\N	\N	10	fullyPaid
1860	1887	\N	\N	10	fullyPaid
1861	1888	\N	\N	1000	fullyPaid
1862	\N	order_G6APnwp8vPagqA	MHdR_9fhP	1000	notPaid
1863	1889	order_G6AQBBMOFln5tW	U_FqLS7Ui	1000	fullyPaid
1864	1890	order_G6AVkdDvFCapEx	gD8Ikva57	1000	fullyPaid
1866	1892	order_G6Ab8FZfM2vnCA	LZZMJdafx	1000	fullyPaid
1868	\N	order_G6AhJt4wVUVdeb	SlVyXYFno	1000	notPaid
1867	1893	order_G6Af5KNJyssBKg	K9Bk7r7GG	1000	fullyPaid
1869	1894	order_G6AkPJfDwRgZvi	huJcwRQV6	1000	fullyPaid
1871	1896	\N	\N	1000	fullyPaid
1870	1895	order_G6At9McIkrHOKG	gM5W3X-5K	1000	fullyPaid
1872	1897	\N	\N	100	fullyPaid
1873	1898	\N	\N	100	fullyPaid
1874	1899	order_G6B5blwN11WUkx	lRVrMDkxl	100	fullyPaid
1875	1900	order_G6BF13XpBtS2td	4zMlGzrxi	100	fullyPaid
1865	1907	order_G6AaCQIn2BwtZE	-b-oHy3sK	1000	fullyPaid
1877	1903	order_G6Bp65bPIKGRvM	TJJEPGl2B	100	fullyPaid
1878	1904	order_G6BurrsxA9IibA	EEaNBeGYY	100	fullyPaid
1879	1905	order_G6C8cXoQ3ULN5G	eStuOthb4	200	fullyPaid
1880	1906	\N	\N	100	fullyPaid
1881	1908	\N	\N	1000	fullyPaid
1935	1966	\N	\N	1000	fullyPaid
1882	1909	order_G6D8ZRgMnv5GSY	RLkrAbwtH	1000	fullyPaid
1883	1910	order_G6D9TVc9NlH1qU	NM4DCF-eL	2000	fullyPaid
1936	1967	order_G7loWhM7ocAo6M	GA9rU1Jgc	1000	fullyPaid
1884	1911	order_G6DIpnGynOt6iN	tWr_5AsRP	1000	fullyPaid
1885	1912	\N	\N	1000	fullyPaid
1886	1913	\N	\N	1000	fullyPaid
1887	1914	\N	\N	1000	fullyPaid
1888	1915	\N	\N	1000	fullyPaid
1889	1916	\N	\N	1000	fullyPaid
1890	1917	\N	\N	1000	fullyPaid
1891	1918	\N	\N	1000	fullyPaid
1892	1919	order_G6WWyxu9OFKaC3	NGAqvOoFr	1000	fullyPaid
1893	1920	\N	\N	100	fullyPaid
1894	1921	\N	\N	1000	fullyPaid
1895	1922	\N	\N	1000	fullyPaid
1896	1923	\N	\N	1000	fullyPaid
1897	1924	\N	\N	1000	fullyPaid
1898	1925	\N	\N	100	fullyPaid
1899	1926	\N	\N	100	fullyPaid
1900	1927	\N	\N	100	fullyPaid
1901	1928	\N	\N	100	fullyPaid
1902	1929	\N	\N	5000	fullyPaid
1903	1930	\N	\N	500	fullyPaid
1904	1933	\N	\N	500	fullyPaid
1953	1984	\N	\N	10	fullyPaid
1905	1934	order_G7JExn1vFP98KB	5UAnRNNpS	500	fullyPaid
1906	1935	\N	\N	500	fullyPaid
1907	1936	\N	\N	500	fullyPaid
1908	1937	\N	\N	500	fullyPaid
1909	1938	\N	\N	500	fullyPaid
1910	1939	\N	\N	500	fullyPaid
1911	1940	\N	\N	500	fullyPaid
1937	1968	order_G7lsL9x8AEGEEv	qGwrCJlN3	2000	fullyPaid
1912	1941	order_G7PEKLr7HzUL8W	NmG3PVxGd	2000	fullyPaid
1914	1943	order_G7PtnQo3zwJXt5	mc0P0GULa	500	fullyPaid
1913	1944	order_G7PFqZfswCsRMM	fy3CQQrGZ	500	fullyPaid
1915	1945	\N	\N	500	fullyPaid
1916	1946	\N	\N	500	fullyPaid
1917	1948	\N	\N	500	fullyPaid
1938	1969	order_G7m2033I3BNrys	a3riHhZyM	2000	fullyPaid
1918	1949	order_G7hGRliEOfmW3m	kmf7VZxRu	500	fullyPaid
1919	1950	\N	\N	2000	fullyPaid
1922	\N	order_G7jLS2FwzTIU1M	d-9bkWtSL	500	notPaid
1962	1997	order_G8CIUvZLIvgAjp	e6nAJ5X4c	500	fullyPaid
1921	1952	order_G7jLFsB8k533o6	MlcDN5Njt	2000	fullyPaid
1923	1953	order_G7jMmBKehN3aXF	04had05JF	2000	fullyPaid
1924	1954	order_G7jNZqXKzSbxeh	rLAo479Vv	2000	fullyPaid
1939	1972	order_G7m3bpm5zVWmn1	XrlbrdXcB	2000	fullyPaid
1925	1955	order_G7jZHY3ElVk1wv	lk2pYcaF1	2000	fullyPaid
1926	1956	\N	\N	2000	fullyPaid
1927	1957	\N	\N	500	fullyPaid
1928	1958	\N	\N	500	fullyPaid
1940	\N	order_G7m5sQJ7UdFHOz	7yhNcruvy	100	notPaid
1929	1959	order_G7kqGKq5T9psyx	DqjdU3xGq	2000	fullyPaid
1941	1973	\N	\N	1000	fullyPaid
1930	1960	order_G7ksI4B0Wg2sob	-emifVITJ	500	fullyPaid
1931	1961	order_G7kykTBKn8G0mV	7qIkGu5ey	500	fullyPaid
1954	1985	order_G85tCQccm04DMc	JbN0Mq7L5	10	fullyPaid
1932	1962	order_G7l4lkRsGDJGZC	fQSjxz-AT	500	fullyPaid
1942	1974	order_G7mJSvfO0akJeZ	4e7dEBogE	1000	fullyPaid
1933	1963	order_G7l5pg8sExOYvy	K0Tp45-EN	500	fullyPaid
1934	1964	\N	\N	1000	fullyPaid
1955	1986	\N	\N	10	fullyPaid
1943	1975	order_G7mNuLEXI46xh8	mgVhFSsu8	1000	fullyPaid
1944	1976	order_G7mUZDteVrJKGi	z-pq5GnwN	2000	fullyPaid
1945	\N	order_G7maa5CaB2w3o8	iOwmp6HdC	2000	notPaid
1946	1977	order_G7mb2q8rDzHFXH	nUVpydAeO	2000	fullyPaid
1947	\N	order_G7mbRr91jkRIX2	TW5YF29AD	5000	notPaid
1948	\N	order_G7mbwG40hw1V02	Up_HX_Hae	5000	notPaid
1956	1987	order_G87fp2VdLC2oYL	oIx_qR2tz	500	fullyPaid
1950	1979	order_G7n2MGgtsiqzoW	wfB33pgER	1000	fullyPaid
1963	1999	\N	\N	500	fullyPaid
1951	1980	order_G85a7n2KUVyJn0	GAh6279wt	200	fullyPaid
1949	1981	order_G7meq9mqzftBcc	Rcz7MXiX-	2000	fullyPaid
1952	1982	\N	\N	10	fullyPaid
1957	1988	order_G87yu8DL6L1PCF	3CidUtrw9	500	fullyPaid
1958	1989	\N	\N	500	fullyPaid
1959	1990	\N	\N	500	fullyPaid
1920	1992	order_G7iz8SEqsk2GtB	okb8T4KAO	500	fullyPaid
1960	1994	order_G8CA9Hxch2dsWr	cP3GY6HBF	500	fullyPaid
1968	2003	order_G8CmiNVqJ7QGAf	ffRO39W4G	2000	fullyPaid
1964	2000	order_G8CUJJ4c6hIzSC	FAMMTTMwb	500	fullyPaid
1965	2001	order_G8CiTlie46KauL	osowGXgmQ	500	fullyPaid
1969	2004	order_G8Co9Y5ifEmmk6	bWbeoSEop	2000	fullyPaid
1966	2002	order_G8ClZPlWCTcKxI	9JYVY3IDH	2000	fullyPaid
1967	\N	order_G8CmXjs7blAyhs	6vW18K_YF	2000	notPaid
1973	2008	\N	\N	500	fullyPaid
1970	2005	\N	\N	500	fullyPaid
1971	2006	order_G8TUsW4R64HLwu	Kztm9TGfi	500	fullyPaid
1972	\N	order_G8U5X4TWwYxghW	T-ajae66X	1000	notPaid
1976	2011	\N	\N	250	fullyPaid
1974	2009	order_G8UGW3D2hnmqZ1	G9_s0aEjo	500	fullyPaid
1975	2010	order_G8UIdCbeYGYkMr	kr-IjIm-m	500	fullyPaid
1977	2012	\N	\N	250	fullyPaid
1978	2013	order_G8V1NeD9Be0PHa	WW1tYBNLf	900	fullyPaid
1979	2014	order_G8V55iVqfzHMSr	bt5v83z3t	900	fullyPaid
1980	2015	order_G8V5pFMbAUajlH	wQiOqdx9h	900	fullyPaid
1981	2016	order_G8V6NQZ33P7Oaj	awoz4NljP	900	fullyPaid
1983	2018	\N	\N	900	fullyPaid
1982	2017	order_G8X9jCyQrz0ytK	jWAJORIxI	900	fullyPaid
1984	\N	order_G8Xu3khKveN9qI	Og46CPwF1	400	notPaid
1985	\N	order_G8XuPMSxVXfvRp	J8SoQ661v	400	notPaid
1986	\N	order_G8Xuzrnu3JIHyb	hgj0gCmqU	400	notPaid
1987	\N	order_G8XyFquBcRWVgI	q52yDoVQ1	2000	notPaid
1988	\N	order_G8Y4OdwxRwy0Nh	h8f0D-Nv0	2000	notPaid
2044	2064	\N	\N	1500	fullyPaid
1989	2019	order_G8Y4iarsrH3sEc	IaTXMY6Xy	2000	fullyPaid
1990	2020	\N	\N	900	fullyPaid
1991	2021	\N	\N	900	fullyPaid
1992	2022	\N	\N	100	fullyPaid
1993	2023	\N	\N	100	fullyPaid
1994	2024	order_G8aHsAzhqT5uww	5pC4VYv36	100	fullyPaid
1995	2025	\N	\N	100	fullyPaid
1996	2026	order_G8aK0Lx5PA2wTY	v3G8T0AkR	100	fullyPaid
1997	2027	\N	\N	100	fullyPaid
1998	2028	\N	\N	100	fullyPaid
1999	2029	\N	\N	100	fullyPaid
2000	2030	\N	\N	100	fullyPaid
2001	2031	\N	\N	100	fullyPaid
2045	2065	order_GA603sS6L0I7gC	a5QPONrdQ	1500	fullyPaid
2002	2032	order_G8dQeImaZtdA20	8c3u2id4b	100	fullyPaid
2046	\N	order_GA7J7VRl3TtarL	MmSzxQvjR	1500	notPaid
2003	2033	order_G8dRjtzlbfi2qp	oX7xXbbNY	100	fullyPaid
2004	2035	\N	\N	500	fullyPaid
2005	2036	\N	\N	500	fullyPaid
2047	\N	order_GA8Pgr8tuRY97V	6Xx6FoGBS	1500	notPaid
2006	2038	order_G8dbaixS3wKwJC	9Xq5ZXqb7	500	fullyPaid
2048	\N	order_GA8cl9gNRHTFrL	R4B28E8wQ	1500	notPaid
2007	2045	order_G8divIk0S9DsUy	zVwUgKfe4	500	fullyPaid
2049	\N	order_GAAqXdGzIPV4II	9vS3Xc_0H	2500	notPaid
2008	2047	order_G8eeF9QTXXNrbF	Y3ivdaP9g	500	fullyPaid
2050	\N	order_GABjKWNhGwdE0u	9jP619OBZ	1500	notPaid
2009	2048	order_G8efwdzHKUJ3Mn	X9EjPBcwq	500	fullyPaid
2051	\N	order_GABx0wCMlcsEJs	_tOSYMdya	1500	notPaid
2010	2050	order_G8eja1hhsDL2oD	hpHVyfnrz	500	fullyPaid
2052	\N	order_GAC1OQGSTPso04	QNmQegMCf	1500	notPaid
2011	2051	order_G8emH6YdColXvK	OkLEMscmE	500	fullyPaid
1961	2052	order_G8CEzHEw6G028o	TpIlifZV4	500	fullyPaid
2053	\N	order_GACBSIfbZiUwWb	D8WO36Nim	1500	notPaid
2012	2053	order_G8sg7mKYdRQt6f	VSAlS1Ov5	200	fullyPaid
2013	\N	order_G8tG8PFYHmKJKl	DAJmScQf1	1000	fullyPaid
2014	\N	order_G8tHJL7LSc25kx	FSwg3Nal8	1005	notPaid
2015	2055	\N	\N	1005	fullyPaid
2016	2057	order_G8tLvjdFm0hTdf	W-U2OgS-j	1005	fullyPaid
2066	2083	\N	\N	2000	fullyPaid
2017	2058	order_G8tdtJg7oPQpEH	KMGpMzB-X	1005	fullyPaid
2018	\N	order_G8xJGOWon9LHqB	r_qzjJ7MI	200	notPaid
2019	\N	order_G8xKIC6ZpHgdA3	JjRFh8J9V	200	notPaid
2020	\N	order_G8xLIzFauz4AJ4	-rWbJU3VL	2500	notPaid
2021	2060	\N	\N	1000	fullyPaid
2022	\N	order_G8y23kUUkwRjZ6	LcHokWjyS	1000	notPaid
2023	\N	order_G8y3brbZPNnJuK	npeGeuaRl	2000	notPaid
2024	2061	\N	\N	1000	fullyPaid
2025	2062	\N	\N	1000	fullyPaid
2026	\N	order_G9LgCTAoBKlrfk	dkEvYJ0aU	2000	notPaid
2027	\N	order_G9LntqAPxCkpMM	c9qp3PlKz	2500	notPaid
2028	\N	order_G9LpMkDSxzseey	-c40bi6vw	2000	notPaid
2029	\N	order_G9M2MvjnQ9nM46	xYDdD0JeW	2000	notPaid
2030	\N	order_G9M3ZrYHwNTGFh	TZq_DG4Ka	2000	notPaid
2031	\N	order_G9M5B7Bg859LvX	RW4tv3_1S	2000	notPaid
2032	\N	order_G9M6fV7BcbS4SQ	DiYuG47T5	2000	notPaid
2033	\N	order_G9M8kClRfIhJ93	01zDpoXTr	2000	notPaid
2034	\N	order_G9M9ZBe54eURwu	8PiNidChR	2000	notPaid
2035	\N	order_G9MCcxj9tqsoZt	5-Fr0lAsq	2000	notPaid
2036	\N	order_G9ME0XHmX3lkKe	iL6oYgVuc	2000	notPaid
2037	\N	order_G9MVMSLgTEfsUI	8NloUuFF7	2500	notPaid
2038	\N	order_G9N6STXaiagcoa	abkE1MY3n	2000	notPaid
2039	\N	order_G9N6STtqaDPCFA	Lqf8KrmnAN	2000	notPaid
2040	\N	order_G9N8HBSRzLW3Mj	ouYegI1-l	2000	notPaid
2041	\N	order_G9N9TYpynopQnO	42hvu84Pc	2000	notPaid
2042	\N	order_G9NA7nJfRLqNFR	QFIqjYdwS	2000	notPaid
2043	\N	order_GA4sDasqJMU8wm	0O49399WS	1000	notPaid
2054	2066	order_GACEVj0tGS6u6X	dWEIhG_lc	1500	fullyPaid
2055	2067	order_GARVOKabI1Z4Jf	zcePLFasx	2000	fullyPaid
2056	2069	\N	\N	1500	fullyPaid
2057	2070	order_GAZt4kk9Tg5Mwp	sB1hjCt4T	1500	fullyPaid
2058	2071	\N	\N	1500	fullyPaid
2059	2073	\N	\N	1000	fullyPaid
2060	2076	\N	\N	1000	fullyPaid
2061	2077	order_GAb95rlnAOIqN2	TS3yeKFa7	1000	fullyPaid
2062	2078	order_GAbAlydrJgl2kR	ZjBPh_Smz	1000	fullyPaid
2063	2079	order_GAbDA09nC6x1cY	j3bhPHTeb	2000	fullyPaid
2068	2087	\N	\N	2000	fullyPaid
2064	2080	order_GAbJ27yDTpNREN	XZZR5f6S6	1000	fullyPaid
2065	2081	\N	\N	2000	fullyPaid
2067	2090	order_GBdk3Sbkt9iEA8	Dv2bxby3J	2000	fullyPaid
2069	2092	order_GBfrdwZMRhqmRx	SeW3NXFGc	2000	fullyPaid
2070	2093	\N	\N	2000	fullyPaid
2071	2094	\N	\N	2000	fullyPaid
2072	2095	\N	\N	2000	fullyPaid
2073	2097	\N	\N	2000	fullyPaid
2074	2098	order_GBhNtI9lD0IPrf	_CAgZaUSm	200	fullyPaid
2078	2106	order_GBjKSaGa73nBcz	NxmA5y0In	2000	fullyPaid
2076	2100	order_GBhOyhpSpL40MD	FoeeH2_Wc	2000	fullyPaid
2075	2104	\N	\N	2000	fullyPaid
2077	2105	\N	\N	2000	fullyPaid
2079	2108	\N	\N	1500	fullyPaid
2080	2109	\N	\N	1500	fullyPaid
2081	2129	order_GBkDiYAH7q6aac	eHePtPY7Q	1500	fullyPaid
2082	2130	order_GBksIXbsTYQdhl	REQEJqKYv	1500	fullyPaid
2083	2133	order_GBkus15qiKJOnS	gQTee5yuT	100	fullyPaid
2085	2134	order_GBlI9KSOBdRXRQ	s-pdxQ6Sx	1500	fullyPaid
2084	2135	order_GBlI4Qpw9vyB5a	wvdF7zOlJ	1500	fullyPaid
2086	2136	order_GBmcVGf7ALgQbb	tAzeMSP4n	1500	fullyPaid
2087	2137	order_GC2r6hsRF5SLqf	IJWKXz_qC	1000	fullyPaid
2088	2138	order_GC2x748CKcV2pV	E6T71RSZb	1000	fullyPaid
2089	2139	order_GC3xWAuD9nEFGY	kDWF4pbfV	1000	fullyPaid
2090	2140	order_GC40So3VBii49s	RkQHLuozN	1000	fullyPaid
2092	\N	order_GC5KSnJf281sSw	RseHZek5D	1000	notPaid
2091	2141	order_GC5Jz6Pyap5loq	z8vUiihoq	1000	fullyPaid
2164	2209	\N	\N	1500	fullyPaid
2093	2142	order_GC5KrruwdTaKbr	SqV2UnG7_	1000	fullyPaid
2165	2210	\N	\N	1500	fullyPaid
2094	2144	order_GC5O5LzAd5cvnj	DfIOhLfUA	1000	fullyPaid
2166	2211	\N	\N	1500	fullyPaid
2095	2145	order_GC5W5Pi3ZW1XMC	WFDfx62hV	1000	fullyPaid
2167	2212	\N	\N	1500	fullyPaid
2096	2146	order_GC5Wqg6zHo2c9S	OtXzxr3uY	1000	fullyPaid
2168	2213	\N	\N	1500	fullyPaid
2097	2147	order_GC731AnoUZJq15	kw_Js_SeN	1500	fullyPaid
2169	2214	\N	\N	1500	fullyPaid
2098	2148	order_GC7653LG2iwHil	gKcVnDeAZ	1500	fullyPaid
2170	2215	\N	\N	1500	fullyPaid
2099	2149	order_GC7AwIpbu03uJ9	5jVW_7Ili	1500	fullyPaid
2100	\N	order_GCtJUY3TxAsdXy	Ur9EbL5hi	1500	notPaid
2101	\N	order_GDih7vVrX24nLr	jjPIETdPL	1500	notPaid
2171	2216	\N	\N	1500	fullyPaid
2102	2150	order_GDim5gH0s3XAAT	wW_ftQ76S	1500	fullyPaid
2172	2217	\N	\N	1500	fullyPaid
2103	2151	order_GE01yoDDPArMeX	kDy6pkunq	1500	fullyPaid
2173	2218	\N	\N	1500	fullyPaid
2104	2152	order_GE91Vy6msNNnMi	527sbb6TK	1500	fullyPaid
2174	2219	\N	\N	1500	fullyPaid
2105	2153	order_GENJjCO0pi4d0q	i0iRwqPM4	1500	fullyPaid
2106	2154	\N	\N	1500	fullyPaid
2107	2155	\N	\N	1500	fullyPaid
2108	2156	\N	\N	1500	fullyPaid
2175	2220	\N	\N	1500	fullyPaid
2109	2157	order_GEsIpkumRP8BVv	ESw2O4ffC	1500	fullyPaid
2110	2158	\N	\N	1500	fullyPaid
2111	2159	\N	\N	1500	fullyPaid
2112	2160	\N	\N	1500	fullyPaid
2113	2161	\N	\N	1500	fullyPaid
2114	2162	\N	\N	1500	fullyPaid
2115	2163	\N	\N	1500	fullyPaid
2116	2164	\N	\N	1500	fullyPaid
2117	2165	\N	\N	1500	fullyPaid
2118	2166	\N	\N	1500	fullyPaid
2119	2168	\N	\N	1500	fullyPaid
2120	2169	\N	\N	1500	fullyPaid
2121	2170	\N	\N	1500	fullyPaid
2122	2171	\N	\N	1500	fullyPaid
2123	2172	\N	\N	1500	fullyPaid
2124	2173	\N	\N	1500	fullyPaid
2125	2174	\N	\N	1500	fullyPaid
2126	2175	\N	\N	1500	fullyPaid
2127	2176	\N	\N	1500	fullyPaid
2128	2177	\N	\N	1500	fullyPaid
2129	2178	\N	\N	1500	fullyPaid
2130	2179	\N	\N	1500	fullyPaid
2176	2221	\N	\N	1500	fullyPaid
2131	2180	order_GGTjeC9qrt8Gxn	kPjZQznTg	1500	fullyPaid
2132	2181	\N	\N	1500	fullyPaid
2133	2182	\N	\N	1500	fullyPaid
2134	2183	\N	\N	1500	fullyPaid
2135	2184	\N	\N	1500	fullyPaid
2136	2185	\N	\N	1500	fullyPaid
2137	\N	order_GGVxUU4gWDxma3	dxasgDiE_	1500	notPaid
2138	\N	order_GGVxUUrk5JVOwg	1RNIdzBLF	1500	fullyPaid
2139	\N	order_GGWEzrd3Uv3XwF	cvBrZtaeI	1500	notPaid
2140	\N	order_GGWEzlSLaZbsLO	OGCDXrKsE	1500	notPaid
2141	2186	order_GGWF3tMv5jc9lj	R03-KlSiU	1500	fullyPaid
2142	2187	order_GGWSjsTMqGbtlT	mB8dfJTib	2000	fullyPaid
2143	2188	\N	\N	1500	fullyPaid
2144	2189	\N	\N	1500	fullyPaid
2145	2190	\N	\N	1500	fullyPaid
2146	2191	\N	\N	1500	fullyPaid
2147	2192	\N	\N	1500	fullyPaid
2148	2193	\N	\N	1500	fullyPaid
2149	2194	\N	\N	1500	fullyPaid
2150	2195	\N	\N	1500	fullyPaid
2151	2196	\N	\N	1500	fullyPaid
2177	2222	order_GGvazL98xHXOuA	HWIGIJdCb	1500	fullyPaid
2152	2197	order_GGqFF0slFHD9M0	JhybnYRd_	1500	fullyPaid
2153	2198	\N	\N	1500	fullyPaid
2154	2199	\N	\N	1500	fullyPaid
2155	2200	\N	\N	1500	fullyPaid
2156	2201	\N	\N	1500	fullyPaid
2157	2202	\N	\N	1500	fullyPaid
2158	2203	\N	\N	1500	fullyPaid
2159	2204	\N	\N	1500	fullyPaid
2160	2205	\N	\N	1500	fullyPaid
2161	2206	\N	\N	1500	fullyPaid
2162	2207	\N	\N	1500	fullyPaid
2163	2208	\N	\N	1500	fullyPaid
2178	\N	order_GGvcoS4HeThCoM	suRQNLj5X	1500	notPaid
2180	\N	order_GGveUQmtmyoCVd	VVofTtLIB	1500	notPaid
2179	2225	order_GGvdtH616Hk9eb	ssow-Ik4a	1500	fullyPaid
2192	2233	\N	\N	1	fullyPaid
2181	2226	order_GGvmTbw6LrnyEu	aMRoM-H17	1500	fullyPaid
2187	\N	order_GGvrHBLHdiOZVp	w-K3GICB0	1500	fullyPaid
2182	2227	order_GGvn7TcAgfrI8e	1qmbUbqN7	1500	fullyPaid
2183	\N	order_GGvnlJPWgqc1Qi	76g01kC-o	1500	notPaid
2184	\N	order_GGvo2cB4in5rxn	N1BE9o_ZZ	1500	notPaid
2188	2229	order_GGvrHDATqcOC7r	obveGTHWry	1500	fullyPaid
2186	\N	order_GGvpoZQcu7l5mQ	62EF-8sGx	1500	fullyPaid
2185	2228	order_GGvpguqoYpvikW	lJUccwCVl	1500	fullyPaid
2193	2234	\N	\N	1	fullyPaid
2189	2230	order_GGwO2DlVZvaF0m	cBDAntr64	1	fullyPaid
2194	2235	\N	\N	5000	fullyPaid
2190	2231	order_GGwR9s0V9qyhkG	v4066-B4g	1	fullyPaid
2191	2232	\N	\N	1	fullyPaid
2195	\N	order_GIqhLHx9OU5EjU	1yTnlzLgJ	5000	notPaid
2196	2236	\N	\N	1	fullyPaid
2197	2237	\N	\N	1	fullyPaid
2198	\N	order_GJDzRbY4fJHizk	m9G1BDEHV	1	notPaid
2200	\N	order_GJGJH8b49uC5yp	MmzUNx6wU	1	notPaid
2199	2238	order_GJE0ivwP5rzZbk	IxqAnOimU	1	fullyPaid
2201	2239	\N	\N	1	fullyPaid
2202	\N	order_GJX5574YljgEXb	1Ev0iPWhP	1	notPaid
2204	2241	\N	\N	1	fullyPaid
2203	2240	order_GJX6aExtKSPMpZ	YW1KuqjTf	1	fullyPaid
2205	2242	\N	\N	1	fullyPaid
2206	2243	order_GL7Xgi86vXjtWG	l7MJGEkTW	2000	fullyPaid
2207	2244	order_GLCmfbJREzGpqK	0ZevII5Ep	1000	fullyPaid
2209	\N	order_GLCq1E1OMFtxIC	Lc8sgBKSa	1000	fullyPaid
2208	2245	order_GLCpwwFhJHuRQj	UiPSApucV	1000	fullyPaid
2210	2246	\N	\N	1000	fullyPaid
2230	2265	order_GNudmQwq9QsAe3	hdOhibot-	1000	fullyPaid
2212	2248	order_GLDoeJcY0LW2Ot	leKcsd-k7	1000	fullyPaid
2213	2249	\N	\N	1000	fullyPaid
2271	2301	order_GQjbpvgVXzS1f4	6GioBcDdM	1000	fullyPaid
2214	2250	order_GLECpwt3zshFsG	r1bpwQLLV	1000	fullyPaid
2231	2266	order_GNv1sfdb93NSZ6	RoPyLbcRp	1000	fullyPaid
2285	2315	order_GRvU8ZHZ8UCuKR	gh1A10ra_	2000	fullyPaid
2215	2251	order_GLEdjnuMS4PsGx	tdleiEeao	1000	fullyPaid
2264	2294	order_GPgS2Sr9W0UYP0	2a0xfyJFT	1000	fullyPaid
2232	2267	order_GNxDsTWQ0d0EQu	HKSERO13V	200	fullyPaid
2216	2252	order_GLF3ZbaIc6xUzc	QO8DjM-eD	1000	fullyPaid
2272	2302	order_GQjxCFQfUfBHjQ	WLsQ5yvi7	1000	fullyPaid
2265	2295	\N	\N	1000	fullyPaid
2217	2253	order_GLFiYkSwUwDnCI	sdfHCLJ8m	1000	fullyPaid
2233	2268	order_GNxSpi8dw9kZXg	KXtPcsBeh	1000	fullyPaid
2218	2254	order_GLGJRzK3PIWo5J	N4kVauqz6	1000	fullyPaid
2234	2269	order_GNyHMk3b9bhH54	W-i4VSS5r	1000	fullyPaid
2219	2255	order_GLbAAWKnvFQ7RZ	MQL0YR9Lk	1000	fullyPaid
2220	2256	\N	\N	1000	fullyPaid
2235	\N	order_GO3Tv9MJeIxelz	qfaXKlS0C	1000	notPaid
2273	2303	order_GQkCYnYRTtnvkx	0BxKK98gV	1000	fullyPaid
2221	2257	order_GLbwyLz8wTC2qd	A7e8CBr0l	1000	fullyPaid
2222	\N	order_GLg3fk55Ar12ws	wbkC24UpJ	1000	notPaid
2274	2304	\N	\N	1000	fullyPaid
2236	2270	order_GO4lEalHE9LyhV	pxxXM1D0T	1000	fullyPaid
2223	2258	order_GLg52E2bSOuUn7	glPc5lZK8	1000	fullyPaid
2275	\N	order_GQlcgGuWZEeevV	C7V-Q1f1b	1000	notPaid
2266	2296	order_GPxGiURnFGTuuJ	BmJobVXUs	1000	fullyPaid
2224	2259	order_GM2jHh1c6hCOGW	AqOOpqNqr	1000	fullyPaid
2237	2271	order_GOJqXeTea8Rgx5	aWrZ4yHmd	1000	fullyPaid
2225	2260	order_GM2tVCiAQ3TEUR	t4FieZgBd	1000	fullyPaid
2226	2261	\N	\N	1000	fullyPaid
2238	2272	order_GOM9Z5la5HyZj9	UvgFaSvzb	1000	fullyPaid
2227	2262	order_GNUMBqRUpTgKuR	B7LWA3epD	1000	fullyPaid
2276	2305	order_GQoXgtXBa8BRbR	xlHqiNnhG	1000	fullyPaid
2228	2263	order_GNuXj56hdbEDkH	lCdOLXrmq	1000	fullyPaid
2239	2273	order_GOQEntEb4nsWBB	jUXG4Bkgt	1000	fullyPaid
2286	2316	order_GRxS7Nzvr1FYKe	1r_vitmzu	1000	fullyPaid
2229	2264	order_GNua98J2ayZr5B	wrlm8gimd	1000	fullyPaid
2267	2297	order_GPxiLDCebIVT2S	mw2ygbKIr	1000	fullyPaid
2240	2274	order_GOQH2Y9xB4NS7S	4oqwHbtTY	1000	fullyPaid
2277	2306	order_GR2GsGV0oL7qWB	zXLEn1No_	1000	fullyPaid
2241	2275	order_GORREh7Mri9Tz4	GiRU-cYCn	1000	fullyPaid
2242	\N	order_GOUMLqRJjdDmu3	Z52uRJMoe	3000	notPaid
2243	\N	order_GOUpQ0QlXPdsMQ	N4_H_HX_N	5000	notPaid
2244	\N	order_GOUqby9KT8AgVp	pX-qAYwCZ	5000	notPaid
2278	2307	order_GRQXinmj0n6rar	JZKuycmQU	1000	fullyPaid
2245	2276	order_GOUrzdZV1QOtJM	ym7cSdxcT	200	fullyPaid
2268	2298	order_GPxkI60q10Kxft	oXLu86SGc	1000	fullyPaid
2246	2277	order_GOVJUucbbEUei0	ljL8LreDS	1000	fullyPaid
2279	2309	\N	\N	2000	fullyPaid
2280	2310	\N	\N	2000	fullyPaid
2247	2278	order_GOVKcOKq5ibm0V	inaMZaYse	1000	fullyPaid
2248	\N	order_GOVTbXbgzXH2Ie	BEBv0q5w3	2000	notPaid
2249	2279	order_GOVUGxVm0sJ7sZ	M4vqPtOxu	2000	fullyPaid
2281	2311	order_GRZyBMJDdhPSxW	CyyXCoP-4	1000	fullyPaid
2269	2299	order_GPxyK018wwcaK2	6JsWTXiRp	1000	fullyPaid
2250	2280	order_GOVrlWC05pJzmR	7xjFHAoiX	1000	fullyPaid
2287	2317	order_GSFX0HuK9WwR2Q	UovfOlP0g	2000	fullyPaid
2251	2281	order_GOcVqJnBznnrIb	LWenkisNW	100	fullyPaid
2282	2313	order_GRa69WzP5mq3f2	SkdCwCFdS	1000	fullyPaid
2254	2284	order_GOfGHapgxL44Pm	PHuk01ywA	1000	fullyPaid
2270	2300	order_GQdpXNPouXI3EW	TVmbfubH-	1000	fullyPaid
2255	2285	order_GOfjmos56vjcne	D8mmKaQPQ	1000	fullyPaid
2288	\N	order_GSFfSDEGr8zyk2	_le7-nuww	2000	notPaid
2283	2314	order_GRp7GRYZRRhlqv	0NsDL3m0_	2000	fullyPaid
2256	2286	order_GOfypznIgS1rCL	3NsIqVIl0	1000	fullyPaid
2284	\N	order_GRvU7vD9MFTz1L	j-zLsjNyi	2000	notPaid
2257	2287	order_GPZ6bloDVXKsFA	2Fx3tlyXC	1000	fullyPaid
2293	2321	order_GSGKEuaRzYaLIW	uAsxbPga_	2000	fullyPaid
2289	\N	order_GSFggLcSFEYnIC	BJJib0iOh	2000	notPaid
2259	2289	order_GPZAfkLWyAkXEk	3cLL3kYie	1000	fullyPaid
2294	\N	order_GSJct8mNDjcPGd	5ScntV1rP	2000	notPaid
2260	2290	order_GPZi6Tgc23F4Pl	54SWG2RqW	1000	fullyPaid
2261	2291	\N	\N	1000	fullyPaid
2262	2292	\N	\N	1000	fullyPaid
2263	2293	\N	\N	1000	fullyPaid
2290	2318	order_GSFhLivBBDdV2r	LLKBzTtTW	2000	fullyPaid
2295	\N	order_GSJctVPPXXr2GU	sQXMkqsHh	2000	notPaid
2291	2319	order_GSG7xTeelIpt7g	NqKFfNjy7	2000	fullyPaid
2292	2320	order_GSGCSRSg9ejVR7	ZsdEsWizW	2000	fullyPaid
2296	2322	order_GSJctmPu1vW1JA	-RdrYbnzl0	2000	fullyPaid
\.


--
-- Data for Name: prescription; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prescription (id, appointment_id, appointment_date, hospital_logo, hospital_name, doctor_name, doctor_signature, patient_name, prescription_url) FROM stdin;
21	2169	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	hb fgh	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/hb%20fgh/prescription/prescription-21.pdf
22	2169	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	hb fgh	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/hb%20fgh/prescription/prescription-22.pdf
23	2169	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	hb fgh	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/hb%20fgh/prescription/prescription-23.pdf
24	2169	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	hb fgh	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/hb%20fgh/prescription/prescription-24.pdf
16	2162	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gf gfg	https://virujh-cloud.s3.amazonaws.com/virujh/gf%20gfg/prescription/prescription-16.pdf
17	2165	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	hth hxvb	https://virujh-cloud.s3.amazonaws.com/virujh/hth%20hxvb/prescription/prescription-17.pdf
18	2166	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	sdd bvv	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/sdd%20bvv/prescription/prescription-18.pdf
19	2167	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	err nn	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/err%20nn/prescription/prescription-19.pdf
20	2168	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	err nn	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/err%20nn/prescription/prescription-20.pdf
25	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-25.pdf
26	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-26.pdf
27	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-27.pdf
28	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-28.pdf
29	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-29.pdf
30	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-30.pdf
31	2171	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-31.pdf
32	2172	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-32.pdf
33	2172	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-33.pdf
34	2172	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-34.pdf
35	2172	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-35.pdf
36	2173	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	hgh ss	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/hgh%20ss/prescription/prescription-36.pdf
37	2174	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	sgers sregg	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/sgers%20sregg/prescription/prescription-37.pdf
38	2175	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	j jhj	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/j%20jhj/prescription/prescription-38.pdf
39	2176	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	abhilash c	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/abhilash%20c/prescription/prescription-39.pdf
40	2177	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	hardf yu	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/hardf%20yu/prescription/prescription-40.pdf
41	2177	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	hardf yu	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/hardf%20yu/prescription/prescription-41.pdf
42	2177	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	hardf yu	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/hardf%20yu/prescription/prescription-42.pdf
43	2178	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	abhilash c	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/abhilash%20c/prescription/prescription-43.pdf
44	2179	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	srinivas yadav	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/srinivas%20yadav/prescription/prescription-44.pdf
45	2179	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	srinivas yadav	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/srinivas%20yadav/prescription/prescription-45.pdf
46	2179	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	srinivas yadav	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/srinivas%20yadav/prescription/prescription-46.pdf
47	2181	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	err nn	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/err%20nn/prescription/prescription-47.pdf
48	2181	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	err nn	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/err%20nn/prescription/prescription-48.pdf
49	2181	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	err nn	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/err%20nn/prescription/prescription-49.pdf
50	2181	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	err nn	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/err%20nn/prescription/prescription-50.pdf
51	2180	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	srinivas yadav	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/srinivas%20yadav/prescription/prescription-51.pdf
52	2180	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	srinivas yadav	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/srinivas%20yadav/prescription/prescription-52.pdf
53	2184	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	err nn	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/err%20nn/prescription/prescription-53.pdf
54	2185	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Dharani Antharvedi	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Dharani%20Antharvedi/prescription/prescription-54.pdf
55	2185	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Dharani Antharvedi	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Dharani%20Antharvedi/prescription/prescription-55.pdf
56	2185	2020-12-23	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Dharani Antharvedi	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Dharani%20Antharvedi/prescription/prescription-56.pdf
57	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-57.pdf
58	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-58.pdf
59	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-59.pdf
60	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-60.pdf
61	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-61.pdf
392	2311	2021-01-20	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	John Wick	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/John%20Wick/prescription/prescription-392.pdf
63	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-63.pdf
62	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-62.pdf
65	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-65.pdf
66	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-66.pdf
67	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-67.pdf
64	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-64.pdf
68	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-68.pdf
69	2189	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-69.pdf
70	2191	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ramesh V	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramesh%20V/prescription/prescription-70.pdf
71	2191	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ramesh V	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramesh%20V/prescription/prescription-71.pdf
72	2191	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ramesh V	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramesh%20V/prescription/prescription-72.pdf
73	2191	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ramesh V	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramesh%20V/prescription/prescription-73.pdf
74	2191	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ramesh V	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramesh%20V/prescription/prescription-74.pdf
75	2191	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ramesh V	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramesh%20V/prescription/prescription-75.pdf
76	2191	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ramesh V	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ramesh%20V/prescription/prescription-76.pdf
77	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-77.pdf
78	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-78.pdf
79	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-79.pdf
80	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-80.pdf
81	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-81.pdf
83	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-83.pdf
82	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-82.pdf
84	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-84.pdf
85	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-85.pdf
86	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-86.pdf
87	2190	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-87.pdf
88	2194	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Hdjdjk Hdjdk	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Hdjdjk%20Hdjdk/prescription/prescription-88.pdf
89	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-89.pdf
90	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-90.pdf
91	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-91.pdf
92	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-92.pdf
94	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-94.pdf
93	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-93.pdf
95	2196	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	firstName lastName	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/firstName%20lastName/prescription/prescription-95.pdf
96	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-96.pdf
97	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-97.pdf
98	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-98.pdf
99	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-99.pdf
100	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-100.pdf
101	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-101.pdf
102	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-102.pdf
103	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-103.pdf
104	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-104.pdf
105	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-105.pdf
106	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-106.pdf
107	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-107.pdf
108	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-108.pdf
109	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-109.pdf
111	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-111.pdf
110	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-110.pdf
112	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-112.pdf
113	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-113.pdf
114	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-114.pdf
115	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-115.pdf
116	2199	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	varun kumar	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/varun%20kumar/prescription/prescription-116.pdf
117	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-117.pdf
118	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-118.pdf
119	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-119.pdf
120	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-120.pdf
121	2199	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	varun kumar	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/varun%20kumar/prescription/prescription-121.pdf
122	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-122.pdf
123	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-123.pdf
124	2199	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	varun kumar	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/varun%20kumar/prescription/prescription-124.pdf
125	2199	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	varun kumar	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/varun%20kumar/prescription/prescription-125.pdf
126	2201	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	firstName lastName	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/firstName%20lastName/prescription/prescription-126.pdf
127	2204	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-127.pdf
128	2205	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Hdjdjk Hdjdk	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Hdjdjk%20Hdjdk/prescription/prescription-128.pdf
129	2207	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Dean Ambrose	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Dean%20Ambrose/prescription/prescription-129.pdf
130	2209	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	arun de	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/arun%20de/prescription/prescription-130.pdf
131	2209	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	arun de	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/arun%20de/prescription/prescription-131.pdf
132	2209	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	arun de	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/arun%20de/prescription/prescription-132.pdf
133	2210	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	asdfasd 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/asdfasd%20/prescription/prescription-133.pdf
134	2211	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Goku G	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Goku%20G/prescription/prescription-134.pdf
135	2216	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-135.pdf
136	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-136.pdf
137	2216	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-137.pdf
138	2216	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-138.pdf
139	2217	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	firstName lastName	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/firstName%20lastName/prescription/prescription-139.pdf
140	2219	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-140.pdf
141	2219	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-141.pdf
142	2220	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	sunil jay	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/sunil%20jay/prescription/prescription-142.pdf
143	2221	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Hdjdjk Hdjdk	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Hdjdjk%20Hdjdk/prescription/prescription-143.pdf
144	2220	2020-12-24	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	sunil jay	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/sunil%20jay/prescription/prescription-144.pdf
145	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-145.pdf
146	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-146.pdf
147	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-147.pdf
148	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-148.pdf
149	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-149.pdf
150	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-150.pdf
151	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-151.pdf
152	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-152.pdf
153	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-153.pdf
154	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-154.pdf
155	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-155.pdf
157	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-157.pdf
156	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-156.pdf
158	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-158.pdf
159	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-159.pdf
162	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-162.pdf
161	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-161.pdf
163	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-163.pdf
164	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-164.pdf
160	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-160.pdf
165	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-165.pdf
168	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-168.pdf
167	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-167.pdf
166	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-166.pdf
169	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-169.pdf
170	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-170.pdf
172	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-172.pdf
171	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-171.pdf
174	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-174.pdf
173	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-173.pdf
176	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-176.pdf
175	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-175.pdf
177	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-177.pdf
178	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-178.pdf
179	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-179.pdf
180	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-180.pdf
182	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-182.pdf
183	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-183.pdf
185	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-185.pdf
181	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-181.pdf
186	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-186.pdf
184	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-184.pdf
188	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-188.pdf
189	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-189.pdf
187	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-187.pdf
190	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
191	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
192	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
193	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
194	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
195	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
196	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
197	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
198	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
199	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
200	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
201	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
202	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
203	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
204	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
205	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
206	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
207	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
208	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
209	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
210	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
211	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
212	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
213	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
214	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
215	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
216	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
217	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
218	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
219	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
220	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
221	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
222	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	\N
223	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.amazonaws.com/virujh/gayatri%20A/prescription/prescription-223.pdf
225	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-225.pdf
224	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-224.pdf
226	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-226.pdf
227	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-227.pdf
228	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-228.pdf
229	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-229.pdf
230	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-230.pdf
231	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-231.pdf
232	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-232.pdf
233	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-233.pdf
234	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-234.pdf
236	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-236.pdf
235	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-235.pdf
237	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-237.pdf
238	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-238.pdf
239	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-239.pdf
240	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-240.pdf
241	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-241.pdf
242	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-242.pdf
243	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-243.pdf
244	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-244.pdf
245	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-245.pdf
246	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-246.pdf
247	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-247.pdf
248	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-248.pdf
249	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-249.pdf
250	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-250.pdf
251	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-251.pdf
252	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-252.pdf
253	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-253.pdf
254	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-254.pdf
255	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-255.pdf
256	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-256.pdf
257	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-257.pdf
258	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-258.pdf
259	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-259.pdf
260	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-260.pdf
262	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-262.pdf
261	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-261.pdf
263	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-263.pdf
264	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-264.pdf
265	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-265.pdf
266	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-266.pdf
267	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-267.pdf
269	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-269.pdf
268	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-268.pdf
270	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-270.pdf
271	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-271.pdf
272	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-272.pdf
273	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-273.pdf
274	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-274.pdf
275	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-275.pdf
276	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-276.pdf
277	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-277.pdf
278	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-278.pdf
279	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-279.pdf
280	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-280.pdf
281	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-281.pdf
282	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-282.pdf
283	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-283.pdf
284	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-284.pdf
285	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-285.pdf
286	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-286.pdf
288	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-288.pdf
287	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-287.pdf
289	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-289.pdf
290	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-290.pdf
291	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-291.pdf
292	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-292.pdf
294	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-294.pdf
293	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-293.pdf
295	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-295.pdf
297	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-297.pdf
296	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-296.pdf
298	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-298.pdf
299	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-299.pdf
300	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-300.pdf
302	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-302.pdf
303	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-303.pdf
301	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-301.pdf
304	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-304.pdf
305	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-305.pdf
306	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-306.pdf
307	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-307.pdf
308	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-308.pdf
309	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-309.pdf
310	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-310.pdf
313	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-313.pdf
311	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-311.pdf
312	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-312.pdf
314	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-314.pdf
315	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-315.pdf
316	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-316.pdf
317	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-317.pdf
318	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-318.pdf
319	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-319.pdf
320	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-320.pdf
321	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-321.pdf
322	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-322.pdf
323	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-323.pdf
324	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-324.pdf
325	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-325.pdf
326	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-326.pdf
327	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-327.pdf
328	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-328.pdf
329	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-329.pdf
330	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-330.pdf
331	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-331.pdf
332	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-332.pdf
333	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-333.pdf
334	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-334.pdf
335	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-335.pdf
336	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-336.pdf
338	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-338.pdf
337	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-337.pdf
339	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-339.pdf
340	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-340.pdf
341	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-341.pdf
342	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-342.pdf
343	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-343.pdf
344	2236	2020-12-30	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-344.pdf
345	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-345.pdf
346	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-346.pdf
347	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-347.pdf
348	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-348.pdf
349	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-349.pdf
350	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-350.pdf
351	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-351.pdf
352	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-352.pdf
353	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-353.pdf
354	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-354.pdf
355	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-355.pdf
356	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-356.pdf
357	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-357.pdf
358	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-358.pdf
359	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-359.pdf
360	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-360.pdf
361	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-361.pdf
362	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-362.pdf
363	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-363.pdf
364	251	2020-07-29	\N	Apollo hospitalss	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-364.pdf
365	251	2020-07-29	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-365.pdf
366	251	2020-07-29	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-366.pdf
367	251	2020-07-29	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-367.pdf
368	251	2020-07-29	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	gayatri A	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/gayatri%20A/prescription/prescription-368.pdf
369	2253	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-369.pdf
370	2253	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-370.pdf
371	2253	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-371.pdf
372	2253	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-372.pdf
373	2254	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-373.pdf
374	2254	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-374.pdf
375	2254	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-375.pdf
376	2254	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-376.pdf
377	2254	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-377.pdf
378	2254	2021-01-04	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-378.pdf
379	2243	2021-01-05	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-379.pdf
380	2243	2021-01-05	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-380.pdf
381	2259	2021-01-06	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Gdhs Gsjs	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Gdhs%20Gsjs/prescription/prescription-381.pdf
382	2259	2021-01-06	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Gdhs Gsjs	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Gdhs%20Gsjs/prescription/prescription-382.pdf
383	2260	2021-01-06	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-383.pdf
384	2270	2021-01-12	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-384.pdf
385	2270	2021-01-12	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-385.pdf
386	2270	2021-01-12	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-386.pdf
387	2271	2021-01-12	\N	Apollo Hospitals	Sreeram Valluri	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-387.pdf
388	2272	2021-01-12	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	vijaya lakshmi  T 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/vijaya%20lakshmi%20%20T%20/prescription/prescription-388.pdf
389	2283	2021-01-13	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Ponni pa	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Ponni%20pa/prescription/prescription-389.pdf
390	2284	2021-01-13	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Sunder 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Sunder%20/prescription/prescription-390.pdf
391	2285	2021-01-13	\N	Apollo Hospitals	Shalini Shetty	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGHomN6o3VHRvm-lllm5B0zWqbOQwdggippA&usqp=CAU	Sunder 	https://virujh-cloud.s3.ap-south-1.amazonaws.com/virujh/Sunder%20/prescription/prescription-391.pdf
\.


--
-- Data for Name: tabesample; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tabesample (id, name, place) FROM stdin;
\.


--
-- Data for Name: work_schedule_day; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.work_schedule_day (id, doctor_id, date, is_active, doctor_key) FROM stdin;
\.


--
-- Data for Name: work_schedule_interval; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.work_schedule_interval (id, start_time, end_time, work_schedule_day_id, is_active) FROM stdin;
\.


--
-- Name: account_details_account_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_details_account_details_id_seq', 1, false);


--
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq', 1, false);


--
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_doc_config_appointment_doc_config_id_seq', 2063, true);


--
-- Name: appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_id_seq', 2322, true);


--
-- Name: appointment_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_seq', 17, true);


--
-- Name: communication_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.communication_type_id_seq', 1, false);


--
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_can_resch_doc_config_can_resch_id_seq', 2, true);


--
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq', 520, true);


--
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq', 578, true);


--
-- Name: docconfigid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.docconfigid_seq', 86, true);


--
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_can_resch_doc_config_can_resch_id_seq', 1, false);


--
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_pre_consultation_doctor_config_id_seq', 1, false);


--
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_preconsultation_doctor_config_id_seq', 9, true);


--
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_details_doctor_id_seq', 109, true);


--
-- Name: doctor_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_doctor_id_seq', 1, false);


--
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interval_days_interval_days_id_seq', 1, false);


--
-- Name: medicine_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medicine_id_seq', 609, true);


--
-- Name: message_metadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_metadata_id_seq', 1, false);


--
-- Name: message_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_template_id_seq', 1, false);


--
-- Name: message_template_placeholders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_template_placeholders_id_seq', 1, false);


--
-- Name: message_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_type_id_seq', 1, false);


--
-- Name: openvidu_session_openvidu_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.openvidu_session_openvidu_session_id_seq', 10522, true);


--
-- Name: openvidu_session_token_openvidu_session_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.openvidu_session_token_openvidu_session_token_id_seq', 12546, true);


--
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_details_patient_details_id_seq', 958, true);


--
-- Name: patient_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_report_id_seq', 51, true);


--
-- Name: payment_details_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_details_payment_id_seq', 2296, true);


--
-- Name: prescription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prescription_id_seq', 392, true);


--
-- Name: tabesample_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tabesample_id_seq', 1, false);


--
-- Name: work_schedule_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_schedule_day_id_seq', 1, false);


--
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_schedule_interval_id_seq', 1, false);


--
-- Name: account_details account_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_details_pkey PRIMARY KEY (account_details_id);


--
-- Name: account_details account_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_key_unique UNIQUE (account_key);


--
-- Name: appointment_cancel_reschedule appointment_cancel_reschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT appointment_cancel_reschedule_pkey PRIMARY KEY (appointment_cancel_reschedule_id);


--
-- Name: appointment_doc_config appointment_doc_config_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT appointment_doc_config_id PRIMARY KEY (appointment_doc_config_id);


--
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id);


--
-- Name: communication_type communication_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.communication_type
    ADD CONSTRAINT communication_type_pkey PRIMARY KEY (id);


--
-- Name: doctor_config_can_resch doc_config_can_resch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_can_resch
    ADD CONSTRAINT doc_config_can_resch_pkey PRIMARY KEY (doc_config_can_resch_id);


--
-- Name: doc_config doc_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doc_config_pkey PRIMARY KEY (id);


--
-- Name: doc_config_schedule_day doc_config_schedule_day_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_config_schedule_day_id PRIMARY KEY (id);


--
-- Name: doc_config_schedule_interval doc_config_schedule_interval_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_config_schedule_interval_id PRIMARY KEY (id);


--
-- Name: doctor_config_pre_consultation doctor_config_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_pre_consultation
    ADD CONSTRAINT doctor_config_id PRIMARY KEY (doctor_config_id);


--
-- Name: doctor doctor_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_id PRIMARY KEY ("doctorId");


--
-- Name: doctor doctor_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_key_unique UNIQUE (doctor_key);


--
-- Name: interval_days interval_days_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interval_days
    ADD CONSTRAINT interval_days_id PRIMARY KEY (interval_days_id);


--
-- Name: medicine medicine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine
    ADD CONSTRAINT medicine_pkey PRIMARY KEY (id);


--
-- Name: message_metadata message_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_metadata_pkey PRIMARY KEY (id);


--
-- Name: message_template message_template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template
    ADD CONSTRAINT message_template_pkey PRIMARY KEY (id);


--
-- Name: message_template_placeholders message_template_placeholders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_template_placeholders_pkey PRIMARY KEY (id);


--
-- Name: message_type message_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_type
    ADD CONSTRAINT message_type_pkey PRIMARY KEY (id);


--
-- Name: openvidu_session openvidu_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session
    ADD CONSTRAINT openvidu_session_pkey PRIMARY KEY (openvidu_session_id);


--
-- Name: openvidu_session_token openvidu_session_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_token_pkey PRIMARY KEY (openvidu_session_token_id);


--
-- Name: patient_details patient_details_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_details
    ADD CONSTRAINT patient_details_id PRIMARY KEY (id);


--
-- Name: patient_report patient_report_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_report
    ADD CONSTRAINT patient_report_id PRIMARY KEY (id);


--
-- Name: payment_details payment_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_id PRIMARY KEY (id);


--
-- Name: prescription prescriptionId; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescription
    ADD CONSTRAINT "prescriptionId" UNIQUE (id) INCLUDE (id);


--
-- Name: tabesample tabesample_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabesample
    ADD CONSTRAINT tabesample_pkey PRIMARY KEY (id);


--
-- Name: work_schedule_day work_schedule_day_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_day
    ADD CONSTRAINT work_schedule_day_pkey PRIMARY KEY (id);


--
-- Name: work_schedule_interval work_schedule_interval_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT work_schedule_interval_pkey PRIMARY KEY (id);


--
-- Name: fki_app_doc_con_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_app_doc_con_to_app_id ON public.appointment_doc_config USING btree (appointment_id);


--
-- Name: fki_can_resch_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_can_resch_to_app_id ON public.appointment_cancel_reschedule USING btree (appointment_id);


--
-- Name: fki_doc_config_to_doc_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doc_config_to_doc_key ON public.doctor_config_pre_consultation USING btree (doctor_key);


--
-- Name: fki_doc_sched_to_doc_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doc_sched_to_doc_id ON public.doc_config_schedule_day USING btree (doctor_id);


--
-- Name: fki_doctor_to_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doctor_to_account ON public.doctor USING btree (account_key);


--
-- Name: fki_int_days_to_wrk_sched_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_int_days_to_wrk_sched_id ON public.interval_days USING btree (wrk_sched_id);


--
-- Name: fki_interval_to_wrk_sched_con_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_interval_to_wrk_sched_con_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");


--
-- Name: fki_interval_to_wrk_sched_config_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_interval_to_wrk_sched_config_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");


--
-- Name: fki_payment_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_payment_to_app_id ON public.payment_details USING btree (appointment_id);


--
-- Name: fki_workScheduleIntervalToDay; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_workScheduleIntervalToDay" ON public.work_schedule_interval USING btree (work_schedule_day_id);


--
-- Name: appointment_doc_config app_doc_con_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT app_doc_con_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- Name: prescription appointmentId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescription
    ADD CONSTRAINT "appointmentId" FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- Name: appointment_cancel_reschedule can_resch_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT can_resch_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- Name: message_metadata communication_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT communication_type_id FOREIGN KEY (communication_type_id) REFERENCES public.communication_type(id);


--
-- Name: doc_config_schedule_interval doc_sched_interval_to_day; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_sched_interval_to_day FOREIGN KEY ("docConfigScheduleDayId") REFERENCES public.doc_config_schedule_day(id) NOT VALID;


--
-- Name: doc_config_schedule_day doc_sched_to_doc_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_sched_to_doc_id FOREIGN KEY (doctor_id) REFERENCES public.doctor("doctorId") NOT VALID;


--
-- Name: doc_config doctor_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doctor_key FOREIGN KEY (doctor_key) REFERENCES public.doctor(doctor_key);


--
-- Name: doctor doctor_to_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_to_account FOREIGN KEY (account_key) REFERENCES public.account_details(account_key);


--
-- Name: message_template_placeholders message_template_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_template_id FOREIGN KEY (message_template_id) REFERENCES public.message_template(id);


--
-- Name: message_metadata message_template_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_template_id FOREIGN KEY (message_template_id) REFERENCES public.message_template(id);


--
-- Name: message_template_placeholders message_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_type_id FOREIGN KEY (message_type_id) REFERENCES public.message_type(id);


--
-- Name: message_metadata message_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_type_id FOREIGN KEY (message_type_id) REFERENCES public.message_type(id);


--
-- Name: openvidu_session_token openvidu_session_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_id FOREIGN KEY (openvidu_session_id) REFERENCES public.openvidu_session(openvidu_session_id);


--
-- Name: payment_details payment_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- Name: medicine prescription_id_medicine; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine
    ADD CONSTRAINT prescription_id_medicine FOREIGN KEY (prescription_id) REFERENCES public.prescription(id);


--
-- Name: work_schedule_interval workScheduleIntervalToDay; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT "workScheduleIntervalToDay" FOREIGN KEY (work_schedule_day_id) REFERENCES public.work_schedule_day(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

