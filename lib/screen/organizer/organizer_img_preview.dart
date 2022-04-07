import 'package:app/const/colors.dart';
import 'package:app/controllers/organizerController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrganizerImagePreview extends StatefulWidget {
  const OrganizerImagePreview({Key? key}) : super(key: key);

  @override
  State<OrganizerImagePreview> createState() => _OrganizerImagePreviewState();
}

class _OrganizerImagePreviewState extends State<OrganizerImagePreview> {
  final _organizerController = Get.put(OrganizerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: Get.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: _organizerController.selectedOrganizerImg["_id"],
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                fadeInDuration: const Duration(seconds: 1),
                fadeOutDuration: const Duration(
                  milliseconds: 500,
                ),
                imageUrl: _organizerController.selectedOrganizerImg["url"],
                placeholder: (context, url) => Container(
                  color: const Color.fromARGB(
                    255,
                    250,
                    250,
                    250,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Positioned.fill(
              top: 40.0,
              left: 30.0,
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Ionicons.arrow_back_circle,
                      color: Colors.white,
                      size: 40.0,
                    )),
              ),
            ),
            Positioned.fill(
              left: 30.0,
              right: 30.0,
              bottom: 40.0,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20.0,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _organizerController.selectedOrganizerImg["description"],
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
