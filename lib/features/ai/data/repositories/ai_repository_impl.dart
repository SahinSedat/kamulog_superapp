import 'dart:async';
import 'package:kamulog_superapp/features/ai/data/datasources/ai_remote_datasource.dart';
import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';

class AiRepository {
  final AiRemoteDataSource _remoteDataSource;

  AiRepository({required AiRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  Stream<String> sendMessage({
    required String conversationId,
    required String message,
    String? context,
    List<AiMessageModel>? history,
  }) {
    return _remoteDataSource.sendMessage(
      conversationId: conversationId,
      message: message,
      context: context,
      history: history,
    );
  }

  Future<List<String>> getSuggestions(String context) {
    return _remoteDataSource.getSuggestions(context);
  }
}
