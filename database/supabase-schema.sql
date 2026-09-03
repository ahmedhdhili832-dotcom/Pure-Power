-- PURE & POWER — Production database
-- Run this script once in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  client_first_name text not null,
  client_last_name text not null,
  email text not null,
  phone text not null,
  service text not null,
  quantity numeric not null default 1,
  unit_price numeric not null default 0,
  total_price numeric not null default 0,
  booking_date date not null,
  booking_time time not null,
  address text not null,
  needs text,
  status text not null default 'pending' check (status in ('pending','approved','rejected','client_confirmed','client_refused','cancelled')),
  contract_status text not null default 'draft' check (contract_status in ('draft','sent','client_confirmed','client_refused')),
  payment_status text not null default 'pending' check (payment_status in ('pending','paid','failed','refunded')),
  contract_token uuid not null default gen_random_uuid() unique,
  contract_sent_at timestamptz,
  client_decision_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists bookings_status_idx on public.bookings(status);
create index if not exists bookings_email_idx on public.bookings(lower(email));
create index if not exists bookings_contract_token_idx on public.bookings(contract_token);

alter table public.bookings enable row level security;

-- Public clients may create a request. Admin operations should be done server-side.
drop policy if exists "public can create booking" on public.bookings;
create policy "public can create booking" on public.bookings
for insert to anon, authenticated with check (true);

-- Do not expose all bookings to anonymous users. Client contract reads/decisions go through Netlify Functions.

drop policy if exists "public can read nothing" on public.bookings;

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists bookings_updated_at on public.bookings;
create trigger bookings_updated_at before update on public.bookings
for each row execute function public.set_updated_at();
