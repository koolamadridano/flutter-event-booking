import 'dart:io';
import 'package:app/const/colors.dart';
import 'package:app/controllers/eventController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/helpers/focusNode.dart';
import 'package:app/ux/alert_dialogs/category_dialog.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/input.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EventPlannerCreateEvent extends StatefulWidget {
  const EventPlannerCreateEvent({Key? key}) : super(key: key);

  @override
  State<EventPlannerCreateEvent> createState() =>
      _EventPlannerCreateEventState();
}

class _EventPlannerCreateEventState extends State<EventPlannerCreateEvent> {
  final ProfileController _profileController = Get.put(ProfileController());
  final EventController _eventController = Get.put(EventController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _moreDetailsController = TextEditingController();
  final TextEditingController _priceFromController = TextEditingController();
  final TextEditingController _priceToController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String _img1Path = "";
  String _img1Name = "";

  String _img2Path = "";
  String _img2Name = "";

  String _img3Path = "";
  String _img3Name = "";

  Future<void> handleCreateEvent() async {
    final _title = _titleController.text.trim();
    final _moreDetails = _moreDetailsController.text.trim();
    final _priceFrom = _priceFromController.text.trim();
    final _priceTo = _priceToController.text.trim();

    List<String> _vars = [
      _img1Path,
      _img2Path,
      _img3Path,
      _title,
      _moreDetails,
      _priceFrom,
      _priceTo
    ];

    Map images = {
      "img1": {
        "path": _img1Path,
        "name": _img1Name,
      },
      "img2": {
        "path": _img2Path,
        "name": _img2Name,
      },
      "img3": {
        "path": _img3Path,
        "name": _img3Name,
      }
    };
    Map data = {
      "eventPlanner": {
        "id": _profileController.profileData["accountId"],
        "firstName": _profileController.profileData["firstName"],
        "lastName": _profileController.profileData["lastName"],
        "contactNo": _profileController.profileData["contact"]["number"],
      },
      "event": {
        "title": _title,
        "moreDetails": _moreDetails,
        "isEventAvailable": true,
        "priceRange": {
          "from": _priceFrom.replaceAll(r',', ""),
          "to": _priceTo.replaceAll(r',', ""),
        },
        "category": "custom-party"
      }
    };

    if (_vars.contains("")) {
      print("Some fields are empty");
      return;
    }
    destroyTextFieldFocus(context);
    dialogCategory(
      context: context,
      action: () => _eventController.createEvent(data, images),
    );
    //  await _eventController.createEvent(data, images);
  }

  Future<void> selectImage({required int index}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (index == 1) {
      if (image != null) {
        setState(() {
          _img1Path = image.path;
          _img1Name = image.name;
        });
      }
      return;
    }
    if (index == 2) {
      if (image != null) {
        setState(() {
          _img2Path = image.path;
          _img2Name = image.name;
        });
      }
      return;
    }
    if (index == 3) {
      if (image != null) {
        setState(() {
          _img3Path = image.path;
          _img3Name = image.name;
        });
      }
      return;
    }
  }

  void removeSelectedImage({required int index}) async {
    _eventController.uploadedIndexes.removeWhere((element) => element == index);
    if (index == 1) {
      setState(() {
        _img1Path = "";
      });
      return;
    }
    if (index == 2) {
      setState(() {
        _img2Path = "";
      });
      return;
    }
    if (index == 3) {
      setState(() {
        _img3Path = "";
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => destroyTextFieldFocus(context),
      child: Obx(() => Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 60.0,
              backgroundColor: Colors.white,
              leading: const SizedBox(),
              leadingWidth: 0,
              elevation: 0,
              shadowColor: Colors.white,
              // shape: Border(
              //   bottom:
              //       BorderSide(color: secondary.withOpacity(0.2), width: 0.5),
              // ),
              title: Text(
                "Create Event",
                style: GoogleFonts.fredokaOne(
                  color: secondary.withOpacity(0.8),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              actions: [
                IconButton(
                  splashRadius: 20.0,
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    AntDesign.close,
                    color: secondary,
                  ),
                ),
              ],
            ),
            body: Container(
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    margin: const EdgeInsets.only(
                      top: 20.0,
                      left: 40.0,
                      bottom: 15.0,
                    ),
                    child: Text(
                      "Venue Photos",
                      style: GoogleFonts.roboto(
                        color: secondary.withOpacity(0.5),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: _img1Path == ""
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async => await selectImage(index: 1),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(15),
                                  dashPattern: const [10, 10],
                                  color: Colors.black12,
                                  strokeWidth: 1.5,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: Get.height * 0.10,
                                        width: Get.width * 0.25,
                                      ),
                                      const Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            AntDesign.plus,
                                            color: Colors.black12,
                                            size: 34.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(15),
                                dashPattern: const [10, 10],
                                color: Colors.transparent,
                                strokeWidth: 1.5,
                                child: Stack(
                                  children: [
                                    Image.file(
                                      File(_img1Path),
                                      height: Get.height * 0.10,
                                      width: Get.width * 0.25,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: IconButton(
                                        splashRadius: 20.0,
                                        onPressed: () =>
                                            removeSelectedImage(index: 1),
                                        icon: const Icon(
                                          AntDesign.closecircle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    _eventController.uploadedIndexes.contains(1)
                                        ? Positioned(
                                            top: 5,
                                            left: 5,
                                            child: IconButton(
                                              splashRadius: 20.0,
                                              onPressed: () {},
                                              icon: const Icon(
                                                AntDesign.checkcircle,
                                                color: Colors.green,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(width: 5),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: _img2Path == ""
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async => await selectImage(index: 2),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(15),
                                  dashPattern: const [10, 10],
                                  color: Colors.black12,
                                  strokeWidth: 1.5,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: Get.height * 0.10,
                                        width: Get.width * 0.25,
                                      ),
                                      const Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            AntDesign.plus,
                                            color: Colors.black12,
                                            size: 34.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(15),
                                dashPattern: const [10, 10],
                                color: Colors.transparent,
                                strokeWidth: 1.5,
                                child: Stack(
                                  children: [
                                    Image.file(
                                      File(_img2Path),
                                      height: Get.height * 0.10,
                                      width: Get.width * 0.25,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: IconButton(
                                        splashRadius: 20.0,
                                        onPressed: () =>
                                            removeSelectedImage(index: 2),
                                        icon: const Icon(
                                          AntDesign.closecircle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    _eventController.uploadedIndexes.contains(2)
                                        ? Positioned(
                                            top: 5,
                                            left: 5,
                                            child: IconButton(
                                              splashRadius: 20.0,
                                              onPressed: () {},
                                              icon: const Icon(
                                                AntDesign.checkcircle,
                                                color: Colors.green,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(width: 5),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: _img3Path == ""
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async => await selectImage(index: 3),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(15),
                                  dashPattern: const [10, 10],
                                  color: Colors.black12,
                                  strokeWidth: 1.5,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: Get.height * 0.10,
                                        width: Get.width * 0.25,
                                      ),
                                      const Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            AntDesign.plus,
                                            color: Colors.black12,
                                            size: 34.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(15),
                                dashPattern: const [10, 10],
                                color: Colors.transparent,
                                strokeWidth: 1.5,
                                child: Stack(
                                  children: [
                                    Image.file(
                                      File(_img3Path),
                                      height: Get.height * 0.10,
                                      width: Get.width * 0.25,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: IconButton(
                                        splashRadius: 20.0,
                                        onPressed: () =>
                                            removeSelectedImage(index: 3),
                                        icon: const Icon(
                                          AntDesign.closecircle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    _eventController.uploadedIndexes.contains(3)
                                        ? Positioned(
                                            top: 5,
                                            left: 5,
                                            child: IconButton(
                                              splashRadius: 20.0,
                                              onPressed: () {},
                                              icon: const Icon(
                                                AntDesign.checkcircle,
                                                color: Colors.green,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                  Container(
                    width: Get.width,
                    margin: const EdgeInsets.only(
                      top: 30.0,
                      left: 40.0,
                      right: 40.0,
                      bottom: 15.0,
                    ),
                    child: Text(
                      "Details",
                      style: GoogleFonts.roboto(
                        color: secondary.withOpacity(0.5),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                    ),
                    child: inputTextField(
                      labelText: "Event title",
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      hintStyleStyle: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                      controller: _titleController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      left: 40.0,
                      right: 40.0,
                    ),
                    child: inputTextArea(
                      labelText: "More Details",
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      hintStyleStyle: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                      controller: _moreDetailsController,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    margin: const EdgeInsets.only(
                      top: 30.0,
                      left: 40.0,
                      right: 40.0,
                      bottom: 15.0,
                    ),
                    child: Text(
                      "Price Range",
                      style: GoogleFonts.roboto(
                        color: secondary.withOpacity(0.5),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width * 0.38,
                          child: inputNumberTextField(
                            labelText: "From",
                            textFieldStyle: GoogleFonts.roboto(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                            hintStyleStyle: GoogleFonts.roboto(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                            controller: _priceFromController,
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: Get.width * 0.38,
                          child: inputNumberTextField(
                            labelText: "To",
                            textFieldStyle: GoogleFonts.roboto(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                            hintStyleStyle: GoogleFonts.roboto(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                            controller: _priceToController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 5),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _eventController.isUploadingImages.value == true
                        ? 0.1
                        : 1,
                    child: Container(
                      height: Get.height * 0.06,
                      width: Get.width,
                      margin: const EdgeInsets.only(
                        top: 50.0,
                        left: 40.0,
                        bottom: 15.0,
                        right: 40.0,
                      ),
                      child: elevatedButton(
                        backgroundColor: primary,
                        textStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        label: "CREATE",
                        action: _eventController.isUploadingImages.value == true
                            ? () {}
                            : () => handleCreateEvent(),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )),
    );
  }
}
