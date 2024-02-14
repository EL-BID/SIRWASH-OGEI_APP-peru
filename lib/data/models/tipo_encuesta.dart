class TipoEncuesta {
  final EncuestaKey key;
  final String titulo;
  final String subTitulo;
  final String imgPath;
  final String keycode;

  const TipoEncuesta({
    required this.key,
    required this.titulo,
    required this.subTitulo,
    required this.imgPath,
    required this.keycode,
  });
}

enum EncuestaKey {
  cloroResidual,
  componenteSap,
  continuidadServicio,
  cloracion
}
