import 'package:flutter/material.dart';

ElevatedButton elevatedButton({
  required Color backgroundColor,
  required TextStyle textStyle,
  required String label,
  required Function action,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    onPressed: () => action(),
    child: Text(label, style: textStyle),
  );
}
