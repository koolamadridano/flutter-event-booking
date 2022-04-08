import 'dart:async';
import 'package:app/const/colors.dart';
import 'package:app/controllers/organizerController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/controllers/verificationController.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:app/ux/alert_dialogs/verification_success_dialog.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrganizerMain extends StatefulWidget {
  const OrganizerMain({Key? key}) : super(key: key);

  @override
  State<OrganizerMain> createState() => _OrganizerMainState();
}

class _OrganizerMainState extends State<OrganizerMain>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _userController = Get.put(UserController());
  final _profileController = Get.put(ProfileController());
  final _verificationController = Get.put(VerificationController());
  final _organizerController = Get.put(OrganizerController());

  late bool _isVerified;
  late String _firstName;
  late String _selectedTab;

  String _deleteId = "";

  late Future<dynamic> _images;

  final List<Map<String, dynamic>> _categories = [
    {"index": 0, "name": "Wedding", "tag": "custom-wedding"},
    {"index": 1, "name": "Disco", "tag": "custom-disco"},
    {"index": 2, "name": "Promenade", "tag": "custom-promenade"},
    {"index": 3, "name": "Fashion Show", "tag": "custom-fashion-show"},
    {"index": 4, "name": "Ball", "tag": "custom-ball"},
    {"index": 5, "name": "Party", "tag": "custom-party"}
  ];

  @override
  void initState() {
    super.initState();

    // DEBUG PRINT
    prettyPrint("ORGANIZER_PROFILE", _profileController.profileData);

    // INITIALIZE VARIABLES
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );

    _isVerified = _profileController.profileData["isVerified"];
    _firstName = _profileController.profileData["firstName"];

    _images = _organizerController.getImages(
      accountId: _profileController.profileData["accountId"],
      category: "custom-wedding",
    );
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
            Get.toNamed("/organizer-main", preventDuplicates: false);
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

  Future<void> onDelete(id, publicId) async {
    await _organizerController.deleteImage(id, publicId);
    _refreshImages();
  }

  void _refreshImages() {
    setState(() {
      _images = _organizerController.getImages(
        accountId: _profileController.profileData["accountId"],
        category: _selectedTab,
      );
    });
  }

  void _onTabChange(v) {
    setState(() {
      _selectedTab = v["tag"];
      _images = _organizerController.getImages(
        accountId: _profileController.profileData["accountId"],
        category: v["tag"],
      );
    });
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
                "Welcome Back, $_firstName",
                style: GoogleFonts.fredokaOne(
                  color: secondary.withOpacity(0.8),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              actions: [
                IconButton(
                  splashRadius: 20.0,
                  onPressed: () => Get.toNamed("/organizer-posted-links"),
                  icon: const Icon(
                    Feather.external_link,
                    color: secondary,
                    size: 23.0,
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
                      labelStyle: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorWeight: 1,
                      physics: const ScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      unselectedLabelStyle: GoogleFonts.roboto(fontSize: 11),
                      // indicatorColor: Colors.black38,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.transparent,
                      onTap: (index) {
                        _onTabChange(
                          _categories
                              .where((element) => element["index"] == index)
                              .toSet()
                              .elementAt(0),
                        );
                      },

                      tabs: _categories
                          .map((element) => GestureDetector(
                                child: Text(element["name"].toString()),
                              ))
                          .toList(),
                    ),
            ),
            body: FutureBuilder(
              future: _images,
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
                return Container(
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 10.0,
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async => _refreshImages(),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed("/organizer-img-preview");
                            _organizerController.selectedOrganizerImg =
                                snapshot.data[index];
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Hero(
                                tag: snapshot.data[index]["_id"],
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(seconds: 1),
                                  fadeOutDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  imageUrl: snapshot.data[index]["url"],
                                  placeholder: (context, url) => Container(
                                    color: const Color.fromARGB(
                                      255,
                                      250,
                                      250,
                                      250,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              _deleteId == snapshot.data[index]["_id"]
                                  ? Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Transform.scale(
                                          scale: 0.6,
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 5,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                _deleteId =
                                                    snapshot.data[index]["_id"];
                                              });
                                              await onDelete(
                                                snapshot.data[index]["_id"],
                                                snapshot.data[index]
                                                    ["publicId"],
                                              );
                                            },
                                            icon: const Icon(
                                              AntDesign.closecircle,
                                              color: Colors.white,
                                              size: 30.0,
                                            )),
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
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
                            Feather.upload,
                            color: secondary,
                          ),
                          title: Text(
                            'Upload Photo',
                            style: GoogleFonts.roboto(
                              color: secondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () {
                            Get.toNamed("/organizer-upload");
                          },
                        )
                      : const SizedBox(),
                  _isVerified
                      ? ListTile(
                          leading: const Icon(
                            Feather.link,
                            color: secondary,
                          ),
                          title: Text(
                            'Social Links',
                            style: GoogleFonts.roboto(
                              color: secondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () {
                            Get.toNamed("/organizer-social-links");
                          },
                        )
                      : const SizedBox(),
                  _isVerified
                      ? ListTile(
                          leading: const Icon(
                            AntDesign.message1,
                            color: secondary,
                          ),
                          title: Text(
                            'Messages',
                            style: GoogleFonts.roboto(
                              color: secondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () {
                            Get.toNamed("/messages");
                          },
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
