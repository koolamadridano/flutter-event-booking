import 'package:app/const/colors.dart';
import 'package:app/controllers/bookingsController.dart';
import 'package:app/controllers/eventController.dart';
import 'package:app/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

Future<void> dialogConfirmBook({context, action}) async {
  final BookingsController _bookingController = Get.put(BookingsController());
  final Map _selectedEvent = Get.put(EventController()).selectedEvent;

  final _contactNumberController = MaskedTextController(mask: '0000 000 0000');
  final _noteController = TextEditingController();

  Future<void> handleConfirmBook() async {
    final _contactNumber =
        _contactNumberController.text.trim().replaceAll(r' ', "");
    final _note = _noteController.text..trim();
    final _isReady = _note.isNotEmpty && _contactNumber.length == 11;

    if (_isReady) {
      Map data = {"note": _note, "contactNo": _contactNumber};
      _bookingController.bookEvent(data: data);
    }
  }

  return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
              width: Get.width * 0.90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedEvent["event"]["title"],
                    style: GoogleFonts.fredokaOne(
                      color: secondary,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Number to Contact",
                    style: GoogleFonts.fredokaOne(
                      color: secondary.withOpacity(0.8),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Container(
                    width: Get.width * 0.50,
                    child: Text(
                      "Event Planner will reach you using the number you provided below",
                      style: GoogleFonts.roboto(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: inputNumberTextField(
                      labelText: "Contact Number",
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      hintStyleStyle: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                      controller: _contactNumberController,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Note",
                    style: GoogleFonts.fredokaOne(
                      color: secondary.withOpacity(0.8),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Container(
                    width: Get.width * 0.50,
                    child: Text(
                      "Leave a note for Event Planner (optional)",
                      style: GoogleFonts.roboto(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: inputTextArea(
                      labelText: "Write Note",
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      hintStyleStyle: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                      controller: _noteController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width * 0.33,
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
                          width: Get.width * 0.33,
                          child: ElevatedButton(
                            onPressed: () => handleConfirmBook(),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            child: Text(
                              "Confirm",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
