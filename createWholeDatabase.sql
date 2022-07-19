--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Debian 14.4-1.pgdg110+1)
-- Dumped by pg_dump version 14.4 (Ubuntu 14.4-1.pgdg22.04+1)

-- Started on 2022-07-19 16:58:48 +07

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 211 (class 1259 OID 16635)
-- Name: accounts; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    owner character varying NOT NULL,
    balance bigint NOT NULL,
    currency character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.accounts OWNER TO root;

--
-- TOC entry 210 (class 1259 OID 16634)
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO root;

--
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 210
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- TOC entry 213 (class 1259 OID 16645)
-- Name: entries; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.entries (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    amount bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.entries OWNER TO root;

--
-- TOC entry 3369 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN entries.amount; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.entries.amount IS 'can be negative or positive';


--
-- TOC entry 212 (class 1259 OID 16644)
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entries_id_seq OWNER TO root;

--
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 212
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.entries_id_seq OWNED BY public.entries.id;


--
-- TOC entry 209 (class 1259 OID 16386)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    dirty boolean NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO root;

--
-- TOC entry 215 (class 1259 OID 16653)
-- Name: transfers; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transfers (
    id bigint NOT NULL,
    from_account_id bigint NOT NULL,
    to_account_id bigint NOT NULL,
    amount bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.transfers OWNER TO root;

--
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN transfers.amount; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON COLUMN public.transfers.amount IS 'must be positive';


--
-- TOC entry 214 (class 1259 OID 16652)
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfers_id_seq OWNER TO root;

--
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 214
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.transfers_id_seq OWNED BY public.transfers.id;


--
-- TOC entry 216 (class 1259 OID 16737)
-- Name: users; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.users (
    username character varying NOT NULL,
    hashed_password character varying NOT NULL,
    full_name character varying NOT NULL,
    email character varying NOT NULL,
    password_changed_at timestamp with time zone DEFAULT '0001-01-01 00:00:00+00'::timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO root;

--
-- TOC entry 3185 (class 2604 OID 16638)
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- TOC entry 3187 (class 2604 OID 16648)
-- Name: entries id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.entries ALTER COLUMN id SET DEFAULT nextval('public.entries_id_seq'::regclass);


--
-- TOC entry 3189 (class 2604 OID 16656)
-- Name: transfers id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transfers ALTER COLUMN id SET DEFAULT nextval('public.transfers_id_seq'::regclass);


--
-- TOC entry 3357 (class 0 OID 16635)
-- Dependencies: 211
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.accounts (id, owner, balance, currency, created_at) FROM stdin;
8	enbrpq	340	EUR	2022-07-18 08:47:02.177856+00
12	nqhwwd	779	EUR	2022-07-18 08:47:02.185132+00
13	nbzedb	801	EUR	2022-07-18 08:47:02.186405+00
14	soyoph	821	EUR	2022-07-18 08:47:02.187617+00
15	kzqhwp	126	USD	2022-07-18 08:47:02.18895+00
16	fvuxag	809	CAD	2022-07-18 08:47:02.190233+00
18	vgkhgy	477	CAD	2022-07-18 08:47:02.192639+00
19	bnxubf	461	USD	2022-07-18 08:47:02.193797+00
22	frdezw	801	EUR	2022-07-18 08:47:02.199975+00
23	owqmvd	454	EUR	2022-07-18 08:47:02.202672+00
24	ffgsiu	647	EUR	2022-07-18 08:47:02.2056+00
62	tjbees	359	USD	2022-07-18 08:49:02.670313+00
25	hhqcug	59	EUR	2022-07-18 08:47:02.214189+00
26	jncqcq	495	CAD	2022-07-18 08:47:02.215547+00
63	ptngje	285	EUR	2022-07-18 08:49:02.671732+00
64	szwmrh	932	USD	2022-07-18 08:49:02.674135+00
65	rfyukz	335	USD	2022-07-18 08:49:02.675458+00
67	txbdhc	227	CAD	2022-07-18 08:49:02.679387+00
68	jkhgfe	193	USD	2022-07-18 08:49:02.682862+00
69	nrdakv	536	CAD	2022-07-18 08:49:02.684487+00
70	xjknzv	816	CAD	2022-07-18 08:49:02.687799+00
71	syjhbf	123	EUR	2022-07-18 08:49:02.689172+00
72	zsaxww	0	USD	2022-07-18 08:53:10.928175+00
77	ukopcs	389	USD	2022-07-18 09:07:45.347358+00
78	shfafx	205	CAD	2022-07-18 09:07:45.407031+00
79	rdonyd	521	USD	2022-07-18 09:07:45.465427+00
27	krfhcy	159	CAD	2022-07-18 08:47:02.224607+00
28	xpjbhs	55	USD	2022-07-18 08:47:02.226127+00
29	vtnepe	811	CAD	2022-07-18 08:47:02.274611+00
30	yvpxgu	415	USD	2022-07-18 08:47:02.275994+00
31	vrtvaq	722	USD	2022-07-18 08:47:02.27805+00
32	rbcdnm	271	EUR	2022-07-18 08:47:02.27942+00
33	usqihq	770	USD	2022-07-18 08:47:02.281587+00
34	ozwpuz	571	CAD	2022-07-18 08:47:02.282807+00
35	xypqrm	178	CAD	2022-07-18 08:47:02.286042+00
36	bstmrp	248	CAD	2022-07-18 08:47:02.287347+00
37	hhbmsn	260	EUR	2022-07-18 08:47:02.290404+00
38	zsaxww	722	EUR	2022-07-18 08:47:02.291817+00
39	hxonsi	162	USD	2022-07-18 08:49:02.572524+00
40	fyuwxy	400	CAD	2022-07-18 08:49:02.57474+00
41	wjggnc	667	EUR	2022-07-18 08:49:02.577979+00
43	zzyjqn	326	CAD	2022-07-18 08:49:02.583955+00
44	jqngnj	26	CAD	2022-07-18 08:49:02.585298+00
45	rxyavd	543	USD	2022-07-18 08:49:02.586636+00
46	ofmfpt	872	EUR	2022-07-18 08:49:02.588016+00
47	qdiqvu	835	USD	2022-07-18 08:49:02.591725+00
48	nmrawd	216	USD	2022-07-18 08:49:02.59354+00
49	mxckug	475	USD	2022-07-18 08:49:02.595338+00
50	pzfceg	814	EUR	2022-07-18 08:49:02.596927+00
51	bnxyii	151	EUR	2022-07-18 08:49:02.598243+00
52	hpfsse	421	EUR	2022-07-18 08:49:02.599517+00
53	mcpgyz	409	USD	2022-07-18 08:49:02.601151+00
55	qqxxpn	805	USD	2022-07-18 08:49:02.605302+00
56	ocaose	477	CAD	2022-07-18 08:49:02.608257+00
57	qhnrii	351	EUR	2022-07-18 08:49:02.61172+00
81	mifsjw	200	USD	2022-07-18 09:07:45.584181+00
58	ehvnyu	24	CAD	2022-07-18 08:49:02.620261+00
59	aywirt	907	EUR	2022-07-18 08:49:02.621559+00
82	jvmjxb	219	EUR	2022-07-18 09:07:45.640088+00
83	xmtbet	984	USD	2022-07-18 09:07:45.696992+00
84	rbyuwy	891	EUR	2022-07-18 09:07:45.760966+00
85	vbwrex	889	CAD	2022-07-18 09:07:45.822531+00
86	axptyc	923	USD	2022-07-18 09:07:45.884825+00
87	ojabpz	666	USD	2022-07-18 09:07:45.9426+00
88	ffhjzc	41	EUR	2022-07-18 09:07:46.001201+00
89	fzodjt	977	CAD	2022-07-18 09:07:46.05921+00
90	itsryg	871	CAD	2022-07-18 09:07:46.116696+00
91	nwtrpm	291	USD	2022-07-18 09:07:46.177058+00
92	mvvriy	841	CAD	2022-07-18 09:07:46.240722+00
93	xninbu	840	USD	2022-07-18 09:07:46.302611+00
94	cwuopw	339	USD	2022-07-18 09:07:46.36509+00
95	kogjgk	37	USD	2022-07-18 09:07:46.426879+00
104	qpuour	208	USD	2022-07-18 09:07:47.007967+00
105	qpcskr	115	USD	2022-07-18 09:07:47.083051+00
60	dewxmr	933	EUR	2022-07-18 08:49:02.632038+00
106	iaaxww	565	USD	2022-07-18 09:07:47.147287+00
107	drgubq	808	USD	2022-07-18 09:07:47.208818+00
96	dvwutm	342	EUR	2022-07-18 09:07:46.493246+00
97	jxomew	885	CAD	2022-07-18 09:07:46.552907+00
108	ypcftq	389	CAD	2022-07-18 09:07:47.269436+00
109	oihfhn	128	CAD	2022-07-18 09:07:47.328959+00
10	bneuoy	686	CAD	2022-07-18 08:47:02.182424+00
11	ikyemx	665	CAD	2022-07-18 08:47:02.183775+00
98	tmapzp	658	CAD	2022-07-18 09:07:46.621893+00
99	bkdubh	313	USD	2022-07-18 09:07:46.682637+00
100	rsaftj	687	USD	2022-07-18 09:07:46.763948+00
101	uaywxd	426	USD	2022-07-18 09:07:46.824529+00
102	xhzisd	635	CAD	2022-07-18 09:07:46.885622+00
103	ebuqdg	567	EUR	2022-07-18 09:07:46.945672+00
\.


--
-- TOC entry 3359 (class 0 OID 16645)
-- Dependencies: 213
-- Data for Name: entries; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.entries (id, account_id, amount, created_at) FROM stdin;
3	22	69980	2022-07-18 08:47:02.200635+00
5	24	90392	2022-07-18 08:47:02.206249+00
6	24	85710	2022-07-18 08:47:02.2069+00
7	24	42196	2022-07-18 08:47:02.207584+00
8	24	80071	2022-07-18 08:47:02.208338+00
9	24	48590	2022-07-18 08:47:02.209053+00
10	24	40389	2022-07-18 08:47:02.209763+00
11	24	33850	2022-07-18 08:47:02.210471+00
12	24	7765	2022-07-18 08:47:02.211155+00
13	24	61039	2022-07-18 08:47:02.211863+00
14	24	60494	2022-07-18 08:47:02.212556+00
15	25	-10	2022-07-18 08:47:02.216159+00
16	26	10	2022-07-18 08:47:02.216159+00
17	25	-10	2022-07-18 08:47:02.220296+00
18	26	10	2022-07-18 08:47:02.220296+00
19	27	-10	2022-07-18 08:47:02.226844+00
20	28	-10	2022-07-18 08:47:02.226824+00
21	28	10	2022-07-18 08:47:02.226844+00
22	27	10	2022-07-18 08:47:02.226824+00
23	27	-10	2022-07-18 08:47:02.257761+00
24	28	10	2022-07-18 08:47:02.257761+00
25	27	-10	2022-07-18 08:47:02.260016+00
26	27	-10	2022-07-18 08:47:02.261677+00
27	28	-10	2022-07-18 08:47:02.260325+00
28	28	10	2022-07-18 08:47:02.260016+00
29	28	10	2022-07-18 08:47:02.261677+00
30	27	10	2022-07-18 08:47:02.260325+00
31	28	-10	2022-07-18 08:47:02.26231+00
32	27	10	2022-07-18 08:47:02.26231+00
33	27	-10	2022-07-18 08:47:02.264852+00
34	28	10	2022-07-18 08:47:02.264852+00
35	28	-10	2022-07-18 08:47:02.263102+00
36	27	10	2022-07-18 08:47:02.263102+00
37	28	-10	2022-07-18 08:47:02.266783+00
38	27	10	2022-07-18 08:47:02.266783+00
39	53	90776	2022-07-18 08:49:02.60177+00
41	55	83286	2022-07-18 08:49:02.606024+00
43	57	92919	2022-07-18 08:49:02.612353+00
44	57	58730	2022-07-18 08:49:02.613036+00
45	57	18191	2022-07-18 08:49:02.613818+00
46	57	93709	2022-07-18 08:49:02.614473+00
47	57	22249	2022-07-18 08:49:02.6151+00
48	57	14725	2022-07-18 08:49:02.615716+00
49	57	90663	2022-07-18 08:49:02.616365+00
50	57	79850	2022-07-18 08:49:02.617041+00
51	57	57138	2022-07-18 08:49:02.617705+00
52	57	59065	2022-07-18 08:49:02.618401+00
53	58	-10	2022-07-18 08:49:02.622141+00
54	59	10	2022-07-18 08:49:02.622141+00
55	58	-10	2022-07-18 08:49:02.626147+00
56	59	10	2022-07-18 08:49:02.626147+00
57	60	-10	2022-07-18 08:49:02.63462+00
60	60	10	2022-07-18 08:49:02.634304+00
61	60	-10	2022-07-18 08:49:02.642164+00
63	60	10	2022-07-18 08:49:02.642116+00
65	60	10	2022-07-18 08:49:02.643678+00
66	60	-10	2022-07-18 08:49:02.642899+00
70	60	10	2022-07-18 08:49:02.646153+00
71	60	-10	2022-07-18 08:49:02.646475+00
73	60	10	2022-07-18 08:49:02.644762+00
74	60	-10	2022-07-18 08:49:02.643732+00
77	91	25114	2022-07-18 09:07:46.177745+00
78	92	7524	2022-07-18 09:07:46.241578+00
79	93	39256	2022-07-18 09:07:46.303429+00
81	95	18106	2022-07-18 09:07:46.427602+00
82	95	83428	2022-07-18 09:07:46.428278+00
83	95	6999	2022-07-18 09:07:46.428954+00
84	95	67736	2022-07-18 09:07:46.429593+00
85	95	10313	2022-07-18 09:07:46.430231+00
86	95	94953	2022-07-18 09:07:46.430875+00
87	95	46264	2022-07-18 09:07:46.431607+00
88	95	19974	2022-07-18 09:07:46.432272+00
89	95	6532	2022-07-18 09:07:46.432962+00
90	95	27276	2022-07-18 09:07:46.433595+00
91	96	-10	2022-07-18 09:07:46.553745+00
92	97	10	2022-07-18 09:07:46.553745+00
93	96	-10	2022-07-18 09:07:46.558176+00
94	97	10	2022-07-18 09:07:46.558176+00
95	99	-10	2022-07-18 09:07:46.683806+00
96	99	-10	2022-07-18 09:07:46.683825+00
97	98	10	2022-07-18 09:07:46.683806+00
98	98	10	2022-07-18 09:07:46.683825+00
99	98	-10	2022-07-18 09:07:46.690301+00
100	99	10	2022-07-18 09:07:46.690301+00
101	98	-10	2022-07-18 09:07:46.691278+00
102	99	10	2022-07-18 09:07:46.691278+00
103	98	-10	2022-07-18 09:07:46.693004+00
104	99	10	2022-07-18 09:07:46.693004+00
105	99	-10	2022-07-18 09:07:46.693141+00
106	98	-10	2022-07-18 09:07:46.694378+00
107	99	-10	2022-07-18 09:07:46.694508+00
108	98	10	2022-07-18 09:07:46.693141+00
109	98	10	2022-07-18 09:07:46.694508+00
110	99	-10	2022-07-18 09:07:46.695357+00
111	98	-10	2022-07-18 09:07:46.694578+00
112	98	10	2022-07-18 09:07:46.695357+00
113	99	10	2022-07-18 09:07:46.694578+00
114	99	10	2022-07-18 09:07:46.694378+00
115	11	-100	2022-07-19 09:26:32.996155+00
116	10	100	2022-07-19 09:26:32.996155+00
\.


--
-- TOC entry 3355 (class 0 OID 16386)
-- Dependencies: 209
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.schema_migrations (version, dirty) FROM stdin;
2	f
\.


--
-- TOC entry 3361 (class 0 OID 16653)
-- Dependencies: 215
-- Data for Name: transfers; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.transfers (id, from_account_id, to_account_id, amount, created_at) FROM stdin;
1	25	26	10	2022-07-18 08:47:02.216159+00
2	25	26	10	2022-07-18 08:47:02.220296+00
3	27	28	10	2022-07-18 08:47:02.226844+00
4	28	27	10	2022-07-18 08:47:02.226824+00
5	27	28	10	2022-07-18 08:47:02.257761+00
6	28	27	10	2022-07-18 08:47:02.260325+00
7	27	28	10	2022-07-18 08:47:02.260016+00
8	27	28	10	2022-07-18 08:47:02.261677+00
9	28	27	10	2022-07-18 08:47:02.26231+00
10	27	28	10	2022-07-18 08:47:02.264852+00
11	28	27	10	2022-07-18 08:47:02.263102+00
12	28	27	10	2022-07-18 08:47:02.266783+00
13	29	30	81897	2022-07-18 08:47:02.276684+00
14	31	32	46773	2022-07-18 08:47:02.280108+00
15	33	34	71526	2022-07-18 08:47:02.283451+00
17	37	38	41021	2022-07-18 08:47:02.292524+00
18	37	38	56615	2022-07-18 08:47:02.293185+00
19	37	38	23908	2022-07-18 08:47:02.293866+00
20	37	38	93345	2022-07-18 08:47:02.294555+00
21	37	38	24394	2022-07-18 08:47:02.295222+00
22	37	38	58376	2022-07-18 08:47:02.295941+00
23	37	38	18860	2022-07-18 08:47:02.296565+00
24	37	38	29548	2022-07-18 08:47:02.297194+00
25	37	38	9029	2022-07-18 08:47:02.297826+00
26	37	38	48560	2022-07-18 08:47:02.298455+00
27	58	59	10	2022-07-18 08:49:02.622141+00
28	58	59	10	2022-07-18 08:49:02.626147+00
39	62	63	58498	2022-07-18 08:49:02.672486+00
40	64	65	63590	2022-07-18 08:49:02.676206+00
43	70	71	76817	2022-07-18 08:49:02.689856+00
44	70	71	19798	2022-07-18 08:49:02.690571+00
45	70	71	56742	2022-07-18 08:49:02.691374+00
46	70	71	43976	2022-07-18 08:49:02.692049+00
47	70	71	72798	2022-07-18 08:49:02.692691+00
48	70	71	49177	2022-07-18 08:49:02.693376+00
49	70	71	84704	2022-07-18 08:49:02.69406+00
50	70	71	51062	2022-07-18 08:49:02.694749+00
51	70	71	60523	2022-07-18 08:49:02.695685+00
52	70	71	23694	2022-07-18 08:49:02.696366+00
53	96	97	10	2022-07-18 09:07:46.553745+00
54	96	97	10	2022-07-18 09:07:46.558176+00
55	99	98	10	2022-07-18 09:07:46.683806+00
56	99	98	10	2022-07-18 09:07:46.683825+00
57	98	99	10	2022-07-18 09:07:46.690301+00
58	98	99	10	2022-07-18 09:07:46.691278+00
59	98	99	10	2022-07-18 09:07:46.693004+00
61	98	99	10	2022-07-18 09:07:46.694378+00
60	99	98	10	2022-07-18 09:07:46.693141+00
62	99	98	10	2022-07-18 09:07:46.694508+00
63	99	98	10	2022-07-18 09:07:46.695357+00
64	98	99	10	2022-07-18 09:07:46.694578+00
65	100	101	3402	2022-07-18 09:07:46.825459+00
66	102	103	29817	2022-07-18 09:07:46.946456+00
67	104	105	75546	2022-07-18 09:07:47.085016+00
69	108	109	38285	2022-07-18 09:07:47.329654+00
70	108	109	64107	2022-07-18 09:07:47.330294+00
71	108	109	94849	2022-07-18 09:07:47.330956+00
72	108	109	1378	2022-07-18 09:07:47.331595+00
73	108	109	57036	2022-07-18 09:07:47.332263+00
74	108	109	80720	2022-07-18 09:07:47.332936+00
75	108	109	49386	2022-07-18 09:07:47.333536+00
76	108	109	55223	2022-07-18 09:07:47.334245+00
77	108	109	93885	2022-07-18 09:07:47.335071+00
78	108	109	22532	2022-07-18 09:07:47.335925+00
79	11	10	10	2022-07-19 09:23:44.208677+00
80	11	10	100	2022-07-19 09:26:32.996155+00
\.


--
-- TOC entry 3362 (class 0 OID 16737)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.users (username, hashed_password, full_name, email, password_changed_at, created_at) FROM stdin;
jysopq	secret	wqqydk	kbhvft@email.com	0001-01-01 00:00:00+00	2022-07-18 08:45:12.369906+00
jzfnwm	secret	drdmwy	mjdwio@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.173154+00
qmnaec	secret	bwskkc	mpaotp@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.175604+00
enbrpq	secret	bwobve	spekto@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.17718+00
ycuaxt	secret	dytvdd	bgwozk@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.179293+00
bneuoy	secret	qnxpdh	yzoraw@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.181752+00
ikyemx	secret	irguzq	tetzje@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.183128+00
nqhwwd	secret	phvgwn	zqyyyz@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.184513+00
nbzedb	secret	qcqdon	nwodnx@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.185793+00
soyoph	secret	pawqrg	qnzfro@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.186985+00
kzqhwp	secret	mhasnn	phwddm@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.188288+00
fvuxag	secret	xxbbob	xisnai@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.189616+00
biashp	secret	eybuvy	gawqvh@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.190855+00
vgkhgy	secret	vaivqm	wrxqkq@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.192029+00
bnxubf	secret	gaqaef	ozrxyz@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.193246+00
gusfmk	secret	iiqipe	ppooib@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.194798+00
rpjber	secret	ktstqk	iwkikp@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.197132+00
frdezw	secret	zfgvkh	btkbjv@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.199308+00
owqmvd	secret	bkjwon	xrjeno@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.202019+00
ffgsiu	secret	woxtvt	yspkso@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.204923+00
hhqcug	secret	qdyamq	dxsagc@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.21346+00
jncqcq	secret	nqphys	epdcih@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.214945+00
krfhcy	secret	jfbkyc	jwqkby@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.223859+00
xpjbhs	secret	trohns	wamxbq@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.225447+00
vtnepe	secret	krgjtt	swguvx@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.273797+00
yvpxgu	secret	jeuzij	cuficv@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.275347+00
vrtvaq	secret	tqzvhd	gbvvjo@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.277404+00
rbcdnm	secret	ichojh	acxzve@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.278771+00
usqihq	secret	syibdn	iedzut@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.28096+00
ozwpuz	secret	pfknri	ydkxgi@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.282209+00
xypqrm	secret	mtcbzy	wyxqyu@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.285408+00
bstmrp	secret	snbbyy	ohigep@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.2867+00
hhbmsn	secret	efzmqh	thhszp@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.28968+00
zsaxww	secret	azmesa	nmpwvd@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.291135+00
wfcgbo	secret	ekfrff	wfgxgz@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.299426+00
yqkuzi	secret	cpykpv	ppswia@email.com	0001-01-01 00:00:00+00	2022-07-18 08:47:02.300083+00
hxonsi	secret	qgbbhd	ijbktf@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.571461+00
fyuwxy	secret	usvyuo	dskrab@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.57381+00
wjggnc	secret	defaam	xozyzd@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.577079+00
sbffhz	secret	gpfiox	opmbxe@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.580235+00
zzyjqn	secret	cwczzm	oztnyq@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.583319+00
jqngnj	secret	jfzrnp	ktadhz@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.584644+00
rxyavd	secret	uwarpe	smrmdv@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.586+00
ofmfpt	secret	usyuyr	tzgtfo@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.587273+00
qdiqvu	secret	jcysoe	pindxb@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.588932+00
nmrawd	secret	ebsgqk	rhkiam@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.592697+00
mxckug	secret	ummymm	abmytg@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.594382+00
pzfceg	secret	xpwddk	rmdmgd@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.596231+00
bnxyii	secret	ddtvym	tmhrwc@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.597628+00
hpfsse	secret	umfuus	abrazs@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.598917+00
mcpgyz	secret	pefwtb	urmgyy@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.600537+00
qqxxpn	secret	ucpape	vjnuso@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.604683+00
ocaose	secret	euhnka	nxonci@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.607601+00
qhnrii	secret	kxgyua	hheorj@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.61107+00
ehvnyu	secret	wionxw	whktvg@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.619598+00
aywirt	secret	gtzgjr	nqnieu@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.620956+00
dewxmr	secret	vcjkxh	fbbjef@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.631289+00
tjbees	secret	soepxr	yyjyko@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.66962+00
ptngje	secret	tjxbxa	ghxhhh@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.671048+00
szwmrh	secret	mxqtpc	gzgsip@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.67331+00
rfyukz	secret	syoiwy	upcztp@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.674828+00
txbdhc	secret	tezabi	epsajs@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.67872+00
jkhgfe	secret	nosyzn	bgwzmi@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.68212+00
nrdakv	secret	sumxkx	nixfma@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.683583+00
xjknzv	secret	ehbjwk	jsyjva@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.68715+00
syjhbf	secret	mrgpdu	ydoqwb@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.688503+00
hzgycv	secret	bfvgpi	aixcxi@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.697581+00
ttdjvc	secret	cecapv	acesej@email.com	0001-01-01 00:00:00+00	2022-07-18 08:49:02.698529+00
ukopcs	$2a$10$K/F89.i7w79U8BgKIh3WNO4LSDx9S9O8XzRkNcVrgNF2ZwTOOvfii	dwycxj	ekknga@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.346325+00
shfafx	$2a$10$XGsyQRwIuYN5TLGRARG86u1ZkjtaVzp3IjoICvpigwrYivlU9Ppl6	abhgjg	swaonw@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.40624+00
rdonyd	$2a$10$xqPPzSrlr3lY6wh3Q2n/TOKFspb39OhOKLm6uv0YFMUOxPGMOnG2.	iycrqh	krujgz@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.464406+00
mifsjw	$2a$10$YNFsUmd1bwA4irAD5jnt3ehMyMMf5dETgNo5.DxFu0w3VzziuipxG	jmntxa	csfkuo@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.583186+00
jvmjxb	$2a$10$2jC3c5GJFJiwJe/6Gm/U5ejg5A7N1uQZdxkyCcAik0x.oLIZ3jl2G	jshdni	ykctms@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.639153+00
xmtbet	$2a$10$n5VLq3r.gQEbpCff0Fu6..khX8JyC9u17EZyy0m6uBr22q2odN4ka	jzscui	injgjg@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.695846+00
rbyuwy	$2a$10$YhTeUnrg5e8uwO6ZQhnm..PucPHxtYSm4if/Nop2PAzRRYQYj6lla	ocwqwf	bvjbnm@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.760025+00
vbwrex	$2a$10$Se7/NpOe4y3PLx.MBKjiDuEyUlmnSAxhKmMZASp.tpn4fFSLazVHO	obhfsr	wnyovu@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.821421+00
axptyc	$2a$10$kMSMmNaHeh0lQOwVyzb80.qNs8ww.c6MKnLV1SDJYrBMQCneq6Naq	mbyjbt	foqrcz@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.883988+00
ojabpz	$2a$10$zYdwlFCmKM4wD.Kpoj1DeOfiy0wkaIwO2UVNVyn53OrIevJhFpB8K	ivbsuh	bzpkbo@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:45.941478+00
ffhjzc	$2a$10$CwUH46mOgyLXOC8rVDzFq.QM/QShqHao0XLxbGxvs1APSgCQGJkMG	fgwzym	sfnccy@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.000116+00
fzodjt	$2a$10$yiXo4v2uBww7UeKUeS.mD.qY/WkZfsp38NhzUC9dJ9Va8NEPSWFiW	tappyd	ktmjqo@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.058358+00
itsryg	$2a$10$ezK4Ot5ZHkUClBXqeRN5RuVWDmmaNTksbxMkEK1R2RgHc71T7NUJm	jcojoq	omzzpa@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.115782+00
nwtrpm	$2a$10$k1Pg5dr2bCcakv/1fXyQZeixxJ8ZB1xymKZZQ2i/l3.ZjcQtsUmUS	omwwho	ortgmm@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.176292+00
mvvriy	$2a$10$siH1abkGtvHfUqMLfABHHus/rgn8PPY5f5AReDkq6YFFPBCeeFjIq	gmpjjb	xuzxtc@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.238072+00
xninbu	$2a$10$naTJpIxgOZa5t3bO4YG5EetA5oOtudcuCnDloPkR0G62ugwZ1LH7q	nbvmuu	fccsvi@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.30167+00
cwuopw	$2a$10$hynkxGBSrMkQ0309U5hVSuJ3yxTPwYb/slQGrp7u01LtoDzG6lMtW	uqmboh	pcezjh@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.364088+00
kogjgk	$2a$10$ozbjoNCUZk92.oYn4K3Kw.6owPE1qzSFa0E.MtJ/nPKsA4rFH2zgq	imbmry	kqnfiw@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.426034+00
dvwutm	$2a$10$/GLp7J3QWRak/2EnKmJ9z.D4bjDc/aMDIfXFylc2bszuaHw5TWzyu	xyrawg	vnzpdh@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.492277+00
jxomew	$2a$10$UKabZJQFCXlr9NOxzNoC9O3X0XrCFNXiHE9YzBglNVXIupvZOqmPS	wowebe	rggths@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.551803+00
tmapzp	$2a$10$42n8iDHZqFd.9O9r8FzSXusWuQOSlIVQI1qRbw.27VWLUynDxiAqG	cgftka	rypitu@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.620966+00
bkdubh	$2a$10$0vhWo1ufzOHpMmdC0sqLpeD4/BHo9MdC.DpgNTDkWhNE2z4Uu9TNm	qrnruu	iqqdrf@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.681777+00
rsaftj	$2a$10$I0J5M.9YqkMTN6VURUD3nOMvlxJjNKaZSC2LgRsIq/1BG5ybjMPaS	axawpn	tcxkgz@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.763035+00
uaywxd	$2a$10$f4QbmAjO4tXZcCKhOUdLy.exeNrHWZvBbFXDCX.LU90v9HmehMa5O	swwdjo	vmonwj@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.823541+00
xhzisd	$2a$10$Iml6Mgu18RLIiihNao5cVuHKlcdpHOEuVFNFZ/Tea8EbtFwz96H4.	kwrcyw	tdjbqp@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.884262+00
ebuqdg	$2a$10$k9Aq0wLxbeV1gCBNgDFce.5r9LxgpjO0HViZ9O4O5TzfMaShY4VLW	pwbmjm	cykquq@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:46.944802+00
qpuour	$2a$10$bUhRxOZ2JezZdcmW9gfOMeyBJNmwFpcGsBqqmi/0NIjyrrRCDF3O2	cbhshj	dongcg@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:47.006761+00
qpcskr	$2a$10$16FgCVXCy1WX8d2cw2PEMeex7vlkd8gVLNcmOMYI7oqAO.E0qO22G	odywcp	hghhun@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:47.081994+00
iaaxww	$2a$10$auP26XwN74gVoDf9wh0p0OO7MQ/ILnKhNbedV5wGDY/TUVVaPxWSa	thycdh	tbzjqt@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:47.14645+00
drgubq	$2a$10$DO34oDHv/sk3ebfiQRE8V.b/YX9DYt.XGoAE37h4F1ZCG9fTfy2z.	hpbuep	kfnwiy@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:47.207774+00
ypcftq	$2a$10$5655v9zff95avTm0uJoavuw7lQdL1EU188BqYk4Hz35IsShVWi0hi	tmcwro	acxhfj@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:47.26852+00
oihfhn	$2a$10$YQiOaRYasRBP0g2FicYzAeoA3Ooe.WKC4USXTi62RkkWD4sBlsGV2	dnvkei	fnagyu@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:47.328049+00
tjdnhc	$2a$10$NhgRkp0H35eviYVVsqgZ7.PZHxcTwruNHK4TW3AwgcMZSUB/.gaYy	hgyowh	gjhzic@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:47.394474+00
ozcmun	$2a$10$MDXWBFW4UOI6pGupu6Jw3O693PfSylmnY7E08/YvtsoxW5m4MyjnW	vcxrqa	qfpemj@email.com	0001-01-01 00:00:00+00	2022-07-18 09:07:47.453688+00
huuloc	$2a$10$gBQ.EZpBjsxKk6SZMILVoOS.Qedxuq9u.P7piaIyBR08/.DzOLYhy	huynh huu loc	loc@email.com	0001-01-01 00:00:00+00	2022-07-18 09:20:35.201482+00
huuloc123	$2a$10$byE5kVT5CNrBwW1yA0AAWeUxaLe2lGB1DyPkgOdeFkEYOn2r3/KL6	huynh huu loc	loc123@email.com	0001-01-01 00:00:00+00	2022-07-18 09:27:24.771222+00
\.


--
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 210
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.accounts_id_seq', 109, true);


--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 212
-- Name: entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.entries_id_seq', 116, true);


--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 214
-- Name: transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.transfers_id_seq', 80, true);


--
-- TOC entry 3197 (class 2606 OID 16643)
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 3202 (class 2606 OID 16651)
-- Name: entries entries_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- TOC entry 3199 (class 2606 OID 16754)
-- Name: accounts owner_currency_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT owner_currency_key UNIQUE (owner, currency);


--
-- TOC entry 3194 (class 2606 OID 16390)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 3206 (class 2606 OID 16659)
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- TOC entry 3209 (class 2606 OID 16747)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3211 (class 2606 OID 16745)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (username);


--
-- TOC entry 3195 (class 1259 OID 16660)
-- Name: accounts_owner_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX accounts_owner_idx ON public.accounts USING btree (owner);


--
-- TOC entry 3200 (class 1259 OID 16661)
-- Name: entries_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX entries_account_id_idx ON public.entries USING btree (account_id);


--
-- TOC entry 3203 (class 1259 OID 16662)
-- Name: transfers_from_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transfers_from_account_id_idx ON public.transfers USING btree (from_account_id);


--
-- TOC entry 3204 (class 1259 OID 16664)
-- Name: transfers_from_account_id_to_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transfers_from_account_id_to_account_id_idx ON public.transfers USING btree (from_account_id, to_account_id);


--
-- TOC entry 3207 (class 1259 OID 16663)
-- Name: transfers_to_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transfers_to_account_id_idx ON public.transfers USING btree (to_account_id);


--
-- TOC entry 3212 (class 2606 OID 16748)
-- Name: accounts accounts_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_owner_fkey FOREIGN KEY (owner) REFERENCES public.users(username);


--
-- TOC entry 3213 (class 2606 OID 16665)
-- Name: entries entries_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- TOC entry 3214 (class 2606 OID 16670)
-- Name: transfers transfers_from_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_from_account_id_fkey FOREIGN KEY (from_account_id) REFERENCES public.accounts(id);


--
-- TOC entry 3215 (class 2606 OID 16675)
-- Name: transfers transfers_to_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_to_account_id_fkey FOREIGN KEY (to_account_id) REFERENCES public.accounts(id);


-- Completed on 2022-07-19 16:58:48 +07

--
-- PostgreSQL database dump complete
--

