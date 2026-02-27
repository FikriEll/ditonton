# Firebase Evidence Checklist

## 1) Analytics (wajib ada aktivitas user)
1. Jalankan aplikasi dengan konfigurasi Firebase (`google-services.json`/`GoogleService-Info.plist` aktif).
2. Lakukan aktivitas berikut di app:
   - Buka halaman pencarian film lalu submit query.
   - Buka halaman pencarian TV lalu submit query.
   - Buka detail film/TV lalu tekan tombol watchlist (add/remove).
3. Tunggu event masuk ke Firebase Analytics.
4. Ambil screenshot halaman Firebase Analytics yang menampilkan event:
   - `movie_search`
   - `tv_search`
   - `movie_watchlist_toggle`
   - `tv_watchlist_toggle`

## 2) Crashlytics
1. Trigger non-fatal error atau crash uji coba dari app.
2. Pastikan issue muncul di Firebase Crashlytics dashboard.
3. Ambil screenshot halaman issue Crashlytics yang menampilkan:
   - Nama issue
   - Timestamp kejadian
   - Stack trace/ringkasan error

## 3) Lampiran yang dikirim
- Screenshot Analytics (terlihat data event aktivitas user).
- Screenshot Crashlytics (terlihat data crash/error).
