import 'package:app/const/url.dart';
import 'package:app/controllers/profileController.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as http;
import 'package:http_parser/http_parser.dart';

class OrganizerController extends GetxController {
  Map selectedOrganizer = {};
  RxBool imgIsUploading = false.obs;
  RxBool isCreatingLink = false.obs;
  RxBool hasLinks = false.obs;
  RxBool isDeleting = false.obs;
  RxBool isDeletingLink = false.obs;

  Future<void> uploadImage({data}) async {
    try {
      imgIsUploading.value = true;
      final _profile = Get.put(ProfileController());
      final payload = http.FormData.fromMap({
        "accountId": _profile.profileData["accountId"],
        'img': await http.MultipartFile.fromFile(
          data["img"]["path"],
          filename: data["img"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      });

      await http.Dio().post(
        baseUrl + '/photos',
        data: payload,
        onSendProgress: (int sent, int total) async {
          if (total == sent) {
            // Refres indexes
            print("Uploaded successfully");
          }
        },
      );
      imgIsUploading.value = false;
    } on http.DioError catch (e) {
      print(e.response!.data);
    }
  }

  Future<dynamic> getImages() async {
    try {
      final _profile = Get.put(ProfileController());
      var response = await http.Dio().get(
        baseUrl + "/photos/${_profile.profileData["accountId"]}",
      );

      return response.data;
    } on http.DioError catch (e) {
      print(e.response!.data);
    }
  }

  Future<dynamic> getLinks() async {
    try {
      final _profile = Get.put(ProfileController());
      var response = await http.Dio().get(
        baseUrl + "/url/${_profile.profileData["accountId"]}",
      );
      if (response.data.length >= 1) {
        hasLinks.value = true;
      }
      if (response.data.length == 0) {
        hasLinks.value = false;
      }
      return response.data;
    } on http.DioError catch (e) {
      print(e.response!.data);
    }
  }

  Future<void> createLink({title, url}) async {
    try {
      isCreatingLink.value = true;

      final _profile = Get.put(ProfileController());
      await http.Dio().post(
        baseUrl + '/url',
        data: {
          "accountId": _profile.profileData["accountId"],
          "title": title.toString().trim(),
          "url": url.toString().trim(),
        },
      );
      isCreatingLink.value = false;
    } on http.DioError catch (e) {
      print(e.response!.data);
      isCreatingLink.value = false;
    }
  }

  Future<void> deleteLink(id) async {
    try {
      isDeletingLink.value = true;
      await http.Dio().delete(baseUrl + "/url/$id");
      isDeletingLink.value = false;
    } on http.DioError catch (e) {
      print(e.response!.data);
      isDeletingLink.value = false;
    }
  }

  Future<void> deleteImage(id, publicId) async {
    try {
      isDeleting.value = true;
      await http.Dio().delete(baseUrl + "/photos", data: {
        "_id": id,
        "publicId": publicId,
      });
      isDeleting.value = false;
    } on http.DioError catch (e) {
      print(e.response!.data);
      isDeleting.value = false;
    }
  }

  Future<dynamic> getOrganizers() async {
    try {
      var response = await http.Dio().get(
        baseUrl + "/profile?userType=organizer",
      );
      return response.data;
    } on http.DioError catch (e) {
      print(e.response!.data);
    }
  }

  Future<dynamic> getSelectedOrganizerPhotos() async {
    try {
      var response = await http.Dio().get(
        baseUrl + "/photos/${selectedOrganizer["accountId"]}",
      );

      return response.data;
    } on http.DioError catch (e) {
      print(e.response!.data);
    }
  }

  Future<dynamic> getSelectedOrganizerLinks() async {
    try {
      var response = await http.Dio().get(
        baseUrl + "/url/${selectedOrganizer["accountId"]}",
      );
      if (response.data.length >= 1) {
        hasLinks.value = true;
      }
      if (response.data.length == 0) {
        hasLinks.value = false;
      }
      print(response.data);
      return response.data;
    } on http.DioError catch (e) {
      print(e.response!.data);
    }
  }
}
