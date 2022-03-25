import 'package:app/screen/organizer/organizer-main.dart';
import 'package:app/screen/preload_after_verified.dart';
import 'package:app/screen/ticket/verification.dart';
import 'package:app/screen/user/user_playground.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/screen/user/user_sign_in.dart';
import 'package:app/screen/user/user_sign_in_pre_load.dart';
import 'package:app/screen/customer/_customer_cancelled_bookings.dart';
import 'package:app/screen/customer/customer_bookings_page.dart';
import 'package:app/screen/customer/customer_event_preview.dart';
import 'package:app/screen/customer/customer_main_screen.dart';
import 'package:app/screen/customer/customer_receipts.dart';
import 'package:app/screen/event-planner/event_planner_create_events.dart';
import 'package:app/screen/event-planner/event_planner_event_preview.dart';
import 'package:app/screen/event-planner/event_planner_events.dart';
import 'package:app/screen/event-planner/event_planner_history.dart';
import 'package:app/screen/event-planner/event_planner_page.dart';
import 'package:app/screen/event-planner/preview/preview_event_planner_booking.dart';
import 'package:app/screen/event-planner/redirect/redirect_event_planner_accept_book.dart';
import 'package:app/screen/user/user_init_profile.dart';
import 'package:app/screen/user/usert_type_selection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Event Management Application',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Container(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      initialRoute: "/user-sign-in",
      getPages: [
        GetPage(
          name: "/playground",
          page: () => const PlaygroundScreen(),
        ),
        GetPage(
          name: "/user-sign-in",
          page: () => const UserSignIn(),
        ),
        GetPage(
          name: "/user-sign-in-preload",
          page: () => const UserSignInPreLoad(),
        ),
        GetPage(
          name: "/user-type-selection",
          page: () => const UserTypeSelection(),
        ),
        GetPage(
          name: "/user-init-profile",
          page: () => const UserInitializeProfile(),
        ),
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
        GetPage(
          name: "/event-planner-main",
          page: () => const EventPlannerMainScreen(),
        ),
        GetPage(
          name: "/event-planner-events",
          page: () => const EventPlannerEvents(),
        ),
        GetPage(
          name: "/event-planner-event-preview",
          page: () => const EventPlannerEventPreview(),
        ),
        GetPage(
          name: "/event-planner-create",
          page: () => const EventPlannerCreateEvent(),
        ),
        GetPage(
          name: "/event-planner-history",
          page: () => const EventPlannerHistory(),
        ),

        // Preview
        GetPage(
          name: "/preview-event-planner-booking",
          page: () => const PreviewEventPlannerBooking(),
        ),
        // Redirect
        GetPage(
          name: "/redirect-event-planner-accept-book",
          page: () => const RedirectEventPlannerAcceptBook(),
        ),

        GetPage(
          name: "/organizer-main",
          page: () => const OrganizerMain(),
        ),
        GetPage(
          name: "/ticket-verification",
          page: () => const Verification(),
        ),

        // PRELOAD
        GetPage(
          name: "/preload-after-verified",
          page: () => const PreloadAfterVerified(),
        ),
      ],
    );
  }
}
