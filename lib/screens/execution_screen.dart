import 'package:flutter/material.dart';
import 'package:ms_sakusei/models/pad_flow_model.dart';
import 'package:ms_sakusei/models/prompt_model.dart';
import 'package:ms_sakusei/services/api_service.dart';
import 'package:ms_sakusei/services/pad_service.dart';

class ExecutionScreen extends StatefulWidget {
  final Prompt prompt;
  final PadFlow padFlow;
  final String input;
  final ApiService apiService;
  final PadService padService;

  const ExecutionScreen({
    super.key,
    required this.prompt,
    required this.padFlow,
    required this.input,
    required this.apiService,
    required this.padService,
  });

  @override
  State<ExecutionScreen> createState() => _ExecutionScreenState();
}

class _ExecutionScreenState extends State<ExecutionScreen> {
  String _openAILog = '';
  String _padLog = '';
  String _finalResult = '';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _executeFlow();
  }

  Future<void> _executeFlow() async {
    try {
      // 1. Call OpenAI API
      setState(() {
        _openAILog = 'Calling OpenAI API...';
      });
      final openAIResponse = await widget.apiService.getOpenAICompletion(
        widget.prompt.prompt,
        widget.input,
      );
      setState(() {
        _openAILog = 'OpenAI API Response: $openAIResponse';
      });

      // 2. Prepare data and call PAD service
      setState(() {
        _padLog = 'Preparing data for PAD flow and executing...';
      });
      // Assuming the OpenAI response is the input for the PAD flow
      final padResponse = await widget.padService.executePadFlow(
        widget.padFlow,
        openAIResponse,
      );
      setState(() {
        _padLog = 'PAD Flow Response: $padResponse';
        _finalResult = padResponse;
      });

      Navigator.pop(context, _finalResult);
    } catch (e) {
      setState(() {
        _hasError = true;
        _finalResult = 'Error: $e';
        _openAILog += '\nError: $e';
        _padLog += '\nError: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Execution Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 16.0),
              Text('Status: Running...', style: Theme.of(context).textTheme.titleMedium),
            ] else if (_hasError) ...[
              Text('Status: Failed', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.red)),
            ] else ...[
              Text('Status: Completed', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.green)),
            ],
            const SizedBox(height: 16.0),
            Text('OpenAI Logs:', style: Theme.of(context).textTheme.titleSmall),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_openAILog),
              ),
            ),
            const SizedBox(height: 16.0),
            Text('PAD Logs:', style: Theme.of(context).textTheme.titleSmall),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_padLog),
              ),
            ),
            const SizedBox(height: 16.0),
            Text('Final Result:', style: Theme.of(context).textTheme.titleSmall),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_finalResult),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
