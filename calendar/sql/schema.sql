--To Create the dump file from PG-ADMIN use Format:"Plain", Enable:"Pre-data", "Data", "Post-data", "Use Column Inserts", "Use Insert Commands"
-- PostgreSQL database dump
--
--
CREATE TYPE public.overbookingtype AS ENUM (
    'Per Hour',
    'Per day'
);


ALTER TYPE public.overbookingtype OWNER TO postgres;

SET default_tablespace = '';

--
-- TOC entry 197 (class 1259 OID 16489)
-- Name: account_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_details (
    account_key character varying(200) NOT NULL,
    hospital_name character varying(200) NOT NULL,
    street1 character varying(100),
    street2 character varying(100),
    city character varying(100),
    state character varying NOT NULL,
    pincode character varying(100) NOT NULL,
    phone bigint NOT NULL,
    support_email character varying(100),
    account_details_id integer NOT NULL
);


ALTER TABLE public.account_details OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 16487)
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
-- TOC entry 4031 (class 0 OID 0)
-- Dependencies: 196
-- Name: account_details_account_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_details_account_details_id_seq OWNED BY public.account_details.account_details_id;


--
-- TOC entry 199 (class 1259 OID 16502)
-- Name: appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment (
    id integer NOT NULL,
    doctor_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    appointment_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    payment_status boolean,
    is_active boolean,
    is_cancel boolean DEFAULT false,
    created_by character varying,
    created_id bigint,
    cancelled_by character varying(100),
    cancelled_id bigint
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16513)
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
-- TOC entry 200 (class 1259 OID 16511)
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
-- TOC entry 4032 (class 0 OID 0)
-- Dependencies: 200
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq OWNED BY public.appointment_cancel_reschedule.appointment_cancel_reschedule_id;


--
-- TOC entry 203 (class 1259 OID 16527)
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
-- TOC entry 202 (class 1259 OID 16525)
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
-- TOC entry 4033 (class 0 OID 0)
-- Dependencies: 202
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq OWNED BY public.appointment_doc_config.appointment_doc_config_id;


--
-- TOC entry 198 (class 1259 OID 16500)
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
-- TOC entry 4034 (class 0 OID 0)
-- Dependencies: 198
-- Name: appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_id_seq OWNED BY public.appointment.id;


--
-- TOC entry 216 (class 1259 OID 16751)
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
-- TOC entry 220 (class 1259 OID 24635)
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
    over_booking_count bigint,
    overbooking_enable boolean DEFAULT false,
    "overBooking_type" public.overbookingtype,
    consultation_session_timings character varying
);


ALTER TABLE public.doc_config OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16587)
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
-- TOC entry 217 (class 1259 OID 16753)
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
-- TOC entry 4035 (class 0 OID 0)
-- Dependencies: 217
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;


--
-- TOC entry 204 (class 1259 OID 16544)
-- Name: doc_config_schedule_day; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doc_config_schedule_day (
    doctor_id bigint NOT NULL,
    day_of_week character varying(50) NOT NULL,
    id integer NOT NULL,
    doctor_key character varying
);


ALTER TABLE public.doc_config_schedule_day OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24666)
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
-- TOC entry 4036 (class 0 OID 0)
-- Dependencies: 222
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq OWNED BY public.doc_config_schedule_day.id;


--
-- TOC entry 205 (class 1259 OID 16552)
-- Name: doc_config_schedule_interval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doc_config_schedule_interval (
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    doc_config_schedule_day_id bigint NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.doc_config_schedule_interval OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24672)
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
-- TOC entry 4037 (class 0 OID 0)
-- Dependencies: 223
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq OWNED BY public.doc_config_schedule_interval.id;


--
-- TOC entry 221 (class 1259 OID 24663)
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
-- TOC entry 4038 (class 0 OID 0)
-- Dependencies: 221
-- Name: docconfigid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.docconfigid_seq OWNED BY public.doc_config.id;


--
-- TOC entry 207 (class 1259 OID 16568)
-- Name: doctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor (
    doctor_id integer NOT NULL,
    doctor_name character varying(100) NOT NULL,
    account_key character varying(200) NOT NULL,
    doctor_key character varying(200) NOT NULL,
    experience bigint NOT NULL,
    speciality character varying(200) NOT NULL,
    qualification character varying(500),
    photo character varying(500),
    number bigint,
    signature character varying(500),
    first_name character varying(100),
    last_name character varying(100),
    registration_number character varying(200),
    email character varying(200)
);


ALTER TABLE public.doctor OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16585)
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
-- TOC entry 4039 (class 0 OID 0)
-- Dependencies: 208
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;


--
-- TOC entry 211 (class 1259 OID 16598)
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
-- TOC entry 210 (class 1259 OID 16596)
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
-- TOC entry 4040 (class 0 OID 0)
-- Dependencies: 210
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;


--
-- TOC entry 218 (class 1259 OID 16755)
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
-- TOC entry 4041 (class 0 OID 0)
-- Dependencies: 218
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;


--
-- TOC entry 219 (class 1259 OID 16757)
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
-- TOC entry 4042 (class 0 OID 0)
-- Dependencies: 219
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_details_doctor_id_seq OWNED BY public.doctor.doctor_id;


--
-- TOC entry 206 (class 1259 OID 16566)
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
-- TOC entry 4043 (class 0 OID 0)
-- Dependencies: 206
-- Name: doctor_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_doctor_id_seq OWNED BY public.doctor.doctor_id;


--
-- TOC entry 215 (class 1259 OID 16642)
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
-- TOC entry 214 (class 1259 OID 16640)
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
-- TOC entry 4044 (class 0 OID 0)
-- Dependencies: 214
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interval_days_interval_days_id_seq OWNED BY public.interval_days.interval_days_id;


--
-- TOC entry 225 (class 1259 OID 24691)
-- Name: patient_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_details (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    landmark character varying(100),
    country character varying(100) NOT NULL,
    registration_number character varying(200),
    address character varying(400),
    state character varying(100) NOT NULL,
    pincode character varying(100),
    email character varying(100),
    photo character varying(100),
    phone bigint,
    patient_id bigint
);


ALTER TABLE public.patient_details OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24689)
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
-- TOC entry 4045 (class 0 OID 0)
-- Dependencies: 224
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_details_patient_details_id_seq OWNED BY public.patient_details.id;


--
-- TOC entry 213 (class 1259 OID 16628)
-- Name: payment_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_details (
    id integer NOT NULL,
    appointment_id bigint NOT NULL,
    is_paid boolean DEFAULT false,
    refund character varying(100)
);


ALTER TABLE public.payment_details OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16626)
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
-- TOC entry 4046 (class 0 OID 0)
-- Dependencies: 212
-- Name: payment_details_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_details_payment_id_seq OWNED BY public.payment_details.id;


--
-- TOC entry 227 (class 1259 OID 24709)
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
-- TOC entry 226 (class 1259 OID 24707)
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
-- TOC entry 4047 (class 0 OID 0)
-- Dependencies: 226
-- Name: work_schedule_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.work_schedule_day_id_seq OWNED BY public.work_schedule_day.id;


--
-- TOC entry 229 (class 1259 OID 24717)
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
-- TOC entry 228 (class 1259 OID 24715)
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
-- TOC entry 4048 (class 0 OID 0)
-- Dependencies: 228
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.work_schedule_interval_id_seq OWNED BY public.work_schedule_interval.id;


--
-- TOC entry 3785 (class 2604 OID 16764)
-- Name: account_details account_details_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details ALTER COLUMN account_details_id SET DEFAULT nextval('public.account_details_account_details_id_seq'::regclass);


--
-- TOC entry 3786 (class 2604 OID 16505)
-- Name: appointment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment ALTER COLUMN id SET DEFAULT nextval('public.appointment_id_seq'::regclass);


--
-- TOC entry 3788 (class 2604 OID 16765)
-- Name: appointment_cancel_reschedule appointment_cancel_reschedule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule ALTER COLUMN appointment_cancel_reschedule_id SET DEFAULT nextval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq'::regclass);


--
-- TOC entry 3789 (class 2604 OID 16766)
-- Name: appointment_doc_config appointment_doc_config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config ALTER COLUMN appointment_doc_config_id SET DEFAULT nextval('public.appointment_doc_config_appointment_doc_config_id_seq'::regclass);


--
-- TOC entry 3813 (class 2604 OID 24665)
-- Name: doc_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config ALTER COLUMN id SET DEFAULT nextval('public.docconfigid_seq'::regclass);


--
-- TOC entry 3790 (class 2604 OID 24668)
-- Name: doc_config_schedule_day id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq'::regclass);


--
-- TOC entry 3791 (class 2604 OID 24674)
-- Name: doc_config_schedule_interval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq'::regclass);


--
-- TOC entry 3792 (class 2604 OID 16769)
-- Name: doctor doctor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor ALTER COLUMN doctor_id SET DEFAULT nextval('public.doctor_details_doctor_id_seq'::regclass);


--
-- TOC entry 3793 (class 2604 OID 16770)
-- Name: doctor_config_can_resch doc_config_can_resch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_can_resch ALTER COLUMN doc_config_can_resch_id SET DEFAULT nextval('public.doc_config_can_resch_doc_config_can_resch_id_seq'::regclass);


--
-- TOC entry 3794 (class 2604 OID 16771)
-- Name: doctor_config_pre_consultation doctor_config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_pre_consultation ALTER COLUMN doctor_config_id SET DEFAULT nextval('public.doctor_config_preconsultation_doctor_config_id_seq'::regclass);


--
-- TOC entry 3797 (class 2604 OID 16772)
-- Name: interval_days interval_days_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interval_days ALTER COLUMN interval_days_id SET DEFAULT nextval('public.interval_days_interval_days_id_seq'::regclass);


--
-- TOC entry 3815 (class 2604 OID 24694)
-- Name: patient_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_details ALTER COLUMN id SET DEFAULT nextval('public.patient_details_patient_details_id_seq'::regclass);


--
-- TOC entry 3795 (class 2604 OID 16773)
-- Name: payment_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details ALTER COLUMN id SET DEFAULT nextval('public.payment_details_payment_id_seq'::regclass);


--
-- TOC entry 3816 (class 2604 OID 24712)
-- Name: work_schedule_day id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_day_id_seq'::regclass);


--
-- TOC entry 3817 (class 2604 OID 24720)
-- Name: work_schedule_interval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_interval_id_seq'::regclass);


--
-- TOC entry 3992 (class 0 OID 16489)
-- Dependencies: 197
-- Data for Name: account_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.account_details (account_key, hospital_name, street1, street2, city, state, pincode, phone, support_email, account_details_id) VALUES ('Acc_1', 'Apollo Hospitals', 'Greams Lane', 'Thousand Lights', 'Chennai', 'Tamil Nadu', '600006', 9623456256, 'chennai@apollohospitals.com', 1);
INSERT INTO public.account_details (account_key, hospital_name, street1, street2, city, state, pincode, phone, support_email, account_details_id) VALUES ('Acc_2', 'Dr Kamakshi Memorial Hospital', 'Kasturba Nagar', 'st Adyar', 'Chennai', 'Tamil Nadu', '600020', 9623456257, 'kamashimemorialhospital@gmail.com', 2);
INSERT INTO public.account_details (account_key, hospital_name, street1, street2, city, state, pincode, phone, support_email, account_details_id) VALUES ('Acc_3', 'Dr Mehtas Hospital', 'Nichols road', 'chetpet', 'Chennai', 'Tamil Nadu', '600031', 9623456258, 'drmehtashospital@gmail.com', 3);
INSERT INTO public.account_details (account_key, hospital_name, street1, street2, city, state, pincode, phone, support_email, account_details_id) VALUES ('Acc_4', 'HCG Cancer Centre', 'Luz church', 'mylapur', 'Chennai', 'Tamil Nadu', '600004', 9623456259, 'hcgcancercentre@gmail.com', 4);
INSERT INTO public.account_details (account_key, hospital_name, street1, street2, city, state, pincode, phone, support_email, account_details_id) VALUES ('Acc_5', 'Kauvery Hospital', 'TTK road', 'Alwarpet', 'Chennai', 'Tamil Nadu', '600018', 9623456270, 'kauveryhospital@gmail.com', 5);
INSERT INTO public.account_details (account_key, hospital_name, street1, street2, city, state, pincode, phone, support_email, account_details_id) VALUES ('Acc_6', 'Frontier Lifeline Hospital', 'Ambattur Industrial Estate Road', 'Mogappair', 'Chennai', 'Tamil Nadu', '600101', 9623656270, 'frontierlifeline@gmail.com', 6);


--
-- TOC entry 3994 (class 0 OID 16502)
-- Dependencies: 199
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (1, 2, 3, '2020-05-05', '10:00:00', '11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (2, 2, 3, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (3, 3, 3, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (4, 4, 2, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (5, 12, 2, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (6, 1, 5, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (7, 1, 5, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (8, 1, 1, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (9, 1, 1, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (10, 1, 1, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (11, 1, 2, '2020-05-05', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (12, 1, 2, '2020-06-01', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (13, 1, 2, '2020-06-01', '10:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (14, 1, 1, '2020-06-02', '10:00:00', '11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (15, 1, 1, '2020-06-02', '10:00:00', '11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (16, 3, 2, '2020-06-02', '10:00:00', '11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (17, 3, 2, '2020-06-02', '10:00:00', '11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (34, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (35, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, 'DOCTOR', 32);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (36, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (37, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (25, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, 'DOCTOR', 32);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (39, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (38, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, 'DOCTOR', 32);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (18, 5, 1, '2020-05-06', '10:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (19, 5, 1, '2020-05-06', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (21, 5, 1, '2020-05-06', '10:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (22, 5, 1, '2020-06-21', '10:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (23, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (24, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (27, 5, 1, '2020-06-12', '11:00:00', '11:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (29, 5, 1, '2020-06-12', '11:00:00', '11:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (30, 5, 1, '2020-06-12', '11:00:00', '11:30:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (40, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (41, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 28, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (42, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 28, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (20, 5, 1, '2020-06-06', '10:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, 'DOCTOR', 32);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (43, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (33, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, true, 'DOCTOR', 32, 'DOCTOR', 32);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (44, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (28, 5, 1, '2020-06-12', '11:00:00', '11:30:00', NULL, true, true, 'DOCTOR', 32, 'DOCTOR', 32);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (45, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (46, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (47, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (48, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (49, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (50, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (51, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (52, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (53, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (54, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (55, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (56, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (57, 1, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'PATIENT', 1, NULL, NULL);
INSERT INTO public.appointment (id, doctor_id, patient_id, appointment_date, start_time, end_time, payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id) VALUES (58, 5, 1, '2020-06-12', '10:00:00', '11:00:00', NULL, true, false, 'DOCTOR', 32, NULL, NULL);


--
-- TOC entry 3996 (class 0 OID 16513)
-- Dependencies: 201
-- Data for Name: appointment_cancel_reschedule; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3998 (class 0 OID 16527)
-- Dependencies: 203
-- Data for Name: appointment_doc_config; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4015 (class 0 OID 24635)
-- Dependencies: 220
-- Data for Name: doc_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (1, 'Doc_5', '10002000200020002000', true, '5', '30', true, '2', '3', '30', true, '2', '4', '15', '1', '3', '15', false, NULL, NULL, 5, false, 'Per Hour', '40 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (2, 'Doc_22', '200', true, '2', '12', false, '2', '2', '3', false, '3', '3', '4', '2', '3', '2', false, NULL, NULL, 4, true, 'Per Hour', '20 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (3, 'Doc_23', '400', true, '2', '12', false, '2', '2', '21', false, '3', '2', '12', '1', '2', '12', false, NULL, NULL, 2, true, 'Per Hour', '20 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (4, 'Doc_24', '123', true, '5', '12', false, '2', '4', '21', false, '1', '12', '2', '5', '1', '12', false, NULL, NULL, 3, true, 'Per Hour', '15 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (5, 'Doc_1', '2000', true, '2', '10', true, '3', '3', '20', true, '2', '10', '12', '1', '12', '10', true, NULL, NULL, 2, true, 'Per Hour', '20 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (6, 'Doc_2', '1000', true, '12', '12', true, '2', '2', '10', true, '1', '1', '20', '0', '1', '0', false, NULL, NULL, 1, false, 'Per Hour', '15 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (7, 'Doc_3', '200', true, '2', '10', false, '5', '2', '30', true, '1', '1', '10', '0', '1', '1', true, NULL, NULL, 4, true, 'Per Hour', '15 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (8, 'Doc_4', '500', true, '2', '10', false, '5', '2', '30', true, '1', '1', '10', '0', '1', '10', false, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (9, 'Doc_6', '400', true, '2', '10', true, '1', '5', '10', false, '1', '1', '1', '0', '1', '10', true, NULL, NULL, 2, true, 'Per Hour', '15 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (10, 'Doc_7', '200', true, '1', '0', true, '0', '3', '10', true, '2', '20', '10', '0', '0', '20', true, NULL, NULL, 3, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (11, 'Doc_8', '500', true, '1', '20', true, '0', '2', '10', true, '10', '10', '1', '0', '1', '15', true, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (12, 'Doc_9', '150', true, '2', '10', true, '1', '0', '0', true, '1', '0', '0', '0', '1', '15', true, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (13, 'Doc_10', '500', true, '2', '10', true, '1', '0', '10', true, '6', '8', '40', '5', '3', '15', true, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (14, 'Doc_11', '100', true, '10', '0', true, '1', '10', '10', true, '0', '20', '10', '3', '3', '15', true, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (15, 'Doc_12', '500', true, '10', '1', true, '10', '10', '21', true, '1', '5', '0', '0', '0', '20', true, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (16, 'Doc_13', '200', true, '10', '1', true, '10', '10', '20', true, '1', '3', '0', '0', '0', '20', true, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (17, 'Doc_14', '200', true, '10', '1', false, '5', '2', '30', true, '1', '10', '10', '0', '1', '10', true, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (18, 'Doc_15', '200', true, '2', '0', false, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (19, 'Doc_16', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 2, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (20, 'Doc_17', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (21, 'Doc_18', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (22, 'Doc_19', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (23, 'Doc_20', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (24, 'Doc_21', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 3, true, 'Per Hour', '30 minutes');
INSERT INTO public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, over_booking_count, overbooking_enable, "overBooking_type", consultation_session_timings) VALUES (25, 'Doc_25', '200', true, '2', NULL, true, '5', '2', '30', true, '6', '8', '40', '5', '3', '15', false, NULL, NULL, 2, true, 'Per Hour', '30 minutes');


--
-- TOC entry 3999 (class 0 OID 16544)
-- Dependencies: 204
-- Data for Name: doc_config_schedule_day; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doc_config_schedule_day (doctor_id, day_of_week, id, doctor_key) VALUES (5, 'Monday', 1, 'Doc_5');
INSERT INTO public.doc_config_schedule_day (doctor_id, day_of_week, id, doctor_key) VALUES (5, 'Tuesday', 2, 'Doc_5');
INSERT INTO public.doc_config_schedule_day (doctor_id, day_of_week, id, doctor_key) VALUES (5, 'Wednesday', 3, 'Doc_5');
INSERT INTO public.doc_config_schedule_day (doctor_id, day_of_week, id, doctor_key) VALUES (5, 'Thursday', 4, 'Doc_5');
INSERT INTO public.doc_config_schedule_day (doctor_id, day_of_week, id, doctor_key) VALUES (5, 'Friday', 5, 'Doc_5');
INSERT INTO public.doc_config_schedule_day (doctor_id, day_of_week, id, doctor_key) VALUES (5, 'Saturday', 6, 'Doc_5');
INSERT INTO public.doc_config_schedule_day (doctor_id, day_of_week, id, doctor_key) VALUES (5, 'Sunday', 7, 'Doc_5');


--
-- TOC entry 4000 (class 0 OID 16552)
-- Dependencies: 205
-- Data for Name: doc_config_schedule_interval; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doc_config_schedule_interval (start_time, end_time, doc_config_schedule_day_id, id) VALUES ('09:00:00', '10:00:00', 4, 33);
INSERT INTO public.doc_config_schedule_interval (start_time, end_time, doc_config_schedule_day_id, id) VALUES ('08:30:00', '09:00:00', 4, 34);
INSERT INTO public.doc_config_schedule_interval (start_time, end_time, doc_config_schedule_day_id, id) VALUES ('08:30:00', '09:00:00', 5, 49);
INSERT INTO public.doc_config_schedule_interval (start_time, end_time, doc_config_schedule_day_id, id) VALUES ('20:00:00', '21:00:00', 3, 6);
INSERT INTO public.doc_config_schedule_interval (start_time, end_time, doc_config_schedule_day_id, id) VALUES ('20:00:00', '21:00:00', 3, 7);
INSERT INTO public.doc_config_schedule_interval (start_time, end_time, doc_config_schedule_day_id, id) VALUES ('20:00:00', '21:00:00', 3, 8);
INSERT INTO public.doc_config_schedule_interval (start_time, end_time, doc_config_schedule_day_id, id) VALUES ('15:00:00', '16:00:00', 3, 9);
INSERT INTO public.doc_config_schedule_interval (start_time, end_time, doc_config_schedule_day_id, id) VALUES ('09:00:00', '10:00:00', 2, 3);
INSERT INTO public.doc_config_schedule_interval (start_time, end_time, doc_config_schedule_day_id, id) VALUES ('08:30:00', '09:00:00', 2, 12);


--
-- TOC entry 4002 (class 0 OID 16568)
-- Dependencies: 207
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (2, 'Prof Narendranath Kanna', 'Acc_1', 'Doc_2', 28, 'Cardiologist', 'MBBS MD Cardiology', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856325847, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Narendranath', 'kanna', 'RegD_2', 'narendranath@apollo.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (3, 'Sheetal Desai', 'Acc_1', 'Doc_3', 7, 'General Physician', 'MBBS', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856425847, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Sheetal', 'Desai', 'RegD_3', 'sheetaldesai@apollo.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (4, 'Sree Kumar Reddy', 'Acc_1', 'Doc_4', 26, 'Opthamologist', 'MBBS MD Opthamology', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856425887, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Sree Kumar', 'Reddy', 'RegD_4', 'sreekumarreddy@apollo.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (5, 'Shalini Shetty', 'Acc_1', 'Doc_5', 17, 'Opthamologist', 'MBBS MD Opthamology', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856425888, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Shalini', 'Shetty', 'RegD_5', 'test@apollo.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (16, 'Maheshkumar N Upasani', 'Acc_4', 'Doc_16', 20, 'Radiation oncologist', 'MD,PDCR', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556724899, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Maheshkumar N', 'Upasani', 'RegD_16', 'maheshkumar@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (17, 'Balaji.J', 'Acc_4', 'Doc_17', 21, 'Medical oncologist', 'DMRT, DNB(RT),DM (ONCOLOGY)', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556727899, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Balaji', 'J', 'RegD_17', 'balajij@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (18, 'Murugesh	DMRT', 'Acc_4', 'Doc_18', 21, 'Radiation oncologist', 'DNB', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556728899, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Murugesh', 'DMRT', 'RegD_18', 'murugesh@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (19, 'Mohammed Ibrahinm', 'Acc_4', 'Doc_19', 21, 'Surgical oncologist', 'MS(Gen.Surg.), DNB(Gen.Surg.), DNB(Surg.Oncology),MRCSEd(UK), FMAS', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556728899, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Mohammed', 'Ibrahim', 'RegD_19', 'mohammedibrahim@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (20, 'Aravindan Selvaraj', 'Acc_5', 'Doc_20', 11, 'Orthopaedic Surgery', 'MBBS.,MS.,FRCS( UK & IRELAND)', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556728899, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Aravindan', 'Selvaraj', 'RegD_20', 'aravindanselvaraj@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (21, 'Balamurali', 'Acc_5', 'Doc_21', 11, 'Spine Surgery', 'MBBS.,MRCS.,MD.,FRCS', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556728999, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Bala', 'Murali', 'RegD_21', 'balamurali@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (22, 'Raghavan Subramanyan', 'Acc_6', 'Doc_22', 21, 'Sr Consultant Cardiologist', 'MBBS, MD, DM, FRCPI, FSCAI, FSCI', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556728909, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'raghavan', 'Subramanyan', 'RegD_22', 'raghavansubramaniyan@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (23, 'Anto sahayaraj. R', 'Acc_6', 'Doc_23', 15, 'Paediatric Cardiac Surgery', 'MBBS, MS, M.Ch', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556728901, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Anto', 'Sahayaraj R', 'RegD_23', 'antosahayaraj@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (24, 'Sowmya Ramanan V', 'Acc_6', 'Doc_24', 14, 'Paediatric Cardiac Surgery', 'MBBS, MS, M.Ch,MRCS', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556728901, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Sowmya', 'Ramanan V', 'RegD_24', 'sowmyaramananv@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (11, 'Usha Shukla', 'Acc_3', 'Doc_11', 14, 'Family Medicine', 'MD', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856428879, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Usha', 'Shukla', 'RegD_11', 'ushashukla@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (12, ' Sarala Rajajee', 'Acc_3', 'Doc_12', 12, 'Paediatric Haematology', 'MD DCH DNB PhD', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856424879, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'sarala', 'Rajajee', 'RegD_12', 'saralarajajee@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (13, 'Parthasarathy Srinivasan', 'Acc_3', 'Doc_13', 10, 'Orthopaedics', 'D Ortho, DNB Ortho, FNB Spine', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556424879, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Parthasarathy', 'Srinivasan', 'RegD_13', 'parthasarathy@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (14, 'K Kalaiselvi', 'Acc_3', 'Doc_14', 10, 'Oncology', 'MD DM', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556424899, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'KalaiSelvi', 'K', 'RegD_14', 'kalaiselvi@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (15, 'S Jayaraman', 'Acc_3', 'Doc_15', 10, 'Pulmonology', 'MBBS DTCD DNB', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556424899, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Jayaraman', 'S', 'RegD_15', 'jayaraman@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (25, ' Balaji Srimurugan', 'Acc_6', 'Doc_25', 16, 'Staff Cardiac Surgeon', 'MBBS, MS, M.Ch', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9556728906, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Balaji', 'Srimurugan', 'RegD_25', 'balajisrimurugan@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (1, 'Adithya K', 'Acc_1', 'Doc_1', 7, 'Cardiologist', 'MBBS MD Cardiology', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856325647, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Adithya', 'K', 'RegD_1', 'adithya@apollo.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (6, 'Sreeram Valluri', 'Acc_1', 'Doc_6', 7, 'ENT', 'MBBS MD ENT', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856425889, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'sreeram', 'valluri', 'RegD_6', 'sreeram@apollo.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (7, 'Indhumathi R', 'Acc_2', 'Doc_7', 7, 'Internal Medicine and masterhealth checkup', 'MBBS MD', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856425889, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'indhumathi', 'R', 'RegD_7', 'indhumathir@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (8, 'Kumar ThulasiDass', 'Acc_2', 'Doc_8', 12, 'DIABETOLOGY & ENDOCRINOLOGIST', 'MBBS MD', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856425885, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Kumar', 'Thuasi Dass', 'RegD_8', 'thulasidass@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (9, 'Rajeshwari  Ramachandran', 'Acc_2', 'Doc_9', 17, 'NEUROLOGY', 'MBBS MD.DM', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856425889, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Rajeshwari', 'Ramachandran', 'RegD_9', 'rajeshwari@gmail.com');
INSERT INTO public.doctor (doctor_id, doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email) VALUES (10, 'Vijay  Iyer', 'Acc_2', 'Doc_10', 20, 'NEURO SURGERY & TRAUMA CARE', 'MS Mch', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 9856425879, 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', 'Vijay', 'Iyer', 'RegD_10', 'vijayiyer@gmail.com');


--
-- TOC entry 4004 (class 0 OID 16587)
-- Dependencies: 209
-- Data for Name: doctor_config_can_resch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doctor_config_can_resch (doc_config_can_resch_id, doc_key, is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_resch_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, is_active, created_on, modified_on) VALUES (1, 'Doc_1', false, '1', 10, 10, false, '2', 2, 3, '0', 3, 10, false, NULL, '2020-06-08');
INSERT INTO public.doctor_config_can_resch (doc_config_can_resch_id, doc_key, is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_resch_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, is_active, created_on, modified_on) VALUES (2, 'Doc_5', false, '1', 10, 10, false, '2', 2, 3, '0', 3, 10, false, NULL, '2020-06-20');


--
-- TOC entry 4006 (class 0 OID 16598)
-- Dependencies: 211
-- Data for Name: doctor_config_pre_consultation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doctor_config_pre_consultation (doctor_config_id, doctor_key, consultation_cost, is_preconsultation_allowed, preconsultation_hours, preconsultation_minutes, is_active, created_on, modified_on) VALUES (7, 'doc_1', 1000, false, 1, 10, true, NULL, '2020-06-08');
INSERT INTO public.doctor_config_pre_consultation (doctor_config_id, doctor_key, consultation_cost, is_preconsultation_allowed, preconsultation_hours, preconsultation_minutes, is_active, created_on, modified_on) VALUES (8, 'doc_1', 1000, false, 1, 10, true, NULL, '2020-06-08');
INSERT INTO public.doctor_config_pre_consultation (doctor_config_id, doctor_key, consultation_cost, is_preconsultation_allowed, preconsultation_hours, preconsultation_minutes, is_active, created_on, modified_on) VALUES (9, 'doc_1', 1000, false, 1, 10, true, NULL, '2020-06-08');


--
-- TOC entry 4010 (class 0 OID 16642)
-- Dependencies: 215
-- Data for Name: interval_days; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4020 (class 0 OID 24691)
-- Dependencies: 225
-- Data for Name: patient_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (3, 'Shrushti Jayanth Deshmukh', 'Van Vihar National Park', 'India', 'Reg_3', 'Bhopal', 'Madhya Pradesh', '462023', 'shrushti@gmail.com', 'testImageUrl', 9999999993, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (1, 'Nirmala Seetharaman', 'Redfort', 'India', 'Reg_1', 'New Delhi', 'Delhi', '110001', 'nirmala@gmail.com', 'testImageUrl', 9999999991, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (2, 'Ashok Gajapathi Raj', 'Mysore Palace', 'India', 'Reg_2', 'Bangalore', 'Karnataka', '530068', 'ashok@gmail.com', 'testImageUrl', 9999999992, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (6, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (7, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (8, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (9, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (10, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (11, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (12, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (13, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (14, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (15, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (16, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (17, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (18, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (19, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (20, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (21, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (22, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (23, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (24, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (25, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (26, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (27, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (28, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 75);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (29, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 76);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (30, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 77);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (31, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 78);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (32, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 79);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (33, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (34, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (35, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (36, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (37, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (38, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (39, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (40, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (41, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (42, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (43, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (44, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (5, 'anjana', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 5);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (4, 'Amrutha', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, 4);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (45, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (46, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);
INSERT INTO public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id) VALUES (47, 'name', 'landmark', 'country', NULL, 'address', 'state', '12346', 'nirmala@gmail.com', 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png', NULL, NULL);


--
-- TOC entry 4008 (class 0 OID 16628)
-- Dependencies: 213
-- Data for Name: payment_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.payment_details (id, appointment_id, is_paid, refund) VALUES (1, 34, true, NULL);
INSERT INTO public.payment_details (id, appointment_id, is_paid, refund) VALUES (2, 36, false, NULL);
INSERT INTO public.payment_details (id, appointment_id, is_paid, refund) VALUES (3, 37, true, NULL);
INSERT INTO public.payment_details (id, appointment_id, is_paid, refund) VALUES (4, 35, true, NULL);
INSERT INTO public.payment_details (id, appointment_id, is_paid, refund) VALUES (5, 19, false, NULL);
INSERT INTO public.payment_details (id, appointment_id, is_paid, refund) VALUES (6, 27, true, NULL);
INSERT INTO public.payment_details (id, appointment_id, is_paid, refund) VALUES (7, 28, true, NULL);
INSERT INTO public.payment_details (id, appointment_id, is_paid, refund) VALUES (8, 29, false, NULL);
INSERT INTO public.payment_details (id, appointment_id, is_paid, refund) VALUES (9, 30, true, NULL);


--
-- TOC entry 4022 (class 0 OID 24709)
-- Dependencies: 227
-- Data for Name: work_schedule_day; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4024 (class 0 OID 24717)
-- Dependencies: 229
-- Data for Name: work_schedule_interval; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4049 (class 0 OID 0)
-- Dependencies: 196
-- Name: account_details_account_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_details_account_details_id_seq', 1, false);


--
-- TOC entry 4050 (class 0 OID 0)
-- Dependencies: 200
-- Name: appointment_cancel_reschedule_appointment_cancel_reschedule_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq', 1, false);


--
-- TOC entry 4051 (class 0 OID 0)
-- Dependencies: 202
-- Name: appointment_doc_config_appointment_doc_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_doc_config_appointment_doc_config_id_seq', 1, false);


--
-- TOC entry 4052 (class 0 OID 0)
-- Dependencies: 198
-- Name: appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_id_seq', 58, true);


--
-- TOC entry 4053 (class 0 OID 0)
-- Dependencies: 216
-- Name: appointment_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_seq', 17, true);


--
-- TOC entry 4054 (class 0 OID 0)
-- Dependencies: 217
-- Name: doc_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_can_resch_doc_config_can_resch_id_seq', 2, true);


--
-- TOC entry 4055 (class 0 OID 0)
-- Dependencies: 222
-- Name: doc_config_schedule_day_doc_config_schedule_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq', 7, true);


--
-- TOC entry 4056 (class 0 OID 0)
-- Dependencies: 223
-- Name: doc_config_schedule_interval_doc_config_schedule_interval_i_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq', 50, true);


--
-- TOC entry 4057 (class 0 OID 0)
-- Dependencies: 221
-- Name: docconfigid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.docconfigid_seq', 25, true);


--
-- TOC entry 4058 (class 0 OID 0)
-- Dependencies: 208
-- Name: doctor_config_can_resch_doc_config_can_resch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_can_resch_doc_config_can_resch_id_seq', 1, false);


--
-- TOC entry 4059 (class 0 OID 0)
-- Dependencies: 210
-- Name: doctor_config_pre_consultation_doctor_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_pre_consultation_doctor_config_id_seq', 1, false);


--
-- TOC entry 4060 (class 0 OID 0)
-- Dependencies: 218
-- Name: doctor_config_preconsultation_doctor_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_config_preconsultation_doctor_config_id_seq', 9, true);


--
-- TOC entry 4061 (class 0 OID 0)
-- Dependencies: 219
-- Name: doctor_details_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_details_doctor_id_seq', 1, false);


--
-- TOC entry 4062 (class 0 OID 0)
-- Dependencies: 206
-- Name: doctor_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_doctor_id_seq', 1, false);


--
-- TOC entry 4063 (class 0 OID 0)
-- Dependencies: 214
-- Name: interval_days_interval_days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interval_days_interval_days_id_seq', 1, false);


--
-- TOC entry 4064 (class 0 OID 0)
-- Dependencies: 224
-- Name: patient_details_patient_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_details_patient_details_id_seq', 47, true);


--
-- TOC entry 4065 (class 0 OID 0)
-- Dependencies: 212
-- Name: payment_details_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_details_payment_id_seq', 9, true);


--
-- TOC entry 4066 (class 0 OID 0)
-- Dependencies: 226
-- Name: work_schedule_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_schedule_day_id_seq', 1, false);


--
-- TOC entry 4067 (class 0 OID 0)
-- Dependencies: 228
-- Name: work_schedule_interval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_schedule_interval_id_seq', 1, false);


--
-- TOC entry 3819 (class 2606 OID 16497)
-- Name: account_details account_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_details_pkey PRIMARY KEY (account_details_id);


--
-- TOC entry 3821 (class 2606 OID 16499)
-- Name: account_details account_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_key_unique UNIQUE (account_key);


--
-- TOC entry 3825 (class 2606 OID 16518)
-- Name: appointment_cancel_reschedule appointment_cancel_reschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT appointment_cancel_reschedule_pkey PRIMARY KEY (appointment_cancel_reschedule_id);


--
-- TOC entry 3828 (class 2606 OID 16535)
-- Name: appointment_doc_config appointment_doc_config_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT appointment_doc_config_id PRIMARY KEY (appointment_doc_config_id);


--
-- TOC entry 3823 (class 2606 OID 16510)
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id);


--
-- TOC entry 3843 (class 2606 OID 16595)
-- Name: doctor_config_can_resch doc_config_can_resch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_can_resch
    ADD CONSTRAINT doc_config_can_resch_pkey PRIMARY KEY (doc_config_can_resch_id);


--
-- TOC entry 3854 (class 2606 OID 24657)
-- Name: doc_config doc_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doc_config_pkey PRIMARY KEY (id);


--
-- TOC entry 3831 (class 2606 OID 24683)
-- Name: doc_config_schedule_day doc_config_schedule_day_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_config_schedule_day_id PRIMARY KEY (id);


--
-- TOC entry 3834 (class 2606 OID 24681)
-- Name: doc_config_schedule_interval doc_config_schedule_interval_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_config_schedule_interval_id PRIMARY KEY (id);


--
-- TOC entry 3845 (class 2606 OID 16606)
-- Name: doctor_config_pre_consultation doctor_config_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_config_pre_consultation
    ADD CONSTRAINT doctor_config_id PRIMARY KEY (doctor_config_id);


--
-- TOC entry 3838 (class 2606 OID 16576)
-- Name: doctor doctor_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_id PRIMARY KEY (doctor_id);


--
-- TOC entry 3840 (class 2606 OID 16578)
-- Name: doctor doctor_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_key_unique UNIQUE (doctor_key);


--
-- TOC entry 3852 (class 2606 OID 16647)
-- Name: interval_days interval_days_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interval_days
    ADD CONSTRAINT interval_days_id PRIMARY KEY (interval_days_id);


--
-- TOC entry 3856 (class 2606 OID 24699)
-- Name: patient_details patient_details_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_details
    ADD CONSTRAINT patient_details_id PRIMARY KEY (id);


--
-- TOC entry 3849 (class 2606 OID 16633)
-- Name: payment_details payment_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_id PRIMARY KEY (id);


--
-- TOC entry 3858 (class 2606 OID 24714)
-- Name: work_schedule_day work_schedule_day_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_day
    ADD CONSTRAINT work_schedule_day_pkey PRIMARY KEY (id);


--
-- TOC entry 3861 (class 2606 OID 24722)
-- Name: work_schedule_interval work_schedule_interval_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT work_schedule_interval_pkey PRIMARY KEY (id);


--
-- TOC entry 3829 (class 1259 OID 16541)
-- Name: fki_app_doc_con_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_app_doc_con_to_app_id ON public.appointment_doc_config USING btree (appointment_id);


--
-- TOC entry 3826 (class 1259 OID 16524)
-- Name: fki_can_resch_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_can_resch_to_app_id ON public.appointment_cancel_reschedule USING btree (appointment_id);


--
-- TOC entry 3846 (class 1259 OID 16607)
-- Name: fki_doc_config_to_doc_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doc_config_to_doc_key ON public.doctor_config_pre_consultation USING btree (doctor_key);


--
-- TOC entry 3832 (class 1259 OID 24706)
-- Name: fki_doc_sched_to_doc_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doc_sched_to_doc_id ON public.doc_config_schedule_day USING btree (doctor_id);


--
-- TOC entry 3841 (class 1259 OID 16584)
-- Name: fki_doctor_to_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_doctor_to_account ON public.doctor USING btree (account_key);


--
-- TOC entry 3850 (class 1259 OID 16653)
-- Name: fki_int_days_to_wrk_sched_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_int_days_to_wrk_sched_id ON public.interval_days USING btree (wrk_sched_id);


--
-- TOC entry 3835 (class 1259 OID 16563)
-- Name: fki_interval_to_wrk_sched_con_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_interval_to_wrk_sched_con_id ON public.doc_config_schedule_interval USING btree (doc_config_schedule_day_id);


--
-- TOC entry 3836 (class 1259 OID 16564)
-- Name: fki_interval_to_wrk_sched_config_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_interval_to_wrk_sched_config_id ON public.doc_config_schedule_interval USING btree (doc_config_schedule_day_id);


--
-- TOC entry 3847 (class 1259 OID 16639)
-- Name: fki_payment_to_app_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_payment_to_app_id ON public.payment_details USING btree (appointment_id);


--
-- TOC entry 3859 (class 1259 OID 24728)
-- Name: fki_workScheduleIntervalToDay; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_workScheduleIntervalToDay" ON public.work_schedule_interval USING btree (work_schedule_day_id);


--
-- TOC entry 3863 (class 2606 OID 16536)
-- Name: appointment_doc_config app_doc_con_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT app_doc_con_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 3862 (class 2606 OID 16519)
-- Name: appointment_cancel_reschedule can_resch_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT can_resch_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 3865 (class 2606 OID 24684)
-- Name: doc_config_schedule_interval doc_sched_interval_to_day; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_sched_interval_to_day FOREIGN KEY (doc_config_schedule_day_id) REFERENCES public.doc_config_schedule_day(id) NOT VALID;


--
-- TOC entry 3864 (class 2606 OID 24701)
-- Name: doc_config_schedule_day doc_sched_to_doc_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_sched_to_doc_id FOREIGN KEY (doctor_id) REFERENCES public.doctor(doctor_id) NOT VALID;


--
-- TOC entry 3868 (class 2606 OID 24658)
-- Name: doc_config doctor_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doctor_key FOREIGN KEY (doctor_key) REFERENCES public.doctor(doctor_key);


--
-- TOC entry 3866 (class 2606 OID 16579)
-- Name: doctor doctor_to_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_to_account FOREIGN KEY (account_key) REFERENCES public.account_details(account_key);


--
-- TOC entry 3867 (class 2606 OID 16634)
-- Name: payment_details payment_to_app_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);


--
-- TOC entry 3869 (class 2606 OID 24723)
-- Name: work_schedule_interval workScheduleIntervalToDay; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT "workScheduleIntervalToDay" FOREIGN KEY (work_schedule_day_id) REFERENCES public.work_schedule_day(id) NOT VALID;

--
-- PostgreSQL database dump complete
--

