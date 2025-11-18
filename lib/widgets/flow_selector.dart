import 'package:flutter/material.dart';

class FlowSelector extends StatelessWidget {
  const FlowSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: const <DropdownMenuItem<String>>[],
      onChanged: (String? value) {},
      hint: const Text('Select Flow'),
    );
  }
}
