import 'package:app/const/colors.dart';
import 'package:app/screen/customer/customer_cancelled_bookings.dart';
import 'package:app/screen/customer/customer_completed_bookings.dart';
import 'package:app/screen/customer/customer_declined_bookings.dart';
import 'package:app/screen/customer/customer_ongoing_bookings.dart';
import 'package:app/screen/customer/customer_pending_bookings.dart';
import 'package:app/screen/customer/customer_ready_bookings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerBookingsPage extends StatefulWidget {
  const CustomerBookingsPage({Key? key}) : super(key: key);

  @override
  State<CustomerBookingsPage> createState() => _CustomerBookingsPageState();
}

class _CustomerBookingsPageState extends State<CustomerBookingsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final PageController _pageController = PageController();

  void initState() {
    _tabController = TabController(length: 4, vsync: this);
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
          "Bookings",
          style: GoogleFonts.fredokaOne(
            color: secondary.withOpacity(0.8),
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          ),
        ),
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
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (index) {
                  _pageController.jumpToPage(index);

                  print("TAB INDEX $index");
                },
                tabs: [
                  SizedBox(
                    width: Get.width * 0.30,
                    child: const Text(
                      "Pending",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.30,
                    child: const Text(
                      "Ready",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.30,
                    child: const Text(
                      "Completed",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.30,
                    child: const Text(
                      "Declined",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController!.animateTo(index);
          print("PAGE INDEX $index");
        },
        children: const [
          CustomerPendingBookings(),
          CustomerReadyBookings(),
          CustomerCompletedBookings(),
          CustomerDeclinedBookings(),
        ],
      ),
    );
  }
}
