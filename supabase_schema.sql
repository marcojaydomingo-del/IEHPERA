-- Run this entire file in your Supabase SQL Editor
-- Dashboard > SQL Editor > New Query > Paste > Run

-- ──────────────────────────────────────────────
-- ERAs table (one row per uploaded PDF)
-- ──────────────────────────────────────────────
create table if not exists eras (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references auth.users(id) on delete cascade not null,
  filename        text not null,
  check_date      text,
  check_no        text,
  check_amount    numeric(12,2) default 0,
  total_billed    numeric(12,2) default 0,
  amount_allowed  numeric(12,2) default 0,
  not_covered     numeric(12,2) default 0,
  copay_deduct    numeric(12,2) default 0,
  withheld        numeric(12,2) default 0,
  net_paid        numeric(12,2) default 0,
  total_claims    integer default 0,
  total_claim_lines integer default 0,
  provider_name   text,
  npi             text,
  patient_count   integer default 0,
  denied_count    integer default 0,
  created_at      timestamptz default now()
);

-- ──────────────────────────────────────────────
-- Patients table (one row per patient per ERA)
-- ──────────────────────────────────────────────
create table if not exists patients (
  id                  uuid primary key default gen_random_uuid(),
  era_id              uuid references eras(id) on delete cascade not null,
  user_id             uuid references auth.users(id) on delete cascade not null,
  member_id           text,
  name                text not null,
  lob                 text,
  claim_nos           text[],
  procs               text[],
  total_billed        numeric(12,2) default 0,
  total_allowed       numeric(12,2) default 0,
  total_not_covered   numeric(12,2) default 0,
  total_copay_deduct  numeric(12,2) default 0,
  total_withhold      numeric(12,2) default 0,
  total_net_paid      numeric(12,2) default 0,
  is_denied           boolean default false,
  has_partial_denial  boolean default false,
  denial_codes        text[],
  denial_action       text,
  primary_payer       text,
  claim_lines         jsonb,
  created_at          timestamptz default now()
);

-- ──────────────────────────────────────────────
-- Row Level Security (RLS)
-- Users can only see their own data
-- ──────────────────────────────────────────────
alter table eras enable row level security;
alter table patients enable row level security;

create policy "Users see own eras"
  on eras for all
  using (auth.uid() = user_id);

create policy "Users see own patients"
  on patients for all
  using (auth.uid() = user_id);

-- ──────────────────────────────────────────────
-- Indexes for performance
-- ──────────────────────────────────────────────
create index if not exists idx_eras_user_id on eras(user_id);
create index if not exists idx_eras_created_at on eras(created_at desc);
create index if not exists idx_patients_era_id on patients(era_id);
create index if not exists idx_patients_user_id on patients(user_id);
create index if not exists idx_patients_is_denied on patients(is_denied);
create index if not exists idx_patients_lob on patients(lob);
