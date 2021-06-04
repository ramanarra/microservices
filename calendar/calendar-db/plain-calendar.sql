PGDMP     3                    y            calendar    11.8    12.2 �    N           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            O           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            P           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            Q           1262    16408    calendar    DATABASE     z   CREATE DATABASE calendar WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE calendar;
                postgres    false            R           0    0    DATABASE calendar    ACL     -   GRANT ALL ON DATABASE calendar TO devvirujh;
                   postgres    false    4177                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            S           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    3            T           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    3            �           1247    24835    consultations    TYPE     M   CREATE TYPE public.consultations AS ENUM (
    'online',
    'inHospital'
);
     DROP TYPE public.consultations;
       public          postgres    false    3            �           1247    24873    live_statuses    TYPE     t   CREATE TYPE public.live_statuses AS ENUM (
    'offline',
    'online',
    'videoSessionReady',
    'inSession'
);
     DROP TYPE public.live_statuses;
       public          postgres    false    3            �           1247    24756    overbookingtype    TYPE     N   CREATE TYPE public.overbookingtype AS ENUM (
    'Per Hour',
    'Per day'
);
 "   DROP TYPE public.overbookingtype;
       public          postgres    false    3            �           1247    24988    payment_statuses    TYPE     u   CREATE TYPE public.payment_statuses AS ENUM (
    'notPaid',
    'partiallyPaid',
    'fullyPaid',
    'refunded'
);
 #   DROP TYPE public.payment_statuses;
       public          postgres    false    3            �           1247    24827    payments    TYPE     h   CREATE TYPE public.payments AS ENUM (
    'onlineCollection',
    'directPayment',
    'notRequired'
);
    DROP TYPE public.payments;
       public          postgres    false    3            �           1247    24841    preconsultations    TYPE     E   CREATE TYPE public.preconsultations AS ENUM (
    'on',
    'off'
);
 #   DROP TYPE public.preconsultations;
       public          postgres    false    3            �           1247    24865    statuses    TYPE     [   CREATE TYPE public.statuses AS ENUM (
    'completed',
    'paused',
    'notCompleted'
);
    DROP TYPE public.statuses;
       public          postgres    false    3            �            1259    16489    account_details    TABLE     s  CREATE TABLE public.account_details (
    account_key character varying(200) NOT NULL,
    hospital_name character varying(200) NOT NULL,
    street1 character varying(100),
    street2 character varying(100),
    city character varying(100),
    state character varying NOT NULL,
    pincode character varying(100) NOT NULL,
    phone bigint NOT NULL,
    support_email character varying(100),
    account_details_id integer NOT NULL,
    hospital_photo character varying(500),
    country character varying(100),
    landmark character varying(100),
    "supportEmail" character varying,
    "cityState" character varying
);
 #   DROP TABLE public.account_details;
       public            postgres    false    3            �            1259    16487 &   account_details_account_details_id_seq    SEQUENCE     �   CREATE SEQUENCE public.account_details_account_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.account_details_account_details_id_seq;
       public          postgres    false    197    3            U           0    0 &   account_details_account_details_id_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.account_details_account_details_id_seq OWNED BY public.account_details.account_details_id;
          public          postgres    false    196            �            1259    27738    advertisement    TABLE     �   CREATE TABLE public.advertisement (
    id integer NOT NULL,
    name character varying(100),
    content character varying(5000),
    code character varying(1000),
    "createdTime" timestamp without time zone,
    is_active boolean
);
 !   DROP TABLE public.advertisement;
       public            postgres    false    3            �            1259    16502    appointment    TABLE     B  CREATE TABLE public.appointment (
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
    "hasConsultation" boolean,
    reportid character varying(100)
);
    DROP TABLE public.appointment;
       public            postgres    false    727    730    736    727    3    730    736            �            1259    16513    appointment_cancel_reschedule    TABLE     z  CREATE TABLE public.appointment_cancel_reschedule (
    appointment_cancel_reschedule_id integer NOT NULL,
    cancel_on date NOT NULL,
    cancel_by bigint NOT NULL,
    cancel_payment_status character varying(100) NOT NULL,
    cancel_by_id bigint NOT NULL,
    reschedule boolean NOT NULL,
    reschedule_appointment_id bigint NOT NULL,
    appointment_id bigint NOT NULL
);
 1   DROP TABLE public.appointment_cancel_reschedule;
       public            postgres    false    3            �            1259    16511 ?   appointment_cancel_reschedule_appointment_cancel_reschedule_seq    SEQUENCE     �   CREATE SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 V   DROP SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq;
       public          postgres    false    201    3            V           0    0 ?   appointment_cancel_reschedule_appointment_cancel_reschedule_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq OWNED BY public.appointment_cancel_reschedule.appointment_cancel_reschedule_id;
          public          postgres    false    200            �            1259    16527    appointment_doc_config    TABLE     �  CREATE TABLE public.appointment_doc_config (
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
 *   DROP TABLE public.appointment_doc_config;
       public            postgres    false    3            �            1259    16525 4   appointment_doc_config_appointment_doc_config_id_seq    SEQUENCE     �   CREATE SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 K   DROP SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq;
       public          postgres    false    3    203            W           0    0 4   appointment_doc_config_appointment_doc_config_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq OWNED BY public.appointment_doc_config.appointment_doc_config_id;
          public          postgres    false    202            �            1259    16500    appointment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.appointment_id_seq;
       public          postgres    false    3    199            X           0    0    appointment_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.appointment_id_seq OWNED BY public.appointment.id;
          public          postgres    false    198            �            1259    16751    appointment_seq    SEQUENCE     x   CREATE SEQUENCE public.appointment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.appointment_seq;
       public          postgres    false    3            �            1259    24932    communication_type    TABLE     e   CREATE TABLE public.communication_type (
    id integer NOT NULL,
    name character varying(100)
);
 &   DROP TABLE public.communication_type;
       public            postgres    false    3            �            1259    24930    communication_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.communication_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.communication_type_id_seq;
       public          postgres    false    3    239            Y           0    0    communication_type_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.communication_type_id_seq OWNED BY public.communication_type.id;
          public          postgres    false    238            �            1259    24635 
   doc_config    TABLE     �  CREATE TABLE public.doc_config (
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
    DROP TABLE public.doc_config;
       public            postgres    false    3    712            �            1259    16587    doctor_config_can_resch    TABLE     ^  CREATE TABLE public.doctor_config_can_resch (
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
 +   DROP TABLE public.doctor_config_can_resch;
       public            postgres    false    3            �            1259    16753 0   doc_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 G   DROP SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq;
       public          postgres    false    209    3            Z           0    0 0   doc_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;
          public          postgres    false    217            �            1259    16544    doc_config_schedule_day    TABLE     �   CREATE TABLE public.doc_config_schedule_day (
    doctor_id bigint NOT NULL,
    "dayOfWeek" character varying(50) NOT NULL,
    id integer NOT NULL,
    doctor_key character varying
);
 +   DROP TABLE public.doc_config_schedule_day;
       public            postgres    false    3            �            1259    24666 6   doc_config_schedule_day_doc_config_schedule_day_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 M   DROP SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq;
       public          postgres    false    3    204            [           0    0 6   doc_config_schedule_day_doc_config_schedule_day_id_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq OWNED BY public.doc_config_schedule_day.id;
          public          postgres    false    222            �            1259    16552    doc_config_schedule_interval    TABLE     �   CREATE TABLE public.doc_config_schedule_interval (
    "startTime" time without time zone NOT NULL,
    "endTime" time without time zone NOT NULL,
    "docConfigScheduleDayId" bigint NOT NULL,
    id integer NOT NULL,
    doctorkey character varying
);
 0   DROP TABLE public.doc_config_schedule_interval;
       public            postgres    false    3            �            1259    24672 ?   doc_config_schedule_interval_doc_config_schedule_interval_i_seq    SEQUENCE     �   CREATE SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 V   DROP SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq;
       public          postgres    false    3    205            \           0    0 ?   doc_config_schedule_interval_doc_config_schedule_interval_i_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq OWNED BY public.doc_config_schedule_interval.id;
          public          postgres    false    223            �            1259    24663    docconfigid_seq    SEQUENCE     x   CREATE SEQUENCE public.docconfigid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.docconfigid_seq;
       public          postgres    false    220    3            ]           0    0    docconfigid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.docconfigid_seq OWNED BY public.doc_config.id;
          public          postgres    false    221            �            1259    16568    doctor    TABLE     �  CREATE TABLE public.doctor (
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
    DROP TABLE public.doctor;
       public            postgres    false    739    739    3            �            1259    16585 3   doctor_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 J   DROP SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq;
       public          postgres    false    3    209            ^           0    0 3   doctor_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;
          public          postgres    false    208            �            1259    16598    doctor_config_pre_consultation    TABLE     Y  CREATE TABLE public.doctor_config_pre_consultation (
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
 2   DROP TABLE public.doctor_config_pre_consultation;
       public            postgres    false    3            �            1259    16596 3   doctor_config_pre_consultation_doctor_config_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 J   DROP SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq;
       public          postgres    false    211    3            _           0    0 3   doctor_config_pre_consultation_doctor_config_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;
          public          postgres    false    210            �            1259    16755 2   doctor_config_preconsultation_doctor_config_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 I   DROP SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq;
       public          postgres    false    3    211            `           0    0 2   doctor_config_preconsultation_doctor_config_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;
          public          postgres    false    218            �            1259    16757    doctor_details_doctor_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_details_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.doctor_details_doctor_id_seq;
       public          postgres    false    3    207            a           0    0    doctor_details_doctor_id_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.doctor_details_doctor_id_seq OWNED BY public.doctor."doctorId";
          public          postgres    false    219            �            1259    16566    doctor_doctor_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.doctor_doctor_id_seq;
       public          postgres    false    207    3            b           0    0    doctor_doctor_id_seq    SEQUENCE OWNED BY     N   ALTER SEQUENCE public.doctor_doctor_id_seq OWNED BY public.doctor."doctorId";
          public          postgres    false    206            �            1259    16642    interval_days    TABLE     �   CREATE TABLE public.interval_days (
    interval_days_id integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    wrk_sched_id bigint NOT NULL
);
 !   DROP TABLE public.interval_days;
       public            postgres    false    3            �            1259    16640 "   interval_days_interval_days_id_seq    SEQUENCE     �   CREATE SEQUENCE public.interval_days_interval_days_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.interval_days_interval_days_id_seq;
       public          postgres    false    215    3            c           0    0 "   interval_days_interval_days_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.interval_days_interval_days_id_seq OWNED BY public.interval_days.interval_days_id;
          public          postgres    false    214            �            1259    33192    medicine    TABLE     D  CREATE TABLE public.medicine (
    id integer,
    prescription_id bigint,
    name_of_medicine character varying,
    frequency_of_each_dose character varying,
    count_of_medicine_for_each_dose bigint,
    type_of_medicine character varying,
    dose_of_medicine character varying,
    count_of_days character varying
);
    DROP TABLE public.medicine;
       public            postgres    false    3            �            1259    24958    message_metadata    TABLE     �   CREATE TABLE public.message_metadata (
    id integer NOT NULL,
    message_type_id bigint,
    communication_type_id bigint,
    message_template_id bigint
);
 $   DROP TABLE public.message_metadata;
       public            postgres    false    3            �            1259    24956    message_metadata_id_seq    SEQUENCE     �   CREATE SEQUENCE public.message_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.message_metadata_id_seq;
       public          postgres    false    3    243            d           0    0    message_metadata_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.message_metadata_id_seq OWNED BY public.message_metadata.id;
          public          postgres    false    242            �            1259    24912    message_template    TABLE     �   CREATE TABLE public.message_template (
    id integer NOT NULL,
    sender character varying(200),
    subject character varying(200),
    body character varying(500000)
);
 $   DROP TABLE public.message_template;
       public            postgres    false    3            �            1259    24910    message_template_id_seq    SEQUENCE     �   CREATE SEQUENCE public.message_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.message_template_id_seq;
       public          postgres    false    235    3            e           0    0    message_template_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.message_template_id_seq OWNED BY public.message_template.id;
          public          postgres    false    234            �            1259    24940    message_template_placeholders    TABLE     �   CREATE TABLE public.message_template_placeholders (
    id integer NOT NULL,
    message_template_id bigint,
    placeholder_name character varying(200),
    message_type_id bigint
);
 1   DROP TABLE public.message_template_placeholders;
       public            postgres    false    3            �            1259    24938 $   message_template_placeholders_id_seq    SEQUENCE     �   CREATE SEQUENCE public.message_template_placeholders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.message_template_placeholders_id_seq;
       public          postgres    false    3    241            f           0    0 $   message_template_placeholders_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.message_template_placeholders_id_seq OWNED BY public.message_template_placeholders.id;
          public          postgres    false    240            �            1259    24923    message_type    TABLE     �   CREATE TABLE public.message_type (
    id integer NOT NULL,
    name character varying(200),
    description character varying
);
     DROP TABLE public.message_type;
       public            postgres    false    3            �            1259    24921    message_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.message_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.message_type_id_seq;
       public          postgres    false    3    237            g           0    0    message_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.message_type_id_seq OWNED BY public.message_type.id;
          public          postgres    false    236            �            1259    24773    openvidu_session    TABLE     �   CREATE TABLE public.openvidu_session (
    openvidu_session_id integer NOT NULL,
    doctor_key character varying(100) NOT NULL,
    session_name character varying(100) NOT NULL,
    session_id character varying(100) NOT NULL
);
 $   DROP TABLE public.openvidu_session;
       public            postgres    false    3            �            1259    24771 (   openvidu_session_openvidu_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.openvidu_session_openvidu_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.openvidu_session_openvidu_session_id_seq;
       public          postgres    false    231    3            h           0    0 (   openvidu_session_openvidu_session_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.openvidu_session_openvidu_session_id_seq OWNED BY public.openvidu_session.openvidu_session_id;
          public          postgres    false    230            �            1259    24783    openvidu_session_token    TABLE     �   CREATE TABLE public.openvidu_session_token (
    openvidu_session_token_id integer NOT NULL,
    openvidu_session_id bigint NOT NULL,
    token text NOT NULL,
    doctor_id bigint,
    patient_id bigint
);
 *   DROP TABLE public.openvidu_session_token;
       public            postgres    false    3            �            1259    24781 4   openvidu_session_token_openvidu_session_token_id_seq    SEQUENCE     �   CREATE SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 K   DROP SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq;
       public          postgres    false    233    3            i           0    0 4   openvidu_session_token_openvidu_session_token_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq OWNED BY public.openvidu_session_token.openvidu_session_token_id;
          public          postgres    false    232            �            1259    24691    patient_details    TABLE     X  CREATE TABLE public.patient_details (
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
    last_active timestamp without time zone,
    honorific character varying(10),
    city character varying,
    gender character varying(100)
);
 #   DROP TABLE public.patient_details;
       public            postgres    false    739    3    739            �            1259    24689 &   patient_details_patient_details_id_seq    SEQUENCE     �   CREATE SEQUENCE public.patient_details_patient_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.patient_details_patient_details_id_seq;
       public          postgres    false    225    3            j           0    0 &   patient_details_patient_details_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.patient_details_patient_details_id_seq OWNED BY public.patient_details.id;
          public          postgres    false    224            �            1259    33460    patient_report    TABLE     Q  CREATE TABLE public.patient_report (
    id integer NOT NULL,
    patient_id bigint NOT NULL,
    appointment_id bigint,
    file_name character varying NOT NULL,
    file_type character varying NOT NULL,
    report_url character varying NOT NULL,
    comments character varying,
    report_date date,
    active boolean DEFAULT true
);
 "   DROP TABLE public.patient_report;
       public            postgres    false    3            �            1259    33467    patient_report_id_seq    SEQUENCE     �   CREATE SEQUENCE public.patient_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.patient_report_id_seq;
       public          postgres    false    248    3            k           0    0    patient_report_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.patient_report_id_seq OWNED BY public.patient_report.id;
          public          postgres    false    249            �            1259    16628    payment_details    TABLE     "  CREATE TABLE public.payment_details (
    id integer NOT NULL,
    appointment_id bigint,
    order_id character varying(200),
    receipt_id character varying(200),
    amount character varying(100),
    payment_status public.payment_statuses DEFAULT 'notPaid'::public.payment_statuses
);
 #   DROP TABLE public.payment_details;
       public            postgres    false    765    765    3            �            1259    16626    payment_details_payment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_details_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.payment_details_payment_id_seq;
       public          postgres    false    3    213            l           0    0    payment_details_payment_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.payment_details_payment_id_seq OWNED BY public.payment_details.id;
          public          postgres    false    212            �            1259    33142    prescription    TABLE     �  CREATE TABLE public.prescription (
    appointment_id bigint,
    appointment_date date,
    hospital_logo character varying(500),
    hospital_name character varying(100),
    doctor_name character varying(200),
    doctor_signature character varying(500),
    patient_name character varying(200),
    prescription_url character varying,
    id integer NOT NULL,
    remarks character varying(500),
    "hospitalAddress" character varying(200),
    diagnosis character varying(500)
);
     DROP TABLE public.prescription;
       public            postgres    false    3            �            1259    33231    prescription_id_seq    SEQUENCE     �   ALTER TABLE public.prescription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.prescription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    245    3            �            1259    24709    work_schedule_day    TABLE     �   CREATE TABLE public.work_schedule_day (
    id integer NOT NULL,
    doctor_id bigint NOT NULL,
    date date NOT NULL,
    is_active boolean,
    doctor_key character varying(100)
);
 %   DROP TABLE public.work_schedule_day;
       public            postgres    false    3            �            1259    24707    work_schedule_day_id_seq    SEQUENCE     �   CREATE SEQUENCE public.work_schedule_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.work_schedule_day_id_seq;
       public          postgres    false    227    3            m           0    0    work_schedule_day_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.work_schedule_day_id_seq OWNED BY public.work_schedule_day.id;
          public          postgres    false    226            �            1259    24717    work_schedule_interval    TABLE     �   CREATE TABLE public.work_schedule_interval (
    id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    work_schedule_day_id bigint,
    is_active boolean
);
 *   DROP TABLE public.work_schedule_interval;
       public            postgres    false    3            �            1259    24715    work_schedule_interval_id_seq    SEQUENCE     �   CREATE SEQUENCE public.work_schedule_interval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.work_schedule_interval_id_seq;
       public          postgres    false    3    229            n           0    0    work_schedule_interval_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.work_schedule_interval_id_seq OWNED BY public.work_schedule_interval.id;
          public          postgres    false    228            "           2604    16764 "   account_details account_details_id    DEFAULT     �   ALTER TABLE ONLY public.account_details ALTER COLUMN account_details_id SET DEFAULT nextval('public.account_details_account_details_id_seq'::regclass);
 Q   ALTER TABLE public.account_details ALTER COLUMN account_details_id DROP DEFAULT;
       public          postgres    false    196    197    197            #           2604    16505    appointment id    DEFAULT     p   ALTER TABLE ONLY public.appointment ALTER COLUMN id SET DEFAULT nextval('public.appointment_id_seq'::regclass);
 =   ALTER TABLE public.appointment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    199    198    199            (           2604    16765 >   appointment_cancel_reschedule appointment_cancel_reschedule_id    DEFAULT     �   ALTER TABLE ONLY public.appointment_cancel_reschedule ALTER COLUMN appointment_cancel_reschedule_id SET DEFAULT nextval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq'::regclass);
 m   ALTER TABLE public.appointment_cancel_reschedule ALTER COLUMN appointment_cancel_reschedule_id DROP DEFAULT;
       public          postgres    false    200    201    201            )           2604    16766 0   appointment_doc_config appointment_doc_config_id    DEFAULT     �   ALTER TABLE ONLY public.appointment_doc_config ALTER COLUMN appointment_doc_config_id SET DEFAULT nextval('public.appointment_doc_config_appointment_doc_config_id_seq'::regclass);
 _   ALTER TABLE public.appointment_doc_config ALTER COLUMN appointment_doc_config_id DROP DEFAULT;
       public          postgres    false    202    203    203            L           2604    24935    communication_type id    DEFAULT     ~   ALTER TABLE ONLY public.communication_type ALTER COLUMN id SET DEFAULT nextval('public.communication_type_id_seq'::regclass);
 D   ALTER TABLE public.communication_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    239    239            B           2604    24665    doc_config id    DEFAULT     l   ALTER TABLE ONLY public.doc_config ALTER COLUMN id SET DEFAULT nextval('public.docconfigid_seq'::regclass);
 <   ALTER TABLE public.doc_config ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    220            *           2604    24668    doc_config_schedule_day id    DEFAULT     �   ALTER TABLE ONLY public.doc_config_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq'::regclass);
 I   ALTER TABLE public.doc_config_schedule_day ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    204            +           2604    24674    doc_config_schedule_interval id    DEFAULT     �   ALTER TABLE ONLY public.doc_config_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq'::regclass);
 N   ALTER TABLE public.doc_config_schedule_interval ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    205            ,           2604    16769    doctor doctorId    DEFAULT     }   ALTER TABLE ONLY public.doctor ALTER COLUMN "doctorId" SET DEFAULT nextval('public.doctor_details_doctor_id_seq'::regclass);
 @   ALTER TABLE public.doctor ALTER COLUMN "doctorId" DROP DEFAULT;
       public          postgres    false    219    207            .           2604    16770 /   doctor_config_can_resch doc_config_can_resch_id    DEFAULT     �   ALTER TABLE ONLY public.doctor_config_can_resch ALTER COLUMN doc_config_can_resch_id SET DEFAULT nextval('public.doc_config_can_resch_doc_config_can_resch_id_seq'::regclass);
 ^   ALTER TABLE public.doctor_config_can_resch ALTER COLUMN doc_config_can_resch_id DROP DEFAULT;
       public          postgres    false    217    209            /           2604    16771 /   doctor_config_pre_consultation doctor_config_id    DEFAULT     �   ALTER TABLE ONLY public.doctor_config_pre_consultation ALTER COLUMN doctor_config_id SET DEFAULT nextval('public.doctor_config_preconsultation_doctor_config_id_seq'::regclass);
 ^   ALTER TABLE public.doctor_config_pre_consultation ALTER COLUMN doctor_config_id DROP DEFAULT;
       public          postgres    false    218    211            2           2604    16772    interval_days interval_days_id    DEFAULT     �   ALTER TABLE ONLY public.interval_days ALTER COLUMN interval_days_id SET DEFAULT nextval('public.interval_days_interval_days_id_seq'::regclass);
 M   ALTER TABLE public.interval_days ALTER COLUMN interval_days_id DROP DEFAULT;
       public          postgres    false    215    214    215            N           2604    24961    message_metadata id    DEFAULT     z   ALTER TABLE ONLY public.message_metadata ALTER COLUMN id SET DEFAULT nextval('public.message_metadata_id_seq'::regclass);
 B   ALTER TABLE public.message_metadata ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    242    243    243            J           2604    24915    message_template id    DEFAULT     z   ALTER TABLE ONLY public.message_template ALTER COLUMN id SET DEFAULT nextval('public.message_template_id_seq'::regclass);
 B   ALTER TABLE public.message_template ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    235    234    235            M           2604    24943     message_template_placeholders id    DEFAULT     �   ALTER TABLE ONLY public.message_template_placeholders ALTER COLUMN id SET DEFAULT nextval('public.message_template_placeholders_id_seq'::regclass);
 O   ALTER TABLE public.message_template_placeholders ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240    241            K           2604    24926    message_type id    DEFAULT     r   ALTER TABLE ONLY public.message_type ALTER COLUMN id SET DEFAULT nextval('public.message_type_id_seq'::regclass);
 >   ALTER TABLE public.message_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    236    237            H           2604    24776 $   openvidu_session openvidu_session_id    DEFAULT     �   ALTER TABLE ONLY public.openvidu_session ALTER COLUMN openvidu_session_id SET DEFAULT nextval('public.openvidu_session_openvidu_session_id_seq'::regclass);
 S   ALTER TABLE public.openvidu_session ALTER COLUMN openvidu_session_id DROP DEFAULT;
       public          postgres    false    231    230    231            I           2604    24786 0   openvidu_session_token openvidu_session_token_id    DEFAULT     �   ALTER TABLE ONLY public.openvidu_session_token ALTER COLUMN openvidu_session_token_id SET DEFAULT nextval('public.openvidu_session_token_openvidu_session_token_id_seq'::regclass);
 _   ALTER TABLE public.openvidu_session_token ALTER COLUMN openvidu_session_token_id DROP DEFAULT;
       public          postgres    false    232    233    233            D           2604    24694    patient_details id    DEFAULT     �   ALTER TABLE ONLY public.patient_details ALTER COLUMN id SET DEFAULT nextval('public.patient_details_patient_details_id_seq'::regclass);
 A   ALTER TABLE public.patient_details ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    225    225            P           2604    33469    patient_report id    DEFAULT     v   ALTER TABLE ONLY public.patient_report ALTER COLUMN id SET DEFAULT nextval('public.patient_report_id_seq'::regclass);
 @   ALTER TABLE public.patient_report ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    249    248            0           2604    16773    payment_details id    DEFAULT     �   ALTER TABLE ONLY public.payment_details ALTER COLUMN id SET DEFAULT nextval('public.payment_details_payment_id_seq'::regclass);
 A   ALTER TABLE public.payment_details ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212    213            F           2604    24712    work_schedule_day id    DEFAULT     |   ALTER TABLE ONLY public.work_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_day_id_seq'::regclass);
 C   ALTER TABLE public.work_schedule_day ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227            G           2604    24720    work_schedule_interval id    DEFAULT     �   ALTER TABLE ONLY public.work_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_interval_id_seq'::regclass);
 H   ALTER TABLE public.work_schedule_interval ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228    229                      0    16489    account_details 
   TABLE DATA           �   COPY public.account_details (account_key, hospital_name, street1, street2, city, state, pincode, phone, support_email, account_details_id, hospital_photo, country, landmark, "supportEmail", "cityState") FROM stdin;
    public          postgres    false    197            F          0    27738    advertisement 
   TABLE DATA           Z   COPY public.advertisement (id, name, content, code, "createdTime", is_active) FROM stdin;
    public          postgres    false    244                      0    16502    appointment 
   TABLE DATA           (  COPY public.appointment (id, "doctorId", patient_id, appointment_date, "startTime", "endTime", payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id, "slotTiming", paymentoption, consultationmode, status, "createdTime", "hasConsultation", reportid) FROM stdin;
    public          postgres    false    199                      0    16513    appointment_cancel_reschedule 
   TABLE DATA           �   COPY public.appointment_cancel_reschedule (appointment_cancel_reschedule_id, cancel_on, cancel_by, cancel_payment_status, cancel_by_id, reschedule, reschedule_appointment_id, appointment_id) FROM stdin;
    public          postgres    false    201                      0    16527    appointment_doc_config 
   TABLE DATA           �  COPY public.appointment_doc_config (appointment_doc_config_id, appointment_id, consultation_cost, is_preconsultation_allowed, pre_consultation_hours, pre_consultation_mins, is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins) FROM stdin;
    public          postgres    false    203            A          0    24932    communication_type 
   TABLE DATA           6   COPY public.communication_type (id, name) FROM stdin;
    public          postgres    false    239            .          0    24635 
   doc_config 
   TABLE DATA           �  COPY public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, "overBookingCount", "overBookingEnabled", "overBookingType", "consultationSessionTimings") FROM stdin;
    public          postgres    false    220                      0    16544    doc_config_schedule_day 
   TABLE DATA           Y   COPY public.doc_config_schedule_day (doctor_id, "dayOfWeek", id, doctor_key) FROM stdin;
    public          postgres    false    204                      0    16552    doc_config_schedule_interval 
   TABLE DATA           w   COPY public.doc_config_schedule_interval ("startTime", "endTime", "docConfigScheduleDayId", id, doctorkey) FROM stdin;
    public          postgres    false    205            !          0    16568    doctor 
   TABLE DATA           �   COPY public.doctor ("doctorId", doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email, live_status, last_active) FROM stdin;
    public          postgres    false    207            #          0    16587    doctor_config_can_resch 
   TABLE DATA           W  COPY public.doctor_config_can_resch (doc_config_can_resch_id, doc_key, is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_resch_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, is_active, created_on, modified_on) FROM stdin;
    public          postgres    false    209            %          0    16598    doctor_config_pre_consultation 
   TABLE DATA           �   COPY public.doctor_config_pre_consultation (doctor_config_id, doctor_key, consultation_cost, is_preconsultation_allowed, preconsultation_hours, preconsultation_minutes, is_active, created_on, modified_on) FROM stdin;
    public          postgres    false    211            )          0    16642    interval_days 
   TABLE DATA           ]   COPY public.interval_days (interval_days_id, start_time, end_time, wrk_sched_id) FROM stdin;
    public          postgres    false    215            H          0    33192    medicine 
   TABLE DATA           �   COPY public.medicine (id, prescription_id, name_of_medicine, frequency_of_each_dose, count_of_medicine_for_each_dose, type_of_medicine, dose_of_medicine, count_of_days) FROM stdin;
    public          postgres    false    246            E          0    24958    message_metadata 
   TABLE DATA           k   COPY public.message_metadata (id, message_type_id, communication_type_id, message_template_id) FROM stdin;
    public          postgres    false    243            =          0    24912    message_template 
   TABLE DATA           E   COPY public.message_template (id, sender, subject, body) FROM stdin;
    public          postgres    false    235            C          0    24940    message_template_placeholders 
   TABLE DATA           s   COPY public.message_template_placeholders (id, message_template_id, placeholder_name, message_type_id) FROM stdin;
    public          postgres    false    241            ?          0    24923    message_type 
   TABLE DATA           =   COPY public.message_type (id, name, description) FROM stdin;
    public          postgres    false    237            9          0    24773    openvidu_session 
   TABLE DATA           e   COPY public.openvidu_session (openvidu_session_id, doctor_key, session_name, session_id) FROM stdin;
    public          postgres    false    231            ;          0    24783    openvidu_session_token 
   TABLE DATA           ~   COPY public.openvidu_session_token (openvidu_session_token_id, openvidu_session_id, token, doctor_id, patient_id) FROM stdin;
    public          postgres    false    233            3          0    24691    patient_details 
   TABLE DATA           	  COPY public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id, "firstName", "lastName", "dateOfBirth", "alternateContact", age, live_status, last_active, honorific, city, gender) FROM stdin;
    public          postgres    false    225            J          0    33460    patient_report 
   TABLE DATA           �   COPY public.patient_report (id, patient_id, appointment_id, file_name, file_type, report_url, comments, report_date, active) FROM stdin;
    public          postgres    false    248            '          0    16628    payment_details 
   TABLE DATA           k   COPY public.payment_details (id, appointment_id, order_id, receipt_id, amount, payment_status) FROM stdin;
    public          postgres    false    213            G          0    33142    prescription 
   TABLE DATA           �   COPY public.prescription (appointment_id, appointment_date, hospital_logo, hospital_name, doctor_name, doctor_signature, patient_name, prescription_url, id, remarks, "hospitalAddress", diagnosis) FROM stdin;
    public          postgres    false    245            5          0    24709    work_schedule_day 
   TABLE DATA           W   COPY public.work_schedule_day (id, doctor_id, date, is_active, doctor_key) FROM stdin;
    public          postgres    false    227            7          0    24717    work_schedule_interval 
   TABLE DATA           k   COPY public.work_schedule_interval (id, start_time, end_time, work_schedule_day_id, is_active) FROM stdin;
    public          postgres    false    229            o           0    0 &   account_details_account_details_id_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.account_details_account_details_id_seq', 1, false);
          public          postgres    false    196            p           0    0 ?   appointment_cancel_reschedule_appointment_cancel_reschedule_seq    SEQUENCE SET     n   SELECT pg_catalog.setval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq', 1, false);
          public          postgres    false    200            q           0    0 4   appointment_doc_config_appointment_doc_config_id_seq    SEQUENCE SET     e   SELECT pg_catalog.setval('public.appointment_doc_config_appointment_doc_config_id_seq', 2453, true);
          public          postgres    false    202            r           0    0    appointment_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.appointment_id_seq', 2712, true);
          public          postgres    false    198            s           0    0    appointment_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.appointment_seq', 17, true);
          public          postgres    false    216            t           0    0    communication_type_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.communication_type_id_seq', 1, false);
          public          postgres    false    238            u           0    0 0   doc_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE SET     ^   SELECT pg_catalog.setval('public.doc_config_can_resch_doc_config_can_resch_id_seq', 2, true);
          public          postgres    false    217            v           0    0 6   doc_config_schedule_day_doc_config_schedule_day_id_seq    SEQUENCE SET     f   SELECT pg_catalog.setval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq', 492, true);
          public          postgres    false    222            w           0    0 ?   doc_config_schedule_interval_doc_config_schedule_interval_i_seq    SEQUENCE SET     o   SELECT pg_catalog.setval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq', 583, true);
          public          postgres    false    223            x           0    0    docconfigid_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.docconfigid_seq', 109, true);
          public          postgres    false    221            y           0    0 3   doctor_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE SET     b   SELECT pg_catalog.setval('public.doctor_config_can_resch_doc_config_can_resch_id_seq', 1, false);
          public          postgres    false    208            z           0    0 3   doctor_config_pre_consultation_doctor_config_id_seq    SEQUENCE SET     b   SELECT pg_catalog.setval('public.doctor_config_pre_consultation_doctor_config_id_seq', 1, false);
          public          postgres    false    210            {           0    0 2   doctor_config_preconsultation_doctor_config_id_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('public.doctor_config_preconsultation_doctor_config_id_seq', 9, true);
          public          postgres    false    218            |           0    0    doctor_details_doctor_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.doctor_details_doctor_id_seq', 95, true);
          public          postgres    false    219            }           0    0    doctor_doctor_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.doctor_doctor_id_seq', 1, false);
          public          postgres    false    206            ~           0    0 "   interval_days_interval_days_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.interval_days_interval_days_id_seq', 1, false);
          public          postgres    false    214                       0    0    message_metadata_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.message_metadata_id_seq', 1, false);
          public          postgres    false    242            �           0    0    message_template_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.message_template_id_seq', 1, false);
          public          postgres    false    234            �           0    0 $   message_template_placeholders_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.message_template_placeholders_id_seq', 1, false);
          public          postgres    false    240            �           0    0    message_type_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.message_type_id_seq', 1, false);
          public          postgres    false    236            �           0    0 (   openvidu_session_openvidu_session_id_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public.openvidu_session_openvidu_session_id_seq', 18290, true);
          public          postgres    false    230            �           0    0 4   openvidu_session_token_openvidu_session_token_id_seq    SEQUENCE SET     f   SELECT pg_catalog.setval('public.openvidu_session_token_openvidu_session_token_id_seq', 21007, true);
          public          postgres    false    232            �           0    0 &   patient_details_patient_details_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.patient_details_patient_details_id_seq', 876, true);
          public          postgres    false    224            �           0    0    patient_report_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.patient_report_id_seq', 1519, true);
          public          postgres    false    249            �           0    0    payment_details_payment_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.payment_details_payment_id_seq', 2765, true);
          public          postgres    false    212            �           0    0    prescription_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.prescription_id_seq', 198, true);
          public          postgres    false    247            �           0    0    work_schedule_day_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.work_schedule_day_id_seq', 1, false);
          public          postgres    false    226            �           0    0    work_schedule_interval_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.work_schedule_interval_id_seq', 1, false);
          public          postgres    false    228            R           2606    16497 $   account_details account_details_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_details_pkey PRIMARY KEY (account_details_id);
 N   ALTER TABLE ONLY public.account_details DROP CONSTRAINT account_details_pkey;
       public            postgres    false    197            T           2606    16499 "   account_details account_key_unique 
   CONSTRAINT     d   ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_key_unique UNIQUE (account_key);
 L   ALTER TABLE ONLY public.account_details DROP CONSTRAINT account_key_unique;
       public            postgres    false    197            �           2606    27745     advertisement advertisement_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.advertisement
    ADD CONSTRAINT advertisement_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.advertisement DROP CONSTRAINT advertisement_pkey;
       public            postgres    false    244            X           2606    16518 @   appointment_cancel_reschedule appointment_cancel_reschedule_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT appointment_cancel_reschedule_pkey PRIMARY KEY (appointment_cancel_reschedule_id);
 j   ALTER TABLE ONLY public.appointment_cancel_reschedule DROP CONSTRAINT appointment_cancel_reschedule_pkey;
       public            postgres    false    201            [           2606    16535 0   appointment_doc_config appointment_doc_config_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT appointment_doc_config_id PRIMARY KEY (appointment_doc_config_id);
 Z   ALTER TABLE ONLY public.appointment_doc_config DROP CONSTRAINT appointment_doc_config_id;
       public            postgres    false    203            V           2606    16510    appointment appointment_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.appointment DROP CONSTRAINT appointment_pkey;
       public            postgres    false    199            �           2606    24937 *   communication_type communication_type_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.communication_type
    ADD CONSTRAINT communication_type_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.communication_type DROP CONSTRAINT communication_type_pkey;
       public            postgres    false    239            j           2606    16595 1   doctor_config_can_resch doc_config_can_resch_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.doctor_config_can_resch
    ADD CONSTRAINT doc_config_can_resch_pkey PRIMARY KEY (doc_config_can_resch_id);
 [   ALTER TABLE ONLY public.doctor_config_can_resch DROP CONSTRAINT doc_config_can_resch_pkey;
       public            postgres    false    209            u           2606    24657    doc_config doc_config_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doc_config_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.doc_config DROP CONSTRAINT doc_config_pkey;
       public            postgres    false    220            ^           2606    24683 2   doc_config_schedule_day doc_config_schedule_day_id 
   CONSTRAINT     p   ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_config_schedule_day_id PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.doc_config_schedule_day DROP CONSTRAINT doc_config_schedule_day_id;
       public            postgres    false    204            a           2606    24681 <   doc_config_schedule_interval doc_config_schedule_interval_id 
   CONSTRAINT     z   ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_config_schedule_interval_id PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.doc_config_schedule_interval DROP CONSTRAINT doc_config_schedule_interval_id;
       public            postgres    false    205            l           2606    16606 /   doctor_config_pre_consultation doctor_config_id 
   CONSTRAINT     {   ALTER TABLE ONLY public.doctor_config_pre_consultation
    ADD CONSTRAINT doctor_config_id PRIMARY KEY (doctor_config_id);
 Y   ALTER TABLE ONLY public.doctor_config_pre_consultation DROP CONSTRAINT doctor_config_id;
       public            postgres    false    211            e           2606    16576    doctor doctor_id 
   CONSTRAINT     V   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_id PRIMARY KEY ("doctorId");
 :   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_id;
       public            postgres    false    207            g           2606    16578    doctor doctor_key_unique 
   CONSTRAINT     Y   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_key_unique UNIQUE (doctor_key);
 B   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_key_unique;
       public            postgres    false    207            s           2606    16647    interval_days interval_days_id 
   CONSTRAINT     j   ALTER TABLE ONLY public.interval_days
    ADD CONSTRAINT interval_days_id PRIMARY KEY (interval_days_id);
 H   ALTER TABLE ONLY public.interval_days DROP CONSTRAINT interval_days_id;
       public            postgres    false    215            �           2606    24963 &   message_metadata message_metadata_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_metadata_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.message_metadata DROP CONSTRAINT message_metadata_pkey;
       public            postgres    false    243            �           2606    24920 &   message_template message_template_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.message_template
    ADD CONSTRAINT message_template_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.message_template DROP CONSTRAINT message_template_pkey;
       public            postgres    false    235            �           2606    24945 @   message_template_placeholders message_template_placeholders_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_template_placeholders_pkey PRIMARY KEY (id);
 j   ALTER TABLE ONLY public.message_template_placeholders DROP CONSTRAINT message_template_placeholders_pkey;
       public            postgres    false    241            �           2606    24928    message_type message_type_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.message_type
    ADD CONSTRAINT message_type_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.message_type DROP CONSTRAINT message_type_pkey;
       public            postgres    false    237            ~           2606    24778 &   openvidu_session openvidu_session_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.openvidu_session
    ADD CONSTRAINT openvidu_session_pkey PRIMARY KEY (openvidu_session_id);
 P   ALTER TABLE ONLY public.openvidu_session DROP CONSTRAINT openvidu_session_pkey;
       public            postgres    false    231            �           2606    24791 2   openvidu_session_token openvidu_session_token_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_token_pkey PRIMARY KEY (openvidu_session_token_id);
 \   ALTER TABLE ONLY public.openvidu_session_token DROP CONSTRAINT openvidu_session_token_pkey;
       public            postgres    false    233            w           2606    24699 "   patient_details patient_details_id 
   CONSTRAINT     `   ALTER TABLE ONLY public.patient_details
    ADD CONSTRAINT patient_details_id PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.patient_details DROP CONSTRAINT patient_details_id;
       public            postgres    false    225            �           2606    33471     patient_report patient_report_id 
   CONSTRAINT     ^   ALTER TABLE ONLY public.patient_report
    ADD CONSTRAINT patient_report_id PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.patient_report DROP CONSTRAINT patient_report_id;
       public            postgres    false    248            p           2606    16633    payment_details payment_id 
   CONSTRAINT     X   ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_id PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.payment_details DROP CONSTRAINT payment_id;
       public            postgres    false    213            y           2606    24714 (   work_schedule_day work_schedule_day_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.work_schedule_day
    ADD CONSTRAINT work_schedule_day_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.work_schedule_day DROP CONSTRAINT work_schedule_day_pkey;
       public            postgres    false    227            |           2606    24722 2   work_schedule_interval work_schedule_interval_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT work_schedule_interval_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.work_schedule_interval DROP CONSTRAINT work_schedule_interval_pkey;
       public            postgres    false    229            \           1259    16541    fki_app_doc_con_to_app_id    INDEX     f   CREATE INDEX fki_app_doc_con_to_app_id ON public.appointment_doc_config USING btree (appointment_id);
 -   DROP INDEX public.fki_app_doc_con_to_app_id;
       public            postgres    false    203            Y           1259    16524    fki_can_resch_to_app_id    INDEX     k   CREATE INDEX fki_can_resch_to_app_id ON public.appointment_cancel_reschedule USING btree (appointment_id);
 +   DROP INDEX public.fki_can_resch_to_app_id;
       public            postgres    false    201            m           1259    16607    fki_doc_config_to_doc_key    INDEX     j   CREATE INDEX fki_doc_config_to_doc_key ON public.doctor_config_pre_consultation USING btree (doctor_key);
 -   DROP INDEX public.fki_doc_config_to_doc_key;
       public            postgres    false    211            _           1259    24706    fki_doc_sched_to_doc_id    INDEX     `   CREATE INDEX fki_doc_sched_to_doc_id ON public.doc_config_schedule_day USING btree (doctor_id);
 +   DROP INDEX public.fki_doc_sched_to_doc_id;
       public            postgres    false    204            h           1259    16584    fki_doctor_to_account    INDEX     O   CREATE INDEX fki_doctor_to_account ON public.doctor USING btree (account_key);
 )   DROP INDEX public.fki_doctor_to_account;
       public            postgres    false    207            q           1259    16653    fki_int_days_to_wrk_sched_id    INDEX     ^   CREATE INDEX fki_int_days_to_wrk_sched_id ON public.interval_days USING btree (wrk_sched_id);
 0   DROP INDEX public.fki_int_days_to_wrk_sched_id;
       public            postgres    false    215            b           1259    16563     fki_interval_to_wrk_sched_con_id    INDEX     }   CREATE INDEX fki_interval_to_wrk_sched_con_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");
 4   DROP INDEX public.fki_interval_to_wrk_sched_con_id;
       public            postgres    false    205            c           1259    16564 #   fki_interval_to_wrk_sched_config_id    INDEX     �   CREATE INDEX fki_interval_to_wrk_sched_config_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");
 7   DROP INDEX public.fki_interval_to_wrk_sched_config_id;
       public            postgres    false    205            n           1259    16639    fki_payment_to_app_id    INDEX     [   CREATE INDEX fki_payment_to_app_id ON public.payment_details USING btree (appointment_id);
 )   DROP INDEX public.fki_payment_to_app_id;
       public            postgres    false    213            z           1259    24728    fki_workScheduleIntervalToDay    INDEX     r   CREATE INDEX "fki_workScheduleIntervalToDay" ON public.work_schedule_interval USING btree (work_schedule_day_id);
 3   DROP INDEX public."fki_workScheduleIntervalToDay";
       public            postgres    false    229            �           2606    16536 ,   appointment_doc_config app_doc_con_to_app_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT app_doc_con_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);
 V   ALTER TABLE ONLY public.appointment_doc_config DROP CONSTRAINT app_doc_con_to_app_id;
       public          postgres    false    199    203    3926            �           2606    16519 1   appointment_cancel_reschedule can_resch_to_app_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT can_resch_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);
 [   ALTER TABLE ONLY public.appointment_cancel_reschedule DROP CONSTRAINT can_resch_to_app_id;
       public          postgres    false    201    3926    199            �           2606    24969 &   message_metadata communication_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT communication_type_id FOREIGN KEY (communication_type_id) REFERENCES public.communication_type(id);
 P   ALTER TABLE ONLY public.message_metadata DROP CONSTRAINT communication_type_id;
       public          postgres    false    3974    243    239            �           2606    24684 6   doc_config_schedule_interval doc_sched_interval_to_day    FK CONSTRAINT     �   ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_sched_interval_to_day FOREIGN KEY ("docConfigScheduleDayId") REFERENCES public.doc_config_schedule_day(id) NOT VALID;
 `   ALTER TABLE ONLY public.doc_config_schedule_interval DROP CONSTRAINT doc_sched_interval_to_day;
       public          postgres    false    205    204    3934            �           2606    24701 +   doc_config_schedule_day doc_sched_to_doc_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_sched_to_doc_id FOREIGN KEY (doctor_id) REFERENCES public.doctor("doctorId") NOT VALID;
 U   ALTER TABLE ONLY public.doc_config_schedule_day DROP CONSTRAINT doc_sched_to_doc_id;
       public          postgres    false    3941    207    204            �           2606    24658    doc_config doctor_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doctor_key FOREIGN KEY (doctor_key) REFERENCES public.doctor(doctor_key);
 ?   ALTER TABLE ONLY public.doc_config DROP CONSTRAINT doctor_key;
       public          postgres    false    3943    220    207            �           2606    16579    doctor doctor_to_account    FK CONSTRAINT     �   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_to_account FOREIGN KEY (account_key) REFERENCES public.account_details(account_key);
 B   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_to_account;
       public          postgres    false    3924    197    207            �           2606    24946 1   message_template_placeholders message_template_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_template_id FOREIGN KEY (message_template_id) REFERENCES public.message_template(id);
 [   ALTER TABLE ONLY public.message_template_placeholders DROP CONSTRAINT message_template_id;
       public          postgres    false    235    241    3970            �           2606    24974 $   message_metadata message_template_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_template_id FOREIGN KEY (message_template_id) REFERENCES public.message_template(id);
 N   ALTER TABLE ONLY public.message_metadata DROP CONSTRAINT message_template_id;
       public          postgres    false    3970    243    235            �           2606    24951 -   message_template_placeholders message_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_type_id FOREIGN KEY (message_type_id) REFERENCES public.message_type(id);
 W   ALTER TABLE ONLY public.message_template_placeholders DROP CONSTRAINT message_type_id;
       public          postgres    false    3972    241    237            �           2606    24964     message_metadata message_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_type_id FOREIGN KEY (message_type_id) REFERENCES public.message_type(id);
 J   ALTER TABLE ONLY public.message_metadata DROP CONSTRAINT message_type_id;
       public          postgres    false    237    243    3972            �           2606    24792 *   openvidu_session_token openvidu_session_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_id FOREIGN KEY (openvidu_session_id) REFERENCES public.openvidu_session(openvidu_session_id);
 T   ALTER TABLE ONLY public.openvidu_session_token DROP CONSTRAINT openvidu_session_id;
       public          postgres    false    231    233    3966            �           2606    16634 !   payment_details payment_to_app_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);
 K   ALTER TABLE ONLY public.payment_details DROP CONSTRAINT payment_to_app_id;
       public          postgres    false    213    199    3926            �           2606    24723 0   work_schedule_interval workScheduleIntervalToDay    FK CONSTRAINT     �   ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT "workScheduleIntervalToDay" FOREIGN KEY (work_schedule_day_id) REFERENCES public.work_schedule_day(id) NOT VALID;
 \   ALTER TABLE ONLY public.work_schedule_interval DROP CONSTRAINT "workScheduleIntervalToDay";
       public          postgres    false    229    227    3961                 x�}�ݎ�0F����&�I*U]��l�M.�H�Y)��ؘ�fW���G�M%.@��3�x
Jw3�Y+�p45�L*�A�ʴ܂@+0��{6P�F�Eyr7˚5p�Ʌ{Yv�`�g-�,I32�rtt\��#���.�TI4C����E\B�L`�9���U�o���Sf�8Nr�����qT/��B�f�h��c��l��������oK�wM
�Er�b�j���V�ZA�ڶ���>�}�sTjٳ�i;9Wl.�g�wI���[���2,Yc5COݟ�֝�5�'mww8�"Tӊ� �sn<R�q���{a����nWC�x��0���!��(��w�ȼÕ���Uc�K����.�܃u�����b,X6ĹV�-�{9�xc%1��$^�M���B]ZC�_A �Ys��������2��c� =���u��ژiS�.�~U�-�ܜ���D	�� x�;����4��狜$��=c|ޕO�?fx�U���d��<O'��_]�a1      F   W   x�3��MM�L��K�N,KU05PU�OKK-RH�/RHLN-I����/�H�Sȅ�T(-P(�W02Q��/-*��s�(/6��"�=... ���            x��}ˮ5�m�x�)��u��3���������ǃ�}���&�zuw��A��}�}6�U,^?�R�/���J�J�_)�%�O�|I�����~���o_��׿������o��C��_����/���?����_���_������������˟~�ӿ��R�/�)FI�K�����������Ҋ�t����&j�H�Rӓ�IW~�~��*j����ewV�H�{����)��])w)���^?E���b��
�W%=���T�����s�%U~��J�̥�?F������E	�$�
_®� ������YY��DmS���J瞤�Ty��K$-�)ɟꕦ8��LCI�Tz��0�R(%P��5�f��)*b@W�g���,��e�6D�V�D��R7��Ś�cCi�Vj*%�KJ�]m�I���ښ����bCi3�GZ�$%�;��~ۇ9KM��b_N��+jn|_wO��.�x�}yg�	���O��FB6��_�$jA6߶����,%<EQ�Z仴��~��ߥ�|�bCmS��3�%��,j�ѳ<6߱,�X}�����b��v٤��Y����;C=��J>�.��'N�2�&E!&�|ʉ�rD���0�{h��;p1v�=2+���=�˔�M���w�n�s7���{��������D�������e:����J����ԔR(��ڥ��v��=��d�o�1�0[V$|�#�x:9[�����KhD����������?�ex���zB9��M�hš�̡&��T��|ǆ�}���>NlwhW��J�[в���	���4�Sy�O��V�i�C�&=�+�4K����de�i�Ye�Xx{�Yj���$�KU'�l�.�e��y$驪B�z6�i>J�Բ�i��H���kF�I6r���b���J�FU�5�R������EMi��Euzuz��7�Y�-���Q����j'�P�?�V��K1����P��H퇷�Ɍ�~h�����N4�z)��TMIl�&t�IJZv��c��W�h��	z�&8eu���v_��w�|��4��dr���Q)fBrәF�wC��}�3A�k�ƨ�3����Y?�:�Zh��ɬm�o+����?��B�P{��J��>���K�VGx�|MUG(�v~n��u�ρO��*HM|�t+j��h|�o-Q�T�0�*j���oR�M����S�yr�Dk����^�������҈{�쩤j?���BV %uΞ���U��+]���*��L��JZ@����NU$�_����������Q}�0�X�+R .��>�5��"�ctw��d=�����.�٪Hhʟ���PR
�� Ga�����i����U
�?�0�Y�O�C�T�\�'����#�[�CJN���Uk�'��
�������h�b�)���~a��I�	���Dx}������Xò�`�~�L_��I?�W�����(@����G�&O~\�L.BX��0�ZS_�R�)J5�g�;0�֘*��0�&J�?>Ƴr҂��O���:y���J���=IM5���]n-�M�f:��D�_խ,�������,y$"�g��yf�m�B���\<4��'\RlIj����Q�.r�|��|��+�N	�I��z"9{����vp�heL��?��W�ɔ���(�N��,���t��4����قd�M偿u�`��PV�����d�I\qt�3�2^��#�6]-�����Sf��Ng�C)^���:2׉�8�F2�k�$>�0�b����fJ?������<� ����Xd3�CAMʾ�D����' {�o�'&���{Ԥ�U�~ԣ�&G����.e�r4�K���<����8�˼*�"[��cח!&���C����c�s��k|�ғ�s���{9�s��m���q�� W������o���Wrr.x��vhσ���<��e��x^�f�Z#3O�?TF�p�Q�$��|!ç��ښK:M���Z��YU������<{1q_L�@]}�K��PY��[Op�� v{�2������E��M���q~��
z�%��<�ۜ��~ԇ�X�����k3;K-�_���hD���Sݏ:�k��g���3h��q���g :C�؋�e��!�F��`Z�zYҗ�$�uNrO;�Ó<g�uFE1r���$r�%wFNN��M����>%ӡU�
�$r��u[��;�ۥU��V\��Bx�2���\�Tg�%?E�d�O�rjO9�9GQbu��+�_K�I�MiVU�֌⁩9KJ5܃�_��N>jm�(���^O~b�nO|����N�����>M�7�X�8ǖ�)	�l ,��fs�Qg�!���HH�}���FCm�E14���g&S�JgO���@�~��;���j��3o�4���c���_����~���:���� nvZ���'i�4ԩ[�VL�9!�V�,E��L5l�)z=-<��2<NU%VJ���;�q����A2�j�A�wU�gգ�NH�W	�^��y�����q$$��ɜ�Ismu���-h����|Oe|�k�R���J�ԙ��څ���3E;���rUzW}��8��w�0�:l;9&�d��tھKy#��/�������|r���PN��[ �A*ᤘ8�c���h��f��5+��^U.�lOv�0sQ���6�Ӡ��z�2	P��|��s�R���j����O�8�Ȁ�B��<��J;����{>��:����3�!��غ,�vF��Y"2��M[�������2m����Ŭ�h�g0�]ܽ��b�H8��*9}}��h@�;O����`k�K�]��v��a����������G���>�9�S��0��t�q9�<��~\�#��;�=E{_kߡ���~9i��(?�u�܃8�7A}fP'����R���7�yu}����:e5[��g>�^�����Iɫ���Y�0�k�N��/CHM-��c�q�(����$EvSi�.-��(�9�S�Pa�:��O��m�P�/|MV֟���赊֞gx�|���]'ɷ���g��l	���U`p��O�K7!+j�����r#jh�ȣ7�Jʚ�v.;d��LDq��o(6;�.���*3��8��S�*	�r,!����d�t(3��j��6�Z]��
O��噜��E��l��9�e2\4�;$�O<4��ene��qƧ��ˉ`������S� ����tf�˙��P��>(2���Q<A�ϊ��8�kϒ3H�,P�u
��H[�4�q
�Mb���-��o�h鋔<~�+�������]������@��l��:I-V���$�v#��Ԕ���[���͡�Q7��J3n�&j�ڽ��̂���.�9�t��s�f��:t� �6���r�Q�a���c�O�q'�#�Te�w���OA���KF�OR_��܏1�u�*�F��������bCj�P��n�J��!տ���dKj���ܯR=R�W��_�[�`E��_ez�v�q�W���j<MM�&Ԯ������o:K�7��EM���Pb��^ֈ�R��{�w�ܤd�Wh�i�Dg���J����Te��{�0X���[�G���Wm�)߮�~�U�p�B*��Sϯ6���7U**C���������p��We����Mm7�	��^����RR�����k���^�-�?�uc���@[�=_�d����U��7ݥT⏕y	�YJ����a��7+�����!5��,�������_���A��%ՠ�,�'����ŚE��8GK�i�M{����L���{��-����'H������/��R<V�%/JJ���l�Gɖ�R�[��쳟/8�;w�=�W��J��
c�O%�OQj�G[{|�V�K	}h%Yn�(~����U�P|Z:;����du}����1NRVH_ݛ>y�I)�RU�M%�$���C߸��y/^�h��]Q�oW�@qʅ���蕞|���tY��ZytO���I���H�ы�:�ՈLW�D-3(ُQr_����v{��EJ�Ci�ߚ��B���(���"P�}Q��y~�n��R��� �`��I�e��vH������k>S�Qwi�����e�g(�3�)���;ƀ\��$��;QiD��������B��Bu�f;é�B={"����g����bJ+z�cT������    i~�lj
OgZՈ�-�����|���3'ƙ���X�y	�����V4������f`lAi4g��GA�3��4��x�R,)IY졜ףm%���Y��{7�a��(5�&�	ǈ��D�xG�Ro�2�W�Ǿ�֤^LܼI�ؼ��o����`�O�$?H������+���Ó��U��}�*z��1�SV��ˤ2��^�?�쀮ge��.�[M�?rW�%z�����ø�|�s�)RN�K/a�'��X����0����6��c.K#�@L��>������_B�uXy�,T�9��{�(H�ٸ@d�q�
��Մ�)X�S��ٰ3 K?�,�$�t�?��o�lޖ�(��M�1 ����X�$�F^�I'�!��n�����Oq���-`��8� O���ӼX�xR�Pʝ�oުl�~���2�yu%���a�	'ť��(W�	��J��39P]�)�6'��m�`R���glV9��|�5?�O�l�r8�SzN�7 m��z���8HV\-Q즮���n��+�BLX�%g�BW�>�uT
;k�A����ߕ4V&����d���z1z��D�v\��ӟ�r����%��a��@�ɛ� "\=G�W��v�s�����Qu�(��]�S���٧A�*�D���E��={�L8��Y���SX��0+����p����L.�[Ă*]
���o����PF�tD��;8X�R��;L���GoS@�H ��W���Y�q�M��HV��4rQ����;�4�}`��&�2�(`іtA%�~l'� ��-�1�����bҷv�
d@q�ڮB�1�4���C��*�GV�����<S�	!�Z�Dl3��i��c��АXJު�^,2;�t�<�������j��6������4�����чr K�oArN��~*�<:�ᡵ�� `Ezq�F�_�@���m<���C����&�I�2��?}�_���{�Uz�t�s��1�"բ�5ķ�`y_�)qP��6�az��C���ݥ�L�u��M U�D�H/k�8�"�T�.�kH=.��(�YO�1sƺ��|ư��5V�M�{�ࡀ^�rw�Zy[gr�� n�$��-y,b��>��`�5�^�T;yS`,�
��D�"5=�<���	����_f�JHℸ?_)%=y�`E>���%����e @�\��m��9��1�� �mĎ��#�` ��-��7���1�|Q18̈́�(�.ylvs1p�u�Œ����|�&!*�kn�����g���jW�H�ąD�U<�M*Ac[�=�����|_#�]�l@3t�&O���J��{���@�H�2n�i
��bԊZ?T"O�1~!������� ���~҉�6�hz~�/������r��c27�%���a�5��,@�Q/A�.r�ŔR=^nv�����B���b��7h��с��͟<"���d}�@��8g߬g��2�~��֡��ϖz�T��o/b��D+�Ҙ���!�ɮ��G��@�a�D�xy6�T)J�{�{�C6�x�g�~��e���ù�2����0��ʗd!,���<��׷��x�����������k�X��pjw�������E��@NK�H����2RzN3h���q��ʞur{s�<br��wTl����2Ȱ8v�ymJ	���֎��ל�h�V\��\	�^j{C'���R��J�1���s�����o�~q�$2t���w�b�#dOm;�����(�{�-�K�M������>(�'y�]��j�{�/1����Sp��t�?<� ,D���b(}.��}�<������#�u�kl 1�^����sΚ^(*9kn׊�Y�5�j8�!b�] aWI���u~��Ǩ!Iz�����=Ǆ�̮N�ƃ��9���e''�5  2(��.���W �1/橜;��C�CX��2qv��&�X$�R�h�&�Ժ,��煤��`
�w%�:M�Q�)ΉX�p��=	D�́���ߖ?GB�w7R��9��Tr13��60;������f�O�/���B+��/f��c�`pQE:�+H��2����a�B�I�E;�X��b���}�`���O+Y��Ӣ��z�ޭ[Y=�[ά�]��7҄ǘ���z�?�=�����d��;�������q$�2�`�h��P��Y (�H'��ي��y�w9H�л"��L9{Dɀt�Hk�2�P�53 ����h�fU|8�_�[I�YP��$k$�A�YEB������8΂w]������0�ܻ� h��,rձ��V�['��|FN>�C���vh�3�7Pe������M��G��"U9%J�1q��������1<s
}x�k'k8��ޕ�\��~	��7�,s$}�'���2��;$���o�u�~��4��r��sM�>�A�72�0q���΀md���b
`?�A���}��6�S��B�_�%JJj�g��&�n�Pu����n��~*��\��J���^���^��9s���"�q��aU��=������`"8���
��Gkn�`����2�`z<픸��thz��C��ʚ�0���=1�&6[g/� ��֮�Ş�y�)��p0R@��^ ��+w�+�
܃^��m��\10�h�E
���l����6���ஏ�w c%�"�s�u���B�1 \[�E�q��]��������E�PQ���=#&n[)` LM��v��s��`x��B7��`�IX��h�\�a���oEaϩA��"�;��f��υ�#�6�&�8*A���o��}Y�@���ƀ��\�8�{K7J� b����\P��֥�&������1���	V�B�3�`�����>DIjl_{ӻ�N�C�ǂ��+�v�N!���b������?��4ĭ�\^$��ˆ8Ke΋�B�Y�qV��k���$`�r�#Z�c�J�Em�у��B4C"&�d 
������
�}���9�#�K�w��PI &��&~�!(,j�� q��|@���zPFZts`�NU��n�\�X4��C��k��:c�]^��;wXSݒ}��<��<\�Vf.*�7�� N�N����4�`�e}�j0C�6P��8)w7s-0��t�:a���t��w�o�݅�����z��$�~�����`/�)�#L�7_��(/�Z�h�f���w����~�k a����WPN�}w�d���3o��=�;F���dCO#�C��;/�q�ܖ��߳�f��hM؞ m��� �G����!N�jG���M?_x�?��`��^|�3HN�.2T�����U2����Ixn��r���=���C�XK�u���ێ�eө�W@�$�7D;t8�H9�R�F��K%�����u`��b}�Z(i��)�h. �"�Y4|����B/a�[!z�� u�����)Z���m�o�~��.q�[r�Y`���V�g����%�)�
���g��P�tțS�gv M�v�w��^5I��`�E�h�F���(�V�Y�Ӧ�b�ۤ*)`U�K����p�bt�\�ba�d�X:��A��f9��o�w�)_Ia[�� nu��<��A�9���;ʨ���0k*|Ӝ�uѽ��@� B���V�F�?���^$�9���U`�J�_ K�q ::�I[(u����78��7 �$�	p�S�=�_`
u����="�Wԝ� '�^2���0!��,����s�7���e�<��5�I �>Q7
��o��Y�Dt&�eZ�-x�UW�w
���$#�B�q�F����8@���,��|��'p��YP�l��C�("��W�E����@������r=�q�����AS{�d7�����\�>Fa68b;}T�Vwp��q�p���ս̎��#����$���[��}���oC����#�pr
�b�ntzZb<�XK2P+x� I�B�v�;�MH�:������b�!]ۭje�� ���`	#2[Gd�b�3~�pI�.����=�D_�EzR��    +�R�
�����f>%P��1������ه�H^��Z�g�h^"���>�疷O�CL�Fz�����9N��mg^��Ğ>�t	"=
��Z]�>�l��׽[x�*\��M"A4�:|�)@;>�iq�GJ+�Y
�n�H_;��Ie�"��}L�7�R�A� ��o�����A�t��/T�'1�`
������?�a�$`�=�Lz�q���"�2 5���(j��^T�=CUz���Fϕ����r��A��4^�M�w��|$'��w^|���h9$%Ԁ�dP�%�l�~<p�Ŭ��p���C����~��[ν�\C�q��Hy��9mz��u2�֋Q� f�]y�laP��,����A�hA_�z����<���U�I,�m*B�Ƃ���x	6�W� 2jc`�bs�H�������!�����l+��Poj�Z{��5챍Fy�O���w`@�s����h�`��s��¾2@nSX��UŖx�%Y�Tc@���S�U��;C�Z<��^qq<�!\;��wC��6C�!�/p�M�M�-Y�XðBG���$��(:Wп��;��(���]`ͼ���Ў<� v�����|��K��@�p ��80���/�C�@(�m�.����
�S�O!/�J�@�(4 �@�סS�A�2ٰ��B���ц ��+:� �_�Rd�onRa�_m�b��>߬Dy�:�����Mb_O�,F�~�N�$�a��IXk��BT��z��9s
������Ͽ��/C�0XF0TN�Ma��PQe�8�(�q`� �c�g�� I��*�V�El^��g��e뒎�-v�������:�[l@K1�����̒��t��h�KGP.�x�d*H%'ם�W�G��.��]�&�ݕG�M�II/�\���M�"�6�A�!j2b�Y��>Fg����1���H9��`�~IQ�82Y�>�'�"
A��:��:� |�ESn�5��@�Ӯ#�����v���!y��-�r[�����\�$� ��3�=��I`UE�*3�|�����Ɣ%	9��&��>��Z3�73��)ث瓙"���@�%׌#�8��ub	����F_��q�M�,i�&�y�睆�}6; %���|T*�����#~D�(OO6��B$�l�d��#l]��-Jû&���,he�����/����!_���Wb0��|�����T��<P�s�b���,��^@En�]�~2�}�
�g����^vo�M�Π��BJJ�8��~g��-o�@U�1uV�Y���R�E��� z����K����W�Q�U0��8!}�&d$�F2ZH�uj+RVs�oէ��k�0Ӷ1��j�dG/ԹE?l�9��=	�����oh�q:S��7��uLy,}���Q^�����jz��2f��~����ħ�!��b�E]��v���ry�)KZ�X�%����L�����9�:���v�X�.��K��N���H�w���_oqP~
�����U�����V���7.w���W���%��G_8�����O~�H�:�*��H�U�>�@�1������XhaEuzsȟ���z��}�l@Ģ��~�}��������ِ;�p�O�s���2��j�lN밷~�=8�n��T=��0B��t����pH?x$q!o$�w6ك��	�ż% s��l�j��`S��8#]�r�M�M��W��6Y�Ɗ��7Bw���|#O:)��26�I2]��N�s�`�`�9�䇦�fp��r���1�����ߛ���dO�.��.�����a8 A�&Ah�����6��BA�g�4Ȓ����߿	���꓋ۗY�.�BV�jO)���J�oA7��Xn�����9,��``'��� ��m7�6����#u�m����p�de"�y.�q�Ö�fD�g��(��P�u�����H|	�!x� �k��71~��Ö5��Q�i��.���ל����i�;G���d�[���eӄ,]$��ܩ�XO�Ai%*T'sW�zI|4c�I��KWJ�(u�y����M�.�t"DD̜������B�� ����g�����0�6��9�2q���"$ӅM���{A��T8���Q����I�w^��{ИD�K�+��7m�N0$�l�m�~���={��zg� ���[��@���C�߯�q��@� ��w$�D��Rw��L��y�I~��!�gc�NĖ�XX^��|!�!`5���Y�S(�Qrꂀ9{�
5�{��V`T�!�O���U�ϣg�����-��}o���kQ&���Q���U�&��Oנp`m���&�M�����Wv�
�x���s7vo?�� ��Zȹ��y%a���-.�S��-9z����H�}�k�cDms�)J���4�4 ��@��ax���(�1�`�`?]-�H�g�L�~�s"0��2��v9��t�rw8�+NJi�Tb��vw������xV5nt��1hzf�U���G��!1ɽO�y�H%��I�/8xkR�N&(�I��q�Z��ǀ$���95!8��Ѣ�4�}a�U ��=8��I='8𠒬X�>A7x��;����Ⱬ�g�G�]��s��;�8ɫj��fdG��n��~�����H@�$��<�g��+�_����_��x�lx�oP}� �3�r�e����t��r�^�Ƚq��L����҂y�D���DȁIN"����(a)�
��c
۴��א�ܙ�4 uP�Y����n�s�1��$Q]��&�E0���w�v��~�b�!p�$�M�몣S��SE�d�vs0B�C� ���B!J0{��W���2N�]���Wq��v�����l1�����?��[~Ca�%
����-��`�#��h5@�F��P�(w:r0u�����Ǹ1`a�#i$���)f��^���,dR�>7'D�|,7�g9��̎��B��#I�����Q��.� �KC1z萾�����t��O�6}5�B9��ҫ?��V��>�$�"�n�-O&�<�,olS|�X�0bG�7i_�3��S@&����ggp�����=�]A���A�>��%���,ۆ;`�Q���<}��K��Kn1��o^doj�,iHd�=T�H=� +�Z�n|�(�mU$�10���1��K�g�"�*���[�x�Fw�i&P�M\�^N�Rw.�M����
�Ƹ���Q�� O__n[y�)���_�?����[����}C^�d!��E�
�����X� M���Tn{oJT�5����}P��k�8CO%Wt���}y�x�LPE<����7��s�Q�Q�.�k8�	����_3�7&��\�� �+��H��x��}��?�I�X�慨b!�5&��A��%�ĳ Vy؃�����*@��SeO����.�{�Z���;�0�1���c�y�@���g�E�: �;H����1@���R��,(_*R�yκ��>��SU�r�#vI��	�"Lcn��Qm~ґb|/c���y���ŀo:`/��b��F�%�i4��9�5�r=�B}�)T����8}0�i�]D뿁��4��	�w?��BP	��6~�]�\#����oa��mr��q����}���"���"?[����w����<���Ju��[��W���:�cƩ���[�bm�#�ݕV�-]�r5l+g���-��.��C'	��&v��1��F���vNg܁�Q�Z ��P�^�~)?��)0���� 	�]���AT���J=��亭|���B���0�<GCy� `:����.-I~�+Ճ��ܯg�A��rY*;��o���*�]�$�옋g�&�2�Hd����j��b(�ӊJüE�~)/��[)��f�S7-�oj��-�\_�%FRܾbE�q�o.+�,��l�<m��Gmǜ�6uAWR�6�\� B�[�{Ȼ4y��~��"�.x���pǹ���=�c����?ٕH1�����{y��;ts�.���"}�d;��k-�[�#��[���>��@�5�����`��4�\֮pEF�C+Sb,E�F�x�pt����s@    :i?�PI�>_�z���	�:Fhx߫}U��g�m���D?�d x���a��V7����G�D_f����wS
��MP�TX�He�I��;���y'���)��hJ�΋���sdS3O����2�z,���胾{@�`� i[1��rh�^l���8�o�I�`����o�t/	뢏��dt�/�$;A�$���гL�!$'$ ��,��pȻ��~d�G+�jJ,������ ���/qh�Z<y�A}�5� !ʆ|o1�(@8˂Ĺ�:&�|W��ǽ-�/X8w	��e�C����@,����X�y��H�*nH�М�,��8��K4X�T�����@��k�x��p�()����VUmz�?��t���Eܰ ���Կ�R����=��+�y�xK��DL0wHt!��ɻ!T^��M՗B��� eֶ�L߯C�y��3e>O����dQ��-����K!�"��/��r9�l�m��X?=�Ƚ�p��O��,^�c���wX�w&.ё$��rŁ�^�C�5.�\�d�qP����C?w	@`9;.%� �FE抛�b���x�Ǜ�à({�j����z���0|�����tM�0\�}�=@� Z�X�-�|#P�t�,�c�(��-d���z-���ެd�M!��iK��g�X"���);=�����#�������`
����!\�r�5P���)�wZ�"�&s�ow=�Ds]s1�f�j0�żi6z���)�h:��Lы+��RZ�4Q��R?��r�K��W):ΐʸV ��p5T�G��CDW�r��w���X���ܜ$�U�ߌ���6���ڥ�쇒5��l���/�^E��P�-�A^ao���WeA:���ٟoq��6��*��W������$i:����>���j�����?X�( \�9����傦+�NQ���t{���ϳ�k�͢Z�;�M�g}\�@�W�Q��|��,:0����X��b������ N���?���D�Mx���o�%1�I�a@Q��Lx�d�ÁF��t����-P ��[&xf��0yɹ�k$3�~�F(�q�1���ϔ]�7`\��a��N�U����;�h�3�K�����t�v��&�:��Ф�{d��H� �����s5��m<*�W�����z�L����#>�� I�䙱�N
x��<s̚��=�R
ν;��g�n��$�X��,��8�[��l�
�3ը����@�O���A�,3�Vu%�-H��s�FH`@��5�ob�����3TSޥ��h�L/�o�Ϝ�ܞ��L�����Lۦ#k�Ť� p�,M�Nj�������s���)xt���x��;�q��F�gv����3�p_�Dh���H�$�]�i�=����A�C$Ej�5aغ�J=�*��`�_d��p�]-���6M\�+�.H唊�l�X�ǖ�ݔڨ���HcD�+8fh�i��a4�:֫6�r7�7<�5��DP֮�cۋ��.�!l���g
�A�AEv��-�SQSoì�6���*�X@�v☑z���%Z\���ѳp��fuR/j.��g�0١Y�]!��+?W)�bu�D���и�v�%�p(����n\�g�C��j)����S+p���"���(P��>a��`wb��0DrVWYxq'�=�KdeZ�:�0�C�^`�+o�W�<�S�"Y;����+�)����f�W,��<����MM�~��w�gi;����48@]����Z]>ς��t�o��WG���$+��")l:*�wg�g =2�$c	H�O���LH\0y�6y�B�8K"��>��;u?��VB����M�<I�["���z��S���s-j�T���rv1,#ԗ�5bKՋA��=&4���fLh\Ym�ɓp7���6;P�̷1A�)�|������72ܷ��4��?Z��G��2�q	C�KŘ�?0�BR���R<Xq����"Ɖ������sxP��$�Č�c{5����Ӱr�,Gu͋[pF�d��R��<�:ւ��=>�K���`aY�f!N������kj+ovK_�{���q4�������Ĕmp����L�/�ۗ�&��;���C�O��7�S0<�@_�\<��k�^�����~��%�s���Aa�4���h���w�����Ʌ�H��j&�d�޺�{� �~�]D3}t'{ξH?)��L�=��-�{�V�M�H���0��0��aO�4�r��Y�V=�(_��6� ��a�UP"��T����ŝ6Ը�CQ�����������yp^�5H��wxX����tl�w	�.��x�'��gd���p����g7[?�M������mdnC��m�I����6��y��H�
һ�͍
R�:LкscC.���M�_��ǧf+��Os��(7� ��5���1:���������t��w�d!����N�?�)R�֋�Dk8����Y�!{V�P��A�cXʝw�J�UT]��w�@��Q���J�rS5~��V?��T�+6�P�V"���Y1M"H���<�������`тK�~+%6�**�����G�/�Z %��\�qC�,.Ȅ��,|ͅ�#�gr���0}�y����k�����D�v�21��Gj	�Ԓt���QA�{�P�y�LI�S�����7R�x���T֋�^�,0�(i/�ml�'1E�>NK'�)��%��M@��`?���N���^B�0a�=H�Xs��ŷH���F�e`o������vZ,��6I9�X�PA�x�ʽ� s�Xȸ^� �E�����,l,<G�?Ȁ����ѷ����u\MY����c"�[�sL��d�,�����3'��T\���!�U��o�P�0���W����Y��.~�4l�Yd c`�������jѬJ��<s4�K���C��	���N�+��-�0��F����O��H>'��_A�<c`3*����+p}��GrN,��cָ�	O��	�H��p�8V�q���Y�8Ϝt�c3�eg��g��#l�,���>� }��ޡ�k���b�rي�t��I�(�ӈ��ᙗ��j��K��U�c'����O�$�V�)s�zy�E��H����Z|��m��O )c�B]#����w����¿�a�
�s�;���<i�{��9AP�![I��Mx�z[ y0J��+��dAMJ� +���9�y�� �0��&ĮU�����9u�A;�~K�3����C���ҷ"$���0Է?�_k��0�6��H;d �Tq�k\��P�X	�`�� �g h�G`l���&����XA%@�X�6�K5Xʓ�%n�z���t� +�w�#�7�y$��"eVG��BL�{�z<����9,�Ǳ��T�h-��1 ���L����_lMX��֧Ћ�kD< �yC�v(�Y �x���EiG�A^YPb�Ć݃���� ۪�bN�A��sXeF��sPj	����s��{����fa��<����,G���f��Z��MFH���rz�T�0�0r9��j>�}Y/��kIĔ��F�X�C�P�M��q�\	`h?�
����O��~�l��Ӕm�)ߡDr��M=n���zQ�Q�8�}���bn� 2�A��jh
>������61�7L�a��=�:�c�*�W��ev�z�c�0����+�[��?4B��K���z3E������_A���@,%t��c<�	��.�	�ܷ�J���~��#+|�#s��C�@��a��,��a'�e+�pS�.�%!������Q��_��8���!����'�١s��䯓0P)Ma㾭���5��[���-���}~�����x��XÄ��Wp�< s�]�a�1�\�-6H?tۋ._�������()�������<�`�""K�����6�		�l�5R(����O�۷�eba�4�kf�=n�,���K`��;�
���f���H0�fq�I��C�P�κ	�    �2��Pp�,�!��Q�/�wy������
@9�x��^��<H��RyO)��9܏V3}ث�Hj"Q��\�c��j�Nf�����sڊ{P���]���+��ò��g�CP����F䇇� �)�����:��>��[���!��O�%��t������!8�d{vMi%�K�w�?Ê���"�]B輅��Rz�Ӊ�Y���,�)�`輦k�R���W�]x�
j��b잂�j͗2��+M/AQ�Ba�Q��H���۷+{Զ�g ?K� �2G
{V��q�p!���ˠ:�$н�o�S��
�\�UP��\�i��cy�	����b��v/m����%�0`���W0�/�B���}�Y�1�l:�;��bb@B&�*������n�Q�M.nkv�Ma5��ü�zX�_X��86j�#��y�8gC>�l	~�Lyz���Un���S ������QO�me�р��� �Y�ΛAT^֨����H� �2���WsCv@L�t�ȟ��q�T�;�yt��s�=�˦a$���%�=l?�B�`�' �2��YTjapW����K1�ˈi
[�qf�H4�2��;�Ȭ;eS���h��;�u�zqL[��=��N���{'���ӊ�9�Ҳ(V���s����3� r)�$ua;q�cN��@V��pRe;���j��4�/.9Q2,�eT��'�x�4I���Ѿ���_.B嫈�Y�LM�~n驫��Q���+(�5l�����uJ�m4,^�.s�4C���������Y�@5e 
b��E��My�3ı�CU\7s�ޱ�3R�����hi�r�o7����RX�v��mIO�� �Εg�?z��Xd,�ϞT]̈́1�IQ���#�Dϲz�I+��z��D�~%�e�a����9b��vP��: ��vo�|��}���x��Fq����]�f1z4��̗{��,�M*9���N3j#���l���DU��(o=�:���^�� Vp��s�'抾�ňЧ!Q�*j�U�u�z���]^����#z����ge�7���-��A�0X)��_C]D(��0/�z��o�I�_ϙ����:#_�U���Δ���Պ�`�:��I�e9�~"�&"���P�P����*#��I���6��	i���!48h�a��8h	K*�X,�qUw��Pp��{"a��΅}���6�U��Yt*,F2}�*�}��X�䛥���}k{����}�R���1p�%3�k���Q>����'��`��Y�(��"���tO�c�Y�'A0L�k���6p��M�,$�ࠣ���1�M�6p	�$�� �u��'��Ʃ�:��Uw�ȷ>����$��/6}h�唾��c��)
�.1 t�����	��f�AqK%���ݩ�{l0�K�̦/�`��3k��jˊ�����9a�*��}��O`�5ja&/�G� /�0��ЋJ��ρ�s� ����{=s��D޼9�FK�8&k	�`�0�l�K�`D]�-�֢Y ��M���`��a�@��i1�:d��bXp{�ݞ�M{ }�ED� \W�^�M��6�-��Ŵ�e�X1�-n�|V WHѤ7-EK��uQP��[&������?���<�;Z���px�u<~���u^%P9!=W|�	ʢ$��;~�1���>S��x(�)��?��%&e�'1�ݷןpW�5�d��-\���;�����,��3��8+��Gx�V0�P�h��U��� ����uq	vܡ7� je!M�"�G���#��p�Ђ�>�����[(4U `ܭ^X�3�St޸��]���-u^�U)����PB�3Iz���i���@V��
�T5�����e.���I���Z���QOc�*�5��Eh(#�U�F��&��̀٫�)����)���v�o�64�bW�W0���[;y"�#Å%�/�r|�E-��S�F�i�7C��"�^�\7)�5%Zˎj'I�1�nAKH�(�a�u'(v�^mX��9�)�=��Ap�V����h��(-��zSn�p ��b��T�Q�qX�W	���.y�%"��u�Z�T��u���J-�͇EQc��!��ve��	�(�����yj�p��,���/��U�ho[��"�P�::"R�P[X�Zމ�n��R@�Y���M��7?Ի��o/��mm�p�X2͔$��V/oaZ����}.���j#N���8I�ų��7��sBh���wi�:op#���4M��P�绁a�b+�%�3d 1���;��4)��9B� �D��iӳ=�2�@Dn
� ����%;�M^~z�E�,G��?�c@cl$X�҂? ����[���W�h�%*���'`�����������E��I%���_�~D�Y9{m,��u,��ľ��Vd�����@��@
��^#|�?~��L^�$�P��E�LmE���7ga=O�r��Èc�V1�� �UV�K��'�q���r<��Y*"�t����� &�5��qa� k��mb �I���W]w2ۗ5\%��*�z�޳�w��4m�B�w�����9�q]^y�$ܢX��\\>�s���{^�I6��ր�9����Y���{q���V5����!yt1������Yx�>��f�W��W#*�i���k��#�L+{��2�s&���6{%�(��fu��ӽBQ������6i�Z/y�ܽ����׃�_���W�;�k|�yzz3����}�2�2�w�<��z����q������֣.$�pM�1}w��� l[<�|�p�^��.`���>�I{5�۬��Ɯ��9k�O{w5nvj�kw_�~A���n%�1�0��n?�E�<�<L�v�sw��Z$˵S%�y�p������aSb1L���|v;����i>'�d�2w3�f����I�ǥ�WG ��e�C]~�z3�����;-=־��a��
��Z:�5ɾzT}��|�V>~ְX�_έ��y� �|�amM~�
G��	���)g?��/��M#��0��
 �ݥ؇��Fԙ=)����_/�;K<���(�e�@y���o}:C>��$.�ϒ��Qg������K���ZWSW��M^Á��/���s<�|�����+c��mm8'�󂳟�)={���Y���M�%����&_�Hf�ǔ�U�g�2��.�rF�I�����"�yw�k���k����o~s�a���ɽ6���Iz����Tp*�iu,t�5��&��LhePk���5Y�V�7:w��TS��`T�ȮE�y�{�]��\�K������o�M~�L����Z���k:w>B����J$FVnq,�c�nRx��[�!? �Mk�9���k%�i$��.3&�,��+ r{~s^�<l�>]�]eY���t̌���>��,�n��W�At���2��uV�>v���y4m��J8�m|>��3�k����y~�D]Y7W��Ex��[���@�G�Yd�W�07��i��5	M��#��\�����1e�h+�.�ti�]?��q��U|��i�G���O�]�>�}��#�.wh�z5��3�C9�����4��C���02~�٧ ���:��	��TX7�I�g��S"����+H����)�s�rlq)W9�hi�Z4a�l
��!x�� ���T[�����zXC��)�s�t
��Z!v
��5tx� dq.��A�F��2�b�J8�<����2�&�2)�w28��28}/�յ�O�2��ȿ��p!��q�$y�&���o�Ӻ�g��n+���*Ǳ�Y�뎕��o�(D�GB$��~��w��"�}���æl֠��>��k�b�b۪��Po�$ 1�8Į8�oZ���Z9��ޠ�9�-j6e�h�e��n)ވS\<_�j��R~N��� �0�l�y=e�^������W�W�?tO=$ p
��/eLO�R�����mS��/��ΐo��L[[���PŲo	����.ޛa\�d�Y�ʖ�U����t����ˤ�i�L=4�V�,{������    X��@�H�TBɿ�A�1[���`w�3���a�"i۵1���A�4nk�z��̇1o��k���*4d1m�vè�Ȧ��F��z��7��y�lPw�(�Ts�VB���6�-���$����\"�m&��5|���:�a�i
�
�����Ő�ƅ+jŢ���7r�44��&�� �v�k����S��l��i��1�^��a�N2%��]��<��Ҏ�;9��,�u��Xu<��4e�U�bM���W3�qV
e&���r��g�� �'�d�Iu�l��}�Ɏ��qr�ll%����}5�h�x���O����3�NE>q��֚J�^O�:cB��i�8��4J��n�EC��׎4Z.�ֈf����{p��pvY�D(bnlS|�i�+�u1^w��p�C<������a�t����t������eܣ��[�"�o���ڐZ��@�ݹs��h�v5wR�uc"X"��������5M��]�o��خjz�h��S�rS�T�̽���AA2}6]��L�:=�1%ɞ����v�`O6��P԰7���g���8���i�0��7fQ\�U>!z�O�Ӭ<s��:��M��8b���ؿ�����v�o2�3
~}\և�e��zRn�-���^uMz���I������7����O����-�:C�zdn>�U�^���p�b
E1�ʴ�*�p��͞e�ag�N�CL}�m��_�v(c+��E� ���՛CtCrԩ��ݥ��I�)h����������SlJ��l?A��h~�'N�ԇ��Q;�i�0��ȼ�:�}8�e ��3Q��f�
'��ӎ�3�����ݎ�}�p�2b#-��	������ųW{.��{��	�,��a���f���j3������M��������==ó�j�����{�����)��Lc5Q�����f��m~�/�[�~���i�/�5�I3#�h��8�uSV�7)_Kh!U�X?A +���@u�u�|�S{��@
47�,�"�`5gW��728��ip�8���7��� be�/4��
S3`�G_/�8��y&|����%>�H`#o]�'�Ȼ���������5_�a��r��q��o��$.���ʈ�&����o����RFشl1�B���q�pN�Y\����ɂ5��Q���2U���L�d�s��}�R���}��{�h_{�p�&�ӌ�|1����`�\& $���j�:�6�v]'}��޵y6pd��P��.3�>�~��ބa��xG�\�3p�r���2�Sp�)�yʷZ��!��2I�V%��XgQ�%*&���/ӽ���Q;nm�Vf!Л�v��c�[z��ty�c߉���ڱ���r��=�������P6]���F]<���_��+&������a���3��難Ǎ��J�G�/ 6��u0¡�>�+���u��v|��:���Xe������S��>�p:Ξ�%�^M��I#��	I��T���t��~��t?�'t�\!�z-��������.�m[F�v|��kFF6y��Y�%ɴr�
�$��$��'_/z�ܠf̪&������ �L���H�����ds $�Z���n&��	�����2M���qFz���
�:��(�xX�LP��+�NS�ā=�&�;8��3]C%�.���Id
p6������?�?������f� �hG%����<���̂�(A�y����=i7��Z'��+y72�����G�$��h����6T�@ޗ
��/V���]>��G�F~�(�Ƴh��cM�+�G��e<-��JE�|��;-r{!j�Yh�b���+�)�i�TC(�&�mJ}�8izEa&���ä�����yU6L�'�߿�1�|�E�1R�K�Mfk*��/Aa��fYI��=~C��,�;w~�߄�T�I�(9���v�˷����0�	�mF��l����Z�J�J� �O��ֶ�} Ґ��^K�~-a��$�IC�u͵��ሇQ���<��/�ʶ����4V5D�j0���@(�� �j�!�i�����<*���pq��#[A�_9�
¼�(AeMh1휁�ރ�Z�$z�p4���У�7��@Z~��v�����?������EX����7����g,��q^��g[ �.�ƹX'�g�����P���=�u����"����ͣ��?��+�>/-!--��[6��S�����+�%�� ���N�*�k=XL���E�� ����8ұG� j��e	��#�� y\�I ���.�F�<�u%���3ַu�@Va��f`��da�kj�T��|�׵��M#j@ڰ���O�f� �p�?��Հ�c�w��}��r���#���0[�	rB���{���E̺o��#��a$��x�Nh�Y�.6u�P�n>��~��\�=ͻ�g�����H� ^�EӢ��f$x�*�`.����U���>�n� ��chrZ�����q����������=�"0k��6�(ە<#.`���@t�hV���/l�T���j�zލ�
,����l@���8����g��e8ozV��V���x�{	���޿�>^d>{S�W�vcB�A�� �j5�Ƙ��,d�z�'��`���. T�� 27 ��G�v�Q�"|��9�L�T��W��y��<�+coLq(�$�K|�5��f	 ��=�CH�n���!h���3�A��RY��:�x �q���עX�8���N�8���q�1h�S����Y�9Μ�8���Bb������:�?�ꅱ�j=�`n���)j����m <8`�GiB����q�a�3&I�v���SJ=��dl
�v}���	�u�����^�$�Yg��n���J��P��L˂��o6���}���L��w������x�PT5ϴ�{7΂��-�3�hsq�乊)�?2h.�LE8�ĵ�x��%2�5�#����pkŵ|k����h�h D�O��#լ�٨)D��g����� Y&%6e��U��V�2�1H�Xҹ7��x��q.���
]�D��'����HF��wN�9����|����kf��R�}�`H�)$�R?r;���uR�?���_<��!D�~[㈇�+�>`� &Ħ�:���ϝA���Û�V<t%}q4���8�8]�ER�����^�߰�K,+a�^��|9Ҡ�4�p>�ɷx�����U�iꔙSb-�k�����rm`��-�P�0]�ݺ������.H��8C���g�1q�楪A��]�y�Nˍ����Sb<�:v�n�0�:a�}+\��k�x�;������e����ˇ�(7s�f�p���ž�o�L�dY���9w&cCi��S��	�bBֽ��zX7��?�U�9$s�J�j����p<׽�y�SA4.=<_LOR���B"~����7���B�� `9OGY��b���G�8x�}Km�����l�]\�(R������Ք���[:|nF�����Τx��C]����s=��C��!�'��:��!D\�$�GCӍ��0(p�4{Ʃ���.����&6�}C�ЈF
�;[2�H����1=�t������f�-���t]OUo��;v*�>@P���)���?�z��a{�bX�{Wʏ?���'P?�Q����;�4���C�͢΀b�`6�e�{�!���ۀ]]r�nI ��:�_v�ʰ����a'�^�_|��cː��,�j�84�w�HR�XD``hL��H@��a�p[��J��fBl����7��M>�15�9��?�2�//2\9�8��]I�]	[{�py����
���v��Nq�a�~MV���D�_v�����dDb���4v&4B���y�1	�m�vY���u-i�Y n:��p��P��q�2�P���eg�ĳ#��j~d� ��@�	�6	,3#�Q[Q�N@��{Ɓ�8�������sW`1�b ��,;��9�Kl���S�ĩR%0�pлI֜�D�$�8���߮���")���2���@�P~�f�?oK��ܒ?�P��s�ǅ���^A|�y��    �X�>�J���T�8@H �(�O����j�����#��*W ���9+�UX�J�rd���V{����xp��&}��h#q��&�\��c��{�t�"�D�z�h4�s�J�w�C⨑-� p��]S�W��+RDM�?�7\=��]]�Т�w�^ci7��Ҭl}} D���1��{ �2ѯ��~?\h�¬��7|?K(�ؚ������5`W�b
��_,�;�q*��s�'@mM��r�CAl>N?ů�t�����<) /K��Ŭ��.|?̺|&Le-�g�CO�b�G��ji�����uS~��y�Y�7�+��i����~�uC������ªHʙ@U�%��Ŵ	�u�������@���K��o����8�G�éf�׮�~Q�����f?�h�\����٫�c<�ziD��S�DO�ϗ�W�EK���J�i��Ţ�k��$}��x"S=�C���8���Q�`@0��:�鯲/ Ѡa$� �wԆ|����!bq,�Z������<}��ai���9;��Z�z����|?�Ȧ���	{�x7��~?��FC�uź���؏4���吧�Byr,�d�u4����f����t6}܀�Ya �����!�bm�����lol�O�'�#ʎ�=�����R1����3 Qԝ���Χo�b,�������~�����7��?[�-�#����"T��y�Gӎ/��y��[�ߪ���������*�ͣ�b�h�9���k��&�zK��?�>�`p��o"�Чălo^��n��A��<K#��l����������	���<��3� ��uhy�\���!���E*� ]M���ˉ��
��fY�D��LX�7b ��v��i@� ��;�TS��"��?E��2Vȧ�=\T�����A(���HH�z�WS:�>NB�vmoc-�U
l���˾��?��<�^��ZgQ�r(���TI�_.yA�N�s��#nc�m����n7�`�����v��Ě���5�A��L�㣎W �a�?���8}�3ʶ��l�v�b=������at5�o���}��x����sQ3��5���n�<�)��|?��̦�!��,���{�����CP��u�q�#�'��X�7�9\m��o�v ��C_cƙy<�-��&�Π���3��4.��[��ps�]�gQ�8\/lH����h�������xA5�k�M��-h�V���Ց8�;	 M��&|���uS^7ϔ���ێz����[^�r���M�;��&�_n�U�����������̹~�C�;ފo���4�G{o6ү'�� ص�`��wwSov��EG_x��{�n�M������rx�n	�,�����r�d��ͪ)���X��X{�:��^���lq��e� k���ι+�u�'��4���]��s;Oæ������:0��ޚ*�ai�3���فm�3��bL���ܳAI����6��n��M~lv��q����7��Ot0�~�ðמ�Ｋ��*����P&�I���;����w7�/>#�ׅ�0=ޙ�Ε=�� �.Q��Z������4�����ؙ	�$�GZL�s'c��GǲW7s�;���֮,����}}��|�<���O����3����5�B��/�-��&O�m$~�,��0��W,�Y��SԱ�j���V���Y|Y��?B>��������c�⯏�}�N?�װ|��?o��>=?_j�t��.�[���E�R[�%���f��۞1PF9�ݻ�˻2�3q$�c |��d�,��L�i�`<ڵ���/�%���<��j�g.��	��(`Cc�|��k%}�����i�����|ٚ���N8��7�Z-R2�櫒^ʝ�LO�C԰��4�����!��v����R���,���V}�1��r��7���i�!�����N�fqO��_|��y���h*�&����Xdv�~>·���K��y]�����(��~�d���(՗��o���~ߞ'B�=Ľ�Ta��ch���0p?O߿���G=b��+��H��c�C���@n���&8x�f>G?�Ȉև�_t��2d�Nӗ ���f-��W1���}�<�e�����+���+t!��'���7����?;}��H>����C�3���o����}x��J��&����/`1ї/��6��C��	�$���@�%�*�>�ec ��8l�G�f�g�Fa�[�����t�/�9ȣ�$�]A��uq�5[��z/��e��\��X�D��Q�%G�A�{ү�Ӑ7�y�"|��9�\A����'\�%���%�<6>_�w_b��������|ob5�Gv��̗���褷���6�w����@���A$%�����<�k{�k���o�Bx���i.����@���U};1�!}?� l$iT_���`�E���C1	 ��|�>�8��e���=�6ܵ��?�NQ_�L LK{��1_�=�����Iv�'�����&O��@ك��ޱ�`��;B�Q���,��xU�[��dгr����v��7P=���P��bN��Bc���r0;����Ve_c���۳�L�C{��=�#�m۞��*QO����������B�|���Vz�G�=�
7}��iW}Uc��o}�Y�7�!T{������W`p��m�;��{{�Q�Y߁��˸I���A�/S��/f�n�-h�����s��o��h�#�Oݿ�|��#2�K�F��̹oB������͆��N�����!~E��r��(6�=�����u����_�ރ��̀�O���n��xc�r�3��$�H��`�{��	�+��XH!��n"����(A���v����o� ���^K`�`dE;��\������6+�c*U\�������e�񀂖R>���4�:��pg|��C9���|��&$��9��ɮGՖ2RIJ��VpM/����-�������r��S��-v��5.o���2�q��!l�5�qCL�G�я����/� J�Z��qK̔� .`�Q�
f>���u�w�38���0�`k���QLb��]���{L�n�������$��u�<V�_�˾�<$B�=�/;!~Ϻ�q*��UUX������w�� �k/6��G��jR�ڵ�{��~P��哨��#�����+�*�`��*n�Ϊ�b�B�+x���H�g�֗8��<
/�@t�h������߲����7L��ͤ��P:���0�^���H�B6�5"��H��a4Eܮ��`�!����=�89�3^�R�׆�qs%�C�"=z��q�%��T��>R j;P\��0pde���Z���w,���6a�,;k�x���⯵VZ �jJ�����eH,K��`P �F��V��A�t���k�T^|KF4�k%z
����L�E���_+������qO�+��+?Ʈ�����d``�%Ka�6 ܱ<�3��NeT�b�Y.����۞���H���SN$)DV,�����+�6�#�-�U}�p�9��|h�ϣѭK�M~0Y��l�ik���r���iq��X�HFΔ^�b�B1X�u?85�w�A��RpzOt�9V�����e�`���н�h�o�,
�?��{���h_q��՘˅���j�b�P/~����:`���,$�`��d�`>z ���j��e wHI�X��Z��a�P��A�k !c���A�� \��b!�$C7}�we��D������ۆ���N�fu>��PF%�t�M���k`�3�P���W�|�>,��*���0����8	�L5�Nk�P$�|��\& *��S!vr�O3�Mrʱw�y�O_G�X��b'���j��d�dVP��Q2����<}Za�,��h+pŰ�'����#au�#�� �d"o�
�$��$�6��p�j$�Qt��F����%&�瓳BT=��ně�d��-;���x>"n^ew���+��z-%�}t�b�J�͕$5�9U۫DE/���Cc� ����LGt���7a[���Q���w`裏    F�����2�-{��#S�s>MNv�U�P��P�ȫ37�ps���3���Qꏲ��F� O�([�0��F�=����K�2�I�M]?b����oQ؏یĄ2l�V����a&f�,$�����4g5J۲�͝bN3Xz`������>�m�߾Y�,��P�1ɍ�A���S/�}�g�q���Eb�;���:�.�s�1���TdgG���=-�6����R=�v��i_�=z�,ƌuS�lt=���X �Q� ۨj��,�u>
G@�B��8�:�B���:���U?����M�e ��'��3P{/�ޔBL &0��Q�0��9�1�`9�Z�X�zSo{]M\��n
���9������Bc�)lJ�j��P����/hWc������e�'�#(�"�:P,���§n;�;�.�ЍQw@S�U�S�.7޳y��*M��>����'�ۋ�߰�t"t��
�΁���#�Z=W{�f�'��C��f6w���a��`j�M�\�� ~c��.+�aV6PAH\qX|�G�q۰�p��$�mU-����."� �D��4�����20:k��Q��S<Hl'�`��6����z0W��~[��s4`��g���H�E>�u����O��轩E�7��eCmlt��=6p���\�U^��O�{�������Eg;i���`���i�qU{�0�q�q�(��[��%��&����	�;�*@s."+	��?���4A����?�����v�l���@�#[tΕ�F�8��%�����C��A��L�(U:A�@V
 |kC�	���}ɮ�J��:�+�����+��E�M�2���j��Cv��p���Y����}�Fw��c�0����7}dsOa%Ro\7���(��$S�7�����Ŏ�=b��~�k48C�-ln��q�����9��u`1\O�l��	�_6C��T�v|-�����]*WD��w��#8>ӻ2��E	�Ï������+��FY���������5��è9����ntRC���; �ZrF�;��2ሉr��!U��y�%����>�%���D���!����r�����$�����G�E��^r?]�A�C�axɖz"t�
�x\�����p~I�<��%�@X�DЅ���
����y��s>2#q/.�ح�3zw/�cN��4��J�k�e�*%:��8_eu�Mxh�Ƅ�oK�P�s)���9�{L����!r[�#Ɯ�xP��Db�����$�3�_����#�v��q�~p�ŝ)K)V�.��c�K�ח�_��S7?2�������m`���s�'D<q��� $�
`eON[�"�Tc���R��&�� ��G;
n�!Wt�,)�_Ify4��M\����0��gq.�.ga�����Ԗ�G���[�Ò[S�(�Jq��NLCe�:��zHز�^B���fо6n���)����;�p�Wy�jDj鿅��4Qd䶣�w�����@�mg�o!x�s������dp�iP�d�m>��N!*���V��q�߳dd�F���sr���p��/�"7��� �3g�lv���bi����d-����jP��m����i�������-=`��0w����Ͽ�������H�0~��9B��EW���f���\�h76��C=���Ȯ���0W�;p��Z˸~/�m��u��e}˅Ƿ�(~6������gcXs����p��c�aP�d��6�������J�2#2\׏�4
���_
�S0❸�C��@��h���T
�gl���ĴDg�%�q�������ť���*�t�NH���/p��}�9]|�YܨPȒ�J�Ƨ�Eŗ���W��`��m�S�N�?^�
�
�~Y�:��O��O���T ��g:�A��q[�����E-̳xO�``ؕ۹�a^-�����?�l��.���$]��M	����޷Gᘯz��K*����bg��E$��(Z܏��[�V�n��p��ưM�_]~E��_q���(����>ި�5T����0s6�_������J<-¯0�%!~�u�,"1Kb	#���q�u𴋅ae������<����ӈ�n.�G�����PB6����2��H�d#n;��A�;�,�di�'0���U=�v:��z�% ���g�R���Y��N��4/�AZ������Ŝ���i���GTzQ¥�>�W�q
�Wąn�4�A�� .����0쫇k�N�~�q�\�E�����e�����DO��d�':�p�U3��H��h�/���#{AKW ���C]�q����d����o������>+2+�[�[��]���b�2F|���v��m*#r���g��4�zf~�>�&(�(n,%Ō8�a�5���)ϸ�;��T5O��\&#����G����-���X�S���%�_.)��r�Y�e��՞�:����g��|
��xU�ѵ�X7a�IW��|{�부c	� <7��W6[T>\�|t��Wv��F�V���t��[�� D[$��.gj�<������\Ch�<1�����m�G��W7׵e�X�M�3���� E���N�����>���EZ	0���|�_�v~�Hu-��ׅ�\\���,I8.��1�1��m�4l:-�����v λ�-��7]V�;���Z~Ku������X��5	�{m;D�;s�q�b��	��E�����{{��"<1��S����vq�TQ�й�<S��<�3�?�Z�Q���7�O{�x�LDq���#���鸦����T1&t��u7C�:�Z���|˟���!�iU�"���oӁi����r��h�Y�TFk,�_�92�e�ʣ��i�5�Y2"C�Ī�C����5%�,�p��&��a�/�5��Fl��cd�O��������O���E��k�
l�=�ԸO��jQX���6�Z�C���-�X&�o6��d@��|al�5W�����(v�('���H�~��/�A�K�"��t�u���E��ГO�Օ��Ad R@�F
X��>���K�5"�qDƗq�,9y�#2���gu��i$Q�N��2ecG��20�_O#��۔�,��ZUM�����x�Ӣ�����a�g@q/l;�c�ڢ�?CF�DpdR���ͺ�u��¥��ݺ�B��LF���6�|����'2ڔ��M[�T��1[7��f!�sdp��i�n�緜F�R�4�ɟ\CƗy���j�n�'W��2ܪ�E������M�������;�|"���nRJ���K�![7�kl��bQ@��V�Q�C&�ŢX˾�������$лȑ~ڴWm�}����V
�\[l��o3%Ҋ�J�����m{���A�5"Hd�W:F�tUF��ֶ��:Ï���pb���j���nD�)"/N�zl��Co-����Gnvqљ%��k�3����2{+�W��6��8ɥ�mL��BO7��~\X�P���<��א�R�����x	�K�����x���j��:�����7���O�¶՗�@WOkhn������g����K��i�I�S䵴�Jf����w��m0�T��g��36<�E���@�l�
3�b��|�
��PӾ�[��fE�b���uY�*8�[(���-W�b(*�`���j��ֹ�qO��<�_*��*W?��)�{�)�k���K�����e|�O2[�1��?���П��Mu]�M�ݕ��_�����X'���!��W��3b.種9V�g)p���̉�P���/�W�N��e��:����0�"��y�б�����<q��E3I<?6})�����>���X�3�u�\�/ �Q�0;��ơ����M�������ع.�1 �\jj��=��� ����{��ThB%CwS�� e�� $��8��c�Y~	��n�Z�5#:f�x ,-�b8��%���hyܚ}�)��1�1|�X>C*��{'�ɐ/o��d*��a̛w!!�4x�)��xAC�/�g�    �����y�u�Z�����ߖ=͗y�^0/� oȡ2	�ކǿ)ErZ�cQg�Ͱ�1����%��B�q�J�����ۤD�N$��1xx�bO�R�0$6ee�׊\\���ڋ|ߵ}#�x����٩�!�Y��m��*�1e��0鶁�<?�"�O�۪0N�i��M;9�"��0G���t�!��U��Z䊬����.��HKb�v�Zlq*�E���îZ/���|��ZA"��#���`2�hsuV���MS1Zג����y���y�t�b�p&/��ҹm�,�����"���g!�0S�F/Z5�ۘ��S)�[t�V��� ��&f�E�M�=
�y�Kmf����T���	�ˬ�.��}M�z,����ɢ���)��м�'��.��tX�v��+j���(M��ݾ�ư�>x��e~���a��%�8,�럻5�9x���'�+�(!S����F�YV�����G�Q�6� 	p�=���gc'+�>�7�h�e�tm5Ա��Qv�	̗B�����:��i�D�{aW�]�K�����Z���/�B1y!���s���%4+829r�T�<�RP���^��~�� &쑈愜^��*��6P$#�Tǁu�;���x��N$N��;F�.!vD�����$��2p/��ܾV:@���@c˙n���o?e�m���&����qJ���f���� ����.��s�(�D	���4}�������Yş�O����x���:�7xr��)o�\%ޚ.;:;�F�8����N��Q��y@C@���f�:�(��\�&bԀ��ј��O� ��Z�"�;o�.��cg��ŉ��膪ξL�(3qMձ4aA���2�����gU;D�,�N�]ƩV��JT�Q�e�6b�Prg�ƿU�;�{�R%$��T���.C��{�Df�B�x��������Ff��7��	�{Od��2�|�k�V�x<��{����(x��\dM���e��^�ԺI�p|OH
�ĕy��Ж,��xԴ⏕k����\�+'�+�������{��tOy�2�co.�D�2�����ܞxAW�X�]]b�%�<gἕ��a�y{�x�# х��T�N.cm�-�/Ʌ��k�]�	�aK.�v�aWJp#cJ�����^/^�.�Esh`��d�k�1����əE�.<�c
W���<#�)��B�Ez[�	�c7=W�z\�J���E�:x䦿�]ÓL�;PX ��?�(�]g�v~S�Jr���P�'�Dx�)������Z����UK偆x��K8�����Fr�j����#*�������h��͝3㪂|I�<��a���lk.@�d/O��-W�vc|�<}>�F^|����F�E��{�c���E���8��^�?����t1�+��h�H�O��fe�_Ge�!/ ��V��AF
*��a���O����(�o��Ky�x{�$�k�c����$����S��!2Z�\�\����F������$��1t��`$��,�W�� -Ր0p�p�У��܇Z0��&���`oY\�	y�4'眸�Ъj?n�BU2�8�H�<�k4øt �g��r�0�R�QiHC��x�V:4*5Sߜ��f	�鶶��ߧ˲:o�Pz],3�8s��J��D_/}�&,�#=��a� .�yV;�2��r�.���\N�a�In(:����O����1�����Н����e�ެ&<U#l��u넺u.�����魥���٢�%����.����)�Mn�TnE��9�&��vyC�0��Y�>�%�m�c�^��X�٦�n���[˯_��S� p�E��*�0_���R� �,a)@�>k�ޖ��[�m�{!�
p*-ë��_a,v�9_�b�u�ϣ��-��$x���!-�ۦ�+x�u/��}����C~(M��/���>R̓	MR&�n#�8��s;l�B�YP�x����'Y��m>�S��ҚB��w|r�;X.�3bW��sU�?�<��)z��H1,��'��I�>�g���=���!;�+1)R�'�q�z�h�w��W��C�z����ڊ���CE�L)T�fx}��3 �h$'�m�{4{~J��Lm�fJΡ�:vml޻[��-.��r�u�u�lk&b� ������!T�������/�VM���0�9�tm��y:�����b�+j��K���UͯDO��q�������)�PRX�ƞ2Hc�6�p��$��c�7.��?�m�l�U�w�FY�Ś�*l��!t�N��1�Te�^%/���9��m���D��#o��=%z�8�PFQn��&gsC����G�A\QI´z�(	sY��u,�2|6�nϢ�:��k��h�G
B��DK��T���M���g�z3���2/�~H�i�3l�I��qO���n�$K����$�$���]��4P$�*b0�*Fы�5��>�g`#���f�̬{x�e�qnQ�Mvb��q���>Q��[�
�s����wI��I�p��n 	.c�Ay�GKC��ً?+�D����~M����4�-�_���{�Z�������e_}+�����Coc�CPF�g�-���72��ƭ�����b�B�G.i�)�p��r%�D�=�o�bOzB/��AHKn��r�KAr�}g�׼AVk���!����.�I-	�u8���`�u,��%V��2֭����u|{_��� �K��y�����3�v@p{MqNWi�k�5�fM�?v�xG6`Ғ��_����m�����<u��ĳ�y=;n��V=*2xؖ�"����%�Db�HT�N�٭��������8E�"��ƴ����O&�>��^D����-�����u�dO�h]�3��_A����lo�AJ��dǌ�r��ұ��ѯ� ,�M���j'�܏�0\�A��LD�-�A�8~����2X\`�U�����a����!� l��1�^%�6�N��g��R���%5"�E�X$���+�H�,���wJf�����}?��_�������F�^���?;2��\z��L(���
��5���Qݰy�jZ���{�@��=������ZBh�{���r�Á��*��D�8�� ��/*.xb2S��@�2�!�'ԃ+���dT���j�x�����PZ���sC
��A�N�e��z���z��L�\���Z�@�f1!���;\� G�������P>����]�K�?{��c�̕���9v����*c���-�+qm&�2��]&/�b_���1���!���H1o�8R�5}���X7R�)��aFMߣ�{4������~��u���C�Ti޴w�s�r���˄�^/b��ic���s7!����$��(�+�����h�B\�?G�~�gD�ڤ��I��<���C[�N��ŕ�F$�=�Ot��&���p,�Y�ŉ�g�fS��{����=Yq�EϚ�y �3|�D;�s�0LG4$��$Ԑ��NCRjH�I��;2$�&�����}������.�����C���p������X5z��eAR=�Y=����,��ޮ]#�k_i��3�OY�T*��ꕎh����c�X�ˬ���P��\H�T�N�O� ��]sa���N��l����[���Y�h��{�ߴ:� M�����io�ђ����J����D�^��iXg�Pe�j��]a@���v�����#0(E۾�Ӭzk�A���5
�2�c�%"M?$����a�I�1�����)] !��d�3Y�LV<ñ8_�+R���ߓ'��G���b�{�m{���S��s��w����2w���dp��g�Ӷ^��y��a��}{̍�ŔU+1�����䪕?��'�,F���.0�"�Dk�A��!��a2g�|�	��#��t:����������%����~O?/��Kv��׶mhu��1��զ���
xJ� :R]~Ň�j�;z	b$A�$��1rOrn3%Z�������p�͋-(��    ���!�i��*��TB̠�%�^��ԛ4C��Β�U$��I�����f��7�:��B���#������;�	
��3q+l���hZ5_nǐ��C��f�"�|Bi�.|lVv�Ӊ��D�z"�R~ş}l�o�?�)�6���v�G:�eԌ|�.�M�	�x��o�?ԖSR���o;���,�1.�����D�Ȫ&�Xi�D�2��M0/��޹�v�wG��6���r{��w=��V��
KeU���{�G�Q7�b���؝��S 3��Y�Ɉ����L{&ۗ�M3� �y!&_6.�ՙ[�+⳦M1h�����d�D3� fx��t�L�I_<�8�EIJ�-�<�\)9UeX9��JJ6Y�TKlIz-H�N�Х����h����
�Ԛ��;���Ĥz�|i���Y�Q����1���@�l����=��ȴ)t�)t�A7�z-.*t���^�����I���������D���i:�-�� y�aJ��_�ΊZ�\!�~�����׫rP ��,��s90�0�Z'���%���K.�'�7"�\8Ռ��S$O$(�ۯfKp'�l��Wބ�>��vd��l�@y��@�p�-�ڰ	L�R�kk�cMEc ��.���l��L7���Qb�
�7��Z�Y�,�0mס�"��7:�j�A�b�^%�_�؝����)��yK��ϬV���x!�C�����ŕ"��� �ws������s�8
���:݀�CY��&Y�C0��m`l��\	��@�U�9��4�c.�b��-i�F�̚��&1�$������qz^�΂���Ul�[��9ä��ܯ?��
^LIq�j5�#��<޾�(�Y�5�'�C�B~qfU֦�(�ɼҍ���O!a��ִ���^f��tI��dmۇ��p�Cq�}0�e�S+���"�`oۤ�9�r=<�@���R�߫G۶9�xU �;ϓ.���*pkM�Tx�n<y1�3x���]J �Wo=�����2F����Pg`��X���d���B�Mb���s>�"V�2*�P�j��_Q���1#M!OA��+�)�1������-�Ҽ*Oj��X�f1�`�����øn��Ö��nv"��E��_��l�Qn��'I�oÂ)��<$�# �a�ֶ��X�v,׉��*/�F���v������^>Ȁ��d]�\��*2k^�gWdv�$�؎ւ<��kw��=d�y�����.Fo@N;H�Ư��ɼS]�4�1@�M$�*)�M$���*�UY��֓)Ht�EWdT�GR�4�R��Ǩַ��}'��D���ϵB�]A�q!ķYWW�`R�R"�~&�%^�Wo/)<>�F�M��zk�ғ�³40���x|�U?�T�8}��(���t���Oy~E]#U�*D����xTeK����񨹞'`�V8a���6xt���ƭ`v$�l]�I���/_p!a�19Z�x�bP�)�+���Z��"���^�im�y�"�v�e_[O���_`��@f�!����̦�I��/z5rZ����5m��;nԹE��0~Ѧm���z=�?2ox%[:<I���K�?8�����<���$5� *4�hS��fw�K!�qj���Z4'��O���_���;VdWS�+Lx�}M���1k�tf������'��>_;\"+0� �e�xSn˧�͆�U�N�O<��zW��۸�@�3�����lv��+�o�~��R��#�JA�P�pj2�L>��50�':���`�,I��0��VQ��Դo�����lj��)�˸��@t&�	�fU���t��~�8��%��n��d|I��\�o�fa����Y���Eqe�3;�	���e�CC��Ӊ0��b�V���VN�$�"�ĔV��DW�n��#�����qM�x��CB�Lq���ܻ	� T:�~h�fHq������`V#���{�`�Ҁq5��e!�X�AE[pE�6��#�����^c���
��%Z�=���d��JE;���Q�c�Q(��km�5.�K�R$3\�݇�˚�����u�o�����y~��"�c�ӱ��6Iph�������D���_7��~m2J���6��n�x^��Cw�ן?����h�wKR���B�Q}�s�f�A�Ey���Cك���� ��"�*ޣ����Q;M?9��4}Q�
is_�{l�Ԫ�`A�]2�Ku��1���`���<�dUd[T0�qC���Q8�Ft�Ʈ��)��i.�F,�mqL&�a5�?:�R@:#3��̔C]\�L�H�0}W�Qkdb�����U^���6.�iT���<�'�W���i��8��8V���9�F��[L�[8U��ܓ�}!�=JF(u�_S�	�u_4��;k-3��C��&n����ޑsRB�A6��"�[��a��Eq*/J�M���L��I�]W�
vf���8� ���l<�!)>��M����x/'�1
0���R�I�P��*C��`*B��59�u���� 6M�g�F�%9�PZȰ�}q��ŵdy�%���|��d,���:ʢ^/*�$����]0�w~��<�={���P��T��0e�J���3o�y��([�2IW��uwa���nc�w�L@X�<�A���R�k�*ƌ�\�Z�D'�f�^�+�0�Syݴ���44�ڔ��V�j�O����0\ V�D���
���Ńg;VoQ ���Ԍ�Sݘz<&�|�d�6ߺ�ѳy�|{nF��9�b��L���`n�RG�[V�Y��)��@z<O7����q����7��|�Le�[&���'}	��������u-EQ������6�%�U�uͦӦ�{�㶜������[����Fi/)��j���������
G_��8�5�]�(������_D>��w��m��\���.nD�`jl�0�su^rE=wmhRe�Z�h9�$�50BM�I����k�׀�U�蜇X�$��X�����Z���O���z�MV8k�8s���<:^��;����V)�C��#�"��8�R�)`�Vk��^��F��>��hKV��N*�j�B���� q�s��J��H�>��fn'@ذ����c@���A��zH����Q1c7��«j�-@����>;�0�`W���@e���HK�W	Nn�nw�UWfw�a׹�n���x�m���ً��b��_��u0�5�1M�ҹ-W�,W;��4S��p���T��+����T�W�cm'��Q���u2j��w3nQќT|J���KE�������]�j��s��j��X��4��Xڦ�+`��]UM�M�},�W/ƣ��:���x]	_���ҽ��Bk=6���`�"sf�����HO�~�a�&T}�Z}a�Y�g�J^��Q�*�9?0ۃg��nQ�y1g�p~�2-���T�%�tH;T�]�>pW.L�-�z�<����,֋3h�R�V���n�"-�vD�����(�p��mE������N*�[�� ��
d���*����p�����~~v�{}v�ݫ����qT��2:�䤩o�'�|g:__4����s�������墍����T�at{��X�]k�h�H��N��y#��p�Vg�3n����W�i�Y*����t�an۽7���S�v7ኴ�[���;�nQ�6���f��l���&Y\�'�{�wƴ^��I8��(�'2�`�6�l���RA_5)�w~'bXϳ�<�sh�M��f�?Oix�K4rӥ�A9�m�z(M/#���G��Z;��c0��a��]�V82ro�e�����v�ka�����ͨhmDi��h^��U=�l�o.b����E���@�,���Ц�Q+9Eo��N��]��2�F�f/��tL`�>"DzG,��{�%��Eh�߳��î�BD�g+J�k��?��F����N���b��>W��5�q�t-g�u[�{��i2�1$�|g��Y��֔Y�p���0E��f�t\�����#%k�w����G��/O?{1<\��ڸ$+l�$���?�����l����ķ	c�q�O~j?���b��*�)�� �z�f`]�o��8t_,Fxܻ�bl�Im�2�A9������    ���������5`�e�q�nh�Z�W-
��O<�O��uF�bD�-�Q��O6z��Hg$��$-�EKVj��P�ڼ�(̛k�v��]�����_?�2Na�VHD��8.$�J����F��:�����]�VjS4a���iJ<���2V��-���h���T� `�����C�{T0.�����(���r/zZͶӰWT�fc!ӱ��O�է0Tm7$��+�Ij@ef������-J$�ROEM:5Uӈ�i^R�+������<������F��}
�r������vK��C���/QtзCA+��-_?8!��X}��&?n�x�4 
yɱz�y�J�Jʗ��������],�w�5�A�'NE1�")��9������-]��o���ug+-]�Ň���WRPQ![���<0%��s�L�����+m���8UH�q5��.���Y�Y��f�P�Z��r��xTT�� ?�����i�:*±Q�u}ⴜ�]\�����B����`�oNb;���:��yM��آ��p��1��)
>�x�������ڊ.*~MwrFH�E�!-�MZ�F�0��(���p� �S�>[=��*4p)\�ʃ���o����ţ8�vb��k��Ef�o+�3a-��BT�U�����(����M���8'��))K��ĭ7jH�޸u��{�[��U�ud"+"���f��1��q͗���#F�z&���|�@C3����ֆ�j��Pa�]�,a��b����2�	�ƕHQء��^�׼q?\{��{�I>:��
*p�@B�%��^�kw��Mk��:.��{�ƪ)��!���*��)��K����+'��,^�l�!��������(%x$�������N��ؠϨjl��y��������Pw�u@�n������:�'>�i�ѫP��_�]��nͶ�_z�3ȣD+�.�2qhxq�>5����#����њ� s.
��)`�F��޳�ד�6z�� ��J3��y���xu}~� ؓ�]Q�m���7F����).D��C�ގ"s�y�I����RX��Z[�v���=�0���k1��AX<�͟�<禅
�q"Le�n�0�Z"����{��@eJ7Pҵ'Vt����S� ���0��nF(�|Ҥ<<�Eg�I�7�k��#sw�n���I���׮?=	=~]�\i@�8W��C:^�C��	:����k���� >~/�*Y���7����6A��4?<�vl!�|3B���`yn��� �^��nr#����Td�|�<�����Z1~e?c %#"NP��*[w��.�����x&V���#-xt�7f��E�%6��6�=�ua�{o4|�a�O6	���G���Q����na:�9+mv�r�pQڋ�>O��=1Lo�;��g��wQ�CW�z��f�ܻ�ζ�S�.��n8)�'�g9���#`����naIg�~�ݱh������PR��8\�sn��n���y�I�?�V�S� |�U�� �\���I	:̐�5Sp���^gf���W���M�h{����������u�#*���l�^MZ�^��"<�Sm�f(D��`�����^.%� ��.g�S���%@4��]K�2�Ǯ%�λ�*���RA����A:�KW<EI���ž%ޘ��:S��*��h��5�T���u�s\��ѽ]5U7���h� ��( 1BIv3A铁��a�����3S�`������Ѭęt�Ӣ������!��{�ݜx}Ƒ�<�D�����V��:w������>۟>��>j���˳�7�#y?O|$r�o����Yץ��#��g;}`y�jd7���W���|#쳾���Q�*K�}JfI"A�M����{��q�q��(�"�J�B@�� �R��%ڲoA�M���͊0z(�CZ�����F?�\Ř>�o����� No����0e2%+'�.��l5���\�`VE���6#�T�b,L)��Fn[��jE�#{}�U`�m }T;�����<:�T\*���_��d�^`��ԕg��tHcUx�ѳ{�)1B�]'t:n��g��,I� ���I�͞�Il&��"T���Z��S�Q�U���ַ{K�&|
�ƋGc�o<�Q��JP�1�Ntu���]��G�w��dџ���)��jסڍ��)��N(��Z����=�U�w*��E?���Y�`ߵikw�|M��S�у�����8 -�O7l��C2�eI2E�/ؠ��d��ywGHcnS���	J���Z��z��r:e���&#/�ߍӿI��qH�h��:q.�r�'��/������O��XPU���M�}�,�2����A�lr�̴�& �4�~sw���d��'�2���2.P���Qx?e���9�W�:�B~��<��6����G�zWt^�o�K��'�оV���[� ����V�g� ��۷{����`8~yt����i��7�w��Ͻ|!�㐞ӕ�8|��#Z��YJJ[�]��(GϮqo�~��n
e|���w�cj��	f�a|��S��*��K�ڣ��G[^{ <��ĚY���w�6v�$zv����;��4����ly��I��mY�B*�-�ݽ��G��;��� ���_[��b\� ����S�F���N�_Bs]�-�n�	mCxa�%���ו�P[Y��!�؛�W����PƋdSf5�G|WË�ܒD��.˘I�=�>�e��h/t�0�2^D��D$sSm���IR�&zaY��h<I��v��*Y��nٶǝ����e�N�'}���;MfVp@;~ϡ$<�WS��}Nc\�Gk�ka�9�Q��j�F�yqB�v�Ҽxx�u�v:�$ｵ6۬V���==����}���ݹ���n;��Y�H��k9�3?ƿB" (�EWH��.� �^������(����%�"�,�ӵj��,�
�eN��do�,^��L�7��9o/,];�c���G�A߷,�u��';\]_X�^9�a������n�<��]H��9��=L�Vt�ٰ��2�>�c9�>3�;c5�;>3Y�Ի�E8�������y��JxX�y�J<0��p%8������>��;M�E���2��#b�1�����Oedq/9`�
��mC8|<�.�H�H7�?~�z�^�Oy44��Zdr��Q�ȶ�_��'ou����G���+TwZ(ĒH}@!�䮼y�������K�a]�s ���9�z� _�my�w���]����! lɢ��
0���G^؅G����n+��W;+� ?�?�3��;���"Z�x�BC@Z'\�?�L�" �s��z
^
W��?ɱ�YWЄ����m����ܾJ�B�^�o>��x taIf�ᐰ*5A��@�Hy�5,�<vK��`�|�B$������}Lٱ���/��O=�{V�p�u8�?nbH��W��t��9�t���^҄������MyrM#��&�In*d��C(�HD��x�&㕅�����?������a������L�e1�[U��[����ī���~PiqF�ad�ꍻ
�k�+��%B0��O��n�I�N��J<;��Q�W=}.`+w̓��: ���3u���X}����u8L�^Քy߷�b�ʨ�	s��̘Z���$ݟ̙D깣)���6�:[�R�`e@b;.g�4��.;���h�7.��I���DH�ݻl���܈�sv��5��Ok~�$�+6m�'x�ŵ���:���t.M�P|�(�
��n�Sy�W��9� b����(12M�4;���y��LvG��������0Ϊb��<:�Y���N �ga�ꎆ�-w2C�A�e�� :�Eî���p�t�� İ^���Ը&o����i��)��uu��
e-����2��_�I؎��uɢQ+���/�E�\`�&5�8�� ��kQ�M]do�ٴ��C0��n������_�hԹ�oV`��YS@��_,�DC!	_"�|�+��u8�z�_�,�-6~1C~W� �   ��P��(U焙�7}b��?ٳ�2^��<YW���gO������a��Q����7n���wP�sX��q��*�1Ε_tU��,�����	1�?A�񋐁ΐ'rp+g9~����FL{�=v�H�É�z�迪u����������(�3�i8�Q�Sw����Yy�a9peﱮ��T�ݥ����.�<Q`5]�F���/���h[�X            x������ � �            x���]�㸚,���2fǈ`���:��޿M���$!��\;���R+��)�B�k��m�����3����~~��!���Aa�m�p�����?q���/8������L�,�P������>�2�:�e�
�`� �d�
�`����(,�=SX{���Ja��`��N&��`��qX�����Y�8"��Da�#SX�(8*��Fa��SX��F]7j��ύ,z�m�5�����t����oI�Okpg��5�����\�U�i��&��Wp|Z�+X��(�����QtKN8EW�j��`��j��`��j��`�5�@j�I��ȓ"5��'EjP#O�ԠF��A�<)R�yR�5�Hj�IqE+�q@V���X�;)��^����� +w)CV�R��̥
Y�K��7�9)�^����Kx��!N\��q�:)C{uR��4餜������q9̅�Ҙ�F�;)C��vR�5���f�T���R��f�T� Y'��f�T��uR�k0h�I��uR���f�T���Y'(0h�I�� L�JԸ�*���@�T�ƝT�D�;�R�wR�5�J%j�I�JԸ�*��q'5�5�Fj�I�Ը�5�q'5jP�NjԠƝԨA�;�Q�wR�5�Fj�I����:5��'ujP#O�Ԡf�ԩA=�S��zR�5��Nj�I����:5��'jPsOԠ��4�A�=iP��{Ҡ5���<fAK�U ����*�YВx�,hY��d����/·�~�������m�=���?~�y0���'�|2���&x�Ep��Ϋx	-����s�������.z`ZB�� �Q(kj��d��E����dzn��9�v�y��tzp��dzr��l�%5e��MC�-����2��㩨��D/�����S7��0������h4��F�O���kW�Q~Knnq=o��-.�qz�t:�>R����J7��X��ue7>Ϟ��n�w��.J9�_��>~H?G�,�����W�s��+ǹ�5(�W�s��+ɹ������2��r�`YL� `�*Ѩ���x��e15��c���s����rv~�~^���\���_��r���[cS֐�١KsSΙ޵����哢�)�
_,�r��RsS�tQjl�q�"���#�%�E�ԔK�ǵ��)���^2Kƴl��i�,��57�BϟQSS.xmF�M������r� ,��b�r�_QO���׏�g����_i��� ^B�A�։�֊i	��Z������>��r~�#a_�?+NsS���55���Ȕߺ8w��y/�X6�2��r/�X&<�FMIy/�{�ǽ��|��W�����5(��G�A)�@aY��8�?w|�դ�{�/�J���Y)w|�ը�;>�jR�o��;Z�Z9w�D��������XMIyDL�v�))|�Ԕ�v�1)�RSRإƤ<�K�Iyгe���]���o��c	�g�9(��7�8n�����J�a��߷�J����C�o�`���Aa����������oX`�p|��Ç��oX`�5���$����pOF� �Bm�}�u.4�U��D�*=E�*=i�	������{>�4�q9�|]zF�D��]V#��9��������!�,.�?v�Jl0.�)r\��v���Ԕ1-��m(-��bZF5�PZB_��4��;�ϼQ�S����ר'��Ϝ��u������#�ߴ|:��|����z=</����e�l��/%p\NK�O����}H˨?���B��zs�Bg��4L�g阖�20-�u��'���xt�؎g���xx�؎����x|�؎秊�x|�؎�����e���԰K�N���԰KhְK7�v鱩a�>5��CS�.53��]jh*���T:v���t�R�R�إƥұK�K�c��جc��Ԭc��Ь�@�E�Q���aV�5�@���]tu�i�������ǻ��c������%��=�;h��1��@�~���Z�;���`z�>e�+��er�Η�_&إ椺a����]jN��)��~�-G����S�]����m�H��s,��%3�c�%.��t�]њ�j8g��l��qvI�f8g��l��qvI�f8g��l��qvIKg��6ܒ��4����f<-�#����=�OKsEk���4��d���\ҒOKsIKf<-�%-��t�]ҒO��%-��t�]�ro]>i�L����:�r���qo�~x�F�L�=ؙ���?��n���+�V��{ܚ�)�"��`Z2]\��d��i�L��-��5�>{�϶G�EK�1����5Z���|i<[�i��	Ӓ�3�%�-չ�%�-չ�%37LKf�d>h�,���u����
u}]�u�d�������|���B=�=]���t-ԣ�ӵP��N�B=�:]�� ���QI�|BPC���J��+��p����$U}a9���W�CZ
}i9�}`z��ܼ?�Q)2ԇ�ǆ���͋�q|<����0ԯ��P�|;C��V7���_d��YqZ�^�O�z�^�O��W�&����3
���v��o?n���h�����}8g��\5B���6��/����7y�n��w�����#:��4��u4��u9�;��uď;wV�����h8�5��)�#�����y��S�d���2���U�����P����K���zό�����U&ꀬ_�d%�fV}�~���� +-CV"��0�����:_�Q[�Ե�q	l��^M���?����x�u����<En6^�z5�!+/?=�[V^~Z�w�&��G�`1�YރH��)�cH����}^��!60VS}��G���}��a����Y_�X ��V����Y��������~Q!`�m��Y�Mm+oz��������McSЛƦ�7�M-@o:ɵ ��<�"���\�Л�s-Bo:ϵ��<�"���\�Л�s-Bo:ϵ��$�"��3\�ЛNo-Ao��[��tl	z�y�%�M����7�[��tl	z�����y?Ao�[��4��i�ozӄ�2���e�M�}�Л����7�-W��H#~�М����9M;-Cs�vZ��4����y"i��s�����E��*}����Z�~.����\�h�+��W7L��O\h9�	L -�?��=��~B@��O�w�RP����a��)m��Y����ǟ��=,��;,aYl��a	Kb;�KX�Z�����Kf�`;��,���`���}��ώ�����J\�2��q��c��Dj��A�4�~��߱��1�����S���c��<?{�,:�+�:����yC�ι'�z&�q�ߟ��p=�{�S�ڠ�4�����a	T�&�6�@�FmP���ڠ+P�QԠ��6�
�x�]���ڠ5 ���|�7jPRߨ��=5�ѤoԠf��Q����e������j�oqAjJ�^����FjH�,2���g=
��2�A_=P���z�5z�@נ&��B^=�5���jPsW�Ԡ�����#]���z�5w�Hj�����#5���GjPsW�Ԡ��A�]=Q���z�5w�Dj�ꏦ�턤���i	�c�]=
K`����[�[�����1FsWO����%0o��(,�9RXs�����Kp�nP�W���h��{����0Í�������%,���p	��c_��a[�W/�2X~��� d�$��K�����=�^΋pE�`9��_�RX���W���[��'���ӯhi��7�+Z"_��c�[h�&|�3��������h-_�rZg�	~Y�b�_��e}qɟ_�伿Gt��N�ZF��=n9���2��j_��ھ����/�j6����z�«&���T�����p�K�{Wᖗ���_�<z�¯�޿𫙭�/�jl���z����_o��W�[�_����VX���z�+W3\���z
w����S���%��,a�<�;+X3\?�;KXO����S���epϧKXǲ�w�epϦK��۲�w���e/�w��^����
�7��[�%��,�(�8-�$Xψ���`�ʽ���Aa�������ep�^,�!    �>n�XMoC�c�/�7%.Ə@?�u7~ڍu7~�\Yh9Ӓ���v�1_3ۈߵ,ƈii|�h�l�q��2b��F�*5�����Im�Na�����Gh#?5^�Ҙ�/aYL�όW�沑�/a9L��R�*�e0Q���F�5��Dj
�>��F�ϳf�<�`^X#������`>�KX�1]�2��y���������x�e�,G�#,�e9:a<�Y�����8UY��h�u�Q�A��ǩ#��e�T�Y�2X�AW�G��9t�xThЭ�Q�A�`�R��F�5��Jj��65�!l4jP3�hԠF�ѨAM`�ԎY�2xjǬ`�_�ԎY�2xj�,a<�c����1KXO�%,�}�����~�oz�2���MOXv0��e��}���/G��X�	�`�k�=a<]��e��5Ԟ��.�[�2x�0n	���¸%�7�Ԡ&�1�AM^�=B�Tp)y�G(�a|��|�e��N~[��x���:���T�)%���I��S2��R����ϲ�'�{��{��oH�(=����X�Y��e�.�]��e�.�]��e���݃Nߊ�-�X�mzd����j��ڬ~B"�Y�|Djs~���j��ڜ�Ez֫����e�.�]F��e�.�]�_Wd~��2m��!l�)@�S��5�a[L���S���a+L�6���n���"�V�g�.E��Ŝ0n�z���e�q�c��=fW�-�N<�*�Ûϴ]��7�i�,�J��ǰ�r�.i?��g�&��ϴU�k�Ǫ�҂��㊴��U�˻���N��&ˠ�M֍�6Y�m�F�KZdM�ǚ���#$��EHϪu]�<�Y����ׅ�3m�ua�L�d[�<�6�&ϴM�6������m�����5�2�e�.�gj�����5�r~��ة�Ϗ�:;U�������_;����n�jtkZp��5>�v��ExՓ[ӂ+����X?_�������`��>_���W���W���W����=��E�V���tA�=*]��G]��?���
�`�����b���p�Z0{���`���j����tGS���U�s��ij�����iz�t���c�|�p��1�<.`{'��C��@�u���I-��r�y�{R�Ϡ���.��T8�\�v�.��]���uI[f<_��m�㸳��wff�:���\޹m���\�wB�2�He:�	��t�"��t'�ӝ��t'��l���t���L��m�w��|�r~ �
���������{�3l��C�Ӏ���w>�v���0_��<�V���G�a�_\��̋�nG���톴n���nI���領n���nK����nL����ִn���nN������n��i�?�p�nQ�ܴ�Ժ7�6�n�M�Q�p�.Jk�]���i��un�k݀�v�Z7�ݴ��0�7X��j���¿�<�M�³�����V�|���j6��\�v�⊫��_\r5���k�f;|qѕٺ�+�R�ⲫ��_\w5�١�Z��f��� �9�φ�N[r���/��r=[7�s��³7���h�s���X��
F;R
+ m��V:��/����o�Mh��Hi��B7�������u:V
8Vr_[�ϸ�#d�����~8W
���qg�ׯtKa,.H?Δ^\�~���8؄O�å�a����������qs��C�3<\8a��|]\�];`�[�t4}~�������m��m0�r���ϸ���_��S�m"Vr�1�p�����2d�[f�/��/+GLԇ�mj�S���}�&�=h���m��mw�~<>�xq��~1E�z<���m��m�ӎ�"�=hˌ_LDN��[�t�8f�o1�n�iø�&�B�5��+�YSL��V����bL��6��Ŝ��)���#��gN1}1�zH���3Ξb����󧘿x?�*^5����^5���fj�!T��N�b��R��1ӣ����;��5J�i��]9�B߻8o�徼��6�B�N�b�_�L�����B�شg���Ů=+�:�9��!^�۳�w�P�욇x�s��ޭ��:��!V�Bg�<�J'�Y9�tt���J|���V{�{ϊ��JO��z.��Y��yl������|��f�\8��4)6�Nf�υs���b�r�$���:H�m�_���;F���u�|�:��!>�Hwo�gs]<<�2�p�I�et�pl�mt���:����u҅�s�l��Z�$�s�YK��:K�/X�Iq�Yx��ů�>��i�aR��ى�ԁ�:K�Nó�.|���n�NL��.Ku���fK=��c'��T�Ii�op��z��Ru��h�4��±UGJi�V�)�/U�Ji�V�*�[u����`)|nu����d)l��R
ت�����R
ت���U�K)�y��R
ت����R�x�:`Jƅ��.LN�R�V1���:cJ[uȔ"��)El�S�ت#���ZuĔ^���R�V�1���:dJ4d�uv���)%<,9dJ	�W2��{{�O�V��)el��R�x�:\J�.������f�]8^�����f�]8��)e�ϒ�p�H8bJ���.'�R���)��q[-�Z
�]v^1n��a�V/���~"]y>��j�0n�8gr�]8��޻p^k��w݂�u�]8���� ��w�X��T�A�x�<�E���(.�M��Esi��ul�QSjtݺ/�ó/���f'^�����^�nASb���i6�Së�aS���Y���-����W�[6�/��q9�?�nq��~�pz�uC^8=Ӻ#/�����;lJ�XD[�:�U�M	lt���)���~p[ت��tj.�U[��2��ō�1/;u֔^�ΚΚܛgMn��3�;���L�Ƽp��YS�Y�����Ju֔i}i6�c�)�z��8krG^/3l�#e�B�rqx��!b�Vñc��m�����ӕrK�#e>m.��m�������9Ծ���2�!�?�1�G��9�YS�j�Y���`㼽�6�^?z{=�2����t�����>�k�^�q���'�w��=x��M�ָ���sk�^#>�z���W�6�t܈e�`l�=m��m5�bY���6�ය_>�p[Mx�:m�	�V��9���)'l�iSN��u���GȜ�U�M9c�N�r�V�6�תGȜ�Z��O_:�ĝ6��7��q[=m���m5c�N�r�k�#d.Ǫ����Et��Ӧ|��n��j�V�6傭:mʅZ���\���υZ���\�U�߅C����fUj�x�����pj�%x�Ǵi����R�5n�����ӛ���W����er7���_$w��j�k�Ux���V=D�v<?��!�]x�p��Y��8�mx������S´|8^ʧxi���钸5n���ָ�~�=d��7� q������q��⚸ٍ�-�ȇ]��-����-l��o#�y���-y݂�gQ^���Y��-����)�/�b��u�/�b�u�o�{����4��ƹS�<�q�$*�o�;�������ƹ�<�qۃ���R���ۃg���؃g���؃g���؃g��qۃg��qۙT��qۙT������lت��U�%`�<K�V=x����;���9xx�,����V��O�q�%T��j�3�3��Y���J�?`�qø�ƀq��X�C��9,;�*�X��%����oȎ��W��J�n�aT%~svFU�7'a�T%}svRU�7'a�U%�e찪$��V��U;�*�+�ָ=�.�[�|�:n����ڸ5n��2�U���/�G�'n����/|�;������K�NO[--i+=����T��&KK�B�;,=��׋�AUy�����AU)�6z�\�����[���J7wn��"�q}�U���ӞJˇn��!%��C�;{�'�5n���)�7|J��,֋?���w�?/���_սz�Щk����%m��(-~Q;��Uz�w+}}Y���b���K���*�/L�����t����SN��կꐪ�r��c��\�������Z_ߞv{������[�Z�ꔪ\�t��S���:    �*�/R�ŭ��Uj����ث3�r�	-~W��߽�^�A����S�z;�*� hI[kǫչT�تC�2�U'R����Ө����[�7ᆸ��DLq;�.���S��_���znx�v:�ic��=���ˋv�T����z`u�wM/�~MGMu�,��w6�}:i��pg��5�S��o��,.�n����;�u�6Uo�qkտ���z�$�[l�+�iS��븩^�н�6p��j�j�8���:r��)�5�̩��`�[n�3�S����/x�g�7|.��s�ۭ�:O������~#��i_��^}��6;����y6f��Γ1í5�봩F�b5��P�Z���z�,xK�t��&�h1�t\��S��z�\��z��\�֚>��i[��K���t�T���v���a���a��9��[�5o��|�3�E�P;�	�ַ�H[R�}q�?ok�)R���+�mpo��΄��}e����$��5#�;K�yЇ�0���vY���YR-�d�,�^n�}�zu�T/��^�6{�4z8��pl�r���x~�6��I�ߵ�<ސ�W{-�o�{�y���?��wV�����<��y��������o
?���0��Jݞ�ͺ>/�u^<�\������{�����%g�v׻r�x?[7�f��������F{d�C_״}���pM�'�jm�}]_�v~&m�-�x��_wo��͓.p{m��;θ��u�w�n��`��־���־���־���֞1n�}��n�[u�TW{']ය�;�;X����.p[]�t����V�,Ձ�:Y�[u�T��d��6O��mu�y�n�[u�TW�'�qgKu��.�m�V�.�[u�Զ7�j�g�	��x�x5^0ތW�w���x�������j�0n��'���UgK-`�l[�V�,���:Xj����y��R�����չRثc��W�J-b��ک;��],�uy����:�ڈ�:Zj/XGK-�멶E,�Sm�X��ږ�XO�-a��j[��Sm�̕�=9Wj�\�o��d�o�뽺ϼ͞ҥ�ծ��>�Η�z��3o�띺ϼ��7�>��{j#}��7s�����μ���0�������μ�f�r=��W������u��
^�N���k�N����V��u����w�{�-�d��|Dv��
>";yj{u��
�:�m��pǧ�����w�mv��pg�f+5뒼p:E�$/��uI^8뒼p*v��[�bgI�U,֡S�t��$Z��%y�X�C����%y�تC�ְU�N�aMΜZ�/gN��b����ŋnȇֱ�8���3�ֱ&gN����%�^��W���x�ت3��gN����^��>�ǋǞ:��_�Z?j]���گ���x�Z�'�N��b��{���=���#���Z}���������݅��:uj�V�Nm`�N���Z�:����N�����q���UO�R�c��m�%�ܩ_�N�^3���i�J��l|Y��q�������n拆���/��+����ϟ^?<�n�Qz��v�Է���)t���U�x���k���b��_w}����A��έ��m�����h�T����N'M=P��z�:4��}��q���k�>/����3R�N�z������B�U�����6�׸��6NZ}<�R���Y���}����8c�i�wn��]�?���t����K�'�RSƸ�v���[j����0n�	Ku������fl��R�ت��~�7i��u���ծ׸��q[��=�ָ���gk�V3��T�gZ|q#_8��T�lթR/تC�^�Zu��^�Δz�kՙR/ت3�^�Zu����L��Vg+���g���Z~�������z����8�����.��	�պ\�'�V�r��p[�K�'�V+��R�pjե|�˵z|0��ץ�n�mi�����I��	����Uw�ӵ�J���V���烱�V0n��b�V[ø��NqJ�����vz�]���x��{�V(���:P��'�V;��f�w�V�'��ת�����yR���o�Γ���V���G��?��8�l�qRت�>�U�I}`�����V'���:M�NKn凱��0ilx�:L��0ilتӤ�a���Ɔ�:O��@ilت��}8��^��Ɔ�:R�UGJ#`�ΔF�0-��V��Pilթ�تc��U�J#`��F�V�,���:Y�U'K#b�N�F�k��҈ت���UGK#b���F�V-���:Z8Z����UgK#��li���^�zړ{���iO�5n�8[r)_8��li�lɥ|������m�_�V�x|��k�a\V��Ş��^>|�Kc/�p�]�K'�b���	�X|��{���s��o��u�t|s�xi��|­�,��	�ղ�z�m�,��p[-K�'�V���	��u�t�m�,C�n�e�\O�����k��a��V~���~?��2?��S�n��N��N���/�:u+_8u�V�p�ԭ|�ԩ[���Ju+_8]�n凱�N���¥�V/7��m�rS�k�V/7��m�a��F�V.���:\���/W�åѰU�K�c��F�V.���:\s���h(��q���qɅ|�t\r!_8��pitl���������B~���q!_8}k�B�p���}|������±U�K�K.��C����a�M|�X������g��$x�-~�Ǎ���-~��l%��a6c|��s���
�}ѫoܼ���Φ�?<���	f?l����ڷ��^n������_��{{���J�Km���ӥ6�}]!w�ح���>�����~?�W�������������;�Fig��-p���8Xjs�,������.c,���(���G4Q��F5�l�����Kqn#��"��=�������uQ�-n���[:af��ӎKG�V^���epi��o�����y���wn#��4�W&c�sь���D4�:����Y�ǥ�6�H&�:��y����F�����\Zj��cpi��o�)� <�5��zy�}D���o���\���|R��{��;zn\�>0n�:S�^u&����TLqKҹ��v��1ŭHgc�ې���U��)n�[��l�V�4۰�9�6lu�[�[�6lu�$ڰչ�C�V�0۰�9�6lu�"ڰչ�h�V��[��=tlun�бչ�C�V���tlu~ML�V�w�tlu~AL�V��tl5�j�V�&�[�3��V�L;��9�luδ[�3��V�H;��9���l���lu~P:�UO�����8��6lت���a����:Z
��h)�����M�%���ӷ6n��R,���:X
Ku���6�\�-|��-�[���[V���W��*��%|��Uw�Ec���B�N�+���:X
;u�"^���B�N-���:Z
~-�H�:Y
�:u�"����!a�N�B�N-���:Z
���
���NSƸ���q;�i��v��-5u�;X
i`�V�q[�i�⶚a��h�a���3�s;����X)<�J�M�M�צήߋno���OK�c�������`,ԙR��w�����o�D�_q �B'J�`�N��k[�[�>��H)�H��{�8Rr�^|�O���a-���f>]����a�f��!l�5A�k��%���U{�̡����C��C�~]�
:7
87r�^8��Q54�q����(䂽ph҃jh���z�p:�^/�~�x�F��z�w����{�F�_}[ꂷ���K�������{�ث�Հs#W��5��(���{�47r�^8��(����pn䊽p:�b/[unpn䊽plչQ���+�±U�Fa`�΍΍f�>�\E�`/��E.��c����{�Y��88���S�~jm�Fq�VE����ҞZ#��ܮ�1�7.n����h�F=��M~�6�Q���9��z�ةc#��0n��TGG��ǈ�#���㯃���#��Ec��b���Q�x^rp#ܯNW����Jupu���&>*y����T�FQ�aHۨ��P��!m���AݬNˠ�Y^�ec«ԓlLx�z������J��L�:4��*uh3U��(f�ԙQ��\��(��i���S�����5��(f>" (
  99�k>zG�����X����Q,����(*ձQ,T�C�X�T�F�У��X�Qwj͎�{�>V�s/����ާ��-нN+[�{�>V�r/���\�]�H�G{�>���^���|�W�c��s���F��{�>���ޥ��:u�ۇ�_��V�vg�^<|o���c�e��M[��L/�yg�^<]�N�"��>�p$�F�xza��ԋ�f%�N׫����[�Y���:K���Tg�^<W�16v�h'����8�]Jqp�N�"M��v}���ޮ�4Q����&J{�>�Div��ñ��H�H{�>m�s�٭���m"�n�pz�u��6�b'%z��l�g��,֋�J=�&�'�^�hl�yR
�8�<)�R�(%�Cڛ��&J{�>�ԁR�^�O4P��z����<)*�qR�q�,����4)E:;LJ�NLΒR�k�QR�ԧ���q�IR�t�:HJ�QO�)�î���٦�)Q���f�^4^�fL�f�^4��I6%���ARJT��ؔ��t��]�N�R�2=Ħ�O��aS�׉��p���,��U�Y��1n�0G�z��p��5� i������k�AҬ��T����5����o�4K�Ez��L�,)<�:LJz�&��}o^N�R��^�I�^�6{����=���5m�G/<���5z�ԩk�©S��S����Ng�>�Ti��Sm���!�u�꠴������2�%�D�g�K�6��}�׳�%���$���i��N��Y�M��[���2u����l�E��ܢ~\����￩ä�#���'J�(�$�
�pl�AR�K���b���F�����]ю�R?��%m��F��m�:����K��Qԧ����#��c�ΎΎ\��������#��S��a�F�z��89�����#��㣮��L�H{}>�k�f^8v�6���z�ة،�#w�c����(Ӌ��}����(��
}v���ٟ|����}�s~�v����������'�NC��ã|�J�5n���q�^|X\2�k��KFf�^t���F��ԅz����z�J�5n���t[��Tϯ9b�`s�R=����p;}�t�[��)���z�B��j��UoSq[���٭���j�w��O�n�מG؜�Vϰ9c�bs�Z&匵:L�k��3��16�qk�X�ٜ�VO�9��j�V�$傭z��[u���� )l�AR.ت��\�U'I�`��es�V}N��Xs�V]�N��X/�Zu�^�o��I��z��Z�m�V��jm���)��k���`��|��"�m�a�N�r�V�&冭:M�[u����8)7l��lnت���7��j�V=�掭:P�[u��;��D)wlՉR�ت#�ܱUgJ�c��r�V�*偭:V�[u����X)lչRت�<�U�Jy`�Ε��V=�恭:W�[��p��3O�V�G����Q���%{��j�oS��<�\l5�,[����V���U'K%`�N�J�V��[u�T^�N�J�V��[u�T��l�l��R	�������OF#��h�Dl��R�تå�U�K%��g�^x������f�^8�Lg/ܗ�^���%��tf�^+�VZ�ܷA�bzﶚ�E�{ݾ�-�f�^8�:?Mx�:\*	���=2	�U�K%��p�$�V�ǣ�l�n����i�k��R��C�Y�/���m���Y����e��H�h^����f,t~@��P�J�`���J�B�'�u�T�Q��q�T�Q蒶����J��ԡR)T��|�P�{��,�,��<��h��S��4��J����18R���8RJ��cp������H��z����z��e=�`)�)N�f��4,u~>�%��c���cp�4��'J.��R�(��ڜ��١����SJJn��R((�_/K����@�{�X���%W�c��
�ܱ��:P*8PJs�Ł�[�zÄ�:P*8Pr�^8��@��@)�-p���'�8Pr�^8��@��@�e{���l��@i��+�f۾�@i��+�f۾nت�؊%��c�d+�f۾�@i��+�f׾�@iV�k�V(U(�i/[�([q�䦽plՁRŁ���±UJJ���V(U(ͪ}Ł���±UJJ���V(Ո�:P�[u�T#��i�FlՁR�ت��UJ5a��j�V(Մ�:P�	[u�T��q��@�}{�ت��@��V�4	�����$�Z�s$�ڤC$�Z�$�ڡ�I��@��k{.%���H"��e�͡Q�̛��/js�>���9/���sXTs礨��9Q-̝S��S"��Ӏ�5z�4��5�Zh@?{��Ѐ�E�X+-��H/_��&�x�лI/�&�n��	���©V7�S�n��Zݤ���Y�kuRTq�h6�k����*}mت��ڰU'E�a�N�*�e{v�c���*�e{���c�Ίj�Z�Վ�:+�kuVT;�ꬨv��YQ�X���ڱVgE�c�Ί*��uz�X�âڱV�Eu�s���b�S'Eu`�N���N�ՁN��H_꘨4�E/�D�B_��\��5:j��h���gw^8��\�;���?Δ���T�μXf�yPۘA�m��;j���]���F��C���[h�����߿�.A��      A      x�3�,�-�2�t�M������� 0�m      .   �  x��Yˎ�0<�_�/(��,�{�i�X�(���"=��K�db{7�z����␒�4}y��=�)�0��4�4�������e\���'9
�����ח?�SsV�gHqP�;ѿP��#)JRxL��I��D�����$�Hb,m��	��S��s�$������D����lA/��8T�%�e!eI�XuҸd�0���7h�)��Asb$�D�RƠW7i���%�aͲ�V�bW�z!�A�,�`Y��S�4��C,IY�c,V�1L��f7��B��2�V���H-Lԉ�<fWB��2,4�e�I�h��q$*�£��Ȩ�UlQ����d'T�,�M+xK�q)��٤D�<O��Ӝ��#0LP�� �y
��ht/�j��$^��	�4�� �E�Db~-ʽ7�+�e����|���1���oG9\
�T���W�H�E!L	I��X0��»Ñz!�K9@*!�	 ��6ɑ/��5��jૼ]��w�G�hM#[���'��&�h[(����"��I��K��ޚn�fYGBkAr��Hb^�..��%�ޤ�td-�ү�q$�7GS+�G�7�)8�D��b��Rq��E���a�Y����ȴ��(�D`sPŅ�m�2m�V3����Y��p�ɑ*�F�~q8�E�\����������Ϸz����K�`we�}$��\(�9Q�h7Y��������x����W/`/���}S1��^��W�5��js8j_���.����{��@���}�_���pԾ�!�L�G�����4��������o�?����ppk����k��h�����k��}[��k��}�_�߃���w�_����߭���o/G�[��W�������pԾ�\�Ū��m���`�!]`���Q���`�{�7�=Gx���r�
�&l�L�����~�	c[���~��WX�ϟ�y���Ts         	  x�U���l��鏹���G��		!@�����ܹr�7���M׎�Uu~��ۯ����?��QK���_~��U���������{����_>�!���?���o�9�a�O��~���C+���m���V}���,j�Y,��7���e� =��|��M��N�m�\X�I��H�b'���p��&a����k΅Eod�蝄}$s�>AVXt�_oB�M$'�hq�`1
	-FM����n��$,� J�1s����,,6IZ�d�� ',�۟7	�Y��b�������0Hh1g2�����������͹�X���䧲%s��Aj	�����5��Z:K�-4t���J�S�N[]5N�	L��u6��
�=��i/�p�d�NXQ3F�+0�N��p:U(�NF�ӕ��d��Vԍ��Y�i�,���p���t�Rw�����Ŋ��p�]`:ݡ��t�P8�%,��R82>���Gg<�JʟY�P�?��I�-�H-��c�P}~�����Z�Z���V!��Z���V�PQ�S���G�c�m��v��%��[��� ���v*jx�c�jx�;5<����P����M5��L�#TծNSwǡ����T��jx����W��ظ�W�@+��S��L�
�`���\�X�� ��>h� ��NE��i���j�a�!�Cm�T�ښ�T�BE��i�!!��a��"����0���$Z7H5ԄSU�:�jG0ծ�TCZ Cua�}E^�a03�5t����pj������!��:�6R��T��T����q�!7�zj�7�}c�z�ላ��"���SY���e�	�E�/�"��sGc�c0��SmU��өv�^�j(ù�#5�5jH�TCi85�����pL�-P�q��(�Y�A�C~#��z��_�1���j�8���Y�w�xpsn���RmL�#TծNS$ǡ�fq�j��ܜ�ev���hqH5$�SQC�`:ն`���v����e�|�PR��T��,����q��Y���p�q@��i�jG`�]���f�4�P-�C��0�P-��97��\C5�0_�,���u:Վ`�]���1�}�!G�6j��TC�8��FC���qj�����W�am� ծ@��E��b��R�	5Ĉ�TC��ې#�5Ԉ�T�BU��t�]�|�V�r�0�܆Y�`��FR-�T�#��r�1ն@Q;�gn�ȑU�j�!��"NE1�i�!G�bġ���Ĺ����.�����jW���Pqj����J1��PTʞC��j����N�t�m�T;E��'���A����Hq*j�LS��8�P)S�bx�ֶR�L�+T^�S0ͷ���:��0�H�Rs�訔}�{i4��|A������T;��v�*�07��J��`��QR��T_���B�q��R���J���N1H�+�j����N�t.4���Jq�j���<:*�T���Fq�j[���N�+�GE`��R��:*�4���FqH5D�SQC�`�j�T�E��T�ں�PC�8�"ũ��S0M5���PC�8�3�I��F��3RmL�#TծNS-�\jq���T�s�7�Ӡ���4jq��@����CE-�`|:ն`���v���vTʺy�VR-"塢���T�Pyp�E�<0բR�8�5T���v��*j�LS��8�P)S���;��P)�54��<�\BUm�t��T�S-*��-*��h�R-"�z�:t�j*�����&^���u�T����PQ�N��<�m�C-*偩��_'���;��a�m��vt:ծ`A�y��J1̧�@��e0΢�(y�Hq*'��L�P��j[���j�����FqH5D�SQC�`�jǡ�Jq(g����ЁJ9� ն�T;BU��4�"TjQ)L���7�'t�R�C��j����N�t�m�T;E��T�-y�
�"ũ��S0M5���PC�8L5T��	�㤾��Q�rW�؍�i�z���C��� Z����0F�FhF�pL�ysd)V��i>�r^�i8Kr>Q�e�!�bqH?$�S��2t�v��!�fq(n;��{(ݮRʭ�X�V�4��o���[]i
�Z�xQz/=Ыd<�%�S�dq�G�����m��X������C����|��?�U�;IEi�A�N�����RKYF�0�8�a\jq,�q��4��-�i����I����R��0�.NiW\�a�s�<㦋�0��.N�n�L�ς��R�Qn�ix���4Oø��<���4��/o���^����?�           x�uX9�#9�K�� @�G�k�&b�}��ߛ�*���6�J���
����Ƃ�E��߿>��0�(���?��G�P֧cQ�b�f��`m[?�#�?�}���x6��V�8X��@q�ȗJv�
쒃�/͎&%��W�v�����X�@PJ)D���':�Q� �zD�?�v�u]A�Ht[
ߠ�+�y�K$ ]K��C-�y�q5�x�B,�� K�f��"!_�ɕ�U����
aQ�BX�J؃��w� =������KS���k-pyMq'`E<�o:3�4����Kā:u|�$`I�N�[��/`M;+��:���?<-����� �Ǿ��G��r���T�q��Ln~ ��+J�de)�����P��ʕ<bUv@$k��#(����%�IU�vH*���Vۓ��P�_�����6��tY�5,;Ϋ�s�V�"8t+B�;�;g�EC�8�|���I�"���2�vsfX>cɒ��㗠���%>0
���a�kba���c^H����"L�e����sz
�Ӣ��0^z����Ѩz h�䁖��CbY�Ud���3�4��]��ɫ4H(N^�1��Ft q��1d�OC&��1g8y%��c���<�L��cȔ���¨�SQ1�T�7����U"�����W̗$�m�N_D#F�����缂z*�c5�\�ٲ+{a���z���ӕ5�A���� ���\�B����H�#NGb�6]�����qV�k�s���Hb����������mӲGr* �?�����X �Q���@��2l3�b���i.�͒�W��G�̵���X��8��}�����y.^�G_�O}�����3v�����.E���i{���Z8s������hUR����ӛَ�'AțR�'�`"�,~<�0R���������ia�6"����]�X�3���SAb��_��q�^�n�fv20��h���7�c~��uƾg��mh�e^\�����J��ʉ�I����F�� 5�]m�[x�K69܁��@����,"ëg���f#33��T}�|�r��Lϩ�4�s�ͫa�~�ގG�W���t�4\�Fs4�e��l�:��2���^�'�oy���9�V7y/��[I�����G�UU�B���0B�͂�w���[@u���i�/�b⬲�
]H��@*ɚ�H�6J��=d}ٟC��w�^��n	�u�­y4��1!t��V�¸��(�ޮ5���V���|>J�ܝ      !   �  x��[kS���<���[IUd�C�U��'���<j���%[Yr$b~�홑�,,�-_�{diܧ�O�ny����c�(��uG�+�z��X�`t���8�,P�g��(,�Y���DS1	��,f�M{�N;�9�"��iR��Qpg��H3�.*Bs��f>���2�����k_�&��ܶ��z�j� e�Y�f1Lp{���Fj3�}����p�/��������(���)�<:���qO�>���{x��ΟL�٬��<�={�����e�1:&=i��
��L�"��f(M�(	п'-b���<��OEf��f"�F�Ҩوbt.�>l���/�@��Y��|e_a����O�IPt �f�;�ձx�Z����ر,έ+���Qv��|�a���:�8����ϓ�8���
Dg� ����hh4m4}8Z�s<^��ЙȊN�D.�A%ѭ�J5�
Dx_:��r�3��wF�d��#<��W �:�����'`���ԢW_�1���ob1�q��?/��E��}�+�����kQ��
�5xP�1C��6�L92�!��#��t��'%����������A䎌�<�i�����wF_��>_o�(��;����=O�����w�������G�����?���:�]�;BY��*�(x��:��4 L�%�="�d�5��TPjD��B���~ ���>³W�9��]e�yҏ͑;��(d������OO�����1�;�	
�kT4�D!��ڀ%���3	5޳䣍9i��g��0��s��p6��iR�)���]�$7<���c	�qJ*�(��q��=��l��s�zx~������:��Ӿ��}�����S�������r��^)2��X��Z\A9��q&	UY42�D0�C�?8R�z��W�����x��t�L��?Lc?���8�S��e�g�mۮ��1�jT��'E�Z��jC�S8k�[�@J��u:��|�i���B$��ՕМڃ�Շ�u~p�	���ϧ�cp2?�^�?2a]���.gя�����^.�w~��m`�]���UqӴ@QV��cѢ1�	�������a%��m-�QL�xa��P�g�_����ߠQ��(����XJt4��\-mF�bh܄�׎E�kQ�q�8:� R�,\䀞��NC�kqB�o�J_�+��-��vKO�:eq���GY��-j�Az7]H~�CJ]Vɒ��0Ԛ8)K�8Q5�y��!D��9���K�Z�Y�[�Ӑ!dW���@`��P�dz�vco�\tF��8����!�>�\���zܖ��	���9r���;��,w��6s[̫F�A����e �#H?*�g�}�M��a{���͸�"��s 8�����/�-�+	wc�U� OF�(��Q횊� IZy����;l�J�?͊2�]4-W��B���3(�=p��>%~}YFƹ��*($A���j��7�"��0q���f>�Z�[�
h���ϼ�"0�rO��<*4�¶������)�V:D��u�P��)�0����
Et���T�65�"�x��{�mc��<�E��w"�ņ�`�Je���!⠓`�U�.���<�pwaj�Dbs��~��5 �j�Lu�bɏ Ј����~����`�@?,?���>p�m�v[P} �X�/��_T��B�F����iU��Fey�<�����CO��Z�"��B�C�D�.'�H��tngW�h����:�rXW�L��G��8Nk`�&f���l[m�8-i�/�y��y^	mW6#�H݁�&���OOw���ZMw����&������/���_|��F������|��z߯��w5�T�"�*D�.*4H>,mD:�̢��ZY��B�� L5+{s~��]�o�9=98�rz��m%|'���/Ln�i bh���[��H�U�Q��BB8������$� AB�kR�T���G��{�������D�?�6m3�]���M�c{�Ƙ����]�-�D����ӡ�&Ƒy /�d�=�[��=�?���($�gUHǱ@�?�kK�]��*��c��X@�if��g��,�朶���)�0��	��0J��`�T��M���ymy��V�U��z��u�V)���o�p�c���y���0��)u�����(9�߾������C�L�?y���P��x"��M��^o-`���-9[�[9��N��&V�����@O�ߎ�??���=�}�p��~|:����^vu�����|gW�ܜ�mw�
+��J�K�塼<� 8����� ��]���d������6�<MS��0����a�~�@�~�ӟl��l�wgM�����pXA׀��4�1�5\=6��>Pat]��a|ZYEH� %��~�\���Z�� ����'d�G�2µ�C-L���Ą}�whE��1���)�������T���@
�p�|�ѭ\�`�YcWu��(L����Z{Zm��K[{Z��^�m��IF�Z�p��Y�G(S�~�-�'��@�k�n��l8�6X�z�Q�����6��Q(�����:r�>lK0G���W;)�C��<�'��n#��B�GC���,'٪�K��DTv��|4����j񡍙�m�L�XE���ݴ������q]�
e�z��f(f������>�|�D*_������Yc����"�nJRCIeussS�X���:I�l�9�y<�?�]��<}u�jA���!Ӌ /(}B+r�P�{��Vd-o�' �����9�����:� k�"���^u�j}��M��Y6��q��i��"���%��\/l3�&\�G�8u��-�B}��!q>v��F��Z�p:��9k����s�j�Sq�&�.Wv�7v�h)4ς��(����/ȗ�Y0џb9y����OLn�z�Yˢ[2��[2��0��S�B���v_��N=�Ad�	\{uƃ�����x�E��-�J�:}��6�B3��6����{V�tj��k�@���D�Au�7XXn�߫c�Um�Q�M�Uz{kS�nyAXA�ύ3Q/�6"h�(�*���|���l��\wڪ�6�
o��~��V݇.:�x&#D$~Շ^-]��P�-G�1ѧ!}������,��{����2J��Kbҭ��Y��u�d��0��eT.E�j�~S��k���-G�+�<6�s4���H�}�/U��kPz����rju��7���c��b�_�G9�.�b��YuL�me�FU�4s�I��`�'_�A��h��偆X�[�H^�Ǻ�fvc�o�$"��2z��{s9Krm�¼)�m)����偳�ʛm�&}����"n��<�y6�.jT<�ո�S�ZLK�f����o�Ӏ��˂�^?7��]M�T�����-P	]���v7'4��X=��f�8�$!��RQTS�����Gw�2�R3�Qn��=կ�8��8��4���Xh��Y�n6�F�� q�ٴ2����]�x�M�q.�q>����EC*��T�/Nݩ��T�"(-�!uq��#��� �}�/+�q��06�g7�W����Q&�c�<�i���EE׿���cL�"w)k��j �.���h���XH���?e���RT{%��gOR���Y����f��q����8�1����0
<�����a��I ������ ӶǼ����s�ӿm��k�khؠ47lW��۶�׶k(�6]��G��֙Jo���_�ǹ�W��q;ּ]=��o��I6��n�Woxϛٶ�5k5[���-W��Ě��,d�M�r�M��h��`#o�qs�󄍐j�j�#M6��z��4�4�m��B~>���k�9{=V�)H��7��Ĳ)D�F��͵�)��6��F��Y�3X�a{�u�|z=բMA�e��ֵ�3ә��4����:�F��<�#��<w�̎�:3?sd�Т� jy� ���T&�ƥ��yV�����S����3�qy'�|��HG7W�u��=��8�M��{�<W�zEl�a;G=/MFK�u,�����SR���T�ڌ�ֿ�V��_Qf�      #   >   x�3�t�O�7�L�4�44 �4N# 4�4 b07Ə����@��L�������HF\1z\\\ ���      %   5   x�3�L�O�7�4400�L�18K8c�8��t�t,�,�PcI��=... ��      )      x������ � �      H   X  x��Zݖ۶���BOЊ�(R��7��4>=M�=�! �v	�Z��;�R\�����(��o~ ��>} �>Z)�����EUB��z|����z��Q��#�}�i��x�������vy$;'���1�W�-U]���S����3ɶ�&Fݥ�R���%6�&T��R��$ibI�~���(����c�/���熶Ǧk��4���}���'W�U$���^i4�*���R���AU<⭙yB�yiidE��5�Gt�jU�1�Rk�ˣ%��7v>�M(�,02^��Q���R�Ɏ�'ӂt�R?�iI0��(��®R��}z��M?N�,mA�p�1����3�cK��a���|x�g�II�?�{:(�D�O����<Qŉ�2���e��!�bv��A�M�Z$��-.r���u�ZPjA���H�nC����~�̰n�~C�+Ir�Z3��'>+���aBH"�%��t
٥RRԚX�[}^�h�8�%�5?ᒋZD]KQ�B֔%����¼I�Qz���`Xd`�%�������i�AP5qA�t֎\
,_�[�l[4��5����}�  ���ګL^f$	^�_�7)��8�O\�bԦO�-�L+�H���m�Gg�j�p��M�G��6�����؆�5�a�*w�<w�zf�)��>�.�j ��H/ɠ�8!!n���`s22�7^a���F\H����2s,3#�=v;�24E]l�r��0kC�����W�ll�IKL����'��j�0��YC�<8���&�|��t�:TIPp� P��n�3�0�;B�)�k6���5����$�֌��ObX�1B�|�������h�ކN�@��v��HMH1�G5 &~��59[QY1�<����!)I&SL�q_%�ys�vĄ�諭���;.
O��L��>�M�66��sߵ���|ϣq����E��c�%�q��$o�c���H�/4M���$6�o����6��u��o�� \��G�-a����Ár4�O�t�����Nb3I>}�HQjTF�Q=.-�rG������ZLr"�!����VIb��ߓ��$~;��I�b�):X+Z�Β�1���- �����yl���0�J5	�:!}bT�C�N��7�:|G�Y�_�5���:Y��)OU' �Vlװ���}�ʁVs��\�,R�/��I(�b,xbܭ@V�/F���F�ҨW�vk�MK@~�d�B��ɏJ(%`�Q-`���Ė%=��;/c\��)��{"�өy��de)~��b�H���(��V�7Lm�a:� ��oԱo��ܽ+��RJgCg­8�&l�ϴ�[X�|;\�1�=��iMo-#i�Ֆ��n�@a�`�p�1V3~M�gTg�~ު�4��_ϭ�rN�Է�[=Lz��Ü!����vN��i��I!��ҵ�<d0ca�\��Cqpw=r���a���i~���h���!'��� ߳���[ɚI���[�Ŭ�s[��5��1�A���Lw?��*��]5�d�������Q	���ۓ�a��$VJ��pX9���)$�B]��V��YP��<e�6�ӑ��t�V��`,���@�b�H��8�'(3���zQ��N�)L=�n=�{~�M�H���d[��+�%�2�QO,���Xu)�fu�j�չ�;�3��$���,��S�0��V;����#o �YnO5�ؔ������}R�1L�7��NO>���6�6��8���m�2P>�ZP)��i.�� ��K�5)  ]z�k/cO�|�㢞��\vuߴU���<�c;��w�v:��huWf�T�������s5n�V�Xd�N�������U�O��n_V��Y�j�r��s.g��.%����v���
ZJZ����UЫ$邥;�;{��L6�dg!���$)���G����1�o6?��$��~���w�.�Iz �2juj6��o� 6�U�/�+ۮ�B�����[�Vz�7J�%{�[��MK��<��bjcق̬��{�OY�G�fX��d	ݤ��t�?�g��l�0D�c�$��-M0�t�Ql@�t�n��N�$1b�KOj#����%_h��O���<7�NKN�B�e����R�R�~]I��xEf%��;�B�Q���E��"n�ˣ��:����2��B���/v�@[�L��춐��Itl8_OaQhe���B�Y�	F�mdr��ڒV�J�ZeZ]�ڵ\�:���Rr�ܟ77��p:-.̉9Y���ʤ_���G��nG޽��I�}c���1Dt֬�Py�)�x��Y�(�2� hL�M,�JskOb�#�H/p���^q������f��HB���2��XXWi�;�(�9Q���3�$�@����-�vw �Ȣ*������Y�9q�c޸ђ�����߯0}M����}&V�Թ(���/�4����Eޯ],S�ڠ���}Q����R�t�Yֵ�<�R-���/�b2򃈎g��s���bv��ķYȥ0����s�2�P��(/�Rl����b���:y��t��MyA>^Y�?��CH�I]
Sj��[C�����Fτ���B�:֨�����$f�p��������C�O1�!"J�h�}�fUl)�tn3&�cg��G��~�i��L�`����W�s���c��m������.��q*�^��e��U�
.�l�����0��(:[ɔ(���{ؖ��ܻ��b�X�P�Ŗ�Z/�v>2^��SʤHn�M>!�/���"]`m
���~�kg��^������Ue��z:>9r�����N��b����f�!8���W�=L�k���$��L���/�]��*Qȗ'���X���x*�#dUͼ�i��H��A�B�1�G2c\�|�-��v��ϡ�@E?]Y_|�e��^^�5A���w&��+��tkǱc�b�\+�\**u���5�s�
29����<�\,ά�R[�ff�f��[�\����y�4��%�]���=y�i=1wfyHH%%��K��7����{s���GO��=��[ȳ]�pi�0-_���Z�����ob%}c��14�Z2��1��+jf݉�l�<F�aKC�F!�*X�gHg���o�~�8�!3�hpL���11�a�8�?��Mў1 �5A:d�bd��0�gE�r���pIԞovT����͇�u3�e�r1��ܐg�4Ml?��k��9Mݩ�s�������,ϧ���>K��Y�g��}ߝ��8�2D߷m�Bȕ��:�2��܏$/���@]#�5��A�C�Q���Q��<>GR����~�@�hc]p+4�`
L_q�Xͳ�\|%r���<�܊��V�W;���o$
���?2+���g�s�fG��������P�<��˛7o�Q��V      E   /   x��I 0�wL��I��q4�8��JJ�V�f4~�V�w���^      =     x��\mo�6���
Nņ���uk9ƚ�A;m�v(���Ҥ@�N�"�}�^lʶd�Z١�%���U�Q&��@bF�a>��l��c!9����q����G�HN��#�3�ώ��	�P8A����q退Q���pnp(���p����`�%��$���%�LT� k��.�r��N���01����n|�DJ��n�	�cL�-u �T�\ؚ� �Jߗ��ϸB�o����0=p�/�l��b��=�X������[��T(�߹٥}���{�
X���w}v;�1fk�GD�j��+��=�ǜMi��G�g�����@!.�.ac6�[ɕ�M��|1���e��ʓ�V���1�b��'J��$&R�d.����%r��>rC$T�s0��Z=m��q�T���C�c*��S5��L�B��%^�r��؅���?���覗A��怞)'���_\LCt�j�k��P��`�ܡ
�ϕ�8w���V~�Hu�&���2>��K�n2�>#a�"�u�y2i֘7`�q�Rݎ�zٴ)�4P 3�����l����􀁯�g8����ϵ[|�&d�F�9�f�Q(_�S�u*�GG��r���]�?P �]�z���~��ߢBt��o6�j!7��Qs !����є��3���')%�[F�~v�V{��wJ�,9�3��E5�J4���:��+�,-(Yi�:9/Mp��a*'
9��#(QX���S�$7`��rv�ɭ�(�ے]~��>���|v
�g�_*`&(�fn�)D��`�<���1���5M&ih�h�݀5q�2=����@_%3O6&�$Ll]7I�o):;� ��[Fj֍#���w��j���5AP 0RΠ΢�ա����dF�ͮy�:ɹ"pX�dg81��\��mK-��͕LE��y��
��OXE�ACc[�p:��cU5�Lg��������O���p�u)w����PM���^-�gb�%_(}��N)��
�$�0�T�M�X�Ӵ�F�K��v�HHȥ+�>�ꚠ֪꽖>()%�"+V�0UA�t�-ԔV��XK|�TAY�U?��UکA
��'��ݰR��ҳ���nv��M���aA�~�����<�k��T�̢�J���b�w��1�l�:.d�vo9�,-���&د0R�Y�0k�0 u�W��F{�D�%$�f�(�}��y������Ҩ��&�Pb�2��)x3�eM�A�S�tv�1oY=��]�ӽ������um�\��NV9���؂0��悢juΤ�:�X�2s�(}M�&�t����A�� Bᔠ:q�v�R��"=.�Ԍ:�=0#�Ԛ,���L��jx���	��A���ֺ%����6�OMIl#2?�!�]���pۆ��׊�.�[=(oCm/-�]~�e�-�m���6�e��g�~[����߻�����4@�N�w�x��-�m��c���Ss�;�AV��g`3�-��e���:w,�y[��r��am��vT��>�]��t���-]}�y�tu���X���g��*�-=ډc�J-c��V�N;OJw�)e�1��5�^��j(f�
b��{�օ���]��p=��u���X��V�w�X_�\+�7*F�Y�M�L����wU� �i4��^���S􇃆nηh����Ղ{�I�ǓD������1� �S[���ޖ���ߣ�_�(���͢�4�7��?Q_�^���U�y�[<ő@��ܕ牒�1�q���0��,�̠�����I�p��MlẳAmẮm�������ɿYmK�      C      x������ � �      ?   �   x�U̽
� ����*����EmH���KA$�4��`,�����p�"R��6w^K'�3D�)�c��1a�K��c&���٣�V~n޾�Ny�ԔWy؍�0��$�\�E��Z���t�_�]?���0�m��
e��F(�e�"f�I!�-��J��S(���	K7Ͽ[x� �@�S�      9     x�e�AN�0�u|�� y{�YV� PQ��B��*�%(iJ�z{Ҹ;��x��?h!!J����s��M�b���U[@!8"MQ����`���?�Z+������ա���y��4�  7ˎ&�[.`� ��&Z�����o�4��\Ml1�z?���udI�S�G�I��[7�;��_ǖ��X2�t��:N]oC9%H"��n��<K�����@4�W�<�x~!�������g�t�=���I�!����]���>,�A+#�B��ȿ�o���c�7��?ʱo�      ;   d  x����n�@��� ]�\`f01�(h�T�*11�����鋵b\�tsrV_��� �p%�Q�fs��m~�m~�dY~-���&cݮ��,v�r�ݥ�K�D��]��0+7��&�jGL#@d�0%	# 1����r�o�hV�?�=<�`��i'ǰ�@��He�V:�ѳ�H�x��O��;� !�Y�����_����)EOg7�zQ
zv�5��8qs���\��0U��j� �U����'x���!�����yl�#j�d�[p�*8z����8�fMw�EI<VV�������V:������=W��Zw`k�u1;9�Ӿ�iy��Of�-�</�0���no0�dEZ4$I����      3      x��}�s�ƶ��W�j꾕Š��z5��ĉ}��l%wޭT݂E� I�
AJ�SS��Y�rvSy�Y��+�S�$$�M���!J"��9���L�Y|��i<\ŋ	���f������E��$_�˄P�\�-��i���*Φ���I�����W��*��GI޻���m�_������\&��+��8[\CYI�z6�2�"ߤ�
,1u�3E~�|6�fI��=�1q�J�Х��i+����7w��W�Jsz�J�2��,�~w�6;q�#�j)���&g����/�d ��:���*�IlU�Ș��!B���=���eg���P��e6ͮ���(��t>��f�,�+^ųeF�g�t�� �SMgZ����,��#tW���;|bK����,d�,�oY@Y��>{a�kK���>P� y�헣47>��A�w��ytC�<)<�H���K{.ׅ@w�gat�D@e?���=��dz��BCE.�8[�3 K�%��d�m�Ps�����:۷ڧd���D��^�&�����'^e4��n>Jf��޳��x�PX�w�U6�{��sd���k�ĸ���y�0}bH��=1�W�sSy��ݫ~�8��j6�۷�RG������\� ~h�v�3�����#��V�'�/8S>�3�*o|��r�|�K����0�I�#��3O*�C��s_*O*/|�<ۿ�F�_���Ǖ��D:d @
��a�ȗ�
vV����$�.�����|��/���֖D��-��E�lɉ�w��;�Z��lv9$��CK��� ���b��X\�iT��|�f��Ax��bg��������^=c'���I�}bE��|�@R]�z���3
�
�臼/D�sUkɉ�-]���UZ;Tڈ��d��K�u|=�N�k�uuj.MD�&J#��1��f��!��,0�,���^�m�Ě�O�1���QOp^����l67�*����oH�X�B�G��
rS*W���]@CI&1���������s'%T���{Q�>�����U]qodS�L����o� _.�d�<h|m����F�%��F�P^�6�1�Zk�P��Z��'2
&MqR�� ����tF����	U@7� (?Z�����%�2��x1h|e�*[%j�ҕ��~�QӞ7�2�7���u�2���g�z0#"���#<������lUT�F!o�Av��9`R��Gk"Bc�򎼜'�nW�0���qR6�y>��K��H0�`,�q�d�c2�r��k�����|5�n6Bpe�r�y~�yr������-?g�]�rt㉯���I����T���И��mv7�������R�ٙ{���v<L��V.! ���4[�f0��f��-\���Ƨ���6����EU��.��$��,�uA�3���@/ۗ�ؓ7�<��Ʉ���0�0�PK��;~��r�GGB�FIL
�hQq�I��s+��
�l�Y�
����rRєʾ�V
m/��U
]�P� [TU�CB,k/e�,�g�O�� {X�	2͖�i�1���+���E�$WXl�������[P|@��k(V�ݪ+V��H�+V�4�V�v)�ntX�ƥX	2oxX��K�@�a^R���
=\��r�a��C�.�@���r�T�x����
�:F�Xyٰp���,!���m��Dp�e������vZ�^J(���j"e��/�eg;)��s(ˉ)jGa��Ö���GC ���P-���n&Xӭ�W �(����*�3�M�	��4ز*J!�P�r�!��Jȥ�}�sK!=ڊڲ]ƃa�"�-Ćr�3`Y�B�Ǻ���U��V�l�d2��i[��C�rݸ!i�m����&y��h&xY��`X4�ٝ���E��v
��ֶql�n��l6�=:����V P�ٝ)EӘ|��&=A�{L#eP�nk��\�j(W�;)S�H5jp|�W���hD��- 9QX��
2�6�k �T��~\b�}@0��Z��Ow�,NU (���u�쳨Cц��x���U[�-4[Z�2{3���e�/c��#2^��`>�L�ʆ�v�]�(�
{�7��6}>^v�$W���F)���%Tb�]n�W_���k���k�A�Ri*�>� �Pi��8G������r~����Yxe<~���e��<��|X�GxC]r��#j�V?,˲��//��%y=�wx-x��&]�8�LW�����rJ�C�z��EwVu�-��.R8��;��wGj0���ɨ�h������!�? b@��K6^fI�L[
���;caBX�PÛIys�<��r�&��yk��@�n�&�{���*�HT���*��l4�[˃��)�`���|@U���鰆�[����ɢY�Ut�
�����ҟ��#�)��Ep�8�9����6��$����6��P[h� (�al���䎼�o�A>�U��T#*�&Q@;с#��8��4��baO��xFOle�E���}j�P�њC�Z�w?�d�=��Q���A�w9Z�q�� �����ϗ_���K����m{�<��3�a��p0n�:�&����4��o��R��������+`���-?)81�\��\D~����u��=,u//��N���]b�i���� Æ ����]H0j^~��Ep�k)t��C�)�u,M���������2Az[����"��y�R(~����/(3���������`V
Q �XQ`�
����]{ b�L��k�b��F�0�D��h�2>x~C��A�A����@��� #�O��[�9J���NU0��)x�ܮ���x�R�%^��Z�9��G.	u��j�n����Ӽ����EЁ��%�8$��ګ=��ƃ��c#\e3v��D[�l� F����؏��CfgD��F�׆F�6�Km�ѫ�� n��dV|�6(�p#�S��ǐ�1�:1Xf�Ԅ���2t:�/���fK��
����G��#XH#���2Z��
��Mv�g�uFv��RGI�o�K�{��0����"�`���G��}b�Ű5>�(7��(��e��G��?��Նߣ�De�/]L�O���T��C]LiAZN�@R������p�І��7Dc�n;}Cp���Oߐ�x{��i0Z6PQ�w�t:_$σ&1~W|p9��H2���E<��{�1�+hg�q(F�s�s]��,��;/�g�^7tP�c��t/��v�� 6�o9y\��l7q�1:���$jz����<�\Һ� ��ϻ��0���u饵�kd���G�����Nz�CAV����\
^��H/
g�#OO�� ����G���ɷ��e����}�.���B�j�"� ؤ�����`2�\w�����U$j��m/�y<�[�-�� �QS���&�H8���`��`�F��vlc#���G
t,m�P;%�"�	ջ�Y�F���e�����y3�G��~M>��Q��e�k�:Ғ^&mC���G�sy���1FS&�C�����`Ur�Mڌ�LE�5EUA�Ѯ�h���Ğ�G�+���9�y�Vu5:_����j9���C2���A��Be� _4���Rq�F٪�D��z�>����]�ʚk��.gr���1��?���}��"�`�v�ga�6I�g�gX-�!ڲ�ZӲ�qU�Xj�F��ذ����Ms�v��/@$�=%j^n�&3{>fc�����N0���WI<_��be�5g!�N�Dc�K����&Ʒ��>Ƌ�8�e���&ApKO��	e`qX+o�A���N���T���W���=�#�\���1V�f�U9�M��ʆ[�:aD�����ᜌ(�������H]{2jD�2�~�X5U�4��g��@Lh����%�a F�$�E����뱚~��8q���$��r��K�-�a�L�����C����tj�оdxIKpLT�� ���
�����a��Ws9�O�MC3�n�'�T��˷���Ŗ;�Ҁw����|�"�bi^�m�iB��%!�Hg���    -2&?z���k[�Do.��X�y=��� f�U��o���	���<OW1�f��ӆ�a�[���[�XJ��8��e����[��ŉoGga�5kO@�`�o���^q�ı��H�|h/�w�d2T��9���G�d~�%���a��'O� t��)�B#ݮ9���AM9k`i
7Ȁq��6�P6d����?�����4$���MW�� �l�$!��� k��V���)�.�n�|!
-c�j���#O�^��<��t�Y+BO�9��3�`��u�?���~�}��6�4�@�'�m�n�V�$�C��d�����8��Bo�W��e�p�=Q'|��"���-����*0��b��E6�{v�ʑc-�}�ȧ�Z�۟a����a<*b�������u�?���p��,�ţUݕf'n�]�6@`(�$��x��IlJk���4��P��z�֙.�$5�?���dc�'�3��}�#G���U�.�J��A\�M�0ڛ6��0�������X h�/�rR�l��v
s`���S�o�}��@շ������%In ����Y#�E�����=ό��A������t����-\�
X?����5��a<Z��`4DCXްq����Ƶ��>�{�Fb�q����v��]<��&[��&���*O�dA������9�5�p��ܰ>>�7�F[UZ�� �u���
~O:R���4����

=����-(����z�-��ؒo%k�������j����e�x��1>���}>�бR1Ma��%��t_���)W�)�X�����Oz"ס�f��{"ء�}������2��Dj�X��K�D(�B��s���<(��@�<(��DR0O$ � �Z��:�M
*�M)�:�S���Z�(	�MJ�@����L/z�v���=�R�i��'LC�		��H�V���D��%l:��xȃO׍#R��C�}>�و;n������"�0�N�z����3է��[����t����A����ֲ�B�ZH�d�{��ragh�D�Z����E�j.��Tf�DQߣM�N[93�Ƌx��i<�6����bS��dq[�(#@Ԋ�Xp����u\k��[8�ċe�Mjz��T��d ���!�8Y�w�{eP*�f�>"�9O�6j��1�!���C��J��M�z
�Q�}��x+!j�Ƿ����׭��`q�hI��)�Ίs�Q�1�ezЖ�G���J�ݺ2ϭ��1��5"S~��F���%^��Rޓ���[�a4�oI�
�}#���J%���HN��=!�|k�m�=�az(�/0/,z�^�k�N��du#�*VF��l�ʞ���{&�'��t�QqO�� O�� O �t ��@- ��Dp��a�
OU.��JC��r����֫��P������P�����F��_~���a;/!=1JP���0Dœ�;0)_6��y	�I�s�)�<�x�0�'�F8Lx�	��{�k�&��� ɸ'�F8 2�	���{�i��@��>�=��
O�t��`�	�'kU:�U��Z�kUx�V��k� &�9���9���U��#�z���݄�*d�vT��s��96{\����E�/̅9pF�wa�Q��^�o���h���/�/��a�/�/�`���X����N�b�b�;���9�/h�9X�/��9`q����<�8HT���4v>#o��8�]�l�
�Lb��{v �2�,}��=K_��>K_�L9ps_����/}103�>��v�*��i[�����r��I��������[$m�����%0�PO��?��dS��$!=���! I(Of1uH�LJ]��'��jm���R��.S�`R�t۾�nR� �%v���/���8��}�ݤƁ�*_8�q��k8�����}�Ɓ�j_8�q��k8����F"�/����g[��9�|��/����g[��9�|��/����g[��9̔����a��p.}Q:1�s�҉98�K_�N���\��tb�J�҉9�*���D.����D���Bm"x�Bm"x�Bm"x�Bm"xy��y� "O�<�A�	��<�<��<t��'��6���Ё�F�pX��a�/�'�p�|�2���sXz�ay�?�U��6�t�|�4���V�����sX���.�a�6���.�a�>���.�:d/�eo�1�b��lm�;&�lV�밍��es�*v�}<�kY���F&�!㒠�a��i.-�`')�(�����Xii�����~��G���#��
�svZ#�9���8�H>�F�Hf�x�[ȼ��9�$&Ұ ҍ����5@��E��Q��p[J>����� ��O���[c
P��7��bSx�Z|�gż1�N�*�N��%������$�y!;8&�(��]P5��ݿ%�J�6�(��W߫󙠞�k�?��-�N@fqfELa7��Cɬ�7rz��e����d����_R-Θ�	�y�����Z�SR�Qj��A�n:M#p?x�C�o�&�a*�M��#�M���`]Ƣl�n>�Z�,R �ꐰj0�]B��4�n����qi&���O.���:^nEdq�[�w+3�=n�; �6[����k;�I��Хh��D�>D�{���L���₤/�!.H���₤/�!.H�#�₤/1�!.H�#�₤/1�!.H�#�₤/1�!.H�#�₤/1�!.Hj_��C\�4�Pk��6��Bm\₌/�&r��j9pX����簆kg1��i\�p�0�j#`���.�E|�M���X�C��ܛ�Eξ�v��]N�A/���,������W��,����¯��Zs"��o�lz���|���6��o��`��ш��ih���zD4�yl���dW�&�(�}��s٣L�i�2Mf3�噠dV�WS�`��qu=PL�I<��g8Y�i��IY�xFO& uX=<:m�c���m�nO[s)�	���-7��;\1��O[u:v�8q��u�ƳU��-�щ�ػ�������z�����쉿u@B{�P�[B{�P�[�x�P�[��:l	_D\��%|q�C���F�u�ވ�[��!`KxU��%��*v��D;l	o����7Q�[�b��-�KT1s��D3��-�KT1s��D3��-�KT1s��D3��-�KT1sؒ�D3��-�KT1sؒ�D3��-�KT1sؒ�D3�`c�%��;���/�9ؘ}�*f���˗�b�������P�ђ@����8�s����px���2��Z�O=!g܁"(�	9�A���(����3�@���q���'�3�$	���3�$	���PyO�6��'gI�/�;pX���֗���|�Y��NFS�L�e��~�e�d|D��J����� � ?g�Q6�v�SR\/�<��A��	�wϾ���e��o�u�
�8�f�0���Z^��O7a�$���d&�kX��:p������mDH�x?'�Il�Q��7�ۦuJ��N���L�A�(=EEd/ �7�q��N�Be�gp3;�ͽ]T��@�f���#R��l�d\E:��Ã�M�h�iR�`����N�ӧ�����+�Ф&�O�s��&#蟦%��fD�ѡ-a�[K������V3L�qh��Nq��<Mf	�AE�ó2�N�������8Qz������N�SJ�&�7�k���/��!	?t]��a�pD!�J�L^O�lE�Ci,�k�g�A�����?��X vn(t�e�,ŋ��U<Hm��׫E|�<��/V����d}��&�U\�L
�RWSn1��}hq�����M�׷���w���M{������(���4y&}I���_җ4��A�%}I���_җ4��A�%}��0����F��_�sPI_l4�;��}��0�`r��Fø���fhݻ��hwా�hwా�hwా�hwా�h�p��+8,��
�|��2_    8�p��+\Rs5=�>�U;�I�(��]���q��}�^`mbp��=�	��)_hw�~������&p�|�	��)�	���OqOP7w�~�{����S�����➠n�����:`?�}��Oq_8��S�+8,���
+|��a�*��o�]*|X�B9��7��J��i<��u�����
��:��|�`1�S���lޣa�|O��&Kn�o�y�y������-�
X�z!�m�*"h]׃T��=���4�������Т!nB͖��xy�禇[\����߾{w�Ca��$�k��A�;���	��9��_tz'F�3[��!N�^͓C���N����A�C��)[b�1���k	תA��>�t<�4>7F�\)
0�G������6���׳a�,d0`�)�JJt<�޲�c�!�=�6�:�r��^>a�;xf�\��-��s%�i>���m~ G�JT�#ѧ4�ɠn����}�D�h/D{�h/D{�h/D{�h/D{�h/D{�h/D{�h/D{�h/D{�h/D{�h/���+8���*+}�ʁ�J_8�r���8��ê�9�Q�U�?��O�C|S1���0�1�@��S̚�q0�!FF��H
u���	�g�ii*��p*ܧL |���o�bBv�r����V��C�Q���L�A�u�QG	�#��@[�
�uK:P���5H���[���Њ���	sچNR�����k���'�1��hǨ�'�2�`�K�1����:F�=Մ���mŕ�����r���<H�p$�{�R��j�R�N)���u�ɦ��B*�7����:��.��i�����#4B��Zs"�"�;5��R����ZA˗"tӊs��Ӵ@ "d��PqPL��>F�Ӊc�|z(�c�<O��U<.7���ۻ|�H��P�ˤ���o���g�x
_�71>>��@�������Z1-�X���d�,�4��������UQ�0�h�]0YA;�,9���tu!�Q:��O:����4�B�f�&٬�!P�hd�
���q�Y��m�V�-g�
n�g�!gBrqr>;��h"�N��W�7���yo����\�v�}X�,��©z
�N3	��'��[�" ���I��4ftLR}F{FҺ�ٱ}GgVVR���t�ݓѐ�+($j{��~�I��H�������%��ɠ�ג��,�	զ������k�
� H�w�RRD��\+7T����B��Fm��T�����k�S�1�5#p����հ4ڄ�I�F���:2�Z3��d��t��d�%�KFwU}<	��Q�T �}��#?9[=N"E��?�6��p�ЖtM	�N`�JZGDq��P�N9�T�1�ա2��&J�!"�w���H	�P	"��C�4N�������J���L�D�<t�;��'a���H��]u���
���4_�d-;�=�6����oS窎��س��`�!��d�Įq<��k|�O�q8�'�e�;���o�����[��F�`��(���;
�����"��0��x�6o���'��n��H_v�t�Ǖ��!��6�z+���*��Μ�I�pL��~V�?�JX��u�Æ�Zv�3��lZ񐱈��2=|��:�n�O0kfAE؋.B	%"8�/)8�_*��CKBp��>�?�=�s���; U56֛���"�})�x��^k�%�3�_֗�/D/*❱-J@��`d�}V�+~J��D��aR��4��@uk�U�/L�E������)��\b��l�F��4��N�C��z�wӻi�)���m��p����9v�"Z���"[���eV���ܯ�m'�_�DU�/�Vw�'�2�S�1�;�H��绵bv��Oz���Z���?yd���iLq�؃Up��kՓ�I(98X�x�G+�:i��d�Ⱥ_��A�O��	n�ŏ��	?	_+�/�������$O�VT��߬��V����9z[pm�8���͢��k|����b�����;d��K �W�IJ~d�s
��e6�����fB�'/��u<f9H�6PY(( ^��G=�8٭���ɟI��q#���u��O�=�W~���渍��+���Wyh#���?�����O�9�::��akE���k�Mw-�S�):8�@vڀ��wŅ�s�Gi܁\��?�����ytu�U�`�4�N�/[T��-S�$A[VQ՗Q/��1�
���u�Jc�sB�w N�^il/�4�%�����?ը��柧�	#�\�X�y�݂.�����
	��us��򴄭�����4���ts�1����3 j3!�Z�B�.M����jL0tu�H:�z-��䥔L
�+E���g`}1N���ɇPS�#�g�ݾ�Y��g�k��S�4;��Ұ�k�6E���a�S��b��rkU���akUq��r!Nq�-=������Z��y<�H�]:��AO�ޏ�b��@�� �ߦ����n���N��T~utF}&6T>l�L�k$�Wܢ�F�~���#*T�DO�(�!gF�;R5	���cO)A��f����iz�<��L.�W��dQT����	��� ^$�� L��E�,[R�����0�H�X1ʑ��6ʱ�$$��^���-9� ���[�C��0�ͨF�9���q�Z��ɼ��s�	��k��b�6�a��꽮�}V����������C�"�p0�c'��A�<�������!�gֳ�H�Y���rpf�L�{z��]���@�Y�Q��!�bh�%�즼�7�Ä�I�����)�_(4�E� ]{bzz���B�F�����+D��w׳���Y)%�����;�]լ���d�����~���V��b���8w�r�uo\4�D�� ��|6��:=�'PMnc�AĮ�������lޙ@�,d�-X����aѡGH�����b��	@��:5zEF�c2�'q��X�Gz����F� ;=�u��c/���Y*|¬�LA4��ܪ|��+�h�K,�ܭ��o_�h�)$�����2�-?���o�.�,+*���g��O���� zu����7��ﾨw�����?��8St���t9����7F���*�����9��������f��v�����uӒdU����t~;���U昊#U�T4����fg��6����h�A�ls�f:5H��P�T!V�Z�\� ռ�v�O����c�^����]����<��ɖ�������`�\���t>��)��Y���+r�Ȱ��Ms�z>�W3�������D��pu)ѓ�2�����M�HKT��K Ѫ'�%��T�� $*8���\Y£yK����(ܯ��L<�fqSa�1����[��m�V�L��
~T��/g�S�n���/�A��Q��t�iy|~Zy+���I4��T�"�Ѳ��bI�.�h�Hw��*E�x��֬?�ڏ��b��T�"����;"��N�'�u�vBˤ=Vo�X��ׯ�xGg��?����;Lm�G�7\`uHQ�����?Hm��}Q�w"��� ��q�G��г`F0���if��Ǔ�f���n�W:��w�٘(���?�K��!^;�����M�!W;�g\-��T)��m����T�Ka�~�����o���o���o��������_���߿�������������o���@�����2���2HKk��puת�$�A�� ·��?����ڟ�g�7����������{Ѓ7���"� ����(�Rz��B6��a� �~����5�{�HJ4��H/� ]��|h!HטQ/d=�![zCO�ڐ
��Qu�j�pI^X&��n�ka���Iu�T��T(��.,p�z$�;��*C�F�⴨	F;-^�+���x�R�I�ꮌM:����s��> V�̡�5y�X�����UwCMw�xtJ��cb%�H+�Χ�.��Ze�QJ��j3i4�G�4`0�+�αځ�r��J�����c3�����O"�0Q�A9g����n���I>e=�Y�>� �  0����]�h�
dX�Ǩ�O{�U��`�����
�	�,� -��f��0��b����jG�R������W֎���*��p�!�3
$���)�9^��	H\˼�[��03p�$�8c|�1q���qT�U4R�f��d�F(�z�ɰ�%���G��B���ʒ����������n9A`�&ܨ�'UUX��[�86`���S�7��t0�eF��uB&0c���T��u�M
`]ZP��"*�sSV����� �J?�>��`v9�E�� �T��.������b
����{�Ȯo��zK	���!s��ŖU[-H�GU���,��Kk�%W�urרPe-*��Ҡ1\_��^�	0N+�� �vw4i���(}F�EC!�]ش`{k��6#�!����J�(�O�E��֚f�:�π�i����-G��6j�׉px5�����|ܴ����	�@��1C����ܠ��=�k5HkYfC�	��hc���N�����+��Κ�G'��J參3����Vݧ�ĸ�m��cͿ�Q�B��+*A>&	��4ktIc<��;o,�dZ@>�y�̮|���|��Qkb$�51��P�6�7�W$G'��Э�VB�L�����{P��a�G��(V+�dd�:�҅����v���J�HPv���+PWӜ�M��4���U��i�6  Fy� �����c�f*�V�Un����Y��R`7��KH��1U"�4O M��@#1�\���ߎ�i���h,��T*"�ij�� (	ٓ�Ŏ��`&Y�lg5?��Hw���Cw�ަOJn���V��G@Ʋ�U�ؕ�ֲ�Śt��a�d�] dxaXy{!���f�UMJ��Tx
�{xd��
�0 &1���d_���t�f�>o:�wպ���*��W W�孥�O�;�݅� I�J-�]3Ƭ�E�87J&"P�c��f��ghT���,@:[B��j%U�̟�A���}0)w�b�.��r�	�ؓc�6}�MqLMO1��L3��̗��ݴiB���8뻺����Y�o�t�BXXV����(�#��q�����Sl[�����+�'m��YK�l���w�ҽ�j�N�+���6I�(BE�{XW�?�,���a��r9�g�e�iJ�De<)�L`w�S�������7����)v8$Ă�VwIa+� ��oG�`�,ރW�P�pk�̂r��{����v�:      J      x��ko�ȕ�?;�� "O�/��fwf��M���ɛ/�H��e�)��_�V�N)�mRUR=c�yꩪS眺�0t'������yƳ��9Yn7���s0���˙��}�����9��o�9,w�U4�����>�����e����l����.|��o:g��!���	w��F� wPBq��}��o�x��o���=����yq�|��7��p�U@����C2M@GI��E�� ���ϳ]n�h�x����S�}`�������yS0�O��ϓx�O�	<I[%� u���I��? ��6��'��w?�u~]�</Y�?\��aM!�Ra2�P=
�$s��MYp��8( QM'r)h1D�<|�n���q��z?'�]80��I�|��կ*y33��w��q
�
ȺuB�� ��L��§���X��Xҩ�*\Q�q2�?)�4SSf��45u�]i����d��SQ*��C�{�t��vT8˧�C�*@	���i:��UU�|�.*Ft
LG��e�{����<���L�U��HU�Z�m���>J�T�$ߨ��Y)�T�ݘ8�#��V
']��������-ZɆ/���:�6�B�,�;�<���	��Q�)�|<a%Q����f��"�f�лg�A7�O�Sa�T��'/I���������`G�zD=�C$s�p<��H��Ŵ�H܉�F�FX_4�a�
KwL�RHB����l��/wj����8�'I������	��PN8/t��;#1�͗�0���-�h�w�ā�����=	tR);�0�r�Z�I�����x�NR6��ǿnԤ!Ռ7� �^g�γǿd1J���8	FrF�X��L���Z�L�ԭB`$bh�1e�(��X�X�L�Uඍ �P��J�$�<y���$�Β�n��L�m��L����%�Χ���_���aGM�_�2�o�wp؄K�fwD\"�`��Ǽ�<���=�(�R�1�pC��� Q����^X�ya��0�֙�k��^�fft��D@^��%,��/���RgU�6��"5ˬ�[f��M�������w�g64��_cB�f��S�����֫�B��mt�x6^��+�F
fIK-�-�*��5dI�����hWf���,����a���g�ξ�`K���Ȧё����K����'�z�]TaE�3���]�=	P��P�O�&.�Q�M6r�(v��LWi�e��i�����Iץ���v�?K��e�:�2-�"�jn*2�7.�N�.�Xk*�I���.T�h��,�����?�e

���d�1\P	���*}��/���W�b���gL��Go��I��w����Ҡ:l���s�Q�}��=�I<����Y���?������ϻ�,�c���}��GsS`*(@��&��g���ǿ���/H���5�� �$c@�d��� Kݑ2�®�Qg�HE��h���r��ҤbӕP���v�mS��"�����vs.��Щ)�( �JL S��Q��o�4g-]�ِ����H!��US�O�~|�P>��<Q!��&�\u���&*�@H��c.���	�^6s �T��lP�O�a�O��OT�6��B�����	�MU^Y�՟�Bq���<+��=�qt���൙G�U�K2j�W	�D$'rm� %�rP>]���h��-��.���r��B/�Lw�2�����L��&�yS}m���*R�-���B=p�E�!T?Bo�����!�'�����<u�K���j���H߻8$*��>oy��8�Q�\D��>qP�v��B*HIU8^���Ex��忊�*O}���QzM�Hva�V *Ai"9�_|йQ��<e_�ҕ�$�6{.���?v�(�s�업|�Gv�2�&MS�\�¥*a��F:�2�z7Z��E��PO������OS�QZ=^�3-�Z	�e��%����h��.2�������د*6�ÿ��_��L��)�U�lY9R,�����$����	vm�)Zo��Ϗ�A�y?�Oa�d�i;B;�F�:��<�'_���Of��Ƙ$JPm5MBoNYz���A:wu�fKu��լJ�܍�����r�T����/p�*	Z&r>k�5����Ia�����۩
Q�0�F�F���J9dS����Y�o��S�p`�L�B��V���9-�$�g�.C]~m<�JɝL
�ϥΌ��-���Q��\Rf��˩�t� �H�6�+&k�lR�Β���i�h���M����i&X������2�T� ���ኩ�z�"NF��\��2�Խ�i�6,�0�X�ʳ9`�Ά��ِ5�����������������c`f	(�Z�::e��^���5� 	���;V۲?/[��qΑ�{�Gz�{8�r�8����]�a��$%A����
�J�O�Z<�X$�'�%� ����)[w��F���=G���xAxX�j�Ju���=�Ԣ0���WS�
Ck$P�Eï�j�N�<&�|uV��F�a*�c�Ք�Z�^��U�PȡWL��s���Zb"��pA�ޮד��8���oEPn T��A	FC��2e�4ͪ��h����1�^�ek�&-uE+��N��p��^�_҅������@L�cy�������dudkݷ �,P�p�'+�Y��r�l{�y�+��mU�-��3�;6ے�)XٯQHj�;a�#ʳ��z����-�C�(5(��WY@8k��Z9CA�%�\���H���Bs���|Zx�n��-����>{ }V��ߨۓ�웧0X�������PN9�2~����?~�i�[{ˍ�{+�&���� �����zQ�\D�.����z��az��0BJe��6����~�q-[��Mv�h)�^�Bq�r��K�KJZQY,�HHɅ�XL*�S!x������o�CO���&�S��C�\�X�`��0@�Fa/;gj�9�i�p�3������R��Q��e��LX+
�&�28P4sa�,g-�W����J�UT��2"Q������C��v��j�V1<Xo:���l_��� �d���=��Ż��[�8��1�:�}z,��
��#=e�:*
�� �	uCO w��2GtD8aG��G��RIIJ�g(�>�c0c`���3����9w�������'Gɳ>ߢ��]?��7�7�Wo�+�bo��j�K��'p�)�<Q��d�d|���8Q����s�E�FWD�6�u�3�rUECo�}#�:a6�!r�|�W53�P���#�=	�{vB��k+��޿�_hkz�FXՇnm`��4�U����aŃ lpX��28�xipX�2q��:�'̑v��#v��#ش�v�ôgv�ôgV�6��5[��6��	78��*38��]R�]f�7��Qv8��a��dԍ]%�ణ���W7�`�b�HaG�Ec�jemvj�^����+�-�k�#v��m�Ny G�W:Ԧ����r���#)�D|��|Mٿ��r��Q�x������ȥ�#���!��.�_�]���g�+����|�w�H��%*��9�D=�*����v�Z�i��F������[UQ�8�KKڲMK	*��\>�*22����L�Iz�Ҙ6�ب���
Ŝ�� b�.�7�R�t��eC��F��h9��q��$�T���&���>=��$������_&��D��p�a�Q��)�:)���*3�-��.�X���fVp���ӷVL~����y��Re���I.���%JV⌝��qjQw&�ۙT�=U�����fV��dE�VK�_ӒjE�������7�r�R��[��-E+�7t�aUv�܉rq[5�o�f���pySJ&��Ԍ��U3�vj�TY��!q;�R�V #�meG܎�ɷ�r����\}'M�\cݎ���ԍܔ����s�ʱ��������vN�8L�*��Rx��+�����r�Ƙ�Z���/^���7|^����q�m�����\w[��.Z�n���*;��]xy���q;-��V�a7�] ���o�U��q��\ey�Ӊ���A%�m�3yK���V��c��͘g�n�V������(�-��߄�,����&Z��s��ETY�v��jJv�mEVٸz�U��s    �-�<��ի<��6Lqy� ��8��a�Ѕ��,�>�"�`ǥ��8��q�JR)�~�e�n��fb��|+�Pyƕeu'�4�,[Qwb�e;���^Եo��D�H�uJ(��N	7ͧ��m�rO��I&�}�-ߪ�E]p���:N�pX���l��w���)���}X���R�8VI�L�	8"�ƪ;d�{4��L�X!&�sG��`!HaE[�Z$��K2��{0����\�s���cP�$�gQ�.tU/�*������K��K����!����s�Aw�.۹t���_�2��7�'Ό��Yq_�u�F��mu_;��p����:�Y���E�k��F���G�}����G+fPkg��+����@D�*��[�|T�5�^i���l@J�V� rЖ� 
Ж��,Q�,��.��*[��U3
;RaĊm09��R�!��m��R`f ^��)ȋ��� �x1�s�0 /fH�,O�l	�[Q5��X1&��8&G9�+.|���"zP.���W`��3��ʦ�#��]�aqKY�5��fPީ�a ��'�`��}=�)�mwA�����~\JU�D��.��>
h&���e��nhs��{�������_��Q����g�%�?b��٫@��Q�ʣ������N����M� ���\i�U��1�ͷ�'3�o��w�2����7��v�e�4�p����p��NM��v>_�B��O�&���U��8
��i}����b��S�$U�5��5ї��2�g���6j�����v���+�Fש'�\����Bp�&��eW� Mgu���_��X������?}t�boI'����)�R]�����Nկm������	N1���34��<�av�Ϲ"�?Hz^zFw�벽�;��z�)l����κet:|���U��t�l�kt!�'�Ji}l�<��b�1 .��#+�<]��10/��Z+�"�P.u���m!xP� z��	�M���'��a�\�>���>~���GubB9z����#��J�,bt���$��q-!W������8�b/^e�Ǩ�6->�W�_Q���F}�?�.��Ҵ�д&D��{uo�8B���"<�^-��z ��Rɡ����_��~8������Q��oV
$�N�^�����3���;�cJ̴H���+l�������z��y�	Se/M���ۊ)RdN";$g�,�A��?��[?h��_b~$���%�=����u�q�GZS'(��[ �FFׇ��vc��)tr�ˋ��=c'\B�'�|) ��f��M]�LQ���Qv��ʧ���g���T}��3��.����o��6m>b�]��ǭ���|�J�<��|V։�d<-8����s{~��������I�+��0b��Y��O��Ȣ��p{�Ffmd�2���Z��z�T���۫52i#�����鷜�y<�C�B�s��9x���w��>l�i��P�Clj8t�CV<�^��<�{<ڡ&��=�m(�G�͊혛w`	�)�v��{�L�:ڱ8��2����-k�ʠ8�� *8�lZ~H@蒻�7�Wp.��|�{�'�����t�tR��O8#X~X$�c�	Dh��(�	�P��1!٘PUm(*��� �?��TJ2B�5e�ȏ<������F�8��$M�i���ʟE���wE��E��,���$^,��c����=Ώ����������5:.�/�/�^�(<��Cz͓�KE�g���Qƒ~ڧ�T�
hZ��Ӵ2O'�̎1���19>c3(̀����a�uc�L$p��H`��씇�9E�Ü��aC$0���s>Ն=���5��.EBW��l�=B*�Ǫ�$cOM�z��w\&������0ӆ�F�sm��ݞ'ɖm�A�^�ɯ`ٛ1�p��H��aĥ�	vz�L�M� ����Yos�	C��2ðK��f���Ʌ�O�����4�/Wm/�+/s���e�a/\>�$4c�򞂳���m83ھ���	����XN�ݴ���5+ݣ��5+ݣ�%�5+�����5+C
�=Gg�t��DN��ӐH{���)ٝ�Ei�̑��i��mMv�����-�c8�lY�?ÿ5ݝD�0��f��)Af����*'J���փ�C"GG.%�L�
��B��rx?��e�C0�҆��g0I��c��A*k�%)�A�m�%)��*�EF����-N�NX�3C�b� �p��ON8I"�ryR'-A�k+��d#�@]�\Fs��6��&|�w��%����*�kk�u11�v���[.'�����@8�����͢������k�F��C*G-�*��8�qE:��O����y�}U����&�n����9����g{��=��]����8V��}��G3W`�|��c՛6�7ޟ7^4]�6_^����^���[=Ng/���q={Q���U4���Sovx\MW_������qu����a�.E�/���/�,:̢����h�E�C�n�
T��(ӗ�¼�%��`�����tUm�\����S-����5�L�S��x��	tEg��f�hf���.���v3�k	ɽ,0g�g�LBr8,H*V��8�hs�j8KM�N�m�_�0�C�S��.�Z�z&��p�dk;�;;�)�(���T@6ƲӦlӟCZ�(# ���C�l�6Q��w[rm0J��A�D�;Y&.�h�H(�A1J#���E��Tͼ���
�pȀ����I]�^O{����19
W]v�ER2?:g�h�B p�W�]U'n;*��r4PMvz�mrѤB�WMG�����o��}�U�i��H��b����.;�*��-��/j5�yǘ����ͮĀR8�q��nnp錂h�+��_��B�������2*wP;?j%���R�VU2<Z4[��U��v�E�@�r8c �:1a�Bt݀�F�#�]��l��1�0��	K��(���=���a��SYM�t,���0�j/7��ƹ@�>()e{�����(()�YN�"�D��ڇ�����QwJ����;��,�Z����e_��²o�X�es��"4�.�2</i��/��K�lm�^����0@l�<�a�#�Mm�Tʃ.j����]r��b�C��ZjƦw�S5�ڞ�e�u�k�T�Y۳ql����r��/���4^;ʶr��i�+����L�0؀�d4�bǌ"f����� v<*"!.�#�ˮ�H<�(�~��Ŷל�1@dEc�������NC��M�v��틙��/��Nd:����?��*�[o��;@`���n���`�Gi5]It �n$6>��ٮ.4bu�ՅSenI��FDa�(�F!���I>}2(L!��"�8��qB�S(�eI�5Ty���4���e��vT<�pQ�<�ไ�����%"�~a�\*��e����X��C>;�i�vb-���k������t`�x�JF��-;���߁cQ?l����(��<ۅ�&��I��H
��Dҡ���P"�E���^��FB����bC0���7�@l���a��l��p� š>��\��%x@zj�Ho$�A�*ʢ�`��)�~LA�"���t���I�cocr���Y���Di<���ֺN�gvN�g�I��m{2�d��$���{�ӓ�U=�X�u��q�	\ۅ܁�N��~Ӄ�+
%�N��~1
X�$��]��$��&�E̝6mًV���rl�'�Ŧ'�m��>l�sl⤒�Mk�`F'�mu73<�l[���e�xQ�>����m��L�W�H��"��l�7�@�K��	u ��]��F�>��:�Ǯ���ޱ+w*��_���Aa���b���������hy���:�E������8�A�2ʱ�?��"L�Nz�`v�v��LOێ=:X�1�L�R3ј��t�\;��Idۺہ����|h^0� �L�4dw8'Q�8��7)��"�S���#�t�U�DO�a��݆SD�h>m* Q�(�)5d������3�;�W��?d���1�z@`�+c�Vd��Mѿ���L��X='<    G�|���6;�^��`1`��YG��K�,���!!ঞI��̥ST� �9��Z��ޡ��e��^ɓc�zAkJ{i綾X�����V��|5��w���"K;�ra�X���p������L�v�:�nZvl��� �h�^;���dm�޵ݲ=GD\��{A7���ϫ��k�Ɉ嘻��:�o���hZ����n��6���4�K�-y��;��xo���������ʰ:�B:|���S7��h��t}&�P�޻Ւ��� * �R���Z%"G� h�� )^��-,H��c�հ%���V,��u�pQ��j�C���BEOu�,S�h���\a�3�p�/p�����p@��H���@?q��8�YLǘ�M����7�T��� �� ��p��E�^���t�?Ǯ�?�s
6��6�[	��ocl�no&��59|�彦��M���Q[�;@D�Q��xG_KvHa����� ɱ��&��*w쟀��>D��2�j�n(�C�ZP'u�]��q'u��M�9`�V���"���Cf!Z���y�H��#�̳%��V,���z���4���vKR��oG˗ٶ���m�/��E|� �o�%PnȮ���4A�\�2KӐ��r�?��S��>��|:�vʾ:�`���â��j�c�LK�~���z�|�$����y�}Cﳿ	������$���`;{i,8l���s�yyZϷ�'?�'��|9՝��p�����y���q��,����7�[���I�>6QY1��%[OorTo�p�H��<����.���vs���0�;����9�Qeo��^�_��d?��ۣ��zД��k��>]n`MzW�����JcAJ%�=X4��g�LBr�:�A�!���pX���ȮH/�\x�8އF^��Y���L.��o������P����9N�D� �B��֟�[����:e9@"��"����#1SvG��+������fW��~d��NW����ʎb*�Ï�e�Q�5BTx����i�"��F�I�->��GU'`XK�#�-<�/ �L ����ҭ�B'�-$�n�@�	(`o���S��s~<��cW� ʅ��>�fB��q������b��������W.�2]&d"�����P��7�(�bd�P$F�tH�;@ha2δgCvH�K�%��݈eB�!�d��6��UIF&o��%|;G�	���a�oQ:��)J�'s�ޤt�P�V����] *�sW/�m��.�q*,�1s�BNƭ����Β⌢1G;J��`��D���1-a@؜�0`��+�d�T�k0U��Tտ�N������������	���I8f��D�l�N����$[ce�3$r�m���Uk��a�e/�L�� h��3�TmA��5�̓<G��+=��χ����·�:f>fg�}=n��Y�r�۝Yr�ҕA�r�{?��,���wb�EZ	�L����w�Z�;��ݘ�C���.�w�}4��>C��"j��5\ś���{G���r@�TZ�^~��)0v]=�w�W9��5Z'
@��, ֛�+���g��ѷ����\Ԝ�rpi�E������j�2s�P ,�Y�ѐm[���X�J4r��uY�$؊�Q���uͺdo�HȞ���^]�O�����҄~$�W^�����.��v���p}��E|WK� 8b�����~t��>���Eu��PGt���v�޸A�I0��&��^�����ncwu���l����GP��3֥ϣ3+����#����{8J~]�ǝ�'\C�n�������֏{x���o���7���.��yW�O4�lA��P4��X�sA_�sM_��B\β�C��	o��-ϐ�@�7ǔ�ԡMh�qcd�T��!X��Yr��������NTs��9�M��	�d>�>�@4��B���w�3�,�f �A8	�L�d"�DH��c.���	wd�5�0#�/Ȃ�����&|0�) ���Bzg�Y�M���>�ɫ� �B�DC�)��Z��ogB���*����2љ	�P�4��c�eC��8T�����Аm4/|m��w>7���Sg���@iI�f�����&���ߙpN�Z�Μ�7CXp��|'Ҕm�S�kn��#��KY�*�#ٰ�l3F��`a C8��*���1,;̵������·��3Ȩ�Mrg>�ZoieB���M�fk#��;�@�̳ud�]�'���~E�_���W�H^-䎖 t��۹�ʺ F]\�i��&��D��7�Q��dH����M�u��\�p��v�^7���,�+�,��r���<��'β�A읯��'��1����0Ш�C�0<2*������
��`��4wMX���9?�G|�� ��;@���<���CA���o$ԁ({�BTbq�#�j	���D$\�L��5N����14�!��@bd��54e��`�\�r��k�a�,\��J��Pi�	fr��������~��)�����ɳ���:�kcϳ �����Z�<x�+��Z���k��C.y͓�y��"ɖEr~����޵КN�*6dM�s6W�>�1�U�ΩJ3H���3�,S��u	U���s�)�r�ؿ&��%z}6� ����I�Q�hf���k�4�C�\} �/%#�:����Z��*�� b-!����AH�%k	u ��_�R,�@��"q_��-�7/����LDt-�
���r�u��e1AL��ǘ%k�6@p����L��e��$�0VVx--���(�A!!+p�i����4�²�~jauP?M�1����Ut1�9l&Tko����M���o�J������o��E�S���ՍOu�)��Q7�h�7�5�@���8c}����;AU�V��l&H0�P��B�d"%'t0Ʀ �`hܳ����������4�	��)���L��H�Fg��ǈ�CA�~o���H.��:�q��nw���[>��g�]�;/^&��&��X���%?X�~�D��ҏ�G/��/o�/�O����_��Eq4��@��o�$�=/���y�h������|�=����c<U�{�{?�����?F����8��k�e�]�#?|�?��C�����|��{T���\=�~�����f̷�h�dm��"���Q���x=�+%I]���*���R1x���ϟ��:�W�?�[�l<��i��XI���?���|����Ղ�`=_�|ηJ�<PCUk���v�^��:PO�[������W��h���/��>���������ʦ�k��)~�ӑ�Њ�!� ܼ/;�F��Kn����2 P���"���9�����<�������l?�S�WAa����?��D��Z�f�����|G�O�%p��`E�=U�y�K���Ѽ�̕���g>��7~���H��U�+����x|:!�'A1��K��t����{���	�=<9`מ\̚�H��H���t'��o��!�x�҉x���r�T`���3���:�@z�c�:��/y#��S�ڶ�3C�.�Fs��ި&GD�F!�t�c˚�?/�S}N7=��tC�N��Zv9"s�Q���r��.���r}n�('6ew�c�LtT*����ϕx#!�2?�������K�Fa��3m�AL�GɄ~���g��$��j�>x�h�xx<����%zy�>�ҟ/�/����~Y�����b-��������j���<�s����u����XݳX����j�P=F꾕J�1x}Q?�/��u��}�-_�3�QS,��j�<���Qx��z6���_��6ڼ$�r�dE��V%��V)����!-'M�*l�v}��.���kaM��Z�AH��F\�0��֞:�h'��o�I����"N��<��^�
�@�͑4J��)��E~+��bO��>.�?�����W�?W���+�/Za��.�Y������:N�Y��7�x����A�g���A}�	N�?�����:*ug�T��3�oa S  ��g���g�z�W�g����U��yƳ��Y=OT�~���i�K���6@c!��h!%��IN�����4h��%Pk�i2M��Ȱ�l�bk5D��<�L��b��->����}: ��jU!>��ծ�@ �D��Nc`3]�o�����8����Vf��6->�W�_Q���F}�?�j�]�W�ք�{Cua��U���^�!��h,��݇��JVv?}r��w���%0:&��p�)Fꛕ����G��qqP�^g`��w�ǔ�i�v�d�!Ң�ʽ2([5��6Ph��cu����/T,@�r��r�kgb�l\^������5G��	5P.�!)���5m���[�ifZS[�}���s�V�7�2-�Hm�"��(���{���d�"��0���"N���W���R���f����}���XQ�R�3���+S�T�R*�WẊFU`�'�~�}ݾ����HU��L���<��$�U������q6}Y���r�����5�I�Wsy�hW?��w��K�
�uX:ۨ��@}󲈵�U*�Q���V�鋺��k���\��_�|+.��U�ϼ����r���+� �5A������͏M@�Ѷ7H%�l�ƋVL�a�STm5�葖�~��>�hA�2��o)5ew�����@b]Hs�@�HR=4*R�����(5����c?~Kv]�Q"[ �L�1T�)� � �@��h�C/[�;@�+m�BB�(p��]i�q��h=���`o�W��F�F�+�l�0�G8�%�D�S&Ңn@�\[���#�
0���n�$���Z+��-k�"'Z���܉^�dn���;�W�Dw^b��ڪ�h�%�2��z�b�X��d�~z�p�;L�}�o�O�q�S����K���><&�A���dw8��nwz�c�ۿ.��Λ��u]?���z��*<�����;n��u���Z�n�>���Wbw^xTW����#
�}Go)��c��D�h����?�0>F�(܇Z��pLd�S�H���WI��>����x3_��K��1���~���T��Ww+��8���0u�}	5���>Xi6�¯���Jk��^�Zi���h�%�믕��J������7�AxJ      '      x�t}Wӫ������r��
�A
酐yg2��{����g�$���9ٷ�bK�/]�p�0�������/�0��?N�ߙ��L��+���߅��B��T�ݔ����m��m�����0�߱��X��(�.�%
{���(��^��WH{��^!�%
{���(��^��WH{��^S�K���^��ה�R�����*�5��Ta�)��
{Mi/U�kJ{��^S�K���^��ג�2�����)쵤�La�%�e
{-i/S�kI{��^K���Z�^��ג�2�����+쵥�\a�-��
{mi/W�kK{��^[�����^��ז�r�����+쵥�\a�-�
{�!
��!-
��!M
��!m
��!�
��!�
��!�
��!�
��!
ñ!-7U�ci���K�M��XZn�,��M��±��\b86U�KǦ�r���TY.a�*�%�cKe�rl�,�H�-��ʱ��\b9�T�K0ǖ�r���RY.�[*�%�cKe�tl�,���m��ұ��\b:�U�KPǶ�r���VY.a�*�%�c[e�vl�,�Ȏm��ڱ��\b;1T�Kp'��r���PY.�*�%�Ce�xb�,�O��≡�\b<1T�K�'��r���,�0O��r���,�@OT����X@=Q�2�z��e �DE� 퉊��5�'*n�OT� ��� >Q�3 |��g �DE� �����E�'*��OT$ ��X >Q�4 |��i �DE� �����U�'*��NT�p��X�:Q�2�u��e��DE� ׉���5\'*n�NT�p����:Q�3�u��g��DE� ׉���E\'*��NT$p��X�:Q�4�u��i��DE� ׉���U\'*��NTTp����:QQ5�u��j��DE� ׉���U\'*��NTTp����:QQ5�u��j��DE� ׉���U\'*��NTTp����:QQ5�u��j��DE� ׉���U\'*��NTTp����:QQ5�u��j��DE� ׉���U\'*��NTTp����:QQ5�u��jDR5��j �DE� 𩊪�SU��*��OUT ��� >UQ5 |��j �TE� 𩊪�SU��*��OUT ��� >UQ5 |��j �TE� 𩊪�SU��*��OUT ��� >UQ5 |��j �TE� 𩊪�SU��*��OUT ��� >UQ5 |��j �TE� 𩊪�SU��*��OUT ��� >U�� ���S���*�OU ��8 >Uq8 |��p �T�� ���S���*�OU ��8 >Uq8 |��p �T�� ���S���*�OU ��8 >Uq8 |��p �T�� ���S���*�OU ��8 >Uq8 |��p �T�� ���S���*�OU ��8 >Uq8 |��p �T�� ���S���*�OU ��8 >Uq8 |��p �T�� ���S���*�OU ��8 >Uq8 |��p �T�� ���S���*�OU ��8 >Uq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3��g*��T ��8 >Sq8 |��p �L�� ���3���*��U ��8 >Wq8 |��p �\�� ���s���*��U ��8 >Wq8 |��p �\�� ���s���*��U ��8 >Wq8 |��p �\�� ���s���*��U ��8 >Wq8 |��p �\�� ���s���*��U ��8 >Wq8 |��p �\�� ���s���*��U ��8 >Wq8 |��p �\�� ���s���*��U ��8 >Wq8 |��p �\�� ���s���*��U ��8 >Wq8 |��p �\E� 𹊪�sU��*���UT ��� >WQ5 |��j �\E� 𹊪�sU��*���UT ��� >WQ5 |��j �\E� 𹊪�sU��*���UT ��� >WQ5 |��j �\E� 𹊪�sU��*���UT ��� >WQ5 |��j �\E� 𹊪�sU��*���UT ��� �PQ5 |��j �BE� �����U�*��/TT _�� �PQ5 |��j �BE� �����U��G$��3����i��	�B�؁|�|�@�P>x _�� �PQ5 |��j\r8��j�	���A&*��@��d��j�	���A&*��@��d��j�	���A&*��@��d��j�	���A&*��@��d��j�	���A&*��@��d��j�	���A&*��@��d��j�	���A&*��@��d��j�	���A&*��@��d��j�	���A&*��@��d��j�	����L T�6�B�� ��L T2�Pq8�B�� ��L T2�Pq8�B�� ��L T2�Pq8�B�� ��L T2�Pq8�B�� ��L T2�Pq8�B�� ��L T2�Pq8�B�� ��L T2�Pq8�B�� ��L T2�Pq8�B�� ��L T2�Pq8�B�� ��L`�8dS�� �*��Tq8����A&0U2���p�	L��L`�8dS�� �*��Tq8����A&0U2���p�	L��L`�8dS�� �*��Tq8����Q�	L��2���Ge&0���L`*� ���T>B*3��~�TZ�|�TfS�����1R�	L��L`�8dS�� �*��Tq8����A&0U2���p�	L��L`�8dS�� �*��Tq8����A&0U2���p�	L��L`�8dS�� �*�/�O��i�6�e�;�ٰ��Q<��`,��p�D�����	r�u��i��;t������pZ����	��v�ۖ+N��a�wVF��l���޾�g#V8����	Oh'tHR�/�z��җ����j㺛��Ф�%g;�7�-l�[���gtد�����n��^� 5��:���?{����O�'�rĽ��9�M4��[���e� :-c��7z�	�Ѫ]<�l+F2Z}�X;dߞV"����,״����p�ʷ�t]�s٨=O�����C���҅���B��kte��y�t��j��LP�,	����"�-w[��oT��ti2��@:�=#tC�T1��v[du�tjZL�;�\���i�����¿��1�I&M���3ZC�'��9��j=���<�&������.Y=�^���ޜ4w�p�?n�?�sͺԞWsuU��r܉hZ�%U��y6^�C�q�٠����J<�t�	+=B��S�O�F�e�Axn�p�{��(�V��޻��K�.��/Of��k��c��h����$B��O��.��=A�V�P��ӬR�.���윕�(�gasÛ񬓚��6�������j�؉
��٢Wu�1���|����tl�B�C����4HD���� �u.����p\ĵ�$v�F��T|ڴ��ԶwE��z��T��>;�Dݪ�ܲk�Qӹ \q-�    ���ۤR"�n&�Ӥn����Q�h.�ēJ>)�<�;#T\�Vn�_��S�:<��G������^��Y�^R���}uj����V3F�Ǳuq\��ѱ�:�UMDOC\�魲\C��{�	%;���잃F=���x�_{�D����!�rOQ��.8�E�Nß�z�q�q'��т�R�v��Ѻ�*��xpO9�����s�v����Q���-+;�o(�6ε�jUj����v����Tb	%�����UF�°�aV�'�rŸnzގ��g7�����R"�bo�d�C��ʣ۱ec�8��J��HN��rF��K,�/ �zP����M�PnY����o�_T�6��?O���'i�)Y�g(oDW�Ѿ[A��>^�-/2ZP,~Z
��)	�)���'��iP�Űvڣ�6�گp���d"���}�����Jf�璯��U�/�� N"�����CsQ_7Q�n/:ONb��r���j��֣\k��v��9X�3scFr�E76J���Qe����o�Uz �tee��ϣh�N��Ս�e�4ف;�`��%��⮆�r��W|�y�l��#��,4>�����y+�M��~����Π�G���?u�[�v`/�������Ƃ_��N+���u����^?h��̨�RcI��>��ƪ[/!�1�V$�2�����y.����y�l�Q���}���e|�K�,[w�k�P��������bb)��w��tQ7���/\��<��C�{H� �x�}�6^ѯl'���C���>�NO۬Er?[�MV�k�U�f�wm�Jcjľ����WI�1뻍
��b�s�UKg�ts����;g��{���w!����R;�U�j���]���������BY�[�kr��#�Z�6� ob�U���eRƿ�]��юO���>��(�Gc��XY-K.����Zުn�9D>�-�Ű�m�N��c���3w�������3e<e�>+͞R��ЪA�b�&(7�DY�vP�焜�Oe�����tn[��%Z���4��Ė*q�ͅ�"-�z-��V3wݧ��$K֮U"��l?�V�h5E���X<��f��	�)��n�vp���v�<��UXr��'�빻�!�����+��*\�����{�7}2v�����ݭy\��92���2kY����b��u����C�\A���E9�%���'��t�2B�x�]aW\ث�\Z�k��4׊;8�Ok��Ct�RVi֧�2)�o&�����gn�6�6���Ǽ�l��%0e�R��C�ӍOS,Sz�~-��e��u;���vw\���J#��֧���?�\�O,-���?ͮ��2kY��VF(��t�����n��֧�������2B�OK��*=�9�H�Uf����:<�y��'����s��ܚ��JI�~NA2?)��h�<��t�E���9�'M.?��X7���h����F~�M�-׈��:���!�^��;��~���м�ҿ+�YVX���K�*7���]�{,��r������V'��`}΅�?(#��Q�i�'�<�.��[�S�����hvI��6w�.l�Ҹb����-N�nп���Nd������M�Z�*	��v�C�x��G�B�"z�E��O���`Q����L�<:�ӽXf�J2֏ఋ��j5By�Z�eLR�b%U~���^�{GT����)?�i�d�K����9A3j����tM�$�qp�zS����j�C���AZ%�_��7,n<����h|��~���U�-��^�S�FO�5*����W��[Fr�&�Ǎ�~z���i�/��9���?���y�]T̗lR�jz��ꏰ��\�h��*7��yP3�*���].�΍˥�����*�F4��X���[���@�Zظ���I��e�,t�h��i��~�2?�]�G�����`�ר0t�ו�Jb�GbT�Ѿ��TQu�8�ݰpK�$V�v�+�t	�O��pY�gNږ��:xU�qM��Z�G5sЂ7B&U�?
�#��U_o��&��dr���ɜ��J�i�s?$#L�����N^e_9�����2��)���=�փ���%v(�Ն�Dl�����%�~���� -R�1B�⣳v=�fp���8�`�泎�i#��rcc��%�E$�o���s���o9��hv���xArB�s�%-�49�h�6qeКķ�h�;\Ȗ�����>��N����Vr&��D3���h��%�5rÛ���+ڭ&��Z|��@�#A�����qƃ8��X�0x=��9;�o��]ڄm�1�.z����r�#2�}����D���ʫN�F���9y���c%��\�I�`����NF(�Vh$`Khh�Ed��4���+[�m�^�9��t�y�4SY��$�瑍φ���Y寲�|��K� [?��碜{=N�B�B����n���p�s9(=sɦ����P���PF(W���Yc�����E0u~���2u~�rLqJm}.���R[�n_F(=d�<$��e�<$��e�<$��e�<$��e�<���!4�+���
�����Ԩ:�Ѐ���?�+���ᶒ�n���86�D���n��dv�\	�|�~p'�Yw���������P�D���}�������PtC1<T�w�f�z^�!mC��$t؆���G5w>�6���q;.�ZBj�R��|����,Y�ۆ�Z�h�����G(7���f�m�+����jT��ń�;�h��^@���'����v��=��܎qq��g�i��hd��0��:���+	�v�wɺ)� 7��ͯNwX�EXeC�2߮F�񫝩'%,ؘ��������GȺ�k�Z^כ��鵽�빴��9E�*�u�s�HO��T�-g���}]��`�F��8VB�;lF͍;�\8TZ��8��P	�-�]�)lʸu:]�qRE� �i��U�޸4������w�5�$�L"��i�}�����xN>[6p�՘.j�����1x�ho��lY	}��l�[quvI	��jw�o�8�)+�k7�]���7��gc�'�4�N0� z���桶�'ik�����65�@^���9,��hґ�j��wt��5;q������g�����ƛ?636����U^����`�����7�ŴJ2`7�M�rr��,@��D���&�&���D�_���ֻ�^�E�*Լ�������Ѽ֞�<9Ac��s��?�0=o3���8�}Q��P۝�t�������+�>v.�;:������:�X��r��>�NoA�6�!�l ˒��m`�Hd��X�\|�Yо�;�Zr�d���|�\W�2~^�^����ejz���P��k�yح:l09=���6D#K��v͸��ʑq�F���ܒ�uX�v�m9.$���u=^:)��%E��l3pȠ\���88PyK�}t3���N""1R�[t��V���BBqv��R�&:j�h������~�O��ʫ�6���q��[����Yͯ]d6�+�7���eR�voa�ڑ���A�I,u'�k/s|o%�@��5*�h�q�v���b̍C@R�K��W�=<���[ȋk��^�%i�-t%ɎMyb��$�M�=��n�Y/?HO�N��{?Y������h�Wnn�����%���;��A�������Ҷ�G��m6>V�k#v���c��r��nmz4�θO�̈́��;ϝ4dq����w
���/����y���K�2:�\����% 1w}l������-�k�}.���K쵒���O�K�B�[�ֿTo���JBg3�;��VnϮ]~A�~�u�u��-�1r�mn�$����=��"w��(#���؆��?ؽw�]�mk�ʉM���E"�s�m8�WU�9G�>��0�f�趁�(8��_>Qgj[K��{d�I4ς���N�(�Ct�ϜVkloǐ ���� +1x�B�t��tx��چ`i/�G-�>��%���X����0������d	V8�I�5̥�\�q�L�q���\scc�\�V��2A�>���n���7hEܸ�<d����7:g�y�g�:h(j?G�{��e�m"�(��H��ɬgޭ#�Q\\5IV+�����]�go�#�0�M6��(����V�1{ō�lZ[E��:���ҥn=�q�2�TQ�o|iW�I:�)    ;�[�5�'4��{����*8��{��1��ZCTx·�8�0�B�*�b{�r%V�����o�i�$j<���5���ZnY�e��KS*C�4��������n�g�m*^��^���g�;������PT8Ǘ�_;s�n'�,vyݞ�]��Bn�n��oR��	W6����M�<��nw�n��%Yi�4@9VӨ�/��ʵ�o�H;��7>��W�n��]��ɝ��sX���<:n{x;ʴrߎ��qa�O�#3��jJ��S/�=���=E�����B���m&���#7Q���m�i������X��w�a�nw����-o�}ƙ�]�`p�a�f��(w�-��>�S��ض����rz�V�;1C�~cR�b�(�}{Cܮ�᠇��J^F!=�������ӽ����r�X���rv��\���B-��\����@"=�Q��-BV�X�Y��UZ%V>���]���C�V}��&O�X)������{��F�K��o�R�� çnVK�I97E��%_|��gZ%��~�&�}��-��6m�wE!�i��q��-��1����D�[��m���k���b?�[��9���ezH{���>��Ydh�ٗ�� �Dru�^��|i���e^��h����>I�֙��њ���q~��2yd����	��������)Ҷu	�L,�|Z.��9*�:N�����U�a�uI>[����O��z�.ܗˠpFQ�{��A�ێ���y6�UF�m%晿��3vQ����vW��%n��*�^�ެk�������h�K.��|����Zf��`����6� b��jy����k������K����w*��W�n
:l�\�/Ȯ9|z��5�m�}�i������BoHJ5[��"��`K6����^�� ����r��q_�&.��p��>/uo�(�c���;':��H���A�V��Cދi��uޭ��)|��� �/!Xsa�N6��B��՞���NH�s�NW��N�O(X$��7r��=�忰�3��dO*,U{��m�{Insx�l�#��J��b޽�bT�Ffsڴ�*��Xs�`�W�9S ��R[#�/2��G3RX�Z�^�-|�� ���/5Ds�`�O�� �QJ�N
�":_���|�� ?�xa��~/�%��ߛyI)���`R
��T'_Q����(�I�WT���KzI)��Z:)���|_y4>ϡf���h|��e����E���~�����ݵ��&�b�-��6���I��}&Ś�����w*1|�����&�(�5)�-5|,���G$�4�d��ukߍ4>��*��>/Ɋ�3�v7��q�啁��+�]&��1K$�nl�x��U�B�Ke��Ζ'3W��ܒ䬙_�Zl��)&k�����ß�&���y���-�?��a�o�57�˿=є��$~-w�D�`�O|���.��uy����F�F��i�&�Vuj��W�!c���y{�Y0���!���4>=٬bEh�>�i�rç6S��O0+�h�^�ۡ�����F{�r|�Ӱ�_%z��m�����k�+ͲNH�X>�>�{�\�ڨ��~y4�V�����(���1"���}�;�L��'A��60Vo�yP�W�.��^c2˪�D{FL�5�us����y�'��ޣ�,x���&ڮ���ٷ')��gˍ�z�kEϥ5|�P��<��s�
����;XC�����?>�^>�u���WݻPe>&%��Lڬ�ꊴQvJ��	yL�v�~i������VJ��i�|����vh��KOz������a�U�оyB������<#cO�$G��]�y;�_��+�v�U�ɝnO�����}���5�^�Jzz<�R+������6�ٴ���5/���Z�I�g7���9w�խ�`���a�ʅ�\|������h_�iJE$}M���lo�|���K��(��*� ���������7��K��١�~�Z_/���j��:�t+�����W���c��� }z+�e(��5�Σ��w��t<w;��?�jG�W��v鑬�J���f�c��;��OV)�DI>"��uW��_rT���ܺ�^>E���ȫ�o���D~n=��Vǌ=��xT�/dht�ܪxD�C�p�4v����!���٠�h=�f��:�����J�����j�1��v�I�*�����n��1D��7L��Jܠ��P/c�����q�uT\@���v�`�D�ܠ�Ɔ6��ਞ+7F�F}Ŭ>z�A�U|.�������
#�7�U֏���? ���Qa�M�u�s�P�:Yo/h.�?3�-���$BיQd���8]Ij!�F��pOO����B�7�v4����H���1w͆�rh�j��y��6KL�ݕҲ����Q�HϦ�6��Pm6_����M+�$�br,l��p/4���:[J$���K�#�lDcޚ#�woA�u�Y��]�Q��t�W�л	}�Aq<�if�Pc��\Pcm�	%1|e�c6�Y��XF~�n!kT�w���U�X�T��$�B����}��}��%CE��.f��}����X���08��MgЛ�B�W�M	����EW�����:~<m��>��]\ƥ��d�T%4�j��8ֻ�:c?�����~?Brn`���[u2���OQn�����n&i��-��oz+�S��U%B���n��2�-`�c�t{CM���
�~0f�K�R�4׀��i.c�_�1��wy7�1���oLƘk��Ac����2���J��0�Z�Aݏ��kP�c�����k�u?�Z�Aݏ��kP�c����Xh�u?�]�b��J�����R���t������3�P���B�5^Z�A�u��p���j��0�]Ηb��z���t�ߨ����t�������/��5�E�7�b�����V�?��3K��Ҵt��fiz�R^�]��0|��8��Cيql�~t~�?`�c����8V���*��ӭ���,�vc�M�8Q�ɱ����0=>�i�,��-��X�l߮R(�j�\ j�w���V��/��B�ڔc/�ܾvY_���B7�Ȍ��mBq�7��Vy��=�O�|nH.�)Q߇&��m�K����(o6��HB�T{�g|z>uۨڙ����1N�/Q��f3|^o^xlD#T���� ˎ�1t<�W:X|�Xǅ�_ny���}1^�ի�g!*��!{h7V�h"
W������=���V��{�!���`X��Ѱ���r;??���_����в��b��Z,6&Z�GaE��Bv��ձY+8�^��!�V�Vu�h<i����ew���ЄV�0)m��d+K���y4���H�`���>9�����i���-������n�j�z3Ijs�uv��L��D��?�_(�l؜����ż:�b��(���Ά�k��D+& �5�!I����`~[�G�g��z�.u�0j�u��M�}����W��Ԟ��:�Xgoq�2'S��o5]�r�L��2���aqrm���Bo�Q�>����izPHuRMw� �N�ug*��XWC��b�y�;�I��H��Xs&�Nu��h3���6�2)�4�s�k��y����p`�����hcP�؜���ʺ΋�� 󝂤X��I��w]x(�Z���`�)�b x�mp��-�:oKK����tJ�o�F��l�蔯[��rZo�.Y�$^6+����It�,ЫS�x��L�>L��j���X����&T�G��&T���;�j�+քi�+�Ȅ�+ll)�.�4��(�)��`���n�bvP!�U��u2K@`�R���{��~a?<=:�I�s^Cw��w��(sO��۟o�kuy�ԗ�Ea�<=7/�@1�.��w:�n��J`�hθ��1�N�wv�������q��@[�{�K�_�����: ����ϳhW����j���=檩@���NR�.u:�:��&�: ��!�: ��#�:D�YI���2��|��$ �`��_���V�o8��B֔kӏ�7�� �=�I���v�@}O�n�����?�=�T�1��D{K��'��X�mR��{�mR��{�mr��.,@�    �b݅�QR�������*�QR������z�{bj��=�=���QR������]�%#\�7��'������^�p3��MX��܊�Q�C��j��j��.�s��&�AOx�*Nr�(���{Q�X(��$1��
(����w���_t���q��Ν��&�S~���2/�x'?����g˼F�u���Ц�Y��b+s����vU�=A,���(��U�V��{���Q��ZB����}�1|��q�;�g�]�f�\�X���0b����������m��Z_L+�3�%y�Z���7����.
�3����Oas�l�D��ᣉ\:ލ�B\��,�	TK{!'ȟ�����.����p��v��0;����� ����jh��k�ԆT���wN�b-@]J�v�B]J�vwAÀj�&�	R�]D([)��h�P���wN�b��O �s���.���^;����l[?^fgE��uwBߩD��	J=J�+	u$%Z��+ִ�"ս񝈤�[�<6-	~�aU&Ӧ�ù��bo<�z�%��R-ӂB�R�F�B�~�t_�Y����B�2�C ��v��P�L�P(R��|(�(ӺzS�i#�ʴ^�ڎ2�נ��L�P�Q���v�k���Z�AmG�����zrPeH��'�[�5��߄E�u�1@-�Xw1H���@�u�
�*t�;@})�y�]�u^p�b�i��k��Z�A�B�.� ܥX�5�J���P w)�u �1՞a�K�� �.�Z�AUBMm�AUBM��b����jϰ �X�C�(I�6֠*��3,
U	՞aA��b]��R��5p7fDG� ;I�O��T��B��>/����<^�,_��$��1
��tx�,'�c�դ��Nj���k�Ӻ�����'��<��NwRO�JP�PK�o�`iW	�jkW	�jk
jkW	�j�$=)�z�:�	ȉR�C'��*R���{t�Ǯ���.h�����;�u����=�����+y�������P���̤Q�o��Ͱ��P4���y^��ى��D�{��7{�S����|[�T��&��O��"�>�+��߼������|�s�h�����������a�l���0����{����f�n���z�F�þ�Z�+�z�h�W��F=�2�Η��m2�X��K�g��6��ʹm `R�B�2mi,@��[Z�Ц%h0C�u��g�`��cڒ	X fڒ	X�k�1��i	�1��i	�1�{����X���O����ڭ���P.���&�I��ֲ&����`Ɍ}�2�MkM����k�Z�	��|�l F!���Wc׋G�w�]t�S�3��!�\0��u�ۯ��e{S��nx���a3�-�7C������?�י}x�%�گ� Hw���H5�ZAɾM�ɪd�kmԝ�8�w��w+{pIC:M�����}Ei���R���蘟��2�z
�����PH���B!źǫ�PH�6��cTEP�1��"���:����Z���;u}-H�R��p@��b��P�1�ݏP�1ݻ��\��n�B�i�Ճ,��l��ښ*5��miF�uw�h��XSä-^���r\A�s�L��k;�L�A�Gu��F�u΄T#�:gB��b�3!�H�Ι�j�X�ΐj�XW�@��L[�A��b]J�T#�:_C��b]}�F�u�� �H��R�T#źJR���Y�:��<�}#����*A�7��NP�dHHP�G?�>�{�bx�#��~�����+&� ti3S�P2�aK\r���ǈ]u��r6quY&_w%����i�\[.ۓ�bh�<O�Zڜc�鱶��]Ц��M!���h�
R����4�x�^k[&�U�YX�*��*U�}S�4��,v�Y��{�N����B�F[�Bړbm�@	˴�4���b���X�۠�e��*�+)�!�k)��6(E������+����&�}��_�X�5()�������zJJfi�%%��^����Z�AI�l�נ�d��kP32[�58�b��kP�1[��{km���d��Z�����5��Nl�X�5�����TP��z*(nh�7�^�
�Z�A��נ��6B��נ��X�5��8�z-���"ƫ�Xw�];v�셷I�#�U�_�A����p�G3�ީy��cA�ŵGT���XW�BV�b]�
YY�uU꿬���W�J���nf��^ǰh�Fn�mr�K��S��[y�t8Z,f�:�����i�����։ǹ�<�c%u:���	^��U�sZ.�g��D;ֆ��^"�F4�+��/h�q��/hZq�)h%q�݈�x�D����D�Ӡ"�D�Ӡ�������Æ��`������j��_vyPQp/p�����9��*2N�����S����7G�U����#ȡ�lhmf�ϼr��]�~v�Fi�?�GaP��Q�?s����ա��3��m/_9��2�]���eճ��X�J�u�9Qo/�OI�Ĥ6Xe�ղߞ��GcTZϯG�X�O�lO£��g^���_���^s�j^n����1Z/�m�'�uP�qf|�_��X��z-g��5�D������זΛ�1+8v>
躦e?�#����2"���t]�N�� �:�7X4�B��{�o���,{+���'��{\K~e��'��e�y+W}�����o<й���xd�b�N�r<] �ē���Ɉ���Q`�=b�c噷V:I@#��@��Q���(�G��#�8�2&@�z�g�<��n�5^U�t�E�A7ȼ������ �K�>���p��5/:��s��j�zi��� �K��H�7N�O{..����Etm��Z���z�����H�Px�-���c��>��n�} �g'�z�Z.��F������暡���P=�3��!	���6�T���_���x�j�8��Ʀ��G��klj�j�A�a�>�AY�{�h����q��\�
�@p|_^3��qat6q�RBN�pΥm�����{)x~�ٍZ��+�J=z��y<������ᾱ߷/��ҽ�n�꼮���B1Mm� ҽkC��Fw��^�u��t/�_S������9t^���z���e�w���k��H�6T累l���~���-��EQ�����0���U��
F���س�3����0���6̍[�������v��UΙ���s?�Ϋ�ƥ��h�.���X˼���b���� #�_H����o7�J�Fij�j���B�_|�����u4�;q�~G/�w]n�+��A���$6�;�ي�n���ܱBq����h�׾��B�R}�v[�Iu��FQQeģ�M~Cws�����*�֝*���n�,������Xׂ�%]�]�a���+����Q�v����Rx�7�O�V�a����
����/KY�B�߷4j��Y��U��A7B��M��}?:`���7�/�ᵝo��Ct������]f"z�{�v>���F�~Z7ST ��\�J����	���qnN��yؤ�o�:Ѯ$3�s���4���Y��󎅓�[��u^�^��q2:�f�r�`O��y��U�`#{�p[��s#>3y��p�w��%�W{�_s�h0�+� �,\�>�,�D��ǵ%��a��;sF��3mԠB�D d�b����?c�
���)]4�������]������}�k��\lM�@&����0�Y
�D����@���ߍ�3��u6�YK�B��G�&��=q'`������o�"Z���U^�R�o�:� ��b߭�Vg�e�N����hetDR'2�(��i�C�~]^�qv�Hmc�'^�1�7��r�Yn��*�Y�:�T�?��?z+gP	;����r��oc���I<Q>?,����mu�����X�i7�� p�լ+ߝ��tB�����C2:	wX�a��ݺny��Uq�r�p��1 ~�o̚�Q�]�Ft--�h���(�N����"�����"�t-�bH���eF����A�jC���^��և^W:��=@��V�\KA���"�Ϙg~�-ߍu�s����G�B��,��:�����e �{�d~='�X�������Zu�Ln����>��2��.DV ��z:B��&`1R�E6���    (��m/��k�@��Ћ*�<���^&��'����f�8�C�Emj��xq?t�Zojl�����G��������W1�r�I�����Q�����U�,��k�C�
S����ě�&�>��v� �K1�����&�W���~�ڻw��H��"~�P�w(�~��	���׆���0��g��
瓿��o~��������Xo�+��r����=^Χ+�����=�#A�{:=Bے��b}Y�ж� J�X�Y�A�l\X�I4���Z�u{+/�ÚS���E�u[����')��!`�Rl~��`y�/��
Z��?X��=��ۍ��1j;nc���`�D�n�ynֱ���o.j��}Ï۹~���f�}g����*瘷�|�NP��?{˪�|/FE�j���C��et����\PL`�����]��h��=���N��U�ed?.������ڒ�co����.�fB�ij��lB�hjo��+�`!+�9��˳บ	����ؙ�S`��Z\�d"�4�z9?0k������4z��yJ��4��9H����Նa�[-�D7�.�N���μ��)�'�<�nm���^��t;Ș�!�uIS L�X�*���7�:�_�u7��r���n�J�g��#���T(�Z$H|�sY����jv1d�V���� K	l�u��Ҡ9r�}u���N�Êo�F�p�_�uMZ5�LdtpZg?�¹��N4da�?�萤�$,�n��y�A���F���I� @�D�'�$'=�ti��{oQ����I�.�컜D�s��t8�����-���q�b%<N�$��tv9���0	�n�����%��$�2�ݑ��?:W�f������f��2�;��Nen��I����������|����R���(�(���qk���VZ�N�,��e?�7�qjm��n%��x��{��XO�nk�$��O��x)8�0�爐�����o^ܢ���7t����g�~f�'�+�tj��j�L�ړ�F,=�w8i!��ADw Im3����B﮹N����{�֩TiО��#a��ʡ�J��M���W!�i�A�b-�F����!K�6�@_Ah��'���^LpEh/�A�b��@�fR��0iI�uw*!�K��N%d')�zn�S�d�)�u�!�H�6D��ڦ)@%�N�~�O^�7��n;�Ƒb�mg�8R���,�={K��x7�-���}V�S���Z�>�/��<�S�����>�/�m9[�w{��z��Ұ�n��Z��[ڇ�ŻW�}(_�{��w�w��tb���
LC�5����k�+0�נW`j߯;@��n�k��U� �Z��5��z�vS�� �R����h� �Z���{S��5�R��<$ab�[��7�֩PךD�K �Ǿjm��w���ϵ��A$H����W�h�.(SM��9D��|��M�3 	R���	R���;�� � ź� ź� ź� �:�� +Y݁*U�ut�M)֑>��X�58�6�陼�A��^��lS��j��R��58^5��T�(�b������~R	�P�����ɵ�N)M��9�[SKo!
�X��@oM-��(�b�z5�z 
�X�T੦�zx��}�P��?�x��PX=ˮO��.��x4:Z��|f⛃�"~�kÙp犊�r��6�CZ��M�f���04��c��[��]�Mo�ӹq�L����p����gṲ�Q�ޕN�I��*�
Z��u�X}�{M-���<R������I����[5F�>�V�۶�"O/5�Ĺ�t�����=b4<�F����<��4'��~����BsQotܩ��w�T~��΂���]?����W#^~���QxBe�ho�R���3���qƣ���r=�N9��������`����_=�b&Tܵ5��Wބ�"xѮM�����P���v:����<���o��,�OϚ7:G� ��͖ю���J���/V'&����"E�g��j�UpBe�m�z���Fh��t\��l�U~�߽7b���Z�N�UA���Y
n��O�����:�RǍ���e��-w��}����}�Wj-���1���NU��R'���߻�R+�t.�I�Zm\t�t��>�ٻ���ms����t����sԴ�"��W�Y-�f���W�5-o��ō�ᅚ�M�W�c���t�e��x��0�ƀ��3�F�]���x@�,=]���2t�P�X�+&5�a}&U�]n�i}c����bjdo* �K=-������r�=��f�+ad�f�ǣS*^,`P֧�]6V���r�I�4D��f���"��q9�̥����k�=��δ�L��*V!p:�~Vz햞�BMs��l�7��ѣk�rh�_Z����:�N�����n��| $R�q�z�U���V���<�ᾂ��>���+���7��-�d7�H�Y_�E&	VQckf�Y���	���[��JWM���<�C��x��]QJ���d���{��3�4���c��/Ӂ���;*�q�{=W�M.	����iG��6�_W���Ҿ���'C���w��B��)W����@3s�s��}���@�+�ً�&Ա濣�cߤ���j���%f
���~��%zPw���K'7EÍS.��$;�����+t��J�.����+?_�ݱ�v���BAma�����z:d�W�:����?�K�uL��{j��z;][�A�mi[�&T�ђ��k��k�(t�G�A�&:Ֆ��{���(x�h�fͽ���:�c��zΫ3�`�S�	hJhb4�E��h�B��|�i=T�
����� R�s$��������;2��#h3o��.V\[�(���8�v��<=ct�N�?�d�5�l�җ�v��Q�uX���	y�ݣ_�*��8�G��b��[����ژ�r�7h��̫�߳�h�������6�VD�.*N���y*4 ��L�v���=ϨN�Ǣ�(Z2H�&���_`9߇�I����� շ��l�
�����w�Xa�r�/�����}vC	1Y=a��1����V�~	�@��b~��� �HP�[�M�P0��CÓE�������U#�>�L��d�M�5�E=���A��+5�
=X��-	��Xn��٤�|����뺚U�y��̚I/�	��F�ܬ���BH��_�ż�Yސ0�����eI��r$?k�{4Á��A�D�<kڱ����9�3���OX�k�<�g0W�URⴭ�M�/�ظ��څ�S~8<�Z&j��m��:?63C�����Z�O�T��duvfk�N�A���D�Pq��ĝ����x���&Asa~���c=A��kCg�W����uJ��_��֣��F!�X8I4�?�:w����mN�U�Ce�p�kq����7�����| ��}-�@S>�@ax3|��C/=|�j
{�G��>�& ��}-�@g�s_�#���_�k����k��WЄ��
���`���
gp�F�}-o�� �(` <|�>4~�:4���_����*�i�Z�q(wp��������?~�?�G��し�^�
��^���O����#������Wa�ٹU|�'��t$i���JX*�!��M8X��q�
���N��Q�a�f򅾞�	^�/�����i��������6�\W��v��՛�3�4f�.&��k��c����nueC�y�w@틓u�h/�%T�/E����m����6�^�n�Ǽ�=;�'l�m�'�h�$k��8�5�/�Q���/���z�������YN� �b?*v��ͽv*)��l��)V�����㫉��s�!��Coc��?���hh���&��,+��m����b��=�;�
��odC:>��`�}y�#^P�qdo�Y�*�s������/��5v�Hp�}��~a���F��1�%C*�F��t����}{	����h�ϣ��7�!����|�q����6��m��h�>�HiD3p~O��י�������t��<e k���aw�ϹA��;;����>;�L+��X"ϗX���㘷m>*cl�0�͝�����f�23o�*���56����    ������p�4�z5�{��9PFk�i�g��1�;�)��G��x:����o���}�������`lQ?��I�{n4���ҋm���,ȝ�7�9�s��n|�]��=Ո���(����9�2�`,7�h��0�f��ğw����c*>�o2<�_��M���f326����!Z��e�/�%��G���q�q���!�@�!���!n�zg�.4�r{zbn/YR��"������Q�/��D4ʾ�ш��4�n�����%X���MɄ������<Q�Ȣj��n5�=��6��>S��Y˳�5�N���7���M���� d�V�ۺ�4���5�`+�ql}�ԩG�h�w��t��^�>�<�7Jy����w��<h��j7@��ʑU���Ns�=]ٙ�+<�����h��w��d�����x��m<�y��{�qʳ H�� �\ܬe}^�����i�@��TX�	`HL4���<�NSЇ�\���8mu&Y�h�w��������i����<�,fD�s���&�������Ѽ��\]Rw� �n�ҏV���HO�w=�[�y�Q��1@�~�v���ػ��~X������ⅻ�h��@�"���A?+A���:e����w=xV�I|>3��AI>�Ņ�>�9���A����l_,�p�&ϳ�K�h����櫫 Qx��G<�7��aD��/]��Yc�5����2�y׃�)�'=���M&�q��.����|��Vw�\��$�]�>7����	�xHLQ�G��:r�Ks<�wǬn"�?���4�TYw���ozp`	����E
�<x3�X#�7=8pw5c�#K��;p.�V[cD�!U��s^����G��v#�7=8,��Ⱔ����U��������ozpX�9Fz��N��-�3w�|v���7=8��K���_)2������O�M-vW;ƍ���0�j��Ǒ-@�'Q��Ե�F�YEQ+�sR������!�@�-������o�&���?]e���l�f�p��8��(�}n����P����1�#H�������د��P�i�������~����X�E��������A��e����\�C<�L��&���nKn�b��2<�:0}��xN5��ø��_,G,N8�X�r��!x�~l<��lL�J)�����S�?�j?DBq��a3�D������/1����[�������¨�
Ï����CD���ڛ�U�j�L���"��l�1�+���٪�a����:�`��M�:y��CY
)��ߨ��� [���r�����;� 6;N��M�.���lkW��?�L�k#n�yS^,��p�W���f�����z�7D���OÕ�������V�x�_�N�)���]I���~�k�l�<!���]��i����A�pV"����?��a4"���hP�^�W���(�1�����^�Pٱ!�`����ZG��c��V�p٠���l�������[5�������rW&�#� ��.0��=���\�����|�QE��4���.wП���7�����}��ͪ�@�f���/�����k����kTҕ�GSGVO_2��&�O����a2_}4HyT� K��o܊̅!���mH/�q��!���A
Ka'��u�`����n\��_�)����:o�+��
���jOR�~��<�޹��͇#�D�8�τۀ�f�*͖�>f���v`s��U��Y"�B��:��O�CBu��c<��|��P�:ˢ���E��J~	�������	����l�)MBb�8���{�Ϲ�g����k<4��lv\�>d#3�D��5��Pq��;:�ΝHM�q���͊q���,җYc5ZDl�K�V�gK�&�v=�~,�.梼���x�t0|�PF.�&�Q���]��C�,;��ƥ�r�ɉ�A:�Ӌ��Ŋ�l�W��ؤɸ�:��k��."��i����H�����r�����Ga�:���ZZ2+Wގ$��b	ϡ�yϖ�+4v��aoW-t�x5F� �a���&ߝx�(��;�q~��G�ϣ�y��I7����vqo�Ķ;�!��NV�!���f�~E6����x��)1�Gt>�F�=l��&s��OYL�<>���n}F�7k��h�<5������H��5�G��W�:R�� V��>,���L���b���(%X&c#K8�@�*�n��m<�2�#;��*��r�h@ܷ+�Z�����1�ʳ����R�l�<gx8N���q�㭢�\�~��_(\X���:�#{�Mq��-��l�͈�0A�o6�
�.�3���?dҥM�,���r�ױ>�Y�7)��<l��Ĉ�@�ٱ,�*dt5U��Λ렙����s^~\��Q�����J�_9��v^����)^P���4d�t3��y�up��띣���~�]{�Z���������Hr��>��C�|m�w��oH6l陛�r����O2��,l�gag�������U�p��j\�K��c�������)�^WY�="��ɲ���DF�õ��wZ���[Oh��"�z�����k$���_�@�>#7{�扽�c�
� ��`)�V?c���o$�zH8$�s�;�6�0��`�_���Ȇ��#4���IG�+H,��Ό����ˠ:dU��m��J�G�`�m��tPEP���Į_��({G@�]9+��1A�/�Bƺ�=��ju4E����9乗���_2�����,�K���_�������d��gDK��'��m�� �o�<G�_N���B>��Չ�e'`oϢ�Q�X>8�+���9w/%���@��J�\�t�J�B>�k��3�(.(�y�/��3�˰:��׭�p�F�`�b[I0��n�
����A�Q �,"����.@k���d�gDU �o�c�,u�Y�uG�	Ux�%��<S|~��F�S	���=fY��]5~*\��d~�k���4��!t�l��e��-�x[]�M�FO�\�@��/���#ԁ1nO� ��Y��-�n��TFtl�A�����%k6���(����:�����Y&>{N�[�s}�9)n��V��ϒ�⺔�=�&{F���|qKCL��Y_.j
ҷV¸��̛�
�˫ee��ё��j���h(T
m����4 ٰ)�D$ђ	����Ы�(gf�O�6i�V�3`�x/:�eO��fC���M���Ƶ����º�4�( %0�C+H�N�&i9U]�ҁP�|H]F�O@{Bx���"���f@�i��VG%��[�y7:?�̱w�D���#��ilѕ���� p�P�o;�[Ξ��2x��pWM��/�췷�Ù�vzvQ;`Qv]|��}���c/�=|�������V���a2�7�"����W)\^�DFI�r0c;�|������������ˌ��W�P��z����I��Ҁ��6�|O��Q��|��o�==������(W��Na�l����.>1����e)Mc񝲢�S�"U�R�%��4�kA(��|��Oen�*;+�<y���v��q��]��R�HR	p�!���������f�e����k��6��v!��I�|�#ZƏ�V��݃UBt}p[�8�f����F��s����g���_-d�_~Wq����:CZ'�樣p�(�sn���(a_������SHe$f��|a9�g��W��v�Gc��e�O;�Ϧ��+!�9�-���s=1L��}kƟ������+�Z����|��s�޺6�v��qK8BQ�/g-5F�<��ڠS����Ǳ��H)��C��P
��m;�j��S��R����^���Ic:�!:�C%{��f'��T~��b�D�MCE�Z���J��w�N��j��4��:8�o���\'��_= �J~uU,T7���8��S�����ލ�h�t̋+z��C�P��z���/�-��>{�t�����N����%.��B*\O<��1	��
y�ѴqScu�,RЇ^��Z:���/��,�Oq�u3��ϭl4!    [|U7l�٨{�U��(B��Y��ؗnN?������c��P�A�ܒ��qRA�穑�{��q`5E�TA�b�:�묽�Ě�9��'�-��҉v��/�}�8
�v1Fv�-&ܹy�ŀdب1��Ɇ�d(ڡ	F{g����6F'nv�}X�O�B��E;c�A��f��D$�$�
�~RJ��}1Eqň���N�14��u�1q��Ɠ����7�ҬH�'%1�-)��n��SPO�M��"��pp�]�_03���H|�8�pT;c��f�X�F	��Mv�GK�z���ZT���]�js��x�F�+E~���pT ��#��#-t�U���Rko�;�\)Trc'��b�dH���u6��GÄp�o����pAP=�YdQ��506X��;���hL���E��A)o�i���8�i��훃������.1����O ��xm�k�c��vD�����ߙ̴+@�p�O{���
m�����k3kT�wծ<��.��|,L�*������~�*�o�b��2&������W�����h�s?u��2k����yM�����G�v�����+r�͊����O�Z��գOk�\������8*�1:�/{���dH��W6�GLq���N��g��X���-��E0w+��f��+�2�Y�(��;/3����z��@抬o1����z��g� ��8���A^���w��h��|��]��oӭ,��)����]L�dN!�7�s�Ω�')��0���Ʊ̅~H�����m^iC0�69�0��N�B5\��]r2M���ڀ�1��Ӹ#m�	W��k�:��1.ft�M�T�{'o�y���|�7H�S��7��%��T)��o��X��Y&����=7�J�T[�Y'�Ӆ������Jx#ckq�y�t�fo��/�Wc�Wj%�����9c�����|�<e]b�������o_JC8�0'��☬]\)ZM|~��b>4��x� �B��a�rV&%y��T�lY�귛�m��+��bUW-g /��)��_$hTk�队�uy,�!MIsr���8��y������nW�x����e����k�5��9�@%��u}�/�b���+����?Q�4OyeSsĹo�%08׹���mB��=k6OyC��3T�%�aN����C$���������zO5��^CI�{zb^�NQm����ɲ�[k���Kq�?N��K����D�õ�`J���+����s#��s%���r;�@�R9�>Oо��a��W^�ّ^�D��,�2�s����#迋۪l����Qʌ09���%c��9�*Lq��A(ͪ���n��)T�1�	&�s�#�#^�\b���Nf�ʙ���O+7�cB�_��?��b�e�`��fYiv��!<�#W��A�.�lr��`��+����j]>J�$�>���2��A��/y�:.�w���O��d�1���,���r��w��������Ch�����>�pu����v��6�>���
�vb��8�5o}-}I�?!t�̝	���>53ne/���5�MH]�X�?�W,W����������F5c�Y>���r?#���5�d��:�k(T|��N�h��aŁ�yQ���.�
A�Roh�8)�fց�Kt�El��K�&A�x@^.#_`�1:,����}3�B�G�	
a�R���n�ޖ vT6
��~D���j��}6ow��A;�i))���A�n��?wmB��2 �.�8�}�'xA��b���s{�S>��4��\���ގ�ɸ|��fs��T�Ż�3�9�{Z4��7�����+�ȓ����5C񃌯�q�(7��`�5i��Ψ��$���\��Ep�]r_��G�v�X�� |����,������$Þ�>�D����<`ZJ�z���9PV,b6����G�1:�W
�E2Q�����	�aw�d�u�ݨ�	?&(�e�^w����?�`�c精&��րޅ,�t�҉`v3l���>n����٨��,OϦ�b�Io����>�X�`�Y_���s�x
���Z:���+_�'�omo^�@�w�ǟ�f�UYz�O���x*ryZ���HaBG#�T��]ʯv�lsKA"�l�pF3����螺�K�r�m1Y_�b���j��'�8H�!:�l�H^������V��%�����zpS���]�1C"�Opn-K�V۱����Q_�K�H��)��:��J)��a\���4��d���]E��_����rS&��Q�l��Q��Y慀�ܽ����O�*�2��=/[;��� IK)�ly��vP1R�J�177�1=� <�;Αgc+�o��のS�[��6��M��bg)c��ErrB�l@�k�y���؝˖-�s�Q*z$x��M٭�ZފC�X1��_��1/��~GS��z>w���xZ�e����?u0ר�yv��Ha��F���&:W�Yj@�U������p9-��;�&��׿CZO��	iB[�։��{�LᦟKð:u!4`���ϙ�?�f�� ���|���~y�s�TkVЗ�8D����PU.-��4d�kw�zu`<�}b���>�F�w媐�`���O3��*�ƙ;|��@x�
C��v%��J+A,��`�,&v5X6Coct�.��T7�3���"ayP�t�<�ށ��G@���B�\z��	�@9ީ�XV�4#<(C��˕e�7P���^�}5A���]X#��oz�GCP�^��Wp���Wi��!K'k/H��?��2�_D{�2N�`�@	K?�g_�)i��t��Y���7���M��O��%{������?*����|��2�X?xy��7�]E���>����鵤�:�A��+�H��'�C�h�ݱ�_�#�9� ÄG�%��9QPԿ�څ�%��z[�N��Ԍ�l��5��Y'�����7�-��.ۗ)~�~A P��������H�!��.�)��8ȏA�\/3�rv�7$h��_-o@��h�d��s������up�i�q]����J��8�+q�ͧ͸���(X*u[O������ǅڭ�h��e��.K��J���q}	=�j�<g��)/�Ք\^6�֝},�mUp���A���e�
�	�P.8�˕�0f�&;u�Exna�f�
�Yn���u[1=OҢ�3ǕBX��?�Ύ�lk/QA_��t����8qd��"Y;r(�����7�W��w6�+�OX��[��$��mAt����;�	~���ay�Z�f��*c���*=��	��jC�
�D�v�Jv1u��:�0!hG(�f��=��IX��3��/�
͏�&S:b�s���\`�հ8�B�A�L��jîBv��
������{\�zb~��iv��Ǚ�א�!ʇ�K�O�A�F�JXgc�x��n&m ��TSͯ�	��rAIx[~�AlO�aْ;gÞ5��t
�u��m��#N,�D���f9�~��"�v=!�V��aVԙj�1�	��=��|mwحz��f�����WC��@�٢��<�{i �Cy���C��@Ǫn��8Y�m7`/�����1B�FgbX�i�[�חS9�_��F���`M�3
lp���pk�"�@E,{g���c��:��z��N͈�[���]{�{�'\s����s~��m�����q��3���]��v�"~���a�i�!�>��������'\Tyt����<���V2���O�lb�e�����d5���� ��0~#~�\�����%WZ���T��XqQ��*���P��v��-;�h@'�9}v��:��F��$�ڏ;hZ��j�o0�F�b�����g�3�����p�P�F��8���ӍԞ�[yU�c^�yE����=5� ��7R=n��Y�a��)ߴ>'�M��쐏l���[04/t���4z�x�-�Sw0/��w\<�/X�#P�Nv��Vf�P�IӀ��g�_�N�Bp������i�	1��$@^�.��91Nh^(Sfw�>�	��e�ܳ��������uSfo'��[3g<����v�'�֪t���Ia�8%�	SB�3�0 5��'�;    t��ݥ�m����y`��T�?�	:h?�{ ������\�']y�*���뀐��	e�zv�iW�ő`'���0�����v�,g�|����}K_�O}�gBt�-���v������;���D-�^:K��q�=��:7{$�3�,W����� �-��I�{<��ւ�lBwj����&[���	�n� #v�y�c:x�@[�xN�{����u'w����1?��d+3�mr�k��s�V�+���m����|�>�9=l��:�y��5~��$�ߵ���<%��~ع/,i-?���#��i=�.��I���؃i,!JH�c2lm��/m|�9�Vc�-Q9��K����=�!��R�'2���	:�c���cq�ݜm�m����J&�z!���\I+_��W�����n�� ��^_��6{����cUCC��t~��h^��sҙs���B^��8���@�g�h�.���⦊�f�I�4ٍ�c��}�&�t��aI��^�x 	� ��c�:�+��pD'��bv��I�ᓘ�<�+x�f�I:3��T;y�#HL�����3����vt���D>�dw��L�3\;t�g�ƞ�C����6�E�zj�L���[�I��6/�W����z=0�3A� �q��2���K�	**�ܟ~1N�a8�1�.9�z(�-�Dg��˳���:qR�*�!�������B�y�f�/QK��Ζ��.�(��6�V��3��+�����<\"ޟտwu��#�?T���Z�pM*�"K��5��6�x��J)W�c�)b;�h��~f}/��2�b�y�I����֏p͋�)�~C ar7D��<��f��C�\}���e�^vˉ%���J����R����ԁ����_��ĒB�C@&�GC�,r"U�`|u�5{ߎ �}�I�|p���Y~���������GdP]QٗSAvכ�:_w �g������xkDũF��$�1q�ͭ#\�7�0<�E���@u���晻+q�����<�B���j��ǰт�o��Vg���:zg�� !G�D�jKn���<Ԭ#20��!STSi���'��ǵ�._�2����bnA�[����2��ᓎ��MbL�#�S��=oi��R���H��F�������bWH�X"We��L�����'��A���	��E+���o$k5����� �Z<���!$��9�0����1!h�L�ix�X`K��� P� ��f2��J��lt��z�t���?5��҈N����Pl����v9|�Sy'$�����⺳y#����C �D�����	���,��j����$O�OyNRb4wRp���-�Gc��-�\��j������-S"�t�n���<u����IO^����3.��tP�ѩ�A�W�Ö1�%X͝B��!y�A�G�v�~E���4XD˵��~�D`B9��C�ؙu�G�t��v����t�T{tl��-3�1%5��('���w�/����W�_�V�M>9A:>��A�2O�[�Z�X���k���[l��Ft����<�r��E?���Nqz ���{`B9��K�Ka��.?W}��<Ыtbw&_f���m�uO�#��RxlXqb�O��5*��)�[�8E*��p�T#_����@��O�>��`��|��~L���	�0?���>�lK�����nn�Vx�Q=ы�|ۀT��GƘ�ITX᭬���I�ML����`�x`�N"4G0<�ϩü%�5�嚻f��`�����њ�fv۬����}��ǧr���C@� ��0��E��9 �ŗ�~��'�����"�<
$G��7 ��H���0��!����F	Dw�F+KJ��z�B��w�Cr����/���Y��%���c ��LcɆ������t�_�~	�$B�5?��/��������@9��t�ai���*�9�O� ��?DI
��	��.����D�Ϙ"$B��ͦ�	O1�WX�����8��A��D`������}�*�,�q��=�/L&Q�RX��yٮ��&=��{����~���ɂ���g[��������&���ǩ���F�8�\�u�m����V$B*#n7�.�e� ����hL�:�~�~�k�}̔�6]��-�K?�ҡ��?���$��	Y�q�q:�q�mԫz�N,/�|J~�&	����������s��B%F��0t'R�U����ֽ�%��+����?�L}� ���g���7Q֯=K��3����t6�/�����n���y�Y�X�w5�`���������Y(#�K��W0|F~`c�g�q}�H�f��ڞ?!JK"�S0��Ʉ�N���2��/�99!<���_� 0i>#�m��W1��-P&}��I9��5�6l]?#�d���u��?3'���Ƥ����ek������Fn��a�>��/O3�r������/n�c�9iƝ��TY$*,l��}��'��;�Y	�3c�F��;�6�]3K�N{��Qx�h0T�����Pͅ��3���CQ�8!h�������^��a�^D���o�Q7A�!�����q�W�aW3����n��f'�:�H��bK��� �Zt�����C����<�.��<�����\�'�E�.����g�WH�.���d7%���*�i�|��b�i9^�t�q�\�-\u��e&�����Gr�!�@��%�f�Y�Gm{��Z�|�H�����5�Of�ȫ�~tr��󢾯�}~�Pv���,ޝ�~�����3��j�����Cl����::��kQ�NV|y�m��@[Q"�����0���1I�x����jU��o<���e�Wj@};���g�v��=\�.�nA��Ε&����ȷWzf��]%�e�;��(�M�|t����@�,ℙ��R�N�:u�V�&�%��|�D6Zi�;i� �mL�����AKB�����.]���ȭc/�����AKB���Q}�p���<V�Y���V�c������|�;|�SF����H�:�L��!�]Ȥ����RpxP`)������	ʚ���Z�Gƪ,�]�3�E4!h��r<L�+Ϝ!ғ�=F��Q��!��V�0z�#lw'���vV@��˖��k��}��"�R��k� �7o�!��O�@\�D�Х|_zW�h�X�jnT����o���JC�E��_/�p�գ��bċ|�q���j.lF���]�d�nDC��\L�Op���s����X��S���0�omLȷ��"�E�9X�����JiTJd�;�F�'W��
O_�A���S>O��|k�u/���}~�(u�K2�42v�y֤�;��a�4����~u?�A"� h�/�6�y��fO�m8�%Y��g�1�o�o`
B��1�?�C��H��^�=����.��%y�N ��$�U��$����y��\�t{�E���@ӣrR�S >M!`B\��T�Y�+>p��V(���|s�a(nN���-�xv[�$V��1��4̥:щ����S�g O}�0W҄d��!�V$�X�bܝv���?ɨ��+����!��Ԓ4���;�1��+C�٧���m��(>�]����.?���Ϻ�h� 8��I(��˖�����J�K�H�ߟ�i,�T�*U��ad�GC���`g�."&���?��Ȫ���1����$�f2w��|��%`���2�ѿu��yћݝ��'���}��.�1�o4�l{�h�8�@V.Q�^�g#h�����Ux����Jt����O���u/���"�w�Я��|�c9�C�3�����Bcf&Mv<���TU'L[g~�ۑ!�;��yNу����ɢ�u9��7^`r8С�g��Y=��a�{ぼWC�AM��6�7�Ǫ6!���Z����u
4��5RT�s:��j���(�l�6�����[��}����1;:�=�ȷ�ʳ��ΰ��E3n�#�}��Z�Ѽ������M��u�w�*    �]g�K���!�C!@q��.��q������^�}�R� #��.iŁ�����_�"v���
���
+C�Y��,�z��zx<�z�_���O�k�=�u���U�g�"�����%�^���V1[^�<.|�Pw�����b,>Cr�_)њ�Χ>�P�����u��imt�k����S@����������H�QB��ު.CVvVG���"�X��t���*�5�C�Ф�(�~{$qvT%m�en}����_獳��͛����jD�f�(�(Q3
P�$o?�m`^z�AG��n��|H�}�q��5���"R�B�x���O���☗�6��#�/�,�R7
u4�7v��7��de�n�Q�å5�O6o.���B������5��{����?5��#�g]�E�g9����ƽ�T�{b0Yz��?X=��4o:p��2Vd���}pU���O���kg��]��������?'}�2���7I�|��u��ܚ7�ȷ�����7I�vf�RG3<�襍������6�PYav:�Nm�(�p���ݒl�=��
��a�~!��t8��F���)}��T���NO�^�c��j�.�=�{����;�����2I�I�����Y�9���{���ޫ�b��� ^�������,`ɃB��Y��x��w�� d}%���D�WYt�;c뮷2�JP8��c����W����]kI��z=�T���.8:���`P"�43O�&fK�J*}�>}g��O4^��'�,�)ӑN]�����\X[�i��=R�d<k=ת�� b��C,�ɧу�aP)o��	c���UR��L�ӣ�C)/Q�:*�����s]&��M�����`� ɿt���e�b�!\�F
*/�3~�tXNx��-��g�S��h��<	�D��cQꜧ��K��(�gb)n���g51Η!�&W�V��ȳ-�s�%�v�`���T�-�+��ؿ)�������W�IP��4w���Wv�^�r�0���ы�_#��&l���q��5���^mޛhTaU
գ掘�v����]�x��Qw`&���������T�\��T��2�y1n�!́�Gq�[���&g��\�յ��Mٞ�Su��G)ReP���[�_9��Q(�F\V�I�y��v4�ԟ݃ࣉ�ƥ�}���(���thUT����dq�:Qo����Hݜ��G|t��^�w�b��6��P}m�S�G�bk\� �č�^�d�a��?^�L�}ʉI4�W��U�*�j���9� U��z�<w�9J�`��W�b���A_
�����vk	 _�����^F��/���%g������_q��u���j���jK�p��T<[<�|61Nh�������jm��5���r�e;'�Mv�n"�SڥB#8�}SsO�ʭk�u3g�c��P�y���r�����Lp�pI�����v�TjmR��N�E 2�s��/��2�$������,3"L~����G�:&'t��@`�L����HN�'h`���.�L��'u~�H��W��J��:ރ`����8sjR�	l���T�� `L��0���z��ֆ�U⇟h��J��A_�;Ƥwp�h��@�[�z迣G�^	��^���#��r�����Dw%���<��ʕ�
����u�����L��~ܐ&~����W7�j߶`��>2	�X?XB�̘g��/w�� #P"ٿ��	~зP�4��#�`��V������V���C���~�q_K�Q�:�JJ*�'�AA�K1��NH9��UZ7���ݢS�R����Ly#i@�Ug���q��Ҿ��I�������j����F�	,V�XG�5��?��>��Ywo�Ÿ�3�ʣ��\�?-4�a��D�വVq���p��������N�f�&��z�5���?�{�Ĩ�Θ�v���&9Դ����",�v�R�ف��*���8��g�����[��G�}]*��I7 ��Ɨ�	�	�HQ褬�	BU��ť(�z�nWx���y�B^��T�8IRS����鐝-��t���QQ�^���r7Q[���ڵE�'bx�Fȋ���Y��1�S�r��\O�H����Dʬ+�U���9�N�J?�>�r4�e�`[��}Ak��{=��u�x4Vd6؅�y��!�V]���jjƽ��u`�=��NO��G�}�ǧ�jcOCH#_-[gN�줧t_ U}#�&�M\ᒿz��G',���ȕ�������X�	�7����A�1C5\�'�PO�U�i��v�-�{S]�;X(��yص��L0��ѽz�PXR��Ǥ[� �U�'�z
-�����Kv���bX�s}o��S�n��7�Ckgd��~7kݞ�^�{n��{�?ܫ��tfjp���0x�v��S7΃�^M[�;������=�V�{'����4�Җwǘ�0/�Ш���4͝�\��Aܬ�����ۃ�Z���M;1��
OTja��
?�bb�����=s��=b�EV��"��B��W�^M�:4N����X�=v����<.��&_��9W��'�7��Hz��M�X&�N��l���YwR����B����&蠪��[��nE	�u9(�W�T��q�b�&o�C��Xʋ�7CRֹ]�3�b��K	���lݯ��:Y��GQ��ZMt���it_M�&��q䞏N��.�SW��'\��ݭ��'��؂p�O�T��.W�;�3��r��%x��5��
Jt𥚎CY�l���ؓ��>ht�lLcY�6M�E�5����7���Fp8�r�0�a�pz��4`1�jq麩�HP%PD���Y���Z6� ���,m��5�}��	ۋ4�Tv��}N��l�ptf�L5~�+�
}
{�6�{���A]���M�+���F�m�Y�U6/\��r�
4�a_F�=�A8�z��<�ϫ�D+�����ixܗ���~-�t���^��T/�`�+�������f*���N4�����^��️*���ן%��"���Wv�,��v��h�q��@���{S`���Y���?�R%���`wX]Ջ[MX��)��E�!�g�j�g{}NN�a���?ˣ�u��!ȝx��H��+�[v��{�*s��"g;���D����L�L4��U��.���E��m��G��r����ҏ�]�ކ�ITM#�Ym�,�������>�:<_͠[#�X)��v��$���>Фq�l��o��g'⟟�������@���:���;�3�@��!T�a�ߞ*��}�Fj5ǌ�N�K�0Lk=��tc\����d�������>[M豇�_�!��k�<xԜ!�vd�g��o������~����U�*�}�*����繨{�]A���O��E�w����EO�£��oPr;�����8:1�B�zgo��O�L󀹱/�n���4�A���ؗBYؚ��<����Kk����U�`���������3��"���%���'�ǃ�q�򃻝	"e
0��z�������V=��釡9d�\і=L���Ce�;��u�Z�]�����HW�	:8N��P�/J�>��ct�L>��W����|�9��t���:��a�Y �d��s�Q'�Յ�� ܊�j����u�<f��wv��)�Spk�[�����<8쳕6��p((�Us#7���s��p��u]ٲ�H���~�}��d�1N�Ad�YQ�������媪\���$�y����.�s��څ���B��Z��K���Q�v/� HHإޡJT�y��K�hp����峿��+j��C)9'��U����XMj��.�	�:	�Z��:����
���H��wa^��������	�&?���K�Ev���ﳉ���g+� p:����!��Wt�z�k͸��(��yvf}DfN���{7�z�ֻ���^�N��s��iH��̯�_�X�ߣ��g`�a��Yj�����;��:�?�B`p�WY�/��=(�ZM|�_���u,���beP�X�.�4�J��z�-�' �  �k5ě-y�z!&���Gk����.>hpNi��K����vY��'�U�ߗE<�lus����̋�I���?^�A��*}\$��u�%�f�͸^J~����`�zZ�7^X���l�܂���h�}��J��&'Y�-}��������S�r&��e�v͚2Jq�K�����GԽ�L�N��G^ӭ��W�şd���Gw��M!8I��u�����f�zI�]�~Q.D2�QD]�&�E��f>B� d9�CZ,�l�$v+�<+�3��?�Ϫ*�yf���v
�nSCٓY�.r�F>��[�]�秮5g\���}�J�7��N��Q�kp�d�.�y| ~|忒W4��t�x����j�B�%�i�fv� �M�z��%78(�m$�l�י��]?]�a��k���u��p��&*G�r�{��L.�!��g���1>���ӓ͔��<w��F��x��/��'���KrI�V�2�p��-Α��V�����e��רlEXO�̀X5.Լ��(\Qq�+g�}��gb4������?˛Ӹ:�~|b���t�X}޵�����x�2��L-OCu����t����W>���o\��֞;.�+���i�ݒT���;�XW���:�׋���E��s+�]ny&yZ�Li]����|����\P-�v�ZE�n0)��M���M^I��hK�VQŌy���,�Q��5�=b�v^�������8|bhh�Z:�iz�DGA�92s,kg��`R�v9��T-�bD�7�S��5�/���c�Jg�0ʈjƺ)���a��:'�@����g�����LŠY^�ƂᛐJZ@�A~������B38��<��'ѵ�PLƞ�1b,�Smy?�R��z���͂#�U�T�c���jmZ]Z�Ӝ�vB�s9Yx&s�
fj�tQ�Ʌ���!k���"! 
�\oM�tk9E� Y�S���� �,1�M�Jw�*Y�Rg�(7  tʪK��K�mv�x@�o'��̧9@����xl�R��ϣ�*�*�"sf`���]VreI�Gc\.�>Zt�ӠWV]ޭ��cFܭ��O�횶�mfb�mc9�`�QД�
�u�1��>ڨ|��n�&��\G�<w�<\4`x>�N�f3#P����l� ��x])U�S&�_��� `x����R�Y�P��,�`ps �*_���
9S����� ����2���x�^�~D>daoB�Nv*m&NsTu���k�� `r�5k��du�P.ޫ�JJ' ��G���JK5{n?z8�	��>��)��WU�(���7w�q0H�n�d� ��{�h:�O=�}�*�u��Q�*�Y4�������īB�OZ�lD���Y!W����}��^�*�k��,R(,t��<����*�L����˸�zc�����J�J�&vTj�!�ևu$��*.=ŋ����
������A�O���B>�
cpv]S^c.��՗6��t�F@��'���v���A��s��i���p����Ȏ�ܫ�2���c*��W�Ĩ8t�ܧL��{8����y?�P%�5/��0������~N�GI�4q��ַy��>��=��Pb�
���k�����c*]��g�倐VZ��;�^)�]���W����U:lt�!Dɮ=$�R�MX�/�&a_���iRg�Uݰ�9!)}?K>Wpu��7�`y�L�Q�ho@�a0 �U���H�|!s)}��.N�y���~�W�9 �u��x��  ,���B�VPrh,�J������;�]��b�r���Qp!�x)%_��:��[��C�j���ZÀ��e�uǄ���0[
�W���T0����l�;�3j��:���f����w,:<�޺E���ߟ-�[��/88�1��[�I����m������f�n�;�>:YT"��__���*�����I��v��XP�����"�����Fl(Ο^�g���� i]��$�Ѱ�m��p@�EB�;6 :�� >���4�X@T��>"�#o����̄p\p�o&~X�Prt����ḷ  &�b������6�n��K.<z~pb������Yv�ssG�TЛ�����C��07&6���]����}Ȓg���\%�v�z�d5��F?�|�&�݃˔h��DS&���^s`�˚A2��S��Q�jE^����:�����ϓ ���;�1�����o�BY�Q	�K���]�e�X�����@�P\8��Rm����ۧ�y��l��o��>V�l	"��5��{k�~���/ d�7��+�Qbt_�&��	��d��B;�ъ���Z�M�F��1%)ϣErh�rvg��@ 	����%d����"�� �� �O�Kw��N׽����!��E�I����ߣ���@���S�/xME�b)�Q�! hI�;'d=k}1������ �%��]���t��x:�ۅ�C-�J��%k\�Jy&q�t�M'��Cvy�W�5l��9&���k���9�yg�UD��;p��(�G-�TE��n˛�J����C5��]^��P*�����V�TL�&��k$�2�#� ?�㝁˂�Wa+��������DX|춰&'�Z%z��=�h�L�ֹ� �kr�r:�dА����x�>��W�;�nQe�᳔\�5�&aZ�4�a?F�(�a��%>�>R�S#��Y��l�[��ąr
������!�C�L�B',�=y�k�)>�����a�]��w�]S=��oY�v�f!�����Uoc�=(�����g��.2(�<:h�j~�)k{�I�(��69:Vy?*lk,�����-��B4�C`���ꋚ@��E����r���P��\��ク?�V�цZ��cm4H������ҏ!�B�O>��tŉ��#��+{�i�'䕑���U_hN�<�R�FU1R��� �Kq�4���qi^��g�؇��'0��o�Th~x.L|�_3gl� �ѣJÎ+�l�gVF����� 8�������7�c�      G      x���r㸵��9O��쫱� $wUjWgRsHf����&US�A�$Qn���<} �H'��`��&�%��[�����/�����ڮsc�[����?�6��~��&�0��,��U~Β�9ZY�<��}�.����C���&��۔5Q�������m�&��>����w���w$����w��wx�������f��l����S���?�4���O�>=������-J�MQ�>m��m���ov-�e�m�p�vm��8��6�׮���l�����εy�����C���7U���>j9���=�r� \�/��|V�:I�h~�6���ߢ"�Q�"�(�D4P�5i�� �9B��A<�D�ЌE���"�(�8&�<Q�5Q�D�(�Dhy���>UČX�*b��O	�"O	�"O�g�1���1���5���?G��v��CB�T�ɇh���2�(f��T��'�ǭ��Z.2��?E]��]]_��=��ԣ?l=t�Cf��J=����ǳۊ4�|�v����\�&or��������&S���gIUE����� ���~�c�W�m۷�C�5B�J���,Sv]�=[�<��C?<k�f���d\�_.I�H�{�n�F�4��9�_?�x���7�w�w�F�1d���^_v��x�7�� ;��þ��Y��o:�#)=H� �>�H?��XJ���#�H?����y~_z�(=�����F�Z)X�VQ���;V�Uj�|��&��lG�F���y��?��"���%�����x=�����}�/i.��5���<���!j�lۚo����ws���/H�O��@���s�<�������8�8���D$>�[𧤮��E�x�{�%��c����{mǾt�p�d���3�y͚;><�H�h�85�i<6v	���p�og10&NDeQ�}\f,�\>��^K��P����CamJ�_8���gp̄CZb8��!^7��d-��v� M�v8�ǖ.a�����k�g��Zi�a8�������2�7ɯvB;�Hȭ�fMHH�i�7Ӯ�KHxu�0�	v$�2rZ�F�q�{!�Q�3���٧�2�'x$�1�ү����tƨ�]�.�TPFvw�M�3D\�K�K��|"���Ex ��r���K#��Af���|����.�+W�3�3O��d�Kk���uAҧ�Ш>��XZSlէT]�T�էT]zT�էT]�S�էT]�Q��S�.-)FF�)U��|)r��J
`X�U웃ʃ_�U<0�x1�[.�c�X���b�H?��������b�H?��һ��~饁�##��K�\,��"�c̩�򾴴>4fC ��?�~o�?������}ij}l���M�����Q}Jե������K��F�	U�sl����K�8F�)U�~5p��c�O�H=��҇�jXC@���Q|\ť���$�Ur�~�H~�6���aW����)���c��7�."�� ۶�-�iЌ�F�� K4��U۪$|����7��6x�p�Q���EV �'�!� ��8������r��t�����mT�T;�gh� ��9f��Ȫ��0��I[W��W�U��ѡc�?�� ���	�?]�;���t(�g9�.��Vӟ4�����֖�[�����'�́?��/M88��Ũ��Y��4�aw�����C_�O�>k	(i�C>�M�� ڂC^7y�U ���g�Wr���|%t�%'�?��BM\0�T�%�6�Ch�nt�-�|k�Y��i*���a1(*�Js������P����X�	͋�0��s�9�ʝ���M���U�\�a�A4"O!��9pm���PA����##�K��s�{��o�A�s�3���m�4�F��.)��rpa	[�-c�G��IS@hҬ |��m	�R���6��wd�¨W��p)��(�����7�h�M��х\��ET�BX�tuB�[
���CE*�xۤa��V|G��bb�3sT�ñ���".�etg����i�g�{��:%ou��UɃ��&���,i��c��U�p4k^
��M���&�ʋ��[���f�(&j�C=w��{�L:btTāzA�[�Ǡ��y��i�#,�\Jq�%/H�c�{�����R�DlѴ��q*Z�4�c��P�Bq����^�?�{7��m/2SG� {��r�qs(�A$�j��c�%qÜ焗*�8�&���c}��<7�8	��Zq�h���$�'m��[�?$bG�`�6`+$�å�;�}Iة�S{�p��.��zAg�M�LA\GYo�@�:d3�]Uq]�4ہ"�t
�\�NKh��9��^E�=�~��=�9��:N��&�db�xH�/ �*���U�4�t�����'�ط���� H|K�4K(�.�V̟�$���;V��Ů��PW���? qR��(!|���I�hԫ��ӂT��[>��O����� &��}Zg<R�NM5�7�;�Jw�b�7��w���A652U�q5�7�;.���ڐ}��|{~��?�Ǜਾ��/?�]D��7\��!�|�T:qhSAS�7���I"����燿�C�$�N������1�sE��U86r_4�7��K\=U���e�
r�2p����X�#��{e$���\OU�܎���|��A�+��h�g�.����x^ǖ�T�j�~�HUYǃ���K@�
<�ӫ���@Y��(#�Ңd))J�V�)�?���ߢi)�������� iI5�63��BU��Qs�Q���_����dH�{Vv}�Ϝf�<��L��݋8U���,�=l�N�YI��S�#/��c�K��t���^3���SUW��n)l�p� gA�JFж�c~ls���mթs1U�j�
M]FU(�z�Q��5��QՄ��r2�Yu4�f#���@��P��3^��D���@dQ�ă�y�9;a���<_���@l}TW~����y�Cq	Q�j4зRFR��NP����.>x_DG ^��7sTbs���@����0��51�k���}T� �mX���e[��#����ń�T��B��7��UUb�ce98�Z�he���;�g��i�Q^$��1ȵ�c{z�V�"Z3œ�Q�س����� �
��ǝ�]s�?S��I�[(��GUZ������]��F|I������ǨZ�4E;q���[�������� lei��x7�&F��'Ho�vW�c/�����ѧ��	�2>4uJ5��&�&�+UCA�Un��V&�Ll��ªT���1�&@��ر�97�?�<jlP���]K�e:���4>&U����]~�Q1;]'����جT5C��H��HlM`-��U`dє2�3��R�#���:����oɐi���Ɩʋ��i2�jT�h�}+b<!j5��&]6<�u�tH܂H�+��pN�����(��Ҍ��ʨ�iAJ�{��Ð�g1)�n�cteJ���M��ݭ���X*��u�q��uM��t�q�R��m:b�cW?��?�:�$=Cr�$�xS�<�����yH��2
��vD���:Fh0����"�vwl�M��E�i�m�\N��%@!jP<��+X�_��Ȫ�	N#pr|U!�M�$&�_���%�.&H0)U �}K���ڎ�[�H��0N+>-5����N��X_�Ʀ,X�A� �P#� }5��U��ռ����� �S=Jxj�G�AҤn��t�+ �5$5�#p:��N%�# G5$5�#pE�Ri�:F]�F��b�w���mT�	!+�)P�@�|���i4C��_��@�6)�ʔ��v�q�p��q\�o�U2�b���!����M/Ț�x�{~�Ćܘ]��u؊�����ΎuW��O1j<]:m8�6'U�|�Nx6��qm퐿��eT�R�����bGX�r2�鸲Sq�6�!6b'����� �����4�P�;Bے+͋ ����9��f��8KxOF�1�3�=�|�-T%�б�C��D��9N��^���9E8���Xbr
���jۈ�Ti$���x�C����4��1T�ZM[�"K����kŐ�I�_� �   "�3�,�ּ�OY|��:��*���:�c+�1m�V�̮\0���c��O��$^7�ӒH?Ei���W��WERM]�
&��M�q�ۜKUC	5� 1��C��)a`}���͑�����������q��W_�OME      5      x������ � �      7      x������ � �      �    N           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            O           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            P           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            Q           1262    16408    calendar    DATABASE     z   CREATE DATABASE calendar WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE calendar;
                postgres    false            R           0    0    DATABASE calendar    ACL     -   GRANT ALL ON DATABASE calendar TO devvirujh;
                   postgres    false    4177                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            S           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    3            T           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    3            �           1247    24835    consultations    TYPE     M   CREATE TYPE public.consultations AS ENUM (
    'online',
    'inHospital'
);
     DROP TYPE public.consultations;
       public          postgres    false    3            �           1247    24873    live_statuses    TYPE     t   CREATE TYPE public.live_statuses AS ENUM (
    'offline',
    'online',
    'videoSessionReady',
    'inSession'
);
     DROP TYPE public.live_statuses;
       public          postgres    false    3            �           1247    24756    overbookingtype    TYPE     N   CREATE TYPE public.overbookingtype AS ENUM (
    'Per Hour',
    'Per day'
);
 "   DROP TYPE public.overbookingtype;
       public          postgres    false    3            �           1247    24988    payment_statuses    TYPE     u   CREATE TYPE public.payment_statuses AS ENUM (
    'notPaid',
    'partiallyPaid',
    'fullyPaid',
    'refunded'
);
 #   DROP TYPE public.payment_statuses;
       public          postgres    false    3            �           1247    24827    payments    TYPE     h   CREATE TYPE public.payments AS ENUM (
    'onlineCollection',
    'directPayment',
    'notRequired'
);
    DROP TYPE public.payments;
       public          postgres    false    3            �           1247    24841    preconsultations    TYPE     E   CREATE TYPE public.preconsultations AS ENUM (
    'on',
    'off'
);
 #   DROP TYPE public.preconsultations;
       public          postgres    false    3            �           1247    24865    statuses    TYPE     [   CREATE TYPE public.statuses AS ENUM (
    'completed',
    'paused',
    'notCompleted'
);
    DROP TYPE public.statuses;
       public          postgres    false    3            �            1259    16489    account_details    TABLE     s  CREATE TABLE public.account_details (
    account_key character varying(200) NOT NULL,
    hospital_name character varying(200) NOT NULL,
    street1 character varying(100),
    street2 character varying(100),
    city character varying(100),
    state character varying NOT NULL,
    pincode character varying(100) NOT NULL,
    phone bigint NOT NULL,
    support_email character varying(100),
    account_details_id integer NOT NULL,
    hospital_photo character varying(500),
    country character varying(100),
    landmark character varying(100),
    "supportEmail" character varying,
    "cityState" character varying
);
 #   DROP TABLE public.account_details;
       public            postgres    false    3            �            1259    16487 &   account_details_account_details_id_seq    SEQUENCE     �   CREATE SEQUENCE public.account_details_account_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.account_details_account_details_id_seq;
       public          postgres    false    197    3            U           0    0 &   account_details_account_details_id_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.account_details_account_details_id_seq OWNED BY public.account_details.account_details_id;
          public          postgres    false    196            �            1259    27738    advertisement    TABLE     �   CREATE TABLE public.advertisement (
    id integer NOT NULL,
    name character varying(100),
    content character varying(5000),
    code character varying(1000),
    "createdTime" timestamp without time zone,
    is_active boolean
);
 !   DROP TABLE public.advertisement;
       public            postgres    false    3            �            1259    16502    appointment    TABLE     B  CREATE TABLE public.appointment (
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
    "hasConsultation" boolean,
    reportid character varying(100)
);
    DROP TABLE public.appointment;
       public            postgres    false    727    730    736    727    3    730    736            �            1259    16513    appointment_cancel_reschedule    TABLE     z  CREATE TABLE public.appointment_cancel_reschedule (
    appointment_cancel_reschedule_id integer NOT NULL,
    cancel_on date NOT NULL,
    cancel_by bigint NOT NULL,
    cancel_payment_status character varying(100) NOT NULL,
    cancel_by_id bigint NOT NULL,
    reschedule boolean NOT NULL,
    reschedule_appointment_id bigint NOT NULL,
    appointment_id bigint NOT NULL
);
 1   DROP TABLE public.appointment_cancel_reschedule;
       public            postgres    false    3            �            1259    16511 ?   appointment_cancel_reschedule_appointment_cancel_reschedule_seq    SEQUENCE     �   CREATE SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 V   DROP SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq;
       public          postgres    false    201    3            V           0    0 ?   appointment_cancel_reschedule_appointment_cancel_reschedule_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq OWNED BY public.appointment_cancel_reschedule.appointment_cancel_reschedule_id;
          public          postgres    false    200            �            1259    16527    appointment_doc_config    TABLE     �  CREATE TABLE public.appointment_doc_config (
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
 *   DROP TABLE public.appointment_doc_config;
       public            postgres    false    3            �            1259    16525 4   appointment_doc_config_appointment_doc_config_id_seq    SEQUENCE     �   CREATE SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 K   DROP SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq;
       public          postgres    false    3    203            W           0    0 4   appointment_doc_config_appointment_doc_config_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.appointment_doc_config_appointment_doc_config_id_seq OWNED BY public.appointment_doc_config.appointment_doc_config_id;
          public          postgres    false    202            �            1259    16500    appointment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.appointment_id_seq;
       public          postgres    false    3    199            X           0    0    appointment_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.appointment_id_seq OWNED BY public.appointment.id;
          public          postgres    false    198            �            1259    16751    appointment_seq    SEQUENCE     x   CREATE SEQUENCE public.appointment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.appointment_seq;
       public          postgres    false    3            �            1259    24932    communication_type    TABLE     e   CREATE TABLE public.communication_type (
    id integer NOT NULL,
    name character varying(100)
);
 &   DROP TABLE public.communication_type;
       public            postgres    false    3            �            1259    24930    communication_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.communication_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.communication_type_id_seq;
       public          postgres    false    3    239            Y           0    0    communication_type_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.communication_type_id_seq OWNED BY public.communication_type.id;
          public          postgres    false    238            �            1259    24635 
   doc_config    TABLE     �  CREATE TABLE public.doc_config (
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
    DROP TABLE public.doc_config;
       public            postgres    false    3    712            �            1259    16587    doctor_config_can_resch    TABLE     ^  CREATE TABLE public.doctor_config_can_resch (
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
 +   DROP TABLE public.doctor_config_can_resch;
       public            postgres    false    3            �            1259    16753 0   doc_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 G   DROP SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq;
       public          postgres    false    209    3            Z           0    0 0   doc_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doc_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;
          public          postgres    false    217            �            1259    16544    doc_config_schedule_day    TABLE     �   CREATE TABLE public.doc_config_schedule_day (
    doctor_id bigint NOT NULL,
    "dayOfWeek" character varying(50) NOT NULL,
    id integer NOT NULL,
    doctor_key character varying
);
 +   DROP TABLE public.doc_config_schedule_day;
       public            postgres    false    3            �            1259    24666 6   doc_config_schedule_day_doc_config_schedule_day_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 M   DROP SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq;
       public          postgres    false    3    204            [           0    0 6   doc_config_schedule_day_doc_config_schedule_day_id_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public.doc_config_schedule_day_doc_config_schedule_day_id_seq OWNED BY public.doc_config_schedule_day.id;
          public          postgres    false    222            �            1259    16552    doc_config_schedule_interval    TABLE     �   CREATE TABLE public.doc_config_schedule_interval (
    "startTime" time without time zone NOT NULL,
    "endTime" time without time zone NOT NULL,
    "docConfigScheduleDayId" bigint NOT NULL,
    id integer NOT NULL,
    doctorkey character varying
);
 0   DROP TABLE public.doc_config_schedule_interval;
       public            postgres    false    3            �            1259    24672 ?   doc_config_schedule_interval_doc_config_schedule_interval_i_seq    SEQUENCE     �   CREATE SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 V   DROP SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq;
       public          postgres    false    3    205            \           0    0 ?   doc_config_schedule_interval_doc_config_schedule_interval_i_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq OWNED BY public.doc_config_schedule_interval.id;
          public          postgres    false    223            �            1259    24663    docconfigid_seq    SEQUENCE     x   CREATE SEQUENCE public.docconfigid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.docconfigid_seq;
       public          postgres    false    220    3            ]           0    0    docconfigid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.docconfigid_seq OWNED BY public.doc_config.id;
          public          postgres    false    221            �            1259    16568    doctor    TABLE     �  CREATE TABLE public.doctor (
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
    DROP TABLE public.doctor;
       public            postgres    false    739    739    3            �            1259    16585 3   doctor_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 J   DROP SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq;
       public          postgres    false    3    209            ^           0    0 3   doctor_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doctor_config_can_resch_doc_config_can_resch_id_seq OWNED BY public.doctor_config_can_resch.doc_config_can_resch_id;
          public          postgres    false    208            �            1259    16598    doctor_config_pre_consultation    TABLE     Y  CREATE TABLE public.doctor_config_pre_consultation (
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
 2   DROP TABLE public.doctor_config_pre_consultation;
       public            postgres    false    3            �            1259    16596 3   doctor_config_pre_consultation_doctor_config_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 J   DROP SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq;
       public          postgres    false    211    3            _           0    0 3   doctor_config_pre_consultation_doctor_config_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doctor_config_pre_consultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;
          public          postgres    false    210            �            1259    16755 2   doctor_config_preconsultation_doctor_config_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 I   DROP SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq;
       public          postgres    false    3    211            `           0    0 2   doctor_config_preconsultation_doctor_config_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.doctor_config_preconsultation_doctor_config_id_seq OWNED BY public.doctor_config_pre_consultation.doctor_config_id;
          public          postgres    false    218            �            1259    16757    doctor_details_doctor_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_details_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.doctor_details_doctor_id_seq;
       public          postgres    false    3    207            a           0    0    doctor_details_doctor_id_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.doctor_details_doctor_id_seq OWNED BY public.doctor."doctorId";
          public          postgres    false    219            �            1259    16566    doctor_doctor_id_seq    SEQUENCE     �   CREATE SEQUENCE public.doctor_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.doctor_doctor_id_seq;
       public          postgres    false    207    3            b           0    0    doctor_doctor_id_seq    SEQUENCE OWNED BY     N   ALTER SEQUENCE public.doctor_doctor_id_seq OWNED BY public.doctor."doctorId";
          public          postgres    false    206            �            1259    16642    interval_days    TABLE     �   CREATE TABLE public.interval_days (
    interval_days_id integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    wrk_sched_id bigint NOT NULL
);
 !   DROP TABLE public.interval_days;
       public            postgres    false    3            �            1259    16640 "   interval_days_interval_days_id_seq    SEQUENCE     �   CREATE SEQUENCE public.interval_days_interval_days_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.interval_days_interval_days_id_seq;
       public          postgres    false    215    3            c           0    0 "   interval_days_interval_days_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.interval_days_interval_days_id_seq OWNED BY public.interval_days.interval_days_id;
          public          postgres    false    214            �            1259    33192    medicine    TABLE     D  CREATE TABLE public.medicine (
    id integer,
    prescription_id bigint,
    name_of_medicine character varying,
    frequency_of_each_dose character varying,
    count_of_medicine_for_each_dose bigint,
    type_of_medicine character varying,
    dose_of_medicine character varying,
    count_of_days character varying
);
    DROP TABLE public.medicine;
       public            postgres    false    3            �            1259    24958    message_metadata    TABLE     �   CREATE TABLE public.message_metadata (
    id integer NOT NULL,
    message_type_id bigint,
    communication_type_id bigint,
    message_template_id bigint
);
 $   DROP TABLE public.message_metadata;
       public            postgres    false    3            �            1259    24956    message_metadata_id_seq    SEQUENCE     �   CREATE SEQUENCE public.message_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.message_metadata_id_seq;
       public          postgres    false    3    243            d           0    0    message_metadata_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.message_metadata_id_seq OWNED BY public.message_metadata.id;
          public          postgres    false    242            �            1259    24912    message_template    TABLE     �   CREATE TABLE public.message_template (
    id integer NOT NULL,
    sender character varying(200),
    subject character varying(200),
    body character varying(500000)
);
 $   DROP TABLE public.message_template;
       public            postgres    false    3            �            1259    24910    message_template_id_seq    SEQUENCE     �   CREATE SEQUENCE public.message_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.message_template_id_seq;
       public          postgres    false    235    3            e           0    0    message_template_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.message_template_id_seq OWNED BY public.message_template.id;
          public          postgres    false    234            �            1259    24940    message_template_placeholders    TABLE     �   CREATE TABLE public.message_template_placeholders (
    id integer NOT NULL,
    message_template_id bigint,
    placeholder_name character varying(200),
    message_type_id bigint
);
 1   DROP TABLE public.message_template_placeholders;
       public            postgres    false    3            �            1259    24938 $   message_template_placeholders_id_seq    SEQUENCE     �   CREATE SEQUENCE public.message_template_placeholders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.message_template_placeholders_id_seq;
       public          postgres    false    3    241            f           0    0 $   message_template_placeholders_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.message_template_placeholders_id_seq OWNED BY public.message_template_placeholders.id;
          public          postgres    false    240            �            1259    24923    message_type    TABLE     �   CREATE TABLE public.message_type (
    id integer NOT NULL,
    name character varying(200),
    description character varying
);
     DROP TABLE public.message_type;
       public            postgres    false    3            �            1259    24921    message_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.message_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.message_type_id_seq;
       public          postgres    false    3    237            g           0    0    message_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.message_type_id_seq OWNED BY public.message_type.id;
          public          postgres    false    236            �            1259    24773    openvidu_session    TABLE     �   CREATE TABLE public.openvidu_session (
    openvidu_session_id integer NOT NULL,
    doctor_key character varying(100) NOT NULL,
    session_name character varying(100) NOT NULL,
    session_id character varying(100) NOT NULL
);
 $   DROP TABLE public.openvidu_session;
       public            postgres    false    3            �            1259    24771 (   openvidu_session_openvidu_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.openvidu_session_openvidu_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.openvidu_session_openvidu_session_id_seq;
       public          postgres    false    231    3            h           0    0 (   openvidu_session_openvidu_session_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.openvidu_session_openvidu_session_id_seq OWNED BY public.openvidu_session.openvidu_session_id;
          public          postgres    false    230            �            1259    24783    openvidu_session_token    TABLE     �   CREATE TABLE public.openvidu_session_token (
    openvidu_session_token_id integer NOT NULL,
    openvidu_session_id bigint NOT NULL,
    token text NOT NULL,
    doctor_id bigint,
    patient_id bigint
);
 *   DROP TABLE public.openvidu_session_token;
       public            postgres    false    3            �            1259    24781 4   openvidu_session_token_openvidu_session_token_id_seq    SEQUENCE     �   CREATE SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 K   DROP SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq;
       public          postgres    false    233    3            i           0    0 4   openvidu_session_token_openvidu_session_token_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.openvidu_session_token_openvidu_session_token_id_seq OWNED BY public.openvidu_session_token.openvidu_session_token_id;
          public          postgres    false    232            �            1259    24691    patient_details    TABLE     X  CREATE TABLE public.patient_details (
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
    last_active timestamp without time zone,
    honorific character varying(10),
    city character varying,
    gender character varying(100)
);
 #   DROP TABLE public.patient_details;
       public            postgres    false    739    3    739            �            1259    24689 &   patient_details_patient_details_id_seq    SEQUENCE     �   CREATE SEQUENCE public.patient_details_patient_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.patient_details_patient_details_id_seq;
       public          postgres    false    225    3            j           0    0 &   patient_details_patient_details_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.patient_details_patient_details_id_seq OWNED BY public.patient_details.id;
          public          postgres    false    224            �            1259    33460    patient_report    TABLE     Q  CREATE TABLE public.patient_report (
    id integer NOT NULL,
    patient_id bigint NOT NULL,
    appointment_id bigint,
    file_name character varying NOT NULL,
    file_type character varying NOT NULL,
    report_url character varying NOT NULL,
    comments character varying,
    report_date date,
    active boolean DEFAULT true
);
 "   DROP TABLE public.patient_report;
       public            postgres    false    3            �            1259    33467    patient_report_id_seq    SEQUENCE     �   CREATE SEQUENCE public.patient_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.patient_report_id_seq;
       public          postgres    false    248    3            k           0    0    patient_report_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.patient_report_id_seq OWNED BY public.patient_report.id;
          public          postgres    false    249            �            1259    16628    payment_details    TABLE     "  CREATE TABLE public.payment_details (
    id integer NOT NULL,
    appointment_id bigint,
    order_id character varying(200),
    receipt_id character varying(200),
    amount character varying(100),
    payment_status public.payment_statuses DEFAULT 'notPaid'::public.payment_statuses
);
 #   DROP TABLE public.payment_details;
       public            postgres    false    765    765    3            �            1259    16626    payment_details_payment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_details_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.payment_details_payment_id_seq;
       public          postgres    false    3    213            l           0    0    payment_details_payment_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.payment_details_payment_id_seq OWNED BY public.payment_details.id;
          public          postgres    false    212            �            1259    33142    prescription    TABLE     �  CREATE TABLE public.prescription (
    appointment_id bigint,
    appointment_date date,
    hospital_logo character varying(500),
    hospital_name character varying(100),
    doctor_name character varying(200),
    doctor_signature character varying(500),
    patient_name character varying(200),
    prescription_url character varying,
    id integer NOT NULL,
    remarks character varying(500),
    "hospitalAddress" character varying(200),
    diagnosis character varying(500)
);
     DROP TABLE public.prescription;
       public            postgres    false    3            �            1259    33231    prescription_id_seq    SEQUENCE     �   ALTER TABLE public.prescription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.prescription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    245    3            �            1259    24709    work_schedule_day    TABLE     �   CREATE TABLE public.work_schedule_day (
    id integer NOT NULL,
    doctor_id bigint NOT NULL,
    date date NOT NULL,
    is_active boolean,
    doctor_key character varying(100)
);
 %   DROP TABLE public.work_schedule_day;
       public            postgres    false    3            �            1259    24707    work_schedule_day_id_seq    SEQUENCE     �   CREATE SEQUENCE public.work_schedule_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.work_schedule_day_id_seq;
       public          postgres    false    227    3            m           0    0    work_schedule_day_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.work_schedule_day_id_seq OWNED BY public.work_schedule_day.id;
          public          postgres    false    226            �            1259    24717    work_schedule_interval    TABLE     �   CREATE TABLE public.work_schedule_interval (
    id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    work_schedule_day_id bigint,
    is_active boolean
);
 *   DROP TABLE public.work_schedule_interval;
       public            postgres    false    3            �            1259    24715    work_schedule_interval_id_seq    SEQUENCE     �   CREATE SEQUENCE public.work_schedule_interval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.work_schedule_interval_id_seq;
       public          postgres    false    3    229            n           0    0    work_schedule_interval_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.work_schedule_interval_id_seq OWNED BY public.work_schedule_interval.id;
          public          postgres    false    228            "           2604    16764 "   account_details account_details_id    DEFAULT     �   ALTER TABLE ONLY public.account_details ALTER COLUMN account_details_id SET DEFAULT nextval('public.account_details_account_details_id_seq'::regclass);
 Q   ALTER TABLE public.account_details ALTER COLUMN account_details_id DROP DEFAULT;
       public          postgres    false    196    197    197            #           2604    16505    appointment id    DEFAULT     p   ALTER TABLE ONLY public.appointment ALTER COLUMN id SET DEFAULT nextval('public.appointment_id_seq'::regclass);
 =   ALTER TABLE public.appointment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    199    198    199            (           2604    16765 >   appointment_cancel_reschedule appointment_cancel_reschedule_id    DEFAULT     �   ALTER TABLE ONLY public.appointment_cancel_reschedule ALTER COLUMN appointment_cancel_reschedule_id SET DEFAULT nextval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq'::regclass);
 m   ALTER TABLE public.appointment_cancel_reschedule ALTER COLUMN appointment_cancel_reschedule_id DROP DEFAULT;
       public          postgres    false    200    201    201            )           2604    16766 0   appointment_doc_config appointment_doc_config_id    DEFAULT     �   ALTER TABLE ONLY public.appointment_doc_config ALTER COLUMN appointment_doc_config_id SET DEFAULT nextval('public.appointment_doc_config_appointment_doc_config_id_seq'::regclass);
 _   ALTER TABLE public.appointment_doc_config ALTER COLUMN appointment_doc_config_id DROP DEFAULT;
       public          postgres    false    202    203    203            L           2604    24935    communication_type id    DEFAULT     ~   ALTER TABLE ONLY public.communication_type ALTER COLUMN id SET DEFAULT nextval('public.communication_type_id_seq'::regclass);
 D   ALTER TABLE public.communication_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    239    239            B           2604    24665    doc_config id    DEFAULT     l   ALTER TABLE ONLY public.doc_config ALTER COLUMN id SET DEFAULT nextval('public.docconfigid_seq'::regclass);
 <   ALTER TABLE public.doc_config ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    220            *           2604    24668    doc_config_schedule_day id    DEFAULT     �   ALTER TABLE ONLY public.doc_config_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq'::regclass);
 I   ALTER TABLE public.doc_config_schedule_day ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    204            +           2604    24674    doc_config_schedule_interval id    DEFAULT     �   ALTER TABLE ONLY public.doc_config_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq'::regclass);
 N   ALTER TABLE public.doc_config_schedule_interval ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    205            ,           2604    16769    doctor doctorId    DEFAULT     }   ALTER TABLE ONLY public.doctor ALTER COLUMN "doctorId" SET DEFAULT nextval('public.doctor_details_doctor_id_seq'::regclass);
 @   ALTER TABLE public.doctor ALTER COLUMN "doctorId" DROP DEFAULT;
       public          postgres    false    219    207            .           2604    16770 /   doctor_config_can_resch doc_config_can_resch_id    DEFAULT     �   ALTER TABLE ONLY public.doctor_config_can_resch ALTER COLUMN doc_config_can_resch_id SET DEFAULT nextval('public.doc_config_can_resch_doc_config_can_resch_id_seq'::regclass);
 ^   ALTER TABLE public.doctor_config_can_resch ALTER COLUMN doc_config_can_resch_id DROP DEFAULT;
       public          postgres    false    217    209            /           2604    16771 /   doctor_config_pre_consultation doctor_config_id    DEFAULT     �   ALTER TABLE ONLY public.doctor_config_pre_consultation ALTER COLUMN doctor_config_id SET DEFAULT nextval('public.doctor_config_preconsultation_doctor_config_id_seq'::regclass);
 ^   ALTER TABLE public.doctor_config_pre_consultation ALTER COLUMN doctor_config_id DROP DEFAULT;
       public          postgres    false    218    211            2           2604    16772    interval_days interval_days_id    DEFAULT     �   ALTER TABLE ONLY public.interval_days ALTER COLUMN interval_days_id SET DEFAULT nextval('public.interval_days_interval_days_id_seq'::regclass);
 M   ALTER TABLE public.interval_days ALTER COLUMN interval_days_id DROP DEFAULT;
       public          postgres    false    215    214    215            N           2604    24961    message_metadata id    DEFAULT     z   ALTER TABLE ONLY public.message_metadata ALTER COLUMN id SET DEFAULT nextval('public.message_metadata_id_seq'::regclass);
 B   ALTER TABLE public.message_metadata ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    242    243    243            J           2604    24915    message_template id    DEFAULT     z   ALTER TABLE ONLY public.message_template ALTER COLUMN id SET DEFAULT nextval('public.message_template_id_seq'::regclass);
 B   ALTER TABLE public.message_template ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    235    234    235            M           2604    24943     message_template_placeholders id    DEFAULT     �   ALTER TABLE ONLY public.message_template_placeholders ALTER COLUMN id SET DEFAULT nextval('public.message_template_placeholders_id_seq'::regclass);
 O   ALTER TABLE public.message_template_placeholders ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240    241            K           2604    24926    message_type id    DEFAULT     r   ALTER TABLE ONLY public.message_type ALTER COLUMN id SET DEFAULT nextval('public.message_type_id_seq'::regclass);
 >   ALTER TABLE public.message_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    236    237            H           2604    24776 $   openvidu_session openvidu_session_id    DEFAULT     �   ALTER TABLE ONLY public.openvidu_session ALTER COLUMN openvidu_session_id SET DEFAULT nextval('public.openvidu_session_openvidu_session_id_seq'::regclass);
 S   ALTER TABLE public.openvidu_session ALTER COLUMN openvidu_session_id DROP DEFAULT;
       public          postgres    false    231    230    231            I           2604    24786 0   openvidu_session_token openvidu_session_token_id    DEFAULT     �   ALTER TABLE ONLY public.openvidu_session_token ALTER COLUMN openvidu_session_token_id SET DEFAULT nextval('public.openvidu_session_token_openvidu_session_token_id_seq'::regclass);
 _   ALTER TABLE public.openvidu_session_token ALTER COLUMN openvidu_session_token_id DROP DEFAULT;
       public          postgres    false    232    233    233            D           2604    24694    patient_details id    DEFAULT     �   ALTER TABLE ONLY public.patient_details ALTER COLUMN id SET DEFAULT nextval('public.patient_details_patient_details_id_seq'::regclass);
 A   ALTER TABLE public.patient_details ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    225    225            P           2604    33469    patient_report id    DEFAULT     v   ALTER TABLE ONLY public.patient_report ALTER COLUMN id SET DEFAULT nextval('public.patient_report_id_seq'::regclass);
 @   ALTER TABLE public.patient_report ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    249    248            0           2604    16773    payment_details id    DEFAULT     �   ALTER TABLE ONLY public.payment_details ALTER COLUMN id SET DEFAULT nextval('public.payment_details_payment_id_seq'::regclass);
 A   ALTER TABLE public.payment_details ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212    213            F           2604    24712    work_schedule_day id    DEFAULT     |   ALTER TABLE ONLY public.work_schedule_day ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_day_id_seq'::regclass);
 C   ALTER TABLE public.work_schedule_day ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227            G           2604    24720    work_schedule_interval id    DEFAULT     �   ALTER TABLE ONLY public.work_schedule_interval ALTER COLUMN id SET DEFAULT nextval('public.work_schedule_interval_id_seq'::regclass);
 H   ALTER TABLE public.work_schedule_interval ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228    229                      0    16489    account_details 
   TABLE DATA           �   COPY public.account_details (account_key, hospital_name, street1, street2, city, state, pincode, phone, support_email, account_details_id, hospital_photo, country, landmark, "supportEmail", "cityState") FROM stdin;
    public          postgres    false    197            F          0    27738    advertisement 
   TABLE DATA           Z   COPY public.advertisement (id, name, content, code, "createdTime", is_active) FROM stdin;
    public          postgres    false    244                    0    16502    appointment 
   TABLE DATA           (  COPY public.appointment (id, "doctorId", patient_id, appointment_date, "startTime", "endTime", payment_status, is_active, is_cancel, created_by, created_id, cancelled_by, cancelled_id, "slotTiming", paymentoption, consultationmode, status, "createdTime", "hasConsultation", reportid) FROM stdin;
    public          postgres    false    199   a                  0    16513    appointment_cancel_reschedule 
   TABLE DATA           �   COPY public.appointment_cancel_reschedule (appointment_cancel_reschedule_id, cancel_on, cancel_by, cancel_payment_status, cancel_by_id, reschedule, reschedule_appointment_id, appointment_id) FROM stdin;
    public          postgres    false    201                    0    16527    appointment_doc_config 
   TABLE DATA           �  COPY public.appointment_doc_config (appointment_doc_config_id, appointment_id, consultation_cost, is_preconsultation_allowed, pre_consultation_hours, pre_consultation_mins, is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins) FROM stdin;
    public          postgres    false    203           A          0    24932    communication_type 
   TABLE DATA           6   COPY public.communication_type (id, name) FROM stdin;
    public          postgres    false    239   A
       .          0    24635 
   doc_config 
   TABLE DATA           �  COPY public.doc_config (id, doctor_key, consultation_cost, is_pre_consultation_allowed, "pre-consultation-hours", "pre-consultation-mins", is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_reschedule_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, "isActive", created_on, modified_on, "overBookingCount", "overBookingEnabled", "overBookingType", "consultationSessionTimings") FROM stdin;
    public          postgres    false    220   %                  0    16544    doc_config_schedule_day 
   TABLE DATA           Y   COPY public.doc_config_schedule_day (doctor_id, "dayOfWeek", id, doctor_key) FROM stdin;
    public          postgres    false    204   �                 0    16552    doc_config_schedule_interval 
   TABLE DATA           w   COPY public.doc_config_schedule_interval ("startTime", "endTime", "docConfigScheduleDayId", id, doctorkey) FROM stdin;
    public          postgres    false    205    	       !          0    16568    doctor 
   TABLE DATA           �   COPY public.doctor ("doctorId", doctor_name, account_key, doctor_key, experience, speciality, qualification, photo, number, signature, first_name, last_name, registration_number, email, live_status, last_active) FROM stdin;
    public          postgres    false    207          #          0    16587    doctor_config_can_resch 
   TABLE DATA           W  COPY public.doctor_config_can_resch (doc_config_can_resch_id, doc_key, is_patient_cancellation_allowed, cancellation_days, cancellation_hours, cancellation_mins, is_patient_resch_allowed, reschedule_days, reschedule_hours, reschedule_mins, auto_cancel_days, auto_cancel_hours, auto_cancel_mins, is_active, created_on, modified_on) FROM stdin;
    public          postgres    false    209           %          0    16598    doctor_config_pre_consultation 
   TABLE DATA           �   COPY public.doctor_config_pre_consultation (doctor_config_id, doctor_key, consultation_cost, is_preconsultation_allowed, preconsultation_hours, preconsultation_minutes, is_active, created_on, modified_on) FROM stdin;
    public          postgres    false    211   H        )          0    16642    interval_days 
   TABLE DATA           ]   COPY public.interval_days (interval_days_id, start_time, end_time, wrk_sched_id) FROM stdin;
    public          postgres    false    215   ?        H          0    33192    medicine 
   TABLE DATA           �   COPY public.medicine (id, prescription_id, name_of_medicine, frequency_of_each_dose, count_of_medicine_for_each_dose, type_of_medicine, dose_of_medicine, count_of_days) FROM stdin;
    public          postgres    false    246           E          0    24958    message_metadata 
   TABLE DATA           k   COPY public.message_metadata (id, message_type_id, communication_type_id, message_template_id) FROM stdin;
    public          postgres    false    243   b       =          0    24912    message_template 
   TABLE DATA           E   COPY public.message_template (id, sender, subject, body) FROM stdin;
    public          postgres    false    235   9        C          0    24940    message_template_placeholders 
   TABLE DATA           s   COPY public.message_template_placeholders (id, message_template_id, placeholder_name, message_type_id) FROM stdin;
    public          postgres    false    241          ?          0    24923    message_type 
   TABLE DATA           =   COPY public.message_type (id, name, description) FROM stdin;
    public          postgres    false    237           9          0    24773    openvidu_session 
   TABLE DATA           e   COPY public.openvidu_session (openvidu_session_id, doctor_key, session_name, session_id) FROM stdin;
    public          postgres    false    231   �        ;          0    24783    openvidu_session_token 
   TABLE DATA           ~   COPY public.openvidu_session_token (openvidu_session_token_id, openvidu_session_id, token, doctor_id, patient_id) FROM stdin;
    public          postgres    false    233          3          0    24691    patient_details 
   TABLE DATA           	  COPY public.patient_details (id, name, landmark, country, registration_number, address, state, pincode, email, photo, phone, patient_id, "firstName", "lastName", "dateOfBirth", "alternateContact", age, live_status, last_active, honorific, city, gender) FROM stdin;
    public          postgres    false    225   n       J          0    33460    patient_report 
   TABLE DATA           �   COPY public.patient_report (id, patient_id, appointment_id, file_name, file_type, report_url, comments, report_date, active) FROM stdin;
    public          postgres    false    248   �       '          0    16628    payment_details 
   TABLE DATA           k   COPY public.payment_details (id, appointment_id, order_id, receipt_id, amount, payment_status) FROM stdin;
    public          postgres    false    213   l       G          0    33142    prescription 
   TABLE DATA           �   COPY public.prescription (appointment_id, appointment_date, hospital_logo, hospital_name, doctor_name, doctor_signature, patient_name, prescription_url, id, remarks, "hospitalAddress", diagnosis) FROM stdin;
    public          postgres    false    245   �       5          0    24709    work_schedule_day 
   TABLE DATA           W   COPY public.work_schedule_day (id, doctor_id, date, is_active, doctor_key) FROM stdin;
    public          postgres    false    227   �        7          0    24717    work_schedule_interval 
   TABLE DATA           k   COPY public.work_schedule_interval (id, start_time, end_time, work_schedule_day_id, is_active) FROM stdin;
    public          postgres    false    229           o           0    0 &   account_details_account_details_id_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.account_details_account_details_id_seq', 1, false);
          public          postgres    false    196            p           0    0 ?   appointment_cancel_reschedule_appointment_cancel_reschedule_seq    SEQUENCE SET     n   SELECT pg_catalog.setval('public.appointment_cancel_reschedule_appointment_cancel_reschedule_seq', 1, false);
          public          postgres    false    200            q           0    0 4   appointment_doc_config_appointment_doc_config_id_seq    SEQUENCE SET     e   SELECT pg_catalog.setval('public.appointment_doc_config_appointment_doc_config_id_seq', 2453, true);
          public          postgres    false    202            r           0    0    appointment_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.appointment_id_seq', 2712, true);
          public          postgres    false    198            s           0    0    appointment_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.appointment_seq', 17, true);
          public          postgres    false    216            t           0    0    communication_type_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.communication_type_id_seq', 1, false);
          public          postgres    false    238            u           0    0 0   doc_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE SET     ^   SELECT pg_catalog.setval('public.doc_config_can_resch_doc_config_can_resch_id_seq', 2, true);
          public          postgres    false    217            v           0    0 6   doc_config_schedule_day_doc_config_schedule_day_id_seq    SEQUENCE SET     f   SELECT pg_catalog.setval('public.doc_config_schedule_day_doc_config_schedule_day_id_seq', 492, true);
          public          postgres    false    222            w           0    0 ?   doc_config_schedule_interval_doc_config_schedule_interval_i_seq    SEQUENCE SET     o   SELECT pg_catalog.setval('public.doc_config_schedule_interval_doc_config_schedule_interval_i_seq', 583, true);
          public          postgres    false    223            x           0    0    docconfigid_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.docconfigid_seq', 109, true);
          public          postgres    false    221            y           0    0 3   doctor_config_can_resch_doc_config_can_resch_id_seq    SEQUENCE SET     b   SELECT pg_catalog.setval('public.doctor_config_can_resch_doc_config_can_resch_id_seq', 1, false);
          public          postgres    false    208            z           0    0 3   doctor_config_pre_consultation_doctor_config_id_seq    SEQUENCE SET     b   SELECT pg_catalog.setval('public.doctor_config_pre_consultation_doctor_config_id_seq', 1, false);
          public          postgres    false    210            {           0    0 2   doctor_config_preconsultation_doctor_config_id_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('public.doctor_config_preconsultation_doctor_config_id_seq', 9, true);
          public          postgres    false    218            |           0    0    doctor_details_doctor_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.doctor_details_doctor_id_seq', 95, true);
          public          postgres    false    219            }           0    0    doctor_doctor_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.doctor_doctor_id_seq', 1, false);
          public          postgres    false    206            ~           0    0 "   interval_days_interval_days_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.interval_days_interval_days_id_seq', 1, false);
          public          postgres    false    214                       0    0    message_metadata_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.message_metadata_id_seq', 1, false);
          public          postgres    false    242            �           0    0    message_template_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.message_template_id_seq', 1, false);
          public          postgres    false    234            �           0    0 $   message_template_placeholders_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.message_template_placeholders_id_seq', 1, false);
          public          postgres    false    240            �           0    0    message_type_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.message_type_id_seq', 1, false);
          public          postgres    false    236            �           0    0 (   openvidu_session_openvidu_session_id_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public.openvidu_session_openvidu_session_id_seq', 18290, true);
          public          postgres    false    230            �           0    0 4   openvidu_session_token_openvidu_session_token_id_seq    SEQUENCE SET     f   SELECT pg_catalog.setval('public.openvidu_session_token_openvidu_session_token_id_seq', 21007, true);
          public          postgres    false    232            �           0    0 &   patient_details_patient_details_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.patient_details_patient_details_id_seq', 876, true);
          public          postgres    false    224            �           0    0    patient_report_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.patient_report_id_seq', 1519, true);
          public          postgres    false    249            �           0    0    payment_details_payment_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.payment_details_payment_id_seq', 2765, true);
          public          postgres    false    212            �           0    0    prescription_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.prescription_id_seq', 198, true);
          public          postgres    false    247            �           0    0    work_schedule_day_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.work_schedule_day_id_seq', 1, false);
          public          postgres    false    226            �           0    0    work_schedule_interval_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.work_schedule_interval_id_seq', 1, false);
          public          postgres    false    228            R           2606    16497 $   account_details account_details_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_details_pkey PRIMARY KEY (account_details_id);
 N   ALTER TABLE ONLY public.account_details DROP CONSTRAINT account_details_pkey;
       public            postgres    false    197            T           2606    16499 "   account_details account_key_unique 
   CONSTRAINT     d   ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_key_unique UNIQUE (account_key);
 L   ALTER TABLE ONLY public.account_details DROP CONSTRAINT account_key_unique;
       public            postgres    false    197            �           2606    27745     advertisement advertisement_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.advertisement
    ADD CONSTRAINT advertisement_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.advertisement DROP CONSTRAINT advertisement_pkey;
       public            postgres    false    244            X           2606    16518 @   appointment_cancel_reschedule appointment_cancel_reschedule_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT appointment_cancel_reschedule_pkey PRIMARY KEY (appointment_cancel_reschedule_id);
 j   ALTER TABLE ONLY public.appointment_cancel_reschedule DROP CONSTRAINT appointment_cancel_reschedule_pkey;
       public            postgres    false    201            [           2606    16535 0   appointment_doc_config appointment_doc_config_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT appointment_doc_config_id PRIMARY KEY (appointment_doc_config_id);
 Z   ALTER TABLE ONLY public.appointment_doc_config DROP CONSTRAINT appointment_doc_config_id;
       public            postgres    false    203            V           2606    16510    appointment appointment_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.appointment DROP CONSTRAINT appointment_pkey;
       public            postgres    false    199            �           2606    24937 *   communication_type communication_type_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.communication_type
    ADD CONSTRAINT communication_type_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.communication_type DROP CONSTRAINT communication_type_pkey;
       public            postgres    false    239            j           2606    16595 1   doctor_config_can_resch doc_config_can_resch_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.doctor_config_can_resch
    ADD CONSTRAINT doc_config_can_resch_pkey PRIMARY KEY (doc_config_can_resch_id);
 [   ALTER TABLE ONLY public.doctor_config_can_resch DROP CONSTRAINT doc_config_can_resch_pkey;
       public            postgres    false    209            u           2606    24657    doc_config doc_config_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doc_config_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.doc_config DROP CONSTRAINT doc_config_pkey;
       public            postgres    false    220            ^           2606    24683 2   doc_config_schedule_day doc_config_schedule_day_id 
   CONSTRAINT     p   ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_config_schedule_day_id PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.doc_config_schedule_day DROP CONSTRAINT doc_config_schedule_day_id;
       public            postgres    false    204            a           2606    24681 <   doc_config_schedule_interval doc_config_schedule_interval_id 
   CONSTRAINT     z   ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_config_schedule_interval_id PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.doc_config_schedule_interval DROP CONSTRAINT doc_config_schedule_interval_id;
       public            postgres    false    205            l           2606    16606 /   doctor_config_pre_consultation doctor_config_id 
   CONSTRAINT     {   ALTER TABLE ONLY public.doctor_config_pre_consultation
    ADD CONSTRAINT doctor_config_id PRIMARY KEY (doctor_config_id);
 Y   ALTER TABLE ONLY public.doctor_config_pre_consultation DROP CONSTRAINT doctor_config_id;
       public            postgres    false    211            e           2606    16576    doctor doctor_id 
   CONSTRAINT     V   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_id PRIMARY KEY ("doctorId");
 :   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_id;
       public            postgres    false    207            g           2606    16578    doctor doctor_key_unique 
   CONSTRAINT     Y   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_key_unique UNIQUE (doctor_key);
 B   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_key_unique;
       public            postgres    false    207            s           2606    16647    interval_days interval_days_id 
   CONSTRAINT     j   ALTER TABLE ONLY public.interval_days
    ADD CONSTRAINT interval_days_id PRIMARY KEY (interval_days_id);
 H   ALTER TABLE ONLY public.interval_days DROP CONSTRAINT interval_days_id;
       public            postgres    false    215            �           2606    24963 &   message_metadata message_metadata_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_metadata_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.message_metadata DROP CONSTRAINT message_metadata_pkey;
       public            postgres    false    243            �           2606    24920 &   message_template message_template_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.message_template
    ADD CONSTRAINT message_template_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.message_template DROP CONSTRAINT message_template_pkey;
       public            postgres    false    235            �           2606    24945 @   message_template_placeholders message_template_placeholders_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_template_placeholders_pkey PRIMARY KEY (id);
 j   ALTER TABLE ONLY public.message_template_placeholders DROP CONSTRAINT message_template_placeholders_pkey;
       public            postgres    false    241            �           2606    24928    message_type message_type_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.message_type
    ADD CONSTRAINT message_type_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.message_type DROP CONSTRAINT message_type_pkey;
       public            postgres    false    237            ~           2606    24778 &   openvidu_session openvidu_session_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.openvidu_session
    ADD CONSTRAINT openvidu_session_pkey PRIMARY KEY (openvidu_session_id);
 P   ALTER TABLE ONLY public.openvidu_session DROP CONSTRAINT openvidu_session_pkey;
       public            postgres    false    231            �           2606    24791 2   openvidu_session_token openvidu_session_token_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_token_pkey PRIMARY KEY (openvidu_session_token_id);
 \   ALTER TABLE ONLY public.openvidu_session_token DROP CONSTRAINT openvidu_session_token_pkey;
       public            postgres    false    233            w           2606    24699 "   patient_details patient_details_id 
   CONSTRAINT     `   ALTER TABLE ONLY public.patient_details
    ADD CONSTRAINT patient_details_id PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.patient_details DROP CONSTRAINT patient_details_id;
       public            postgres    false    225            �           2606    33471     patient_report patient_report_id 
   CONSTRAINT     ^   ALTER TABLE ONLY public.patient_report
    ADD CONSTRAINT patient_report_id PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.patient_report DROP CONSTRAINT patient_report_id;
       public            postgres    false    248            p           2606    16633    payment_details payment_id 
   CONSTRAINT     X   ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_id PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.payment_details DROP CONSTRAINT payment_id;
       public            postgres    false    213            y           2606    24714 (   work_schedule_day work_schedule_day_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.work_schedule_day
    ADD CONSTRAINT work_schedule_day_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.work_schedule_day DROP CONSTRAINT work_schedule_day_pkey;
       public            postgres    false    227            |           2606    24722 2   work_schedule_interval work_schedule_interval_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT work_schedule_interval_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.work_schedule_interval DROP CONSTRAINT work_schedule_interval_pkey;
       public            postgres    false    229            \           1259    16541    fki_app_doc_con_to_app_id    INDEX     f   CREATE INDEX fki_app_doc_con_to_app_id ON public.appointment_doc_config USING btree (appointment_id);
 -   DROP INDEX public.fki_app_doc_con_to_app_id;
       public            postgres    false    203            Y           1259    16524    fki_can_resch_to_app_id    INDEX     k   CREATE INDEX fki_can_resch_to_app_id ON public.appointment_cancel_reschedule USING btree (appointment_id);
 +   DROP INDEX public.fki_can_resch_to_app_id;
       public            postgres    false    201            m           1259    16607    fki_doc_config_to_doc_key    INDEX     j   CREATE INDEX fki_doc_config_to_doc_key ON public.doctor_config_pre_consultation USING btree (doctor_key);
 -   DROP INDEX public.fki_doc_config_to_doc_key;
       public            postgres    false    211            _           1259    24706    fki_doc_sched_to_doc_id    INDEX     `   CREATE INDEX fki_doc_sched_to_doc_id ON public.doc_config_schedule_day USING btree (doctor_id);
 +   DROP INDEX public.fki_doc_sched_to_doc_id;
       public            postgres    false    204            h           1259    16584    fki_doctor_to_account    INDEX     O   CREATE INDEX fki_doctor_to_account ON public.doctor USING btree (account_key);
 )   DROP INDEX public.fki_doctor_to_account;
       public            postgres    false    207            q           1259    16653    fki_int_days_to_wrk_sched_id    INDEX     ^   CREATE INDEX fki_int_days_to_wrk_sched_id ON public.interval_days USING btree (wrk_sched_id);
 0   DROP INDEX public.fki_int_days_to_wrk_sched_id;
       public            postgres    false    215            b           1259    16563     fki_interval_to_wrk_sched_con_id    INDEX     }   CREATE INDEX fki_interval_to_wrk_sched_con_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");
 4   DROP INDEX public.fki_interval_to_wrk_sched_con_id;
       public            postgres    false    205            c           1259    16564 #   fki_interval_to_wrk_sched_config_id    INDEX     �   CREATE INDEX fki_interval_to_wrk_sched_config_id ON public.doc_config_schedule_interval USING btree ("docConfigScheduleDayId");
 7   DROP INDEX public.fki_interval_to_wrk_sched_config_id;
       public            postgres    false    205            n           1259    16639    fki_payment_to_app_id    INDEX     [   CREATE INDEX fki_payment_to_app_id ON public.payment_details USING btree (appointment_id);
 )   DROP INDEX public.fki_payment_to_app_id;
       public            postgres    false    213            z           1259    24728    fki_workScheduleIntervalToDay    INDEX     r   CREATE INDEX "fki_workScheduleIntervalToDay" ON public.work_schedule_interval USING btree (work_schedule_day_id);
 3   DROP INDEX public."fki_workScheduleIntervalToDay";
       public            postgres    false    229            �           2606    16536 ,   appointment_doc_config app_doc_con_to_app_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.appointment_doc_config
    ADD CONSTRAINT app_doc_con_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);
 V   ALTER TABLE ONLY public.appointment_doc_config DROP CONSTRAINT app_doc_con_to_app_id;
       public          postgres    false    199    203    3926            �           2606    16519 1   appointment_cancel_reschedule can_resch_to_app_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.appointment_cancel_reschedule
    ADD CONSTRAINT can_resch_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);
 [   ALTER TABLE ONLY public.appointment_cancel_reschedule DROP CONSTRAINT can_resch_to_app_id;
       public          postgres    false    201    3926    199            �           2606    24969 &   message_metadata communication_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT communication_type_id FOREIGN KEY (communication_type_id) REFERENCES public.communication_type(id);
 P   ALTER TABLE ONLY public.message_metadata DROP CONSTRAINT communication_type_id;
       public          postgres    false    3974    243    239            �           2606    24684 6   doc_config_schedule_interval doc_sched_interval_to_day    FK CONSTRAINT     �   ALTER TABLE ONLY public.doc_config_schedule_interval
    ADD CONSTRAINT doc_sched_interval_to_day FOREIGN KEY ("docConfigScheduleDayId") REFERENCES public.doc_config_schedule_day(id) NOT VALID;
 `   ALTER TABLE ONLY public.doc_config_schedule_interval DROP CONSTRAINT doc_sched_interval_to_day;
       public          postgres    false    205    204    3934            �           2606    24701 +   doc_config_schedule_day doc_sched_to_doc_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.doc_config_schedule_day
    ADD CONSTRAINT doc_sched_to_doc_id FOREIGN KEY (doctor_id) REFERENCES public.doctor("doctorId") NOT VALID;
 U   ALTER TABLE ONLY public.doc_config_schedule_day DROP CONSTRAINT doc_sched_to_doc_id;
       public          postgres    false    3941    207    204            �           2606    24658    doc_config doctor_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.doc_config
    ADD CONSTRAINT doctor_key FOREIGN KEY (doctor_key) REFERENCES public.doctor(doctor_key);
 ?   ALTER TABLE ONLY public.doc_config DROP CONSTRAINT doctor_key;
       public          postgres    false    3943    220    207            �           2606    16579    doctor doctor_to_account    FK CONSTRAINT     �   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_to_account FOREIGN KEY (account_key) REFERENCES public.account_details(account_key);
 B   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_to_account;
       public          postgres    false    3924    197    207            �           2606    24946 1   message_template_placeholders message_template_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_template_id FOREIGN KEY (message_template_id) REFERENCES public.message_template(id);
 [   ALTER TABLE ONLY public.message_template_placeholders DROP CONSTRAINT message_template_id;
       public          postgres    false    235    241    3970            �           2606    24974 $   message_metadata message_template_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_template_id FOREIGN KEY (message_template_id) REFERENCES public.message_template(id);
 N   ALTER TABLE ONLY public.message_metadata DROP CONSTRAINT message_template_id;
       public          postgres    false    3970    243    235            �           2606    24951 -   message_template_placeholders message_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_template_placeholders
    ADD CONSTRAINT message_type_id FOREIGN KEY (message_type_id) REFERENCES public.message_type(id);
 W   ALTER TABLE ONLY public.message_template_placeholders DROP CONSTRAINT message_type_id;
       public          postgres    false    3972    241    237            �           2606    24964     message_metadata message_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.message_metadata
    ADD CONSTRAINT message_type_id FOREIGN KEY (message_type_id) REFERENCES public.message_type(id);
 J   ALTER TABLE ONLY public.message_metadata DROP CONSTRAINT message_type_id;
       public          postgres    false    237    243    3972            �           2606    24792 *   openvidu_session_token openvidu_session_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.openvidu_session_token
    ADD CONSTRAINT openvidu_session_id FOREIGN KEY (openvidu_session_id) REFERENCES public.openvidu_session(openvidu_session_id);
 T   ALTER TABLE ONLY public.openvidu_session_token DROP CONSTRAINT openvidu_session_id;
       public          postgres    false    231    233    3966            �           2606    16634 !   payment_details payment_to_app_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_to_app_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(id);
 K   ALTER TABLE ONLY public.payment_details DROP CONSTRAINT payment_to_app_id;
       public          postgres    false    213    199    3926            �           2606    24723 0   work_schedule_interval workScheduleIntervalToDay    FK CONSTRAINT     �   ALTER TABLE ONLY public.work_schedule_interval
    ADD CONSTRAINT "workScheduleIntervalToDay" FOREIGN KEY (work_schedule_day_id) REFERENCES public.work_schedule_day(id) NOT VALID;
 \   ALTER TABLE ONLY public.work_schedule_interval DROP CONSTRAINT "workScheduleIntervalToDay";
       public          postgres    false    229    227    3961           