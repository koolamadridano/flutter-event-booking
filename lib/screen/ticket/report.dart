import 'package:app/const/colors.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/reportController.dart';
import 'package:app/helpers/focusNode.dart';
import 'package:app/ux/alert_dialogs/report_success_dialog.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final _report = Get.put(ReportController());
  final _profile = Get.put(ProfileController());

  final _description = TextEditingController();
  final _descriptionFocus = FocusNode();

  late dynamic _selectedCategory;
  final List<Map<String, String>> _categories = [
    {
      "name": "Scam/Fake Profile",
      "message":
          "Scammers abuse the anonymity of the internet to mask their true identity and intentions behind various disguises. These can include false profiles, asking any credentials, and other deceptive formats to give the impression of legitimacy."
    },
    {
      "name": "Event Booking Community Standards Violation",
      "message":
          "We want to make sure the content people see on Event Booking is authentic. We believe that authenticity creates a better environment for booking, and that's why we don't want people using Event Booking for fun"
    },
  ];

  Future<void> _handleReport() async {
    final _reason = _description.text.trim();
    final _reportProfile = _report.selectedProfile;
    final _userProfile = _profile.profileData;

    if (_reason.isEmpty) return _descriptionFocus.requestFocus();
    dialogReportSuccess(context: context);
    await _report.reportUser({
      "reportedAccount": {
        "accountId": _reportProfile["accountId"],
        "fullName":
            "${_reportProfile["firstName"]} ${_reportProfile["lastName"]}",
      },
      "reportedBy": {
        "accountId": _userProfile["accountId"],
        "fullName": "${_userProfile["firstName"]} ${_userProfile["lastName"]}",
        "reason": _description.text.trim(),
        "category": _selectedCategory["name"]
      },
      "opened": false
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedCategory = _categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => destroyTextFieldFocus(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 60.0,
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.white,
          // shape: Border(
          //   bottom: BorderSide(color: secondary.withOpacity(0.2), width: 0.5),
          // ),
          title: Text(
            "Report User",
            style: GoogleFonts.fredokaOne(
              color: secondary.withOpacity(0.8),
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                width: double.infinity,
                child: DropdownButton(
                  value: _selectedCategory["name"],
                  items: _categories
                      .map((element) => DropdownMenuItem(
                            child: Text(
                              element["name"].toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            value: element["name"],
                          ))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedCategory = _categories
                          .where((element) => element["name"] == v)
                          .toSet()
                          .elementAt(0);
                    });
                  },
                ),
              ),
              Text(
                _selectedCategory["message"],
                style: GoogleFonts.roboto(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                child: inputTextArea(
                  controller: _description,
                  focusNode: _descriptionFocus,
                  labelText: "Description",
                  textFieldStyle: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                  hintStyleStyle: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
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
                  label: "SUBMIT REPORT",
                  action: () => _handleReport(),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
