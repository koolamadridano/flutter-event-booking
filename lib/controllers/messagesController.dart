import 'package:app/const/url.dart';
import 'package:app/controllers/profileController.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  Map selectedMessage = {};

  Future<dynamic> getMesages() async {
    final _profile = Get.put(ProfileController());
    final _messagesResponse = await Dio().get(
      baseUrl + "/message/${_profile.profileData["accountId"]}",
    );
    return _messagesResponse.data;
  }

  Future<void> openMessage(_id) async {
    await Dio().put(
      baseUrl + "/message",
      data: {"_id": _id, "opened": true},
    );
  }
}
