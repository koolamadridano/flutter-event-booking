import 'package:app/screen/event-planner/event_planner_create_events.dart';
import 'package:app/screen/event-planner/event_planner_event_preview.dart';
import 'package:app/screen/event-planner/event_planner_events.dart';
import 'package:app/screen/event-planner/event_planner_history.dart';
import 'package:app/screen/event-planner/event_planner_main.dart';
import 'package:app/screen/event-planner/preview/preview_event_planner_booking.dart';
import 'package:app/screen/event-planner/redirect/redirect_event_planner_accept_book.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> routeEventPlanner = [
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
];
