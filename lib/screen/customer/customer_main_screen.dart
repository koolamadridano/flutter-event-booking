import 'dart:async';
import 'package:app/const/colors.dart';
import 'package:app/controllers/eventController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/controllers/verificationController.dart';
import 'package:app/helpers/getCategoryBadge.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:app/ux/alert_dialogs/verification_success_dialog.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({Key? key}) : super(key: key);

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _userController = Get.put(UserController());
  final _profileController = Get.put(ProfileController());
  final _verificationController = Get.put(VerificationController());
  final _eventController = Get.put(EventController());

  late bool _isVerified;
  late String _firstName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // DEBUG PRINT
    prettyPrint("PROFILE", _profileController.profileData);

    // INITIALIZE VARIABLES
    _isVerified = _profileController.profileData["isVerified"];
    _firstName = _profileController.profileData["firstName"];

    // METHODS
    initializeVerification();
  }

  Future<void> initializeVerification() async {
    // INITIALIZE VERIFICATION TICKET
    await _verificationController.checkVerificationTicket();

    final _hasVerifiedTicket = _verificationController.hasVerifiedTicket.value;
    final _hasTicket = _verificationController.hasTicket.value;

    // CHECK VERIFICATION TICKET IF DOES EXIST AND NOT YET VERIFIED
    if (!_hasVerifiedTicket && _hasTicket) {
      Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
        if (!_verificationController.hasTicket.value) {
          timer.cancel();
        }
        if (_verificationController.hasVerifiedTicket.value) {
          // END TIMER
          timer.cancel();

          dialogVerificationSuccess(context: context);

          // REFRESH PROFILE
          await _profileController.getProfile();

          Future.delayed(const Duration(seconds: 2), () {
            Get.back();
            // RESET
            _verificationController.hasPendingTicket.value = false;
            //REDIRECT
            Get.toNamed("/customer-main", preventDuplicates: false);
          });
        }
        if (_verificationController.hasPendingTicket.value) {
          // RE-INITIALIZE VERIFICATION TICKET
          await _verificationController.checkVerificationTicket();
        }
        print("TICK #${timer.tick}");
      });
    }
  }

  Future<void> _handleLogout() async {
    await _userController.signOutGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(() => Scaffold(
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
                Badge(
                  showBadge: !_isVerified,
                  badgeContent: Text(
                    '1',
                    style: GoogleFonts.robotoMono(
                      color: Colors.white,
                      fontSize: 8.0,
                    ),
                  ),
                  ignorePointer: true,
                  position: BadgePosition.topEnd(top: 10, end: 5),
                  child: IconButton(
                    splashRadius: 20.0,
                    onPressed: () => _key.currentState!.openDrawer(),
                    icon: const Icon(
                      Feather.menu,
                      color: secondary,
                    ),
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

                      final _category =
                          snapshot.data![index]["event"]["category"];
                      final _date =
                          Jiffy(_datePosted).startOf(Units.SECOND).fromNow();

                      final _from = NumberFormat.currency(name: "PHP").format(
                          int.parse(snapshot.data![index]["event"]["priceRange"]
                              ["from"]));
                      final _to = NumberFormat.currency(name: "PHP").format(
                          int.parse(snapshot.data![index]["event"]["priceRange"]
                              ["to"]));

                      final _priceRange = _from + " to \n" + _to;

                      return GestureDetector(
                        onTap: () {
                          if (!_isVerified &&
                              (_verificationController.hasPendingTicket.value ||
                                  !_verificationController.hasTicket.value)) {
                            _key.currentState!.openDrawer();
                            return;
                          }
                          _eventController.selectedEvent =
                              snapshot.data![index];
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
                                    borderRadius: BorderRadius.circular(
                                        10), // Image border
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          10), // Image radius
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
                                                eventType(_category)
                                                    .toUpperCase(),
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
              child: Column(
                // Important: Remove any padding from the ListView.
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: primary),
                    currentAccountPictureSize: const Size.square(60.0),
                    currentAccountPicture: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: primary,
                      backgroundImage: NetworkImage(
                        _userController.googleAccount["avatar"],
                      ),
                    ),
                    accountEmail: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileController.profileData["isVerified"]
                            ? Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Verified User",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 8.0,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    const Icon(
                                      AntDesign.checkcircle,
                                      color: Colors.white,
                                      size: 8.0,
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Text(
                                  "Not Verified",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 8.0,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10.0),
                        Text(
                          _userController.googleAccount["email"],
                          style: GoogleFonts.roboto(
                            color: Colors.white60,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    accountName: Text(
                      _firstName,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _isVerified
                      ? ListTile(
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
                        )
                      : const SizedBox(),
                  _isVerified
                      ? ListTile(
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
                        )
                      : const SizedBox(),
                  !_verificationController.hasTicket.value
                      ? !_isVerified
                          ? ListTile(
                              onTap: () {
                                Get.toNamed("/ticket-verification");
                              },
                              leading: const Icon(
                                Ionicons.shield_checkmark_outline,
                                color: secondary,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verify My Account',
                                    style: GoogleFonts.roboto(
                                      color: secondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.50,
                                    child: Text(
                                      'Non-verified users has account limitations, please verify your account to continue',
                                      style: GoogleFonts.roboto(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                  _verificationController.hasPendingTicket.value
                      ? !_isVerified
                          ? ListTile(
                              leading: const SizedBox(
                                width: 30.0,
                                height: 30.0,
                                child: CircularProgressIndicator(
                                  color: primary,
                                  strokeWidth: 2.0,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verification in-progress',
                                    style: GoogleFonts.roboto(
                                      color: secondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.50,
                                    child: Text(
                                      'Account Verification are still in progress, please be patient as our admin(s) will do their best to review your ticket',
                                      style: GoogleFonts.roboto(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                  const Spacer(flex: 10),
                  ListTile(
                    leading: const Icon(
                      AntDesign.search1,
                      color: secondary,
                    ),
                    title: Text(
                      'Find Organizers/Supplier',
                      style: GoogleFonts.roboto(
                        color: secondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => Get.toNamed("/organizer-listing"),
                  ),
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
                  const Spacer(),
                ],
              ),
            ),
          )),
    );
  }
}
