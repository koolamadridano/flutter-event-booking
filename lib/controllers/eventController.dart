import 'package:app/const/url.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as http;
import 'package:http_parser/http_parser.dart';

class EventController extends GetxController {
  String createEventSelectedCategory = "";
  RxBool isUploadingImages = false.obs;
  RxList uploadedIndexes = [].obs;
  RxList postedEvents = [].obs;
  RxList events = [].obs;
  RxBool isDeleting = false.obs;

  // EVP handle selected event for preview
  Map selectedEvent = {};
  Map selectedCarouselImg = {};

  Future<void> createEvent(data, images) async {
    try {
      Get.back(); // POP CATEGORY DIALOG
      isUploadingImages.value = true; // ASSIGN TO TRUE AND HIDE BUTTON

      var formD1 = http.FormData.fromMap({
        'img': await http.MultipartFile.fromFile(
          images["img1"]["path"],
          filename: images["img1"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      });
      var formD2 = http.FormData.fromMap({
        'img': await http.MultipartFile.fromFile(
          images["img2"]["path"],
          filename: images["img2"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      });
      var formD3 = http.FormData.fromMap({
        'img': await http.MultipartFile.fromFile(
          images["img3"]["path"],
          filename: images["img3"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      });

      var uploadResponse = await Future.wait(
        [
          _upload(formD1, 1),
          _upload(formD2, 2),
          _upload(formD3, 3),
        ],
      );

      var createEventResponse = await http.Dio().post(
        baseUrl + "/event",
        data: {
          "eventPlanner": {
            "id": data["eventPlanner"]["id"],
            "firstName": data["eventPlanner"]["firstName"],
            "lastName": data["eventPlanner"]["lastName"],
            "contactNo": data["eventPlanner"]["contactNo"]
          },
          "event": {
            "title": data["event"]["title"],
            "moreDetails": data["event"]["moreDetails"],
            "images": [
              uploadResponse[0].data["url"],
              uploadResponse[1].data["url"],
              uploadResponse[2].data["url"]
            ],
            "isEventAvailable": true,
            "priceRange": {
              "from": data["event"]["priceRange"]["from"],
              "to": data["event"]["priceRange"]["to"]
            },
            "category": createEventSelectedCategory,
          }
        },
      );

      isUploadingImages.value = false; // ASSIGN TO FALSE AND TOGGLE BUTTON
      uploadedIndexes.clear();
      Get.toNamed("/event-planner-events");
      prettyPrint("createEventResponse", createEventResponse.data);
    } on http.DioError catch (e) {
      print(e);
      // TODO
    }

    //prettyPrint("data", data);
    // prettyPrint("images", images);
  }

  Future<dynamic> getEventsById() async {
    final ProfileController _profile = Get.put(ProfileController());
    final _accountId = _profile.profileData["accountId"];

    var eventsResponse = await http.Dio().get(baseUrl + "/event/$_accountId");
    postedEvents.value = eventsResponse.data;
    postedEvents.refresh();

    return eventsResponse.data;
  }

  Future<dynamic> getEvents() async {
    var eventsResponse = await http.Dio().get(baseUrl + "/event");
    postedEvents.value = eventsResponse.data;
    postedEvents.refresh();

    return eventsResponse.data;
  }

  Future<void> deleteEventById(id) async {
    Get.back();
    isDeleting.value = true;
    await http.Dio().delete(baseUrl + "/event/$id");
    await getEventsById();
    isDeleting.value = false;
    Get.toNamed("/event-planner-main");
  }

  Future<dynamic> _upload(formData, index) async {
    uploadedIndexes.clear(); // Clear all indexes
    return await http.Dio().post(
      baseUrl + '/img',
      data: formData,
      onSendProgress: (int sent, int total) {
        if (total == sent) {
          uploadedIndexes.add(index); // Add index
          uploadedIndexes.refresh(); // Refres indexes
          print("Index $index was uploaded successfully");
        }
        // print("$sent / $total");
      },
    );
  }
}
