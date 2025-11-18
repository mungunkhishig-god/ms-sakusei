import 'dart:convert';
import 'dart:io';
import 'package:ms_sakusei/models/prompt_model.dart';
import 'package:ms_sakusei/models/pad_flow_model.dart';
import 'package:ms_sakusei/models/config_model.dart';
import 'package:path_provider/path_provider.dart';

class ConfigService {
  late String _appDocPath;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _appDocPath = directory.path;
  }

  File _getFile(String filename) {
    return File('$_appDocPath/ms_sakusei/data/$filename');
  }

  Future<List<Prompt>> loadPrompts() async {
    final file = _getFile('prompts.json');
    if (!await file.exists()) {
      return [];
    }
    final content = await file.readAsString();
    final List<dynamic> jsonList = json.decode(content);
    return jsonList.map((json) => Prompt.fromJson(json)).toList();
  }

  Future<void> savePrompts(List<Prompt> prompts) async {
    final file = _getFile('prompts.json');
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    final jsonList = prompts.map((prompt) => prompt.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  Future<List<PadFlow>> loadPadFlows() async {
    final file = _getFile('pad_flows.json');
    if (!await file.exists()) {
      return [];
    }
    final content = await file.readAsString();
    final List<dynamic> jsonList = json.decode(content);
    return jsonList.map((json) => PadFlow.fromJson(json)).toList();
  }

  Future<void> savePadFlows(List<PadFlow> padFlows) async {
    final file = _getFile('pad_flows.json');
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    final jsonList = padFlows.map((flow) => flow.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  Future<AppConfig> loadAppConfig() async {
    final file = _getFile('app_config.json');
    if (!await file.exists()) {
      // Return a default config if the file doesn't exist
      return AppConfig(openaiApiKey: '');
    }
    final content = await file.readAsString();
    final Map<String, dynamic> jsonMap = json.decode(content);
    return AppConfig.fromJson(jsonMap);
  }

  Future<void> saveAppConfig(AppConfig config) async {
    final file = _getFile('app_config.json');
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    await file.writeAsString(json.encode(config.toJson()));
  }
}
