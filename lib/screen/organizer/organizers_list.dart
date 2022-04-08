import 'package:app/const/colors.dart';
import 'package:app/controllers/organizerController.dart';
import 'package:app/controllers/reportController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class OrganizersListing extends StatefulWidget {
  const OrganizersListing({Key? key}) : super(key: key);

  @override
  State<OrganizersListing> createState() => _OrganizersListingState();
}

class _OrganizersListingState extends State<OrganizersListing> {
  final _organizer = Get.put(OrganizerController());
  final _report = Get.put(ReportController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.white,
        title: Text(
          "Organizers/Suppliers",
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
      ),
      body: FutureBuilder(
        future: _organizer.getOrganizers(),
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

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              final _firstName = snapshot.data[index]["firstName"];
              final _lastName = snapshot.data[index]["lastName"];
              final _dateJoined = snapshot.data[index]["createdAt"];

              return ListTile(
                contentPadding: const EdgeInsets.only(right: 30.0, left: 30.0),
                onTap: () {
                  _report.selectedProfile = snapshot.data[index];
                  _organizer.selectedOrganizer = snapshot.data[index];
                  Get.toNamed("/organizer-listing-preview");
                },
                leading: const Icon(
                  AntDesign.picture,
                  color: secondary,
                ),
                title: Text(
                  _firstName + " " + _lastName,
                  style: GoogleFonts.roboto(
                    color: secondary,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  "Joined ${Jiffy(_dateJoined).startOf(Units.SECOND).fromNow()}",
                  style: GoogleFonts.roboto(
                    color: secondary.withOpacity(0.8),
                    fontSize: 12.0,
                  ),
                ),
              );
            },
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
          );
        },
      ),
    );
  }
}
