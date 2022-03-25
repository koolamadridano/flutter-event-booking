import 'dart:async';
import 'package:app/const/colors.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/controllers/verificationController.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:app/screen/event-planner/pages/page_event_planner_active_bookings.dart';
import 'package:app/screen/event-planner/pages/page_event_planner_bookings.dart';
import 'package:app/ux/alert_dialogs/verification_success_dialog.dart';
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
  final _profileController = Get.put(ProfileController());
  final _verificationController = Get.put(VerificationController());
  final _userController = Get.put(UserController());
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final PageController _pageController = PageController();
  late bool _isVerified;
  TabController? _tabController;

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
    prettyPrint("EVENT_PLANNER_PROFILE", _profileController.profileData);
    _isVerified = _profileController.profileData["isVerified"];

    _tabController = TabController(length: 2, vsync: this);
    _verificationController.checkVerificationTicket();

    if (!_isVerified && _verificationController.hasTicket.value) {
      Timer.periodic(const Duration(seconds: 5), (Timer t) async {
        await _verificationController.checkVerificationTicket();
        if (!_verificationController.hasPendingTicket.value) {
          t.cancel();
          if (_key.currentState!.isDrawerOpen) {
            Get.back();
          }
          Future.delayed(const Duration(milliseconds: 800), () async {
            dialogVerificationSuccess(context: context);
          });
          Future.delayed(const Duration(seconds: 3), () async {
            await _profileController.getProfile();
            Get.back();
            Get.toNamed("/event-planner-main", preventDuplicates: false);
          });
        }
        print("TICK ${t.tick}");
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
                IconButton(
                  splashRadius: 20.0,
                  onPressed: () => _key.currentState!.openDrawer(),
                  icon: const Icon(
                    Feather.menu,
                    color: secondary,
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
                      _userController.googleAccount["name"],
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
        ));
  }
}
