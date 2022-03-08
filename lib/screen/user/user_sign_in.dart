import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/changeStatusBarColor.dart';
import 'package:app/helpers/lifecycleEventHandler.dart';

class UserSignIn extends StatefulWidget {
  const UserSignIn({Key? key}) : super(key: key);

  @override
  State<UserSignIn> createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {
  final UserController _userController = Get.put(UserController());

  Future<void> _handleSignIn() async {
    await _userController.signInGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
          // color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                "images/undraw_festivities_tvvj 1.png",
                height: 150.0,
              ),
              const Spacer(flex: 5),
              //const Spacer(),
              Text(
                "SIGN IN USING",
                style: GoogleFonts.roboto(
                  color: Colors.grey.withOpacity(0.7),
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      MaterialCommunityIcons.facebook,
                      color: Color(0xFF39579B),
                      size: 34.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    onPressed: () => _handleSignIn(),
                    icon: const Icon(
                      MaterialCommunityIcons.google,
                      color: Color(0xFFE94335),
                      size: 34.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    onPressed: () => _userController.signOutGoogle(),
                    icon: const Icon(
                      MaterialCommunityIcons.twitter,
                      color: Color(0xFF1DABDD),
                      size: 34.0,
                    ),
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
