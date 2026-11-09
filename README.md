# GameShelf

Aplikasi mobile Flutter untuk menjelajahi katalog game free-to-play dari FreeToGame API dan mencatat backlog game pribadi di Supabase. Project UTS Pemrograman Mobile.

## Identitas

- **Nama:** Agus Prasetya
- **NIM:** 2415051039
- **Kelas:** PTI-5B

## Arsitektur

Tampilan, state, dan akses data dipisah. Screen tidak memanggil API atau database secara langsung.

screens / widgets → providers → repositories → services → FreeToGame API / Supabase

lib/
├── config/        # identitas mahasiswa dan konfigurasi
├── models/        # class data + fromJson/toJson
├── services/      # akses data mentah: HTTP ke FreeToGame, query ke Supabase
├── repositories/  # penghubung provider dan service
├── providers/     # state aplikasi (ChangeNotifier): loading, data, error
├── screens/       # halaman aplikasi
├── widgets/       # komponen UI yang dipakai ulang
├── theme/         # warna dan tema
├── utils/         # fungsi bantu, misalnya format tanggal
└── main.dart

## Status

Dalam pengerjaan. Fitur, tech stack, arsitektur, screenshot, dan cara menjalankan dilengkapi di tahap-tahap berikutnya.