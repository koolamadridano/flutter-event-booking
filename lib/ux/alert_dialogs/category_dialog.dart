import 'package:app/const/colors.dart';
import 'package:app/controllers/eventController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> dialogCategory({context, action}) async {
  final List<Map<String, String>> _categories = [
    {"name": "Wedding", "tag": "custom-wedding"},
    {"name": "Disco", "tag": "custom-disco"},
    {"name": "Promenade", "tag": "custom-promenade"},
    {"name": "Fashion Show", "tag": "custom-fashion-show"},
    {"name": "Ball", "tag": "custom-ball"},
    {"name": "Party", "tag": "custom-party"}
  ];
  return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
              width: Get.width * 0.50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Event Category",
                    style: GoogleFonts.fredokaOne(
                      color: secondary,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Text(
                          _categories[index]["name"].toString(),
                          style: GoogleFonts.roboto(
                            color: secondary,
                            fontSize: 14.0,
                          ),
                        ),
                        onTap: () async {
                          final _eventController = Get.put(EventController());
                          final _selectedTag =
                              _categories[index]["tag"].toString();

                          _eventController.createEventSelectedCategory =
                              _selectedTag;

                          await action();
                        },
                      );
                    },
                    itemCount: _categories.length,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
