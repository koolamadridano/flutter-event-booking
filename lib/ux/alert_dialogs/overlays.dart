import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

Future<dynamic> overlaySpiner(BuildContext context) async {
  return showDialog<dynamic>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => true,
        child: const AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 140),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: LoadingIndicator(
            indicatorType: Indicator.ballRotateChase,
            colors: [Colors.white54],
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.transparent,
          ),
        ),
      );
    },
  );
}
