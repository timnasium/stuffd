import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

class StuffdButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const StuffdButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Stack(children: <Widget>[
        Positioned.fill(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
          NordColors.frost.lightest,
          NordColors.frost.lighter
        ], stops: [
          0.3,
          0.9
        ])))),
        TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              primary: NordColors.polarNight.darkest,
            ),
            child: Center(child:  Text(text, style: TextStyle(fontSize: 15))))
      ]),
    );
  }
}
