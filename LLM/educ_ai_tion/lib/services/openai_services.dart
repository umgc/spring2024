// OpenAI Service
// 
// Handles all interactions with the OpenAI API. This service is responsible for sending requests to the API to generate questions, 
// process natural language input, or perform any other tasks available through the OpenAI platform, encapsulating the API logic away from the UI.

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A class that provides services for interacting with the OpenAI API.
class OpenAIService {
  final String apiKey = dotenv.env['OPENAI_KEY']!; // Securely load API key

  /// Generates text based on the given prompt using the OpenAI API.
  ///
  /// The [prompt] parameter is the input text to generate text from.
  /// The [modelId] parameter is the ID of the model to use for text generation.
  /// The default value for [modelId] is 'gpt-3.5-turbo'.
  ///
  /// Returns the generated text as a [String].
  ///
  /// Throws an [Exception] if the text generation fails.
  Future<String> generateText(String prompt,
      [String modelId = 'gpt-3.5-turbo']) async {
    var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': modelId,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        // No 'max_tokens' here; adjust parameters as needed for chat models
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['choices'][0]['message']['content']
          .trim(); // Adjusted to match the chat API response structure
    } else {
      print('Failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to generate text from OpenAI');
    }
  }
}



