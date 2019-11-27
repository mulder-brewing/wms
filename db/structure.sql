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
-- Name: dock_request_audit_history_event; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.dock_request_audit_history_event AS ENUM (
    'checked_in',
    'dock_assigned',
    'dock_unassigned',
    'text_message_sent',
    'checked_out',
    'voided',
    'updated'
);


--
-- Name: dock_request_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.dock_request_status AS ENUM (
    'checked_in',
    'dock_assigned',
    'checked_out',
    'voided'
);


SET default_tablespace = '';

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
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id bigint NOT NULL,
    name text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    enabled boolean DEFAULT true
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: dock_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dock_groups (
    id bigint NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    company_id bigint,
    enabled boolean DEFAULT true
);


--
-- Name: dock_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dock_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dock_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dock_groups_id_seq OWNED BY public.dock_groups.id;


--
-- Name: dock_request_audit_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dock_request_audit_histories (
    id bigint NOT NULL,
    dock_request_id bigint,
    phone_number text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    event public.dock_request_audit_history_event,
    company_id bigint,
    dock_id bigint,
    user_id bigint
);


--
-- Name: dock_request_audit_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dock_request_audit_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dock_request_audit_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dock_request_audit_histories_id_seq OWNED BY public.dock_request_audit_histories.id;


--
-- Name: dock_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dock_requests (
    id bigint NOT NULL,
    primary_reference text,
    phone_number text,
    text_message boolean,
    note text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    dock_group_id bigint,
    company_id bigint,
    status public.dock_request_status DEFAULT 'checked_in'::public.dock_request_status,
    dock_id bigint,
    dock_assigned_at timestamp without time zone,
    checked_out_at timestamp without time zone,
    voided_at timestamp without time zone
);


--
-- Name: dock_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dock_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dock_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dock_requests_id_seq OWNED BY public.dock_requests.id;


--
-- Name: docks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.docks (
    id bigint NOT NULL,
    number text,
    enabled boolean DEFAULT true,
    dock_group_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    company_id bigint
);


--
-- Name: docks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.docks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: docks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.docks_id_seq OWNED BY public.docks.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username text,
    first_name text,
    last_name text,
    email text,
    enabled boolean DEFAULT true,
    company_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying,
    company_admin boolean DEFAULT false,
    app_admin boolean DEFAULT false,
    password_reset boolean DEFAULT true
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: dock_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_groups ALTER COLUMN id SET DEFAULT nextval('public.dock_groups_id_seq'::regclass);


--
-- Name: dock_request_audit_histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_request_audit_histories ALTER COLUMN id SET DEFAULT nextval('public.dock_request_audit_histories_id_seq'::regclass);


--
-- Name: dock_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_requests ALTER COLUMN id SET DEFAULT nextval('public.dock_requests_id_seq'::regclass);


--
-- Name: docks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.docks ALTER COLUMN id SET DEFAULT nextval('public.docks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: dock_groups dock_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_groups
    ADD CONSTRAINT dock_groups_pkey PRIMARY KEY (id);


--
-- Name: dock_request_audit_histories dock_request_audit_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_request_audit_histories
    ADD CONSTRAINT dock_request_audit_histories_pkey PRIMARY KEY (id);


--
-- Name: dock_requests dock_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_requests
    ADD CONSTRAINT dock_requests_pkey PRIMARY KEY (id);


--
-- Name: docks docks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.docks
    ADD CONSTRAINT docks_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_on_name ON public.companies USING btree (name);


--
-- Name: index_dock_groups_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_groups_on_company_id ON public.dock_groups USING btree (company_id);


--
-- Name: index_dock_groups_on_description_and_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_dock_groups_on_description_and_company_id ON public.dock_groups USING btree (description, company_id);


--
-- Name: index_dock_request_audit_histories_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_request_audit_histories_on_company_id ON public.dock_request_audit_histories USING btree (company_id);


--
-- Name: index_dock_request_audit_histories_on_dock_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_request_audit_histories_on_dock_id ON public.dock_request_audit_histories USING btree (dock_id);


--
-- Name: index_dock_request_audit_histories_on_dock_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_request_audit_histories_on_dock_request_id ON public.dock_request_audit_histories USING btree (dock_request_id);


--
-- Name: index_dock_request_audit_histories_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_request_audit_histories_on_user_id ON public.dock_request_audit_histories USING btree (user_id);


--
-- Name: index_dock_requests_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_requests_on_company_id ON public.dock_requests USING btree (company_id);


--
-- Name: index_dock_requests_on_dock_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_requests_on_dock_group_id ON public.dock_requests USING btree (dock_group_id);


--
-- Name: index_dock_requests_on_dock_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_requests_on_dock_id ON public.dock_requests USING btree (dock_id);


--
-- Name: index_dock_requests_on_primary_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_requests_on_primary_reference ON public.dock_requests USING btree (primary_reference);


--
-- Name: index_dock_requests_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dock_requests_on_status ON public.dock_requests USING btree (status);


--
-- Name: index_docks_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_docks_on_company_id ON public.docks USING btree (company_id);


--
-- Name: index_docks_on_dock_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_docks_on_dock_group_id ON public.docks USING btree (dock_group_id);


--
-- Name: index_users_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_company_id ON public.users USING btree (company_id);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: docks fk_rails_02ff6b4572; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.docks
    ADD CONSTRAINT fk_rails_02ff6b4572 FOREIGN KEY (dock_group_id) REFERENCES public.dock_groups(id);


--
-- Name: dock_request_audit_histories fk_rails_1a221f2a59; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_request_audit_histories
    ADD CONSTRAINT fk_rails_1a221f2a59 FOREIGN KEY (dock_id) REFERENCES public.docks(id);


--
-- Name: dock_groups fk_rails_1a3a24c5f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_groups
    ADD CONSTRAINT fk_rails_1a3a24c5f2 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: docks fk_rails_2077bae5be; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.docks
    ADD CONSTRAINT fk_rails_2077bae5be FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: users fk_rails_7682a3bdfe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_7682a3bdfe FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: dock_request_audit_histories fk_rails_9d3d5cf4c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_request_audit_histories
    ADD CONSTRAINT fk_rails_9d3d5cf4c3 FOREIGN KEY (dock_request_id) REFERENCES public.dock_requests(id);


--
-- Name: dock_requests fk_rails_aa5d061e79; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_requests
    ADD CONSTRAINT fk_rails_aa5d061e79 FOREIGN KEY (dock_group_id) REFERENCES public.dock_groups(id);


--
-- Name: dock_request_audit_histories fk_rails_bc04785038; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_request_audit_histories
    ADD CONSTRAINT fk_rails_bc04785038 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: dock_requests fk_rails_caff2c10d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_requests
    ADD CONSTRAINT fk_rails_caff2c10d7 FOREIGN KEY (dock_id) REFERENCES public.docks(id);


--
-- Name: dock_requests fk_rails_d6983c8259; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_requests
    ADD CONSTRAINT fk_rails_d6983c8259 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: dock_request_audit_histories fk_rails_f9503f7f47; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dock_request_audit_histories
    ADD CONSTRAINT fk_rails_f9503f7f47 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190515144051'),
('20190515152616'),
('20190515154006'),
('20190519195936'),
('20190525161810'),
('20190525194232'),
('20190526140458'),
('20190609200651'),
('20190616184108'),
('20190616210311'),
('20190619213253'),
('20190619220209'),
('20190619223637'),
('20190619225315'),
('20190620215724'),
('20190620223011'),
('20190621130026'),
('20190621131447'),
('20190621134052'),
('20190624214358'),
('20190624222536'),
('20190630130720'),
('20190630131435'),
('20190630135224'),
('20190702121948'),
('20190702122147'),
('20190702184412'),
('20190702191432'),
('20190704162314'),
('20190704173742'),
('20190705171121'),
('20190716122559'),
('20190716122928'),
('20190716124913'),
('20190716131530'),
('20190717155721'),
('20191119182114');


