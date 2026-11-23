--
-- PostgreSQL database dump
--

\restrict uyM0H2uU6gdp3S75EWw0Iv90MoAw78WTedmLq9caCukpaHjcljWiKwswpFBiG7P

-- Dumped from database version 17.12
-- Dumped by pg_dump version 17.12

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access_groups (
    group_id integer NOT NULL,
    group_name character varying(100) NOT NULL,
    group_description text,
    system_name character varying(50) NOT NULL,
    is_privileged boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: access_groups_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.access_groups_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_groups_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.access_groups_group_id_seq OWNED BY public.access_groups.group_id;


--
-- Name: department_entitlements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.department_entitlements (
    department_entitlement_id integer NOT NULL,
    department_id integer NOT NULL,
    group_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: department_entitlements_department_entitlement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.department_entitlements_department_entitlement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: department_entitlements_department_entitlement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.department_entitlements_department_entitlement_id_seq OWNED BY public.department_entitlements.department_entitlement_id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    department_id integer NOT NULL,
    department_name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.departments_department_id_seq OWNED BY public.departments.department_id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    employee_number character varying(20) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    department_id integer,
    role_id integer,
    manager_id integer,
    employment_status character varying(20) DEFAULT 'Active'::character varying NOT NULL,
    hire_date date,
    termination_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT employees_employment_status_check CHECK (((employment_status)::text = ANY ((ARRAY['Active'::character varying, 'Onboarding'::character varying, 'Leave'::character varying, 'Terminated'::character varying])::text[])))
);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- Name: job_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_roles (
    role_id integer NOT NULL,
    role_name character varying(100) NOT NULL,
    role_description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: job_roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_roles_role_id_seq OWNED BY public.job_roles.role_id;


--
-- Name: lifecycle_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lifecycle_events (
    event_id bigint NOT NULL,
    employee_id integer NOT NULL,
    event_type character varying(20) NOT NULL,
    previous_value jsonb,
    new_value jsonb,
    event_status character varying(20) DEFAULT 'Pending'::character varying NOT NULL,
    initiated_by character varying(100) NOT NULL,
    correlation_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    processed_at timestamp with time zone,
    CONSTRAINT lifecycle_events_event_status_check CHECK (((event_status)::text = ANY ((ARRAY['Pending'::character varying, 'Processing'::character varying, 'Completed'::character varying, 'Failed'::character varying])::text[]))),
    CONSTRAINT lifecycle_events_event_type_check CHECK (((event_type)::text = ANY ((ARRAY['Joiner'::character varying, 'Mover'::character varying, 'Leaver'::character varying])::text[])))
);


--
-- Name: lifecycle_events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lifecycle_events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lifecycle_events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lifecycle_events_event_id_seq OWNED BY public.lifecycle_events.event_id;


--
-- Name: role_entitlements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_entitlements (
    role_entitlement_id integer NOT NULL,
    role_id integer NOT NULL,
    group_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: role_entitlements_role_entitlement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.role_entitlements_role_entitlement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_entitlements_role_entitlement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.role_entitlements_role_entitlement_id_seq OWNED BY public.role_entitlements.role_entitlement_id;


--
-- Name: access_groups group_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_groups ALTER COLUMN group_id SET DEFAULT nextval('public.access_groups_group_id_seq'::regclass);


--
-- Name: department_entitlements department_entitlement_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department_entitlements ALTER COLUMN department_entitlement_id SET DEFAULT nextval('public.department_entitlements_department_entitlement_id_seq'::regclass);


--
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN department_id SET DEFAULT nextval('public.departments_department_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- Name: job_roles role_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_roles ALTER COLUMN role_id SET DEFAULT nextval('public.job_roles_role_id_seq'::regclass);


--
-- Name: lifecycle_events event_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lifecycle_events ALTER COLUMN event_id SET DEFAULT nextval('public.lifecycle_events_event_id_seq'::regclass);


--
-- Name: role_entitlements role_entitlement_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_entitlements ALTER COLUMN role_entitlement_id SET DEFAULT nextval('public.role_entitlements_role_entitlement_id_seq'::regclass);


--
-- Name: access_groups access_groups_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_groups
    ADD CONSTRAINT access_groups_group_name_key UNIQUE (group_name);


--
-- Name: access_groups access_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_groups
    ADD CONSTRAINT access_groups_pkey PRIMARY KEY (group_id);


--
-- Name: department_entitlements department_entitlements_department_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department_entitlements
    ADD CONSTRAINT department_entitlements_department_id_group_id_key UNIQUE (department_id, group_id);


--
-- Name: department_entitlements department_entitlements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department_entitlements
    ADD CONSTRAINT department_entitlements_pkey PRIMARY KEY (department_entitlement_id);


--
-- Name: departments departments_department_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_name_key UNIQUE (department_name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: employees employees_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);


--
-- Name: employees employees_employee_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_employee_number_key UNIQUE (employee_number);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: job_roles job_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_roles
    ADD CONSTRAINT job_roles_pkey PRIMARY KEY (role_id);


--
-- Name: job_roles job_roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_roles
    ADD CONSTRAINT job_roles_role_name_key UNIQUE (role_name);


--
-- Name: lifecycle_events lifecycle_events_correlation_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lifecycle_events
    ADD CONSTRAINT lifecycle_events_correlation_id_key UNIQUE (correlation_id);


--
-- Name: lifecycle_events lifecycle_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lifecycle_events
    ADD CONSTRAINT lifecycle_events_pkey PRIMARY KEY (event_id);


--
-- Name: role_entitlements role_entitlements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_entitlements
    ADD CONSTRAINT role_entitlements_pkey PRIMARY KEY (role_entitlement_id);


--
-- Name: role_entitlements role_entitlements_role_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_entitlements
    ADD CONSTRAINT role_entitlements_role_id_group_id_key UNIQUE (role_id, group_id);


--
-- Name: department_entitlements department_entitlements_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department_entitlements
    ADD CONSTRAINT department_entitlements_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- Name: department_entitlements department_entitlements_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department_entitlements
    ADD CONSTRAINT department_entitlements_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.access_groups(group_id);


--
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- Name: employees employees_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- Name: employees employees_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.job_roles(role_id);


--
-- Name: lifecycle_events lifecycle_events_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lifecycle_events
    ADD CONSTRAINT lifecycle_events_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- Name: role_entitlements role_entitlements_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_entitlements
    ADD CONSTRAINT role_entitlements_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.access_groups(group_id);


--
-- Name: role_entitlements role_entitlements_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_entitlements
    ADD CONSTRAINT role_entitlements_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.job_roles(role_id);


--
-- PostgreSQL database dump complete
--

\unrestrict uyM0H2uU6gdp3S75EWw0Iv90MoAw78WTedmLq9caCukpaHjcljWiKwswpFBiG7P

