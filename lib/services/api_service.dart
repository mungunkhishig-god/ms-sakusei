import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ms_sakusei/services/config_service.dart';

class ApiService {
  final ConfigService _configService;

  ApiService(this._configService);

  Future<String> getOpenAICompletion(String promptText, String inputText) async {
    final config = await _configService.loadAppConfig();
    final apiKey = config.openaiApiKey;

    if (apiKey.isEmpty || apiKey == "YOUR_OPENAI_API_KEY") {
      throw Exception("OpenAI API key is not configured.");
    }

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo', // Or any other suitable model
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': promptText.replaceFirst('{text}', inputText)},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load OpenAI completion: ${response.body}');
    }
  }
}
