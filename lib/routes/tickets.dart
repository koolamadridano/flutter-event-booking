import 'package:app/screen/ticket/report.dart';
import 'package:app/screen/ticket/verification.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> routeTicket = [
  GetPage(
    name: "/ticket-verification",
    page: () => const Verification(),
  ),
  GetPage(
    name: "/ticket-report-user",
    page: () => const Report(),
  ),
];
