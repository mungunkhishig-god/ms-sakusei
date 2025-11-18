import 'package:flutter/material.dart';

class ExecutionScreen extends StatelessWidget {
  const ExecutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Execution Screen')),
      body: const Center(
        child: Text('Execution Screen Content'),
      ),
    );
  }
}
