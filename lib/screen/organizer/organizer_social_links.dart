import 'package:app/const/colors.dart';
import 'package:app/controllers/organizerController.dart';
import 'package:app/helpers/focusNode.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrganizerSocialLinks extends StatefulWidget {
  const OrganizerSocialLinks({Key? key}) : super(key: key);

  @override
  State<OrganizerSocialLinks> createState() => _OrganizerSocialLinksState();
}

class _OrganizerSocialLinksState extends State<OrganizerSocialLinks> {
  final _organizerController = Get.put(OrganizerController());

  late TextEditingController _titleController;
  late TextEditingController _urlController;
  late FocusNode _titleFocus;
  late FocusNode _urlFocus;
  String _selectedSocial = "Facebook";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _urlController = TextEditingController();
    _titleFocus = FocusNode();
    _urlFocus = FocusNode();
  }

  Future<void> onAddLink() async {
    final _url = _urlController.text;

    if (_url.isEmpty) {
      return _urlFocus.requestFocus();
    }
    await _organizerController.createLink(title: _selectedSocial, url: _url);
    Get.toNamed("/organizer-main");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Obx(
          () => Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 60.0,
              backgroundColor: Colors.white,
              title: Text(
                "Add Social Link",
                style: GoogleFonts.roboto(
                  color: secondary,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
              ),
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

              actions: [
                _organizerController.isCreatingLink.value
                    ? IgnorePointer(
                        ignoring: true,
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {},
                          icon: const SizedBox(
                            height: 25.0,
                            width: 25.0,
                            child: CircularProgressIndicator(
                              color: secondary,
                              strokeWidth: 1.5,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 5,
                      bottom: 5,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: secondary.withOpacity(0.2), width: 0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: DropdownButton(
                      value: _selectedSocial,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                AntDesign.facebook_square,
                                color: secondary,
                                size: 17.0,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Facebook",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: secondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          value: "Facebook",
                        ),
                        DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                AntDesign.github,
                                color: secondary,
                                size: 17.0,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "GitHub",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: secondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          value: "GitHub",
                        ),
                        DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                AntDesign.linkedin_square,
                                color: secondary,
                                size: 17.0,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "LinkedIn",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: secondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          value: "LinkedIn",
                        ),
                        DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                AntDesign.instagram,
                                color: secondary,
                                size: 17.0,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Instagram",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: secondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          value: "Instagram",
                        ),
                        DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                AntDesign.twitter,
                                color: secondary,
                                size: 17.0,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Twitter",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: secondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          value: "Twitter",
                        ),
                        DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                AntDesign.youtube,
                                color: secondary,
                                size: 17.0,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "YouTube",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: secondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          value: "YouTube",
                        ),
                        DropdownMenuItem(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Foundation.web,
                                color: secondary,
                                size: 20.0,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Personal Website",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: secondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          value: "Website",
                        )
                      ],
                      onChanged: (v) {
                        setState(() {
                          _selectedSocial = v as String;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: Get.width,
                    child: inputTextField(
                      controller: _urlController,
                      focusNode: _urlFocus,
                      labelText: "URL",
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
                  const Spacer(flex: 10),
                  IgnorePointer(
                    ignoring: _organizerController.isCreatingLink.value
                        ? true
                        : false,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity:
                          _organizerController.isCreatingLink.value ? 0 : 1,
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
                          label: "ADD LINK",
                          action: () => onAddLink(),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ));
  }
}
