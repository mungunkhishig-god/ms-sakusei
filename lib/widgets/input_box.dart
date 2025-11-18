import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  const InputBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Input',
      ),
      maxLines: 5,
    );
  }
}
