import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SpinKitWave(color: theme.accentColor),
      ),
    );
  }
}
