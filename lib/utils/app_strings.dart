// Semua teks yang pengguna lihat ada di sini.
// Halaman tidak menulis kalimat sendiri, supaya kata yang sama tidak tersebar.
abstract final class AppStrings {
  static const String appName = 'Dompet Mahasiswa';
  static const String placeholderBody = 'Dompet Mahasiswa';

  static const String dashboard = 'Dashboard';
  static const String riwayat = 'Riwayat';
  static const String transaksi = 'Transaksi';
  static const String dompet = 'Dompet';
  static const String kategori = 'Kategori';
  static const String tambahDompet = 'Tambah Dompet';
  static const String ubahDompet = 'Ubah Dompet';
  static const String tambahKategori = 'Tambah Kategori';
  static const String ubahKategori = 'Ubah Kategori';
  static const String tambahTransaksi = 'Tambah Transaksi';
  static const String ubahTransaksi = 'Ubah Transaksi';
  static const String simpan = 'Simpan';
  static const String batal = 'Batal';
  static const String hapus = 'Hapus';
  static const String cobaLagi = 'Coba Lagi';
  static const String tambah = 'Tambah';
  static const String ok = 'OK';
  static const String tutup = 'Tutup';

  static const String namaDompet = 'Nama Dompet';
  static const String hintNamaDompet = 'Contoh: Dompet Utama';
  static const String namaKategori = 'Nama Kategori';
  static const String hintNamaKategori = 'Contoh: Makanan';
  static const String jenis = 'Jenis';
  static const String pemasukan = 'Pemasukan';
  static const String pengeluaran = 'Pengeluaran';
  static const String jumlah = 'Jumlah';
  static const String hintJumlah = 'Masukkan nominal';
  static const String tanggal = 'Tanggal';
  static const String catatan = 'Catatan';
  static const String hintCatatan = 'Opsional';
  static const String filterBulan = 'Filter Bulan';
  static const String filterKategori = 'Filter Kategori';
  static const String semuaBulan = 'Semua Bulan';
  static const String semuaKategori = 'Semua Kategori';
  static const String pilihDompet = 'Pilih Dompet';
  static const String pilihKategori = 'Pilih Kategori';

  static const String namaDompetWajib = 'Nama dompet wajib diisi';
  static const String namaDompetMin2 = 'Nama dompet minimal 2 karakter';
  static const String namaDompetMax40 = 'Nama dompet maksimal 40 karakter';
  static const String namaKategoriWajib = 'Nama kategori wajib diisi';
  static const String namaKategoriMin2 = 'Nama kategori minimal 2 karakter';
  static const String namaKategoriMax40 = 'Nama kategori maksimal 40 karakter';
  static const String jenisWajib = 'Jenis wajib dipilih';
  static const String dompetWajib = 'Dompet wajib dipilih';
  static const String kategoriWajib = 'Kategori wajib dipilih';
  static const String jumlahWajib = 'Jumlah wajib diisi';
  static const String jumlahHarusAngka = 'Jumlah harus berupa angka';
  static const String jumlahHarusLebihDari0 = 'Jumlah harus lebih dari 0';
  static const String tanggalWajib = 'Tanggal wajib dipilih';
  static const String catatanMax200 = 'Catatan maksimal 200 karakter';

  static const String saldoTidakCukupPrefix = 'Saldo tidak cukup. Tersedia ';
  static const String dompetTidakBisaDihapus =
      'Dompet tidak bisa dihapus karena masih dipakai transaksi.';
  static const String kategoriTidakBisaDihapus =
      'Kategori tidak bisa dihapus karena masih dipakai transaksi.';
  static const String hapusDompetJudul = 'Hapus Dompet?';
  static const String hapusDompetPesan =
      'Dompet ini akan dihapus permanen dari aplikasi.';
  static String konfirmasiHapusDompet(String nama) =>
      'Dompet "$nama" akan dihapus. Lanjutkan?';
  static const String hapusKategoriJudul = 'Hapus Kategori?';
  static const String hapusKategoriPesan =
      'Kategori ini akan dihapus permanen dari aplikasi.';
  static const String hapusTransaksiJudul = 'Hapus Transaksi?';
  static const String hapusTransaksiPesan =
      'Transaksi ini akan dihapus permanen dari riwayat.';

  static String saldoTidakCukup(String saldoTerformat) =>
      '$saldoTidakCukupPrefix$saldoTerformat';

  static const String belumAdaData = 'Belum ada data';
  static const String belumAdaDompet = 'Belum ada dompet';
  static const String belumAdaDompetPesan =
      'Tambah dompet dulu, misalnya Tunai, Bank, atau E-wallet.';
  static const String belumAdaKategori = 'Belum ada kategori';
  static const String belumAdaTransaksi = 'Belum ada transaksi';
  static const String tidakAdaTransaksiFilter =
      'Tidak ada transaksi untuk filter ini';
  static const String belumAdaPengeluaranBulanIni =
      'Belum ada pengeluaran bulan ini';
  static const String belumBisaCatatTransaksi =
      'Tambahkan dompet dan kategori dulu untuk mencatat transaksi.';
  static const String gagalMemuatDashboard = 'Gagal memuat dashboard';
  static const String gagalMemuatDompet = 'Gagal memuat daftar dompet';
  static const String gagalMenghapusDompet = 'Gagal menghapus dompet.';
  static const String dompetTidakDitemukan = 'Dompet tidak ditemukan.';
  static const String gagalMenyimpanDompet = 'Gagal menyimpan dompet.';
  static const String gagalMemuatKategori = 'Gagal memuat daftar kategori';
  static const String gagalMemuatRiwayat = 'Gagal memuat riwayat';
  static const String gagalMemuatFormTransaksi = 'Gagal memuat form transaksi';
  static const String dompetDisimpan = 'Dompet berhasil disimpan';
  static const String dompetDiperbarui = 'Dompet berhasil diperbarui';
  static const String dompetDihapus = 'Dompet berhasil dihapus';
  static const String kategoriDisimpan = 'Kategori berhasil disimpan';
  static const String kategoriDiperbarui = 'Kategori berhasil diperbarui';
  static const String kategoriDihapus = 'Kategori berhasil dihapus';
  static const String transaksiDisimpan = 'Transaksi berhasil disimpan';
  static const String transaksiDiperbarui = 'Transaksi berhasil diperbarui';
  static const String transaksiDihapus = 'Transaksi berhasil dihapus';

  static const String totalSaldo = 'Total Saldo';
  static const String pemasukanBulanIni = 'Pemasukan Bulan Ini';
  static const String pengeluaranBulanIni = 'Pengeluaran Bulan Ini';
  static const String pengeluaranTerbesarBulanIni = 'Pengeluaran Terbesar';

  static const String periodeBulanan = 'Bulanan';
  static const String periodeMingguan = 'Mingguan';
  static const String periodeTahunan = 'Tahunan';
  static const String pilihPeriode = 'Pilih Periode';
}
