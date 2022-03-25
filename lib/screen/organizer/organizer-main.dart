import 'package:app/const/colors.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrganizerMain extends StatefulWidget {
  const OrganizerMain({Key? key}) : super(key: key);

  @override
  State<OrganizerMain> createState() => _OrganizerMainState();
}

class _OrganizerMainState extends State<OrganizerMain> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final UserController _userController = Get.put(UserController());
  final ProfileController _profileController = Get.put(ProfileController());

  _handleLogout() {
    _userController.signOutGoogle();
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
            "Feed",
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
        ),
        body: Container(),
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
                  _userController.googleAccount["name"],
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _profileController.profileData["isVerified"]
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
              _profileController.profileData["isVerified"]
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
              ListTile(
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
