class Dompet {
  const Dompet({this.id, required this.nama});

  final int? id;
  final String nama;

  // Mengubah dompet menjadi map kolom sqlite.
  Map<String, Object?> toMap() {
    // Id null tidak dikirim. Map ini juga dipakai untuk update;
    // mengirim id null akan menimpa primary key, bukan meminta nomor baru.
    return {if (id != null) 'id': id, 'nama': nama};
  }

  // Membaca satu baris query kembali menjadi Dompet.
  factory Dompet.fromMap(Map<String, Object?> map) {
    return Dompet(id: map['id'] as int?, nama: map['nama'] as String);
  }
}
