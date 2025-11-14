import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:free_dictionary_api_v2/free_dictionary_api_v2.dart';
import 'package:http/http.dart' as http;

// You will need to replace this with your actual API key handling.
// For the context of this environment, we will use a placeholder API key.
const String _apiKey = '';
const String _apiModel = 'gemini-2.5-flash-preview-09-2025';
const String _apiUrlBase =
    'https://generativelanguage.googleapis.com/'
    'v1beta/models/$_apiModel:generateContent';

/// Fetches definitions for a list of words using the Gemini API
/// with Google Search Grounding.
class DefinitionFetcher {
  /// Fetches definitions for multiple words concurrently.
  ///
  /// Returns a Map where the key is the word and the value is its definition.
  Future<Map<String, String?>> fetchDefinitions(List<String> words) async {
    final futures = <Future<MapEntry<String, String?>>>[];

    for (final word in words) {
      futures.add(_fetchSingleDefinition(word));
    }

    // Wait for all definition fetches to complete concurrently
    final results = await Future.wait(futures);

    // Convert the list of MapEntries back into a single Map
    return Map.fromEntries(results);
  }

  /// Fetches a single word's definition with exponential backoff for
  /// resilience.
  // ignore: unused_element
  Future<MapEntry<String, String>> _fetchSingleAIDefinition(
    String word, {
    int attempt = 0,
  }) async {
    final uri = Uri.parse('$_apiUrlBase?key=$_apiKey');

    // System instruction to guide the model's output
    const systemPrompt =
        'You are a concise dictionary assistant. For the given word, '
        'provide a single, brief definition, omitting any '
        "introductory phrase like 'The definition is...'.";
    final userQuery = "What is the primary definition of the word '$word'?";

    final payload = {
      'contents': [
        {
          'parts': [
            {'text': userQuery},
          ],
        },
      ],
      // Use Google Search to ensure grounded, accurate definitions
      'tools': [
        {'google_search': <String, dynamic>{}},
      ],
      'systemInstruction': {
        'parts': [
          {'text': systemPrompt},
        ],
      },
    };

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final candidates = jsonResponse['candidates'] as List?;
        final content =
            (candidates?.first as Map<String, dynamic>)['content']
                as Map<String, dynamic>?;
        final parts = content?['parts'] as List?;
        final definition =
            ((parts?.first as Map<String, dynamic>)['text'] as String?) ??
            'Definition not found.';

        // I'm using a [MapEntry] here because it's easy to merge later
        return MapEntry(word, definition.trim());
      } else if (response.statusCode == 429 && attempt < 5) {
        // Handle Rate Limit (Too Many Requests) with Exponential Backoff
        final delay = pow(2, attempt) * 1000; // 1s, 2s, 4s, 8s, 16s
        await Future<void>.delayed(Duration(milliseconds: delay.toInt()));
        dev.log(
          'Rate limit hit for "$word". '
          'Retrying in ${delay.toInt()}ms...',
          name: 'DefinitionFetcher._fetchSingleAIDefinition',
        );
        return _fetchSingleAIDefinition(word, attempt: attempt + 1);
      } else {
        // Handle other errors (e.g., 400, 500)
        dev.log(
          'API Error for "$word": ${response.statusCode} - ${response.body}',
          name: 'DefinitionFetcher._fetchSingleAIDefinition',
        );
        return MapEntry(word, 'Error fetching definition.');
      }
    } on Exception catch (e, s) {
      // Handle network errors
      dev.log(
        'Network or parsing error for "$word"',
        name: 'DefinitionFetcher._fetchSingleAIDefinition',
        error: e,
        stackTrace: s,
      );
      return MapEntry(word, 'Network error.');
    }
  }

  /// Fetches a single word's definition from the Free Dictionary API.
  ///
  /// Optimization: Single-pass algorithm that prioritizes:
  /// 1. Noun definitions that don't contain the word itself
  /// 2. Other definitions that don't contain the word itself
  /// 3. Any available definition as fallback
  ///
  /// Time Complexity: O(m*d) where m=meanings, d=definitions per meaning
  /// Space Complexity: O(1) - no additional data structures
  Future<MapEntry<String, String?>> _fetchSingleDefinition(String word) async {
    try {
      final dictionary = FreeDictionaryApiV2();
      final responses = await dictionary.getDefinition(word);

      if (responses.isEmpty) {
        return MapEntry(word, null);
      }

      final wordLower = word.toLowerCase();
      String? bestDefinition;
      String? nounDefinitionWithWord;
      String? anyDefinitionWithWord;

      // Single pass through all meanings and definitions
      for (final response in responses) {
        final meanings = response.meanings;
        if (meanings == null || meanings.isEmpty) continue;

        for (final meaning in meanings) {
          final definitions = meaning.definitions;
          if (definitions == null || definitions.isEmpty) continue;

          final isNoun = meaning.partOfSpeech == 'noun';

          for (final definition in definitions) {
            final defText = definition.definition;
            if (defText == null || defText.isEmpty) continue;

            final containsWord = defText.toLowerCase().contains(wordLower);

            // Priority 1: Noun definition without the word
            if (isNoun && !containsWord) {
              return MapEntry(word, defText);
            }

            // Priority 2: Any definition without the word
            if (!containsWord && bestDefinition == null) {
              bestDefinition = defText;
            }

            // Fallback 1: Noun definition (even with word)
            if (isNoun && nounDefinitionWithWord == null) {
              nounDefinitionWithWord = defText;
            }

            // Fallback 2: Any definition
            anyDefinitionWithWord ??= defText;
          }
        }
      }

      // Return best available definition in priority order
      return MapEntry(
        word,
        bestDefinition ?? nounDefinitionWithWord ?? anyDefinitionWithWord,
      );
    } on Exception catch (e, s) {
      dev.log(
        'Error fetching definition for "$word"',
        name: 'DefinitionFetcher._fetchSingleDefinition',
        error: e,
        stackTrace: s,
      );
      return MapEntry(word, null);
    }
  }
}
