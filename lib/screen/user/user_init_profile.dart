import 'package:app/const/colors.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/helpers/focusNode.dart';
import 'package:app/helpers/prettyPrint.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/input.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInitializeProfile extends StatefulWidget {
  const UserInitializeProfile({Key? key}) : super(key: key);

  @override
  State<UserInitializeProfile> createState() => _UserInitializeProfileState();
}

class _UserInitializeProfileState extends State<UserInitializeProfile> {
  final ProfileController _profileController = Get.put(ProfileController());

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late MaskedTextController _contactNumberController;

  late FocusNode _firstNameFocus;
  late FocusNode _lastNameFocus;
  late FocusNode _contactNumberFocus;

  bool _hasAgreed = false;
  String _selectedRole = "customer";

  Future<void> handleCreateProfile() async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _contactNumber =
        _contactNumberController.text.trim().replaceAll(r' ', "");

    if (_firstName.isEmpty) {
      return _firstNameFocus.requestFocus();
    }
    if (_lastName.isEmpty) {
      return _lastNameFocus.requestFocus();
    }
    if (_contactNumber.isEmpty) {
      return _contactNumberFocus.requestFocus();
    }

    prettyPrint("handleCreateProfile", {
      "firstName": _firstName,
      "lastName": _lastName,
      "contactNumber": _contactNumber,
      "userType": _selectedRole,
    });

    await _profileController.createProfile(
      firstName: _firstName,
      lastName: _lastName,
      userType: _selectedRole,
      contact: {
        "email": "No Email Provided",
        "number": _contactNumber,
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _contactNumberController = MaskedTextController(mask: '0000 000 0000');

    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _contactNumberFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              children: [
                const Spacer(),
                Center(
                  child: Image.asset(
                    "images/undraw_personal_info_re_ur1n 1.png",
                    height: 150.0,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: Get.width,
                  child: inputTextField(
                    controller: _firstNameController,
                    focusNode: _firstNameFocus,
                    labelText: "Firstname",
                    textFieldStyle: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    hintStyleStyle: GoogleFonts.roboto(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: Get.width,
                  child: inputTextField(
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    labelText: "Lastname",
                    textFieldStyle: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    hintStyleStyle: GoogleFonts.roboto(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: Get.width,
                  child: inputNumberTextField(
                    controller: _contactNumberController,
                    focusNode: _contactNumberFocus,
                    labelText: "Contact Number",
                    textFieldStyle: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    hintStyleStyle: GoogleFonts.roboto(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                CheckboxListTile(
                  value: _hasAgreed,
                  onChanged: (v) {
                    setState(() {
                      _hasAgreed = v as bool;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: DropdownButton(
                    value: _selectedRole,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "I'm a Customer",
                              style: GoogleFonts.roboto(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "View Events, Organizers and Order Booking",
                              style: GoogleFonts.roboto(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        value: 'customer',
                      ),
                      DropdownMenuItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "I'm an Event Planner",
                              style: GoogleFonts.roboto(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "Create Events, View Organizers and Manage Bookings",
                              style: GoogleFonts.roboto(
                                fontSize: 8.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        value: 'event-planner',
                      ),
                      DropdownMenuItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "I'm an Organizer/Supplier",
                              style: GoogleFonts.roboto(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "Attract customers and upload your best images",
                              style: GoogleFonts.roboto(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        value: 'organizer',
                      ),
                    ],
                    onChanged: (v) {
                      setState(() {
                        _selectedRole = v as String;
                      });
                    },
                  ),
                  subtitle: Text(
                    "By clicking Save Changes, I confirm that I have read and agree to the Booking Applications Terms of Service, Privacy Policy, and to receive emails and updates.",
                    style: GoogleFonts.roboto(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38,
                    ),
                  ),
                ),
                const Spacer(flex: 5),
                IgnorePointer(
                  ignoring: _hasAgreed ? false : true,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _hasAgreed ? 1 : 0,
                    child: SizedBox(
                      height: Get.height * 0.06,
                      width: Get.width,
                      child: elevatedButton(
                        backgroundColor: primary,
                        textStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        label: "SAVE CHANGES",
                        action: () => handleCreateProfile(),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
