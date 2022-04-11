import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loader extends StatelessWidget {
  // In the constructor, require a Todo.
  Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
          child: LoadingIndicator(
            indicatorType: Indicator.ballGridBeat,
            colors: [
              NordColors.aurora.purple,
              NordColors.aurora.orange,
              NordColors.aurora.green,
              NordColors.aurora.red,
              NordColors.aurora.yellow
            ],
          ),
        ),
      ),
    );
  }
}
