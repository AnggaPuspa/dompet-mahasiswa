enum KesalahanNamaDompet { kosong, terlaluPendek, terlaluPanjang }

abstract final class NamaDompet {
  static KesalahanNamaDompet? validasi(String nama) {
    final namaBersih = nama.trim();
    if (namaBersih.isEmpty) return KesalahanNamaDompet.kosong;
    final panjang = namaBersih.runes.length;
    if (panjang < 2) return KesalahanNamaDompet.terlaluPendek;
    if (panjang > 40) return KesalahanNamaDompet.terlaluPanjang;
    return null;
  }
}
