import 'package:app/const/url.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ProfileController _profileController = Get.put(ProfileController());

  Map googleAccount = {};
  Map loginData = {};

  Future<void> signInGoogle() async {
    try {
      await _googleSignIn.signIn().then((value) async {
        print(value);
        googleAccount["id"] = value?.id;
        googleAccount["name"] = value?.displayName;
        googleAccount["email"] = value?.email;
        googleAccount["avatar"] = value?.photoUrl;
        prettyPrint("googleAccount", googleAccount);

        // IF VALUE IS NULL, RETURN;
        if (value == null) return;

        // REDIRECT TO PRELOAD
        Get.toNamed("/user-sign-in-preload");

        // CREATE USER ACCOUNT
        await createUserAccount(email: value.email, password: value.id);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOutGoogle() async {
    try {
      // REDIRECT TO PRELOAD
      Get.toNamed("/user-sign-in-preload");
      Future.delayed(const Duration(seconds: 2), () async {
        // SIGN OUT
        await _googleSignIn.signOut();

        // CLEAR
        googleAccount.clear();
        loginData.clear();

        // REDIRECT TO SIGN IN
        Get.toNamed("/user-sign-in");
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUserAccount({email, password}) async {
    try {
      var createUserResponse = await Dio().post(baseUrl + "/user", data: {
        "email": email,
        "password": password,
      });
      prettyPrint("createUserResponse", createUserResponse.data);

      // ATEMPT LOGIN AFTER REGISTRATION
      await loginUserAccount(email: email, password: password);
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        // ATEMPT LOGIN IF LOGIN FAILED
        loginUserAccount(email: email, password: password);
      }
    }
  }

  Future<void> loginUserAccount({email, password}) async {
    try {
      var loginResponse = await Dio().post(baseUrl + "/user/login", data: {
        "email": email,
        "password": password,
      });
      loginData = loginResponse.data;
      prettyPrint("loginData", loginData);

      // SEARCH PROFILE IF DOES EXIST
      await validateProfileIfExist(accountId: loginData["accountId"]);
    } on DioError catch (e) {
      print(e.response);
    }
  }

  Future<void> validateProfileIfExist({accountId}) async {
    try {
      var validatResponse = await Dio().get(baseUrl + "/profile/$accountId");
      prettyPrint("validateProfile", validatResponse.data);
      if (validatResponse.data["userType"] == "customer") {
        // ASSIGN PROFILE DATA
        _profileController.profileData = validatResponse.data;
        // REDIRECT TO CUSTOMER SCREEN
        Get.toNamed("/customer-main");
        return;
      }
      if (validatResponse.data["userType"] == "event-planner") {
        // ASSIGN PROFILE DATA
        _profileController.profileData = validatResponse.data;
        // REDIRECT TO EVENT PLANNER SCREEN
        Get.toNamed("/event-planner-main");
        return;
      }

      Get.back();
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        // REDIRECT
        Get.toNamed("/user-init-profile");
      }
    }
  }
}
