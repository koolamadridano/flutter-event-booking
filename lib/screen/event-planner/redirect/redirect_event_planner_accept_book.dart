import 'package:app/const/colors.dart';
import 'package:app/controllers/bookingsController.dart';
import 'package:app/helpers/focusNode.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/input.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class RedirectEventPlannerAcceptBook extends StatefulWidget {
  const RedirectEventPlannerAcceptBook({Key? key}) : super(key: key);

  @override
  State<RedirectEventPlannerAcceptBook> createState() =>
      _RedirectEventPlannerAcceptBookState();
}

class _RedirectEventPlannerAcceptBookState
    extends State<RedirectEventPlannerAcceptBook> {
  final _bookingsController = Get.put(BookingsController());

  final _eventDateTimeController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final _totalPaymentController = TextEditingController();

  handleMarkAsReady() {
    final _eventDateTime = _eventDateTimeController.text.trim();
    final _eventLocation = _eventLocationController.text.trim();
    final _totalPayment = _totalPaymentController.text.trim();

    final _isReady = _eventDateTime.isNotEmpty &&
        _eventLocation.isNotEmpty &&
        _totalPayment.isNotEmpty;

    if (_isReady) {
      Map data = {
        "eventLocation": _eventLocation,
        "eventDate": _eventDateTime,
        "amountToPay": _totalPayment,
      };
      _bookingsController.markBookedEventAsReady(data: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => destroyTextFieldFocus(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 60.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            splashRadius: 20.0,
            onPressed: () => Get.back(),
            icon: const Icon(
              AntDesign.arrowleft,
              color: secondary,
            ),
          ),
          elevation: 0,
          shadowColor: Colors.white,
          // shape: Border(
          //   bottom: BorderSide(color: secondary.withOpacity(0.2), width: 0.5),
          // ),
          title: Text(
            "Confirm Booking",
            style: GoogleFonts.fredokaOne(
              color: secondary.withOpacity(0.8),
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          child: Column(
            children: [
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: inputTextField(
                        labelText: "Event Date and Time",
                        textFieldStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                        hintStyleStyle: GoogleFonts.roboto(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                        ),
                        controller: _eventDateTimeController,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        BottomPicker.dateTime(
                          height: Get.height * 0.40,
                          title: "Event Date and Time",
                          titleStyle: GoogleFonts.roboto(
                            color: secondary,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          buttonAlignement: MainAxisAlignment.end,
                          buttonSingleColor: primary,
                          onSubmit: (date) {
                            _eventDateTimeController.text =
                                Jiffy(date).yMMMMEEEEdjm;
                          },
                          onClose: () {
                            print("Picker closed");
                          },
                          iconColor: Colors.white,
                          minDateTime: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day + 1,
                          ),
                          maxDateTime: DateTime(DateTime.now().year + 1),
                          use24hFormat: false,
                          pickerTextStyle: GoogleFonts.roboto(
                            color: secondary,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                          ),
                          gradientColors: const [],
                        ).show(context);
                      },
                      splashRadius: 20,
                      icon: const Icon(
                        AntDesign.calendar,
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: inputTextField(
                  labelText: "Event Location",
                  textFieldStyle: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                  hintStyleStyle: GoogleFonts.roboto(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                  controller: _eventLocationController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: inputNumberTextField(
                  labelText: "Total Payment",
                  textFieldStyle: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                  hintStyleStyle: GoogleFonts.roboto(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                  controller: _totalPaymentController,
                ),
              ),
              const Spacer(flex: 9),
              SizedBox(
                height: Get.height * 0.06,
                width: Get.width,
                child: elevatedButton(
                  backgroundColor: primary,
                  textStyle: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  label: "Confirm",
                  action: () => handleMarkAsReady(),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
