import 'package:app/const/colors.dart';
import 'package:app/controllers/messagesController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class MessagesPreview extends StatefulWidget {
  const MessagesPreview({Key? key}) : super(key: key);

  @override
  State<MessagesPreview> createState() => _MessagesPreviewState();
}

class _MessagesPreviewState extends State<MessagesPreview> {
  final _messages = Get.put(MessagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.white,
        // shape: Border(
        //   bottom: BorderSide(color: secondary.withOpacity(0.2), width: 0.5),
        // ),
        leading: IconButton(
          splashRadius: 20.0,
          icon: const Icon(AntDesign.arrowleft),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "ADMIN",
          style: GoogleFonts.fredokaOne(
            color: secondary.withOpacity(0.8),
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _messages.selectedMessage["message"],
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              Jiffy(_messages.selectedMessage["createdAt"]).fromNow(),
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
