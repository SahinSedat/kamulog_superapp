import 'package:flutter/foundation.dart';

enum AiRole { user, assistant, system }

@immutable
class AiMessageModel {
  final String id;
  final String conversationId;
  final AiRole role;
  final String content;
  final int? tokenCount;
  final DateTime createdAt;
  final bool isStreaming;

  const AiMessageModel({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.tokenCount,
    required this.createdAt,
    this.isStreaming = false,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String? ?? '',
      role: AiRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => AiRole.assistant,
      ),
      content: json['content'] as String,
      tokenCount: json['tokenCount'] as int?,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationId': conversationId,
    'role': role.name,
    'content': content,
    'tokenCount': tokenCount,
    'createdAt': createdAt.toIso8601String(),
  };

  AiMessageModel copyWith({
    String? content,
    bool? isStreaming,
    int? tokenCount,
  }) {
    return AiMessageModel(
      id: id,
      conversationId: conversationId,
      role: role,
      content: content ?? this.content,
      tokenCount: tokenCount ?? this.tokenCount,
      createdAt: createdAt,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

@immutable
class AiConversationModel {
  final String id;
  final String? title;
  final List<AiMessageModel> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AiConversationModel({
    required this.id,
    this.title,
    this.messages = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory AiConversationModel.fromJson(Map<String, dynamic> json) {
    return AiConversationModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((m) => AiMessageModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : DateTime.now(),
    );
  }

  String get displayTitle =>
      title ?? 'Sohbet ${createdAt.day}/${createdAt.month}';
}
