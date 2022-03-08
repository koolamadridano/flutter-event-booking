import 'dart:math';
import 'package:uuid/uuid.dart';

int onRandomNumber(min, max) {
  DateTime now = DateTime.now();
  Random random = Random(now.millisecondsSinceEpoch);
  return min + random.nextInt(max - min);
}

String onRandomId() {
  var uuid = const Uuid();
  // Generate a v4 (random) id
  return uuid.v4().toString(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
}
