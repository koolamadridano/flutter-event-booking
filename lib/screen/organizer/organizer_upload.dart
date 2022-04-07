import 'dart:ffi';
import 'dart:io';

import 'package:app/const/colors.dart';
import 'package:app/controllers/organizerController.dart';
import 'package:app/helpers/focusNode.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/input.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class OrganizerUpload extends StatefulWidget {
  const OrganizerUpload({Key? key}) : super(key: key);

  @override
  State<OrganizerUpload> createState() => _OrganizerUploadState();
}

class _OrganizerUploadState extends State<OrganizerUpload> {
  final _organizerController = Get.put(OrganizerController());
  final _description = TextEditingController();
  final _descriptionFocus = FocusNode();

  final ImagePicker _picker = ImagePicker();

  String _img1Path = "";
  String _img1Name = "";
  String _selectedCategory = "custom-party";

  final List<Map<String, String>> _categories = [
    {"name": "Wedding", "tag": "custom-wedding"},
    {"name": "Disco", "tag": "custom-disco"},
    {"name": "Promenade", "tag": "custom-promenade"},
    {"name": "Fashion Show", "tag": "custom-fashion-show"},
    {"name": "Ball", "tag": "custom-ball"},
    {"name": "Party", "tag": "custom-party"}
  ];

  Future<void> selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _img1Path = image.path;
        _img1Name = image.name;
      });
    }
  }

  Future<void> onUpload() async {
    if (_img1Path.isEmpty) {
      return selectImage();
    }
    if (_description.text.isEmpty) {
      return _descriptionFocus.requestFocus();
    }
    await _organizerController.uploadImage(
      data: {
        "category": _selectedCategory,
        "description": _description.text.trim(),
        "img": {
          "path": _img1Path,
          "name": _img1Name,
        },
      },
    );
    _organizerController.imgIsUploading.value = false;
    Get.toNamed("/organizer-main");
  }

  void removeSelectedImage() async {
    setState(() {
      _img1Path = "";
      _img1Name = "";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _description.dispose();
    _descriptionFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => destroyTextFieldFocus(context),
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: 60.0,
              backgroundColor: Colors.white,
              title: Text(
                "Upload Photo",
                style: GoogleFonts.roboto(
                  color: secondary,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
              ),
              leading: IconButton(
                splashRadius: 20.0,
                onPressed: () {
                  _organizerController.imgIsUploading.value = false;
                  Get.back();
                },
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
                _organizerController.imgIsUploading.value
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
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: _img1Path == ""
                        ? GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async => await selectImage(),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(15),
                              dashPattern: const [10, 10],
                              color: Colors.black12,
                              strokeWidth: 1.5,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.25,
                                    width: Get.width,
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
                                  height: Get.height * 0.25,
                                  width: Get.width,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 25,
                                  right: 30,
                                  child: IgnorePointer(
                                    ignoring: _organizerController
                                            .imgIsUploading.value
                                        ? true
                                        : false,
                                    child: AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      opacity: _organizerController
                                              .imgIsUploading.value
                                          ? 0
                                          : 1,
                                      child: IconButton(
                                        splashRadius: 20.0,
                                        onPressed: () => removeSelectedImage(),
                                        icon: const Icon(
                                          AntDesign.closecircle,
                                          color: Colors.white,
                                          size: 40.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  const Spacer(),
                  inputTextArea(
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
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10.0,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.only(left: 20.0),
                    child: DropdownButton(
                      value: _selectedCategory,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          10.0,
                        ),
                      ),
                      underline: const SizedBox(),
                      items: _categories
                          .map((element) => DropdownMenuItem(
                                child: Text(
                                  element["name"].toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                  ),
                                ),
                                value: element["tag"],
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedCategory = v as String;
                        });
                      },
                    ),
                  ),
                  const Spacer(flex: 4),
                  IgnorePointer(
                    ignoring: _organizerController.imgIsUploading.value
                        ? true
                        : false,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity:
                          _organizerController.imgIsUploading.value ? 0 : 1,
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
                          label: "UPLOAD IMAGE",
                          action: () => onUpload(),
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
