import 'package:flutter/material.dart';

class FourOFourPage extends StatelessWidget {
  final String errorText;

  const FourOFourPage({
    Key key,
    this.errorText = 'Generic error. Please improve error handling ;)',
  })  : assert(errorText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(errorText),
      ),
    );
  }
}
