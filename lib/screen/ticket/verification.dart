import 'dart:io';

import 'package:app/const/colors.dart';
import 'package:app/controllers/verificationController.dart';
import 'package:app/helpers/focusNode.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/input.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _verificationController = Get.put(VerificationController());

  final ImagePicker _picker = ImagePicker();

  String _img1Path = "";
  String _img1Name = "";

  var path;

  Future<void> selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _img1Path = image.path;
        _img1Name = image.name;
      });
    }
  }

  void removeSelectedImage() async {
    setState(() {
      _img1Path = "";
      _img1Name = "";
    });
  }

  Future<void> onSubmitTicket() async {
    if (_img1Path.isEmpty) {
      return selectImage();
    }

    await _verificationController.submitVerificationTicket(
      data: {
        "img": {
          "path": _img1Path,
          "name": _img1Name,
        },
      },
    );
    Get.toNamed(Get.previousRoute);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: WillPopScope(
          onWillPop: () async => true,
          child: Obx(
            () => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                toolbarHeight: 60.0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  splashRadius: 20.0,
                  onPressed: () => Get.toNamed(Get.previousRoute),
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account Verification",
                      style: GoogleFonts.roboto(
                        color: secondary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      "UPLOAD YOUR VALID ID (ANY)",
                      style: GoogleFonts.roboto(
                        color: Colors.black54,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                actions: [
                  _verificationController.verificationImgIsUploading.value
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
              backgroundColor: Colors.white,
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
                                      height: Get.height * 0.30,
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
                                    height: Get.height * 0.30,
                                    width: Get.width,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 25,
                                    right: 30,
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
                                ],
                              ),
                            ),
                    ),
                    const Spacer(flex: 5),
                    IgnorePointer(
                      ignoring: _verificationController
                              .verificationImgIsUploading.value
                          ? true
                          : false,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _verificationController
                                .verificationImgIsUploading.value
                            ? 0
                            : 1,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: 1,
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
                              label: "SUBMIT TICKET",
                              action: () => onSubmitTicket(),
                            ),
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
        ));
  }
}
