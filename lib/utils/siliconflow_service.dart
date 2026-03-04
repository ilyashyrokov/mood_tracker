import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SiliconFlowService {
  static String get _apiKey => dotenv.env['SILICONFLOW_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.siliconflow.com/v1';

  static const String _model = 'MiniMaxAI/MiniMax-M2.5';

  static Future<String> sendMessage(String userMessage, {String? systemPrompt}) async {
    final url = Uri.parse('$_baseUrl/chat/completions');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    List<Map<String, String>> messages = [];

    if (systemPrompt != null) {
      messages.add({
        "role": "system",
        "content": systemPrompt,
      });
    }

    messages.add({
      "role": "user",
      "content": userMessage,
    });

    final body = jsonEncode({
      "model": _model,
      "messages": messages,
      "stream": false,
      "max_tokens": 512,
      "temperature": 0.7,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final assistantMessage = data['choices'][0]['message']['content'];
        return assistantMessage;
      } else {
        print('Ошибка API: ${response.statusCode} - ${response.body}');
        throw Exception('Ошибка при запросе к API: ${response.statusCode}');
      }
    } catch (e) {
      print('Исключение: $e');
      throw Exception('Не удалось связаться с сервером');
    }
  }
}