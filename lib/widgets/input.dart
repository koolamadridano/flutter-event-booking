import 'package:flutter/material.dart';

TextField inputTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
  focusNode,
}) {
  return TextField(
    style: textFieldStyle,
    controller: controller,
    focusNode: focusNode,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      hintStyle: hintStyleStyle,
    ),
  );
}

TextField inputNumberTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
  focusNode,
}) {
  return TextField(
    style: textFieldStyle,
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      hintStyle: hintStyleStyle,
    ),
  );
}

TextField inputTextArea({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
}) {
  return TextField(
    style: textFieldStyle,
    controller: controller,
    maxLines: 3,
    maxLength: 255,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      hintStyle: hintStyleStyle,
    ),
  );
}
