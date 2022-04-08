import 'package:app/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountDisabled extends StatelessWidget {
  const AccountDisabled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 4),
          Text(
            "Sorry, your account has been suspended for \n365 days by the Administrator for violating \nthe Terms, Condition and Policy.",
            style: GoogleFonts.roboto(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 15.0,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Get.put(UserController()).signOutGoogle(),
              child: Text(
                "LOGOUT",
                style: GoogleFonts.roboto(
                  color: Colors.black54,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
