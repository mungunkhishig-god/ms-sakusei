import 'package:flutter/material.dart';

class ResponseViewer extends StatelessWidget {
  final String responseText;

  const ResponseViewer({
    super.key,
    required this.responseText,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(responseText),
    );
  }
}
