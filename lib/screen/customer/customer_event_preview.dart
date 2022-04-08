import 'package:app/const/colors.dart';
import 'package:app/controllers/bookingsController.dart';
import 'package:app/controllers/eventController.dart';
import 'package:app/helpers/getCategoryBadge.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:app/ux/alert_dialogs/confirm_book_dialog.dart';
import 'package:app/ux/alert_dialogs/delete_dialog.dart';
import 'package:app/widgets/button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class CustomerEventPreview extends StatefulWidget {
  const CustomerEventPreview({Key? key}) : super(key: key);

  @override
  State<CustomerEventPreview> createState() => _CustomerEventPreviewState();
}

class _CustomerEventPreviewState extends State<CustomerEventPreview> {
  final EventController _eventController = Get.put(EventController());
  final BookingsController _bookingsController = Get.put(BookingsController());

  var _title,
      _datePosted,
      _date,
      _moreDetails,
      _priceRange,
      _firstName,
      _lastName,
      _from,
      _to;

  List<Widget> mapImages() {
    List<Widget> items = [];
    for (var i = 0;
        i < _eventController.selectedEvent["event"]["images"].length;
        i++) {
      var widget = Container(
        margin: const EdgeInsets.only(
          top: 15.0,
          left: 10.0,
          right: 10.0,
        ),
        width: Get.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Image border
          child: SizedBox.fromSize(
            size: const Size.fromRadius(10), // Image radius
            child: Image.network(
              _eventController.selectedEvent["event"]["images"][i],
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      items.add(widget);
    }
    return items;
  }

  @override
  void initState() {
    super.initState();

    _date = Jiffy(_datePosted).startOf(Units.SECOND).fromNow();
    _from = NumberFormat.currency(name: "PHP").format(
      int.parse(_eventController.selectedEvent["event"]["priceRange"]["from"]),
    );
    _to = NumberFormat.currency(name: "PHP").format(
      int.parse(_eventController.selectedEvent["event"]["priceRange"]["to"]),
    );
    _priceRange = _from + " to " + _to;

    _title = _eventController.selectedEvent["event"]["title"];
    _datePosted = _eventController.selectedEvent["event"]["postedOn"];
    _moreDetails = _eventController.selectedEvent["event"]["moreDetails"];
    _firstName = _eventController.selectedEvent["eventPlanner"]["firstName"];
    _lastName = _eventController.selectedEvent["eventPlanner"]["_lastName"];
  }

  Future<void> handleBookEvent() async {
    dialogConfirmBook(
      context: context,
      action: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 60.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              splashRadius: 20.0,
              onPressed:
                  _eventController.isDeleting.value ? () {} : () => Get.back(),
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
                  _eventController.selectedEvent["event"]["title"],
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
                        _eventController.selectedEvent["event"]["category"],
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
                onPressed: () => Get.toNamed("/ticket-report-user"),
                tooltip: "Report",
                splashRadius: 20,
                icon: const Icon(
                  MaterialIcons.report,
                  color: secondary,
                  size: 30,
                ),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bookingsController.isCreatingBook.value
                  ? const LinearProgressIndicator(
                      minHeight: 2,
                      color: secondary,
                    )
                  : const SizedBox(),
              Hero(
                tag: _eventController.selectedEvent["_id"],
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 350.0,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    autoPlay: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                  ),
                  items: mapImages(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 15.0,
                  left: 25.0,
                  right: 25.0,
                ),
                child: Text(
                  _title,
                  style: GoogleFonts.roboto(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 3.0,
                  left: 25.0,
                  right: 25.0,
                ),
                child: Text(
                  "Posted by $_firstName, $_date",
                  style: GoogleFonts.roboto(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 25.0,
                  left: 25.0,
                  right: 25.0,
                ),
                child: Text(
                  "$_priceRange",
                  style: GoogleFonts.rajdhani(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5.0,
                  left: 25.0,
                  right: 25.0,
                ),
                height: Get.height * 0.22,
                child: Text(
                  _moreDetails,
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 12,
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity:
                    _bookingsController.isCreatingBook.value == true ? 0.1 : 1,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 5.0,
                    left: 25.0,
                    right: 25.0,
                  ),
                  height: Get.height * 0.06,
                  width: Get.width,
                  child: elevatedButton(
                    backgroundColor: primary,
                    textStyle: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    label: "BOOK THIS EVENT",
                    action: _bookingsController.isCreatingBook.value == true
                        ? () {}
                        : () => handleBookEvent(),
                  ),
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
