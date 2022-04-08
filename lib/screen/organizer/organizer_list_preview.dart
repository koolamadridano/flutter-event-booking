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

class _OrganizerListingPreviewState extends State<OrganizerListingPreview>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final _organizerController = Get.put(OrganizerController());

  late String _firstName, _lastName, _contactNo;
  late Future<dynamic> _images;
  late Future<dynamic> _links;

  late String _selectedTab;

  final List<Map<String, dynamic>> _categories = [
    {"index": 0, "name": "Wedding", "tag": "custom-wedding"},
    {"index": 1, "name": "Disco", "tag": "custom-disco"},
    {"index": 2, "name": "Promenade", "tag": "custom-promenade"},
    {"index": 3, "name": "Fashion Show", "tag": "custom-fashion-show"},
    {"index": 4, "name": "Ball", "tag": "custom-ball"},
    {"index": 5, "name": "Party", "tag": "custom-party"}
  ];
  Future<void> _callNumber(number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print(e);
    }
  }

  void _refreshImages() {
    setState(() {
      _images = _organizerController.getImages(
        accountId: _organizerController.selectedOrganizer["accountId"],
        category: _selectedTab,
      );
    });
  }

  void _onTabChange(v) {
    setState(() {
      _selectedTab = v["tag"];
      _images = _organizerController.getImages(
        accountId: _organizerController.selectedOrganizer["accountId"],
        category: v["tag"],
      );
    });
  }

  Future<void> _launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );

    _images = _organizerController.getImages(
      accountId: _organizerController.selectedOrganizer["accountId"],
      category: "custom-wedding",
    );
    _firstName = _organizerController.selectedOrganizer["firstName"];
    _lastName = _organizerController.selectedOrganizer["lastName"];

    _contactNo = _organizerController.selectedOrganizer["contact"]["number"];
    _links = _organizerController.getSelectedOrganizerLinks();
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
                  FontAwesome.phone_square,
                  color: secondary,
                ),
              ),
              IconButton(
                onPressed: () => Get.toNamed("/ticket-report-user"),
                tooltip: "Report",
                splashRadius: 20,
                icon: const Icon(
                  MaterialIcons.report,
                  color: secondary,
                  size: 30,
                ),
              )
            ],
            bottom: PreferredSize(
              child: Column(
                children: [
                  FutureBuilder(
                    future: _links,
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
                  Container(
                    child: _tabController == null
                        ? null
                        : TabBar(
                            controller: _tabController,
                            labelColor: secondary,
                            unselectedLabelColor: Colors.black38,
                            isScrollable: true,
                            labelPadding: const EdgeInsets.only(
                              top: 15.0,
                              bottom: 15.0,
                              left: 15.0,
                              right: 15.0,
                            ),
                            labelStyle: GoogleFonts.roboto(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            indicatorWeight: 1,
                            physics: const ScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            unselectedLabelStyle:
                                GoogleFonts.roboto(fontSize: 11),
                            // indicatorColor: Colors.black38,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.transparent,
                            onTap: (index) {
                              _onTabChange(
                                _categories
                                    .where(
                                        (element) => element["index"] == index)
                                    .toSet()
                                    .elementAt(0),
                              );
                            },

                            tabs: _categories
                                .map((element) => GestureDetector(
                                      child: Text(element["name"].toString()),
                                    ))
                                .toList(),
                          ),
                  )
                ],
              ),
              preferredSize: Size.fromHeight(
                _organizerController.hasLinks.value ? 100 : 50,
              ),
            ),
          ),
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
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed("/organizer-img-preview");
                        _organizerController.selectedOrganizerImg =
                            snapshot.data[index];
                      },
                      child: SizedBox(
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: snapshot.data[index]["_id"],
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(seconds: 1),
                                fadeOutDuration:
                                    const Duration(milliseconds: 500),
                                imageUrl: snapshot.data[index]["url"],
                                height: Get.height * 0.40,
                                width: Get.width,
                                placeholder: (context, url) => Container(
                                  color:
                                      const Color.fromARGB(255, 250, 250, 250),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
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
