import 'dart:io';

class Gonderi {
  final String baslik;
  final String aciklama;
  final int kilometre;
  final File? foto;

  Gonderi({
    required this.baslik,
    required this.aciklama,
    required this.kilometre,
    this.foto,
  });
}
