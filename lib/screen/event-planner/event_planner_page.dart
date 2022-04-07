import 'dart:async';
import 'package:app/const/colors.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/controllers/verificationController.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:app/screen/event-planner/pages/page_event_planner_active_bookings.dart';
import 'package:app/screen/event-planner/pages/page_event_planner_bookings.dart';
import 'package:app/ux/alert_dialogs/verification_success_dialog.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class EventPlannerMainScreen extends StatefulWidget {
  const EventPlannerMainScreen({Key? key}) : super(key: key);

  @override
  State<EventPlannerMainScreen> createState() => _EventPlannerMainScreenState();
}

class _EventPlannerMainScreenState extends State<EventPlannerMainScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TabController? _tabController;

  final _profileController = Get.put(ProfileController());
  final _verificationController = Get.put(VerificationController());
  final _userController = Get.put(UserController());

  final PageController _pageController = PageController();
  late bool _isVerified;
  late String _firstName;

  int _currentPageIndex = 0;
  String _currentPageTitle = "Open Bookings";

  Timer? timer;

  void _handleLogout() {
    _userController.signOutGoogle();
  }

  void _onPageViewChange(int page) {
    _tabController!.animateTo(page);
    setState(() {
      _currentPageIndex = page;
    });
    switch (page) {
      case 0:
        setState(() {
          _currentPageTitle = "Open Bookings";
        });
        break;
      case 1:
        setState(() {
          _currentPageTitle = "Active Bookings";
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // DEBUG PRINT
    prettyPrint("EVENT_PLANNER_PROFILE", _profileController.profileData);

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
            Get.toNamed("/event-planner-main", preventDuplicates: false);
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

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Obx(
          () => Scaffold(
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
                _currentPageTitle,
                style: GoogleFonts.fredokaOne(
                  color: secondary.withOpacity(0.8),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              actions: [
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
              bottom: _tabController == null
                  ? null
                  : TabBar(
                      controller: _tabController,
                      labelColor: secondary,
                      unselectedLabelColor: Colors.black38,
                      isScrollable: true,
                      labelPadding: const EdgeInsets.only(
                        top: 15.0,
                        bottom: 15.0,
                        left: 15.0,
                        right: 15.0,
                      ),
                      labelStyle: GoogleFonts.roboto(fontSize: 11),
                      indicatorWeight: 1,
                      physics: const ScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      // indicatorColor: Colors.black38,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.black26,
                      onTap: (index) {
                        _pageController.jumpToPage(index);
                        print("TAB INDEX $index");
                      },
                      tabs: [
                        SizedBox(
                          width: Get.width * 0.40,
                          child: const Text(
                            "My Bookings",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.40,
                          child: const Text(
                            "Active Bookings",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: _onPageViewChange,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: const [
                PageEventPlannerBookings(),
                PageEventPlannerActiveBookings(),
              ],
            ),
            drawer: Drawer(
              backgroundColor: Colors.white,
              child: Column(
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
                        _isVerified
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
                            Ionicons.create_outline,
                            color: secondary,
                          ),
                          title: Text(
                            'Create Event',
                            style: GoogleFonts.roboto(
                              color: secondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () => Get.toNamed("/event-planner-create"),
                        )
                      : const SizedBox(),
                  _isVerified
                      ? ListTile(
                          leading: const Icon(
                            AntDesign.calendar,
                            color: secondary,
                          ),
                          title: Text(
                            'My Events',
                            style: GoogleFonts.roboto(
                              color: secondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () => Get.toNamed("/event-planner-events"),
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
                          onTap: () => Get.toNamed("/event-planner-history"),
                        )
                      : const SizedBox(),
                  !_verificationController.hasTicket.value
                      ? !_isVerified
                          ? ListTile(
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
                              onTap: () {
                                Get.toNamed("/ticket-verification");
                              },
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
                      AntDesign.deleteuser,
                      color: secondary,
                    ),
                    title: Text(
                      'Delete Account',
                      style: GoogleFonts.roboto(
                        color: secondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => _profileController.deleteProfile(),
                  ),
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
          ),
        ));
  }
}
