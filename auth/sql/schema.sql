--To Create the dump file from PG-ADMIN use Format:"Plain", Enable:"Pre-data", "Data", "Post-data", "Use Column Inserts", "Use Insert Commands"
-- PostgreSQL database dump
--
-- TOC entry 196 (class 1259 OID 16664)
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    account_id integer NOT NULL,
    no_of_users bigint NOT NULL,
    sub_start_date date NOT NULL,
    sub_end_date date NOT NULL,
    account_key character varying(200) NOT NULL,
    account_name character varying(100),
    updated_time timestamp without time zone,
    updated_user bigint,
    is_active boolean
);


ALTER TABLE public.account OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16725)
-- Name: account_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_account_id_seq OWNER TO postgres;

--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 200
-- Name: account_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_account_id_seq OWNED BY public.account.account_id;


--
-- TOC entry 197 (class 1259 OID 16677)
-- Name: patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient (
    patient_id integer NOT NULL,
    phone character varying(100) NOT NULL,
    password character varying(200) NOT NULL,
    salt character varying(100)
);


ALTER TABLE public.patient OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16729)
-- Name: patient_login_patient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_login_patient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patient_login_patient_id_seq OWNER TO postgres;

--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 201
-- Name: patient_login_patient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_login_patient_id_seq OWNED BY public.patient.patient_id;


--
-- TOC entry 205 (class 1259 OID 24608)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying,
    description character varying
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 24606)
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 204
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- TOC entry 202 (class 1259 OID 16731)
-- Name: player_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.player_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.player_id_seq OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 24619)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    "roleId" integer,
    "permissionId" integer
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 24617)
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 206
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- TOC entry 198 (class 1259 OID 16684)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    roles_id integer NOT NULL,
    roles character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16733)
-- Name: roles_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_roles_id_seq OWNER TO postgres;

--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 203
-- Name: roles_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_roles_id_seq OWNED BY public.roles.roles_id;


--
-- TOC entry 209 (class 1259 OID 24737)
-- Name: user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint
);


ALTER TABLE public.user_role OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 24735)
-- Name: user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_role_id_seq OWNER TO postgres;

--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 208
-- Name: user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_role_id_seq OWNED BY public.user_role.id;


--
-- TOC entry 199 (class 1259 OID 16689)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(250) NOT NULL,
    email character varying(250) NOT NULL,
    password character varying(250) NOT NULL,
    salt character varying(250),
    account_id bigint,
    doctor_key character varying(200),
    is_active boolean,
    updated_time time without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3719 (class 2604 OID 16747)
-- Name: account account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account ALTER COLUMN account_id SET DEFAULT nextval('public.account_account_id_seq'::regclass);


--
-- TOC entry 3720 (class 2604 OID 16749)
-- Name: patient patient_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient ALTER COLUMN patient_id SET DEFAULT nextval('public.patient_login_patient_id_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 24611)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3723 (class 2604 OID 24622)
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- TOC entry 3721 (class 2604 OID 16750)
-- Name: roles roles_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN roles_id SET DEFAULT nextval('public.roles_roles_id_seq'::regclass);


--
-- TOC entry 3724 (class 2604 OID 24740)
-- Name: user_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role ALTER COLUMN id SET DEFAULT nextval('public.user_role_id_seq'::regclass);


--
-- TOC entry 3868 (class 0 OID 16664)
-- Dependencies: 196
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (1, 6, '2020-02-03', '2020-02-03', 'Acc_1', 'Apollo Hospitals', NULL, NULL, NULL);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (2, 6, '2020-02-03', '2020-02-03', 'Acc_2', 'Dr Kamashi Memorial Hospital', NULL, NULL, NULL);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (3, 6, '2020-02-03', '2020-02-03', 'Acc_3', 'Dr Mehtas Hospital', NULL, NULL, NULL);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (4, 6, '2020-02-03', '2020-02-03', 'Acc_4', 'HCG Cancer Center', NULL, NULL, NULL);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (5, 6, '2020-02-03', '2020-02-03', 'Acc_5', 'Kauvery Hospital', NULL, NULL, NULL);
INSERT INTO public.account (account_id, no_of_users, sub_start_date, sub_end_date, account_key, account_name, updated_time, updated_user, is_active) VALUES (6, 6, '2020-02-03', '2020-02-03', 'Acc_6', 'Frontier Lifeline Hospital', NULL, NULL, NULL);


--
-- TOC entry 3869 (class 0 OID 16677)
-- Dependencies: 197
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (1, '9999999994', '$2b$10$AkjqDNrqBZPcNf3PP0.5/.wuXo01ol1./N.FnarBp4SdSCamdkdKS', '$2b$10$AkjqDNrqBZPcNf3PP0.5/.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (2, '9999999994', '$2b$10$5FIBLAhc8ZWPzzT3MVYNK.lur.6976HnuXQT.DrvNrM1ciey6FZ92', '$2b$10$5FIBLAhc8ZWPzzT3MVYNK.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (3, '9999999995', '$2b$10$Wek0rqGs9QkvLOyLvdz8X.dv87RD6UTr8tvuOQfTC/H8v.hM7Cd62', '$2b$10$Wek0rqGs9QkvLOyLvdz8X.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (4, '9999999995', '$2b$10$0GbIZnsPXhUJTX/EDIFGPuz0QcUI34m18emSQSnxxne1VzwcyfUCa', '$2b$10$0GbIZnsPXhUJTX/EDIFGPu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (5, '9999999996', '$2b$10$uURxkKPBX0sjopE6lfQwHeEZgUmhyAZqMb5NskDI8D.UkZAcbU0du', '$2b$10$uURxkKPBX0sjopE6lfQwHe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (6, '9999999992', '$2b$10$TP2dB6oh4oPiYDfUl/OJXu56LbgEj9w1G7LDHsE87pI8i4W0LrtjS', '$2b$10$TP2dB6oh4oPiYDfUl/OJXu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (7, '9999999992', '$2b$10$OKQ4DUQ67bukOaioxkK/pekQdo3E/pQgEJmSMk5zjoETc.L3luOty', '$2b$10$OKQ4DUQ67bukOaioxkK/pe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (8, '9999999992', '$2b$10$AMhkZkRI5Lo/HtFjJSqps.3hSK5CYRqmBf/yJ8GsRZV.Gls0Xr6su', '$2b$10$AMhkZkRI5Lo/HtFjJSqps.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (9, '9999999992', '$2b$10$oxEda8foMQw2QqCaCxM3felfd3KBuyGPrT6R85i4t3al5gFzI0Q3O', '$2b$10$oxEda8foMQw2QqCaCxM3fe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (10, '9999999982', '$2b$10$0aWK5LCkLqhXU7ZuuBip1OkcnJ0PWUBnz6YQ5HW1tg4nfvIgJ/b8K', '$2b$10$0aWK5LCkLqhXU7ZuuBip1O');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (11, '9999999982', '$2b$10$yPx8lb3i8iiDAX3NZW5qWurw9paZuY9i6e9v5IGkQ5JBS5eHJvcrC', '$2b$10$yPx8lb3i8iiDAX3NZW5qWu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (12, '9999999982', '$2b$10$8y3jhizfqwBVO/GQgD7B8OUAHkMIuXJyagn1q/zm7U2XZQoMjrUvK', '$2b$10$8y3jhizfqwBVO/GQgD7B8O');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (13, '9999999982', '$2b$10$s3lAaudz4J8Hjv6VOmYQk.jRamLw.peKdV1F.EwKy2oGWIpfR/Xy6', '$2b$10$s3lAaudz4J8Hjv6VOmYQk.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (14, '9999999982', '$2b$10$SjUd61A5Lzu3UU1jgEge7.tLcelOuZQ4HOF2VgZ8HYLLSp9bPPeie', '$2b$10$SjUd61A5Lzu3UU1jgEge7.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (15, '9999999982', '$2b$10$myIBzMa2/GMfrmGLxG0j5.WOsnB71T3pvWRTCCB0W4QvmBlUSRSYW', '$2b$10$myIBzMa2/GMfrmGLxG0j5.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (16, '9999999982', '$2b$10$YfHL0T9hVZaSBiPNBk32lOPXXOGItGKtSEzlKZpWyW.8va9J1Vfsa', '$2b$10$YfHL0T9hVZaSBiPNBk32lO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (17, '9999999982', '$2b$10$DvbTmMrREeo2HkTAp/bnA.4sxTtaMg/Z94KXLTC9P2hHXr88atrYG', '$2b$10$DvbTmMrREeo2HkTAp/bnA.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (18, '9999999982', '$2b$10$7SrFxxTUQHwAZFMcBN6XsuSuoQ8GZOv9YYEjLcEeSUyO7juMrOwf6', '$2b$10$7SrFxxTUQHwAZFMcBN6Xsu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (19, '9999999982', '$2b$10$4gMudTMve9w8XiPTTSurEeK/rxJQh6q//Bl9O9D7yT8MmjBwuTYp6', '$2b$10$4gMudTMve9w8XiPTTSurEe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (20, '9999999982', '$2b$10$d9VTNkhCyp6Os0FwImrMhOyE2qaY9FePY8SXLqLLDkwH2JBYcbaIO', '$2b$10$d9VTNkhCyp6Os0FwImrMhO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (21, '9999999982', '$2b$10$BimWh3GvukHzBAYIlZGCbOdbx0BMSVwWowaNmSvcvs6sRkTwVWuTO', '$2b$10$BimWh3GvukHzBAYIlZGCbO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (22, '9999999982', '$2b$10$xF9EerYBJjTtyXyL.1qPxu2sHACLzkUROYe3fE1/54UruQqZXcCVy', '$2b$10$xF9EerYBJjTtyXyL.1qPxu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (23, '9999999982', '$2b$10$FCDrKClhzWJyzItBESEEhuYJ55j1VWWBectw6xHVFbhTRREtHYSJi', '$2b$10$FCDrKClhzWJyzItBESEEhu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (24, '9999999982', '$2b$10$XOXFR1WRw1fCBo1opxH8SuVYhSSXvslU6dmEZRsWofRfAvro7DMNe', '$2b$10$XOXFR1WRw1fCBo1opxH8Su');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (25, '9999999992', '$2b$10$AYxoA9uekhyWfEQrSt.T0OCwmG4gI2mbs4SyPRfxh.spp0nwXX/B.', '$2b$10$AYxoA9uekhyWfEQrSt.T0O');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (26, '9999999992', '$2b$10$e0aKlLwJgPFftM4ZUo9r3OSEYAYEx/caHESwEm7CySmsCd2tjavHm', '$2b$10$e0aKlLwJgPFftM4ZUo9r3O');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (27, '9999999992', '$2b$10$8Nx7PigpU46CKQT3RZfWYev31B7lAwF.K3sbFN62tlFSFjt9dX3x6', '$2b$10$8Nx7PigpU46CKQT3RZfWYe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (28, '9999999992', '$2b$10$XXngOXEGRVD5I/slueiTkOsXWCO9Qz1aXZCzMzkRtpg2Ibmbf2mCW', '$2b$10$XXngOXEGRVD5I/slueiTkO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (29, '9999999992', '$2b$10$X76Z5OflIkVMt7zF8CPMjeEnERtzuIx7VVIXu2uVxW2gS7YFSScOu', '$2b$10$X76Z5OflIkVMt7zF8CPMje');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (30, '9999999992', '$2b$10$upakEsRq6bN.9zquu50gfexfXXYLumrPS2eMFGc1VLJgjun6QtB5q', '$2b$10$upakEsRq6bN.9zquu50gfe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (31, '9999999992', '$2b$10$0JEZaIsixsHfBAnOuQDdxeSMSiuPNJCb6DnZcDDSWp4DLRbqz2u/6', '$2b$10$0JEZaIsixsHfBAnOuQDdxe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (32, '9999999992', '$2b$10$Ky5gwXTzOpuIqBojnTnkT.YAzotzW3I6f9DO7BZGwWTTPclBn.HLu', '$2b$10$Ky5gwXTzOpuIqBojnTnkT.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (33, '9999999992', '$2b$10$vd/aYiiJpQcZLC7bbecUV.Mt4Y4RMWbwUGpy5Bo.ExukZ6q9lGEWm', '$2b$10$vd/aYiiJpQcZLC7bbecUV.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (34, '9999999992', '$2b$10$HS0F96ibu2/D4cOxEn8.rOuN6EjacJ40tamNkRyQYtJbClShQV7d6', '$2b$10$HS0F96ibu2/D4cOxEn8.rO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (35, '9999999992', '$2b$10$fhuxDS61BblMbF3JJ8QMt.KL0GrdUcPLPwYj8QKySs1borwKafFoC', '$2b$10$fhuxDS61BblMbF3JJ8QMt.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (36, '9999999992', '$2b$10$ZWJHo/y4vgSxUfgNXlP0qehSs0ByHA4bSea5Gmu.qA8nwg/e03mmq', '$2b$10$ZWJHo/y4vgSxUfgNXlP0qe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (37, '9999999992', '$2b$10$k3p4ENthET7Y2yOrAO6mmeIJ./xvKqhoOCSCgeUBz8iZ2Km5iwIhC', '$2b$10$k3p4ENthET7Y2yOrAO6mme');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (38, '9999999992', '$2b$10$dUgDWPClinj9zxYlkAxJUevMPL7iW5SxYjnVZ17xI9y9h7fl6v5Ru', '$2b$10$dUgDWPClinj9zxYlkAxJUe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (39, '9999999992', '$2b$10$4S.DjIBGpJIFidpmr2RbzeXR3O/cEWDu87E0VlnSm57u4NpeVkjiC', '$2b$10$4S.DjIBGpJIFidpmr2Rbze');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (40, '9999999992', '$2b$10$HQVDhdxISq702.PkUydpOeyaoQiFcMBVnUHEnu22Dc4n353sZ51vy', '$2b$10$HQVDhdxISq702.PkUydpOe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (41, '9999999992', '$2b$10$./hIb9r1AX1HwvBShf4koeKd2vewzEZPkdEEKdPRMBUydHuo6P8om', '$2b$10$./hIb9r1AX1HwvBShf4koe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (42, '9999999992', '$2b$10$.KpxfXoeE1We40vNGrCJxOQsukytHIflxK/wMZ.FW5Wniz.m/kt5O', '$2b$10$.KpxfXoeE1We40vNGrCJxO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (43, '9999999992', '$2b$10$Z/JnoZqLdQog73mlTeLszOK8VQPDICChA5qto91CAH5PwM4rCln3S', '$2b$10$Z/JnoZqLdQog73mlTeLszO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (44, '9999999992', '$2b$10$nR2ZIOYLW5m7SihYkXRYxO57YRZE1XL453j1bY4.sIY9IqVn4FAGS', '$2b$10$nR2ZIOYLW5m7SihYkXRYxO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (45, '9999999992', '$2b$10$lr7MTSvJGaobn.l5N.HyyetFA9r5yBV3M1o1huEVwrKCb3BggYriK', '$2b$10$lr7MTSvJGaobn.l5N.Hyye');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (46, '9999999992', '$2b$10$BDkLaklEbF2b.YHzc0b6LOXz6pJiYemPa2XPxBYGEKfjXPUqLL6Ua', '$2b$10$BDkLaklEbF2b.YHzc0b6LO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (47, '9999999992', '$2b$10$1Tybcfr5PB7gJy1cgJnfA.sU1GFbWmokXxWYe4lAhze4NvdT9pFFy', '$2b$10$1Tybcfr5PB7gJy1cgJnfA.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (48, '9999999992', '$2b$10$P4gByxFZYWZTcvJsRy55ZOd3fHEp9bwyCKyPjObXQS4En9JkVnqWS', '$2b$10$P4gByxFZYWZTcvJsRy55ZO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (49, '9999999992', '$2b$10$43WY8iXfI1nDqNZ/HwRePuqnJZ9jlL484QNPaCvIkNehq4.t18p6a', '$2b$10$43WY8iXfI1nDqNZ/HwRePu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (50, '9999999992', '$2b$10$iPTg4csyDIzzuEd./fAGou9DNADplQ0sSGBysLXo2PxXykrzPUpIm', '$2b$10$iPTg4csyDIzzuEd./fAGou');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (51, '9999999992', '$2b$10$aRP5ibF/XdZH2k9LFtBZ9eAy4hx/wnZ7cAhZ58SQYtbGQV92ADyFm', '$2b$10$aRP5ibF/XdZH2k9LFtBZ9e');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (52, '9999999992', '$2b$10$RJNXCUbIR3XciEoFNPuxNOUvdLJ96JG/.D4DHLut4aMoW3oUGicrm', '$2b$10$RJNXCUbIR3XciEoFNPuxNO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (53, '9999999992', '$2b$10$dKPmYavNDMxhgEk03vRNd.8B87WvlqJoo6EzCAvtvzhOWw3H8s6bS', '$2b$10$dKPmYavNDMxhgEk03vRNd.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (54, '9999999992', '$2b$10$BW2rovV77fcZtJCIXCg8yeTuOKWBjnPE8krTz8/.IE3bumRpZ80lu', '$2b$10$BW2rovV77fcZtJCIXCg8ye');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (55, '9999999992', '$2b$10$Z.oFMPZf3v305xq/JiVo8OiaIUm4Hh7FqNE5DnCSFwEHuYmiKv7Lq', '$2b$10$Z.oFMPZf3v305xq/JiVo8O');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (56, '9999999992', '$2b$10$hWlqGTZnWL.NQYaqyzs3A.n8fLAwTVSDd0.pGVr73tCekevqFFSDK', '$2b$10$hWlqGTZnWL.NQYaqyzs3A.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (57, '9999999992', '$2b$10$i/S1S7LXlX.jLF9S8Hc6Ne.ejvD.Qsvpa0c1vzLEvJFAjO6rAkBni', '$2b$10$i/S1S7LXlX.jLF9S8Hc6Ne');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (58, '9999999992', '$2b$10$tapqbhwlCHPT04BIEc3OIOgPzmDpE1zlra2WgayKzt8CT4cQ8L56m', '$2b$10$tapqbhwlCHPT04BIEc3OIO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (59, '9999999992', '$2b$10$SXkBk.SFfxk1dQUFwZmaVu.pvR4v5Z/3pIkCmiu91VWc95p3KoXvq', '$2b$10$SXkBk.SFfxk1dQUFwZmaVu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (60, '9999999992', '$2b$10$RcIcpAS0IduWaZey56AhNe3bOjplSRfUY6y3XWcP76Z3hQKTJ3TL6', '$2b$10$RcIcpAS0IduWaZey56AhNe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (61, '9999999992', '$2b$10$CZITQ1Bf2B4NdP58OC6aJuQE4I/At8XywkPGAMhHshpeSF0I3YULe', '$2b$10$CZITQ1Bf2B4NdP58OC6aJu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (62, '9999999992', '$2b$10$qgxyYcrLIGSwIE.IMO1koe2GxOmESTwKB2K5pGuWihCAGLN3gBqhC', '$2b$10$qgxyYcrLIGSwIE.IMO1koe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (63, '9999999992', '$2b$10$VuzBXyJtf3C3uFwEmVbdKOBB0xKMUBCH9KRxxdAe.1d7ei4Necniu', '$2b$10$VuzBXyJtf3C3uFwEmVbdKO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (64, '9999999992', '$2b$10$CopioVKvXm3o1RhmqORjV.yKRC0qTTVtlnUwSlM7s6YzZXCitvyG2', '$2b$10$CopioVKvXm3o1RhmqORjV.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (65, '9999999992', '$2b$10$x.3tu4h6wNSbChiYU1EnjuxbUIph5tphDJ97ccmEfKPRG3bBTJ/aK', '$2b$10$x.3tu4h6wNSbChiYU1Enju');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (66, '9999999992', '$2b$10$ILhI6UgjNZndWwsMsThrGexZcpgkMaU6boeDZIFedmAXu78TM1uY2', '$2b$10$ILhI6UgjNZndWwsMsThrGe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (67, '9999999992', '$2b$10$U5yNHzmSqR1uHZBOdBbA4etWhdMguaz1ZSbj4RCj.Hn5ZTMVMJuhO', '$2b$10$U5yNHzmSqR1uHZBOdBbA4e');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (68, '9999999992', '$2b$10$qSJDHrGNovQSf.8/sbb/guuPAKLqAYD2AiTNtHMjxymtZKLvMR1qG', '$2b$10$qSJDHrGNovQSf.8/sbb/gu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (69, '9999988992', '$2b$10$ZlEQhmFoZUtGo4PmZ9F9y.iqIZbDxsriMhHJTRNjixESmTnEnpXNS', '$2b$10$ZlEQhmFoZUtGo4PmZ9F9y.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (70, '9999988992', '$2b$10$1N8pvUGy5UMSdoFs2l0ZSey3l/bzgayMasKc5Y/Bp4F69K3SwVXuy', '$2b$10$1N8pvUGy5UMSdoFs2l0ZSe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (71, '9999988992', '$2b$10$qoI/GOr1pia3r7RG3uPd8eHbjy.kLuWkxMKg3HBYOG1ysb6CdMTBe', '$2b$10$qoI/GOr1pia3r7RG3uPd8e');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (72, '9999988992', '$2b$10$jH53jcKfOdHDOXt7mbrQ8OwsF8loE6bbI4ZeF0.2xOj/7bjNVZOwO', '$2b$10$jH53jcKfOdHDOXt7mbrQ8O');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (73, '9999988992', '$2b$10$jAO1PQHUv4D/XlzPtoNeWuJPSRbYXNCAVyO1giUW2EE4yJgJ1Lryi', '$2b$10$jAO1PQHUv4D/XlzPtoNeWu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (74, '9999988992', '$2b$10$YYbIB2vbb2bcKJbqY4nlQuSxmEBs2unuiriezpbmBDvjqQMnI5ROK', '$2b$10$YYbIB2vbb2bcKJbqY4nlQu');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (75, '9999988992', '$2b$10$pcMm4b9M6a6fOa4AovPgnO/TtXTUmOaBELebI64C9xbfsp/w0SZee', '$2b$10$pcMm4b9M6a6fOa4AovPgnO');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (76, '9999988992', '$2b$10$cNl2UIyZBJhdGmuxSBM4a.hNKfWh/tfvFDfNg3sqkFGO7xmxcRpJ6', '$2b$10$cNl2UIyZBJhdGmuxSBM4a.');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (77, '9999999992', '$2b$10$2IDXlmo34gRVRShs5JolAeNThC083DSeYByATC0aAW1HZhBB4d8HK', '$2b$10$2IDXlmo34gRVRShs5JolAe');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (78, '9999999992', '$2b$10$XhDdpSXj/qUAeb9lgot20Opsv.ly7jc1j/aG3JqQF8MszwMapAO3G', '$2b$10$XhDdpSXj/qUAeb9lgot20O');
INSERT INTO public.patient (patient_id, phone, password, salt) VALUES (79, '9999999992', '$2b$10$B/NTGwQE7gwNi7rnmYp6qecI/2EI6n3oBmATQcOtD8S.kpnBZRuPu', '$2b$10$B/NTGwQE7gwNi7rnmYp6qe');


--
-- TOC entry 3877 (class 0 OID 24608)
-- Dependencies: 205
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.permissions (id, name, description) VALUES (1, 'SELF_APPOINTMENT_READ', 'SELF_APPOINTMENT_READ');
INSERT INTO public.permissions (id, name, description) VALUES (2, 'SELF_APPOINTMENT_WRITE', 'SELF_APPOINTMENT_WRITE');
INSERT INTO public.permissions (id, name, description) VALUES (3, 'SELF_USER_CONFIG_READ', 'SELF_USER_CONFIG_READ');
INSERT INTO public.permissions (id, name, description) VALUES (4, 'SELF_USER_CONFIG_WRITE', 'SELF_USER_CONFIG_WRITE');
INSERT INTO public.permissions (id, name, description) VALUES (5, 'REPORTS', 'REPORTS');
INSERT INTO public.permissions (id, name, description) VALUES (6, 'ACCOUNT_SETTINGS_READ', 'ACCOUNT_SETTINGS_READ');
INSERT INTO public.permissions (id, name, description) VALUES (7, 'ACCOUNT_SETTINGS_WRITE', 'ACCOUNT_SETTINGS_WRITE');
INSERT INTO public.permissions (id, name, description) VALUES (8, 'ACCOUNT_USERS_CONFIG_READ', 'ACCOUNT_USERS_CONFIG_READ');
INSERT INTO public.permissions (id, name, description) VALUES (9, 'ACCOUNT_USERS_CONFIG_WRITE', 'ACCOUNT_USERS_CONFIG_WRITE');
INSERT INTO public.permissions (id, name, description) VALUES (10, 'ACCOUNT_USERS_APPOINTMENT_READ', 'ACCOUNT_USERS_APPOINTMENT_READ');
INSERT INTO public.permissions (id, name, description) VALUES (11, 'ACCOUNT_USERS_APPOINTMENT_WRITE', 'ACCOUNT_USERS_APPOINTMENT_WRITE');
INSERT INTO public.permissions (id, name, description) VALUES (12, 'CUSTOMER', 'CUSTOMER');


--
-- TOC entry 3879 (class 0 OID 24619)
-- Dependencies: 207
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (1, 2, 1);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (2, 2, 2);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (3, 2, 3);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (4, 2, 4);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (5, 2, 6);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (6, 2, 8);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (7, 2, 10);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (8, 1, 5);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (9, 1, 6);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (10, 1, 7);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (11, 1, 8);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (12, 1, 9);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (13, 1, 10);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (14, 1, 11);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (15, 3, 6);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (16, 3, 8);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (17, 3, 10);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (18, 3, 11);
INSERT INTO public.role_permissions (id, "roleId", "permissionId") VALUES (19, 4, 12);


--
-- TOC entry 3870 (class 0 OID 16684)
-- Dependencies: 198
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles (roles_id, roles) VALUES (1, 'ADMIN');
INSERT INTO public.roles (roles_id, roles) VALUES (2, 'DOCTOR');
INSERT INTO public.roles (roles_id, roles) VALUES (3, 'DOC_ASSISTANT');
INSERT INTO public.roles (roles_id, roles) VALUES (4, 'PATIENT');


--
-- TOC entry 3881 (class 0 OID 24737)
-- Dependencies: 209
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_role (id, user_id, role_id) VALUES (1, 28, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (2, 29, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (3, 30, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (4, 31, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (5, 32, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (6, 33, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (7, 34, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (8, 35, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (9, 36, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (10, 37, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (11, 38, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (12, 39, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (13, 40, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (14, 41, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (15, 42, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (16, 43, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (17, 44, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (18, 45, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (19, 46, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (20, 47, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (21, 48, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (22, 49, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (23, 50, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (24, 51, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (25, 52, 2);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (26, 53, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (27, 54, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (28, 55, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (29, 56, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (30, 57, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (31, 58, 1);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (32, 59, 3);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (33, 60, 4);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (34, 61, 4);
INSERT INTO public.user_role (id, user_id, role_id) VALUES (35, 62, 4);


--
-- TOC entry 3871 (class 0 OID 16689)
-- Dependencies: 199
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (60, 'Nirmala Seetharaman', 'nirmala@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', NULL, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (54, 'T.G.Govindarajan', 'govindarajan@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 2, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (55, 'A.J.Mehta', 'mehta@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 3, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (56, 'B.S.Ajay Kumar', 'ajaykumar@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 4, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (57, 'S.Manivannan', 'manivannan@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 5, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (28, 'Adithya K', 'adithya@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_1', true, '16:11:11.550643');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (29, '"Prof Narendranath Kanna"', 'narendranath@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_2', true, '16:12:32.045519');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (32, 'Shalini shetty', 'test@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_5', true, '15:15:08.858754');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (61, 'Ashok Gajapathi raj', 'ashok@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', NULL, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (62, 'Shrushti Jayanth Deshmukh', 'shrushti@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', NULL, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (58, 'K.M.Cherian', 'cherian@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 6, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (30, 'Sheetal Desai', 'sheetal@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_3', true, '16:13:12.897447');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (53, 'Suneeta Reddy', 'admin2@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 1, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (43, 'Mahesh umar N Upasani', 'maheshkumar@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 4, 'Doc_16', true, '15:53:41.215366');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (31, ' Sree Kumar Reddy', 'sreekumarreddy@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_4', true, '16:14:28.233564');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (33, 'Sreeram Valluri', 'sreeram@apollo.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 1, 'Doc_6', true, '15:30:16.748709');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (34, 'Indhumathi R', 'indhumathir@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 2, 'Doc_7', true, '16:15:33.148347');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (36, 'Rajeshwari Ramachandran ', 'rajeshwari@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 2, 'Doc_9', true, '15:34:46.074008');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (37, 'Vijay Iyer', 'vijayiyer@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 2, 'Doc_10', true, '15:36:38.248111');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (38, 'Usha Shukla', 'ushashukla@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_11', true, '15:38:49.742536');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (39, 'Sarala Rajajee', 'saralarajajee@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_12', true, '15:48:30.22789');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (40, 'Parthasarathy Srinivasan', 'parthasarathy@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_13', true, '15:49:27.060239');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (41, 'K Kalai Selvi', 'kalaiselvi@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_14', true, '15:51:40.72794');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (42, 'S Jayaraman', 'jayaraman@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 3, 'Doc_15', true, '15:52:42.953132');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (44, 'Balaji J', 'balajij@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 4, 'Doc_17', true, '15:54:40.46253');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (45, 'Murugesh DMRT', 'murugesh@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 4, 'Doc_18', true, '15:56:17.651105');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (46, 'Mohammed Ibrahim', 'mohammedibrahim@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 4, 'Doc_19', true, '15:57:26.370248');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (47, 'Aravindan Selvaraj', 'aravindanselvaraj@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 5, 'Doc_20', true, '15:58:45.623112');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (35, 'Kumar Thulasi Dass', 'thulasidass@gmail.com', '123456', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 2, 'Doc_8', true, '16:16:03.452535');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (59, 'Doctor Assistant', 'docassistant2@gmail.com', '$2b$10$wU7YwEwHmAwdJ84zafLWU.etBElvlN4Nzq4J12gx/EeCykq4IY6Pu', '$2b$10$wU7YwEwHmAwdJ84zafLWU.', 1, NULL, NULL, NULL);
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (48, 'Bala Murali', 'balamurali@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 5, 'Doc_21', true, '15:59:35.223995');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (49, 'Raghavan Subramaniyan', 'raghavansubramaniyan@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 6, 'Doc_22', true, '16:01:30.394299');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (50, 'Anto Sahayaraj', 'antosahayaraj@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 6, 'Doc_23', true, '16:02:31.236272');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (51, 'Sowmya Ramanan V', 'sowmyaramananv@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 6, 'Doc_24', true, '16:03:37.305415');
INSERT INTO public.users (id, name, email, password, salt, account_id, doctor_key, is_active, updated_time) VALUES (52, 'Balaji Srimurugan', 'balajisrimurugan@gmail.com', '$2b$10$JGdUPwCYPtdme.LDkHJzuOMEwLXeCxHCbq028DniNeALB4PALLhQC', '$2b$10$JGdUPwCYPtdme.LDkHJzuO', 6, 'Doc_25', true, '16:04:43.54432');


--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 200
-- Name: account_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_account_id_seq', 1, false);


--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 201
-- Name: patient_login_patient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_login_patient_id_seq', 79, true);


--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 204
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 11, true);


--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 202
-- Name: player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.player_id_seq', 28, true);


--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 206
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_permissions_id_seq', 9, true);


--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 203
-- Name: roles_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_roles_id_seq', 1, false);


--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 208
-- Name: user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_role_id_seq', 35, true);


--
-- TOC entry 3726 (class 2606 OID 16701)
-- Name: account account_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_id PRIMARY KEY (account_id);


--
-- TOC entry 3728 (class 2606 OID 16705)
-- Name: patient patient_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_id PRIMARY KEY (patient_id);


--
-- TOC entry 3737 (class 2606 OID 24616)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3741 (class 2606 OID 24624)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3730 (class 2606 OID 16707)
-- Name: roles roles_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_id PRIMARY KEY (roles_id);


--
-- TOC entry 3743 (class 2606 OID 24742)
-- Name: user_role user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);


--
-- TOC entry 3733 (class 2606 OID 16709)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3735 (class 2606 OID 16711)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3738 (class 1259 OID 24754)
-- Name: fki_permissionId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_permissionId" ON public.role_permissions USING btree ("permissionId");


--
-- TOC entry 3739 (class 1259 OID 24748)
-- Name: fki_roleId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_roleId" ON public.role_permissions USING btree ("roleId");


--
-- TOC entry 3731 (class 1259 OID 16713)
-- Name: fki_user_to_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_user_to_account ON public.users USING btree (account_id);


--
-- TOC entry 3746 (class 2606 OID 24749)
-- Name: role_permissions permissionId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "permissionId" FOREIGN KEY ("permissionId") REFERENCES public.permissions(id) NOT VALID;


--
-- TOC entry 3745 (class 2606 OID 24743)
-- Name: role_permissions roleId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "roleId" FOREIGN KEY ("roleId") REFERENCES public.roles(roles_id) NOT VALID;


--
-- TOC entry 3744 (class 2606 OID 16719)
-- Name: users user_to_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_to_account FOREIGN KEY (account_id) REFERENCES public.account(account_id) NOT VALID;


--
-- PostgreSQL database dump complete
--

