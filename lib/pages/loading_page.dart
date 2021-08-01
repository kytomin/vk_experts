import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                color: Colors.blue,
              ))),
    );
  }
}
