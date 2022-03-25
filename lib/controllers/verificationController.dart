import 'package:app/const/url.dart';
import 'package:app/controllers/profileController.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as http;
import 'package:http_parser/http_parser.dart';

class VerificationController extends GetxController {
  RxBool verificationImgIsUploading = false.obs;
  RxBool hasPendingTicket = false.obs;
  RxBool hasVerifiedTicket = false.obs;
  RxBool hasTicket = false.obs;

  Future<void> submitVerificationTicket({data}) async {
    verificationImgIsUploading.value = true;
    try {
      final _profile = Get.put(ProfileController());
      final payload = http.FormData.fromMap({
        "accountId": _profile.profileData["accountId"],
        "firstName": _profile.profileData["firstName"],
        "lastName": _profile.profileData["lastName"],
        "address": data["address"],
        "contactNumber": data["contactNo"],
        "status": "pending",
        'img': await http.MultipartFile.fromFile(
          data["img"]["path"],
          filename: data["img"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      });

      await http.Dio().post(
        baseUrl + '/ticket/verification',
        data: payload,
        onSendProgress: (int sent, int total) async {
          if (total == sent) {
            // Refres indexes
            print("Uploaded successfully");
          }
        },
      );
      verificationImgIsUploading.value = false;
    } on http.DioError catch (e) {
      print(e.response!.data);
    }
  }

  Future<void> checkVerificationTicket() async {
    try {
      final _profile = Get.put(ProfileController());
      var response = await http.Dio().get(
        baseUrl + "/ticket/s/verification/${_profile.profileData["accountId"]}",
      );

      if (response.data == null) {
        hasTicket.value = false;
        hasPendingTicket.value = false;
        hasVerifiedTicket.value = false;
        print("HAS NO TICKET");
        return;
      }

      hasTicket.value = true;

      if (response.data["status"] == "verified") {
        //ASSIGN
        hasVerifiedTicket.value = true;

        print("HAS VERIFIED TICKET");
        return;
      }
      if (response.data["status"] == "pending") {
        //RESET
        hasVerifiedTicket.value = false;
        //ASSIGN
        hasPendingTicket.value = true;
        print("HAS PENDING TICKET");
        return;
      }

      print("HAS TICKET? ${hasTicket.value}");
    } on http.DioError catch (e) {
      print(e.response!.data);
      hasTicket.value = false;
      hasPendingTicket.value = false;
      hasVerifiedTicket.value = false;
      //   hasPendingTicket.value = false;
    }
  }
}
