-- Ejecutar una vez en Supabase: SQL Editor > New query > Run

create table if not exists public.respuestas (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  data jsonb not null check (jsonb_typeof(data) = 'object' and pg_column_size(data) < 20000)
);

alter table public.respuestas enable row level security;

-- Cualquier persona con el enlace puede enviar su respuesta (anónima)
create policy "enviar respuestas" on public.respuestas
  for insert to anon, authenticated with check (true);

-- Solo usuarios autenticados (la facilitadora) pueden leer
create policy "leer respuestas" on public.respuestas
  for select to authenticated using (true);

grant insert on public.respuestas to anon, authenticated;
grant select on public.respuestas to authenticated;
