import 'package:get/get.dart';
import 'package:task_manager/data/models/auth_utility.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/utils/urls.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';

class LoginController extends GetxController{

  bool _loginInProgress = false;
  bool get loginInProgress => _loginInProgress;

  Future<bool> login(String email, String password) async {
    _loginInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password
    };
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.login, requestBody);
    _loginInProgress = false;
    update();
    if (response.isSuccess) {
      await AuthUtility.saveUserInfo(LoginModel.fromJson(response.body!));
      return true;
    } else {
      return false;
    }
  }
}