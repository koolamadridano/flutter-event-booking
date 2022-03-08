import 'package:app/const/colors.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:app/screen/event-planner/pages/page_event_planner_active_bookings.dart';
import 'package:app/screen/event-planner/pages/page_event_planner_bookings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class EventPlannerMainScreen extends StatefulWidget {
  const EventPlannerMainScreen({Key? key}) : super(key: key);

  @override
  State<EventPlannerMainScreen> createState() => _EventPlannerMainScreenState();
}

class _EventPlannerMainScreenState extends State<EventPlannerMainScreen>
    with SingleTickerProviderStateMixin {
  final ProfileController _profileController = Get.put(ProfileController());
  final UserController _userController = Get.put(UserController());
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final PageController _pageController = PageController();
  TabController? _tabController;

  int _currentPageIndex = 0;
  String _currentPageTitle = "Open Bookings";

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
    prettyPrint("EVENT_PLANNER_PROFILE", _profileController.profileData);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
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
                  indicatorColor: secondary,
                  indicatorSize: TabBarIndicatorSize.label,
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
              ),
              ListTile(
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
                onTap: () => Get.toNamed("/event-planner-history"),
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
