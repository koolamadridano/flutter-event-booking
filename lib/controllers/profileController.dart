import 'package:app/const/url.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Map profileData = {};

  Future<void> createProfile({userType, firstName, lastName, contact}) async {
    try {
      final _accountId = Get.put(UserController()).loginData["accountId"];

      // REDIRECT TO PRELOAD
      Get.toNamed("/user-sign-in-preload");

      // CREATE PROFILE
      var createProfileResponse = await Dio().post(
        baseUrl + "/profile",
        data: {
          "accountId": _accountId,
          "userType": userType,
          "firstName": firstName,
          "lastName": lastName,
          "isVerified": false
        },
      );
      await updateProfileContact(
        accountId: _accountId,
        email: contact["email"],
        contactNumber: contact["number"],
      );
      prettyPrint("createProfileResponse", createProfileResponse.data);
      if (userType == "customer") {
        await getProfile(accountId: _accountId);
        Get.toNamed("/customer-main");
        return;
      }
      if (userType == "event-planner") {
        await getProfile(accountId: _accountId);
        Get.toNamed("/event-planner-main");
        return;
      }
      if (userType == "organizer") {
        await getProfile(accountId: _accountId);
        Get.toNamed("/organizer-main");
        return;
      }
    } on DioError catch (e) {
      print(e.response!.data);
    }
  }

  Future<void> getProfile({accountId}) async {
    try {
      final accountId = Get.put(UserController()).loginData["accountId"];

      var profileResponse = await Dio().get(baseUrl + "/profile/$accountId");
      profileData = profileResponse.data;
      prettyPrint("profile", profileResponse.data);
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<void> updateProfileContact({email, contactNumber, accountId}) async {
    try {
      var updateContactResponse = await Dio().put(
        baseUrl + "/contact/$accountId",
        data: {"email": email, "number": contactNumber},
      );
      prettyPrint("updateProfileContact", updateContactResponse.data);
    } on DioError catch (e) {
      print(e);
    }
  }
}
