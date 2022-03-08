import 'package:app/const/colors.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/helpers/focusNode.dart';
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

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      MaskedTextController(mask: '0000 000 0000');

  bool _isEventPlanner = false;

  Future<void> handleCreateProfile() async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _contactNumber =
        _contactNumberController.text.trim().replaceAll(r' ', "");
    bool _isReady = _firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _contactNumber.isNotEmpty;

    if (_isReady) {
      await _profileController.createProfile(
        firstName: _firstName,
        lastName: _lastName,
        userType: _isEventPlanner ? "event-planner" : "customer",
        contact: {
          "email": "No Email Provided",
          "number": _contactNumber,
        },
      );
    }
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
                    controller: _firstNameController,
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: Get.width,
                  child: inputTextField(
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
                    controller: _lastNameController,
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: Get.width,
                  child: inputNumberTextField(
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
                    controller: _contactNumberController,
                  ),
                ),
                const SizedBox(height: 10.0),
                CheckboxListTile(
                  value: _isEventPlanner,
                  onChanged: (v) {
                    setState(() {
                      _isEventPlanner = v as bool;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    "Join Bookify as Event Planner",
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                  subtitle: Text(
                    "Turning this on will make your profile an \"Event Planner\" permanently.",
                    style: GoogleFonts.roboto(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38,
                    ),
                  ),
                ),
                const Spacer(flex: 5),
                SizedBox(
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
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
