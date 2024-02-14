import 'dart:io';

class PhotoFile {
  final String uuid;
  final String name;
  final int tipoImagenId;
  final File file;
  final double latitude;
  final double longitude;

  const PhotoFile({
    required this.uuid,
    required this.name,
    required this.tipoImagenId,
    required this.file,
    required this.latitude,
    required this.longitude,
  });
}
