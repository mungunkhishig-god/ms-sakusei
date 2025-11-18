import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ms_sakusei/models/prompt_model.dart';
import 'package:ms_sakusei/models/pad_flow_model.dart';
import 'package:ms_sakusei/services/config_service.dart';
import 'package:ms_sakusei/services/api_service.dart';
import 'package:ms_sakusei/services/pad_service.dart';
import 'package:ms_sakusei/widgets/flow_selector.dart';
import 'package:ms_sakusei/widgets/input_box.dart';
import 'package:ms_sakusei/widgets/response_viewer.dart';
import 'package:ms_sakusei/screens/settings_screen.dart';
import 'package:ms_sakusei/screens/execution_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConfigService _configService;
  late ApiService _apiService;
  late PadService _padService;

  List<Prompt> _prompts = [];
  Prompt? _selectedPrompt;
  List<PadFlow> _padFlows = [];
  PadFlow? _selectedPadFlow;
  final TextEditingController _inputController = TextEditingController();
  String _responseText = "Welcome! Select a prompt and a PAD flow, then provide input to get started.";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _configService = Provider.of<ConfigService>(context);
    _apiService = ApiService(_configService);
    _padService = PadService();
    _loadData(); // Reload data if dependencies change (e.g., after returning from settings)
  }

  Future<void> _loadData() async {
    _prompts = await _configService.loadPrompts();
    _padFlows = await _configService.loadPadFlows();
    setState(() {
      _selectedPrompt = _prompts.isNotEmpty ? _prompts.first : null;
      _selectedPadFlow = _padFlows.isNotEmpty ? _padFlows.first : null;
    });
  }

  void _runFlow() async {
    if (_selectedPrompt == null || _selectedPadFlow == null || _inputController.text.isEmpty) {
      setState(() {
        _responseText = "Please select a prompt, a PAD flow, and provide input.";
      });
      return;
    }

    // Navigate to ExecutionScreen to show progress
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExecutionScreen(
          prompt: _selectedPrompt!,
          padFlow: _selectedPadFlow!,
          input: _inputController.text,
          apiService: _apiService,
          padService: _padService,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _responseText = result;
      });
    } else {
      setState(() {
        _responseText = "Flow execution cancelled or failed.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MS Sakusei'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              _loadData(); // Reload data after returning from settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Prompt:', style: Theme.of(context).textTheme.titleMedium),
            FlowSelector<Prompt>(
              items: _prompts,
              selectedValue: _selectedPrompt,
              hintText: 'Select Prompt',
              itemTextMapper: (prompt) => prompt.name,
              onChanged: (prompt) {
                setState(() {
                  _selectedPrompt = prompt;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Text('Select PAD Flow:', style: Theme.of(context).textTheme.titleMedium),
            FlowSelector<PadFlow>(
              items: _padFlows,
              selectedValue: _selectedPadFlow,
              hintText: 'Select PAD Flow',
              itemTextMapper: (flow) => flow.name,
              onChanged: (flow) {
                setState(() {
                  _selectedPadFlow = flow;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Text('Input:', style: Theme.of(context).textTheme.titleMedium),
            Expanded(
              child: InputBox(
                controller: _inputController,
                labelText: 'Enter your input here...',
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: _runFlow,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Run Flow'),
              ),
            ),
            const SizedBox(height: 16.0),
            Text('Response:', style: Theme.of(context).textTheme.titleMedium),
            Expanded(
              child: ResponseViewer(responseText: _responseText),
            ),
          ],
        ),
      ),
    );
  }
}
