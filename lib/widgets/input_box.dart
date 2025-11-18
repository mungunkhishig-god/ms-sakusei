import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines;

  const InputBox({
    super.key,
    required this.controller,
    this.labelText = 'Input',
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      maxLines: maxLines,
    );
  }
}
