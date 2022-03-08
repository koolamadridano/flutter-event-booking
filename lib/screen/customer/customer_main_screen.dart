import 'package:app/const/colors.dart';
import 'package:app/controllers/eventController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/getCategoryBadge.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({Key? key}) : super(key: key);

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  final UserController _userController = Get.put(UserController());
  final ProfileController _profileController = Get.put(ProfileController());
  final EventController _eventController = Get.put(EventController());

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  _handleLogout() {
    _userController.signOutGoogle();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prettyPrint("CUSTOMER_PROFILE", _profileController.profileData);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _key, // Assign the key to Scaffold.
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 60.0,
          backgroundColor: Colors.white,
          leading: const SizedBox(),
          leadingWidth: 0,
          elevation: 0,
          shadowColor: Colors.white,
          // shape: Border(
          //   bottom: BorderSide(color: secondary.withOpacity(0.2), width: 0.5),
          // ),
          title: Text(
            "Events",
            style: GoogleFonts.fredokaOne(
              color: secondary.withOpacity(0.8),
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          actions: [
            IconButton(
              splashRadius: 20.0,
              onPressed: () => Get.toNamed("/customer-event-bookings"),
              icon: const Icon(
                AntDesign.book,
                size: 22.0,
                color: secondary,
              ),
            ),
            IconButton(
              splashRadius: 20.0,
              onPressed: () => _key.currentState!.openDrawer(),
              icon: const Icon(
                Feather.menu,
                color: secondary,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
            future: _eventController.getEvents(),
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
                  final _thumbnail =
                      snapshot.data![index]["event"]["images"][0];

                  final _title = snapshot.data![index]["event"]["title"];
                  final _datePosted =
                      snapshot.data![index]["event"]["postedOn"];

                  final _firstName =
                      snapshot.data![index]["eventPlanner"]["firstName"];
                  final _lastName =
                      snapshot.data![index]["eventPlanner"]["_lastName"];

                  final _category = snapshot.data![index]["event"]["category"];
                  final _date =
                      Jiffy(_datePosted).startOf(Units.SECOND).fromNow();

                  final _from = NumberFormat.currency(name: "PHP").format(
                      int.parse(snapshot.data![index]["event"]["priceRange"]
                          ["from"]));
                  final _to = NumberFormat.currency(name: "PHP").format(
                      int.parse(
                          snapshot.data![index]["event"]["priceRange"]["to"]));

                  final _priceRange = _from + " to \n" + _to;

                  return GestureDetector(
                    onTap: () {
                      _eventController.selectedEvent = snapshot.data![index];
                      Get.toNamed("/customer-event-preview");
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: index == 0 ? 30.0 : 0.0,
                      ),
                      child: Row(
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
                              height: Get.height * 0.15,
                              width: Get.width * 0.50,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(10), // Image border
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(10), // Image radius
                                  child: Image.network(
                                    _thumbnail,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width * 0.40,
                                margin: const EdgeInsets.only(
                                  top: 15.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: const BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      child: Text(
                                        "#" +
                                            eventType(_category).toUpperCase(),
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 8.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Row(
                                      children: const [
                                        Icon(
                                          AntDesign.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          AntDesign.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          AntDesign.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          AntDesign.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          AntDesign.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          AntDesign.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 5.0,
                                ),
                                width: Get.width * 0.40,
                                child: Text(
                                  "Posted by $_firstName",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                width: Get.width * 0.40,
                                child: Text(
                                  _date,
                                  style: GoogleFonts.roboto(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 5.0,
                                ),
                                width: Get.width * 0.40,
                                child: Text(
                                  _title,
                                  style: GoogleFonts.roboto(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                width: Get.width * 0.40,
                                child: Text(
                                  _priceRange,
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
              );
            }),
        drawer: Drawer(
          backgroundColor: Colors.white,
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: Column(
            // Important: Remove any padding from the ListView.
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: primary,
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: primary,
                  backgroundImage:
                      NetworkImage(_userController.googleAccount["avatar"]),
                ),
                accountEmail: Text(
                  _userController.googleAccount["email"],
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                accountName: Text(
                  _userController.googleAccount["name"],
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  AntDesign.book,
                  color: secondary,
                ),
                title: Text(
                  'My Bookings',
                  style: GoogleFonts.roboto(
                    color: secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Get.toNamed("/customer-event-bookings");
                },
              ),
              ListTile(
                leading: const Icon(
                  Octicons.history,
                  color: secondary,
                ),
                title: Text(
                  'History',
                  style: GoogleFonts.roboto(
                    color: secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Get.toNamed("/customer-messages");
                },
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(
                  AntDesign.logout,
                  color: secondary,
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.roboto(
                    color: secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () => _handleLogout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
