import 'package:app/const/colors.dart';
import 'package:app/controllers/eventController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_indicator/loading_indicator.dart';

class EventPlannerEvents extends StatefulWidget {
  const EventPlannerEvents({Key? key}) : super(key: key);

  @override
  State<EventPlannerEvents> createState() => _EventPlannerEventsState();
}

class _EventPlannerEventsState extends State<EventPlannerEvents> {
  final EventController _eventController = Get.put(EventController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _eventController.getEventsById();
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
        title: Text(
          "My Events",
          style: GoogleFonts.fredokaOne(
            color: secondary.withOpacity(0.8),
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FutureBuilder(
            future: _eventController.getEventsById(),
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
                itemBuilder: (_, index) {
                  final _thumbnail =
                      snapshot.data![index]["event"]["images"][0];

                  final _title = snapshot.data![index]["event"]["title"];
                  final _datePosted =
                      snapshot.data![index]["event"]["postedOn"];

                  final _date =
                      Jiffy(_datePosted).startOf(Units.SECOND).fromNow();

                  return GestureDetector(
                    onTap: () {
                      _eventController.selectedEvent = snapshot.data![index];
                      Get.toNamed("/event-planner-event-preview");
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: snapshot.data![index]["_id"],
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 15.0,
                              left: 10.0,
                              right: 10.0,
                            ),
                            height: Get.height * 0.25,
                            width: Get.width,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(10), // Image border
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(10), // Image radius
                                child: Image.network(
                                  _thumbnail,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 5.0,
                            left: 25.0,
                            right: 25.0,
                          ),
                          child: Text(
                            _title,
                            style: GoogleFonts.roboto(
                              fontSize: 15.0,
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
                            "Posted $_date",
                            style: GoogleFonts.roboto(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  );
                },
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
              );
            }),
      ),
    );
  }
}
