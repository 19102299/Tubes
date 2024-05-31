import 'package:get/get.dart';
import 'package:surgakicare/services/auth_service.dart';

class AccountController extends GetxController {
  var name = "...".obs;
  var email = "...".obs;
  var tanggaldaftar = "...".obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    var service = AuthService();
    var user = service.getCurrentUser();

    var userInfo = await service.getUserInfo(user!.uid);
    name.value = userInfo?['nama'] ?? "";
    email.value = userInfo?['email'] ?? "";
    tanggaldaftar.value = userInfo?['terdaftar'] ?? "";
  }
}
