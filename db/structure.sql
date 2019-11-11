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
-- Name: mesh_archive; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA mesh_archive;


--
-- Name: proj_cdek_standard_orgs; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA proj_cdek_standard_orgs;


--
-- Name: proj_results_reporting; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA proj_results_reporting;


--
-- Name: proj_tag; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA proj_tag;


--
-- Name: proj_tag_nephrology; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA proj_tag_nephrology;


--
-- Name: proj_tag_osteoporosis; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA proj_tag_osteoporosis;


--
-- Name: proj_tag_pulmonary; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA proj_tag_pulmonary;


--
-- Name: proj_tag_pvd; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA proj_tag_pvd;


--
-- Name: proj_tag_rti; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA proj_tag_rti;


--
-- Name: proj_tag_study_characteristics; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA proj_tag_study_characteristics;


--
-- Name: create_views(); Type: FUNCTION; Schema: proj_tag; Owner: -
--

CREATE FUNCTION proj_tag.create_views() RETURNS void
    LANGUAGE plpgsql STRICT
    AS $$
        BEGIN
          EXECUTE 'CREATE OR REPLACE VIEW proj_tag.current_nephrology_studies AS ' ||
            ' select distinct s.nct_id, s.start_date, s.start_date_type, s.primary_completion_date, s.primary_completion_date_type, ' ||
            '   s.acronym, s.brief_title, s.official_title, s.overall_status, s.phase, ' ||
            '   s.source, s.number_of_arms, s.enrollment, ' ||
            '   regexp_replace(s.baseline_population, E''[\n\r\u2028]+'', '' '', ''g'' ) as baseline_population,  ' ||
            '   regexp_replace(s.why_stopped, E''[\n\r\u2028]+'', '' '', ''g'' ) as why_stopped,  ' ||
            '   regexp_replace(s.limitations_and_caveats, E''[\n\r\u2028]+'', '' '', ''g'' ) as limitations_and_caveats,  ' ||
            '   cv.number_of_facilities, cv.actual_duration, ' ||
            '   cv.were_results_reported, cv.has_us_facility, cv.has_single_facility, ' ||
            '   cv.months_to_report_results , cv.minimum_age_num, cv.minimum_age_unit, ' ||
            '   cv.maximum_age_num, cv.maximum_age_unit, ' ||
            '   d.allocation, d.intervention_model, d.primary_purpose, d.time_perspective, d.masking  ' ||
            '   from ctgov.studies s, ctgov.calculated_values cv, ctgov.designs d ' ||
            '   where s.nct_id = cv.nct_id ' ||
            '     and s.nct_id = d.nct_id  ' ||
            '     and s.nct_id in (        ' ||
              ' select distinct s.nct_id   ' ||
               ' from ctgov.studies s, ctgov.browse_conditions bc ' ||
               ' where s.study_type=''Interventional''  ' ||
                 ' and s.study_first_posted_date >= ''2007-10-01'' ' ||
                 ' and s.nct_id = bc.nct_id ' ||
                 ' and bc.downcase_mesh_term IN (select term from proj_tag_nephrology.tagged_terms) '
              ' union ' ||
              '   select distinct s.nct_id ' ||
              '   from ctgov.studies s, ctgov.keywords k ' ||
              '   where s.study_type=''Interventional'' ' ||
              '   and s.study_first_posted_date >= ''2007-10-01'' ' ||
              '   and s.nct_id = k.nct_id ' ||
              '  and k.downcase_name IN (select term from proj_tag_nephrology.tagged_terms)  ' ||
              ' union  ' ||
              '   select distinct s.nct_id  ' ||
              '   from ctgov.studies s, ctgov.conditions c  ' ||
              '   where s.study_type=''Interventional''  ' ||
              '   and s.study_first_posted_date >= ''2007-10-01''  ' ||
              '   and s.nct_id = c.nct_id  ' ||
              '   and c.downcase_name IN (select term from proj_tag_nephrology.tagged_terms)  ' ||
              '   ) ';

         EXECUTE 'CREATE OR REPLACE VIEW proj_tag.current_mental_health_studies AS ' ||
            ' select distinct s.nct_id, s.start_date, s.start_date_type, s.primary_completion_date, s.primary_completion_date_type, ' ||
            '   s.acronym, s.brief_title, s.official_title, s.overall_status, s.phase, ' ||
            '   s.source, s.number_of_arms, s.enrollment, ' ||
            '   regexp_replace(s.baseline_population, E''[\n\r\u2028]+'', '' '', ''g'' ) as baseline_population,  ' ||
            '   regexp_replace(s.why_stopped, E''[\n\r\u2028]+'', '' '', ''g'' ) as why_stopped,  ' ||
            '   regexp_replace(s.limitations_and_caveats, E''[\n\r\u2028]+'', '' '', ''g'' ) as limitations_and_caveats,  ' ||
            '   cv.number_of_facilities, cv.actual_duration, ' ||
            '   cv.were_results_reported, cv.has_us_facility, cv.has_single_facility, ' ||
            '   cv.months_to_report_results , cv.minimum_age_num, cv.minimum_age_unit, ' ||
            '   cv.maximum_age_num, cv.maximum_age_unit, ' ||
            '   d.allocation, d.intervention_model, d.primary_purpose, d.time_perspective, d.masking  ' ||
            '   from ctgov.studies s, ctgov.calculated_values cv, ctgov.designs d ' ||
            '   where s.nct_id = cv.nct_id ' ||
            '     and s.nct_id = d.nct_id  ' ||
            '     and s.nct_id in (        ' ||
              ' select distinct s.nct_id   ' ||
               ' from ctgov.studies s, ctgov.browse_conditions bc ' ||
               ' where s.study_type=''Interventional''  ' ||
                 ' and s.study_first_posted_date >= ''2007-10-01'' ' ||
                 ' and s.nct_id = bc.nct_id ' ||
                 ' and bc.downcase_mesh_term IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''mental health'') '
              ' union ' ||
              '   select distinct s.nct_id ' ||
              '   from ctgov.studies s, ctgov.keywords k ' ||
              '   where s.study_type=''Interventional'' ' ||
              '   and s.study_first_posted_date >= ''2007-10-01'' ' ||
              '   and s.nct_id = k.nct_id ' ||
              '  and k.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''mental health'')  ' ||
              ' union  ' ||
              '   select distinct s.nct_id  ' ||
              '   from ctgov.studies s, ctgov.conditions c  ' ||
              '   where s.study_type=''Interventional''  ' ||
              '   and s.study_first_posted_date >= ''2007-10-01''  ' ||
              '   and s.nct_id = c.nct_id  ' ||
              '   and c.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''mental health'')  ' ||
              '   ) ';

          EXECUTE 'CREATE OR REPLACE VIEW proj_tag.current_oncology_studies AS ' ||
            ' select distinct s.nct_id, s.start_date, s.start_date_type, s.primary_completion_date, s.primary_completion_date_type, ' ||
            '   s.acronym, s.brief_title, s.official_title, s.overall_status, s.phase, ' ||
            '   s.source, s.number_of_arms, s.enrollment, ' ||
            '   regexp_replace(s.baseline_population, E''[\n\r\u2028]+'', '' '', ''g'' ) as baseline_population,  ' ||
            '   regexp_replace(s.why_stopped, E''[\n\r\u2028]+'', '' '', ''g'' ) as why_stopped,  ' ||
            '   regexp_replace(s.limitations_and_caveats, E''[\n\r\u2028]+'', '' '', ''g'' ) as limitations_and_caveats,  ' ||
            '   cv.number_of_facilities, cv.actual_duration, ' ||
            '   cv.were_results_reported, cv.has_us_facility, cv.has_single_facility, ' ||
            '   cv.months_to_report_results , cv.minimum_age_num, cv.minimum_age_unit, ' ||
            '   cv.maximum_age_num, cv.maximum_age_unit, ' ||
            '   d.allocation, d.intervention_model, d.primary_purpose, d.time_perspective, d.masking  ' ||
            '   from ctgov.studies s, ctgov.calculated_values cv, ctgov.designs d ' ||
            '   where s.nct_id = cv.nct_id ' ||
            '     and s.nct_id = d.nct_id  ' ||
            '     and s.nct_id in (        ' ||
              ' select distinct s.nct_id   ' ||
               ' from ctgov.studies s, ctgov.browse_conditions bc ' ||
               ' where s.study_type=''Interventional''  ' ||
                 ' and s.study_first_posted_date >= ''2007-10-01'' ' ||
                 ' and s.nct_id = bc.nct_id ' ||
                 ' and bc.downcase_mesh_term IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''oncology'') '
              ' union ' ||
              '   select distinct s.nct_id ' ||
              '   from ctgov.studies s, ctgov.keywords k ' ||
              '   where s.study_type=''Interventional'' ' ||
              '   and s.study_first_posted_date >= ''2007-10-01'' ' ||
              '   and s.nct_id = k.nct_id ' ||
              '  and k.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''oncology'')  ' ||
              ' union  ' ||
              '   select distinct s.nct_id  ' ||
              '   from ctgov.studies s, ctgov.conditions c  ' ||
              '   where s.study_type=''Interventional''  ' ||
              '   and s.study_first_posted_date >= ''2007-10-01''  ' ||
              '   and s.nct_id = c.nct_id  ' ||
              '   and c.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''oncology'')  ' ||
              '   ) ';

          EXECUTE 'CREATE OR REPLACE VIEW proj_tag.current_cardiovascular_studies AS ' ||
            ' select distinct s.nct_id, s.start_date, s.start_date_type, s.primary_completion_date, s.primary_completion_date_type, ' ||
            '   s.acronym, s.brief_title, s.official_title, s.overall_status, s.phase, ' ||
            '   s.source, s.number_of_arms, s.enrollment, ' ||
            '   regexp_replace(s.baseline_population, E''[\n\r\u2028]+'', '' '', ''g'' ) as baseline_population,  ' ||
            '   regexp_replace(s.why_stopped, E''[\n\r\u2028]+'', '' '', ''g'' ) as why_stopped,  ' ||
            '   regexp_replace(s.limitations_and_caveats, E''[\n\r\u2028]+'', '' '', ''g'' ) as limitations_and_caveats,  ' ||
            '   cv.number_of_facilities, cv.actual_duration, ' ||
            '   cv.were_results_reported, cv.has_us_facility, cv.has_single_facility, ' ||
            '   cv.months_to_report_results , cv.minimum_age_num, cv.minimum_age_unit, ' ||
            '   cv.maximum_age_num, cv.maximum_age_unit, ' ||
            '   d.allocation, d.intervention_model, d.primary_purpose, d.time_perspective, d.masking  ' ||
            '   from ctgov.studies s, ctgov.calculated_values cv, ctgov.designs d ' ||
            '   where s.nct_id = cv.nct_id ' ||
            '     and s.nct_id = d.nct_id  ' ||
            '     and s.nct_id in (        ' ||
              ' select distinct s.nct_id   ' ||
               ' from ctgov.studies s, ctgov.browse_conditions bc ' ||
               ' where s.study_type=''Interventional''  ' ||
                 ' and s.study_first_posted_date >= ''2007-10-01'' ' ||
                 ' and s.nct_id = bc.nct_id ' ||
                 ' and bc.downcase_mesh_term IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''cardiovascular'') '
              ' union ' ||
              '   select distinct s.nct_id ' ||
              '   from ctgov.studies s, ctgov.keywords k ' ||
              '   where s.study_type=''Interventional'' ' ||
              '   and s.study_first_posted_date >= ''2007-10-01'' ' ||
              '   and s.nct_id = k.nct_id ' ||
              '  and k.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''cardiovascular'')  ' ||
              ' union  ' ||
              '   select distinct s.nct_id  ' ||
              '   from ctgov.studies s, ctgov.conditions c  ' ||
              '   where s.study_type=''Interventional''  ' ||
              '   and s.study_first_posted_date >= ''2007-10-01''  ' ||
              '   and s.nct_id = c.nct_id  ' ||
              '   and c.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''cardiovascular'')  ' ||
              '   ) ';

          RETURN;
        END;
        $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: y2010_mesh_terms; Type: TABLE; Schema: mesh_archive; Owner: -
--

CREATE TABLE mesh_archive.y2010_mesh_terms (
    id bigint NOT NULL,
    qualifier character varying,
    tree_number character varying,
    description character varying,
    mesh_term character varying,
    downcase_mesh_term character varying
);


--
-- Name: y2010_mesh_terms_id_seq; Type: SEQUENCE; Schema: mesh_archive; Owner: -
--

CREATE SEQUENCE mesh_archive.y2010_mesh_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: y2010_mesh_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: mesh_archive; Owner: -
--

ALTER SEQUENCE mesh_archive.y2010_mesh_terms_id_seq OWNED BY mesh_archive.y2010_mesh_terms.id;


--
-- Name: y2016_mesh_headings; Type: TABLE; Schema: mesh_archive; Owner: -
--

CREATE TABLE mesh_archive.y2016_mesh_headings (
    id bigint NOT NULL,
    qualifier character varying,
    heading character varying,
    subcategory character varying
);


--
-- Name: y2016_mesh_headings_id_seq; Type: SEQUENCE; Schema: mesh_archive; Owner: -
--

CREATE SEQUENCE mesh_archive.y2016_mesh_headings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: y2016_mesh_headings_id_seq; Type: SEQUENCE OWNED BY; Schema: mesh_archive; Owner: -
--

ALTER SEQUENCE mesh_archive.y2016_mesh_headings_id_seq OWNED BY mesh_archive.y2016_mesh_headings.id;


--
-- Name: y2016_mesh_terms; Type: TABLE; Schema: mesh_archive; Owner: -
--

CREATE TABLE mesh_archive.y2016_mesh_terms (
    id bigint NOT NULL,
    qualifier character varying,
    tree_number character varying,
    description character varying,
    mesh_term character varying,
    downcase_mesh_term character varying
);


--
-- Name: y2016_mesh_terms_id_seq; Type: SEQUENCE; Schema: mesh_archive; Owner: -
--

CREATE SEQUENCE mesh_archive.y2016_mesh_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: y2016_mesh_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: mesh_archive; Owner: -
--

ALTER SEQUENCE mesh_archive.y2016_mesh_terms_id_seq OWNED BY mesh_archive.y2016_mesh_terms.id;


--
-- Name: y2018_mesh_terms; Type: TABLE; Schema: mesh_archive; Owner: -
--

CREATE TABLE mesh_archive.y2018_mesh_terms (
    id bigint NOT NULL,
    qualifier character varying,
    tree_number character varying,
    description character varying,
    mesh_term character varying,
    downcase_mesh_term character varying
);


--
-- Name: y2018_mesh_terms_id_seq; Type: SEQUENCE; Schema: mesh_archive; Owner: -
--

CREATE SEQUENCE mesh_archive.y2018_mesh_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: y2018_mesh_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: mesh_archive; Owner: -
--

ALTER SEQUENCE mesh_archive.y2018_mesh_terms_id_seq OWNED BY mesh_archive.y2018_mesh_terms.id;


--
-- Name: cdek_organizations; Type: TABLE; Schema: proj_cdek_standard_orgs; Owner: -
--

CREATE TABLE proj_cdek_standard_orgs.cdek_organizations (
    id bigint NOT NULL,
    name character varying,
    downcase_name character varying
);


--
-- Name: cdek_organizations_id_seq; Type: SEQUENCE; Schema: proj_cdek_standard_orgs; Owner: -
--

CREATE SEQUENCE proj_cdek_standard_orgs.cdek_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cdek_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_cdek_standard_orgs; Owner: -
--

ALTER SEQUENCE proj_cdek_standard_orgs.cdek_organizations_id_seq OWNED BY proj_cdek_standard_orgs.cdek_organizations.id;


--
-- Name: cdek_synonyms; Type: TABLE; Schema: proj_cdek_standard_orgs; Owner: -
--

CREATE TABLE proj_cdek_standard_orgs.cdek_synonyms (
    id bigint NOT NULL,
    name character varying,
    preferred_name character varying,
    downcase_name character varying,
    downcase_preferred_name character varying
);


--
-- Name: cdek_synonyms_id_seq; Type: SEQUENCE; Schema: proj_cdek_standard_orgs; Owner: -
--

CREATE SEQUENCE proj_cdek_standard_orgs.cdek_synonyms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cdek_synonyms_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_cdek_standard_orgs; Owner: -
--

ALTER SEQUENCE proj_cdek_standard_orgs.cdek_synonyms_id_seq OWNED BY proj_cdek_standard_orgs.cdek_synonyms.id;


--
-- Name: analyzed_studies; Type: TABLE; Schema: proj_results_reporting; Owner: -
--

CREATE TABLE proj_results_reporting.analyzed_studies (
    id bigint NOT NULL,
    nct_id character varying,
    url character varying,
    brief_title character varying,
    start_month character varying,
    start_year integer,
    overall_status character varying,
    p_completion_month character varying,
    p_completion_year integer,
    completion_month character varying,
    completion_year integer,
    verification_month character varying,
    verification_year integer,
    p_comp_mn integer,
    p_comp_yr integer,
    received_year integer,
    mntopcom integer,
    enrollment integer,
    number_of_arms integer,
    allocation character varying,
    masking character varying,
    phase character varying,
    primary_purpose character varying,
    sponsor_name character varying,
    agency_class character varying,
    collaborator_names character varying,
    funding character varying,
    responsible_party_type character varying,
    responsible_party_organization character varying,
    us_coderc character varying,
    oversight character varying,
    behavioral character varying,
    biological character varying,
    device character varying,
    dietsup character varying,
    drug character varying,
    genetic character varying,
    procedure character varying,
    radiation character varying,
    otherint character varying,
    intervg1 character varying,
    results character varying,
    resultsreceived_month character varying,
    resultsreceived_year character varying,
    firstreceived_results_dt date,
    t2result integer,
    t2result_imp integer,
    t2resmod integer,
    results12 character varying,
    delayed character varying,
    dr_received_dt date,
    mn2delay boolean,
    delayed12 boolean
);


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE; Schema: proj_results_reporting; Owner: -
--

CREATE SEQUENCE proj_results_reporting.analyzed_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_results_reporting; Owner: -
--

ALTER SEQUENCE proj_results_reporting.analyzed_studies_id_seq OWNED BY proj_results_reporting.analyzed_studies.id;


--
-- Name: tagged_terms; Type: TABLE; Schema: proj_tag; Owner: -
--

CREATE TABLE proj_tag.tagged_terms (
    id bigint NOT NULL,
    project_id integer,
    identifier character varying,
    tag character varying,
    term character varying,
    year character varying,
    term_type character varying
);


--
-- Name: tagged_terms_id_seq; Type: SEQUENCE; Schema: proj_tag; Owner: -
--

CREATE SEQUENCE proj_tag.tagged_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tagged_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag; Owner: -
--

ALTER SEQUENCE proj_tag.tagged_terms_id_seq OWNED BY proj_tag.tagged_terms.id;


--
-- Name: analyzed_studies; Type: TABLE; Schema: proj_tag_nephrology; Owner: -
--

CREATE TABLE proj_tag_nephrology.analyzed_studies (
    id bigint NOT NULL,
    nct_id character varying,
    brief_title character varying,
    lead_sponsor character varying
);


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE; Schema: proj_tag_nephrology; Owner: -
--

CREATE SEQUENCE proj_tag_nephrology.analyzed_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_nephrology; Owner: -
--

ALTER SEQUENCE proj_tag_nephrology.analyzed_studies_id_seq OWNED BY proj_tag_nephrology.analyzed_studies.id;


--
-- Name: tagged_terms; Type: TABLE; Schema: proj_tag_nephrology; Owner: -
--

CREATE TABLE proj_tag_nephrology.tagged_terms (
    id bigint NOT NULL,
    tag character varying,
    term character varying,
    term_type character varying
);


--
-- Name: tagged_terms_id_seq; Type: SEQUENCE; Schema: proj_tag_nephrology; Owner: -
--

CREATE SEQUENCE proj_tag_nephrology.tagged_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tagged_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_nephrology; Owner: -
--

ALTER SEQUENCE proj_tag_nephrology.tagged_terms_id_seq OWNED BY proj_tag_nephrology.tagged_terms.id;


--
-- Name: analyzed_studies; Type: TABLE; Schema: proj_tag_osteoporosis; Owner: -
--

CREATE TABLE proj_tag_osteoporosis.analyzed_studies (
    id bigint NOT NULL,
    nct_id character varying,
    brief_title character varying,
    lead_sponsor character varying
);


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE; Schema: proj_tag_osteoporosis; Owner: -
--

CREATE SEQUENCE proj_tag_osteoporosis.analyzed_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_osteoporosis; Owner: -
--

ALTER SEQUENCE proj_tag_osteoporosis.analyzed_studies_id_seq OWNED BY proj_tag_osteoporosis.analyzed_studies.id;


--
-- Name: tagged_terms; Type: VIEW; Schema: proj_tag_osteoporosis; Owner: -
--

CREATE VIEW proj_tag_osteoporosis.tagged_terms AS
 SELECT tagged_terms.id,
    tagged_terms.project_id,
    tagged_terms.identifier,
    tagged_terms.tag,
    tagged_terms.term,
    tagged_terms.year,
    tagged_terms.term_type
   FROM proj_tag.tagged_terms
  WHERE ((tagged_terms.tag)::text = 'osteoporosis'::text);


--
-- Name: analyzed_studies; Type: TABLE; Schema: proj_tag_pulmonary; Owner: -
--

CREATE TABLE proj_tag_pulmonary.analyzed_studies (
    id bigint NOT NULL,
    nct_id character varying,
    brief_title character varying,
    lead_sponsor character varying
);


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE; Schema: proj_tag_pulmonary; Owner: -
--

CREATE SEQUENCE proj_tag_pulmonary.analyzed_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_pulmonary; Owner: -
--

ALTER SEQUENCE proj_tag_pulmonary.analyzed_studies_id_seq OWNED BY proj_tag_pulmonary.analyzed_studies.id;


--
-- Name: tagged_terms; Type: VIEW; Schema: proj_tag_pulmonary; Owner: -
--

CREATE VIEW proj_tag_pulmonary.tagged_terms AS
 SELECT tagged_terms.id,
    tagged_terms.project_id,
    tagged_terms.identifier,
    tagged_terms.tag,
    tagged_terms.term,
    tagged_terms.year,
    tagged_terms.term_type
   FROM proj_tag.tagged_terms
  WHERE ((tagged_terms.tag)::text = 'pulmonary'::text);


--
-- Name: analyzed_studies; Type: TABLE; Schema: proj_tag_pvd; Owner: -
--

CREATE TABLE proj_tag_pvd.analyzed_studies (
    id bigint NOT NULL,
    nct_id character varying,
    brief_title character varying,
    lead_sponsor character varying
);


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE; Schema: proj_tag_pvd; Owner: -
--

CREATE SEQUENCE proj_tag_pvd.analyzed_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_pvd; Owner: -
--

ALTER SEQUENCE proj_tag_pvd.analyzed_studies_id_seq OWNED BY proj_tag_pvd.analyzed_studies.id;


--
-- Name: tagged_terms; Type: VIEW; Schema: proj_tag_pvd; Owner: -
--

CREATE VIEW proj_tag_pvd.tagged_terms AS
 SELECT tagged_terms.id,
    tagged_terms.project_id,
    tagged_terms.identifier,
    tagged_terms.tag,
    tagged_terms.term,
    tagged_terms.year,
    tagged_terms.term_type
   FROM proj_tag.tagged_terms
  WHERE ((tagged_terms.tag)::text = 'peripheral vascular disease'::text);


--
-- Name: analyzed_studies; Type: TABLE; Schema: proj_tag_rti; Owner: -
--

CREATE TABLE proj_tag_rti.analyzed_studies (
    id bigint NOT NULL,
    nct_id character varying,
    brief_title character varying,
    lead_sponsor character varying
);


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE; Schema: proj_tag_rti; Owner: -
--

CREATE SEQUENCE proj_tag_rti.analyzed_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: analyzed_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_rti; Owner: -
--

ALTER SEQUENCE proj_tag_rti.analyzed_studies_id_seq OWNED BY proj_tag_rti.analyzed_studies.id;


--
-- Name: tagged_terms; Type: VIEW; Schema: proj_tag_rti; Owner: -
--

CREATE VIEW proj_tag_rti.tagged_terms AS
 SELECT tagged_terms.id,
    tagged_terms.project_id,
    tagged_terms.identifier,
    tagged_terms.tag,
    tagged_terms.term,
    tagged_terms.year,
    tagged_terms.term_type
   FROM proj_tag.tagged_terms
  WHERE ((tagged_terms.tag)::text = 'respiratory tract infection'::text);


--
-- Name: cardiovascular_studies; Type: TABLE; Schema: proj_tag_study_characteristics; Owner: -
--

CREATE TABLE proj_tag_study_characteristics.cardiovascular_studies (
    id bigint NOT NULL,
    nct_id character varying,
    brief_title character varying,
    lead_sponsor character varying
);


--
-- Name: cardiovascular_studies_id_seq; Type: SEQUENCE; Schema: proj_tag_study_characteristics; Owner: -
--

CREATE SEQUENCE proj_tag_study_characteristics.cardiovascular_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cardiovascular_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER SEQUENCE proj_tag_study_characteristics.cardiovascular_studies_id_seq OWNED BY proj_tag_study_characteristics.cardiovascular_studies.id;


--
-- Name: mental_health_studies; Type: TABLE; Schema: proj_tag_study_characteristics; Owner: -
--

CREATE TABLE proj_tag_study_characteristics.mental_health_studies (
    id bigint NOT NULL,
    nct_id character varying,
    brief_title character varying,
    lead_sponsor character varying
);


--
-- Name: mental_health_studies_id_seq; Type: SEQUENCE; Schema: proj_tag_study_characteristics; Owner: -
--

CREATE SEQUENCE proj_tag_study_characteristics.mental_health_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mental_health_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER SEQUENCE proj_tag_study_characteristics.mental_health_studies_id_seq OWNED BY proj_tag_study_characteristics.mental_health_studies.id;


--
-- Name: oncology_studies; Type: TABLE; Schema: proj_tag_study_characteristics; Owner: -
--

CREATE TABLE proj_tag_study_characteristics.oncology_studies (
    id bigint NOT NULL,
    nct_id character varying,
    brief_title character varying,
    lead_sponsor character varying
);


--
-- Name: oncology_studies_id_seq; Type: SEQUENCE; Schema: proj_tag_study_characteristics; Owner: -
--

CREATE SEQUENCE proj_tag_study_characteristics.oncology_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oncology_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER SEQUENCE proj_tag_study_characteristics.oncology_studies_id_seq OWNED BY proj_tag_study_characteristics.oncology_studies.id;


--
-- Name: tagged_terms; Type: TABLE; Schema: proj_tag_study_characteristics; Owner: -
--

CREATE TABLE proj_tag_study_characteristics.tagged_terms (
    id bigint NOT NULL,
    tag character varying,
    term character varying,
    term_type character varying
);


--
-- Name: tagged_terms_id_seq; Type: SEQUENCE; Schema: proj_tag_study_characteristics; Owner: -
--

CREATE SEQUENCE proj_tag_study_characteristics.tagged_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tagged_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER SEQUENCE proj_tag_study_characteristics.tagged_terms_id_seq OWNED BY proj_tag_study_characteristics.tagged_terms.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: y2010_mesh_terms id; Type: DEFAULT; Schema: mesh_archive; Owner: -
--

ALTER TABLE ONLY mesh_archive.y2010_mesh_terms ALTER COLUMN id SET DEFAULT nextval('mesh_archive.y2010_mesh_terms_id_seq'::regclass);


--
-- Name: y2016_mesh_headings id; Type: DEFAULT; Schema: mesh_archive; Owner: -
--

ALTER TABLE ONLY mesh_archive.y2016_mesh_headings ALTER COLUMN id SET DEFAULT nextval('mesh_archive.y2016_mesh_headings_id_seq'::regclass);


--
-- Name: y2016_mesh_terms id; Type: DEFAULT; Schema: mesh_archive; Owner: -
--

ALTER TABLE ONLY mesh_archive.y2016_mesh_terms ALTER COLUMN id SET DEFAULT nextval('mesh_archive.y2016_mesh_terms_id_seq'::regclass);


--
-- Name: y2018_mesh_terms id; Type: DEFAULT; Schema: mesh_archive; Owner: -
--

ALTER TABLE ONLY mesh_archive.y2018_mesh_terms ALTER COLUMN id SET DEFAULT nextval('mesh_archive.y2018_mesh_terms_id_seq'::regclass);


--
-- Name: cdek_organizations id; Type: DEFAULT; Schema: proj_cdek_standard_orgs; Owner: -
--

ALTER TABLE ONLY proj_cdek_standard_orgs.cdek_organizations ALTER COLUMN id SET DEFAULT nextval('proj_cdek_standard_orgs.cdek_organizations_id_seq'::regclass);


--
-- Name: cdek_synonyms id; Type: DEFAULT; Schema: proj_cdek_standard_orgs; Owner: -
--

ALTER TABLE ONLY proj_cdek_standard_orgs.cdek_synonyms ALTER COLUMN id SET DEFAULT nextval('proj_cdek_standard_orgs.cdek_synonyms_id_seq'::regclass);


--
-- Name: analyzed_studies id; Type: DEFAULT; Schema: proj_results_reporting; Owner: -
--

ALTER TABLE ONLY proj_results_reporting.analyzed_studies ALTER COLUMN id SET DEFAULT nextval('proj_results_reporting.analyzed_studies_id_seq'::regclass);


--
-- Name: tagged_terms id; Type: DEFAULT; Schema: proj_tag; Owner: -
--

ALTER TABLE ONLY proj_tag.tagged_terms ALTER COLUMN id SET DEFAULT nextval('proj_tag.tagged_terms_id_seq'::regclass);


--
-- Name: analyzed_studies id; Type: DEFAULT; Schema: proj_tag_nephrology; Owner: -
--

ALTER TABLE ONLY proj_tag_nephrology.analyzed_studies ALTER COLUMN id SET DEFAULT nextval('proj_tag_nephrology.analyzed_studies_id_seq'::regclass);


--
-- Name: tagged_terms id; Type: DEFAULT; Schema: proj_tag_nephrology; Owner: -
--

ALTER TABLE ONLY proj_tag_nephrology.tagged_terms ALTER COLUMN id SET DEFAULT nextval('proj_tag_nephrology.tagged_terms_id_seq'::regclass);


--
-- Name: analyzed_studies id; Type: DEFAULT; Schema: proj_tag_osteoporosis; Owner: -
--

ALTER TABLE ONLY proj_tag_osteoporosis.analyzed_studies ALTER COLUMN id SET DEFAULT nextval('proj_tag_osteoporosis.analyzed_studies_id_seq'::regclass);


--
-- Name: analyzed_studies id; Type: DEFAULT; Schema: proj_tag_pulmonary; Owner: -
--

ALTER TABLE ONLY proj_tag_pulmonary.analyzed_studies ALTER COLUMN id SET DEFAULT nextval('proj_tag_pulmonary.analyzed_studies_id_seq'::regclass);


--
-- Name: analyzed_studies id; Type: DEFAULT; Schema: proj_tag_pvd; Owner: -
--

ALTER TABLE ONLY proj_tag_pvd.analyzed_studies ALTER COLUMN id SET DEFAULT nextval('proj_tag_pvd.analyzed_studies_id_seq'::regclass);


--
-- Name: analyzed_studies id; Type: DEFAULT; Schema: proj_tag_rti; Owner: -
--

ALTER TABLE ONLY proj_tag_rti.analyzed_studies ALTER COLUMN id SET DEFAULT nextval('proj_tag_rti.analyzed_studies_id_seq'::regclass);


--
-- Name: cardiovascular_studies id; Type: DEFAULT; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER TABLE ONLY proj_tag_study_characteristics.cardiovascular_studies ALTER COLUMN id SET DEFAULT nextval('proj_tag_study_characteristics.cardiovascular_studies_id_seq'::regclass);


--
-- Name: mental_health_studies id; Type: DEFAULT; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER TABLE ONLY proj_tag_study_characteristics.mental_health_studies ALTER COLUMN id SET DEFAULT nextval('proj_tag_study_characteristics.mental_health_studies_id_seq'::regclass);


--
-- Name: oncology_studies id; Type: DEFAULT; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER TABLE ONLY proj_tag_study_characteristics.oncology_studies ALTER COLUMN id SET DEFAULT nextval('proj_tag_study_characteristics.oncology_studies_id_seq'::regclass);


--
-- Name: tagged_terms id; Type: DEFAULT; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER TABLE ONLY proj_tag_study_characteristics.tagged_terms ALTER COLUMN id SET DEFAULT nextval('proj_tag_study_characteristics.tagged_terms_id_seq'::regclass);


--
-- Name: y2010_mesh_terms y2010_mesh_terms_pkey; Type: CONSTRAINT; Schema: mesh_archive; Owner: -
--

ALTER TABLE ONLY mesh_archive.y2010_mesh_terms
    ADD CONSTRAINT y2010_mesh_terms_pkey PRIMARY KEY (id);


--
-- Name: y2016_mesh_headings y2016_mesh_headings_pkey; Type: CONSTRAINT; Schema: mesh_archive; Owner: -
--

ALTER TABLE ONLY mesh_archive.y2016_mesh_headings
    ADD CONSTRAINT y2016_mesh_headings_pkey PRIMARY KEY (id);


--
-- Name: y2016_mesh_terms y2016_mesh_terms_pkey; Type: CONSTRAINT; Schema: mesh_archive; Owner: -
--

ALTER TABLE ONLY mesh_archive.y2016_mesh_terms
    ADD CONSTRAINT y2016_mesh_terms_pkey PRIMARY KEY (id);


--
-- Name: y2018_mesh_terms y2018_mesh_terms_pkey; Type: CONSTRAINT; Schema: mesh_archive; Owner: -
--

ALTER TABLE ONLY mesh_archive.y2018_mesh_terms
    ADD CONSTRAINT y2018_mesh_terms_pkey PRIMARY KEY (id);


--
-- Name: cdek_organizations cdek_organizations_pkey; Type: CONSTRAINT; Schema: proj_cdek_standard_orgs; Owner: -
--

ALTER TABLE ONLY proj_cdek_standard_orgs.cdek_organizations
    ADD CONSTRAINT cdek_organizations_pkey PRIMARY KEY (id);


--
-- Name: cdek_synonyms cdek_synonyms_pkey; Type: CONSTRAINT; Schema: proj_cdek_standard_orgs; Owner: -
--

ALTER TABLE ONLY proj_cdek_standard_orgs.cdek_synonyms
    ADD CONSTRAINT cdek_synonyms_pkey PRIMARY KEY (id);


--
-- Name: analyzed_studies analyzed_studies_pkey; Type: CONSTRAINT; Schema: proj_results_reporting; Owner: -
--

ALTER TABLE ONLY proj_results_reporting.analyzed_studies
    ADD CONSTRAINT analyzed_studies_pkey PRIMARY KEY (id);


--
-- Name: tagged_terms tagged_terms_pkey; Type: CONSTRAINT; Schema: proj_tag; Owner: -
--

ALTER TABLE ONLY proj_tag.tagged_terms
    ADD CONSTRAINT tagged_terms_pkey PRIMARY KEY (id);


--
-- Name: analyzed_studies analyzed_studies_pkey; Type: CONSTRAINT; Schema: proj_tag_nephrology; Owner: -
--

ALTER TABLE ONLY proj_tag_nephrology.analyzed_studies
    ADD CONSTRAINT analyzed_studies_pkey PRIMARY KEY (id);


--
-- Name: tagged_terms tagged_terms_pkey; Type: CONSTRAINT; Schema: proj_tag_nephrology; Owner: -
--

ALTER TABLE ONLY proj_tag_nephrology.tagged_terms
    ADD CONSTRAINT tagged_terms_pkey PRIMARY KEY (id);


--
-- Name: analyzed_studies analyzed_studies_pkey; Type: CONSTRAINT; Schema: proj_tag_osteoporosis; Owner: -
--

ALTER TABLE ONLY proj_tag_osteoporosis.analyzed_studies
    ADD CONSTRAINT analyzed_studies_pkey PRIMARY KEY (id);


--
-- Name: analyzed_studies analyzed_studies_pkey; Type: CONSTRAINT; Schema: proj_tag_pulmonary; Owner: -
--

ALTER TABLE ONLY proj_tag_pulmonary.analyzed_studies
    ADD CONSTRAINT analyzed_studies_pkey PRIMARY KEY (id);


--
-- Name: analyzed_studies analyzed_studies_pkey; Type: CONSTRAINT; Schema: proj_tag_pvd; Owner: -
--

ALTER TABLE ONLY proj_tag_pvd.analyzed_studies
    ADD CONSTRAINT analyzed_studies_pkey PRIMARY KEY (id);


--
-- Name: analyzed_studies analyzed_studies_pkey; Type: CONSTRAINT; Schema: proj_tag_rti; Owner: -
--

ALTER TABLE ONLY proj_tag_rti.analyzed_studies
    ADD CONSTRAINT analyzed_studies_pkey PRIMARY KEY (id);


--
-- Name: cardiovascular_studies cardiovascular_studies_pkey; Type: CONSTRAINT; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER TABLE ONLY proj_tag_study_characteristics.cardiovascular_studies
    ADD CONSTRAINT cardiovascular_studies_pkey PRIMARY KEY (id);


--
-- Name: mental_health_studies mental_health_studies_pkey; Type: CONSTRAINT; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER TABLE ONLY proj_tag_study_characteristics.mental_health_studies
    ADD CONSTRAINT mental_health_studies_pkey PRIMARY KEY (id);


--
-- Name: oncology_studies oncology_studies_pkey; Type: CONSTRAINT; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER TABLE ONLY proj_tag_study_characteristics.oncology_studies
    ADD CONSTRAINT oncology_studies_pkey PRIMARY KEY (id);


--
-- Name: tagged_terms tagged_terms_pkey; Type: CONSTRAINT; Schema: proj_tag_study_characteristics; Owner: -
--

ALTER TABLE ONLY proj_tag_study_characteristics.tagged_terms
    ADD CONSTRAINT tagged_terms_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_mesh_archive.y2010_mesh_terms_on_description; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2010_mesh_terms_on_description" ON mesh_archive.y2010_mesh_terms USING btree (description);


--
-- Name: index_mesh_archive.y2010_mesh_terms_on_downcase_mesh_term; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2010_mesh_terms_on_downcase_mesh_term" ON mesh_archive.y2010_mesh_terms USING btree (downcase_mesh_term);


--
-- Name: index_mesh_archive.y2010_mesh_terms_on_mesh_term; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2010_mesh_terms_on_mesh_term" ON mesh_archive.y2010_mesh_terms USING btree (mesh_term);


--
-- Name: index_mesh_archive.y2010_mesh_terms_on_qualifier; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2010_mesh_terms_on_qualifier" ON mesh_archive.y2010_mesh_terms USING btree (qualifier);


--
-- Name: index_mesh_archive.y2016_mesh_headings_on_qualifier; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2016_mesh_headings_on_qualifier" ON mesh_archive.y2016_mesh_headings USING btree (qualifier);


--
-- Name: index_mesh_archive.y2016_mesh_terms_on_description; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2016_mesh_terms_on_description" ON mesh_archive.y2016_mesh_terms USING btree (description);


--
-- Name: index_mesh_archive.y2016_mesh_terms_on_downcase_mesh_term; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2016_mesh_terms_on_downcase_mesh_term" ON mesh_archive.y2016_mesh_terms USING btree (downcase_mesh_term);


--
-- Name: index_mesh_archive.y2016_mesh_terms_on_mesh_term; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2016_mesh_terms_on_mesh_term" ON mesh_archive.y2016_mesh_terms USING btree (mesh_term);


--
-- Name: index_mesh_archive.y2016_mesh_terms_on_qualifier; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2016_mesh_terms_on_qualifier" ON mesh_archive.y2016_mesh_terms USING btree (qualifier);


--
-- Name: index_mesh_archive.y2018_mesh_terms_on_description; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2018_mesh_terms_on_description" ON mesh_archive.y2018_mesh_terms USING btree (description);


--
-- Name: index_mesh_archive.y2018_mesh_terms_on_downcase_mesh_term; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2018_mesh_terms_on_downcase_mesh_term" ON mesh_archive.y2018_mesh_terms USING btree (downcase_mesh_term);


--
-- Name: index_mesh_archive.y2018_mesh_terms_on_mesh_term; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2018_mesh_terms_on_mesh_term" ON mesh_archive.y2018_mesh_terms USING btree (mesh_term);


--
-- Name: index_mesh_archive.y2018_mesh_terms_on_qualifier; Type: INDEX; Schema: mesh_archive; Owner: -
--

CREATE INDEX "index_mesh_archive.y2018_mesh_terms_on_qualifier" ON mesh_archive.y2018_mesh_terms USING btree (qualifier);


--
-- PostgreSQL database dump complete
--

SET search_path TO ctgov, mesh_archive, proj_results_reporting, proj_cdek_standard_orgs, proj_tag_nephrology, proj_tag_study_characteristics, public;

INSERT INTO "schema_migrations" (version) VALUES
('20180430000122'),
('20180719000122'),
('20180918000122'),
('20181104000122'),
('20181108000122'),
('20190305000122'),
('20190306000122'),
('20190306000124'),
('20190306000126'),
('20190307000122');


