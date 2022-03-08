import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

Future<void> changeStatusBarColor() async {
  await FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
}
