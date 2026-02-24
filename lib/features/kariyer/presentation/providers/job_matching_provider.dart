import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:kamulog_superapp/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';

class JobMatchingState {
  final String conversationId;
  final bool isLoading;
  final String aiContent;
  final bool isMatchingStarted;
  final String searchQuery;

  const JobMatchingState({
    required this.conversationId,
    this.isLoading = false,
    this.aiContent = '',
    this.isMatchingStarted = false,
    this.searchQuery = '',
  });

  JobMatchingState copyWith({
    String? conversationId,
    bool? isLoading,
    String? aiContent,
    bool? isMatchingStarted,
    String? searchQuery,
  }) {
    return JobMatchingState(
      conversationId: conversationId ?? this.conversationId,
      isLoading: isLoading ?? this.isLoading,
      aiContent: aiContent ?? this.aiContent,
      isMatchingStarted: isMatchingStarted ?? this.isMatchingStarted,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class JobMatchingNotifier extends Notifier<JobMatchingState> {
  late AiRepository _repository;
  StreamSubscription? _streamSub;

  @override
  JobMatchingState build() {
    _repository = ref.watch(aiRepositoryProvider);
    ref.onDispose(() {
      _streamSub?.cancel();
    });
    return JobMatchingState(conversationId: const Uuid().v4());
  }

  void newConversation() {
    _streamSub?.cancel();
    state = JobMatchingState(conversationId: const Uuid().v4());
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> startJobMatching(String prompt) async {
    newConversation();

    state = state.copyWith(
      isLoading: true,
      aiContent: '',
      isMatchingStarted: true,
    );

    try {
      _streamSub = _repository
          .sendMessage(
            conversationId: state.conversationId,
            message: prompt,
            context: '',
            history: [],
          )
          .listen(
            (chunk) {
              state = state.copyWith(aiContent: '${state.aiContent}$chunk');
            },
            onDone: () {
              state = state.copyWith(isLoading: false);
            },
            onError: (error) {
              state = state.copyWith(
                isLoading: false,
                aiContent:
                    '${state.aiContent}\n\n[Hata oluştu: Sunucu yanıt veremiyor]',
              );
            },
          );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        aiContent: '${state.aiContent}\n\n[Beklenmeyen bir hata oluştu]',
      );
    }
  }

  /// İş eşleştirme — context ve message ayrı olarak gönderilir
  Future<void> startJobMatchingWithContext(
    String message,
    String dataContext,
  ) async {
    newConversation();

    state = state.copyWith(
      isLoading: true,
      aiContent: '',
      isMatchingStarted: true,
    );

    try {
      _streamSub = _repository
          .sendMessage(
            conversationId: state.conversationId,
            message: message,
            context: dataContext,
            history: [],
          )
          .listen(
            (chunk) {
              state = state.copyWith(aiContent: '${state.aiContent}$chunk');
            },
            onDone: () {
              state = state.copyWith(isLoading: false);
            },
            onError: (error) {
              state = state.copyWith(
                isLoading: false,
                aiContent:
                    '${state.aiContent}\n\n[Hata oluştu: Sunucu yanıt veremiyor]',
              );
            },
          );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        aiContent: '${state.aiContent}\n\n[Beklenmeyen bir hata oluştu]',
      );
    }
  }

  /// İlan ID'sine göre genel uyumluluk puanını parse et
  int? parseScoreForJob(String jobId) {
    if (state.aiContent.isEmpty) return null;
    final lines = state.aiContent.split('\n');
    for (final line in lines) {
      if (line.contains('İLAN#$jobId') || line.contains(jobId)) {
        // Genel skor: ilk %XX değeri
        final match = RegExp(r'%(\d+)').firstMatch(line);
        if (match != null) return int.tryParse(match.group(1)!);
      }
    }
    return null;
  }

  /// İlan tipi parse et: UYGUN veya ALTERNATİF
  String? parseTypeForJob(String jobId) {
    if (state.aiContent.isEmpty) return null;
    final lines = state.aiContent.split('\n');
    for (final line in lines) {
      if (line.contains('İLAN#$jobId') || line.contains(jobId)) {
        if (line.contains('ALTERNATİF')) return 'ALTERNATİF';
        if (line.contains('UYGUN')) return 'UYGUN';
      }
    }
    return null;
  }

  /// Alt kategori puanlarını parse et (EĞİTİM, DENEYİM, BECERİ, UYUM)
  Map<String, int>? parseSubScoresForJob(String jobId) {
    if (state.aiContent.isEmpty) return null;
    final lines = state.aiContent.split('\n');

    // İlan ID'sini içeren satırın bir sonraki satırında alt skorlar
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('İLAN#$jobId') || lines[i].contains(jobId)) {
        // Aynı satırda veya bir sonraki satırda alt skorları ara
        final searchLines = [lines[i], if (i + 1 < lines.length) lines[i + 1]];

        for (final line in searchLines) {
          final egitimMatch = RegExp(r'EĞİTİM:%(\d+)').firstMatch(line);
          final deneyimMatch = RegExp(r'DENEYİM:%(\d+)').firstMatch(line);
          final beceriMatch = RegExp(r'BECERİ:%(\d+)').firstMatch(line);
          final uyumMatch = RegExp(r'UYUM:%(\d+)').firstMatch(line);

          if (egitimMatch != null ||
              deneyimMatch != null ||
              beceriMatch != null ||
              uyumMatch != null) {
            return {
              'egitim': int.tryParse(egitimMatch?.group(1) ?? '0') ?? 0,
              'deneyim': int.tryParse(deneyimMatch?.group(1) ?? '0') ?? 0,
              'beceri': int.tryParse(beceriMatch?.group(1) ?? '0') ?? 0,
              'uyum': int.tryParse(uyumMatch?.group(1) ?? '0') ?? 0,
            };
          }
        }
      }
    }
    return null;
  }
}

final jobMatchingProvider =
    NotifierProvider<JobMatchingNotifier, JobMatchingState>(
      () => JobMatchingNotifier(),
    );
