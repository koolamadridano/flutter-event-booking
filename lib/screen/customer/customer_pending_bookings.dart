import 'package:app/const/colors.dart';
import 'package:app/controllers/bookingsController.dart';
import 'package:app/helpers/getCategoryBadge.dart';
import 'package:app/helpers/random.dart';
import 'package:app/ux/alert_dialogs/cancel_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomerPendingBookings extends StatefulWidget {
  const CustomerPendingBookings({Key? key}) : super(key: key);

  @override
  State<CustomerPendingBookings> createState() =>
      _CustomerPendingBookingsState();
}

class _CustomerPendingBookingsState extends State<CustomerPendingBookings> {
  final BookingsController _bookingsController = Get.put(BookingsController());

  Future<void> _handleCancelBooking({
    required String ref,
    required String title,
  }) async {
    dialogCancelBooking(
      context: context,
      title: title,
      action: () => _bookingsController.cancelBookedEvent(ref),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _bookingsController.isCancellingBook.value
                  ? const Center(
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
                    )
                  : Expanded(
                      child: FutureBuilder(
                        future: _bookingsController
                            .getCustomerBookingsById("pending"),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.none) {
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                                    i <
                                        snapshot.data[index]["event"]["images"]
                                            .length;
                                    i++) {
                                  var widget = Container(
                                    width: Get.width * 0.30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          10), // Image border
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(
                                            10), // Image radius
                                        child: Image.network(
                                          snapshot.data[index]["event"]
                                              ["images"][i],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );

                                  items.add(widget);
                                }
                                return items;
                              }

                              final _bookRef = snapshot.data[index]["ref"];
                              final _title =
                                  snapshot.data[index]["event"]["title"];
                              final _eventPlannerName = snapshot.data[index]
                                  ["header"]["eventPlanner"]["firstName"];
                              final _eventType = eventType(
                                  snapshot.data[index]["event"]["category"]);
                              final _bookedOn =
                                  Jiffy(snapshot.data[index]["date"]["booked"])
                                      .format("MMM do yy"); // Mar 2nd 21
                              return Container(
                                //color: Color.fromARGB(31, 172, 237, 194),
                                width: Get.width,
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                margin:
                                    EdgeInsets.only(top: index == 0 ? 30.0 : 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                          autoPlayInterval: Duration(
                                            seconds: onRandomNumber(3, 9),
                                          ),
                                          height: Get.height * 0.13,
                                          viewportFraction: 1,
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          reverse:
                                              index % 2 == 0 ? true : false,
                                          autoPlayAnimationDuration: Duration(
                                            seconds: onRandomNumber(1, 2),
                                          ),
                                        ),
                                        items: mapImages(),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20.0),
                                      width: Get.width * 0.60,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                decoration: const BoxDecoration(
                                                  color: primary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5.0),
                                                  ),
                                                ),
                                                child: Text(
                                                  "#" +
                                                      _eventType.toUpperCase(),
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                    fontSize: 8.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  _handleCancelBooking(
                                                    ref: _bookRef,
                                                    title: _title,
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "CANCEL",
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.red,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              _title,
                                              style: GoogleFonts.roboto(
                                                color: secondary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17.0,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              "Event by $_eventPlannerName",
                                              style: GoogleFonts.roboto(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              "Booked on $_bookedOn",
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
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ));
  }
}
