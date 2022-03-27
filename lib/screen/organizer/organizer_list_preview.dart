import 'package:app/const/colors.dart';
import 'package:app/const/social_icons.dart';
import 'package:app/controllers/organizerController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

class OrganizerListingPreview extends StatefulWidget {
  const OrganizerListingPreview({Key? key}) : super(key: key);

  @override
  State<OrganizerListingPreview> createState() =>
      _OrganizerListingPreviewState();
}

class _OrganizerListingPreviewState extends State<OrganizerListingPreview> {
  final _organizerController = Get.put(OrganizerController());

  late String _firstName, _lastName, _contactNo;
  late Future<dynamic> _images;

  Future<void> _callNumber(number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print(e);
    }
  }

  void _refreshImages() {
    setState(() {
      _images = _organizerController.getSelectedOrganizerPhotos();
    });
  }

  Future<void> _launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstName = _organizerController.selectedOrganizer["firstName"];
    _lastName = _organizerController.selectedOrganizer["lastName"];

    _contactNo = _organizerController.selectedOrganizer["contact"]["number"];
    _images = _organizerController.getSelectedOrganizerPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              toolbarHeight: 60.0,
              backgroundColor: Colors.white,
              title: Text(
                _firstName + "'s Profile",
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
                IconButton(
                  onPressed: () async => await _callNumber(_contactNo),
                  tooltip: "Call",
                  splashRadius: 20,
                  icon: const Icon(
                    AntDesign.phone,
                    color: secondary,
                  ),
                )
              ],
              bottom: PreferredSize(
                child: FutureBuilder(
                  future: _organizerController.getSelectedOrganizerLinks(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return const SizedBox();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data.length == 0) {
                        return const SizedBox();
                      }
                    }
                    return Container(
                      width: Get.width,
                      height: Get.height * 0.06,
                      margin: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        bottom: 5.0,
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _launchURL(
                              snapshot.data[index]["url"],
                            ),
                            child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 250, 250, 250),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                margin: const EdgeInsets.only(right: 10.0),
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    getIcon(snapshot.data[index]["title"])
                                        as Widget,
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
                preferredSize: Size.fromHeight(
                  _organizerController.hasLinks.value ? 60 : 0,
                ),
              )),
          body: FutureBuilder(
            future: _images,
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
              return RefreshIndicator(
                onRefresh: () async => _refreshImages(),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    return SizedBox(
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(seconds: 1),
                            fadeOutDuration: const Duration(milliseconds: 500),
                            imageUrl: snapshot.data[index]["url"],
                            height: Get.height * 0.40,
                            width: Get.width,
                            placeholder: (context, url) => Container(
                              color: const Color.fromARGB(255, 250, 250, 250),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              top: 20.0,
                            ),
                            child: Text(
                              _firstName,
                              style: GoogleFonts.roboto(
                                color: secondary,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              bottom: 20.0,
                            ),
                            child: Text(
                              Jiffy(snapshot.data[index]["createdAt"])
                                  .startOf(Units.SECOND)
                                  .fromNow(),
                              style: GoogleFonts.roboto(
                                color: secondary.withOpacity(0.8),
                                fontSize: 12.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ));
  }
}
