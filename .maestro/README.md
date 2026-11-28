# Tes UI Maestro

Kita menguji alur layar Dompet Mahasiswa dengan Maestro CLI **2.13.0**. Flow ini black-box: Maestro memakai pohon semantik Flutter, bukan `Key` widget. Tidak ada dependensi baru di `pubspec.yaml`.

`appId` flow adalah applicationId Android di `android/app/build.gradle.kts`: `com.dompetmahasiswa.dompet_mahasiswa`. Repo ini belum punya target iOS, jadi belum ada bundle id yang bisa dipakai.

## Pasang Maestro CLI

Perlu Java 17 atau lebih baru, dan `JAVA_HOME` mengarah ke JDK itu. Cek dengan `java -version`.

Di Linux atau macOS, skrip resmi memasang CLI terbaru ke `~/.maestro/bin`:

```bash
curl -fsSL "https://get.maestro.mobile.dev" | bash
```

Agar satu mesin memakai versi yang sama dengan flow ini:

```bash
export MAESTRO_VERSION=2.13.0
curl -Ls "https://get.maestro.mobile.dev" | bash
```

Lalu pastikan `~/.maestro/bin` ada di `PATH`. Cek dengan `maestro --version`.

Di macOS, Homebrew juga resmi:

```bash
brew tap mobile-dev-inc/tap
brew trust --formula mobile-dev-inc/tap/maestro
brew install mobile-dev-inc/tap/maestro
```

Di Windows, unduh `maestro.zip` dari rilis CLI, ekstrak, lalu tambahkan folder `bin` ke `PATH`.

Sumber: [cara pasang](https://docs.maestro.dev/maestro-cli/how-to-install-maestro-cli), [mengunci versi](https://docs.maestro.dev/maestro-cli/how-to-install-maestro-cli/update-the-maestro-cli), [rilis 2.13.0](https://github.com/mobile-dev-inc/Maestro/releases/tag/cli-2.13.0).

## Bangun dan jalankan aplikasi

Maestro tidak memasang aplikasi. Kita bangun dan pasang dulu, dengan emulator atau perangkat yang sudah terlihat di `adb devices`.

```bash
flutter pub get
flutter run
```

Atau pasang APK debug tanpa sesi `flutter run`:

```bash
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

## Menjalankan flow

Dari root repo:

```bash
maestro test .maestro/
maestro test .maestro/smoke.yaml
maestro test .maestro/ --include-tags=kategori
maestro test .maestro/ --include-tags=smoke
```

`maestro test .maestro/` menjalankan flow di akar workspace. `config.yaml` memakai pola `*` dan mengecualikan tag `util`, jadi berkas di `subflows/` tidak jalan sendiri.

Cek sintaks tanpa perangkat:

```bash
maestro check-syntax .maestro/smoke.yaml .maestro/kategori_tambah.yaml .maestro/kategori_validasi.yaml .maestro/kategori_hapus.yaml .maestro/subflows/buka_kategori.yaml .maestro/subflows/simpan_kategori.yaml
```

Jangan ikutkan `config.yaml` pada `check-syntax`. Berkas itu konfigurasi workspace, bukan flow.

## Isi workspace

| Berkas | Tag | Yang dicek |
| --- | --- | --- |
| `smoke.yaml` | `smoke` | Aplikasi terbuka, lima tujuan bilah navigasi ada, dashboard kosong menampilkan "Belum ada data" |
| `kategori_tambah.yaml` | `kategori` | Dari daftar kosong, form menyimpan "Uang Saku" / Pemasukan, nama muncul di daftar |
| `kategori_validasi.yaml` | `kategori` | Simpan dengan nama kosong menampilkan "Nama kategori wajib diisi" dan form tetap terbuka |
| `kategori_hapus.yaml` | `kategori` | Kategori yang baru disimpan dihapus lewat dialog konfirmasi, daftar kembali kosong |
| `subflows/buka_kategori.yaml` | `util` | `launchApp` dengan `clearState: true`, lalu buka tab Kategori |
| `subflows/simpan_kategori.yaml` | `util` | Isi form dari daftar kosong. Nama datang dari env `NAMA` |

Setiap flow utama membersihkan data aplikasi di awal lewat `clearState`, jadi berkas SQLite `dompet_mahasiswa.db` ikut terhapus. Flow kategori hanya menyentuh layar yang sudah ada: dashboard, bilah `MainShell`, daftar kategori, form kategori, dan `ConfirmDialog`.

## Selector

Teks yang unik kita pilih dengan selector teks. Selector itu regex dan harus cocok dengan seluruh label aksesibilitas, bukan potongan di tengah kalimat. Flutter kadang menggabungkan beberapa teks jadi satu label, misalnya nama kartu `Uang Saku` bersama badge `Pemasukan`, jadi flow memakai pola `Uang Saku.*`.

Ikon tanpa teks, atau teks yang bentrok (tooltip "Hapus" dan tombol "Hapus" di dialog), memakai `Semantics(identifier:)` lalu `id:` di flow:

- `nav_dashboard`, `nav_dompet`, `nav_transaksi`, `nav_riwayat`, `nav_kategori`
- `kategori_nama`
- `kategori_hapus`
- `konfirmasi_dialog`

Identifier itu tidak mengubah tampilan. `Key` Flutter tidak terlihat oleh Maestro.
