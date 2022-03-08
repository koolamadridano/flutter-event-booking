import 'package:app/const/colors.dart';
import 'package:app/controllers/bookingsController.dart';
import 'package:app/helpers/getCategoryBadge.dart';
import 'package:app/ux/alert_dialogs/decline_dialog.dart';
import 'package:app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PreviewEventPlannerBooking extends StatefulWidget {
  const PreviewEventPlannerBooking({Key? key}) : super(key: key);

  @override
  State<PreviewEventPlannerBooking> createState() =>
      _PreviewEventPlannerBookingState();
}

class _PreviewEventPlannerBookingState
    extends State<PreviewEventPlannerBooking> {
  final BookingsController _bookingsController = Get.put(BookingsController());

  var _name,
      _title,
      _message,
      _tag,
      _avatarUrl,
      _bookedOn,
      _contactNo,
      _from,
      _to,
      _priceRange;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = _bookingsController.evpSelectedBooking["header"]["customer"]
            ["firstName"] +
        " " +
        _bookingsController.evpSelectedBooking["header"]["customer"]
            ["lastName"];

    _contactNo = _bookingsController.evpSelectedBooking["header"]["customer"]
        ["contactNo"];
    _title = _bookingsController.evpSelectedBooking["event"]["title"];
    _message =
        _bookingsController.evpSelectedBooking["header"]["customer"]["note"];
    _tag = _bookingsController.evpSelectedBooking["event"]["category"];
    _avatarUrl = _bookingsController.evpSelectedBooking["header"]["customer"]
        ["avatarUrl"];
    _bookedOn = Jiffy(_bookingsController.evpSelectedBooking["bookedOn"])
        .startOf(Units.SECOND)
        .fromNow();

    _from = NumberFormat.currency(name: "PHP").format(
      int.parse(_bookingsController.evpSelectedBooking["event"]["priceRange"]
          ["from"]),
    );
    _to = NumberFormat.currency(name: "PHP").format(
      int.parse(
          _bookingsController.evpSelectedBooking["event"]["priceRange"]["to"]),
    );
    _priceRange = _from + "\n" + _to;
  }

  Future<void> _callNumber(number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handleDecline() async {
    dialogDecline(
      context: context,
      action: () => _bookingsController.declineBooking(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title,
              style: GoogleFonts.roboto(
                color: secondary,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
            ),
            Text(
              "#" +
                  eventType(
                    _tag,
                  ).toUpperCase(),
              style: GoogleFonts.roboto(
                color: Colors.black54,
                fontSize: 10.0,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          IconButton(
            splashRadius: 20.0,
            onPressed: () async => await _callNumber(_contactNo),
            tooltip: "Call",
            icon: const Icon(
              Feather.phone_call,
              color: secondary,
            ),
          ),
        ],
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100), // Image border
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(100), // Image radius
                  child: Image.network(
                    _avatarUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: Text(
                _name,
                style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                ),
                maxLines: 2,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2.0),
              child: Text(
                _contactNo,
                style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0,
                ),
                maxLines: 2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                _message,
                style: GoogleFonts.roboto(
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2.0),
              child: Text(
                _bookedOn,
                style: GoogleFonts.roboto(
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 2),
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Text(
                "Price range (start - end)",
                style: GoogleFonts.roboto(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                _priceRange,
                style: GoogleFonts.rajdhani(
                  fontSize: 34.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  height: 0.8,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 5),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: Get.height * 0.06,
                    child: elevatedButton(
                      backgroundColor: Colors.red,
                      textStyle: GoogleFonts.roboto(
                        color: Colors.white,
                      ),
                      label: "DECLINE",
                      action: () => _handleDecline(),
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  child: SizedBox(
                    height: Get.height * 0.06,
                    child: elevatedButton(
                      backgroundColor: Colors.green,
                      textStyle: GoogleFonts.roboto(
                        color: Colors.white,
                      ),
                      label: "ACCEPT",
                      action: () =>
                          Get.toNamed("/redirect-event-planner-accept-book"),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
