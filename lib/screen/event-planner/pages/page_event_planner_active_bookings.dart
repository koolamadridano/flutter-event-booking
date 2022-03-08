import 'package:app/const/colors.dart';
import 'package:app/controllers/bookingsController.dart';
import 'package:app/helpers/getCategoryBadge.dart';
import 'package:app/helpers/random.dart';
import 'package:app/ux/alert_dialogs/confirm_complete_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PageEventPlannerActiveBookings extends StatefulWidget {
  const PageEventPlannerActiveBookings({Key? key}) : super(key: key);

  @override
  State<PageEventPlannerActiveBookings> createState() =>
      _PageEventPlannerActiveBookingsState();
}

class _PageEventPlannerActiveBookingsState
    extends State<PageEventPlannerActiveBookings> {
  final BookingsController _bookingsController = Get.put(BookingsController());

  Future<void> _callNumber(number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handleMarkEventAsCompleted(data) async {
    _bookingsController.evpSelectedActiveBooking = data;
    dialogIsEventFinished(
      context: context,
      action: () => _bookingsController.markBookedEventCompleted(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _bookingsController.getEventPlannerBookingsById("ready"),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: SizedBox(
                height: 34.0,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseSync,
                  colors: [Colors.black38],
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: Colors.transparent,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 34.0,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseSync,
                  colors: [Colors.black38],
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: Colors.transparent,
                ),
              ),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: SizedBox(
                height: 34.0,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseSync,
                  colors: [Colors.black38],
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: Colors.transparent,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length == 0) {
              return const Center(
                child: Icon(
                  MaterialIcons.inbox,
                  color: Colors.black26,
                  size: 82.0,
                ),
              );
            }
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              List<Widget> mapImages() {
                List<Widget> items = [];
                for (var i = 0;
                    i < snapshot.data[index]["event"]["images"].length;
                    i++) {
                  var widget = Container(
                    width: Get.width * 0.30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Image border
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(10), // Image radius
                        child: Image.network(
                          snapshot.data[index]["event"]["images"][i],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );

                  items.add(widget);
                }
                return items;
              }

              final _title = snapshot.data[index]["event"]["title"];
              final _customerAvatar =
                  snapshot.data[index]["header"]["customer"]["avatarUrl"];
              final _customerNote =
                  snapshot.data[index]["header"]["customer"]["note"];

              final _customerContactNo =
                  snapshot.data[index]["header"]["customer"]["contactNo"];
              final _customerName =
                  snapshot.data[index]["header"]["customer"]["firstName"];

              final _eventType =
                  eventType(snapshot.data[index]["event"]["category"]);

              final _bookedOn = Jiffy(snapshot.data[index]["bookedOn"])
                  .startOf(Units.SECOND)
                  .fromNow();

              return GestureDetector(
                onTap: () {
                  // _bookingsController.evpSelectedBooking = snapshot.data[index];
                  // Get.toNamed("/preview-event-planner-booking");
                },
                child: Container(
                  //color: Color.fromARGB(31, 172, 237, 194),
                  width: Get.width,
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    top: 20.0,
                    bottom: 10.0,
                  ),
                  margin: EdgeInsets.only(top: index == 0 ? 30.0 : 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(100), // Image border
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(100), // Image radius
                            child: Image.network(
                              _customerAvatar,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        width: Get.width * 0.40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                _title,
                                style: GoogleFonts.roboto(
                                  color: secondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.0,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                _customerContactNo,
                                style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                _customerName,
                                style: GoogleFonts.roboto(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () async =>
                              _handleMarkEventAsCompleted(snapshot.data[index]),
                          tooltip: "Mark as Completed",
                          splashRadius: 20,
                          icon: const Icon(
                            AntDesign.checkcircleo,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: IconButton(
                          onPressed: () async =>
                              await _callNumber(_customerContactNo),
                          tooltip: "Call",
                          splashRadius: 20,
                          icon: const Icon(
                            AntDesign.phone,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
