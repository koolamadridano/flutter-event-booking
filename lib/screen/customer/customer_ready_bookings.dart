import 'package:app/const/colors.dart';
import 'package:app/controllers/bookingsController.dart';
import 'package:app/helpers/random.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomerReadyBookings extends StatefulWidget {
  const CustomerReadyBookings({Key? key}) : super(key: key);

  @override
  State<CustomerReadyBookings> createState() => _CustomerReadyBookingsState();
}

class _CustomerReadyBookingsState extends State<CustomerReadyBookings> {
  final BookingsController _bookingsController = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _bookingsController.getCustomerBookingsById("ready"),
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
              final _location = snapshot.data[index]["event"]["location"];
              final _dateTime = snapshot.data[index]["date"]["event"];

              final _eventPlannerName =
                  snapshot.data[index]["header"]["eventPlanner"]["firstName"];
              final _eventPlannerContact =
                  snapshot.data[index]["header"]["eventPlanner"]["contactNo"];
              final _bookedOn = Jiffy(snapshot.data[index]["date"]["booked"])
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
                margin: EdgeInsets.only(top: index == 0 ? 30.0 : 0),
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
                          reverse: index % 2 == 0 ? true : false,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
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
                            width: Get.width * 0.70,
                            child: Text(
                              _dateTime,
                              style: GoogleFonts.roboto(
                                color: secondary,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  MaterialCommunityIcons.map_marker,
                                  color: secondary,
                                  size: 13.0,
                                ),
                                Container(
                                  width: Get.width * 0.50,
                                  child: Text(
                                    _location,
                                    style: GoogleFonts.roboto(
                                      color: secondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      height: 0.9,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              "$_eventPlannerName, $_eventPlannerContact",
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
    );
  }
}
