import 'package:app/screen/customer/_customer_cancelled_bookings.dart';
import 'package:app/screen/customer/customer_bookings_page.dart';
import 'package:app/screen/customer/customer_event_preview.dart';
import 'package:app/screen/customer/customer_main.dart';
import 'package:app/screen/customer/customer_receipts.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> routeCustomers = [
  GetPage(
    name: "/customer-main",
    page: () => const CustomerMainScreen(),
  ),
  GetPage(
    name: "/customer-messages",
    page: () => const CustomerMessages(),
  ),
  GetPage(
    name: "/customer-event-preview",
    page: () => const CustomerEventPreview(),
  ),
  GetPage(
    name: "/customer-event-bookings",
    page: () => const CustomerBookingsPage(),
  ),
  GetPage(
    name: "/customer-event-cancelled-bookings",
    page: () => const CustomerCancelledBookingsScreen(),
  ),
];
