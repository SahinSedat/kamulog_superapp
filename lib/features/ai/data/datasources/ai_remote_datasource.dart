import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kamulog_superapp/core/config/env_config.dart';
import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';

abstract class AiRemoteDataSource {
  /// Send a message and receive a streamed response from OpenAI.
  Stream<String> sendMessage({
    required String conversationId,
    required String message,
    String? context,
    List<AiMessageModel>? history,
  });

  /// Get AI suggestions for a specific context.
  Future<List<String>> getSuggestions(String context);
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  late final Dio _openAiDio;

  static const String _systemPrompt = '''
Sen Kamulog AI Asistan'ısın — Türkiye'deki kamu personeli için geliştirilmiş akıllı bir yapay zeka danışmanısın.

Görevlerin:
• Kamu personeli hakları, mevzuat ve özlük hakları hakkında doğru bilgi vermek
• Kariyer danışmanlığı: CV hazırlama, mülakat ipuçları, kariyer planlaması
• Becayiş (yer değişikliği) süreçleri hakkında rehberlik etmek
• STK (Sivil Toplum Kuruluşları) ve sendika hakları hakkında bilgi vermek
• Güncel mevzuat değişikliklerini açıklamak

Kuralların:
• Türkçe yanıt ver, profesyonel ve samimi ol
• Kısa ve net yanıtlar ver, gereksiz uzatma
• Emin olmadığın konularda "bu konuda güncel bilgiyi resmi kaynaklardan kontrol etmenizi öneririm" de
• Yasal tavsiye verme, genel bilgi sağla
• Kullanıcıyı "siz" olarak hitap et
''';

  AiRemoteDataSourceImpl() {
    _openAiDio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  @override
  Stream<String> sendMessage({
    required String conversationId,
    required String message,
    String? context,
    List<AiMessageModel>? history,
  }) async* {
    final apiKey = EnvConfig.openAiApiKey;
    if (apiKey.isEmpty || apiKey == 'YOUR_OPENAI_API_KEY_HERE') {
      yield 'OpenAI API anahtarı ayarlanmamış. Lütfen .env dosyanıza OPENAI_API_KEY ekleyin.';
      return;
    }

    // Build messages list with context
    final messages = <Map<String, String>>[];

    // System message with context
    String systemMsg = _systemPrompt;
    if (context != null && context.isNotEmpty) {
      systemMsg += '\n\nMevcut bağlam: Kullanıcı "$context" bölümünde.';
    }
    messages.add({'role': 'system', 'content': systemMsg});

    // Add conversation history (last 10 messages for context window)
    if (history != null) {
      final recentHistory =
          history.length > 10 ? history.sublist(history.length - 10) : history;
      for (final msg in recentHistory) {
        if (msg.role == AiRole.system) continue;
        messages.add({'role': msg.role.name, 'content': msg.content});
      }
    }

    // Add current user message
    messages.add({'role': 'user', 'content': message});

    try {
      // Use streaming response
      final response = await _openAiDio.post(
        '/chat/completions',
        data: {
          'model': EnvConfig.openAiModel,
          'messages': messages,
          'stream': true,
          'max_tokens': 1024,
          'temperature': 0.7,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $apiKey'},
          responseType: ResponseType.stream,
        ),
      );

      final stream = response.data.stream as Stream<List<int>>;
      String buffer = '';

      await for (final chunk in stream) {
        buffer += utf8.decode(chunk);

        // Process SSE lines
        while (buffer.contains('\n')) {
          final newlineIndex = buffer.indexOf('\n');
          final line = buffer.substring(0, newlineIndex).trim();
          buffer = buffer.substring(newlineIndex + 1);

          if (line.isEmpty || !line.startsWith('data: ')) continue;

          final data = line.substring(6); // Remove "data: "
          if (data == '[DONE]') return;

          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final choices = json['choices'] as List<dynamic>?;
            if (choices != null && choices.isNotEmpty) {
              final delta = choices[0]['delta'] as Map<String, dynamic>?;
              final content = delta?['content'] as String?;
              if (content != null && content.isNotEmpty) {
                yield content;
              }
            }
          } catch (_) {
            // Skip malformed JSON chunks
          }
        }
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        yield 'API anahtarı geçersiz. Lütfen .env dosyanızdaki OPENAI_API_KEY değerini kontrol edin.';
      } else if (statusCode == 429) {
        yield 'İstek limiti aşıldı. Lütfen biraz bekleyin ve tekrar deneyin.';
      } else if (statusCode == 500 || statusCode == 503) {
        yield 'OpenAI servisi geçici olarak kullanılamıyor. Lütfen daha sonra tekrar deneyin.';
      } else {
        debugPrint('OpenAI error: ${e.message}');
        yield 'Bir hata oluştu. Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.';
      }
    } catch (e) {
      debugPrint('AI error: $e');
      yield 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }

  @override
  Future<List<String>> getSuggestions(String context) async {
    // Return context-specific suggestions immediately (no API call needed)
    return _getDefaultSuggestions(context);
  }

  List<String> _getDefaultSuggestions(String context) {
    switch (context) {
      case 'kariyer':
        return [
          'CV\'mi nasıl geliştirebilirim?',
          'Mülakat hazırlığı için ipuçları',
          'Kamu sektöründe kariyer planlaması',
        ];
      case 'becayis':
        return [
          'Becayiş başvurusu nasıl yapılır?',
          'Hangi kurumlar becayiş kabul ediyor?',
          'Becayiş sürecinde dikkat edilmesi gerekenler',
        ];
      case 'stk':
        return [
          'STK üyelik avantajları nelerdir?',
          'Sendikal haklar hakkında bilgi',
          'Toplu sözleşme süreci nasıl işler?',
        ];
      default:
        return [
          'Bana nasıl yardımcı olabilirsin?',
          'Kamu personeli hakları',
          'Güncel mevzuat değişiklikleri',
        ];
    }
  }
}
