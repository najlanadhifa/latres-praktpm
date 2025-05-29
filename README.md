# 🍽️ Restaurant App Flutter

Aplikasi ini dikembangkan sebagai bagian dari **latihan responsi praktikum mata kuliah Pemrograman Mobile**. Proyek ini bertujuan untuk mengasah kemampuan pengembangan aplikasi Flutter dengan memanfaatkan REST API, manajemen state sederhana, serta penyimpanan data lokal menggunakan SharedPreferences dan Hive.

## 📱 Fitur Utama

- Autentikasi pengguna sederhana (login & register menggunakan `SharedPreferences`)
- Menampilkan daftar restoran dari [Restaurant API Dicoding](https://restaurant-api.dicoding.dev/)
- Melihat detail restoran
- Menyimpan dan menghapus restoran favorit secara lokal menggunakan Hive
- Logout dan refresh data

## 🛠️ Teknologi

- **Flutter**
- **Hive** (untuk penyimpanan lokal favorit)
- **SharedPreferences** (untuk data login lokal)
- **HTTP** (untuk konsumsi REST API)
- **Restaurant API Dicoding** (sebagai sumber data)

## 🚀 Cara Menjalankan

1. Clone repo ini:
   ```
   git clone https://github.com/username/restaurant-flutter-app.git
   cd restaurant-flutter-app
2. Install dependency:
   ```
   flutter pub get
   flutter run
## 📂 Struktur Folder
```
lib/
├── models/              # Model data (Restaurant)
├── pages/             # Semua layar UI (Login, Register, List, Detail, Favorite)
├── services/            # Kode untuk API, auth, dan layanan favorit
├── main.dart            # Entry point aplikasi
>>>>>>> feb0a8f0fae0bbfc274fd81c63ce4a57d1ca7fe8
