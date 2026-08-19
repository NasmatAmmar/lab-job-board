--
-- PostgreSQL database dump
--

\restrict YfiGKYqgR0GKCxaVVmJ3gSiOrvDkqHnYcOIfTojdij3FQROWcX8DGlT4MHR7899

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

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
-- Name: applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.applications (
    id uuid NOT NULL,
    job_id character varying(255) NOT NULL,
    applicant_name character varying(200) NOT NULL,
    applicant_email character varying(200) NOT NULL,
    cover_letter text,
    status character varying(50) DEFAULT 'pending'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT applications_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'reviewed'::character varying, 'accepted'::character varying, 'rejected'::character varying])::text[])))
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id character varying(255) NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL,
    company character varying(200) NOT NULL,
    location character varying(200) NOT NULL,
    salary_range character varying(100),
    created_at timestamp with time zone DEFAULT now()
);


--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.applications (id, job_id, applicant_name, applicant_email, cover_letter, status, created_at) FROM stdin;
81a3fa64-02e6-46ce-87c6-e254db094d98	8a2f041d-a41f-48b9-a300-060ddf91d9b5	Step7 Test	step7@test.com	K8s ingress check	pending	2026-08-15 17:41:36.706814
d1f65bc9-527e-41cd-934a-421b0b8e77cc	job-001	Task2 User	task2@lab.com	\N	pending	2026-08-16 18:38:42.90168
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.jobs (id, title, description, company, location, salary_range, created_at) FROM stdin;
8a2f041d-a41f-48b9-a300-060ddf91d9b5	Senior DevOps Engineer	Design and maintain cloud infrastructure using Kubernetes, Terraform, and CI/CD pipelines to ensure high availability.	TechCorp Ltd.	Remote	$120,000 - $160,000	2026-08-15 17:12:42.530535+00
16b77445-4990-4656-a09f-2469296bfba9	Backend Developer (Python)	Build and maintain RESTful APIs using Python and FastAPI. Design PostgreSQL schemas and collaborate with frontend engineers.	StartupXYZ	Tel Aviv, Israel	$90,000 - $120,000	2026-08-15 17:12:42.729245+00
05981fa8-315e-4469-a9cc-6bfb7fefaf53	Cloud Architect	Design cloud-native solutions on AWS and GCP. Lead architecture reviews and drive Infrastructure as Code adoption with Terraform.	CloudSystems Inc.	Hybrid – Berlin, Germany	$140,000 - $180,000	2026-08-15 17:12:42.741731+00
4077b83d-24b3-4457-9970-4d38b35905e5	Frontend Engineer (React)	Build performant web applications using React and TypeScript. Translate UX designs into accessible components.	ProductLab	Remote	$80,000 - $110,000	2026-08-15 17:12:42.74669+00
74c8abeb-f113-403e-8d63-d2f361b63a18	Security Engineer (DevSecOps)	Own security posture of the engineering organisation. Integrate SAST/DAST tools into CI/CD and run threat-modelling sessions.	SecureOps	London, UK	$130,000 - $165,000	2026-08-15 17:12:42.906759+00
a48707a5-40da-405b-b5f9-8835f4b1b669	K8s Persistence Test	This job must survive a pod restart	Lab Inc	Kubernetes	\N	2026-08-16 18:57:29.862118+00
\.


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: idx_applications_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_applications_job_id ON public.applications USING btree (job_id);


--
-- Name: ix_jobs_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_jobs_id ON public.jobs USING btree (id);


--
-- PostgreSQL database dump complete
--

\unrestrict YfiGKYqgR0GKCxaVVmJ3gSiOrvDkqHnYcOIfTojdij3FQROWcX8DGlT4MHR7899

