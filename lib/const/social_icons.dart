import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

Icon? getIcon(title) {
  if (title == "Facebook") {
    return const Icon(
      AntDesign.facebook_square,
      color: secondary,
      size: 17.0,
    );
  }
  if (title == "YouTube") {
    return const Icon(
      AntDesign.youtube,
      color: secondary,
      size: 17.0,
    );
  }
  if (title == "GitHub") {
    return const Icon(
      AntDesign.github,
      color: secondary,
      size: 17.0,
    );
  }
  if (title == "LinkedIn") {
    return const Icon(
      AntDesign.linkedin_square,
      color: secondary,
      size: 17.0,
    );
  }
  if (title == "Instagram") {
    return const Icon(
      AntDesign.instagram,
      color: secondary,
      size: 17.0,
    );
  }
  if (title == "Twitter") {
    return const Icon(
      AntDesign.twitter,
      color: secondary,
      size: 17.0,
    );
  }
  if (title == "Website") {
    return const Icon(
      Foundation.web,
      color: secondary,
      size: 17.0,
    );
  }
  return const Icon(
    Feather.link,
    color: secondary,
    size: 17.0,
  );
}
