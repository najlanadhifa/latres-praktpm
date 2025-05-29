# 🍽️ Restaurant App 

Aplikasi ini dikembangkan sebagai bagian dari **latihan responsi Praktikum Pemrograman Mobile**. Proyek ini bertujuan untuk mengasah keterampilan menggunakan **Flutter** dalam membangun aplikasi mobile.

## 📱 Fitur Utama

- Autentikasi pengguna sederhana (login & register menggunakan `SharedPreferences`)
- Menampilkan daftar restoran dari [Restaurant API Dicoding](https://restaurant-api.dicoding.dev/)
- Menampilkan detail masing-masing restoran
- Menyimpan dan menghapus restoran favorit secara lokal 
- Logout dan refresh data

## 🛠️ Teknologi

- **Flutter** – Framework utama
- **HTTP** – Untuk mengakses REST API
- **SharedPreferences** – Untuk penyimpanan data login dan favorit lokal
- **Restaurant API Dicoding** – Sumber data restoran

## 🚀 Cara Menjalankan

1. Clone repo ini:
   ```
   git clone https://github.com/najlanadhifa/latres-praktpm.git
2. Install dependency:
   ```
   flutter pub get
   flutter run
## 📂 Struktur Folder
   ```
   lib/
   ├── models/              # Model data (Restaurant)
   ├── pages/               # Semua layar UI (Login, Register, List, Detail, Favorite)
   ├── services/            # Kode untuk API, auth, dan layanan favorit
   ├── main.dart            # Entry point aplikasi
