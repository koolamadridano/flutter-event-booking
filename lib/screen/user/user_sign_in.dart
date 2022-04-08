import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:app/controllers/userController.dart';

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
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () => _handleSignIn(),
                    child: Text(
                      "Sign In With Google Account",
                      style: GoogleFonts.roboto(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                      ),
                    )),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
