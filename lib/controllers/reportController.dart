import 'package:app/const/url.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  Map selectedProfile = {};
  Future<void> reportUser(data) async {
    //prettyPrint("DATA_REPORT", data);
    await Dio().post(baseUrl + "/ticket/report-user", data: data);
  }
}
