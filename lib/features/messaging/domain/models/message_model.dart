import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

/// Mesaj durumu: sent (tek tik), delivered (çift tik), read (mavi çift tik)
enum MessageStatus { sent, delivered, read }

@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String text,
    required String senderId,
    required DateTime timestamp,
    @Default(false) bool isMyMessage,
    @Default(false) bool isSystemMessage,
    @Default(MessageStatus.sent) MessageStatus status,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
