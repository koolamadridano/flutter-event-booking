import 'package:app/screen/organizer/organizer_img_preview.dart';
import 'package:app/screen/organizer/organizer_links.dart';
import 'package:app/screen/organizer/organizer_list_preview.dart';
import 'package:app/screen/organizer/organizer_main.dart';
import 'package:app/screen/organizer/organizer_social_links.dart';
import 'package:app/screen/organizer/organizer_upload.dart';
import 'package:app/screen/organizer/organizers_list.dart';
import 'package:get/get.dart';

final List<GetPage<dynamic>> routeEventOrganizer = [
  // ORGANIZER
  GetPage(
    name: "/organizer-main",
    page: () => const OrganizerMain(),
  ),
  GetPage(
    name: "/organizer-upload",
    page: () => const OrganizerUpload(),
  ),
  GetPage(
    name: "/organizer-social-links",
    page: () => const OrganizerSocialLinks(),
  ),
  GetPage(
    name: "/organizer-listing",
    page: () => const OrganizersListing(),
  ),
  GetPage(
    name: "/organizer-listing-preview",
    page: () => const OrganizerListingPreview(),
  ),
  GetPage(
    name: "/organizer-posted-links",
    page: () => const OrganizerPostedLinks(),
  ),
  GetPage(
    name: "/organizer-img-preview",
    page: () => const OrganizerImagePreview(),
  ),
];
