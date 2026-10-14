-- Classroom/demo setup: this policy allows anyone with the public project URL
-- and publishable key to read and change every row. Do not use it for private,
-- production, or real business inventory. See README.md for safer alternatives.

create table if not exists public.inventory_items (
  id uuid primary key default gen_random_uuid(),
  item_name text not null,
  description text,
  category text not null,
  quantity integer not null default 0 check (quantity >= 0),
  unit_price numeric(12, 2) not null default 0 check (unit_price >= 0),
  created_at timestamptz not null default now()
);

alter table public.inventory_items enable row level security;

drop policy if exists "Classroom demo can read inventory" on public.inventory_items;
drop policy if exists "Classroom demo can add inventory" on public.inventory_items;
drop policy if exists "Classroom demo can update inventory" on public.inventory_items;
drop policy if exists "Classroom demo can delete inventory" on public.inventory_items;

create policy "Classroom demo can read inventory"
  on public.inventory_items for select to anon using (true);

create policy "Classroom demo can add inventory"
  on public.inventory_items for insert to anon with check (true);

create policy "Classroom demo can update inventory"
  on public.inventory_items for update to anon using (true) with check (true);

create policy "Classroom demo can delete inventory"
  on public.inventory_items for delete to anon using (true);

grant select, insert, update, delete on public.inventory_items to anon, authenticated;
