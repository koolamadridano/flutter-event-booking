import 'package:app/routes/customers.dart';
import 'package:app/routes/event_organizer.dart';
import 'package:app/routes/event_planner.dart';
import 'package:app/routes/tickets.dart';
import 'package:app/routes/users.dart';
import 'package:app/screen/account_disabled.dart';
import 'package:app/screen/messages.dart';
import 'package:app/screen/user/user_terms_and_agreement.dart';
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
          name: "/terms-agreement-and-policy",
          page: () => const TermsAndAgreement(),
        ),
        GetPage(
          name: "/messages",
          page: () => const Messages(),
        ),
        GetPage(
          name: "/account-disabled",
          page: () => const AccountDisabled(),
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
