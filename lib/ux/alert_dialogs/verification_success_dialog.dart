import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<Null> dialogVerificationSuccess({context, title, action}) async {
  return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
              width: Get.width * 0.50,
              height: Get.height * 0.15,
              child: SizedBox(
                child: Column(
                  children: [
                    const Icon(
                      AntDesign.checkcircle,
                      color: Colors.green,
                      size: 55.0,
                    ),
                    Spacer(),
                    Text(
                      "Congratulations! your account is now verified, please enjoy your bookings",
                      style: GoogleFonts.roboto(
                        color: Colors.green,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
