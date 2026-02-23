// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      id: json['id'] as String,
      text: json['text'] as String,
      senderId: json['senderId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isMyMessage: json['isMyMessage'] as bool? ?? false,
      isSystemMessage: json['isSystemMessage'] as bool? ?? false,
      status:
          $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'senderId': instance.senderId,
      'timestamp': instance.timestamp.toIso8601String(),
      'isMyMessage': instance.isMyMessage,
      'isSystemMessage': instance.isSystemMessage,
      'status': _$MessageStatusEnumMap[instance.status]!,
    };

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
};
