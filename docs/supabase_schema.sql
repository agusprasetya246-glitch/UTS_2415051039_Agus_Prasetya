-- ============================================================
-- GameShelf – skema database Supabase
-- Jalankan sekali di Supabase Dashboard → SQL Editor.
-- ============================================================

-- Tabel backlog game pribadi
create table if not exists public.game_backlog (
  id           uuid        primary key default gen_random_uuid(),
  student_id   text        not null,                  -- diisi NIM pemilik data
  game_id      integer     not null,                  -- id game di FreeToGame
  title        text        not null,
  thumbnail    text        not null default '',
  status       text        not null default 'ingin_main'
               check (status in ('ingin_main', 'sedang_main', 'selesai')),
  rating       integer     not null default 0 check (rating between 0 and 5),
  hours_played integer     not null default 0 check (hours_played >= 0),
  note         text        not null default '',
  created_at   timestamptz not null default now(),
  -- satu game hanya boleh masuk sekali ke backlog seorang mahasiswa
  unique (student_id, game_id)
);

-- Row Level Security wajib aktif untuk tabel yang diakses dari aplikasi
alter table public.game_backlog enable row level security;

-- Policy khusus keperluan tugas: role anon (publishable key) boleh CRUD.
-- Aplikasi produksi seharusnya memakai Supabase Auth dan membatasi
-- akses per pengguna, misalnya using (auth.uid() = user_id).
create policy "anon boleh CRUD game_backlog (khusus tugas)"
  on public.game_backlog
  for all
  to anon
  using (true)
  with check (true);

grant select, insert, update, delete on public.game_backlog to anon;
