import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ms_sakusei/models/prompt_model.dart';
import 'package:ms_sakusei/models/pad_flow_model.dart';
import 'package:ms_sakusei/models/config_model.dart';
import 'package:ms_sakusei/services/config_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ConfigService _configService;
  List<Prompt> _prompts = [];
  List<PadFlow> _padFlows = [];
  final TextEditingController _openaiApiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _configService = Provider.of<ConfigService>(context);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prompts = await _configService.loadPrompts();
    _padFlows = await _configService.loadPadFlows();
    final appConfig = await _configService.loadAppConfig();
    _openaiApiKeyController.text = appConfig.openaiApiKey;
    setState(() {});
  }

  Future<void> _saveOpenAIKey() async {
    final currentConfig = await _configService.loadAppConfig();
    final newConfig = AppConfig(openaiApiKey: _openaiApiKeyController.text);
    await _configService.saveAppConfig(newConfig);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OpenAI API Key saved!')),
    );
  }

  // Prompt management methods
  void _addPrompt() async {
    final newPrompt = await _showPromptEditDialog(context);
    if (newPrompt != null) {
      _prompts.add(newPrompt);
      await _configService.savePrompts(_prompts);
      _loadSettings();
    }
  }

  void _editPrompt(Prompt prompt) async {
    final updatedPrompt = await _showPromptEditDialog(context, prompt: prompt);
    if (updatedPrompt != null) {
      setState(() {
        final index = _prompts.indexWhere((p) => p.id == updatedPrompt.id);
        if (index != -1) {
          _prompts[index] = updatedPrompt;
        }
      });
      await _configService.savePrompts(_prompts);
      _loadSettings();
    }
  }

  void _deletePrompt(Prompt prompt) async {
    setState(() {
      _prompts.removeWhere((p) => p.id == prompt.id);
    });
    await _configService.savePrompts(_prompts);
    _loadSettings();
  }

  // PAD Flow management methods
  void _addPadFlow() async {
    final newPadFlow = await _showPadFlowEditDialog(context);
    if (newPadFlow != null) {
      _padFlows.add(newPadFlow);
      await _configService.savePadFlows(_padFlows);
      _loadSettings();
    }
  }

  void _editPadFlow(PadFlow padFlow) async {
    final updatedPadFlow = await _showPadFlowEditDialog(context, padFlow: padFlow);
    if (updatedPadFlow != null) {
      setState(() {
        final index = _padFlows.indexWhere((f) => f.id == updatedPadFlow.id);
        if (index != -1) {
          _padFlows[index] = updatedPadFlow;
        }
      });
      await _configService.savePadFlows(_padFlows);
      _loadSettings();
    }
  }

  void _deletePadFlow(PadFlow padFlow) async {
    setState(() {
      _padFlows.removeWhere((f) => f.id == padFlow.id);
    });
    await _configService.savePadFlows(_padFlows);
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('OpenAI API Key', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8.0),
            TextField(
              controller: _openaiApiKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'API Key',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(onPressed: _saveOpenAIKey, child: const Text('Save API Key')),
            const Divider(height: 32.0),
            Text('Prompts Management', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8.0),
            ..._prompts.map((prompt) => ListTile(
                  title: Text(prompt.name),
                  subtitle: Text(prompt.prompt),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editPrompt(prompt)),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _deletePrompt(prompt)),
                    ],
                  ),
                )),
            ElevatedButton(onPressed: _addPrompt, child: const Text('Add New Prompt')),
            const Divider(height: 32.0),
            Text('PAD Flows Management', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8.0),
            ..._padFlows.map((flow) => ListTile(
                  title: Text(flow.name),
                  subtitle: Text(flow.path),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editPadFlow(flow)),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _deletePadFlow(flow)),
                    ],
                  ),
                )),
            ElevatedButton(onPressed: _addPadFlow, child: const Text('Add New PAD Flow')),
          ],
        ),
      ),
    );
  }

  Future<Prompt?> _showPromptEditDialog(BuildContext context, {Prompt? prompt}) async {
    final idController = TextEditingController(text: prompt?.id ?? DateTime.now().millisecondsSinceEpoch.toString());
    final nameController = TextEditingController(text: prompt?.name);
    final promptTextController = TextEditingController(text: prompt?.prompt);

    return showDialog<Prompt?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(prompt == null ? 'Add New Prompt' : 'Edit Prompt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: idController, decoration: const InputDecoration(labelText: 'ID'), readOnly: true),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: promptTextController, decoration: const InputDecoration(labelText: 'Prompt Text'), maxLines: 5),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && promptTextController.text.isNotEmpty) {
                Navigator.pop(
                  context,
                  Prompt(
                    id: idController.text,
                    name: nameController.text,
                    prompt: promptTextController.text,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<PadFlow?> _showPadFlowEditDialog(BuildContext context, {PadFlow? padFlow}) async {
    final idController = TextEditingController(text: padFlow?.id ?? DateTime.now().millisecondsSinceEpoch.toString());
    final nameController = TextEditingController(text: padFlow?.name);
    final pathController = TextEditingController(text: padFlow?.path);
    final argsController = TextEditingController(text: padFlow?.args);

    return showDialog<PadFlow?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(padFlow == null ? 'Add New PAD Flow' : 'Edit PAD Flow'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: idController, decoration: const InputDecoration(labelText: 'ID'), readOnly: true),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: pathController, decoration: const InputDecoration(labelText: 'Path')),
            TextField(controller: argsController, decoration: const InputDecoration(labelText: 'Arguments')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && pathController.text.isNotEmpty) {
                Navigator.pop(
                  context,
                  PadFlow(
                    id: idController.text,
                    name: nameController.text,
                    path: pathController.text,
                    args: argsController.text,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
