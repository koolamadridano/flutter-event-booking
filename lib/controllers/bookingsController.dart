import 'package:app/const/url.dart';
import 'package:app/controllers/eventController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:app/helpers/random.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class BookingsController extends GetxController {
  RxBool isCreatingBook = false.obs;
  RxBool isCancellingBook = false.obs;

  Map evpSelectedBooking = {};
  Map evpSelectedActiveBooking = {};

  Future<void> bookEvent({required Map data}) async {
    try {
      final _refId = onRandomId();
      final _selectedEvent = Get.put(EventController()).selectedEvent;
      final _customerProfile = Get.put(ProfileController()).profileData;
      final _googleAccount = Get.put(UserController()).googleAccount;

      //POP BOOK DIALOG
      Get.back();
      isCreatingBook.value = true;

      // prettyPrint("selectedEvent_data", _selectedEvent);
      // prettyPrint("customerProfile_data", _customerProfile);
      // prettyPrint("bookData", data);

      await Dio().post(
        baseUrl + "/book",
        data: {
          "ref": _refId,
          "header": {
            "eventPlanner": {
              "id": _selectedEvent["eventPlanner"]["id"],
            },
            "customer": {
              "id": _customerProfile["accountId"],
              "avatarUrl": _googleAccount["avatar"],
              "firstName": _customerProfile["firstName"],
              "lastName": _customerProfile["lastName"],
              "contactNo": data["contactNo"],
              "note": data["note"],
            }
          },
          "event": {
            "title": _selectedEvent["event"]["title"],
            "images": _selectedEvent["event"]["images"],
            "priceRange": {
              "from": _selectedEvent["event"]["priceRange"]["from"],
              "to": _selectedEvent["event"]["priceRange"]["to"]
            },
            "category": _selectedEvent["event"]["category"]
          },
          "status": "pending"
        },
      );
      await Dio().post(
        baseUrl + "/me/bookings",
        data: {
          "ref": _refId,
          "header": {
            "eventPlanner": {
              "id": _selectedEvent["eventPlanner"]["id"],
              "firstName": _selectedEvent["eventPlanner"]["firstName"],
              "lastName": _selectedEvent["eventPlanner"]["lastName"],
              "contactNo": _selectedEvent["eventPlanner"]["contactNo"],
            },
            "customer": {
              "id": _customerProfile["accountId"],
            }
          },
          "event": {
            "title": _selectedEvent["event"]["title"],
            "images": _selectedEvent["event"]["images"],
            "location": "Not Specified",
            "priceRange": {
              "from": _selectedEvent["event"]["priceRange"]["from"],
              "to": _selectedEvent["event"]["priceRange"]["to"]
            },
            "category": _selectedEvent["event"]["category"]
          },
          "amountToPay": "Not Specified",
          "date": {"event": "Not Specified"},
          "status": "pending"
        },
      );
      isCreatingBook.value = false;
      //REDIRECT TO CUSTOMER BOOKINGS
      Get.toNamed("/customer-event-bookings");
    } on DioError catch (e) {
      isCreatingBook.value = false;
      print(e.response);
    }
  }

  Future<dynamic> getCustomerBookingsById(String status) async {
    try {
      final ProfileController _profile = Get.put(ProfileController());
      var bookingsResponse = await Dio().get(
        "$baseUrl/me/bookings/${_profile.profileData["accountId"]}",
        queryParameters: {
          'status': status,
        },
      );
      return bookingsResponse.data;
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<dynamic> getEvpBookingsById(String status) async {
    try {
      final ProfileController _profile = Get.put(ProfileController());
      var bookingsResponse = await Dio().get(
        "$baseUrl/evp/bookings/${_profile.profileData["accountId"]}",
        queryParameters: {
          'status': status,
        },
      );
      return bookingsResponse.data;
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<dynamic> getEventPlannerBookingsById(String status) async {
    try {
      final ProfileController _profile = Get.put(ProfileController());
      var bookingsResponse = await Dio().get(
        "$baseUrl/book/${_profile.profileData["accountId"]}",
        queryParameters: {"status": status},
      );
      return bookingsResponse.data;
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<void> cancelBookedEvent(String _ref) async {
    Get.back(); // POP
    isCancellingBook.value = true;
    await Dio().put(
      baseUrl + "/me/bookings/$_ref",
      data: {"status": "cancelled"},
    );
    await Dio().put(
      baseUrl + "/book/$_ref",
      data: {
        "status": "cancelled",
      },
    );
    isCancellingBook.value = false;
    Get.toNamed("/customer-event-cancelled-bookings");
  }

  Future<void> markBookedEventAsReady({required Map data}) async {
    Get.toNamed("/user-sign-in-preload");
    final _ref = evpSelectedBooking["ref"];
    await Dio().put(
      baseUrl + "/update-booking-as-ready/$_ref",
      data: {
        "eventLocation": data["eventLocation"],
        "eventDate": data["eventDate"],
        "amountToPay": data["amountToPay"],
        "status": "ready",
      },
    );
    await Dio().put(
      baseUrl + "/book/$_ref",
      data: {
        "status": "ready",
      },
    );
    Get.toNamed("/event-planner-main");
  }

  Future<void> markBookedEventCompleted() async {
    try {
      Get.toNamed("/user-sign-in-preload");
      final _ref = evpSelectedActiveBooking["ref"];
      await Dio().put(
        baseUrl + "/me/bookings/$_ref",
        data: {
          "status": "completed",
        },
      );
      await Dio().put(
        baseUrl + "/book/$_ref",
        data: {
          "status": "completed",
        },
      );
      Get.toNamed("/event-planner-history");
    } on DioError catch (e) {
      print(e.response);
    }
  }

  Future<void> declineBooking() async {
    try {
      Get.toNamed("/user-sign-in-preload");
      final _ref = evpSelectedBooking["ref"];
      await Dio().put(
        baseUrl + "/book/$_ref",
        data: {
          "status": "declined",
        },
      );
      await Dio().put(
        baseUrl + "/me/bookings/$_ref",
        data: {
          "status": "declined",
        },
      );
      Get.toNamed("/event-planner-main");
    } on DioError catch (e) {
      print(e.response);
    }
  }
}
