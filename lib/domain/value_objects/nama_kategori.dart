import 'package:characters/characters.dart';

enum KesalahanNamaKategori { kosong, terlaluPendek, terlaluPanjang }

abstract final class NamaKategori {
  static const panjangMinimum = 2;
  static const panjangMaksimum = 40;

  static KesalahanNamaKategori? validasi(String nama) {
    final namaBersih = nama.trim();
    if (namaBersih.isEmpty) return KesalahanNamaKategori.kosong;
    final panjang = namaBersih.characters.length;
    if (panjang < panjangMinimum) return KesalahanNamaKategori.terlaluPendek;
    if (panjang > panjangMaksimum) return KesalahanNamaKategori.terlaluPanjang;
    return null;
  }
}
