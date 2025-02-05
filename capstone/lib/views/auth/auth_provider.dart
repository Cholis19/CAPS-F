import 'package:flutter/material.dart';
import 'package:mobile_flutter/models/api/auth_api.dart';
import 'package:mobile_flutter/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider extends ChangeNotifier {

  UserModel? _user;

  UserModel? get user => _user;

  Future<String> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('TOKEN') != null) {
      if (prefs.getString('status_user') == 'unvalidated') {
        return 'unvalidated';
      }
      await getProfile();
      return 'validated';
    }
    return 'failed';
  }

  Future<String> register({required String email, required String password, required String confirmationPassword}) async {
    final auth = AuthAPI();
    String result = await auth.register(email, password, confirmationPassword);
    if (result == 'register success') {
      await getProfile();
    }

    return result;
  }

  Future<String> login({required String email, required String password}) async {
    final auth = AuthAPI();
    String result = await auth.login(email, password);
    if (result == 'login success') {
      await getProfile();
    }

    return result;
  }

  Future<String> createProfile({
    required String name,
    required String phoneNumber,
    required String city,
    required String province,
    required String address
  }) async {
    final auth = AuthAPI();
    String result = await auth.createProfile(name: name, phoneNumber: phoneNumber, city: city, province: province, address: address);
    await getProfile();
    return result;
  }

  Future<void> getProfile() async {
    final auth = AuthAPI();
    final UserModel? result = await auth.getProfile();
    if (result != null) {
      _user = result;
    }
    notifyListeners();
  }

  Future<String> registerMember() async {
    final auth = AuthAPI();
    final result = await auth.registerMember();
    if (result == 'success') {
      await getProfile();
      notifyListeners();
    }
    return result;
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _user = null;
  }

  Future<String> uploadPicture({required String imagePath}) async {
    final auth = AuthAPI();
    final result = await auth.uploadPicture(imagePath: imagePath);
    getProfile();
    return result;
  }

}