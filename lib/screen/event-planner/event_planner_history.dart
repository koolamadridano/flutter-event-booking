import 'package:app/const/colors.dart';
import 'package:app/controllers/bookingsController.dart';
import 'package:app/helpers/getCategoryBadge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class EventPlannerHistory extends StatefulWidget {
  const EventPlannerHistory({Key? key}) : super(key: key);

  @override
  State<EventPlannerHistory> createState() => _EventPlannerHistoryState();
}

class _EventPlannerHistoryState extends State<EventPlannerHistory> {
  final BookingsController _bookingsController = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          splashRadius: 20.0,
          onPressed: () => Get.toNamed("/event-planner-main"),
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
          "History",
          style: GoogleFonts.fredokaOne(
            color: secondary.withOpacity(0.8),
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [],
      ),
      body: FutureBuilder(
        future: _bookingsController.getEvpBookingsById("completed"),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const LinearProgressIndicator(
              minHeight: 2,
              color: secondary,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              minHeight: 2,
              color: secondary,
            );
          }
          if (snapshot.data == null) {
            return const LinearProgressIndicator(
              minHeight: 2,
              color: secondary,
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
              print(snapshot.data[index]["amountToPay"]);
              final _total = NumberFormat.currency(name: "PHP").format(
                int.parse(snapshot.data[index]["amountToPay"]),
              );
              final _ref = snapshot.data[index]["ref"]
                  .toString()
                  .substring(0, 7)
                  .toUpperCase();

              final _eventPlannerName =
                  snapshot.data[index]["header"]["eventPlanner"]["firstName"];
              final _location = snapshot.data[index]["event"]["location"];
              final _dateTime = snapshot.data[index]["date"]["event"];

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      padding: const EdgeInsets.only(bottom: 20.0),
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: Text(
                              "#$_ref",
                              style: GoogleFonts.roboto(
                                color: secondary,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Container(
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
                            child: Text(
                              _total,
                              style: GoogleFonts.rajdhani(
                                color: secondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
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
