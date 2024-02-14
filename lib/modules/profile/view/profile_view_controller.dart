import 'package:get/get.dart';
import 'package:sirwash/data/models/employee.dart';
import 'package:sirwash/data/models/user_credentials.dart';
import 'package:sirwash/modules/auth/auth_controller.dart';
import 'package:sirwash/utils/utils.dart';

class ProfileViewController extends GetxController {
  final _authX = Get.find<AuthController>();

  final loading = false.obs;
  final allDataLoaded = false.obs;
  Employees? employee;
  late UserCredentials userCredentials;

  String appVersion = '';

  bool registeredUser = false;

  @override
  void onInit() {
    super.onInit();
    Helpers.logger.wtf(_authX.userCredentials?.toJson().toString());
    //_fetchData();

    userCredentials = _authX.userCredentials!;

    registeredUser = userCredentials.iduser != null;
  }

  void onLogoutButtonTap() {
    _authX.logout();
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;

    return true;
  }
}
