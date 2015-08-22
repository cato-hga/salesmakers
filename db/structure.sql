--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: distance(double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION distance(lat1 double precision, lon1 double precision, lat2 double precision, lon2 double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE                                                   
    x float = 69.1 * (lat2 - lat1);                           
    y float = 69.1 * (lon2 - lon1) * cos(lat1 / 57.3);        
BEGIN                                                     
    RETURN sqrt(x * x + y * y);                               
END  
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: answer_upvotes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answer_upvotes (
    id integer NOT NULL,
    answer_id integer NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: answer_upvotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answer_upvotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answer_upvotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answer_upvotes_id_seq OWNED BY answer_upvotes.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answers (
    id integer NOT NULL,
    person_id integer NOT NULL,
    question_id integer NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: area_candidate_sourcing_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE area_candidate_sourcing_groups (
    id integer NOT NULL,
    group_number integer,
    project_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: area_candidate_sourcing_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE area_candidate_sourcing_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: area_candidate_sourcing_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE area_candidate_sourcing_groups_id_seq OWNED BY area_candidate_sourcing_groups.id;


--
-- Name: area_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE area_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    project_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: area_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE area_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: area_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE area_types_id_seq OWNED BY area_types.id;


--
-- Name: areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE areas (
    id integer NOT NULL,
    name character varying NOT NULL,
    area_type_id integer NOT NULL,
    ancestry character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    project_id integer NOT NULL,
    connect_salesregion_id character varying,
    personality_assessment_url character varying,
    area_candidate_sourcing_group_id integer,
    email character varying,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE areas_id_seq OWNED BY areas.id;


--
-- Name: blog_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE blog_posts (
    id integer NOT NULL,
    person_id integer NOT NULL,
    excerpt text NOT NULL,
    content text NOT NULL,
    title character varying NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: blog_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE blog_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE blog_posts_id_seq OWNED BY blog_posts.id;


--
-- Name: candidate_availabilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidate_availabilities (
    id integer NOT NULL,
    monday_first boolean DEFAULT false NOT NULL,
    monday_second boolean DEFAULT false NOT NULL,
    monday_third boolean DEFAULT false NOT NULL,
    tuesday_first boolean DEFAULT false NOT NULL,
    tuesday_second boolean DEFAULT false NOT NULL,
    tuesday_third boolean DEFAULT false NOT NULL,
    wednesday_first boolean DEFAULT false NOT NULL,
    wednesday_second boolean DEFAULT false NOT NULL,
    wednesday_third boolean DEFAULT false NOT NULL,
    thursday_first boolean DEFAULT false NOT NULL,
    thursday_second boolean DEFAULT false NOT NULL,
    thursday_third boolean DEFAULT false NOT NULL,
    friday_first boolean DEFAULT false NOT NULL,
    friday_second boolean DEFAULT false NOT NULL,
    friday_third boolean DEFAULT false NOT NULL,
    saturday_first boolean DEFAULT false NOT NULL,
    saturday_second boolean DEFAULT false NOT NULL,
    saturday_third boolean DEFAULT false NOT NULL,
    sunday_first boolean DEFAULT false NOT NULL,
    sunday_second boolean DEFAULT false NOT NULL,
    sunday_third boolean DEFAULT false NOT NULL,
    candidate_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comment text
);


--
-- Name: candidate_availabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidate_availabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_availabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidate_availabilities_id_seq OWNED BY candidate_availabilities.id;


--
-- Name: candidate_contacts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidate_contacts (
    id integer NOT NULL,
    contact_method integer NOT NULL,
    inbound boolean DEFAULT false NOT NULL,
    person_id integer NOT NULL,
    candidate_id integer NOT NULL,
    notes text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    call_results text
);


--
-- Name: candidate_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidate_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidate_contacts_id_seq OWNED BY candidate_contacts.id;


--
-- Name: candidate_denial_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidate_denial_reasons (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: candidate_denial_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidate_denial_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_denial_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidate_denial_reasons_id_seq OWNED BY candidate_denial_reasons.id;


--
-- Name: candidate_drug_tests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidate_drug_tests (
    id integer NOT NULL,
    scheduled boolean DEFAULT false NOT NULL,
    test_date timestamp without time zone,
    comments text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    candidate_id integer
);


--
-- Name: candidate_drug_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidate_drug_tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_drug_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidate_drug_tests_id_seq OWNED BY candidate_drug_tests.id;


--
-- Name: candidate_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidate_notes (
    id integer NOT NULL,
    candidate_id integer NOT NULL,
    person_id integer NOT NULL,
    note text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: candidate_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidate_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidate_notes_id_seq OWNED BY candidate_notes.id;


--
-- Name: candidate_reconciliations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidate_reconciliations (
    id integer NOT NULL,
    candidate_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: candidate_reconciliations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidate_reconciliations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_reconciliations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidate_reconciliations_id_seq OWNED BY candidate_reconciliations.id;


--
-- Name: candidate_sms_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidate_sms_messages (
    id integer NOT NULL,
    text character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: candidate_sms_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidate_sms_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_sms_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidate_sms_messages_id_seq OWNED BY candidate_sms_messages.id;


--
-- Name: candidate_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidate_sources (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: candidate_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidate_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidate_sources_id_seq OWNED BY candidate_sources.id;


--
-- Name: candidate_sprint_radio_shack_training_sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidate_sprint_radio_shack_training_sessions (
    id integer NOT NULL,
    candidate_id integer NOT NULL,
    sprint_radio_shack_training_session_id integer NOT NULL,
    sprint_roster_status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: candidate_sprint_radio_shack_training_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidate_sprint_radio_shack_training_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_sprint_radio_shack_training_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidate_sprint_radio_shack_training_sessions_id_seq OWNED BY candidate_sprint_radio_shack_training_sessions.id;


--
-- Name: candidates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidates (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    suffix character varying,
    mobile_phone character varying NOT NULL,
    email character varying NOT NULL,
    zip character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer,
    location_area_id integer,
    latitude double precision,
    longitude double precision,
    active boolean DEFAULT true NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    state character varying(2),
    candidate_source_id integer,
    created_by integer NOT NULL,
    candidate_denial_reason_id integer,
    personality_assessment_completed boolean DEFAULT false NOT NULL,
    shirt_gender character varying,
    shirt_size character varying,
    personality_assessment_status integer DEFAULT 0 NOT NULL,
    personality_assessment_score double precision,
    sprint_radio_shack_training_session_id integer,
    potential_area_id integer,
    training_session_status integer DEFAULT 0 NOT NULL,
    sprint_roster_status integer,
    time_zone character varying,
    other_phone character varying,
    mobile_phone_valid boolean DEFAULT true NOT NULL,
    other_phone_valid boolean DEFAULT true NOT NULL,
    mobile_phone_is_landline boolean DEFAULT false NOT NULL
);


--
-- Name: candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidates_id_seq OWNED BY candidates.id;


--
-- Name: changelog_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE changelog_entries (
    id integer NOT NULL,
    department_id integer,
    project_id integer,
    all_hq boolean,
    all_field boolean,
    heading character varying NOT NULL,
    description text NOT NULL,
    released timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: changelog_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE changelog_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: changelog_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE changelog_entries_id_seq OWNED BY changelog_entries.id;


--
-- Name: channels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE channels (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE channels_id_seq OWNED BY channels.id;


--
-- Name: client_area_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE client_area_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    project_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: client_area_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE client_area_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: client_area_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE client_area_types_id_seq OWNED BY client_area_types.id;


--
-- Name: client_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE client_areas (
    id integer NOT NULL,
    name character varying NOT NULL,
    client_area_type_id integer NOT NULL,
    ancestry character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    project_id integer NOT NULL
);


--
-- Name: client_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE client_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: client_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE client_areas_id_seq OWNED BY client_areas.id;


--
-- Name: client_representatives; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE client_representatives (
    id integer NOT NULL,
    client_id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    password_digest character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: client_representatives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE client_representatives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: client_representatives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE client_representatives_id_seq OWNED BY client_representatives.id;


--
-- Name: client_representatives_permissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE client_representatives_permissions (
    client_representative_id integer,
    permission_id integer
);


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clients (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clients_id_seq OWNED BY clients.id;


--
-- Name: comcast_customer_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_customer_notes (
    id integer NOT NULL,
    comcast_customer_id integer NOT NULL,
    person_id integer NOT NULL,
    note text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comcast_customer_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_customer_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_customer_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_customer_notes_id_seq OWNED BY comcast_customer_notes.id;


--
-- Name: comcast_customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_customers (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    mobile_phone character varying,
    other_phone character varying,
    person_id integer NOT NULL,
    comments text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    location_id integer NOT NULL,
    comcast_lead_dismissal_reason_id integer,
    dismissal_comment text
);


--
-- Name: comcast_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_customers_id_seq OWNED BY comcast_customers.id;


--
-- Name: comcast_eods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_eods (
    id integer NOT NULL,
    eod_date timestamp without time zone NOT NULL,
    location_id integer NOT NULL,
    sales_pro_visit boolean DEFAULT false NOT NULL,
    sales_pro_visit_takeaway text,
    comcast_visit boolean DEFAULT false NOT NULL,
    comcast_visit_takeaway text,
    cloud_training boolean DEFAULT false NOT NULL,
    cloud_training_takeaway text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer
);


--
-- Name: comcast_eods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_eods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_eods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_eods_id_seq OWNED BY comcast_eods.id;


--
-- Name: comcast_former_providers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_former_providers (
    id integer NOT NULL,
    name character varying NOT NULL,
    comcast_sale_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comcast_former_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_former_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_former_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_former_providers_id_seq OWNED BY comcast_former_providers.id;


--
-- Name: comcast_group_me_bots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_group_me_bots (
    id integer NOT NULL,
    group_num character varying NOT NULL,
    bot_num character varying NOT NULL,
    area_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comcast_group_me_bots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_group_me_bots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_group_me_bots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_group_me_bots_id_seq OWNED BY comcast_group_me_bots.id;


--
-- Name: comcast_install_appointments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_install_appointments (
    id integer NOT NULL,
    install_date date NOT NULL,
    comcast_install_time_slot_id integer NOT NULL,
    comcast_sale_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comcast_install_appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_install_appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_install_appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_install_appointments_id_seq OWNED BY comcast_install_appointments.id;


--
-- Name: comcast_install_time_slots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_install_time_slots (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comcast_install_time_slots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_install_time_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_install_time_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_install_time_slots_id_seq OWNED BY comcast_install_time_slots.id;


--
-- Name: comcast_lead_dismissal_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_lead_dismissal_reasons (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comcast_lead_dismissal_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_lead_dismissal_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_lead_dismissal_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_lead_dismissal_reasons_id_seq OWNED BY comcast_lead_dismissal_reasons.id;


--
-- Name: comcast_leads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_leads (
    id integer NOT NULL,
    comcast_customer_id integer NOT NULL,
    follow_up_by date,
    tv boolean DEFAULT false NOT NULL,
    internet boolean DEFAULT false NOT NULL,
    phone boolean DEFAULT false NOT NULL,
    security boolean DEFAULT false NOT NULL,
    ok_to_call_and_text boolean DEFAULT false NOT NULL,
    comments text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: comcast_leads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_leads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_leads_id_seq OWNED BY comcast_leads.id;


--
-- Name: comcast_sales; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comcast_sales (
    id integer NOT NULL,
    order_date date NOT NULL,
    person_id integer NOT NULL,
    comcast_customer_id integer NOT NULL,
    order_number character varying NOT NULL,
    tv boolean DEFAULT false NOT NULL,
    internet boolean DEFAULT false NOT NULL,
    phone boolean DEFAULT false NOT NULL,
    security boolean DEFAULT false NOT NULL,
    customer_acknowledged boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comcast_former_provider_id integer,
    comcast_lead_id integer
);


--
-- Name: comcast_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comcast_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comcast_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comcast_sales_id_seq OWNED BY comcast_sales.id;


--
-- Name: communication_log_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE communication_log_entries (
    id integer NOT NULL,
    loggable_id integer NOT NULL,
    loggable_type character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    person_id integer NOT NULL
);


--
-- Name: communication_log_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE communication_log_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communication_log_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE communication_log_entries_id_seq OWNED BY communication_log_entries.id;


--
-- Name: day_sales_counts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE day_sales_counts (
    id integer NOT NULL,
    day date NOT NULL,
    saleable_id integer NOT NULL,
    saleable_type character varying NOT NULL,
    sales integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    activations integer DEFAULT 0 NOT NULL,
    new_accounts integer DEFAULT 0 NOT NULL
);


--
-- Name: day_sales_counts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE day_sales_counts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: day_sales_counts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE day_sales_counts_id_seq OWNED BY day_sales_counts.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE departments (
    id integer NOT NULL,
    name character varying NOT NULL,
    corporate boolean NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE departments_id_seq OWNED BY departments.id;


--
-- Name: device_deployments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE device_deployments (
    id integer NOT NULL,
    device_id integer NOT NULL,
    person_id integer NOT NULL,
    started date NOT NULL,
    ended date,
    tracking_number character varying,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: device_deployments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE device_deployments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_deployments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE device_deployments_id_seq OWNED BY device_deployments.id;


--
-- Name: device_manufacturers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE device_manufacturers (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: device_manufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE device_manufacturers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_manufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE device_manufacturers_id_seq OWNED BY device_manufacturers.id;


--
-- Name: device_models; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE device_models (
    id integer NOT NULL,
    name character varying NOT NULL,
    device_manufacturer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: device_models_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE device_models_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE device_models_id_seq OWNED BY device_models.id;


--
-- Name: device_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE device_notes (
    id integer NOT NULL,
    device_id integer,
    note text,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: device_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE device_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE device_notes_id_seq OWNED BY device_notes.id;


--
-- Name: device_states; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE device_states (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    locked boolean DEFAULT false
);


--
-- Name: device_states_devices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE device_states_devices (
    device_id integer NOT NULL,
    device_state_id integer NOT NULL
);


--
-- Name: device_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE device_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE device_states_id_seq OWNED BY device_states.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE devices (
    id integer NOT NULL,
    identifier character varying NOT NULL,
    serial character varying NOT NULL,
    device_model_id integer NOT NULL,
    line_id integer,
    person_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE devices_id_seq OWNED BY devices.id;


--
-- Name: directv_customer_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directv_customer_notes (
    id integer NOT NULL,
    directv_customer_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    note text NOT NULL,
    person_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: directv_customer_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directv_customer_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directv_customer_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directv_customer_notes_id_seq OWNED BY directv_customer_notes.id;


--
-- Name: directv_customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directv_customers (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    mobile_phone character varying,
    other_phone character varying,
    person_id integer,
    comments text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    location_id integer,
    directv_lead_dismissal_reason_id integer,
    dismissal_comment text
);


--
-- Name: directv_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directv_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directv_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directv_customers_id_seq OWNED BY directv_customers.id;


--
-- Name: directv_eods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directv_eods (
    id integer NOT NULL,
    cloud_training boolean DEFAULT false NOT NULL,
    cloud_training_takeaway text,
    directv_visit boolean DEFAULT false NOT NULL,
    directv_visit_takeaway text,
    eod_date timestamp without time zone NOT NULL,
    location_id integer NOT NULL,
    person_id integer,
    sales_pro_visit boolean DEFAULT false NOT NULL,
    sales_pro_visit_takeaway text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: directv_eods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directv_eods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directv_eods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directv_eods_id_seq OWNED BY directv_eods.id;


--
-- Name: directv_former_providers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directv_former_providers (
    id integer NOT NULL,
    directv_sale_id integer,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: directv_former_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directv_former_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directv_former_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directv_former_providers_id_seq OWNED BY directv_former_providers.id;


--
-- Name: directv_install_appointments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directv_install_appointments (
    id integer NOT NULL,
    directv_install_time_slot_id integer NOT NULL,
    directv_sale_id integer NOT NULL,
    install_date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: directv_install_appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directv_install_appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directv_install_appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directv_install_appointments_id_seq OWNED BY directv_install_appointments.id;


--
-- Name: directv_install_time_slots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directv_install_time_slots (
    id integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: directv_install_time_slots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directv_install_time_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directv_install_time_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directv_install_time_slots_id_seq OWNED BY directv_install_time_slots.id;


--
-- Name: directv_lead_dismissal_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directv_lead_dismissal_reasons (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: directv_lead_dismissal_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directv_lead_dismissal_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directv_lead_dismissal_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directv_lead_dismissal_reasons_id_seq OWNED BY directv_lead_dismissal_reasons.id;


--
-- Name: directv_leads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directv_leads (
    id integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    directv_customer_id integer NOT NULL,
    comments text,
    follow_up_by date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ok_to_call_and_text boolean
);


--
-- Name: directv_leads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directv_leads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directv_leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directv_leads_id_seq OWNED BY directv_leads.id;


--
-- Name: directv_sales; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directv_sales (
    id integer NOT NULL,
    order_date date NOT NULL,
    person_id integer,
    directv_customer_id integer NOT NULL,
    order_number character varying NOT NULL,
    directv_former_provider_id integer,
    directv_lead_id integer,
    customer_acknowledged boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: directv_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directv_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directv_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directv_sales_id_seq OWNED BY directv_sales.id;


--
-- Name: docusign_noses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE docusign_noses (
    id integer NOT NULL,
    person_id integer NOT NULL,
    eligible_to_rehire boolean DEFAULT false NOT NULL,
    termination_date timestamp without time zone,
    last_day_worked timestamp without time zone,
    employment_end_reason_id integer,
    remarks text,
    envelope_guid character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    third_party boolean DEFAULT false NOT NULL,
    manager_id integer
);


--
-- Name: docusign_noses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE docusign_noses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: docusign_noses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE docusign_noses_id_seq OWNED BY docusign_noses.id;


--
-- Name: docusign_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE docusign_templates (
    id integer NOT NULL,
    template_guid character varying NOT NULL,
    state character varying(2) NOT NULL,
    document_type integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: docusign_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE docusign_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: docusign_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE docusign_templates_id_seq OWNED BY docusign_templates.id;


--
-- Name: drop_off_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drop_off_reasons (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    eligible_for_reschedule boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: drop_off_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE drop_off_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drop_off_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE drop_off_reasons_id_seq OWNED BY drop_off_reasons.id;


--
-- Name: email_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE email_messages (
    id integer NOT NULL,
    from_email character varying NOT NULL,
    to_email character varying NOT NULL,
    to_person_id integer,
    content text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    subject character varying NOT NULL
);


--
-- Name: email_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE email_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE email_messages_id_seq OWNED BY email_messages.id;


--
-- Name: employment_end_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employment_end_reasons (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: employment_end_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employment_end_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employment_end_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employment_end_reasons_id_seq OWNED BY employment_end_reasons.id;


--
-- Name: employments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employments (
    id integer NOT NULL,
    person_id integer,
    start date,
    "end" date,
    end_reason character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: employments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employments_id_seq OWNED BY employments.id;


--
-- Name: group_me_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_me_groups (
    id integer NOT NULL,
    group_num integer NOT NULL,
    area_id integer,
    name character varying NOT NULL,
    avatar_url character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    bot_num character varying
);


--
-- Name: group_me_groups_group_me_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_me_groups_group_me_users (
    group_me_group_id integer NOT NULL,
    group_me_user_id integer NOT NULL
);


--
-- Name: group_me_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_me_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_me_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_me_groups_id_seq OWNED BY group_me_groups.id;


--
-- Name: group_me_likes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_me_likes (
    id integer NOT NULL,
    group_me_user_id integer NOT NULL,
    group_me_post_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: group_me_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_me_likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_me_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_me_likes_id_seq OWNED BY group_me_likes.id;


--
-- Name: group_me_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_me_posts (
    id integer NOT NULL,
    group_me_group_id integer NOT NULL,
    posted_at timestamp without time zone NOT NULL,
    json text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    group_me_user_id integer NOT NULL,
    message_num character varying NOT NULL,
    like_count integer DEFAULT 0 NOT NULL,
    person_id integer
);


--
-- Name: group_me_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_me_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_me_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_me_posts_id_seq OWNED BY group_me_posts.id;


--
-- Name: group_me_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_me_users (
    id integer NOT NULL,
    group_me_user_num character varying NOT NULL,
    person_id integer,
    name character varying NOT NULL,
    avatar_url character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: group_me_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_me_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_me_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_me_users_id_seq OWNED BY group_me_users.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    display_name character varying NOT NULL,
    email character varying NOT NULL,
    personal_email character varying,
    position_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean DEFAULT true NOT NULL,
    connect_user_id character varying,
    supervisor_id integer,
    office_phone character varying,
    mobile_phone character varying,
    home_phone character varying,
    eid integer,
    groupme_access_token character varying,
    groupme_token_updated timestamp without time zone,
    group_me_user_id character varying,
    last_seen timestamp without time zone,
    changelog_entry_id integer,
    vonage_tablet_approval_status integer DEFAULT 0 NOT NULL,
    passed_asset_hours_requirement boolean DEFAULT false NOT NULL,
    sprint_prepaid_asset_approval_status integer DEFAULT 0 NOT NULL,
    update_position_from_connect boolean DEFAULT true NOT NULL,
    mobile_phone_valid boolean DEFAULT true NOT NULL,
    home_phone_valid boolean DEFAULT true NOT NULL,
    office_phone_valid boolean DEFAULT true NOT NULL
);


--
-- Name: positions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE positions (
    id integer NOT NULL,
    name character varying NOT NULL,
    leadership boolean NOT NULL,
    all_field_visibility boolean NOT NULL,
    all_corporate_visibility boolean NOT NULL,
    department_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    field boolean,
    hq boolean,
    twilio_number character varying
);


--
-- Name: headquarters_org_chart_entries; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW headquarters_org_chart_entries AS
 SELECT row_number() OVER (ORDER BY dep.name, p.display_name) AS id,
    dep.name AS department_name,
    dep.id AS department_id,
    pos.name AS position_name,
    pos.id AS position_id,
    p.display_name AS person_name,
    p.id AS person_id
   FROM ((departments dep
     LEFT JOIN positions pos ON ((pos.department_id = dep.id)))
     LEFT JOIN people p ON ((p.position_id = pos.id)))
  WHERE ((p.active = true) AND (pos.hq = true))
  ORDER BY dep.name, p.display_name;


--
-- Name: historical_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE historical_areas (
    id integer NOT NULL,
    name character varying NOT NULL,
    area_type_id integer NOT NULL,
    ancestry character varying,
    project_id integer NOT NULL,
    connect_salesregion_id character varying,
    personality_assessment_url character varying,
    area_candidate_sourcing_group_id integer,
    email character varying,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date date NOT NULL
);


--
-- Name: historical_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE historical_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE historical_areas_id_seq OWNED BY historical_areas.id;


--
-- Name: historical_client_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE historical_client_areas (
    id integer NOT NULL,
    name character varying NOT NULL,
    client_area_type_id integer NOT NULL,
    ancestry character varying,
    project_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date date NOT NULL
);


--
-- Name: historical_client_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE historical_client_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_client_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE historical_client_areas_id_seq OWNED BY historical_client_areas.id;


--
-- Name: historical_location_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE historical_location_areas (
    id integer NOT NULL,
    historical_location_id integer NOT NULL,
    historical_area_id integer NOT NULL,
    current_head_count integer DEFAULT 0 NOT NULL,
    potential_candidate_count integer DEFAULT 0 NOT NULL,
    target_head_count integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    hourly_rate double precision,
    offer_extended_count integer DEFAULT 1 NOT NULL,
    outsourced boolean,
    launch_group integer,
    distance_to_cor double precision,
    priority integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date date NOT NULL
);


--
-- Name: historical_location_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE historical_location_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_location_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE historical_location_areas_id_seq OWNED BY historical_location_areas.id;


--
-- Name: historical_location_client_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE historical_location_client_areas (
    id integer NOT NULL,
    historical_location_id integer NOT NULL,
    historical_client_area_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date date NOT NULL
);


--
-- Name: historical_location_client_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE historical_location_client_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_location_client_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE historical_location_client_areas_id_seq OWNED BY historical_location_client_areas.id;


--
-- Name: historical_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE historical_locations (
    id integer NOT NULL,
    display_name character varying,
    store_number character varying NOT NULL,
    street_1 character varying,
    street_2 character varying,
    city character varying NOT NULL,
    state character varying NOT NULL,
    zip character varying,
    channel_id integer NOT NULL,
    latitude double precision,
    longitude double precision,
    sprint_radio_shack_training_location_id integer,
    cost_center character varying,
    mail_stop character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date date NOT NULL
);


--
-- Name: historical_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE historical_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE historical_locations_id_seq OWNED BY historical_locations.id;


--
-- Name: historical_people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE historical_people (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    display_name character varying NOT NULL,
    email character varying NOT NULL,
    personal_email character varying,
    position_id integer,
    active boolean DEFAULT true NOT NULL,
    connect_user_id character varying,
    supervisor_id integer,
    office_phone character varying,
    mobile_phone character varying,
    home_phone character varying,
    eid integer,
    groupme_access_token character varying,
    groupme_token_updated timestamp without time zone,
    group_me_user_id character varying,
    last_seen timestamp without time zone,
    changelog_entry_id integer,
    vonage_tablet_approval_status integer DEFAULT 0 NOT NULL,
    passed_asset_hours_requirement boolean DEFAULT false NOT NULL,
    sprint_prepaid_asset_approval_status integer DEFAULT 0 NOT NULL,
    update_position_from_connect boolean DEFAULT true NOT NULL,
    mobile_phone_valid boolean DEFAULT true NOT NULL,
    home_phone_valid boolean DEFAULT true NOT NULL,
    office_phone_valid boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date date NOT NULL
);


--
-- Name: historical_people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE historical_people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE historical_people_id_seq OWNED BY historical_people.id;


--
-- Name: historical_person_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE historical_person_areas (
    id integer NOT NULL,
    historical_person_id integer NOT NULL,
    historical_area_id integer NOT NULL,
    manages boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date date NOT NULL
);


--
-- Name: historical_person_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE historical_person_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_person_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE historical_person_areas_id_seq OWNED BY historical_person_areas.id;


--
-- Name: historical_person_client_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE historical_person_client_areas (
    id integer NOT NULL,
    historical_person_id integer NOT NULL,
    historical_client_area_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date date NOT NULL
);


--
-- Name: historical_person_client_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE historical_person_client_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_person_client_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE historical_person_client_areas_id_seq OWNED BY historical_person_client_areas.id;


--
-- Name: interview_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interview_answers (
    id integer NOT NULL,
    work_history text NOT NULL,
    why_in_market text NOT NULL,
    ideal_position text NOT NULL,
    what_are_you_good_at text NOT NULL,
    what_are_you_not_good_at text NOT NULL,
    compensation_last_job_one character varying NOT NULL,
    compensation_last_job_two character varying,
    compensation_last_job_three character varying,
    compensation_seeking character varying NOT NULL,
    hours_looking_to_work character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    candidate_id integer,
    willingness_characteristic text NOT NULL,
    personality_characteristic text NOT NULL,
    self_motivated_characteristic text NOT NULL,
    last_two_positions text NOT NULL
);


--
-- Name: interview_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE interview_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: interview_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE interview_answers_id_seq OWNED BY interview_answers.id;


--
-- Name: interview_schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE interview_schedules (
    id integer NOT NULL,
    candidate_id integer NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    interview_date date,
    start_time timestamp without time zone NOT NULL,
    active boolean
);


--
-- Name: interview_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE interview_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: interview_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE interview_schedules_id_seq OWNED BY interview_schedules.id;


--
-- Name: job_offer_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE job_offer_details (
    id integer NOT NULL,
    candidate_id integer NOT NULL,
    sent timestamp without time zone NOT NULL,
    completed timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    envelope_guid character varying,
    completed_by_candidate timestamp without time zone,
    completed_by_advocate timestamp without time zone
);


--
-- Name: job_offer_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE job_offer_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_offer_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE job_offer_details_id_seq OWNED BY job_offer_details.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE likes (
    id integer NOT NULL,
    person_id integer NOT NULL,
    wall_post_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE likes_id_seq OWNED BY likes.id;


--
-- Name: line_states; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE line_states (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    locked boolean DEFAULT false
);


--
-- Name: line_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE line_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: line_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE line_states_id_seq OWNED BY line_states.id;


--
-- Name: line_states_lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE line_states_lines (
    line_id integer NOT NULL,
    line_state_id integer NOT NULL
);


--
-- Name: lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lines (
    id integer NOT NULL,
    identifier character varying NOT NULL,
    contract_end_date date NOT NULL,
    technology_service_provider_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lines_id_seq OWNED BY lines.id;


--
-- Name: link_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE link_posts (
    id integer NOT NULL,
    image_uid character varying NOT NULL,
    thumbnail_uid character varying NOT NULL,
    preview_uid character varying NOT NULL,
    large_uid character varying NOT NULL,
    person_id integer NOT NULL,
    title character varying,
    score integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    url character varying NOT NULL
);


--
-- Name: link_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE link_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: link_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE link_posts_id_seq OWNED BY link_posts.id;


--
-- Name: location_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE location_areas (
    id integer NOT NULL,
    location_id integer NOT NULL,
    area_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    current_head_count integer DEFAULT 0 NOT NULL,
    potential_candidate_count integer DEFAULT 0 NOT NULL,
    target_head_count integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    hourly_rate double precision,
    offer_extended_count integer DEFAULT 0 NOT NULL,
    outsourced boolean DEFAULT false NOT NULL,
    launch_group integer,
    distance_to_cor double precision,
    priority integer
);


--
-- Name: location_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE location_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE location_areas_id_seq OWNED BY location_areas.id;


--
-- Name: location_areas_radio_shack_location_schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE location_areas_radio_shack_location_schedules (
    location_area_id integer NOT NULL,
    radio_shack_location_schedule_id integer NOT NULL
);


--
-- Name: location_client_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE location_client_areas (
    id integer NOT NULL,
    location_id integer NOT NULL,
    client_area_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: location_client_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE location_client_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_client_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE location_client_areas_id_seq OWNED BY location_client_areas.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    display_name character varying,
    store_number character varying NOT NULL,
    street_1 character varying,
    street_2 character varying,
    city character varying NOT NULL,
    state character varying NOT NULL,
    zip character varying,
    channel_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    latitude double precision,
    longitude double precision,
    sprint_radio_shack_training_location_id integer,
    cost_center character varying,
    mail_stop character varying
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: log_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE log_entries (
    id integer NOT NULL,
    person_id integer NOT NULL,
    action character varying NOT NULL,
    comment text,
    trackable_id integer NOT NULL,
    trackable_type character varying NOT NULL,
    referenceable_id integer,
    referenceable_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: log_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE log_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE log_entries_id_seq OWNED BY log_entries.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media (
    id integer NOT NULL,
    mediable_id integer NOT NULL,
    mediable_type character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_id_seq OWNED BY media.id;


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: people_poll_question_choices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people_poll_question_choices (
    person_id integer NOT NULL,
    poll_question_choice_id integer NOT NULL
);


--
-- Name: permission_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE permission_groups (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: permission_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE permission_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permission_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE permission_groups_id_seq OWNED BY permission_groups.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE permissions (
    id integer NOT NULL,
    key character varying NOT NULL,
    description character varying NOT NULL,
    permission_group_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE permissions_id_seq OWNED BY permissions.id;


--
-- Name: permissions_positions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE permissions_positions (
    permission_id integer NOT NULL,
    position_id integer NOT NULL
);


--
-- Name: person_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_addresses (
    id integer NOT NULL,
    person_id integer NOT NULL,
    line_1 character varying NOT NULL,
    line_2 character varying,
    city character varying NOT NULL,
    state character varying NOT NULL,
    zip character varying NOT NULL,
    physical boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    latitude double precision,
    longitude double precision,
    time_zone character varying
);


--
-- Name: person_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_addresses_id_seq OWNED BY person_addresses.id;


--
-- Name: person_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_areas (
    id integer NOT NULL,
    person_id integer NOT NULL,
    area_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    manages boolean DEFAULT false NOT NULL
);


--
-- Name: person_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_areas_id_seq OWNED BY person_areas.id;


--
-- Name: person_client_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_client_areas (
    id integer NOT NULL,
    person_id integer NOT NULL,
    client_area_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: person_client_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_client_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_client_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_client_areas_id_seq OWNED BY person_client_areas.id;


--
-- Name: person_pay_rates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_pay_rates (
    id integer NOT NULL,
    person_id integer NOT NULL,
    wage_type integer NOT NULL,
    rate double precision NOT NULL,
    effective_date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    connect_business_partner_salary_category_id character varying
);


--
-- Name: person_pay_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_pay_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_pay_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_pay_rates_id_seq OWNED BY person_pay_rates.id;


--
-- Name: person_punches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_punches (
    id integer NOT NULL,
    identifier character varying NOT NULL,
    punch_time timestamp without time zone NOT NULL,
    in_or_out integer NOT NULL,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: person_punches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_punches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_punches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_punches_id_seq OWNED BY person_punches.id;


--
-- Name: poll_question_choices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE poll_question_choices (
    id integer NOT NULL,
    poll_question_id integer NOT NULL,
    name character varying NOT NULL,
    help_text text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: poll_question_choices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE poll_question_choices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: poll_question_choices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE poll_question_choices_id_seq OWNED BY poll_question_choices.id;


--
-- Name: poll_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE poll_questions (
    id integer NOT NULL,
    question character varying NOT NULL,
    help_text text,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: poll_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE poll_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: poll_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE poll_questions_id_seq OWNED BY poll_questions.id;


--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE positions_id_seq OWNED BY positions.id;


--
-- Name: prescreen_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prescreen_answers (
    id integer NOT NULL,
    candidate_id integer NOT NULL,
    worked_for_salesmakers boolean DEFAULT false NOT NULL,
    of_age_to_work boolean DEFAULT false NOT NULL,
    eligible_smart_phone boolean DEFAULT false NOT NULL,
    can_work_weekends boolean DEFAULT false NOT NULL,
    reliable_transportation boolean DEFAULT false NOT NULL,
    ok_to_screen boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    worked_for_sprint boolean DEFAULT false NOT NULL,
    high_school_diploma boolean DEFAULT false NOT NULL,
    visible_tattoos boolean DEFAULT false NOT NULL,
    worked_for_radioshack boolean DEFAULT false NOT NULL,
    former_employment_date_start date,
    former_employment_date_end date,
    store_number_city_state character varying
);


--
-- Name: prescreen_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prescreen_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prescreen_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prescreen_answers_id_seq OWNED BY prescreen_answers.id;


--
-- Name: process_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE process_logs (
    id integer NOT NULL,
    process_class character varying NOT NULL,
    records_processed integer DEFAULT 0 NOT NULL,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_logs_id_seq OWNED BY process_logs.id;


--
-- Name: profile_educations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profile_educations (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    school character varying NOT NULL,
    start_year integer NOT NULL,
    end_year integer NOT NULL,
    degree character varying NOT NULL,
    field_of_study character varying NOT NULL,
    activities_societies text,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: profile_educations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profile_educations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profile_educations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profile_educations_id_seq OWNED BY profile_educations.id;


--
-- Name: profile_experiences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profile_experiences (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    company_name character varying NOT NULL,
    title character varying NOT NULL,
    location character varying NOT NULL,
    started date NOT NULL,
    ended date,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    currently_employed boolean
);


--
-- Name: profile_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profile_experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profile_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profile_experiences_id_seq OWNED BY profile_experiences.id;


--
-- Name: profile_skills; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profile_skills (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    skill character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: profile_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profile_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profile_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profile_skills_id_seq OWNED BY profile_skills.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profiles (
    id integer NOT NULL,
    person_id integer NOT NULL,
    theme_name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    interests text,
    bio text,
    avatar_uid character varying,
    image_uid character varying,
    nickname character varying,
    last_seen timestamp without time zone
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying NOT NULL,
    client_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    workmarket_project_num character varying
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: publications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publications (
    id integer NOT NULL,
    publishable_id integer NOT NULL,
    publishable_type character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publications_id_seq OWNED BY publications.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    person_id integer NOT NULL,
    answer_id integer,
    title character varying NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: radio_shack_location_schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE radio_shack_location_schedules (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    monday double precision DEFAULT 0.0 NOT NULL,
    tuesday double precision DEFAULT 0.0 NOT NULL,
    wednesday double precision DEFAULT 0.0 NOT NULL,
    thursday double precision DEFAULT 0.0 NOT NULL,
    friday double precision DEFAULT 0.0 NOT NULL,
    saturday double precision DEFAULT 0.0 NOT NULL,
    sunday double precision DEFAULT 0.0 NOT NULL
);


--
-- Name: radio_shack_location_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE radio_shack_location_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: radio_shack_location_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE radio_shack_location_schedules_id_seq OWNED BY radio_shack_location_schedules.id;


--
-- Name: report_queries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE report_queries (
    id integer NOT NULL,
    name character varying NOT NULL,
    category_name character varying NOT NULL,
    database_name character varying NOT NULL,
    query text NOT NULL,
    permission_key character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    has_date_range boolean DEFAULT false NOT NULL,
    start_date_default character varying
);


--
-- Name: report_queries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE report_queries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: report_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE report_queries_id_seq OWNED BY report_queries.id;


--
-- Name: roster_verification_sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roster_verification_sessions (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    missing_employees character varying
);


--
-- Name: roster_verification_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roster_verification_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roster_verification_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roster_verification_sessions_id_seq OWNED BY roster_verification_sessions.id;


--
-- Name: roster_verifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roster_verifications (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    person_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    last_shift_date date,
    location_id integer,
    envelope_guid character varying,
    roster_verification_session_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    issue character varying
);


--
-- Name: roster_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roster_verifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roster_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roster_verifications_id_seq OWNED BY roster_verifications.id;


--
-- Name: sales_performance_ranks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sales_performance_ranks (
    id integer NOT NULL,
    day date NOT NULL,
    rankable_id integer NOT NULL,
    rankable_type character varying NOT NULL,
    day_rank integer,
    week_rank integer,
    month_rank integer,
    year_rank integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sales_performance_ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sales_performance_ranks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_performance_ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sales_performance_ranks_id_seq OWNED BY sales_performance_ranks.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: screenings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE screenings (
    id integer NOT NULL,
    person_id integer NOT NULL,
    sex_offender_check integer DEFAULT 0 NOT NULL,
    public_background_check integer DEFAULT 0 NOT NULL,
    private_background_check integer DEFAULT 0 NOT NULL,
    drug_screening integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: screenings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE screenings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: screenings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE screenings_id_seq OWNED BY screenings.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: shifts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shifts (
    id integer NOT NULL,
    person_id integer NOT NULL,
    location_id integer,
    date date NOT NULL,
    hours numeric NOT NULL,
    break_hours numeric DEFAULT 0.0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    training boolean DEFAULT false NOT NULL,
    project_id integer
);


--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shifts_id_seq OWNED BY shifts.id;


--
-- Name: sms_daily_checks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sms_daily_checks (
    id integer NOT NULL,
    date date NOT NULL,
    person_id integer NOT NULL,
    sms_id integer NOT NULL,
    check_in_uniform boolean,
    check_in_on_time boolean,
    check_in_inside_store boolean,
    check_out_on_time boolean,
    check_out_inside_store boolean,
    off_day boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    out_time timestamp without time zone,
    in_time timestamp without time zone,
    roll_call boolean,
    blueforce_geotag boolean,
    accountability_checkin_1 boolean,
    accountability_checkin_2 boolean,
    accountability_checkin_3 boolean,
    sales integer,
    notes text
);


--
-- Name: sms_daily_checks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sms_daily_checks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sms_daily_checks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sms_daily_checks_id_seq OWNED BY sms_daily_checks.id;


--
-- Name: sms_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sms_messages (
    id integer NOT NULL,
    from_num character varying NOT NULL,
    to_num character varying NOT NULL,
    from_person_id integer,
    to_person_id integer,
    inbound boolean DEFAULT false,
    reply_to_sms_message_id integer,
    replied_to boolean DEFAULT false,
    message text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    sid character varying NOT NULL,
    from_candidate_id integer,
    to_candidate_id integer
);


--
-- Name: sms_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sms_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sms_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sms_messages_id_seq OWNED BY sms_messages.id;


--
-- Name: sprint_group_me_bots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sprint_group_me_bots (
    id integer NOT NULL,
    group_num character varying NOT NULL,
    bot_num character varying NOT NULL,
    area_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sprint_group_me_bots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sprint_group_me_bots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprint_group_me_bots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sprint_group_me_bots_id_seq OWNED BY sprint_group_me_bots.id;


--
-- Name: sprint_pre_training_welcome_calls; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sprint_pre_training_welcome_calls (
    id integer NOT NULL,
    still_able_to_attend boolean DEFAULT false NOT NULL,
    comment text,
    group_me_reviewed boolean DEFAULT false NOT NULL,
    group_me_confirmed boolean DEFAULT false NOT NULL,
    cloud_reviewed boolean DEFAULT false NOT NULL,
    cloud_confirmed boolean DEFAULT false NOT NULL,
    epay_reviewed boolean DEFAULT false NOT NULL,
    epay_confirmed boolean DEFAULT false NOT NULL,
    candidate_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


--
-- Name: sprint_pre_training_welcome_calls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sprint_pre_training_welcome_calls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprint_pre_training_welcome_calls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sprint_pre_training_welcome_calls_id_seq OWNED BY sprint_pre_training_welcome_calls.id;


--
-- Name: sprint_radio_shack_training_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sprint_radio_shack_training_locations (
    id integer NOT NULL,
    name character varying NOT NULL,
    address character varying NOT NULL,
    room character varying NOT NULL,
    latitude double precision,
    longitude double precision,
    virtual boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sprint_radio_shack_training_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sprint_radio_shack_training_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprint_radio_shack_training_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sprint_radio_shack_training_locations_id_seq OWNED BY sprint_radio_shack_training_locations.id;


--
-- Name: sprint_radio_shack_training_sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sprint_radio_shack_training_sessions (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    start_date date NOT NULL,
    locked boolean DEFAULT false NOT NULL
);


--
-- Name: sprint_radio_shack_training_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sprint_radio_shack_training_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprint_radio_shack_training_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sprint_radio_shack_training_sessions_id_seq OWNED BY sprint_radio_shack_training_sessions.id;


--
-- Name: sprint_sales; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sprint_sales (
    id integer NOT NULL,
    sale_date date NOT NULL,
    person_id integer NOT NULL,
    location_id integer NOT NULL,
    meid character varying NOT NULL,
    mobile_phone character varying,
    carrier_name character varying NOT NULL,
    handset_model_name character varying NOT NULL,
    upgrade boolean DEFAULT false NOT NULL,
    rate_plan_name character varying NOT NULL,
    top_up_card_purchased boolean DEFAULT false NOT NULL,
    top_up_card_amount double precision,
    phone_activated_in_store boolean DEFAULT false NOT NULL,
    reason_not_activated_in_store character varying,
    picture_with_customer character varying,
    comments text,
    connect_sprint_sale_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sprint_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sprint_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprint_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sprint_sales_id_seq OWNED BY sprint_sales.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying,
    tagger_id integer,
    tagger_type character varying,
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: technology_service_providers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE technology_service_providers (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: technology_service_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE technology_service_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: technology_service_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE technology_service_providers_id_seq OWNED BY technology_service_providers.id;


--
-- Name: text_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE text_posts (
    id integer NOT NULL,
    person_id integer NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: text_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE text_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: text_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE text_posts_id_seq OWNED BY text_posts.id;


--
-- Name: themes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE themes (
    id integer NOT NULL,
    name character varying NOT NULL,
    display_name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE themes_id_seq OWNED BY themes.id;


--
-- Name: tmp_csr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tmp_csr (
    store_number character varying,
    connect_salesregion_id character varying
);


--
-- Name: tmp_distances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tmp_distances (
    store_number character varying,
    distance numeric
);


--
-- Name: tmp_sn; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tmp_sn (
    store_number character varying
);


--
-- Name: tmp_swas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tmp_swas (
    store_number character varying,
    openings integer,
    priority integer
);


--
-- Name: tmp_wm; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tmp_wm (
    store_number character varying,
    address_1 character varying,
    city character varying,
    state character varying,
    zip character varying,
    latitude double precision,
    longitude double precision
);


--
-- Name: training_availabilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE training_availabilities (
    id integer NOT NULL,
    able_to_attend boolean DEFAULT false NOT NULL,
    training_unavailability_reason_id integer,
    comments text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    candidate_id integer NOT NULL
);


--
-- Name: training_availabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE training_availabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_availabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE training_availabilities_id_seq OWNED BY training_availabilities.id;


--
-- Name: training_class_attendees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE training_class_attendees (
    id integer NOT NULL,
    person_id integer NOT NULL,
    training_class_id integer NOT NULL,
    attended boolean DEFAULT false NOT NULL,
    dropped_off_time timestamp without time zone,
    drop_off_reason_id integer,
    status integer NOT NULL,
    conditional_pass_condition text,
    group_me_setup boolean DEFAULT false NOT NULL,
    time_clock_setup boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: training_class_attendees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE training_class_attendees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_class_attendees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE training_class_attendees_id_seq OWNED BY training_class_attendees.id;


--
-- Name: training_class_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE training_class_types (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying NOT NULL,
    ancestry character varying,
    max_attendance integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: training_class_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE training_class_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_class_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE training_class_types_id_seq OWNED BY training_class_types.id;


--
-- Name: training_classes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE training_classes (
    id integer NOT NULL,
    training_class_type_id integer,
    training_time_slot_id integer,
    date timestamp without time zone,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: training_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE training_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE training_classes_id_seq OWNED BY training_classes.id;


--
-- Name: training_time_slots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE training_time_slots (
    id integer NOT NULL,
    training_class_type_id integer NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    monday boolean DEFAULT false NOT NULL,
    tuesday boolean DEFAULT false NOT NULL,
    wednesday boolean DEFAULT false NOT NULL,
    thursday boolean DEFAULT false NOT NULL,
    friday boolean DEFAULT false NOT NULL,
    saturday boolean DEFAULT false NOT NULL,
    sunday boolean DEFAULT false NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: training_time_slots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE training_time_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_time_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE training_time_slots_id_seq OWNED BY training_time_slots.id;


--
-- Name: training_unavailability_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE training_unavailability_reasons (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: training_unavailability_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE training_unavailability_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_unavailability_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE training_unavailability_reasons_id_seq OWNED BY training_unavailability_reasons.id;


--
-- Name: unmatched_candidates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE unmatched_candidates (
    id integer NOT NULL,
    last_name character varying NOT NULL,
    first_name character varying NOT NULL,
    email character varying NOT NULL,
    score double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: unmatched_candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE unmatched_candidates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unmatched_candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE unmatched_candidates_id_seq OWNED BY unmatched_candidates.id;


--
-- Name: uploaded_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE uploaded_images (
    id integer NOT NULL,
    image_uid character varying NOT NULL,
    thumbnail_uid character varying NOT NULL,
    preview_uid character varying NOT NULL,
    large_uid character varying NOT NULL,
    person_id integer NOT NULL,
    caption character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    score integer DEFAULT 0 NOT NULL
);


--
-- Name: uploaded_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE uploaded_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: uploaded_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE uploaded_images_id_seq OWNED BY uploaded_images.id;


--
-- Name: uploaded_videos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE uploaded_videos (
    id integer NOT NULL,
    url character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    person_id integer NOT NULL,
    score integer DEFAULT 0 NOT NULL
);


--
-- Name: uploaded_videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE uploaded_videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: uploaded_videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE uploaded_videos_id_seq OWNED BY uploaded_videos.id;


--
-- Name: vcp07012015_hps_sales; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vcp07012015_hps_sales (
    id integer NOT NULL,
    vonage_commission_period07012015_id integer NOT NULL,
    vonage_sale_id integer NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vcp07012015_hps_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vcp07012015_hps_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vcp07012015_hps_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vcp07012015_hps_sales_id_seq OWNED BY vcp07012015_hps_sales.id;


--
-- Name: vcp07012015_hps_shifts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vcp07012015_hps_shifts (
    id integer NOT NULL,
    vonage_commission_period07012015_id integer NOT NULL,
    shift_id integer NOT NULL,
    person_id integer NOT NULL,
    hours double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vcp07012015_hps_shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vcp07012015_hps_shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vcp07012015_hps_shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vcp07012015_hps_shifts_id_seq OWNED BY vcp07012015_hps_shifts.id;


--
-- Name: vcp07012015_vested_sales_sales; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vcp07012015_vested_sales_sales (
    id integer NOT NULL,
    vonage_commission_period07012015_id integer NOT NULL,
    vonage_sale_id integer NOT NULL,
    person_id integer NOT NULL,
    vested boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vcp07012015_vested_sales_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vcp07012015_vested_sales_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vcp07012015_vested_sales_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vcp07012015_vested_sales_sales_id_seq OWNED BY vcp07012015_vested_sales_sales.id;


--
-- Name: vcp07012015_vested_sales_shifts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vcp07012015_vested_sales_shifts (
    id integer NOT NULL,
    vonage_commission_period07012015_id integer NOT NULL,
    shift_id integer NOT NULL,
    person_id integer NOT NULL,
    hours double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vcp07012015_vested_sales_shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vcp07012015_vested_sales_shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vcp07012015_vested_sales_shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vcp07012015_vested_sales_shifts_id_seq OWNED BY vcp07012015_vested_sales_shifts.id;


--
-- Name: version_associations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE version_associations (
    id integer NOT NULL,
    version_id integer,
    foreign_key_name character varying NOT NULL,
    foreign_key_id integer
);


--
-- Name: version_associations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE version_associations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: version_associations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE version_associations_id_seq OWNED BY version_associations.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone,
    transaction_id integer
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: vonage_account_status_changes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vonage_account_status_changes (
    id integer NOT NULL,
    mac character varying NOT NULL,
    account_start_date date NOT NULL,
    account_end_date date,
    status integer NOT NULL,
    termination_reason character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vonage_account_status_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vonage_account_status_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vonage_account_status_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vonage_account_status_changes_id_seq OWNED BY vonage_account_status_changes.id;


--
-- Name: vonage_commission_period07012015s; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vonage_commission_period07012015s (
    id integer NOT NULL,
    name character varying NOT NULL,
    hps_start date,
    hps_end date,
    vested_sales_start date,
    vested_sales_end date,
    cutoff timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vonage_commission_period07012015s_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vonage_commission_period07012015s_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vonage_commission_period07012015s_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vonage_commission_period07012015s_id_seq OWNED BY vonage_commission_period07012015s.id;


--
-- Name: vonage_paycheck_negative_balances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vonage_paycheck_negative_balances (
    id integer NOT NULL,
    person_id integer NOT NULL,
    balance numeric NOT NULL,
    vonage_paycheck_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vonage_paycheck_negative_balances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vonage_paycheck_negative_balances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vonage_paycheck_negative_balances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vonage_paycheck_negative_balances_id_seq OWNED BY vonage_paycheck_negative_balances.id;


--
-- Name: vonage_paychecks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vonage_paychecks (
    id integer NOT NULL,
    name character varying NOT NULL,
    wages_start date NOT NULL,
    wages_end date NOT NULL,
    commission_start date NOT NULL,
    commission_end date NOT NULL,
    cutoff timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vonage_paychecks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vonage_paychecks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vonage_paychecks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vonage_paychecks_id_seq OWNED BY vonage_paychecks.id;


--
-- Name: vonage_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vonage_products (
    id integer NOT NULL,
    name character varying NOT NULL,
    price_range_minimum numeric DEFAULT 0.0 NOT NULL,
    price_range_maximum numeric DEFAULT 9999.99 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vonage_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vonage_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vonage_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vonage_products_id_seq OWNED BY vonage_products.id;


--
-- Name: vonage_refunds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vonage_refunds (
    id integer NOT NULL,
    vonage_sale_id integer NOT NULL,
    vonage_account_status_change_id integer NOT NULL,
    refund_date date NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vonage_refunds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vonage_refunds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vonage_refunds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vonage_refunds_id_seq OWNED BY vonage_refunds.id;


--
-- Name: vonage_rep_sale_payout_brackets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vonage_rep_sale_payout_brackets (
    id integer NOT NULL,
    per_sale numeric NOT NULL,
    area_id integer NOT NULL,
    sales_minimum integer NOT NULL,
    sales_maximum integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vonage_rep_sale_payout_brackets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vonage_rep_sale_payout_brackets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vonage_rep_sale_payout_brackets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vonage_rep_sale_payout_brackets_id_seq OWNED BY vonage_rep_sale_payout_brackets.id;


--
-- Name: vonage_sale_payouts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vonage_sale_payouts (
    id integer NOT NULL,
    vonage_sale_id integer NOT NULL,
    person_id integer NOT NULL,
    payout numeric NOT NULL,
    vonage_paycheck_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    day_62 boolean DEFAULT false NOT NULL,
    day_92 boolean DEFAULT false NOT NULL,
    day_122 boolean DEFAULT false NOT NULL,
    day_152 boolean DEFAULT false NOT NULL
);


--
-- Name: vonage_sale_payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vonage_sale_payouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vonage_sale_payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vonage_sale_payouts_id_seq OWNED BY vonage_sale_payouts.id;


--
-- Name: vonage_sales; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vonage_sales (
    id integer NOT NULL,
    sale_date date NOT NULL,
    person_id integer NOT NULL,
    confirmation_number character varying NOT NULL,
    location_id integer NOT NULL,
    customer_first_name character varying NOT NULL,
    customer_last_name character varying NOT NULL,
    mac character varying NOT NULL,
    vonage_product_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    connect_order_uuid character varying,
    resold boolean DEFAULT false NOT NULL,
    vested boolean,
    person_acknowledged boolean DEFAULT false,
    gift_card_number character varying,
    creator_id integer
);


--
-- Name: vonage_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vonage_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vonage_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vonage_sales_id_seq OWNED BY vonage_sales.id;


--
-- Name: wall_post_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wall_post_comments (
    id integer NOT NULL,
    wall_post_id integer NOT NULL,
    person_id integer NOT NULL,
    comment text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: wall_post_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wall_post_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wall_post_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wall_post_comments_id_seq OWNED BY wall_post_comments.id;


--
-- Name: wall_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wall_posts (
    id integer NOT NULL,
    publication_id integer NOT NULL,
    wall_id integer NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    reposted_by_person_id integer
);


--
-- Name: wall_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wall_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wall_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wall_posts_id_seq OWNED BY wall_posts.id;


--
-- Name: walls; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE walls (
    id integer NOT NULL,
    wallable_id integer NOT NULL,
    wallable_type character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: walls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE walls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: walls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE walls_id_seq OWNED BY walls.id;


--
-- Name: walmart_gift_cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE walmart_gift_cards (
    id integer NOT NULL,
    used boolean DEFAULT false NOT NULL,
    card_number character varying NOT NULL,
    link character varying NOT NULL,
    challenge_code character varying NOT NULL,
    unique_code character varying,
    pin character varying NOT NULL,
    balance double precision DEFAULT 0.0 NOT NULL,
    purchase_date date,
    purchase_amount double precision,
    store_number character varying,
    vonage_sale_id integer,
    overridden boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: walmart_gift_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE walmart_gift_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: walmart_gift_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE walmart_gift_cards_id_seq OWNED BY walmart_gift_cards.id;


--
-- Name: workmarket_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE workmarket_assignments (
    id integer NOT NULL,
    project_id integer NOT NULL,
    json text NOT NULL,
    workmarket_assignment_num character varying NOT NULL,
    title character varying NOT NULL,
    worker_name character varying NOT NULL,
    worker_first_name character varying,
    worker_last_name character varying,
    worker_email character varying NOT NULL,
    cost double precision NOT NULL,
    started timestamp without time zone NOT NULL,
    ended timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    workmarket_location_num character varying NOT NULL
);


--
-- Name: workmarket_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE workmarket_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workmarket_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE workmarket_assignments_id_seq OWNED BY workmarket_assignments.id;


--
-- Name: workmarket_attachments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE workmarket_attachments (
    id integer NOT NULL,
    workmarket_assignment_id integer NOT NULL,
    filename character varying NOT NULL,
    url character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    guid character varying NOT NULL
);


--
-- Name: workmarket_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE workmarket_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workmarket_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE workmarket_attachments_id_seq OWNED BY workmarket_attachments.id;


--
-- Name: workmarket_fields; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE workmarket_fields (
    id integer NOT NULL,
    workmarket_assignment_id integer NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: workmarket_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE workmarket_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workmarket_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE workmarket_fields_id_seq OWNED BY workmarket_fields.id;


--
-- Name: workmarket_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE workmarket_locations (
    id integer NOT NULL,
    workmarket_location_num character varying NOT NULL,
    name character varying NOT NULL,
    location_number character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: workmarket_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE workmarket_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workmarket_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE workmarket_locations_id_seq OWNED BY workmarket_locations.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answer_upvotes ALTER COLUMN id SET DEFAULT nextval('answer_upvotes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY area_candidate_sourcing_groups ALTER COLUMN id SET DEFAULT nextval('area_candidate_sourcing_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY area_types ALTER COLUMN id SET DEFAULT nextval('area_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY areas ALTER COLUMN id SET DEFAULT nextval('areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY blog_posts ALTER COLUMN id SET DEFAULT nextval('blog_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidate_availabilities ALTER COLUMN id SET DEFAULT nextval('candidate_availabilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidate_contacts ALTER COLUMN id SET DEFAULT nextval('candidate_contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidate_denial_reasons ALTER COLUMN id SET DEFAULT nextval('candidate_denial_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidate_drug_tests ALTER COLUMN id SET DEFAULT nextval('candidate_drug_tests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidate_notes ALTER COLUMN id SET DEFAULT nextval('candidate_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidate_reconciliations ALTER COLUMN id SET DEFAULT nextval('candidate_reconciliations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidate_sms_messages ALTER COLUMN id SET DEFAULT nextval('candidate_sms_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidate_sources ALTER COLUMN id SET DEFAULT nextval('candidate_sources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidate_sprint_radio_shack_training_sessions ALTER COLUMN id SET DEFAULT nextval('candidate_sprint_radio_shack_training_sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidates ALTER COLUMN id SET DEFAULT nextval('candidates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY changelog_entries ALTER COLUMN id SET DEFAULT nextval('changelog_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY channels ALTER COLUMN id SET DEFAULT nextval('channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY client_area_types ALTER COLUMN id SET DEFAULT nextval('client_area_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY client_areas ALTER COLUMN id SET DEFAULT nextval('client_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY client_representatives ALTER COLUMN id SET DEFAULT nextval('client_representatives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients ALTER COLUMN id SET DEFAULT nextval('clients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_customer_notes ALTER COLUMN id SET DEFAULT nextval('comcast_customer_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_customers ALTER COLUMN id SET DEFAULT nextval('comcast_customers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_eods ALTER COLUMN id SET DEFAULT nextval('comcast_eods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_former_providers ALTER COLUMN id SET DEFAULT nextval('comcast_former_providers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_group_me_bots ALTER COLUMN id SET DEFAULT nextval('comcast_group_me_bots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_install_appointments ALTER COLUMN id SET DEFAULT nextval('comcast_install_appointments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_install_time_slots ALTER COLUMN id SET DEFAULT nextval('comcast_install_time_slots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_lead_dismissal_reasons ALTER COLUMN id SET DEFAULT nextval('comcast_lead_dismissal_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_leads ALTER COLUMN id SET DEFAULT nextval('comcast_leads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comcast_sales ALTER COLUMN id SET DEFAULT nextval('comcast_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY communication_log_entries ALTER COLUMN id SET DEFAULT nextval('communication_log_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY day_sales_counts ALTER COLUMN id SET DEFAULT nextval('day_sales_counts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY departments ALTER COLUMN id SET DEFAULT nextval('departments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY device_deployments ALTER COLUMN id SET DEFAULT nextval('device_deployments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY device_manufacturers ALTER COLUMN id SET DEFAULT nextval('device_manufacturers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY device_models ALTER COLUMN id SET DEFAULT nextval('device_models_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY device_notes ALTER COLUMN id SET DEFAULT nextval('device_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY device_states ALTER COLUMN id SET DEFAULT nextval('device_states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY devices ALTER COLUMN id SET DEFAULT nextval('devices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directv_customer_notes ALTER COLUMN id SET DEFAULT nextval('directv_customer_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directv_customers ALTER COLUMN id SET DEFAULT nextval('directv_customers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directv_eods ALTER COLUMN id SET DEFAULT nextval('directv_eods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directv_former_providers ALTER COLUMN id SET DEFAULT nextval('directv_former_providers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directv_install_appointments ALTER COLUMN id SET DEFAULT nextval('directv_install_appointments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directv_install_time_slots ALTER COLUMN id SET DEFAULT nextval('directv_install_time_slots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directv_lead_dismissal_reasons ALTER COLUMN id SET DEFAULT nextval('directv_lead_dismissal_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directv_leads ALTER COLUMN id SET DEFAULT nextval('directv_leads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directv_sales ALTER COLUMN id SET DEFAULT nextval('directv_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY docusign_noses ALTER COLUMN id SET DEFAULT nextval('docusign_noses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY docusign_templates ALTER COLUMN id SET DEFAULT nextval('docusign_templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY drop_off_reasons ALTER COLUMN id SET DEFAULT nextval('drop_off_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_messages ALTER COLUMN id SET DEFAULT nextval('email_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employment_end_reasons ALTER COLUMN id SET DEFAULT nextval('employment_end_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employments ALTER COLUMN id SET DEFAULT nextval('employments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_me_groups ALTER COLUMN id SET DEFAULT nextval('group_me_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_me_likes ALTER COLUMN id SET DEFAULT nextval('group_me_likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_me_posts ALTER COLUMN id SET DEFAULT nextval('group_me_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_me_users ALTER COLUMN id SET DEFAULT nextval('group_me_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_areas ALTER COLUMN id SET DEFAULT nextval('historical_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_client_areas ALTER COLUMN id SET DEFAULT nextval('historical_client_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_location_areas ALTER COLUMN id SET DEFAULT nextval('historical_location_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_location_client_areas ALTER COLUMN id SET DEFAULT nextval('historical_location_client_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_locations ALTER COLUMN id SET DEFAULT nextval('historical_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_people ALTER COLUMN id SET DEFAULT nextval('historical_people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_person_areas ALTER COLUMN id SET DEFAULT nextval('historical_person_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY historical_person_client_areas ALTER COLUMN id SET DEFAULT nextval('historical_person_client_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY interview_answers ALTER COLUMN id SET DEFAULT nextval('interview_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY interview_schedules ALTER COLUMN id SET DEFAULT nextval('interview_schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY job_offer_details ALTER COLUMN id SET DEFAULT nextval('job_offer_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes ALTER COLUMN id SET DEFAULT nextval('likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY line_states ALTER COLUMN id SET DEFAULT nextval('line_states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lines ALTER COLUMN id SET DEFAULT nextval('lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY link_posts ALTER COLUMN id SET DEFAULT nextval('link_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY location_areas ALTER COLUMN id SET DEFAULT nextval('location_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY location_client_areas ALTER COLUMN id SET DEFAULT nextval('location_client_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY log_entries ALTER COLUMN id SET DEFAULT nextval('log_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media ALTER COLUMN id SET DEFAULT nextval('media_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY permission_groups ALTER COLUMN id SET DEFAULT nextval('permission_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY permissions ALTER COLUMN id SET DEFAULT nextval('permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_addresses ALTER COLUMN id SET DEFAULT nextval('person_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_areas ALTER COLUMN id SET DEFAULT nextval('person_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_client_areas ALTER COLUMN id SET DEFAULT nextval('person_client_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_pay_rates ALTER COLUMN id SET DEFAULT nextval('person_pay_rates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_punches ALTER COLUMN id SET DEFAULT nextval('person_punches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_question_choices ALTER COLUMN id SET DEFAULT nextval('poll_question_choices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_questions ALTER COLUMN id SET DEFAULT nextval('poll_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY positions ALTER COLUMN id SET DEFAULT nextval('positions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prescreen_answers ALTER COLUMN id SET DEFAULT nextval('prescreen_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_logs ALTER COLUMN id SET DEFAULT nextval('process_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profile_educations ALTER COLUMN id SET DEFAULT nextval('profile_educations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profile_experiences ALTER COLUMN id SET DEFAULT nextval('profile_experiences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profile_skills ALTER COLUMN id SET DEFAULT nextval('profile_skills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY publications ALTER COLUMN id SET DEFAULT nextval('publications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY radio_shack_location_schedules ALTER COLUMN id SET DEFAULT nextval('radio_shack_location_schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY report_queries ALTER COLUMN id SET DEFAULT nextval('report_queries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roster_verification_sessions ALTER COLUMN id SET DEFAULT nextval('roster_verification_sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roster_verifications ALTER COLUMN id SET DEFAULT nextval('roster_verifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sales_performance_ranks ALTER COLUMN id SET DEFAULT nextval('sales_performance_ranks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY screenings ALTER COLUMN id SET DEFAULT nextval('screenings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shifts ALTER COLUMN id SET DEFAULT nextval('shifts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sms_daily_checks ALTER COLUMN id SET DEFAULT nextval('sms_daily_checks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sms_messages ALTER COLUMN id SET DEFAULT nextval('sms_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sprint_group_me_bots ALTER COLUMN id SET DEFAULT nextval('sprint_group_me_bots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sprint_pre_training_welcome_calls ALTER COLUMN id SET DEFAULT nextval('sprint_pre_training_welcome_calls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sprint_radio_shack_training_locations ALTER COLUMN id SET DEFAULT nextval('sprint_radio_shack_training_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sprint_radio_shack_training_sessions ALTER COLUMN id SET DEFAULT nextval('sprint_radio_shack_training_sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sprint_sales ALTER COLUMN id SET DEFAULT nextval('sprint_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY technology_service_providers ALTER COLUMN id SET DEFAULT nextval('technology_service_providers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY text_posts ALTER COLUMN id SET DEFAULT nextval('text_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY themes ALTER COLUMN id SET DEFAULT nextval('themes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY training_availabilities ALTER COLUMN id SET DEFAULT nextval('training_availabilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY training_class_attendees ALTER COLUMN id SET DEFAULT nextval('training_class_attendees_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY training_class_types ALTER COLUMN id SET DEFAULT nextval('training_class_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY training_classes ALTER COLUMN id SET DEFAULT nextval('training_classes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY training_time_slots ALTER COLUMN id SET DEFAULT nextval('training_time_slots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY training_unavailability_reasons ALTER COLUMN id SET DEFAULT nextval('training_unavailability_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY unmatched_candidates ALTER COLUMN id SET DEFAULT nextval('unmatched_candidates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY uploaded_images ALTER COLUMN id SET DEFAULT nextval('uploaded_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY uploaded_videos ALTER COLUMN id SET DEFAULT nextval('uploaded_videos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vcp07012015_hps_sales ALTER COLUMN id SET DEFAULT nextval('vcp07012015_hps_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vcp07012015_hps_shifts ALTER COLUMN id SET DEFAULT nextval('vcp07012015_hps_shifts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vcp07012015_vested_sales_sales ALTER COLUMN id SET DEFAULT nextval('vcp07012015_vested_sales_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vcp07012015_vested_sales_shifts ALTER COLUMN id SET DEFAULT nextval('vcp07012015_vested_sales_shifts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY version_associations ALTER COLUMN id SET DEFAULT nextval('version_associations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vonage_account_status_changes ALTER COLUMN id SET DEFAULT nextval('vonage_account_status_changes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vonage_commission_period07012015s ALTER COLUMN id SET DEFAULT nextval('vonage_commission_period07012015s_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vonage_paycheck_negative_balances ALTER COLUMN id SET DEFAULT nextval('vonage_paycheck_negative_balances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vonage_paychecks ALTER COLUMN id SET DEFAULT nextval('vonage_paychecks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vonage_products ALTER COLUMN id SET DEFAULT nextval('vonage_products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vonage_refunds ALTER COLUMN id SET DEFAULT nextval('vonage_refunds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vonage_rep_sale_payout_brackets ALTER COLUMN id SET DEFAULT nextval('vonage_rep_sale_payout_brackets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vonage_sale_payouts ALTER COLUMN id SET DEFAULT nextval('vonage_sale_payouts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vonage_sales ALTER COLUMN id SET DEFAULT nextval('vonage_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wall_post_comments ALTER COLUMN id SET DEFAULT nextval('wall_post_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wall_posts ALTER COLUMN id SET DEFAULT nextval('wall_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY walls ALTER COLUMN id SET DEFAULT nextval('walls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY walmart_gift_cards ALTER COLUMN id SET DEFAULT nextval('walmart_gift_cards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY workmarket_assignments ALTER COLUMN id SET DEFAULT nextval('workmarket_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY workmarket_attachments ALTER COLUMN id SET DEFAULT nextval('workmarket_attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY workmarket_fields ALTER COLUMN id SET DEFAULT nextval('workmarket_fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY workmarket_locations ALTER COLUMN id SET DEFAULT nextval('workmarket_locations_id_seq'::regclass);


--
-- Name: answer_upvotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answer_upvotes
    ADD CONSTRAINT answer_upvotes_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: area_candidate_sourcing_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY area_candidate_sourcing_groups
    ADD CONSTRAINT area_candidate_sourcing_groups_pkey PRIMARY KEY (id);


--
-- Name: area_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY area_types
    ADD CONSTRAINT area_types_pkey PRIMARY KEY (id);


--
-- Name: areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: blog_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY blog_posts
    ADD CONSTRAINT blog_posts_pkey PRIMARY KEY (id);


--
-- Name: candidate_availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidate_availabilities
    ADD CONSTRAINT candidate_availabilities_pkey PRIMARY KEY (id);


--
-- Name: candidate_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidate_contacts
    ADD CONSTRAINT candidate_contacts_pkey PRIMARY KEY (id);


--
-- Name: candidate_denial_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidate_denial_reasons
    ADD CONSTRAINT candidate_denial_reasons_pkey PRIMARY KEY (id);


--
-- Name: candidate_drug_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidate_drug_tests
    ADD CONSTRAINT candidate_drug_tests_pkey PRIMARY KEY (id);


--
-- Name: candidate_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidate_notes
    ADD CONSTRAINT candidate_notes_pkey PRIMARY KEY (id);


--
-- Name: candidate_reconciliations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidate_reconciliations
    ADD CONSTRAINT candidate_reconciliations_pkey PRIMARY KEY (id);


--
-- Name: candidate_sms_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidate_sms_messages
    ADD CONSTRAINT candidate_sms_messages_pkey PRIMARY KEY (id);


--
-- Name: candidate_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidate_sources
    ADD CONSTRAINT candidate_sources_pkey PRIMARY KEY (id);


--
-- Name: candidate_sprint_radio_shack_training_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidate_sprint_radio_shack_training_sessions
    ADD CONSTRAINT candidate_sprint_radio_shack_training_sessions_pkey PRIMARY KEY (id);


--
-- Name: candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidates
    ADD CONSTRAINT candidates_pkey PRIMARY KEY (id);


--
-- Name: changelog_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY changelog_entries
    ADD CONSTRAINT changelog_entries_pkey PRIMARY KEY (id);


--
-- Name: channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: client_area_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY client_area_types
    ADD CONSTRAINT client_area_types_pkey PRIMARY KEY (id);


--
-- Name: client_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY client_areas
    ADD CONSTRAINT client_areas_pkey PRIMARY KEY (id);


--
-- Name: client_representatives_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY client_representatives
    ADD CONSTRAINT client_representatives_pkey PRIMARY KEY (id);


--
-- Name: clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: comcast_customer_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_customer_notes
    ADD CONSTRAINT comcast_customer_notes_pkey PRIMARY KEY (id);


--
-- Name: comcast_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_customers
    ADD CONSTRAINT comcast_customers_pkey PRIMARY KEY (id);


--
-- Name: comcast_eods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_eods
    ADD CONSTRAINT comcast_eods_pkey PRIMARY KEY (id);


--
-- Name: comcast_former_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_former_providers
    ADD CONSTRAINT comcast_former_providers_pkey PRIMARY KEY (id);


--
-- Name: comcast_group_me_bots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_group_me_bots
    ADD CONSTRAINT comcast_group_me_bots_pkey PRIMARY KEY (id);


--
-- Name: comcast_install_appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_install_appointments
    ADD CONSTRAINT comcast_install_appointments_pkey PRIMARY KEY (id);


--
-- Name: comcast_install_time_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_install_time_slots
    ADD CONSTRAINT comcast_install_time_slots_pkey PRIMARY KEY (id);


--
-- Name: comcast_lead_dismissal_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_lead_dismissal_reasons
    ADD CONSTRAINT comcast_lead_dismissal_reasons_pkey PRIMARY KEY (id);


--
-- Name: comcast_leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_leads
    ADD CONSTRAINT comcast_leads_pkey PRIMARY KEY (id);


--
-- Name: comcast_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comcast_sales
    ADD CONSTRAINT comcast_sales_pkey PRIMARY KEY (id);


--
-- Name: communication_log_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY communication_log_entries
    ADD CONSTRAINT communication_log_entries_pkey PRIMARY KEY (id);


--
-- Name: day_sales_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY day_sales_counts
    ADD CONSTRAINT day_sales_counts_pkey PRIMARY KEY (id);


--
-- Name: departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: device_deployments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY device_deployments
    ADD CONSTRAINT device_deployments_pkey PRIMARY KEY (id);


--
-- Name: device_manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY device_manufacturers
    ADD CONSTRAINT device_manufacturers_pkey PRIMARY KEY (id);


--
-- Name: device_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY device_models
    ADD CONSTRAINT device_models_pkey PRIMARY KEY (id);


--
-- Name: device_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY device_notes
    ADD CONSTRAINT device_notes_pkey PRIMARY KEY (id);


--
-- Name: device_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY device_states
    ADD CONSTRAINT device_states_pkey PRIMARY KEY (id);


--
-- Name: devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: directv_customer_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directv_customer_notes
    ADD CONSTRAINT directv_customer_notes_pkey PRIMARY KEY (id);


--
-- Name: directv_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directv_customers
    ADD CONSTRAINT directv_customers_pkey PRIMARY KEY (id);


--
-- Name: directv_eods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directv_eods
    ADD CONSTRAINT directv_eods_pkey PRIMARY KEY (id);


--
-- Name: directv_former_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directv_former_providers
    ADD CONSTRAINT directv_former_providers_pkey PRIMARY KEY (id);


--
-- Name: directv_install_appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directv_install_appointments
    ADD CONSTRAINT directv_install_appointments_pkey PRIMARY KEY (id);


--
-- Name: directv_install_time_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directv_install_time_slots
    ADD CONSTRAINT directv_install_time_slots_pkey PRIMARY KEY (id);


--
-- Name: directv_lead_dismissal_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directv_lead_dismissal_reasons
    ADD CONSTRAINT directv_lead_dismissal_reasons_pkey PRIMARY KEY (id);


--
-- Name: directv_leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directv_leads
    ADD CONSTRAINT directv_leads_pkey PRIMARY KEY (id);


--
-- Name: directv_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directv_sales
    ADD CONSTRAINT directv_sales_pkey PRIMARY KEY (id);


--
-- Name: docusign_noses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY docusign_noses
    ADD CONSTRAINT docusign_noses_pkey PRIMARY KEY (id);


--
-- Name: docusign_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY docusign_templates
    ADD CONSTRAINT docusign_templates_pkey PRIMARY KEY (id);


--
-- Name: drop_off_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drop_off_reasons
    ADD CONSTRAINT drop_off_reasons_pkey PRIMARY KEY (id);


--
-- Name: email_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY email_messages
    ADD CONSTRAINT email_messages_pkey PRIMARY KEY (id);


--
-- Name: employment_end_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employment_end_reasons
    ADD CONSTRAINT employment_end_reasons_pkey PRIMARY KEY (id);


--
-- Name: employments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employments
    ADD CONSTRAINT employments_pkey PRIMARY KEY (id);


--
-- Name: group_me_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_me_groups
    ADD CONSTRAINT group_me_groups_pkey PRIMARY KEY (id);


--
-- Name: group_me_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_me_likes
    ADD CONSTRAINT group_me_likes_pkey PRIMARY KEY (id);


--
-- Name: group_me_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_me_posts
    ADD CONSTRAINT group_me_posts_pkey PRIMARY KEY (id);


--
-- Name: group_me_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_me_users
    ADD CONSTRAINT group_me_users_pkey PRIMARY KEY (id);


--
-- Name: historical_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY historical_areas
    ADD CONSTRAINT historical_areas_pkey PRIMARY KEY (id);


--
-- Name: historical_client_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY historical_client_areas
    ADD CONSTRAINT historical_client_areas_pkey PRIMARY KEY (id);


--
-- Name: historical_location_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY historical_location_areas
    ADD CONSTRAINT historical_location_areas_pkey PRIMARY KEY (id);


--
-- Name: historical_location_client_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY historical_location_client_areas
    ADD CONSTRAINT historical_location_client_areas_pkey PRIMARY KEY (id);


--
-- Name: historical_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY historical_locations
    ADD CONSTRAINT historical_locations_pkey PRIMARY KEY (id);


--
-- Name: historical_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY historical_people
    ADD CONSTRAINT historical_people_pkey PRIMARY KEY (id);


--
-- Name: historical_person_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY historical_person_areas
    ADD CONSTRAINT historical_person_areas_pkey PRIMARY KEY (id);


--
-- Name: historical_person_client_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY historical_person_client_areas
    ADD CONSTRAINT historical_person_client_areas_pkey PRIMARY KEY (id);


--
-- Name: interview_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interview_answers
    ADD CONSTRAINT interview_answers_pkey PRIMARY KEY (id);


--
-- Name: interview_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY interview_schedules
    ADD CONSTRAINT interview_schedules_pkey PRIMARY KEY (id);


--
-- Name: job_offer_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY job_offer_details
    ADD CONSTRAINT job_offer_details_pkey PRIMARY KEY (id);


--
-- Name: likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: line_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY line_states
    ADD CONSTRAINT line_states_pkey PRIMARY KEY (id);


--
-- Name: lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lines
    ADD CONSTRAINT lines_pkey PRIMARY KEY (id);


--
-- Name: link_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY link_posts
    ADD CONSTRAINT link_posts_pkey PRIMARY KEY (id);


--
-- Name: location_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location_areas
    ADD CONSTRAINT location_areas_pkey PRIMARY KEY (id);


--
-- Name: location_client_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location_client_areas
    ADD CONSTRAINT location_client_areas_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: log_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY log_entries
    ADD CONSTRAINT log_entries_pkey PRIMARY KEY (id);


--
-- Name: media_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: permission_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permission_groups
    ADD CONSTRAINT permission_groups_pkey PRIMARY KEY (id);


--
-- Name: permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: person_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_addresses
    ADD CONSTRAINT person_addresses_pkey PRIMARY KEY (id);


--
-- Name: person_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_areas
    ADD CONSTRAINT person_areas_pkey PRIMARY KEY (id);


--
-- Name: person_client_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_client_areas
    ADD CONSTRAINT person_client_areas_pkey PRIMARY KEY (id);


--
-- Name: person_pay_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_pay_rates
    ADD CONSTRAINT person_pay_rates_pkey PRIMARY KEY (id);


--
-- Name: person_punches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_punches
    ADD CONSTRAINT person_punches_pkey PRIMARY KEY (id);


--
-- Name: poll_question_choices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY poll_question_choices
    ADD CONSTRAINT poll_question_choices_pkey PRIMARY KEY (id);


--
-- Name: poll_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY poll_questions
    ADD CONSTRAINT poll_questions_pkey PRIMARY KEY (id);


--
-- Name: positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: prescreen_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prescreen_answers
    ADD CONSTRAINT prescreen_answers_pkey PRIMARY KEY (id);


--
-- Name: process_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY process_logs
    ADD CONSTRAINT process_logs_pkey PRIMARY KEY (id);


--
-- Name: profile_educations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profile_educations
    ADD CONSTRAINT profile_educations_pkey PRIMARY KEY (id);


--
-- Name: profile_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profile_experiences
    ADD CONSTRAINT profile_experiences_pkey PRIMARY KEY (id);


--
-- Name: profile_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profile_skills
    ADD CONSTRAINT profile_skills_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: radio_shack_location_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY radio_shack_location_schedules
    ADD CONSTRAINT radio_shack_location_schedules_pkey PRIMARY KEY (id);


--
-- Name: report_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY report_queries
    ADD CONSTRAINT report_queries_pkey PRIMARY KEY (id);


--
-- Name: roster_verification_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roster_verification_sessions
    ADD CONSTRAINT roster_verification_sessions_pkey PRIMARY KEY (id);


--
-- Name: roster_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roster_verifications
    ADD CONSTRAINT roster_verifications_pkey PRIMARY KEY (id);


--
-- Name: sales_performance_ranks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sales_performance_ranks
    ADD CONSTRAINT sales_performance_ranks_pkey PRIMARY KEY (id);


--
-- Name: screenings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY screenings
    ADD CONSTRAINT screenings_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- Name: sms_daily_checks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sms_daily_checks
    ADD CONSTRAINT sms_daily_checks_pkey PRIMARY KEY (id);


--
-- Name: sms_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sms_messages
    ADD CONSTRAINT sms_messages_pkey PRIMARY KEY (id);


--
-- Name: sprint_group_me_bots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sprint_group_me_bots
    ADD CONSTRAINT sprint_group_me_bots_pkey PRIMARY KEY (id);


--
-- Name: sprint_pre_training_welcome_calls_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sprint_pre_training_welcome_calls
    ADD CONSTRAINT sprint_pre_training_welcome_calls_pkey PRIMARY KEY (id);


--
-- Name: sprint_radio_shack_training_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sprint_radio_shack_training_locations
    ADD CONSTRAINT sprint_radio_shack_training_locations_pkey PRIMARY KEY (id);


--
-- Name: sprint_radio_shack_training_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sprint_radio_shack_training_sessions
    ADD CONSTRAINT sprint_radio_shack_training_sessions_pkey PRIMARY KEY (id);


--
-- Name: sprint_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sprint_sales
    ADD CONSTRAINT sprint_sales_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: technology_service_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY technology_service_providers
    ADD CONSTRAINT technology_service_providers_pkey PRIMARY KEY (id);


--
-- Name: text_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY text_posts
    ADD CONSTRAINT text_posts_pkey PRIMARY KEY (id);


--
-- Name: themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (id);


--
-- Name: training_availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY training_availabilities
    ADD CONSTRAINT training_availabilities_pkey PRIMARY KEY (id);


--
-- Name: training_class_attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY training_class_attendees
    ADD CONSTRAINT training_class_attendees_pkey PRIMARY KEY (id);


--
-- Name: training_class_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY training_class_types
    ADD CONSTRAINT training_class_types_pkey PRIMARY KEY (id);


--
-- Name: training_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY training_classes
    ADD CONSTRAINT training_classes_pkey PRIMARY KEY (id);


--
-- Name: training_time_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY training_time_slots
    ADD CONSTRAINT training_time_slots_pkey PRIMARY KEY (id);


--
-- Name: training_unavailability_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY training_unavailability_reasons
    ADD CONSTRAINT training_unavailability_reasons_pkey PRIMARY KEY (id);


--
-- Name: unmatched_candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY unmatched_candidates
    ADD CONSTRAINT unmatched_candidates_pkey PRIMARY KEY (id);


--
-- Name: uploaded_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY uploaded_images
    ADD CONSTRAINT uploaded_images_pkey PRIMARY KEY (id);


--
-- Name: uploaded_videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY uploaded_videos
    ADD CONSTRAINT uploaded_videos_pkey PRIMARY KEY (id);


--
-- Name: vcp07012015_hps_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vcp07012015_hps_sales
    ADD CONSTRAINT vcp07012015_hps_sales_pkey PRIMARY KEY (id);


--
-- Name: vcp07012015_hps_shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vcp07012015_hps_shifts
    ADD CONSTRAINT vcp07012015_hps_shifts_pkey PRIMARY KEY (id);


--
-- Name: vcp07012015_vested_sales_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vcp07012015_vested_sales_sales
    ADD CONSTRAINT vcp07012015_vested_sales_sales_pkey PRIMARY KEY (id);


--
-- Name: vcp07012015_vested_sales_shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vcp07012015_vested_sales_shifts
    ADD CONSTRAINT vcp07012015_vested_sales_shifts_pkey PRIMARY KEY (id);


--
-- Name: version_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY version_associations
    ADD CONSTRAINT version_associations_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: vonage_account_status_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vonage_account_status_changes
    ADD CONSTRAINT vonage_account_status_changes_pkey PRIMARY KEY (id);


--
-- Name: vonage_commission_period07012015s_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vonage_commission_period07012015s
    ADD CONSTRAINT vonage_commission_period07012015s_pkey PRIMARY KEY (id);


--
-- Name: vonage_paycheck_negative_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vonage_paycheck_negative_balances
    ADD CONSTRAINT vonage_paycheck_negative_balances_pkey PRIMARY KEY (id);


--
-- Name: vonage_paychecks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vonage_paychecks
    ADD CONSTRAINT vonage_paychecks_pkey PRIMARY KEY (id);


--
-- Name: vonage_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vonage_products
    ADD CONSTRAINT vonage_products_pkey PRIMARY KEY (id);


--
-- Name: vonage_refunds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vonage_refunds
    ADD CONSTRAINT vonage_refunds_pkey PRIMARY KEY (id);


--
-- Name: vonage_rep_sale_payout_brackets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vonage_rep_sale_payout_brackets
    ADD CONSTRAINT vonage_rep_sale_payout_brackets_pkey PRIMARY KEY (id);


--
-- Name: vonage_sale_payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vonage_sale_payouts
    ADD CONSTRAINT vonage_sale_payouts_pkey PRIMARY KEY (id);


--
-- Name: vonage_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vonage_sales
    ADD CONSTRAINT vonage_sales_pkey PRIMARY KEY (id);


--
-- Name: wall_post_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wall_post_comments
    ADD CONSTRAINT wall_post_comments_pkey PRIMARY KEY (id);


--
-- Name: wall_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wall_posts
    ADD CONSTRAINT wall_posts_pkey PRIMARY KEY (id);


--
-- Name: walls_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY walls
    ADD CONSTRAINT walls_pkey PRIMARY KEY (id);


--
-- Name: walmart_gift_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY walmart_gift_cards
    ADD CONSTRAINT walmart_gift_cards_pkey PRIMARY KEY (id);


--
-- Name: workmarket_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY workmarket_assignments
    ADD CONSTRAINT workmarket_assignments_pkey PRIMARY KEY (id);


--
-- Name: workmarket_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY workmarket_attachments
    ADD CONSTRAINT workmarket_attachments_pkey PRIMARY KEY (id);


--
-- Name: workmarket_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY workmarket_fields
    ADD CONSTRAINT workmarket_fields_pkey PRIMARY KEY (id);


--
-- Name: workmarket_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY workmarket_locations
    ADD CONSTRAINT workmarket_locations_pkey PRIMARY KEY (id);


--
-- Name: client_rep_perms_client_rep; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX client_rep_perms_client_rep ON client_representatives_permissions USING btree (client_representative_id);


--
-- Name: client_rep_perms_client_rep_perm; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX client_rep_perms_client_rep_perm ON client_representatives_permissions USING btree (client_representative_id, permission_id);


--
-- Name: client_rep_perms_perm; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX client_rep_perms_perm ON client_representatives_permissions USING btree (permission_id);


--
-- Name: comcast_inst_appts_time_slot; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX comcast_inst_appts_time_slot ON comcast_install_appointments USING btree (comcast_install_time_slot_id);


--
-- Name: directv_inst_appts_time_slot; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX directv_inst_appts_time_slot ON directv_install_appointments USING btree (directv_install_time_slot_id);


--
-- Name: gm_groups_and_users; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gm_groups_and_users ON group_me_groups_group_me_users USING btree (group_me_group_id, group_me_user_id);


--
-- Name: gm_users_and_groups; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX gm_users_and_groups ON group_me_groups_group_me_users USING btree (group_me_user_id, group_me_group_id);


--
-- Name: index_answer_upvotes_on_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answer_upvotes_on_answer_id ON answer_upvotes USING btree (answer_id);


--
-- Name: index_answer_upvotes_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answer_upvotes_on_person_id ON answer_upvotes USING btree (person_id);


--
-- Name: index_answers_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_person_id ON answers USING btree (person_id);


--
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_question_id ON answers USING btree (question_id);


--
-- Name: index_area_candidate_sourcing_groups_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_area_candidate_sourcing_groups_on_project_id ON area_candidate_sourcing_groups USING btree (project_id);


--
-- Name: index_area_types_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_area_types_on_project_id ON area_types USING btree (project_id);


--
-- Name: index_areas_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_areas_on_ancestry ON areas USING btree (ancestry);


--
-- Name: index_areas_on_area_candidate_sourcing_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_areas_on_area_candidate_sourcing_group_id ON areas USING btree (area_candidate_sourcing_group_id);


--
-- Name: index_areas_on_area_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_areas_on_area_type_id ON areas USING btree (area_type_id);


--
-- Name: index_areas_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_areas_on_project_id ON areas USING btree (project_id);


--
-- Name: index_blog_posts_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_blog_posts_on_person_id ON blog_posts USING btree (person_id);


--
-- Name: index_candidate_availabilities_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidate_availabilities_on_candidate_id ON candidate_availabilities USING btree (candidate_id);


--
-- Name: index_candidate_contacts_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidate_contacts_on_candidate_id ON candidate_contacts USING btree (candidate_id);


--
-- Name: index_candidate_contacts_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidate_contacts_on_person_id ON candidate_contacts USING btree (person_id);


--
-- Name: index_candidate_drug_tests_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidate_drug_tests_on_candidate_id ON candidate_drug_tests USING btree (candidate_id);


--
-- Name: index_candidate_notes_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidate_notes_on_candidate_id ON candidate_notes USING btree (candidate_id);


--
-- Name: index_candidate_notes_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidate_notes_on_person_id ON candidate_notes USING btree (person_id);


--
-- Name: index_candidate_reconciliations_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidate_reconciliations_on_candidate_id ON candidate_reconciliations USING btree (candidate_id);


--
-- Name: index_candidates_on_candidate_denial_reason_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidates_on_candidate_denial_reason_id ON candidates USING btree (candidate_denial_reason_id);


--
-- Name: index_candidates_on_candidate_source_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidates_on_candidate_source_id ON candidates USING btree (candidate_source_id);


--
-- Name: index_candidates_on_created_by; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidates_on_created_by ON candidates USING btree (created_by);


--
-- Name: index_candidates_on_location_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidates_on_location_area_id ON candidates USING btree (location_area_id);


--
-- Name: index_candidates_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidates_on_person_id ON candidates USING btree (person_id);


--
-- Name: index_candidates_on_potential_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidates_on_potential_area_id ON candidates USING btree (potential_area_id);


--
-- Name: index_candidates_on_sprint_radio_shack_training_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_candidates_on_sprint_radio_shack_training_session_id ON candidates USING btree (sprint_radio_shack_training_session_id);


--
-- Name: index_changelog_entries_on_department_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_changelog_entries_on_department_id ON changelog_entries USING btree (department_id);


--
-- Name: index_changelog_entries_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_changelog_entries_on_project_id ON changelog_entries USING btree (project_id);


--
-- Name: index_client_areas_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_client_areas_on_ancestry ON client_areas USING btree (ancestry);


--
-- Name: index_client_representatives_on_client_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_client_representatives_on_client_id ON client_representatives USING btree (client_id);


--
-- Name: index_comcast_customer_notes_on_comcast_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_customer_notes_on_comcast_customer_id ON comcast_customer_notes USING btree (comcast_customer_id);


--
-- Name: index_comcast_customer_notes_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_customer_notes_on_person_id ON comcast_customer_notes USING btree (person_id);


--
-- Name: index_comcast_customers_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_customers_on_location_id ON comcast_customers USING btree (location_id);


--
-- Name: index_comcast_customers_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_customers_on_person_id ON comcast_customers USING btree (person_id);


--
-- Name: index_comcast_eods_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_eods_on_location_id ON comcast_eods USING btree (location_id);


--
-- Name: index_comcast_eods_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_eods_on_person_id ON comcast_eods USING btree (person_id);


--
-- Name: index_comcast_former_providers_on_comcast_sale_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_former_providers_on_comcast_sale_id ON comcast_former_providers USING btree (comcast_sale_id);


--
-- Name: index_comcast_group_me_bots_on_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_group_me_bots_on_area_id ON comcast_group_me_bots USING btree (area_id);


--
-- Name: index_comcast_install_appointments_on_comcast_sale_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_install_appointments_on_comcast_sale_id ON comcast_install_appointments USING btree (comcast_sale_id);


--
-- Name: index_comcast_leads_on_comcast_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_leads_on_comcast_customer_id ON comcast_leads USING btree (comcast_customer_id);


--
-- Name: index_comcast_sales_on_comcast_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_sales_on_comcast_customer_id ON comcast_sales USING btree (comcast_customer_id);


--
-- Name: index_comcast_sales_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comcast_sales_on_person_id ON comcast_sales USING btree (person_id);


--
-- Name: index_communication_log_entries_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_communication_log_entries_on_person_id ON communication_log_entries USING btree (person_id);


--
-- Name: index_day_sales_counts_on_saleable_id_and_saleable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_day_sales_counts_on_saleable_id_and_saleable_type ON day_sales_counts USING btree (saleable_id, saleable_type);


--
-- Name: index_device_deployments_on_device_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_device_deployments_on_device_id ON device_deployments USING btree (device_id);


--
-- Name: index_device_deployments_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_device_deployments_on_person_id ON device_deployments USING btree (person_id);


--
-- Name: index_device_models_on_device_manufacturer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_device_models_on_device_manufacturer_id ON device_models USING btree (device_manufacturer_id);


--
-- Name: index_device_states_devices_on_device_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_device_states_devices_on_device_id ON device_states_devices USING btree (device_id);


--
-- Name: index_device_states_devices_on_device_state_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_device_states_devices_on_device_state_id ON device_states_devices USING btree (device_state_id);


--
-- Name: index_devices_on_device_model_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_devices_on_device_model_id ON devices USING btree (device_model_id);


--
-- Name: index_devices_on_line_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_devices_on_line_id ON devices USING btree (line_id);


--
-- Name: index_devices_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_devices_on_person_id ON devices USING btree (person_id);


--
-- Name: index_directv_customer_notes_on_directv_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_customer_notes_on_directv_customer_id ON directv_customer_notes USING btree (directv_customer_id);


--
-- Name: index_directv_customer_notes_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_customer_notes_on_person_id ON directv_customer_notes USING btree (person_id);


--
-- Name: index_directv_customers_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_customers_on_location_id ON directv_customers USING btree (location_id);


--
-- Name: index_directv_customers_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_customers_on_person_id ON directv_customers USING btree (person_id);


--
-- Name: index_directv_eods_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_eods_on_location_id ON directv_eods USING btree (location_id);


--
-- Name: index_directv_eods_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_eods_on_person_id ON directv_eods USING btree (person_id);


--
-- Name: index_directv_former_providers_on_directv_sale_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_former_providers_on_directv_sale_id ON directv_former_providers USING btree (directv_sale_id);


--
-- Name: index_directv_install_appointments_on_directv_sale_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_install_appointments_on_directv_sale_id ON directv_install_appointments USING btree (directv_sale_id);


--
-- Name: index_directv_leads_on_directv_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_leads_on_directv_customer_id ON directv_leads USING btree (directv_customer_id);


--
-- Name: index_directv_sales_on_directv_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_sales_on_directv_customer_id ON directv_sales USING btree (directv_customer_id);


--
-- Name: index_directv_sales_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_directv_sales_on_person_id ON directv_sales USING btree (person_id);


--
-- Name: index_docusign_noses_on_employment_end_reason_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_docusign_noses_on_employment_end_reason_id ON docusign_noses USING btree (employment_end_reason_id);


--
-- Name: index_docusign_noses_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_docusign_noses_on_person_id ON docusign_noses USING btree (person_id);


--
-- Name: index_docusign_templates_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_docusign_templates_on_project_id ON docusign_templates USING btree (project_id);


--
-- Name: index_email_messages_on_to_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_email_messages_on_to_person_id ON email_messages USING btree (to_person_id);


--
-- Name: index_employments_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_employments_on_person_id ON employments USING btree (person_id);


--
-- Name: index_group_me_groups_on_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_groups_on_area_id ON group_me_groups USING btree (area_id);


--
-- Name: index_group_me_likes_on_group_me_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_likes_on_group_me_post_id ON group_me_likes USING btree (group_me_post_id);


--
-- Name: index_group_me_likes_on_group_me_post_id_and_group_me_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_likes_on_group_me_post_id_and_group_me_user_id ON group_me_likes USING btree (group_me_post_id, group_me_user_id);


--
-- Name: index_group_me_likes_on_group_me_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_likes_on_group_me_user_id ON group_me_likes USING btree (group_me_user_id);


--
-- Name: index_group_me_likes_on_group_me_user_id_and_group_me_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_likes_on_group_me_user_id_and_group_me_post_id ON group_me_likes USING btree (group_me_user_id, group_me_post_id);


--
-- Name: index_group_me_posts_on_group_me_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_posts_on_group_me_group_id ON group_me_posts USING btree (group_me_group_id);


--
-- Name: index_group_me_posts_on_group_me_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_posts_on_group_me_user_id ON group_me_posts USING btree (group_me_user_id);


--
-- Name: index_group_me_posts_on_message_num; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_posts_on_message_num ON group_me_posts USING btree (message_num);


--
-- Name: index_group_me_posts_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_posts_on_person_id ON group_me_posts USING btree (person_id);


--
-- Name: index_group_me_users_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_me_users_on_person_id ON group_me_users USING btree (person_id);


--
-- Name: index_historical_areas_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_historical_areas_on_date ON historical_areas USING btree (date);


--
-- Name: index_historical_client_areas_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_historical_client_areas_on_date ON historical_client_areas USING btree (date);


--
-- Name: index_historical_location_areas_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_historical_location_areas_on_date ON historical_location_areas USING btree (date);


--
-- Name: index_historical_location_client_areas_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_historical_location_client_areas_on_date ON historical_location_client_areas USING btree (date);


--
-- Name: index_historical_locations_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_historical_locations_on_date ON historical_locations USING btree (date);


--
-- Name: index_historical_people_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_historical_people_on_date ON historical_people USING btree (date);


--
-- Name: index_historical_person_areas_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_historical_person_areas_on_date ON historical_person_areas USING btree (date);


--
-- Name: index_historical_person_client_areas_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_historical_person_client_areas_on_date ON historical_person_client_areas USING btree (date);


--
-- Name: index_interview_answers_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_interview_answers_on_candidate_id ON interview_answers USING btree (candidate_id);


--
-- Name: index_interview_schedules_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_interview_schedules_on_candidate_id ON interview_schedules USING btree (candidate_id);


--
-- Name: index_interview_schedules_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_interview_schedules_on_person_id ON interview_schedules USING btree (person_id);


--
-- Name: index_job_offer_details_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_job_offer_details_on_candidate_id ON job_offer_details USING btree (candidate_id);


--
-- Name: index_likes_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_likes_on_person_id ON likes USING btree (person_id);


--
-- Name: index_likes_on_wall_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_likes_on_wall_post_id ON likes USING btree (wall_post_id);


--
-- Name: index_line_states_lines_on_line_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_line_states_lines_on_line_id ON line_states_lines USING btree (line_id);


--
-- Name: index_line_states_lines_on_line_state_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_line_states_lines_on_line_state_id ON line_states_lines USING btree (line_state_id);


--
-- Name: index_lines_on_technology_service_provider_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lines_on_technology_service_provider_id ON lines USING btree (technology_service_provider_id);


--
-- Name: index_link_posts_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_link_posts_on_person_id ON link_posts USING btree (person_id);


--
-- Name: index_location_areas_on_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_location_areas_on_area_id ON location_areas USING btree (area_id);


--
-- Name: index_location_areas_on_area_id_and_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_location_areas_on_area_id_and_location_id ON location_areas USING btree (area_id, location_id);


--
-- Name: index_location_areas_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_location_areas_on_location_id ON location_areas USING btree (location_id);


--
-- Name: index_locations_on_channel_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_channel_id ON locations USING btree (channel_id);


--
-- Name: index_locations_on_sprint_radio_shack_training_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_sprint_radio_shack_training_location_id ON locations USING btree (sprint_radio_shack_training_location_id);


--
-- Name: index_log_entries_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_log_entries_on_person_id ON log_entries USING btree (person_id);


--
-- Name: index_log_entries_on_referenceable_type_and_referenceable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_log_entries_on_referenceable_type_and_referenceable_id ON log_entries USING btree (referenceable_type, referenceable_id);


--
-- Name: index_log_entries_on_trackable_type_and_trackable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_log_entries_on_trackable_type_and_trackable_id ON log_entries USING btree (trackable_type, trackable_id);


--
-- Name: index_media_on_mediable_id_and_mediable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_on_mediable_id_and_mediable_type ON media USING btree (mediable_id, mediable_type);


--
-- Name: index_people_on_connect_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_connect_user_id ON people USING btree (connect_user_id);


--
-- Name: index_people_on_group_me_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_group_me_user_id ON people USING btree (group_me_user_id);


--
-- Name: index_people_on_position_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_position_id ON people USING btree (position_id);


--
-- Name: index_people_on_supervisor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_supervisor_id ON people USING btree (supervisor_id);


--
-- Name: index_permissions_on_permission_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_permissions_on_permission_group_id ON permissions USING btree (permission_group_id);


--
-- Name: index_permissions_positions_on_permission_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_permissions_positions_on_permission_id ON permissions_positions USING btree (permission_id);


--
-- Name: index_permissions_positions_on_permission_id_and_position_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_permissions_positions_on_permission_id_and_position_id ON permissions_positions USING btree (permission_id, position_id);


--
-- Name: index_permissions_positions_on_position_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_permissions_positions_on_position_id ON permissions_positions USING btree (position_id);


--
-- Name: index_permissions_positions_on_position_id_and_permission_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_permissions_positions_on_position_id_and_permission_id ON permissions_positions USING btree (position_id, permission_id);


--
-- Name: index_person_addresses_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_person_addresses_on_person_id ON person_addresses USING btree (person_id);


--
-- Name: index_person_areas_on_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_person_areas_on_area_id ON person_areas USING btree (area_id);


--
-- Name: index_person_areas_on_area_id_and_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_person_areas_on_area_id_and_person_id ON person_areas USING btree (area_id, person_id);


--
-- Name: index_person_areas_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_person_areas_on_person_id ON person_areas USING btree (person_id);


--
-- Name: index_person_pay_rates_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_person_pay_rates_on_person_id ON person_pay_rates USING btree (person_id);


--
-- Name: index_person_punches_on_identifier; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_person_punches_on_identifier ON person_punches USING btree (identifier);


--
-- Name: index_person_punches_on_in_or_out; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_person_punches_on_in_or_out ON person_punches USING btree (in_or_out);


--
-- Name: index_person_punches_on_punch_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_person_punches_on_punch_time ON person_punches USING btree (punch_time);


--
-- Name: index_poll_question_choices_on_poll_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_poll_question_choices_on_poll_question_id ON poll_question_choices USING btree (poll_question_id);


--
-- Name: index_positions_on_department_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_positions_on_department_id ON positions USING btree (department_id);


--
-- Name: index_prescreen_answers_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_prescreen_answers_on_candidate_id ON prescreen_answers USING btree (candidate_id);


--
-- Name: index_profile_educations_on_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profile_educations_on_profile_id ON profile_educations USING btree (profile_id);


--
-- Name: index_profile_experiences_on_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profile_experiences_on_profile_id ON profile_experiences USING btree (profile_id);


--
-- Name: index_profile_skills_on_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profile_skills_on_profile_id ON profile_skills USING btree (profile_id);


--
-- Name: index_profiles_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profiles_on_person_id ON profiles USING btree (person_id);


--
-- Name: index_projects_on_client_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_client_id ON projects USING btree (client_id);


--
-- Name: index_publications_on_publishable_id_and_publishable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_publications_on_publishable_id_and_publishable_type ON publications USING btree (publishable_id, publishable_type);


--
-- Name: index_questions_on_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_answer_id ON questions USING btree (answer_id);


--
-- Name: index_questions_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_person_id ON questions USING btree (person_id);


--
-- Name: index_sales_performance_ranks_on_rankable_id_and_rankable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sales_performance_ranks_on_rankable_id_and_rankable_type ON sales_performance_ranks USING btree (rankable_id, rankable_type);


--
-- Name: index_screenings_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_screenings_on_person_id ON screenings USING btree (person_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_shifts_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shifts_on_date ON shifts USING btree (date);

ALTER TABLE shifts CLUSTER ON index_shifts_on_date;


--
-- Name: index_shifts_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shifts_on_location_id ON shifts USING btree (location_id);


--
-- Name: index_shifts_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shifts_on_person_id ON shifts USING btree (person_id);


--
-- Name: index_sms_messages_on_from_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sms_messages_on_from_candidate_id ON sms_messages USING btree (from_candidate_id);


--
-- Name: index_sms_messages_on_from_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sms_messages_on_from_person_id ON sms_messages USING btree (from_person_id);


--
-- Name: index_sms_messages_on_to_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sms_messages_on_to_candidate_id ON sms_messages USING btree (to_candidate_id);


--
-- Name: index_sms_messages_on_to_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sms_messages_on_to_person_id ON sms_messages USING btree (to_person_id);


--
-- Name: index_sprint_group_me_bots_on_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sprint_group_me_bots_on_area_id ON sprint_group_me_bots USING btree (area_id);


--
-- Name: index_sprint_pre_training_welcome_calls_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sprint_pre_training_welcome_calls_on_candidate_id ON sprint_pre_training_welcome_calls USING btree (candidate_id);


--
-- Name: index_sprint_sales_on_connect_sprint_sale_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sprint_sales_on_connect_sprint_sale_id ON sprint_sales USING btree (connect_sprint_sale_id);


--
-- Name: index_sprint_sales_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sprint_sales_on_location_id ON sprint_sales USING btree (location_id);


--
-- Name: index_sprint_sales_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sprint_sales_on_person_id ON sprint_sales USING btree (person_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_text_posts_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_text_posts_on_person_id ON text_posts USING btree (person_id);


--
-- Name: index_training_availabilities_on_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_availabilities_on_candidate_id ON training_availabilities USING btree (candidate_id);


--
-- Name: index_training_class_attendees_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_class_attendees_on_person_id ON training_class_attendees USING btree (person_id);


--
-- Name: index_training_class_attendees_on_training_class_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_class_attendees_on_training_class_id ON training_class_attendees USING btree (training_class_id);


--
-- Name: index_training_class_types_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_class_types_on_ancestry ON training_class_types USING btree (ancestry);


--
-- Name: index_training_class_types_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_class_types_on_project_id ON training_class_types USING btree (project_id);


--
-- Name: index_training_classes_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_classes_on_person_id ON training_classes USING btree (person_id);


--
-- Name: index_training_classes_on_training_class_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_classes_on_training_class_type_id ON training_classes USING btree (training_class_type_id);


--
-- Name: index_training_classes_on_training_time_slot_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_classes_on_training_time_slot_id ON training_classes USING btree (training_time_slot_id);


--
-- Name: index_training_time_slots_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_time_slots_on_person_id ON training_time_slots USING btree (person_id);


--
-- Name: index_training_time_slots_on_training_class_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_time_slots_on_training_class_type_id ON training_time_slots USING btree (training_class_type_id);


--
-- Name: index_uploaded_images_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_uploaded_images_on_person_id ON uploaded_images USING btree (person_id);


--
-- Name: index_uploaded_videos_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_uploaded_videos_on_person_id ON uploaded_videos USING btree (person_id);


--
-- Name: index_version_associations_on_foreign_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_version_associations_on_foreign_key ON version_associations USING btree (foreign_key_name, foreign_key_id);


--
-- Name: index_version_associations_on_version_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_version_associations_on_version_id ON version_associations USING btree (version_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: index_versions_on_transaction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_transaction_id ON versions USING btree (transaction_id);


--
-- Name: index_vonage_account_status_changes_on_account_end_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_account_status_changes_on_account_end_date ON vonage_account_status_changes USING btree (account_end_date);


--
-- Name: index_vonage_account_status_changes_on_mac; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_account_status_changes_on_mac ON vonage_account_status_changes USING btree (mac);


--
-- Name: index_vonage_account_status_changes_on_mac_and_account_end_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_account_status_changes_on_mac_and_account_end_date ON vonage_account_status_changes USING btree (mac, account_end_date);


--
-- Name: index_vonage_account_status_changes_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_account_status_changes_on_status ON vonage_account_status_changes USING btree (status);


--
-- Name: index_vonage_paycheck_negative_balances_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_paycheck_negative_balances_on_person_id ON vonage_paycheck_negative_balances USING btree (person_id);


--
-- Name: index_vonage_refunds_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_refunds_on_person_id ON vonage_refunds USING btree (person_id);


--
-- Name: index_vonage_refunds_on_vonage_account_status_change_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_refunds_on_vonage_account_status_change_id ON vonage_refunds USING btree (vonage_account_status_change_id);


--
-- Name: index_vonage_refunds_on_vonage_sale_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_refunds_on_vonage_sale_id ON vonage_refunds USING btree (vonage_sale_id);


--
-- Name: index_vonage_rep_sale_payout_brackets_on_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_rep_sale_payout_brackets_on_area_id ON vonage_rep_sale_payout_brackets USING btree (area_id);


--
-- Name: index_vonage_sale_payouts_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_sale_payouts_on_person_id ON vonage_sale_payouts USING btree (person_id);


--
-- Name: index_vonage_sale_payouts_on_vonage_paycheck_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_sale_payouts_on_vonage_paycheck_id ON vonage_sale_payouts USING btree (vonage_paycheck_id);


--
-- Name: index_vonage_sale_payouts_on_vonage_sale_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_sale_payouts_on_vonage_sale_id ON vonage_sale_payouts USING btree (vonage_sale_id);


--
-- Name: index_vonage_sales_on_connect_order_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_sales_on_connect_order_uuid ON vonage_sales USING btree (connect_order_uuid);


--
-- Name: index_vonage_sales_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_sales_on_location_id ON vonage_sales USING btree (location_id);


--
-- Name: index_vonage_sales_on_mac; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_sales_on_mac ON vonage_sales USING btree (mac);


--
-- Name: index_vonage_sales_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_sales_on_person_id ON vonage_sales USING btree (person_id);


--
-- Name: index_vonage_sales_on_vonage_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vonage_sales_on_vonage_product_id ON vonage_sales USING btree (vonage_product_id);


--
-- Name: index_wall_post_comments_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_wall_post_comments_on_person_id ON wall_post_comments USING btree (person_id);


--
-- Name: index_wall_post_comments_on_wall_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_wall_post_comments_on_wall_post_id ON wall_post_comments USING btree (wall_post_id);


--
-- Name: index_wall_posts_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_wall_posts_on_person_id ON wall_posts USING btree (person_id);


--
-- Name: index_wall_posts_on_publication_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_wall_posts_on_publication_id ON wall_posts USING btree (publication_id);


--
-- Name: index_wall_posts_on_reposted_by_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_wall_posts_on_reposted_by_person_id ON wall_posts USING btree (reposted_by_person_id);


--
-- Name: index_wall_posts_on_wall_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_wall_posts_on_wall_id ON wall_posts USING btree (wall_id);


--
-- Name: index_walls_on_wallable_id_and_wallable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_walls_on_wallable_id_and_wallable_type ON walls USING btree (wallable_id, wallable_type);


--
-- Name: index_workmarket_assignments_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workmarket_assignments_on_project_id ON workmarket_assignments USING btree (project_id);


--
-- Name: index_workmarket_assignments_on_workmarket_location_num; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workmarket_assignments_on_workmarket_location_num ON workmarket_assignments USING btree (workmarket_location_num);


--
-- Name: index_workmarket_attachments_on_workmarket_assignment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workmarket_attachments_on_workmarket_assignment_id ON workmarket_attachments USING btree (workmarket_assignment_id);


--
-- Name: index_workmarket_fields_on_workmarket_assignment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workmarket_fields_on_workmarket_assignment_id ON workmarket_fields USING btree (workmarket_assignment_id);


--
-- Name: location_areas_location_areas; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX location_areas_location_areas ON location_areas_radio_shack_location_schedules USING btree (location_area_id);


--
-- Name: location_areas_location_areas_rs_schedules; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX location_areas_location_areas_rs_schedules ON location_areas_radio_shack_location_schedules USING btree (location_area_id, radio_shack_location_schedule_id);


--
-- Name: location_areas_rs_schedules; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX location_areas_rs_schedules ON location_areas_radio_shack_location_schedules USING btree (radio_shack_location_schedule_id);


--
-- Name: people_poll_choices_person; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX people_poll_choices_person ON people_poll_question_choices USING btree (person_id);


--
-- Name: people_poll_choices_person_choice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX people_poll_choices_person_choice ON people_poll_question_choices USING btree (poll_question_choice_id, person_id);


--
-- Name: poll_q_choices_poll_q_choice_person; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX poll_q_choices_poll_q_choice_person ON people_poll_question_choices USING btree (poll_question_choice_id, person_id);


--
-- Name: ppqc_choice_person; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ppqc_choice_person ON people_poll_question_choices USING btree (poll_question_choice_id, person_id);


--
-- Name: ppqc_person_choice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ppqc_person_choice ON people_poll_question_choices USING btree (person_id, poll_question_choice_id);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX taggings_idx ON taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: train_avail_unavail_reason; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX train_avail_unavail_reason ON training_availabilities USING btree (training_unavailability_reason_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: vasc_maeds; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX vasc_maeds ON vonage_account_status_changes USING btree (mac, account_end_date, status);


--
-- Name: vcp_hps_sales_report; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX vcp_hps_sales_report ON vcp07012015_hps_sales USING btree (vonage_commission_period07012015_id, person_id);


--
-- Name: vcp_hps_shifts_report; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX vcp_hps_shifts_report ON vcp07012015_hps_shifts USING btree (vonage_commission_period07012015_id, person_id);


--
-- Name: vcp_vs_sales_report; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX vcp_vs_sales_report ON vcp07012015_vested_sales_sales USING btree (vonage_commission_period07012015_id, person_id);


--
-- Name: vcp_vs_shifts_report; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX vcp_vs_shifts_report ON vcp07012015_vested_sales_shifts USING btree (vonage_commission_period07012015_id, person_id);


--
-- Name: vonage_paycheck_neg_bal_paycheck; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX vonage_paycheck_neg_bal_paycheck ON vonage_paycheck_negative_balances USING btree (vonage_paycheck_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140618150457');

INSERT INTO schema_migrations (version) VALUES ('20140618153824');

INSERT INTO schema_migrations (version) VALUES ('20140618180234');

INSERT INTO schema_migrations (version) VALUES ('20140619201014');

INSERT INTO schema_migrations (version) VALUES ('20140619203512');

INSERT INTO schema_migrations (version) VALUES ('20140620144330');

INSERT INTO schema_migrations (version) VALUES ('20140620145253');

INSERT INTO schema_migrations (version) VALUES ('20140620152137');

INSERT INTO schema_migrations (version) VALUES ('20140620153541');

INSERT INTO schema_migrations (version) VALUES ('20140624142658');

INSERT INTO schema_migrations (version) VALUES ('20140624143943');

INSERT INTO schema_migrations (version) VALUES ('20140624150601');

INSERT INTO schema_migrations (version) VALUES ('20140625184048');

INSERT INTO schema_migrations (version) VALUES ('20140625191430');

INSERT INTO schema_migrations (version) VALUES ('20140625192652');

INSERT INTO schema_migrations (version) VALUES ('20140625194253');

INSERT INTO schema_migrations (version) VALUES ('20140627172840');

INSERT INTO schema_migrations (version) VALUES ('20140701151222');

INSERT INTO schema_migrations (version) VALUES ('20140701151931');

INSERT INTO schema_migrations (version) VALUES ('20140701153137');

INSERT INTO schema_migrations (version) VALUES ('20140701153901');

INSERT INTO schema_migrations (version) VALUES ('20140701154453');

INSERT INTO schema_migrations (version) VALUES ('20140701154541');

INSERT INTO schema_migrations (version) VALUES ('20140701155411');

INSERT INTO schema_migrations (version) VALUES ('20140701184347');

INSERT INTO schema_migrations (version) VALUES ('20140701190025');

INSERT INTO schema_migrations (version) VALUES ('20140701190425');

INSERT INTO schema_migrations (version) VALUES ('20140701190831');

INSERT INTO schema_migrations (version) VALUES ('20140702155629');

INSERT INTO schema_migrations (version) VALUES ('20140702160637');

INSERT INTO schema_migrations (version) VALUES ('20140704164034');

INSERT INTO schema_migrations (version) VALUES ('20140708142406');

INSERT INTO schema_migrations (version) VALUES ('20140725141502');

INSERT INTO schema_migrations (version) VALUES ('20140725142730');

INSERT INTO schema_migrations (version) VALUES ('20140728160031');

INSERT INTO schema_migrations (version) VALUES ('20140728160553');

INSERT INTO schema_migrations (version) VALUES ('20140728161914');

INSERT INTO schema_migrations (version) VALUES ('20140820164720');

INSERT INTO schema_migrations (version) VALUES ('20140820170913');

INSERT INTO schema_migrations (version) VALUES ('20140821145725');

INSERT INTO schema_migrations (version) VALUES ('20140821202919');

INSERT INTO schema_migrations (version) VALUES ('20140825182021');

INSERT INTO schema_migrations (version) VALUES ('20140828135610');

INSERT INTO schema_migrations (version) VALUES ('20140828140207');

INSERT INTO schema_migrations (version) VALUES ('20140828140644');

INSERT INTO schema_migrations (version) VALUES ('20140828140821');

INSERT INTO schema_migrations (version) VALUES ('20140828153421');

INSERT INTO schema_migrations (version) VALUES ('20140828181055');

INSERT INTO schema_migrations (version) VALUES ('20140828181125');

INSERT INTO schema_migrations (version) VALUES ('20140828181156');

INSERT INTO schema_migrations (version) VALUES ('20140828181559');

INSERT INTO schema_migrations (version) VALUES ('20140828182143');

INSERT INTO schema_migrations (version) VALUES ('20140828185403');

INSERT INTO schema_migrations (version) VALUES ('20140828185609');

INSERT INTO schema_migrations (version) VALUES ('20140828185655');

INSERT INTO schema_migrations (version) VALUES ('20140828185745');

INSERT INTO schema_migrations (version) VALUES ('20140828192644');

INSERT INTO schema_migrations (version) VALUES ('20140828201021');

INSERT INTO schema_migrations (version) VALUES ('20140828201222');

INSERT INTO schema_migrations (version) VALUES ('20140828201359');

INSERT INTO schema_migrations (version) VALUES ('20140828201908');

INSERT INTO schema_migrations (version) VALUES ('20140828202130');

INSERT INTO schema_migrations (version) VALUES ('20140902135603');

INSERT INTO schema_migrations (version) VALUES ('20140902135823');

INSERT INTO schema_migrations (version) VALUES ('20140902135934');

INSERT INTO schema_migrations (version) VALUES ('20140903203640');

INSERT INTO schema_migrations (version) VALUES ('20140904164424');

INSERT INTO schema_migrations (version) VALUES ('20140904171137');

INSERT INTO schema_migrations (version) VALUES ('20140905154500');

INSERT INTO schema_migrations (version) VALUES ('20140905193558');

INSERT INTO schema_migrations (version) VALUES ('20140912185051');

INSERT INTO schema_migrations (version) VALUES ('20140912191853');

INSERT INTO schema_migrations (version) VALUES ('20140915145826');

INSERT INTO schema_migrations (version) VALUES ('20140915151446');

INSERT INTO schema_migrations (version) VALUES ('20140915165155');

INSERT INTO schema_migrations (version) VALUES ('20140916144703');

INSERT INTO schema_migrations (version) VALUES ('20140916144954');

INSERT INTO schema_migrations (version) VALUES ('20140917171517');

INSERT INTO schema_migrations (version) VALUES ('20140917183933');

INSERT INTO schema_migrations (version) VALUES ('20140918184941');

INSERT INTO schema_migrations (version) VALUES ('20140919125927');

INSERT INTO schema_migrations (version) VALUES ('20140920132408');

INSERT INTO schema_migrations (version) VALUES ('20140922161246');

INSERT INTO schema_migrations (version) VALUES ('20140924145852');

INSERT INTO schema_migrations (version) VALUES ('20140924200457');

INSERT INTO schema_migrations (version) VALUES ('20140926191336');

INSERT INTO schema_migrations (version) VALUES ('20140929200930');

INSERT INTO schema_migrations (version) VALUES ('20140929202154');

INSERT INTO schema_migrations (version) VALUES ('20141002180834');

INSERT INTO schema_migrations (version) VALUES ('20141002181848');

INSERT INTO schema_migrations (version) VALUES ('20141002201720');

INSERT INTO schema_migrations (version) VALUES ('20141007190930');

INSERT INTO schema_migrations (version) VALUES ('20141009185321');

INSERT INTO schema_migrations (version) VALUES ('20141009194917');

INSERT INTO schema_migrations (version) VALUES ('20141009201336');

INSERT INTO schema_migrations (version) VALUES ('20141017181621');

INSERT INTO schema_migrations (version) VALUES ('20141017182753');

INSERT INTO schema_migrations (version) VALUES ('20141023145152');

INSERT INTO schema_migrations (version) VALUES ('20141111203428');

INSERT INTO schema_migrations (version) VALUES ('20141111205604');

INSERT INTO schema_migrations (version) VALUES ('20141211143415');

INSERT INTO schema_migrations (version) VALUES ('20141212212733');

INSERT INTO schema_migrations (version) VALUES ('20141212213522');

INSERT INTO schema_migrations (version) VALUES ('20141217153130');

INSERT INTO schema_migrations (version) VALUES ('20141218203748');

INSERT INTO schema_migrations (version) VALUES ('20141230163211');

INSERT INTO schema_migrations (version) VALUES ('20150112184847');

INSERT INTO schema_migrations (version) VALUES ('20150113123125');

INSERT INTO schema_migrations (version) VALUES ('20150113154649');

INSERT INTO schema_migrations (version) VALUES ('20150114175830');

INSERT INTO schema_migrations (version) VALUES ('20150114182452');

INSERT INTO schema_migrations (version) VALUES ('20150114203158');

INSERT INTO schema_migrations (version) VALUES ('20150114211129');

INSERT INTO schema_migrations (version) VALUES ('20150115183615');

INSERT INTO schema_migrations (version) VALUES ('20150116181532');

INSERT INTO schema_migrations (version) VALUES ('20150122192745');

INSERT INTO schema_migrations (version) VALUES ('20150122212316');

INSERT INTO schema_migrations (version) VALUES ('20150122212920');

INSERT INTO schema_migrations (version) VALUES ('20150122213446');

INSERT INTO schema_migrations (version) VALUES ('20150123125422');

INSERT INTO schema_migrations (version) VALUES ('20150123133647');

INSERT INTO schema_migrations (version) VALUES ('20150123195747');

INSERT INTO schema_migrations (version) VALUES ('20150123200142');

INSERT INTO schema_migrations (version) VALUES ('20150126170110');

INSERT INTO schema_migrations (version) VALUES ('20150126171522');

INSERT INTO schema_migrations (version) VALUES ('20150127152525');

INSERT INTO schema_migrations (version) VALUES ('20150128151528');

INSERT INTO schema_migrations (version) VALUES ('20150128165158');

INSERT INTO schema_migrations (version) VALUES ('20150129190515');

INSERT INTO schema_migrations (version) VALUES ('20150129191521');

INSERT INTO schema_migrations (version) VALUES ('20150129195625');

INSERT INTO schema_migrations (version) VALUES ('20150129195757');

INSERT INTO schema_migrations (version) VALUES ('20150130143232');

INSERT INTO schema_migrations (version) VALUES ('20150130182407');

INSERT INTO schema_migrations (version) VALUES ('20150130193000');

INSERT INTO schema_migrations (version) VALUES ('20150130200534');

INSERT INTO schema_migrations (version) VALUES ('20150130210425');

INSERT INTO schema_migrations (version) VALUES ('20150131194530');

INSERT INTO schema_migrations (version) VALUES ('20150202164621');

INSERT INTO schema_migrations (version) VALUES ('20150202213511');

INSERT INTO schema_migrations (version) VALUES ('20150202214901');

INSERT INTO schema_migrations (version) VALUES ('20150203180416');

INSERT INTO schema_migrations (version) VALUES ('20150206143310');

INSERT INTO schema_migrations (version) VALUES ('20150206161224');

INSERT INTO schema_migrations (version) VALUES ('20150209190030');

INSERT INTO schema_migrations (version) VALUES ('20150209200253');

INSERT INTO schema_migrations (version) VALUES ('20150209200613');

INSERT INTO schema_migrations (version) VALUES ('20150209215510');

INSERT INTO schema_migrations (version) VALUES ('20150210124931');

INSERT INTO schema_migrations (version) VALUES ('20150210152201');

INSERT INTO schema_migrations (version) VALUES ('20150210154728');

INSERT INTO schema_migrations (version) VALUES ('20150210200751');

INSERT INTO schema_migrations (version) VALUES ('20150210210701');

INSERT INTO schema_migrations (version) VALUES ('20150210214840');

INSERT INTO schema_migrations (version) VALUES ('20150212164939');

INSERT INTO schema_migrations (version) VALUES ('20150213123103');

INSERT INTO schema_migrations (version) VALUES ('20150213130324');

INSERT INTO schema_migrations (version) VALUES ('20150213144801');

INSERT INTO schema_migrations (version) VALUES ('20150213151515');

INSERT INTO schema_migrations (version) VALUES ('20150213155845');

INSERT INTO schema_migrations (version) VALUES ('20150213201639');

INSERT INTO schema_migrations (version) VALUES ('20150217135845');

INSERT INTO schema_migrations (version) VALUES ('20150217174922');

INSERT INTO schema_migrations (version) VALUES ('20150218162213');

INSERT INTO schema_migrations (version) VALUES ('20150218194559');

INSERT INTO schema_migrations (version) VALUES ('20150219140332');

INSERT INTO schema_migrations (version) VALUES ('20150224140553');

INSERT INTO schema_migrations (version) VALUES ('20150224152807');

INSERT INTO schema_migrations (version) VALUES ('20150224190117');

INSERT INTO schema_migrations (version) VALUES ('20150225203941');

INSERT INTO schema_migrations (version) VALUES ('20150225204141');

INSERT INTO schema_migrations (version) VALUES ('20150226160234');

INSERT INTO schema_migrations (version) VALUES ('20150226175917');

INSERT INTO schema_migrations (version) VALUES ('20150303145740');

INSERT INTO schema_migrations (version) VALUES ('20150303151215');

INSERT INTO schema_migrations (version) VALUES ('20150303152048');

INSERT INTO schema_migrations (version) VALUES ('20150303155410');

INSERT INTO schema_migrations (version) VALUES ('20150303173513');

INSERT INTO schema_migrations (version) VALUES ('20150303192240');

INSERT INTO schema_migrations (version) VALUES ('20150303195139');

INSERT INTO schema_migrations (version) VALUES ('20150304144503');

INSERT INTO schema_migrations (version) VALUES ('20150304151138');

INSERT INTO schema_migrations (version) VALUES ('20150304184508');

INSERT INTO schema_migrations (version) VALUES ('20150305142548');

INSERT INTO schema_migrations (version) VALUES ('20150305144342');

INSERT INTO schema_migrations (version) VALUES ('20150305150631');

INSERT INTO schema_migrations (version) VALUES ('20150305162557');

INSERT INTO schema_migrations (version) VALUES ('20150305174110');

INSERT INTO schema_migrations (version) VALUES ('20150305181515');

INSERT INTO schema_migrations (version) VALUES ('20150305195537');

INSERT INTO schema_migrations (version) VALUES ('20150305200148');

INSERT INTO schema_migrations (version) VALUES ('20150305203700');

INSERT INTO schema_migrations (version) VALUES ('20150306150836');

INSERT INTO schema_migrations (version) VALUES ('20150306151836');

INSERT INTO schema_migrations (version) VALUES ('20150306153201');

INSERT INTO schema_migrations (version) VALUES ('20150306171023');

INSERT INTO schema_migrations (version) VALUES ('20150306201024');

INSERT INTO schema_migrations (version) VALUES ('20150306210727');

INSERT INTO schema_migrations (version) VALUES ('20150306211125');

INSERT INTO schema_migrations (version) VALUES ('20150306211848');

INSERT INTO schema_migrations (version) VALUES ('20150307132623');

INSERT INTO schema_migrations (version) VALUES ('20150307161419');

INSERT INTO schema_migrations (version) VALUES ('20150307165846');

INSERT INTO schema_migrations (version) VALUES ('20150309192159');

INSERT INTO schema_migrations (version) VALUES ('20150310114150');

INSERT INTO schema_migrations (version) VALUES ('20150310154837');

INSERT INTO schema_migrations (version) VALUES ('20150310175501');

INSERT INTO schema_migrations (version) VALUES ('20150310175646');

INSERT INTO schema_migrations (version) VALUES ('20150310185746');

INSERT INTO schema_migrations (version) VALUES ('20150311115250');

INSERT INTO schema_migrations (version) VALUES ('20150312120950');

INSERT INTO schema_migrations (version) VALUES ('20150312122659');

INSERT INTO schema_migrations (version) VALUES ('20150312130502');

INSERT INTO schema_migrations (version) VALUES ('20150312145007');

INSERT INTO schema_migrations (version) VALUES ('20150312152642');

INSERT INTO schema_migrations (version) VALUES ('20150312153732');

INSERT INTO schema_migrations (version) VALUES ('20150312185051');

INSERT INTO schema_migrations (version) VALUES ('20150312185811');

INSERT INTO schema_migrations (version) VALUES ('20150316140651');

INSERT INTO schema_migrations (version) VALUES ('20150316152716');

INSERT INTO schema_migrations (version) VALUES ('20150316153125');

INSERT INTO schema_migrations (version) VALUES ('20150316163747');

INSERT INTO schema_migrations (version) VALUES ('20150316184635');

INSERT INTO schema_migrations (version) VALUES ('20150316193056');

INSERT INTO schema_migrations (version) VALUES ('20150317141134');

INSERT INTO schema_migrations (version) VALUES ('20150317142315');

INSERT INTO schema_migrations (version) VALUES ('20150317151836');

INSERT INTO schema_migrations (version) VALUES ('20150317154722');

INSERT INTO schema_migrations (version) VALUES ('20150317164439');

INSERT INTO schema_migrations (version) VALUES ('20150317181957');

INSERT INTO schema_migrations (version) VALUES ('20150317182805');

INSERT INTO schema_migrations (version) VALUES ('20150317184547');

INSERT INTO schema_migrations (version) VALUES ('20150317202017');

INSERT INTO schema_migrations (version) VALUES ('20150317202104');

INSERT INTO schema_migrations (version) VALUES ('20150318143025');

INSERT INTO schema_migrations (version) VALUES ('20150318171834');

INSERT INTO schema_migrations (version) VALUES ('20150318202542');

INSERT INTO schema_migrations (version) VALUES ('20150319115014');

INSERT INTO schema_migrations (version) VALUES ('20150319152713');

INSERT INTO schema_migrations (version) VALUES ('20150319160417');

INSERT INTO schema_migrations (version) VALUES ('20150319185443');

INSERT INTO schema_migrations (version) VALUES ('20150320120232');

INSERT INTO schema_migrations (version) VALUES ('20150320143514');

INSERT INTO schema_migrations (version) VALUES ('20150320143651');

INSERT INTO schema_migrations (version) VALUES ('20150320145344');

INSERT INTO schema_migrations (version) VALUES ('20150320150556');

INSERT INTO schema_migrations (version) VALUES ('20150320153519');

INSERT INTO schema_migrations (version) VALUES ('20150320160810');

INSERT INTO schema_migrations (version) VALUES ('20150320165605');

INSERT INTO schema_migrations (version) VALUES ('20150320171037');

INSERT INTO schema_migrations (version) VALUES ('20150320183904');

INSERT INTO schema_migrations (version) VALUES ('20150320201444');

INSERT INTO schema_migrations (version) VALUES ('20150320212222');

INSERT INTO schema_migrations (version) VALUES ('20150320212405');

INSERT INTO schema_migrations (version) VALUES ('20150320212526');

INSERT INTO schema_migrations (version) VALUES ('20150320230456');

INSERT INTO schema_migrations (version) VALUES ('20150321123308');

INSERT INTO schema_migrations (version) VALUES ('20150321123837');

INSERT INTO schema_migrations (version) VALUES ('20150321182419');

INSERT INTO schema_migrations (version) VALUES ('20150321190424');

INSERT INTO schema_migrations (version) VALUES ('20150322183322');

INSERT INTO schema_migrations (version) VALUES ('20150323143347');

INSERT INTO schema_migrations (version) VALUES ('20150323145826');

INSERT INTO schema_migrations (version) VALUES ('20150323153340');

INSERT INTO schema_migrations (version) VALUES ('20150323161539');

INSERT INTO schema_migrations (version) VALUES ('20150323174655');

INSERT INTO schema_migrations (version) VALUES ('20150323175711');

INSERT INTO schema_migrations (version) VALUES ('20150323205812');

INSERT INTO schema_migrations (version) VALUES ('20150324120704');

INSERT INTO schema_migrations (version) VALUES ('20150324151825');

INSERT INTO schema_migrations (version) VALUES ('20150324171342');

INSERT INTO schema_migrations (version) VALUES ('20150324171749');

INSERT INTO schema_migrations (version) VALUES ('20150324182252');

INSERT INTO schema_migrations (version) VALUES ('20150324205030');

INSERT INTO schema_migrations (version) VALUES ('20150324205902');

INSERT INTO schema_migrations (version) VALUES ('20150324213812');

INSERT INTO schema_migrations (version) VALUES ('20150324215717');

INSERT INTO schema_migrations (version) VALUES ('20150324233410');

INSERT INTO schema_migrations (version) VALUES ('20150325124207');

INSERT INTO schema_migrations (version) VALUES ('20150325124525');

INSERT INTO schema_migrations (version) VALUES ('20150325125829');

INSERT INTO schema_migrations (version) VALUES ('20150325135550');

INSERT INTO schema_migrations (version) VALUES ('20150325145323');

INSERT INTO schema_migrations (version) VALUES ('20150325155441');

INSERT INTO schema_migrations (version) VALUES ('20150325162213');

INSERT INTO schema_migrations (version) VALUES ('20150325163955');

INSERT INTO schema_migrations (version) VALUES ('20150325174633');

INSERT INTO schema_migrations (version) VALUES ('20150325185423');

INSERT INTO schema_migrations (version) VALUES ('20150325221552');

INSERT INTO schema_migrations (version) VALUES ('20150326123912');

INSERT INTO schema_migrations (version) VALUES ('20150326143755');

INSERT INTO schema_migrations (version) VALUES ('20150326150350');

INSERT INTO schema_migrations (version) VALUES ('20150326190311');

INSERT INTO schema_migrations (version) VALUES ('20150327124704');

INSERT INTO schema_migrations (version) VALUES ('20150327155720');

INSERT INTO schema_migrations (version) VALUES ('20150327161015');

INSERT INTO schema_migrations (version) VALUES ('20150327163021');

INSERT INTO schema_migrations (version) VALUES ('20150330131339');

INSERT INTO schema_migrations (version) VALUES ('20150330182721');

INSERT INTO schema_migrations (version) VALUES ('20150331151340');

INSERT INTO schema_migrations (version) VALUES ('20150331204658');

INSERT INTO schema_migrations (version) VALUES ('20150331204816');

INSERT INTO schema_migrations (version) VALUES ('20150331210837');

INSERT INTO schema_migrations (version) VALUES ('20150401152903');

INSERT INTO schema_migrations (version) VALUES ('20150403171036');

INSERT INTO schema_migrations (version) VALUES ('20150407132602');

INSERT INTO schema_migrations (version) VALUES ('20150407145115');

INSERT INTO schema_migrations (version) VALUES ('20150407145116');

INSERT INTO schema_migrations (version) VALUES ('20150407145117');

INSERT INTO schema_migrations (version) VALUES ('20150408184219');

INSERT INTO schema_migrations (version) VALUES ('20150409133426');

INSERT INTO schema_migrations (version) VALUES ('20150409155833');

INSERT INTO schema_migrations (version) VALUES ('20150409180459');

INSERT INTO schema_migrations (version) VALUES ('20150409211824');

INSERT INTO schema_migrations (version) VALUES ('20150409220556');

INSERT INTO schema_migrations (version) VALUES ('20150413184303');

INSERT INTO schema_migrations (version) VALUES ('20150414131716');

INSERT INTO schema_migrations (version) VALUES ('20150414133923');

INSERT INTO schema_migrations (version) VALUES ('20150415131251');

INSERT INTO schema_migrations (version) VALUES ('20150415133032');

INSERT INTO schema_migrations (version) VALUES ('20150415195029');

INSERT INTO schema_migrations (version) VALUES ('20150415200037');

INSERT INTO schema_migrations (version) VALUES ('20150415200729');

INSERT INTO schema_migrations (version) VALUES ('20150415201126');

INSERT INTO schema_migrations (version) VALUES ('20150416131721');

INSERT INTO schema_migrations (version) VALUES ('20150419172639');

INSERT INTO schema_migrations (version) VALUES ('20150419174613');

INSERT INTO schema_migrations (version) VALUES ('20150419175240');

INSERT INTO schema_migrations (version) VALUES ('20150419195300');

INSERT INTO schema_migrations (version) VALUES ('20150419195753');

INSERT INTO schema_migrations (version) VALUES ('20150419200840');

INSERT INTO schema_migrations (version) VALUES ('20150419202623');

INSERT INTO schema_migrations (version) VALUES ('20150420145318');

INSERT INTO schema_migrations (version) VALUES ('20150420145647');

INSERT INTO schema_migrations (version) VALUES ('20150420154100');

INSERT INTO schema_migrations (version) VALUES ('20150420155720');

INSERT INTO schema_migrations (version) VALUES ('20150420180755');

INSERT INTO schema_migrations (version) VALUES ('20150420184612');

INSERT INTO schema_migrations (version) VALUES ('20150420184745');

INSERT INTO schema_migrations (version) VALUES ('20150420190404');

INSERT INTO schema_migrations (version) VALUES ('20150420203037');

INSERT INTO schema_migrations (version) VALUES ('20150421011352');

INSERT INTO schema_migrations (version) VALUES ('20150421130513');

INSERT INTO schema_migrations (version) VALUES ('20150421142556');

INSERT INTO schema_migrations (version) VALUES ('20150421172824');

INSERT INTO schema_migrations (version) VALUES ('20150421185709');

INSERT INTO schema_migrations (version) VALUES ('20150421190124');

INSERT INTO schema_migrations (version) VALUES ('20150422124222');

INSERT INTO schema_migrations (version) VALUES ('20150422130503');

INSERT INTO schema_migrations (version) VALUES ('20150422135203');

INSERT INTO schema_migrations (version) VALUES ('20150422144313');

INSERT INTO schema_migrations (version) VALUES ('20150422152137');

INSERT INTO schema_migrations (version) VALUES ('20150422172724');

INSERT INTO schema_migrations (version) VALUES ('20150422185035');

INSERT INTO schema_migrations (version) VALUES ('20150424180158');

INSERT INTO schema_migrations (version) VALUES ('20150424183211');

INSERT INTO schema_migrations (version) VALUES ('20150429163512');

INSERT INTO schema_migrations (version) VALUES ('20150430151516');

INSERT INTO schema_migrations (version) VALUES ('20150504140113');

INSERT INTO schema_migrations (version) VALUES ('20150504183218');

INSERT INTO schema_migrations (version) VALUES ('20150505133652');

INSERT INTO schema_migrations (version) VALUES ('20150508180143');

INSERT INTO schema_migrations (version) VALUES ('20150508210342');

INSERT INTO schema_migrations (version) VALUES ('20150511141146');

INSERT INTO schema_migrations (version) VALUES ('20150511161913');

INSERT INTO schema_migrations (version) VALUES ('20150511174249');

INSERT INTO schema_migrations (version) VALUES ('20150511184858');

INSERT INTO schema_migrations (version) VALUES ('20150512130449');

INSERT INTO schema_migrations (version) VALUES ('20150512173333');

INSERT INTO schema_migrations (version) VALUES ('20150512200336');

INSERT INTO schema_migrations (version) VALUES ('20150513131239');

INSERT INTO schema_migrations (version) VALUES ('20150513141907');

INSERT INTO schema_migrations (version) VALUES ('20150513142932');

INSERT INTO schema_migrations (version) VALUES ('20150513195546');

INSERT INTO schema_migrations (version) VALUES ('20150518175231');

INSERT INTO schema_migrations (version) VALUES ('20150518175833');

INSERT INTO schema_migrations (version) VALUES ('20150518181423');

INSERT INTO schema_migrations (version) VALUES ('20150518181755');

INSERT INTO schema_migrations (version) VALUES ('20150518190213');

INSERT INTO schema_migrations (version) VALUES ('20150518192033');

INSERT INTO schema_migrations (version) VALUES ('20150518195922');

INSERT INTO schema_migrations (version) VALUES ('20150518200314');

INSERT INTO schema_migrations (version) VALUES ('20150518201241');

INSERT INTO schema_migrations (version) VALUES ('20150519144311');

INSERT INTO schema_migrations (version) VALUES ('20150519154529');

INSERT INTO schema_migrations (version) VALUES ('20150519170012');

INSERT INTO schema_migrations (version) VALUES ('20150519175248');

INSERT INTO schema_migrations (version) VALUES ('20150519184043');

INSERT INTO schema_migrations (version) VALUES ('20150520135938');

INSERT INTO schema_migrations (version) VALUES ('20150520163509');

INSERT INTO schema_migrations (version) VALUES ('20150520185046');

INSERT INTO schema_migrations (version) VALUES ('20150521153919');

INSERT INTO schema_migrations (version) VALUES ('20150521181549');

INSERT INTO schema_migrations (version) VALUES ('20150521185631');

INSERT INTO schema_migrations (version) VALUES ('20150522123920');

INSERT INTO schema_migrations (version) VALUES ('20150522124139');

INSERT INTO schema_migrations (version) VALUES ('20150522161528');

INSERT INTO schema_migrations (version) VALUES ('20150526194044');

INSERT INTO schema_migrations (version) VALUES ('20150527130134');

INSERT INTO schema_migrations (version) VALUES ('20150527131459');

INSERT INTO schema_migrations (version) VALUES ('20150527135127');

INSERT INTO schema_migrations (version) VALUES ('20150527143514');

INSERT INTO schema_migrations (version) VALUES ('20150527160958');

INSERT INTO schema_migrations (version) VALUES ('20150527181354');

INSERT INTO schema_migrations (version) VALUES ('20150528184201');

INSERT INTO schema_migrations (version) VALUES ('20150601194407');

INSERT INTO schema_migrations (version) VALUES ('20150602131608');

INSERT INTO schema_migrations (version) VALUES ('20150603133719');

INSERT INTO schema_migrations (version) VALUES ('20150603134104');

INSERT INTO schema_migrations (version) VALUES ('20150603143335');

INSERT INTO schema_migrations (version) VALUES ('20150603143336');

INSERT INTO schema_migrations (version) VALUES ('20150605170318');

INSERT INTO schema_migrations (version) VALUES ('20150608145616');

INSERT INTO schema_migrations (version) VALUES ('20150609180257');

INSERT INTO schema_migrations (version) VALUES ('20150609183902');

INSERT INTO schema_migrations (version) VALUES ('20150609192551');

INSERT INTO schema_migrations (version) VALUES ('20150612155423');

INSERT INTO schema_migrations (version) VALUES ('20150612171321');

INSERT INTO schema_migrations (version) VALUES ('20150612175211');

INSERT INTO schema_migrations (version) VALUES ('20150618184240');

INSERT INTO schema_migrations (version) VALUES ('20150618184500');

INSERT INTO schema_migrations (version) VALUES ('20150622192929');

INSERT INTO schema_migrations (version) VALUES ('20150622195621');

INSERT INTO schema_migrations (version) VALUES ('20150623152104');

INSERT INTO schema_migrations (version) VALUES ('20150624135224');

INSERT INTO schema_migrations (version) VALUES ('20150624135729');

INSERT INTO schema_migrations (version) VALUES ('20150624141348');

INSERT INTO schema_migrations (version) VALUES ('20150624153116');

INSERT INTO schema_migrations (version) VALUES ('20150625174010');

INSERT INTO schema_migrations (version) VALUES ('20150626182711');

INSERT INTO schema_migrations (version) VALUES ('20150626191228');

INSERT INTO schema_migrations (version) VALUES ('20150626191313');

INSERT INTO schema_migrations (version) VALUES ('20150626193106');

INSERT INTO schema_migrations (version) VALUES ('20150626194312');

INSERT INTO schema_migrations (version) VALUES ('20150626194833');

INSERT INTO schema_migrations (version) VALUES ('20150630143153');

INSERT INTO schema_migrations (version) VALUES ('20150701181643');

INSERT INTO schema_migrations (version) VALUES ('20150707200146');

INSERT INTO schema_migrations (version) VALUES ('20150708152321');

INSERT INTO schema_migrations (version) VALUES ('20150709141841');

INSERT INTO schema_migrations (version) VALUES ('20150709183929');

INSERT INTO schema_migrations (version) VALUES ('20150709193232');

INSERT INTO schema_migrations (version) VALUES ('20150709194414');

INSERT INTO schema_migrations (version) VALUES ('20150709195124');

INSERT INTO schema_migrations (version) VALUES ('20150709195850');

INSERT INTO schema_migrations (version) VALUES ('20150713194138');

INSERT INTO schema_migrations (version) VALUES ('20150713194328');

INSERT INTO schema_migrations (version) VALUES ('20150714132627');

INSERT INTO schema_migrations (version) VALUES ('20150716142107');

INSERT INTO schema_migrations (version) VALUES ('20150716142818');

INSERT INTO schema_migrations (version) VALUES ('20150716194648');

INSERT INTO schema_migrations (version) VALUES ('20150716201630');

INSERT INTO schema_migrations (version) VALUES ('20150717144346');

INSERT INTO schema_migrations (version) VALUES ('20150720140615');

INSERT INTO schema_migrations (version) VALUES ('20150721180921');

INSERT INTO schema_migrations (version) VALUES ('20150723144802');

INSERT INTO schema_migrations (version) VALUES ('20150728181149');

INSERT INTO schema_migrations (version) VALUES ('20150728182139');

INSERT INTO schema_migrations (version) VALUES ('20150728182328');

INSERT INTO schema_migrations (version) VALUES ('20150728182625');

INSERT INTO schema_migrations (version) VALUES ('20150728184312');

INSERT INTO schema_migrations (version) VALUES ('20150728190837');

INSERT INTO schema_migrations (version) VALUES ('20150728191114');

INSERT INTO schema_migrations (version) VALUES ('20150728191231');

INSERT INTO schema_migrations (version) VALUES ('20150728191405');

INSERT INTO schema_migrations (version) VALUES ('20150728191425');

INSERT INTO schema_migrations (version) VALUES ('20150728191524');

INSERT INTO schema_migrations (version) VALUES ('20150728191553');

INSERT INTO schema_migrations (version) VALUES ('20150728191615');

INSERT INTO schema_migrations (version) VALUES ('20150728191751');

INSERT INTO schema_migrations (version) VALUES ('20150728194445');

INSERT INTO schema_migrations (version) VALUES ('20150728194639');

INSERT INTO schema_migrations (version) VALUES ('20150729141222');

INSERT INTO schema_migrations (version) VALUES ('20150729145118');

INSERT INTO schema_migrations (version) VALUES ('20150803141142');

INSERT INTO schema_migrations (version) VALUES ('20150805161446');

INSERT INTO schema_migrations (version) VALUES ('20150805235212');

INSERT INTO schema_migrations (version) VALUES ('20150806131842');

INSERT INTO schema_migrations (version) VALUES ('20150806152041');

INSERT INTO schema_migrations (version) VALUES ('20150806162252');

INSERT INTO schema_migrations (version) VALUES ('20150807193021');

INSERT INTO schema_migrations (version) VALUES ('20150807193355');

INSERT INTO schema_migrations (version) VALUES ('20150807193852');

INSERT INTO schema_migrations (version) VALUES ('20150807194138');

INSERT INTO schema_migrations (version) VALUES ('20150807235009');

INSERT INTO schema_migrations (version) VALUES ('20150810144604');

INSERT INTO schema_migrations (version) VALUES ('20150812132503');

INSERT INTO schema_migrations (version) VALUES ('20150817134549');

INSERT INTO schema_migrations (version) VALUES ('20150817141749');

INSERT INTO schema_migrations (version) VALUES ('20150817153612');

INSERT INTO schema_migrations (version) VALUES ('20150817154022');

INSERT INTO schema_migrations (version) VALUES ('20150817181149');

INSERT INTO schema_migrations (version) VALUES ('20150818202108');

INSERT INTO schema_migrations (version) VALUES ('20150819143132');

INSERT INTO schema_migrations (version) VALUES ('20150820124622');

INSERT INTO schema_migrations (version) VALUES ('20150821152703');

INSERT INTO schema_migrations (version) VALUES ('20150821180815');

