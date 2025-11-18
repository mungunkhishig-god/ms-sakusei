import 'dart:io';
import 'dart:async';
import 'package:ms_sakusei/models/pad_flow_model.dart';

class PadService {
  /// Executes a PAD flow (or a mock).
  /// For Windows, this will attempt to run the specified executable or batch file.
  /// For other platforms or if simulation is enabled, it will return mock data after a delay.
  Future<String> executePadFlow(PadFlow flow, String input, {bool simulate = false}) async {
    if (simulate || !Platform.isWindows) {
      // Simulate PAD flow execution
      await Future.delayed(const Duration(seconds: 3));
      return "Mock PAD Flow '${flow.name}' executed with input: '$input'.\nSimulated output.";
    } else {
      // Execute actual PAD flow on Windows
      try {
        final processResult = await Process.run(
          flow.path,
          flow.args.split(' ').map((arg) => arg.replaceFirst('{input}', input)).toList(),
          runInShell: true, // Needed for .bat files
        );

        if (processResult.exitCode == 0) {
          return processResult.stdout as String;
        } else {
          throw Exception('PAD Flow execution failed with exit code ${processResult.exitCode}: ${processResult.stderr}');
        }
      } catch (e) {
        throw Exception('Failed to execute PAD Flow: $e');
      }
    }
  }
}
