import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/utils/utils.dart';

/// Muestra una alerta para salir de la encuesta sin guardar
Future<bool> confirmBackWithoutSave() async {
  final result = await Helpers.confirmDialog(
    title: '¿Seguro que deseas salir?',
    subTitle: 'Los datos registrados no se guardarán',
    noText: 'No, seguir editando',
    yesText: 'Sí',
  );

  return result ?? false;
}

/// Función utilizada por las encuestas para comprobar si
/// las fotos(requeridas) fueron completadas o no.
bool checkPhotosCompleted(
    List<TipoImagen> listTipoImagen, List<PhotoFile> photos) {
  bool photosCompleted = true;
  // Recibe los tipo de imagenes (Obligatorios, facultativos, etc)
  // Filtra aquellos tipos que sean requeridos
  final requiredGroups = listTipoImagen.where((t) => t.requerido);
  // Recorre los grupos de tipo de imagenes requeridos
  // Dentro, recorre la lista de fotos, filtra aquellas que tenga el mismo tipo de imagen y
  // valida que tengan al menos un elemento, de lo contrario photosCompleted será false
  for (var group in requiredGroups) {
    final filterPhotos = photos.where(
      (p) => p.tipoImagenId == group.tipoImagenesId,
    );
    if (filterPhotos.isEmpty) {
      photosCompleted = false;
    }
  }

  return photosCompleted;
}

/// Evalúa las casuísticas y determina el mensaje de error
/// obtienen la lista de centros poblados
String? erroresListCentroPoblado(
    AuthController authX, List<CentroPoblado> filterList) {
  String? error;

  if (filterList.isEmpty) {
    if (!authX.hasCredentials) {
      return 'Lista de centros poblados vacía. Asegúrate de sincronizar desde Ajustes.';
    }

    if (authX.userCredentials!.misCentrosPoblados.isEmpty) {
      return 'Tu cuenta de usuario no tiene centros poblados asignados.';
    }

    return 'Tus centros poblados asignados no se encontraron en el almacenamiento. Asegúrate de sincronizar desde Ajustes.';
  }

  return error;
}
