part of 'widgets.dart';

class PhotoUser extends StatelessWidget {
  final String avatarUrl;
  final int photoVersion;
  final double wsize;
  final double hsize;
  final Uint8List? imgBytes;

  const PhotoUser({
    Key? key,
    required this.avatarUrl,
    required this.photoVersion,
    required this.wsize,
    required this.hsize,
    required this.imgBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.wsize,
      height: this.hsize,
      decoration: BoxDecoration(
          color: Helpers.darken(akScaffoldBackgroundColor, 0.05),
          // border: Border.all(color: Colors.black26, width: 2),
          borderRadius: BorderRadius.circular(10.0),
          image: imgBytes != null
              ? DecorationImage(
                  image: MemoryImage(imgBytes!), fit: BoxFit.cover)
              : DecorationImage(
                  image: AssetImage('assets/img/fondo_cargar_imagen.png'),
                  fit: BoxFit.cover,
                )),
    );
  }
}
