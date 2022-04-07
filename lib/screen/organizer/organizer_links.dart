import 'package:app/const/colors.dart';
import 'package:app/const/social_icons.dart';
import 'package:app/controllers/organizerController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class OrganizerPostedLinks extends StatefulWidget {
  const OrganizerPostedLinks({Key? key}) : super(key: key);

  @override
  State<OrganizerPostedLinks> createState() => _OrganizerPostedLinksState();
}

class _OrganizerPostedLinksState extends State<OrganizerPostedLinks> {
  final _organizerController = Get.put(OrganizerController());

  late Future<dynamic> _links;

  Future<void> _launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  Future<void> onDeleteLink(id) async {
    await _organizerController.deleteLink(id);
    _refreshLinks();
  }

  void _refreshLinks() {
    setState(() {
      _links = _organizerController.getLinks();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _links = _organizerController.getLinks();
  }

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
        title: Text(
          "My Links",
          style: GoogleFonts.fredokaOne(
            color: secondary.withOpacity(0.8),
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _links,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const LinearProgressIndicator(
              minHeight: 2,
              color: secondary,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              minHeight: 2,
              color: secondary,
            );
          }
          if (snapshot.data == null) {
            return const LinearProgressIndicator(
              minHeight: 2,
              color: secondary,
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length == 0) {
              return const Center(
                child: Icon(
                  MaterialIcons.inbox,
                  color: Colors.black26,
                  size: 82.0,
                ),
              );
            }
          }
          return Container(
            width: Get.width,
            margin: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 5.0,
            ),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _launchURL(
                    snapshot.data[index]["url"],
                  ),
                  onDoubleTap: () => onDeleteLink(
                    snapshot.data[index]["_id"],
                  ),
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 250, 250, 250),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                        right: 15.0,
                        left: 15.0,
                        top: 20.0,
                      ),
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        children: [
                          getIcon(snapshot.data[index]["title"]) as Widget,
                          const SizedBox(width: 5),
                          Text(
                            snapshot.data[index]["title"],
                            style: GoogleFonts.roboto(
                              color: secondary,
                              fontSize: 14.0,
                              height: 1.4,
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
