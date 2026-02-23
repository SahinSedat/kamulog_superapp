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

  const JobMatchingState({
    required this.conversationId,
    this.isLoading = false,
    this.aiContent = '',
    this.isMatchingStarted = false,
  });

  JobMatchingState copyWith({
    String? conversationId,
    bool? isLoading,
    String? aiContent,
    bool? isMatchingStarted,
  }) {
    return JobMatchingState(
      conversationId: conversationId ?? this.conversationId,
      isLoading: isLoading ?? this.isLoading,
      aiContent: aiContent ?? this.aiContent,
      isMatchingStarted: isMatchingStarted ?? this.isMatchingStarted,
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
            message: 'Sistemdeki mevcut ilanları CV\'mle karşılaştır.',
            context: prompt,
            history: [],
          )
          .listen(
            (chunk) {
              state = state.copyWith(aiContent: state.aiContent + chunk);
            },
            onDone: () {
              state = state.copyWith(isLoading: false);
            },
            onError: (error) {
              state = state.copyWith(
                isLoading: false,
                aiContent:
                aiContent: '\${state.aiContent}\n\n[Hata oluştu: Sunucu yanıt veremiyor]',
              );
            },
          );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        aiContent: '\${state.aiContent}\n\n[Beklenmeyen bir hata oluştu]',
      );
    }
  }

  int? parseScoreForJob(String jobId) {
    if (state.aiContent.isEmpty) return null;
    final lines = state.aiContent.split('\n');
    for (final line in lines) {
      if (line.contains('İLAN#$jobId') || line.contains(jobId)) {
        final match = RegExp(r'%(\d+)').firstMatch(line);
        if (match != null) return int.tryParse(match.group(1)!);
      }
    }
    return null;
  }
}

final jobMatchingProvider =
    NotifierProvider<JobMatchingNotifier, JobMatchingState>(
      () => JobMatchingNotifier(),
    );
