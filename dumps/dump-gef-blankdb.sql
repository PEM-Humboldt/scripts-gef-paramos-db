--
-- PostgreSQL database dump
--

-- Dumped from database version 14.17 (Ubuntu 14.17-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 17.0

-- Started on 2025-04-21 16:14:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE gef;
--
-- TOC entry 3451 (class 1262 OID 16385)
-- Name: gef; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE gef WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';


ALTER DATABASE gef OWNER TO postgres;

\connect gef

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3452 (class 0 OID 0)
-- Dependencies: 3451
-- Name: DATABASE gef; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE gef IS 'Base de datos proyecto GEF-P';


--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3453 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 844 (class 1247 OID 16397)
-- Name: cataloguer; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.cataloguer AS ENUM (
    'ceiba',
    'geonetwork',
    'biocultural'
);


ALTER TYPE public.cataloguer OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 25630)
-- Name: biocultural_accion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_accion (
    idactor character varying(128) NOT NULL,
    idaccion character varying(128),
    acciongeneral character varying(128),
    rolespecifico character varying(128),
    estrategiadeaccion character varying(128),
    objetodeinteres character varying(128),
    especiedeinteres character varying(128),
    ecosistemaincidido character varying(128),
    inicio character varying(128),
    fin character varying(128),
    personacompiladora character varying(128),
    fechacompilacion character varying(128),
    correocompilador character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_accion OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 25616)
-- Name: biocultural_actor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_actor (
    idactor character varying(128) NOT NULL,
    nombreactor character varying(128),
    sigla character varying(128),
    tipoorganizacion character varying(128),
    dependencia character varying(128),
    mision character varying(128),
    etnia character varying(128),
    condicionpoblacion character varying(128),
    ocupacionsocioeconomica character varying(128),
    ambitogeograficoactuacion character varying(128),
    ubicaciondepartamental character varying(128),
    ubicacionmunicipal character varying(128),
    ubicacionveredal character varying(128),
    localidadubicacion character varying(128),
    latituddecimal character varying(128),
    longituddecimal character varying(128),
    sistemacoordenadas character varying(128),
    sistemareferenciaespacial character varying(128),
    personacompiladora character varying(128),
    fechacompilacion character varying(128),
    correocompilador character varying(128),
    fuenteinformacion character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_actor OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25644)
-- Name: biocultural_conflict; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_conflict (
    idconflicto character varying(128) NOT NULL,
    nombrecsa character varying(128),
    causa character varying(128),
    objetodisputa character varying(128),
    tipoconflicto character varying(128),
    expresionesvisibles character varying(128),
    impactoambiental character varying(128),
    impactosocial character varying(128),
    impactocultural character varying(128),
    impactoeconomico character varying(128),
    resumen character varying(128),
    iniciocsa character varying(128),
    hitos character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_conflict OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 25623)
-- Name: biocultural_directory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_directory (
    idactor character varying(128) NOT NULL,
    personacontacto character varying(128),
    temadependencia character varying(128),
    genero character varying(128),
    telefono character varying(128),
    correoelectronico character varying(128),
    paginaweb character varying(128),
    personaenlaceiavh character varying(128),
    fechaultimocontacto character varying(128),
    personacompiladora character varying(128),
    fechacompilacion character varying(128),
    correocompilador character varying(128),
    fuenteinformacion character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_directory OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 25651)
-- Name: biocultural_implication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_implication (
    idconflicto character varying(128) NOT NULL,
    idactor character varying(128),
    nombreactor character varying(128),
    sigla character varying(128),
    territorialidadimplicada character varying(128),
    afectacionactor character varying(128),
    ubicaciondepartamental character varying(128),
    ubicacionmunicipal character varying(128),
    ubicacionveredal character varying(128),
    localidadubicacion character varying(128),
    latitud character varying(128),
    longitud character varying(128),
    sistemacoordenadas character varying(128),
    sistemareferenciaespacial character varying(128),
    personacompiladora character varying(128),
    fechacompilacion character varying(128),
    correocompilador character varying(128),
    fuenteinformacion character varying(128),
    actividadidentifcainformacion character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_implication OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25658)
-- Name: biocultural_interactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_interactions (
    idactora character varying(128) NOT NULL,
    nombreactora character varying(128),
    idactorb character varying(128),
    nombreactorb character varying(128),
    relaciona_b character varying(128),
    relacionb_a character varying(128),
    motivovinculo character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_interactions OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 25637)
-- Name: biocultural_locality; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_locality (
    idaccion character varying(128) NOT NULL,
    departamento character varying(128),
    municipio character varying(128),
    vereda character varying(128),
    localidad character varying(128),
    latitud character varying(128),
    longitud character varying(128),
    sistemacoordenadas character varying(128),
    sistemareferenciaespacial character varying(128),
    personacompiladora character varying(128),
    fechacompilacion character varying(128),
    correocompilador character varying(128),
    fuenteinformacion character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_locality OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25672)
-- Name: biocultural_practice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_practice (
    idproceso character varying(128) NOT NULL,
    idpractica character varying(128),
    narrativa character varying(128),
    verbonivel1 character varying(128),
    quenivel2 character varying(128),
    recursonivel3 character varying(128),
    atributo character varying(128),
    condicionesacceso character varying(128),
    beneficiosgenerados character varying(128),
    actoresinvolucrados character varying(128),
    herramientassociotecnicas character varying(128),
    conflictos character varying(128),
    personacompiladora character varying(128),
    fechacompilacion character varying(128),
    correocompilador character varying(128),
    fuenteinformacion character varying(128),
    actividadidentifcainformacion character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_practice OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25665)
-- Name: biocultural_process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_process (
    idproceso character varying(128) NOT NULL,
    nombreproceso character varying(128),
    tipoprocesoorganizativo character varying(128),
    areaincidencia character varying(128),
    ecosistemaestrategico character varying(128),
    historiaproceso character varying(128),
    personacompiladora character varying(128),
    fechacompilacion character varying(128),
    correocompilador character varying(128),
    fuenteinformacion character varying(128),
    actividadidentifcainformacion character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_process OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25721)
-- Name: biocultural_survey; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biocultural_survey (
    codigo_id character varying(128) NOT NULL,
    nombre character varying(128),
    organizacion character varying(128),
    perfil character varying(128),
    edad character varying(128),
    genero character varying(128),
    departamento character varying(128),
    municipio character varying(128),
    sector character varying(128),
    fecha character varying(128),
    hora character varying(128),
    contacto character varying(128),
    formato character varying(128),
    entrevistador character varying(128),
    compilador character varying(128),
    altitud character varying(128),
    latitud_decimal character varying(128),
    longitud_decimal character varying(128),
    sistema_referencia_espacial character varying(128),
    incertidumbre_coordenadas_metros character varying(128),
    precision_coordenadas character varying(128),
    resource_id integer
);


ALTER TABLE public.biocultural_survey OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25793)
-- Name: ceiba_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ceiba_event (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    eventid character varying(1000) NOT NULL,
    eventtype character varying(1000),
    institutioncode character varying(1000),
    institutionid character varying(1000),
    samplingprotocol character varying(1000) NOT NULL,
    samplesizevalue character varying(1000),
    samplesizeunit character varying(1000),
    samplingeffort character varying(1000),
    eventdate character varying(1000) NOT NULL,
    eventtime character varying(1000),
    habitat character varying(1000),
    eventremarks character varying(1000),
    continent character varying(1000),
    country character varying(1000) NOT NULL,
    countrycode character varying(1000),
    stateprovince character varying(1000),
    county character varying(1000),
    municipality character varying(1000),
    locality character varying(1000),
    minimumelevationinmeters character varying(1000),
    maximumelevationinmeters character varying(1000),
    locationremarks character varying(1000),
    verbatimlatitude character varying(1000),
    verbatimlongitude character varying(1000),
    decimallatitude character varying(1000) NOT NULL,
    decimallongitude character varying(1000) NOT NULL,
    geodeticdatum character varying(1000),
    coordinateuncertaintyinmeters character varying(1000)
);


ALTER TABLE public.ceiba_event OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25792)
-- Name: ceiba_event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ceiba_event ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ceiba_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 25779)
-- Name: ceiba_occurrence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ceiba_occurrence (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    occurrenceid character varying(1000) NOT NULL,
    basisofrecord character varying(1000) NOT NULL,
    type character varying(1000) DEFAULT 'PreservedSpecimen'::character varying NOT NULL,
    institutioncode character varying(1000) NOT NULL,
    institutionid character varying(1000) DEFAULT '000.000.000-0'::character varying NOT NULL,
    recordnumber character varying(1000),
    recordedby character varying(1000),
    individualcount character varying(1000),
    organismquantity character varying(1000),
    organismquantitytype character varying(1000),
    sex character varying(1000),
    lifestage character varying(1000),
    occurrencestatus character varying(1000),
    preparations character varying(1000),
    disposition character varying(1000),
    occurrenceremarks character varying(1000),
    eventid character varying(1000),
    eventtype character varying(1000),
    samplingprotocol character varying(1000),
    samplingeffort character varying(1000),
    eventdate character varying(1000),
    eventtime character varying(1000),
    habitat character varying(1000),
    eventremarks character varying(1000),
    continent character varying(1000),
    country character varying(1000) NOT NULL,
    countrycode character varying(1000),
    stateprovince character varying(1000),
    county character varying(1000),
    municipality character varying(1000),
    locality character varying(1000),
    minimumelevationinmeters character varying(1000),
    maximumelevationinmeters character varying(1000),
    locationremarks character varying(1000),
    verbatimlatitude character varying(1000),
    verbatimlongitude character varying(1000),
    decimallatitude character varying(1000),
    decimallongitude character varying(1000),
    geodeticdatum character varying(1000),
    coordinateuncertaintyinmeters character varying(1000),
    identifiedby character varying(1000),
    dateidentified character varying(1000),
    identificationremarks character varying(1000),
    identificationqualifier character varying(1000),
    scientificname character varying(1000) NOT NULL,
    scientificnameauthorship character varying(1000),
    kingdom character varying(1000),
    phylum character varying(1000),
    class character varying(1000),
    "order" character varying(1000),
    superfamily character varying(1000),
    family character varying(1000),
    subfamily character varying(1000),
    tribe character varying(1000),
    subtribe character varying(1000),
    genus character varying(1000),
    subgenus character varying(1000),
    specificepithet character varying(1000),
    infraspecificepithet character varying(1000),
    taxonrank character varying(1000) NOT NULL,
    vernacularname character varying(1000),
    taxonremarks character varying(1000)
);


ALTER TABLE public.ceiba_occurrence OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25778)
-- Name: ceiba_ocurrence_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ceiba_occurrence ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ceiba_ocurrence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 212 (class 1259 OID 16428)
-- Name: geonetwork_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geonetwork_data (
    geographical_id integer NOT NULL,
    resource_id integer NOT NULL,
    original_data text NOT NULL
);


ALTER TABLE public.geonetwork_data OWNER TO postgres;

--
-- TOC entry 3455 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN geonetwork_data.geographical_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.geonetwork_data.geographical_id IS 'Id del registro interno';


--
-- TOC entry 3456 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN geonetwork_data.resource_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.geonetwork_data.resource_id IS 'Recurso del cual se obtiene el dato';


--
-- TOC entry 3457 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN geonetwork_data.original_data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.geonetwork_data.original_data IS 'XML original de los metadatos en geonetwork';


--
-- TOC entry 211 (class 1259 OID 16427)
-- Name: geographical_data_geographical_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.geonetwork_data ALTER COLUMN geographical_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.geographical_data_geographical_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 210 (class 1259 OID 16387)
-- Name: resources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resources (
    resource_id integer NOT NULL,
    identifier character varying(64) NOT NULL,
    url character varying(1000),
    catalogue public.cataloguer NOT NULL,
    timestamp_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    timestamp_modified timestamp without time zone,
    harvested boolean DEFAULT false NOT NULL,
    title character varying(1000),
    publication_date character varying(50),
    abstract text
);


ALTER TABLE public.resources OWNER TO postgres;

--
-- TOC entry 3458 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE resources; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.resources IS 'Tabla para almacenar guid, nombres cortes de recursos para acceso a los catalogadores';


--
-- TOC entry 3459 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.resource_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.resource_id IS 'Campo id auto incremental';


--
-- TOC entry 3460 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.identifier IS 'Identificador del recurso según el catalogador. Para ceiba es el nombre corto, para geonetwork es el uuid al igual que para biocultural';


--
-- TOC entry 3461 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.url; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.url IS 'URL del recurso en el catalogador. Es opcional';


--
-- TOC entry 3462 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.catalogue; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.catalogue IS 'Catálogo de donde proviene la información recopilada: Ceiba, Geonetwork y Biocultural';


--
-- TOC entry 3463 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.timestamp_created; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.timestamp_created IS 'Fecha de creación del recurso';


--
-- TOC entry 3464 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.timestamp_modified; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.timestamp_modified IS 'Fecha de actualización del recurso. Es depediente del valor de control ''harvested'', que si es true, deberá actualizar datos y generar una fecha de actualización del recurso';


--
-- TOC entry 3465 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.harvested; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.harvested IS 'Indica si el recurso se ha cosechado dentro de la base de gef-p. Por defecto es false (0, no, f, también son valores válidos dentro del motor postgresql)';


--
-- TOC entry 3466 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.title; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.title IS 'Título del recurso según el catalogador';


--
-- TOC entry 3467 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.publication_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.publication_date IS 'Fecha de publicación del recurso';


--
-- TOC entry 3468 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN resources.abstract; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.abstract IS 'Resumen del recurso';


--
-- TOC entry 209 (class 1259 OID 16386)
-- Name: resources_resource_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.resources ALTER COLUMN resource_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.resources_resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 214 (class 1259 OID 16441)
-- Name: stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stats (
    stat_id integer NOT NULL,
    stat character varying(255) NOT NULL,
    stat_value integer NOT NULL,
    timestamp_created timestamp without time zone,
    timestamp_modified timestamp without time zone
);


ALTER TABLE public.stats OWNER TO postgres;

--
-- TOC entry 3469 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE stats; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.stats IS 'Tabla para almacenar valores de estadísticos';


--
-- TOC entry 3470 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN stats.stat_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.stats.stat_id IS 'Identificador interno del estadístico';


--
-- TOC entry 3471 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN stats.stat; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.stats.stat IS 'Indicador';


--
-- TOC entry 3472 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN stats.stat_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.stats.stat_value IS 'Valor del indicador';


--
-- TOC entry 3473 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN stats.timestamp_created; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.stats.timestamp_created IS 'Fecha de cálculo del indicador';


--
-- TOC entry 3474 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN stats.timestamp_modified; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.stats.timestamp_modified IS 'Fecha de modificación del valor del indicador';


--
-- TOC entry 213 (class 1259 OID 16440)
-- Name: stats_stat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.stats ALTER COLUMN stat_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stats_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3434 (class 0 OID 25630)
-- Dependencies: 217
-- Data for Name: biocultural_accion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_accion (idactor, idaccion, acciongeneral, rolespecifico, estrategiadeaccion, objetodeinteres, especiedeinteres, ecosistemaincidido, inicio, fin, personacompiladora, fechacompilacion, correocompilador, resource_id) FROM stdin;
\.


--
-- TOC entry 3432 (class 0 OID 25616)
-- Dependencies: 215
-- Data for Name: biocultural_actor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_actor (idactor, nombreactor, sigla, tipoorganizacion, dependencia, mision, etnia, condicionpoblacion, ocupacionsocioeconomica, ambitogeograficoactuacion, ubicaciondepartamental, ubicacionmunicipal, ubicacionveredal, localidadubicacion, latituddecimal, longituddecimal, sistemacoordenadas, sistemareferenciaespacial, personacompiladora, fechacompilacion, correocompilador, fuenteinformacion, resource_id) FROM stdin;
\.


--
-- TOC entry 3436 (class 0 OID 25644)
-- Dependencies: 219
-- Data for Name: biocultural_conflict; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_conflict (idconflicto, nombrecsa, causa, objetodisputa, tipoconflicto, expresionesvisibles, impactoambiental, impactosocial, impactocultural, impactoeconomico, resumen, iniciocsa, hitos, resource_id) FROM stdin;
\.


--
-- TOC entry 3433 (class 0 OID 25623)
-- Dependencies: 216
-- Data for Name: biocultural_directory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_directory (idactor, personacontacto, temadependencia, genero, telefono, correoelectronico, paginaweb, personaenlaceiavh, fechaultimocontacto, personacompiladora, fechacompilacion, correocompilador, fuenteinformacion, resource_id) FROM stdin;
\.


--
-- TOC entry 3437 (class 0 OID 25651)
-- Dependencies: 220
-- Data for Name: biocultural_implication; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_implication (idconflicto, idactor, nombreactor, sigla, territorialidadimplicada, afectacionactor, ubicaciondepartamental, ubicacionmunicipal, ubicacionveredal, localidadubicacion, latitud, longitud, sistemacoordenadas, sistemareferenciaespacial, personacompiladora, fechacompilacion, correocompilador, fuenteinformacion, actividadidentifcainformacion, resource_id) FROM stdin;
\.


--
-- TOC entry 3438 (class 0 OID 25658)
-- Dependencies: 221
-- Data for Name: biocultural_interactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_interactions (idactora, nombreactora, idactorb, nombreactorb, relaciona_b, relacionb_a, motivovinculo, resource_id) FROM stdin;
\.


--
-- TOC entry 3435 (class 0 OID 25637)
-- Dependencies: 218
-- Data for Name: biocultural_locality; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_locality (idaccion, departamento, municipio, vereda, localidad, latitud, longitud, sistemacoordenadas, sistemareferenciaespacial, personacompiladora, fechacompilacion, correocompilador, fuenteinformacion, resource_id) FROM stdin;
\.


--
-- TOC entry 3440 (class 0 OID 25672)
-- Dependencies: 223
-- Data for Name: biocultural_practice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_practice (idproceso, idpractica, narrativa, verbonivel1, quenivel2, recursonivel3, atributo, condicionesacceso, beneficiosgenerados, actoresinvolucrados, herramientassociotecnicas, conflictos, personacompiladora, fechacompilacion, correocompilador, fuenteinformacion, actividadidentifcainformacion, resource_id) FROM stdin;
\.


--
-- TOC entry 3439 (class 0 OID 25665)
-- Dependencies: 222
-- Data for Name: biocultural_process; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_process (idproceso, nombreproceso, tipoprocesoorganizativo, areaincidencia, ecosistemaestrategico, historiaproceso, personacompiladora, fechacompilacion, correocompilador, fuenteinformacion, actividadidentifcainformacion, resource_id) FROM stdin;
\.


--
-- TOC entry 3441 (class 0 OID 25721)
-- Dependencies: 224
-- Data for Name: biocultural_survey; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biocultural_survey (codigo_id, nombre, organizacion, perfil, edad, genero, departamento, municipio, sector, fecha, hora, contacto, formato, entrevistador, compilador, altitud, latitud_decimal, longitud_decimal, sistema_referencia_espacial, incertidumbre_coordenadas_metros, precision_coordenadas, resource_id) FROM stdin;
\.


--
-- TOC entry 3445 (class 0 OID 25793)
-- Dependencies: 228
-- Data for Name: ceiba_event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ceiba_event (id, resource_id, eventid, eventtype, institutioncode, institutionid, samplingprotocol, samplesizevalue, samplesizeunit, samplingeffort, eventdate, eventtime, habitat, eventremarks, continent, country, countrycode, stateprovince, county, municipality, locality, minimumelevationinmeters, maximumelevationinmeters, locationremarks, verbatimlatitude, verbatimlongitude, decimallatitude, decimallongitude, geodeticdatum, coordinateuncertaintyinmeters) FROM stdin;
\.


--
-- TOC entry 3443 (class 0 OID 25779)
-- Dependencies: 226
-- Data for Name: ceiba_occurrence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ceiba_occurrence (id, resource_id, occurrenceid, basisofrecord, type, institutioncode, institutionid, recordnumber, recordedby, individualcount, organismquantity, organismquantitytype, sex, lifestage, occurrencestatus, preparations, disposition, occurrenceremarks, eventid, eventtype, samplingprotocol, samplingeffort, eventdate, eventtime, habitat, eventremarks, continent, country, countrycode, stateprovince, county, municipality, locality, minimumelevationinmeters, maximumelevationinmeters, locationremarks, verbatimlatitude, verbatimlongitude, decimallatitude, decimallongitude, geodeticdatum, coordinateuncertaintyinmeters, identifiedby, dateidentified, identificationremarks, identificationqualifier, scientificname, scientificnameauthorship, kingdom, phylum, class, "order", superfamily, family, subfamily, tribe, subtribe, genus, subgenus, specificepithet, infraspecificepithet, taxonrank, vernacularname, taxonremarks) FROM stdin;
\.


--
-- TOC entry 3429 (class 0 OID 16428)
-- Dependencies: 212
-- Data for Name: geonetwork_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.geonetwork_data (geographical_id, resource_id, original_data) FROM stdin;
\.


--
-- TOC entry 3427 (class 0 OID 16387)
-- Dependencies: 210
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resources (resource_id, identifier, url, catalogue, timestamp_created, timestamp_modified, harvested, title, publication_date, abstract) FROM stdin;
3	aves_vichada_bio	\N	ceiba	2025-01-16 01:45:38.100781	\N	f	\N	\N	\N
1	biota_v10_n1-2_10	\N	ceiba	2025-01-16 01:45:38.091812	\N	f	\N	\N	\N
4	b1ad521f-4a2b-46ac-a644-807bf43360a7	\N	geonetwork	2025-04-10 10:06:19.051904	\N	f	\N	\N	\N
2	cacay-moriche_guaviare	\N	ceiba	2025-01-16 01:45:38.097256	\N	f	\N	\N	\N
5	doi:10.21068/WK1KS4	\N	biocultural	2025-04-10 13:01:45.330578	\N	f	\N	\N	\N
\.


--
-- TOC entry 3431 (class 0 OID 16441)
-- Dependencies: 214
-- Data for Name: stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stats (stat_id, stat, stat_value, timestamp_created, timestamp_modified) FROM stdin;
\.


--
-- TOC entry 3475 (class 0 OID 0)
-- Dependencies: 227
-- Name: ceiba_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ceiba_event_id_seq', 1, false);


--
-- TOC entry 3476 (class 0 OID 0)
-- Dependencies: 225
-- Name: ceiba_ocurrence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ceiba_ocurrence_id_seq', 1, false);


--
-- TOC entry 3477 (class 0 OID 0)
-- Dependencies: 211
-- Name: geographical_data_geographical_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.geographical_data_geographical_id_seq', 1, false);


--
-- TOC entry 3478 (class 0 OID 0)
-- Dependencies: 209
-- Name: resources_resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resources_resource_id_seq', 5, true);


--
-- TOC entry 3479 (class 0 OID 0)
-- Dependencies: 213
-- Name: stats_stat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stats_stat_id_seq', 1, false);


--
-- TOC entry 3253 (class 2606 OID 25657)
-- Name: biocultural_implication actores_conflictos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_implication
    ADD CONSTRAINT actores_conflictos_pkey PRIMARY KEY (idconflicto);


--
-- TOC entry 3251 (class 2606 OID 25650)
-- Name: biocultural_conflict biocultura_conflict_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_conflict
    ADD CONSTRAINT biocultura_conflict_pkey PRIMARY KEY (idconflicto);


--
-- TOC entry 3247 (class 2606 OID 25690)
-- Name: biocultural_accion biocultural_accion_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_accion
    ADD CONSTRAINT biocultural_accion_unique UNIQUE (idaccion);


--
-- TOC entry 3243 (class 2606 OID 25622)
-- Name: biocultural_actor biocultural_actor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_actor
    ADD CONSTRAINT biocultural_actor_pkey PRIMARY KEY (idactor);


--
-- TOC entry 3245 (class 2606 OID 25629)
-- Name: biocultural_directory biocultural_directory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_directory
    ADD CONSTRAINT biocultural_directory_pkey PRIMARY KEY (idactor);


--
-- TOC entry 3249 (class 2606 OID 25643)
-- Name: biocultural_locality biocultural_locality_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_locality
    ADD CONSTRAINT biocultural_locality_pkey PRIMARY KEY (idaccion);


--
-- TOC entry 3259 (class 2606 OID 25678)
-- Name: biocultural_practice biocultural_practices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_practice
    ADD CONSTRAINT biocultural_practices_pkey PRIMARY KEY (idproceso);


--
-- TOC entry 3257 (class 2606 OID 25671)
-- Name: biocultural_process biocultural_process_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_process
    ADD CONSTRAINT biocultural_process_pkey PRIMARY KEY (idproceso);


--
-- TOC entry 3261 (class 2606 OID 25727)
-- Name: biocultural_survey biocultural_survey_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_survey
    ADD CONSTRAINT biocultural_survey_pkey PRIMARY KEY (codigo_id);


--
-- TOC entry 3263 (class 2606 OID 25785)
-- Name: ceiba_occurrence biological_data_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ceiba_occurrence
    ADD CONSTRAINT biological_data_pk PRIMARY KEY (id);


--
-- TOC entry 3265 (class 2606 OID 25799)
-- Name: ceiba_event event_data_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ceiba_event
    ADD CONSTRAINT event_data_pk PRIMARY KEY (id);


--
-- TOC entry 3239 (class 2606 OID 16434)
-- Name: geonetwork_data geographical_data_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geonetwork_data
    ADD CONSTRAINT geographical_data_pk PRIMARY KEY (geographical_id);


--
-- TOC entry 3255 (class 2606 OID 25664)
-- Name: biocultural_interactions relaciones_actores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_interactions
    ADD CONSTRAINT relaciones_actores_pkey PRIMARY KEY (idactora);


--
-- TOC entry 3237 (class 2606 OID 16395)
-- Name: resources resource_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resource_pk PRIMARY KEY (resource_id);


--
-- TOC entry 3241 (class 2606 OID 16445)
-- Name: stats stats_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stats
    ADD CONSTRAINT stats_pk PRIMARY KEY (stat_id);


--
-- TOC entry 3270 (class 2606 OID 25684)
-- Name: biocultural_accion biocultural_accion_biocultural_actor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_accion
    ADD CONSTRAINT biocultural_accion_biocultural_actor_fk FOREIGN KEY (idactor) REFERENCES public.biocultural_actor(idactor);


--
-- TOC entry 3271 (class 2606 OID 25728)
-- Name: biocultural_accion biocultural_accion_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_accion
    ADD CONSTRAINT biocultural_accion_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3267 (class 2606 OID 25733)
-- Name: biocultural_actor biocultural_actor_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_actor
    ADD CONSTRAINT biocultural_actor_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3274 (class 2606 OID 25738)
-- Name: biocultural_conflict biocultural_conflict_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_conflict
    ADD CONSTRAINT biocultural_conflict_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3268 (class 2606 OID 25679)
-- Name: biocultural_directory biocultural_directory_biocultural_actor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_directory
    ADD CONSTRAINT biocultural_directory_biocultural_actor_fk FOREIGN KEY (idactor) REFERENCES public.biocultural_actor(idactor);


--
-- TOC entry 3269 (class 2606 OID 25743)
-- Name: biocultural_directory biocultural_directory_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_directory
    ADD CONSTRAINT biocultural_directory_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3275 (class 2606 OID 25701)
-- Name: biocultural_implication biocultural_implication_biocultural_actor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_implication
    ADD CONSTRAINT biocultural_implication_biocultural_actor_fk FOREIGN KEY (idactor) REFERENCES public.biocultural_actor(idactor);


--
-- TOC entry 3276 (class 2606 OID 25696)
-- Name: biocultural_implication biocultural_implication_biocultural_conflict_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_implication
    ADD CONSTRAINT biocultural_implication_biocultural_conflict_fk FOREIGN KEY (idconflicto) REFERENCES public.biocultural_conflict(idconflicto);


--
-- TOC entry 3277 (class 2606 OID 25748)
-- Name: biocultural_implication biocultural_implication_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_implication
    ADD CONSTRAINT biocultural_implication_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3278 (class 2606 OID 25753)
-- Name: biocultural_interactions biocultural_interaction_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_interactions
    ADD CONSTRAINT biocultural_interaction_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3279 (class 2606 OID 25706)
-- Name: biocultural_interactions biocultural_interactions_biocultural_actor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_interactions
    ADD CONSTRAINT biocultural_interactions_biocultural_actor_fk FOREIGN KEY (idactora) REFERENCES public.biocultural_actor(idactor);


--
-- TOC entry 3280 (class 2606 OID 25711)
-- Name: biocultural_interactions biocultural_interactions_biocultural_actor_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_interactions
    ADD CONSTRAINT biocultural_interactions_biocultural_actor_fk_1 FOREIGN KEY (idactorb) REFERENCES public.biocultural_actor(idactor);


--
-- TOC entry 3272 (class 2606 OID 25691)
-- Name: biocultural_locality biocultural_locality_biocultural_accion_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_locality
    ADD CONSTRAINT biocultural_locality_biocultural_accion_fk FOREIGN KEY (idaccion) REFERENCES public.biocultural_accion(idaccion);


--
-- TOC entry 3273 (class 2606 OID 25758)
-- Name: biocultural_locality biocultural_locality_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_locality
    ADD CONSTRAINT biocultural_locality_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3282 (class 2606 OID 25716)
-- Name: biocultural_practice biocultural_practice_biocultural_process_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_practice
    ADD CONSTRAINT biocultural_practice_biocultural_process_fk FOREIGN KEY (idproceso) REFERENCES public.biocultural_process(idproceso);


--
-- TOC entry 3283 (class 2606 OID 25763)
-- Name: biocultural_practice biocultural_practice_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_practice
    ADD CONSTRAINT biocultural_practice_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3281 (class 2606 OID 25768)
-- Name: biocultural_process biocultural_process_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_process
    ADD CONSTRAINT biocultural_process_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3284 (class 2606 OID 25773)
-- Name: biocultural_survey biocultural_survey_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biocultural_survey
    ADD CONSTRAINT biocultural_survey_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3285 (class 2606 OID 25786)
-- Name: ceiba_occurrence biological_data_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ceiba_occurrence
    ADD CONSTRAINT biological_data_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3286 (class 2606 OID 25800)
-- Name: ceiba_event event_data_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ceiba_event
    ADD CONSTRAINT event_data_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3266 (class 2606 OID 16435)
-- Name: geonetwork_data geographical_data_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geonetwork_data
    ADD CONSTRAINT geographical_data_resources_fk FOREIGN KEY (resource_id) REFERENCES public.resources(resource_id);


--
-- TOC entry 3454 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2025-04-21 16:14:43

--
-- PostgreSQL database dump complete
--

