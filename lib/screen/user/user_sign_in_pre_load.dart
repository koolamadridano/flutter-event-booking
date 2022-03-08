import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class UserSignInPreLoad extends StatefulWidget {
  const UserSignInPreLoad({Key? key}) : super(key: key);

  @override
  State<UserSignInPreLoad> createState() => _UserSignInPreLoadState();
}

class _UserSignInPreLoadState extends State<UserSignInPreLoad> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            height: 34.0,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulseSync,
              colors: [Colors.black38],
              strokeWidth: 2,
              backgroundColor: Colors.transparent,
              pathBackgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
