import 'package:app/const/colors.dart';
import 'package:app/controllers/bookingsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<Null> dialogDecline({required BuildContext context, action}) async {
  return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
              width: Get.width * 0.50,
              height: Get.height * 0.15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5.0),
                  Text(
                    "Do you want to decline this booking?",
                    style: GoogleFonts.roboto(
                      color: Colors.black87,
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      const Icon(
                        MaterialCommunityIcons.information_outline,
                        size: 10.0,
                        color: Colors.black38,
                      ),
                      const SizedBox(width: 3.0),
                      Text(
                        "this action is cannot be undone",
                        style: GoogleFonts.roboto(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 10.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.26,
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.roboto(
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      SizedBox(
                        width: Get.width * 0.26,
                        child: ElevatedButton(
                          onPressed: () => action(),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: Text(
                            "Yes",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
