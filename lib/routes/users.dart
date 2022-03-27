import 'package:app/screen/user/user_init_profile.dart';
import 'package:app/screen/user/user_sign_in.dart';
import 'package:app/screen/user/user_sign_in_pre_load.dart';
import 'package:app/screen/user/usert_type_selection.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> routeUsers = [
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
  )
];
