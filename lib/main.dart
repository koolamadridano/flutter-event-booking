import 'package:app/routes/customers.dart';
import 'package:app/routes/event_organizer.dart';
import 'package:app/routes/event_planner.dart';
import 'package:app/routes/tickets.dart';
import 'package:app/routes/users.dart';
import 'package:app/screen/user/user_playground.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        ...routeUsers,
        ...routeCustomers,
        ...routeEventPlanner,
        ...routeEventOrganizer,
        ...routeTicket,
      ],
    );
  }
}
