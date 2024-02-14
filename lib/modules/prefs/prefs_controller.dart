import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sirwash/constants/constants.dart';
import 'package:sirwash/data/models/user_credentials.dart';
import 'package:sirwash/utils/utils.dart';

class PrefsController extends GetxController {
  final box = GetStorage();

  // Obtiene las credenciales al Storage desde el String en memoria
  UserCredentials? get userCredentialStored {
    try {
      final credentialsEncoded = box.read(K_BOX_USERSESSION_KEY);
      if (credentialsEncoded is String) {
        final credentialsDecoded = jsonDecode(credentialsEncoded);
        final credentialsInstance =
            UserCredentials.fromJson(credentialsDecoded);
        return credentialsInstance;
      } else {
        Helpers.logger.wtf('No hay usuario..');
        return null;
      }
    } catch (e) {
      Helpers.logger.e(e.toString());
      Helpers.logger.e('No se pudo decodificar el usuario o no hay usuario');
      deleteAll();
      return null;
    }
  }

  /// Almacena las credenciales de usuario en el almacenamiento de la app
  Future<void> setUserCredentialStored(UserCredentials? credentials) async {
    if (credentials != null) {
      final credentialsJsonString = jsonEncode(credentials.toJson());
      await box.write(K_BOX_USERSESSION_KEY, credentialsJsonString);
    } else {
      await box.remove(K_BOX_USERSESSION_KEY);
    }
  }

  Future<void> deleteAll() async {
    await box.erase();
  }
}
