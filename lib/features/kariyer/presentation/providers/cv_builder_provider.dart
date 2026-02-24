import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';
import 'package:kamulog_superapp/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

/// CV Oluşturucu ekranına özel State sınıfı
class CvBuilderState {
  final String conversationId;
  final List<AiMessageModel> messages;
  final bool isLoading;
  final bool isCvReady;
  final bool isStarted;

  const CvBuilderState({
    required this.conversationId,
    this.messages = const [],
    this.isLoading = false,
    this.isCvReady = false,
    this.isStarted = false,
  });

  CvBuilderState copyWith({
    String? conversationId,
    List<AiMessageModel>? messages,
    bool? isLoading,
    bool? isCvReady,
    bool? isStarted,
  }) {
    return CvBuilderState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isCvReady: isCvReady ?? this.isCvReady,
      isStarted: isStarted ?? this.isStarted,
    );
  }
}

class CvBuilderNotifier extends Notifier<CvBuilderState> {
  late AiRepository _repository;
  StreamSubscription? _streamSub;
  String? _cachedSystemPrompt;

  @override
  CvBuilderState build() {
    _repository = ref.watch(aiRepositoryProvider);
    ref.onDispose(() {
      _streamSub?.cancel();
    });
    return CvBuilderState(conversationId: const Uuid().v4());
  }

  void newConversation() {
    _streamSub?.cancel();
    state = CvBuilderState(conversationId: const Uuid().v4());
  }

  /// Profil bilgilerini kontrol edip mevcut bilgileri topla
  Map<String, String> _getProfileData() {
    final profil = ref.read(profilProvider);
    final data = <String, String>{};

    if (profil.name != null && profil.name!.isNotEmpty) {
      data['Ad Soyad'] = profil.name!;
    }
    if (profil.phone != null && profil.phone!.isNotEmpty) {
      data['Telefon'] = profil.phone!;
    }
    if (profil.tcKimlik != null && profil.tcKimlik!.isNotEmpty) {
      data['TC Kimlik No'] = profil.tcKimlik!;
    }
    if (profil.city != null && profil.city!.isNotEmpty) {
      data['İl'] = profil.city!;
    }
    if (profil.district != null && profil.district!.isNotEmpty) {
      data['İlçe'] = profil.district!;
    }
    if (profil.institution != null && profil.institution!.isNotEmpty) {
      data['Kurum'] = profil.institution!;
    }
    if (profil.title != null && profil.title!.isNotEmpty) {
      data['Unvan'] = profil.title!;
    }
    if (profil.employmentType != null) {
      data['Çalışma Durumu'] = profil.employmentText;
    }

    return data;
  }

  /// CV oluşturma sürecini başlatır — sadece ilk kez veya yeniden başlatmada çağrılır
  Future<void> startCvBuilding() async {
    // Eğer zaten başlamışsa ve mesajlar varsa, kaldığı yerden devam et
    if (state.isStarted && state.messages.isNotEmpty) {
      return;
    }

    final profil = ref.read(profilProvider);
    if (profil.credits < 2) return;

    newConversation();

    final profileData = _getProfileData();

    // Profil bilgilerini doğrudan listeye dönüştür
    final StringBuffer profilBilgi = StringBuffer();
    if (profileData.isNotEmpty) {
      profilBilgi.writeln(
        'ZORUNLU KULLAN — aşağıdaki bilgiler PROFİLDEN alındı, bunları CV\'ye DOĞRUDAN YAZ ve TEKRAR SORMA:',
      );
      for (final entry in profileData.entries) {
        profilBilgi.writeln('  ✓ ${entry.key}: ${entry.value}');
      }
    }

    // Belgelerim'deki mevcut CV içeriklerini de ekle
    final cvDocs =
        profil.documents
            .where((d) => d.category.toLowerCase() == 'cv')
            .toList();
    if (cvDocs.isNotEmpty) {
      profilBilgi.writeln('\nKULLANICININ MEVCUT CV BELGELERİ:');
      for (final doc in cvDocs) {
        if (doc.content != null && doc.content!.isNotEmpty) {
          profilBilgi.writeln('--- ${doc.name} ---');
          profilBilgi.writeln(doc.content!);
        }
      }
    }

    _cachedSystemPrompt =
        'Sen üst düzey profesyonel bir İK uzmanısın ve CV yazarısın. SADECE CV hazırlama konusunda çalışırsın.\n\n'
        '${profilBilgi.toString()}\n\n'
        'KRİTİK KURALLAR:\n'
        '1. Yukarıdaki ✓ ile işaretli bilgileri CV\'de OLDUĞU GİBİ kullan. Bu bilgileri kullanıcıya TEKRAR SORMA.\n'
        '2. SADECE eksik bilgileri sor (eğitim, deneyim, beceriler gibi).\n'
        '3. CV dışı konularda "Üzgünüm, görevim sadece CV hazırlamaktır." de.\n'
        '4. Kullanıcı "tamam" derse CV\'yi oluştur.\n'
        '5. CV hazır olduğunda mesajının EN BAŞINA [CV_HAZIR] etiketini koy.\n\n'
        '═══ CV FORMAT TALİMATI ═══\n'
        'CV\'yi aşağıdaki DÜZENLE yaz (bölüm başlıkları ■ ile işaretli):\n\n'
        '■ KİŞİSEL BİLGİLER\n'
        'Ad Soyad: ...\n'
        'Telefon: ...\n'
        'E-posta: ...\n'
        'Adres: ...\n\n'
        '■ KARİYER HEDEFİ\n'
        '(2-3 cümle profesyonel hedef özeti)\n\n'
        '■ EĞİTİM BİLGİLERİ\n'
        '• Okul — Bölüm (Yıl)\n\n'
        '■ İŞ DENEYİMİ\n'
        '• Pozisyon — Şirket (Tarih aralığı)\n'
        '  Görev ve sorumluluklar\n\n'
        '■ BECERİLER VE YETKİNLİKLER\n'
        '• Teknik: ...\n'
        '• Kişisel: ...\n\n'
        '■ SERTİFİKA VE KURSLAR\n'
        '• Sertifika adı (Kurum, Yıl)\n\n'
        '■ YABANCI DİLLER\n'
        '• Dil — Seviye\n\n'
        '■ REFERANSLAR\n'
        'İstenildiğinde sunulabilir.\n\n'
        '═══════════════════════\n\n'
        '--- PROFESYONELLİK DEĞERLENDİRMESİ ---\n'
        'CV\'nin altına: 🎯 Güçlü Yönler + 💡 Öneriler + ⭐ Puan X/10\n'
        'Bu CV Kamulog AI tarafından oluşturulmuştur.\n\n'
        '6. Kullanıcıdan aldığın YENİ bilgileri (profilde olmayanları) '
        'CV\'nin sonunda [PROFIL_GUNCELLE] etiketi ile belirt.\n'
        'Tüm alanları dahil et: name, phone, tckimlik, city, district, institution, title\n'
        'Örnek: [PROFIL_GUNCELLE]city=Ankara,tckimlik=12345678901,name=Ahmet Yılmaz,phone=5551234567[/PROFIL_GUNCELLE]';

    // İlk mesajı oluştur
    String firstMessage;
    if (profileData.length >= 5) {
      // Profilde yeterli bilgi var — kalan soruları sor
      firstMessage =
          'Merhaba ${profil.name ?? ''}! 👋 Profesyonel CV\'nizi birlikte hazırlayalım.\n\n'
          '✅ Profil bilgilerinizden aşağıdakileri zaten aldım:\n'
          '${profileData.entries.map((e) => '• ${e.key}: ${e.value}').join('\n')}\n\n'
          '📝 **CV\'nizi tamamlamak için şu bilgilere ihtiyacım var:**\n\n'
          '1️⃣ **Eğitim Bilgileri:** Okul adı, bölüm, mezuniyet durumu\n'
          '2️⃣ **Mezuniyet Yılı:** Ne zaman mezun oldunuz?\n'
          '3️⃣ **İş Deneyimi:** Çalıştığınız yerler, pozisyon, süre\n'
          '4️⃣ **Beceriler:** Teknik ve kişisel yetkinlikleriniz\n'
          '5️⃣ **Sertifika/Kurslar:** (varsa)\n'
          '6️⃣ **Yabancı Dil:** (varsa)\n\n'
          'Tüm bilgileri tek mesajda yazabilirsiniz. Eksik bir şey kalırsa hatırlatacağım. ✍️';
    } else {
      // Profilde eksik bilgi çok — tüm soruları sor
      firstMessage =
          'Merhaba${profil.name != null ? ' ${profil.name}' : ''}! 👋 Profesyonel CV\'nizi birlikte hazırlayalım.\n\n'
          'CV\'niz için aşağıdaki bilgilere ihtiyacım var. Lütfen sırasıyla yazın:\n\n'
          '📋 **Gerekli Bilgiler:**\n\n'
          '1️⃣ **Kişisel Bilgiler:** Ad-soyad, e-posta, telefon\n'
          '2️⃣ **Eğitim Bilgileri:** Okul adı, bölüm, mezuniyet durumu\n'
          '3️⃣ **Mezuniyet Yılı:** Hangi yıl mezun oldunuz?\n'
          '4️⃣ **İş Deneyimi:** Çalıştığınız yerler, pozisyon, süre\n'
          '5️⃣ **Beceriler:** Teknik ve kişisel yetkinlikleriniz\n'
          '6️⃣ **Sertifika/Kurslar:** (varsa)\n'
          '7️⃣ **Yabancı Dil:** (varsa)\n\n'
          'Tüm bilgileri tek mesajda veya adım adım yazabilirsiniz. Eksik bir şey olursa hatırlatacağım. ✍️';
    }

    final msgId = const Uuid().v4();
    final systemMessage = AiMessageModel(
      id: msgId,
      conversationId: state.conversationId,
      role: AiRole.assistant,
      content: firstMessage,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(messages: [systemMessage], isStarted: true);
  }

  /// Yeniden başlatma — explicit olarak çağrılır
  Future<void> restartCvBuilding() async {
    newConversation();
    await startCvBuilding();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.isLoading) return;

    final userMsgId = const Uuid().v4();
    final userMessage = AiMessageModel(
      id: userMsgId,
      conversationId: state.conversationId,
      role: AiRole.user,
      content: text.trim(),
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    final aiMsgId = const Uuid().v4();
    final aiMessage = AiMessageModel(
      id: aiMsgId,
      conversationId: state.conversationId,
      role: AiRole.assistant,
      content: '',
      createdAt: DateTime.now(),
      isStreaming: true,
    );

    state = state.copyWith(messages: [...state.messages, aiMessage]);

    try {
      final history =
          state.messages
              .where(
                (m) =>
                    m.id != userMsgId &&
                    m.id != aiMsgId &&
                    m.content.isNotEmpty,
              )
              .toList();

      _streamSub = _repository
          .sendMessage(
            conversationId: state.conversationId,
            message: text.trim(),
            context:
                _cachedSystemPrompt ??
                'Sen profesyonel bir İK uzmanısın. SADECE CV oluşturma konusuna odaklan. Konu dışı sorulara kibarca ret et.',
            history: history,
          )
          .listen(
            (chunk) {
              _updateStreamingMessage(aiMsgId, chunk);
            },
            onDone: () {
              _finishStreamingMessage(aiMsgId);
              state = state.copyWith(isLoading: false);
              _checkCvReady();
              _checkProfileUpdate();
            },
            onError: (error) {
              _updateStreamingMessage(
                aiMsgId,
                '\n\n[Hata oluştu: Sunucu yanıt veremiyor]',
              );
              _finishStreamingMessage(aiMsgId);
              state = state.copyWith(isLoading: false);
            },
          );
    } catch (e) {
      _updateStreamingMessage(aiMsgId, '\n\n[Beklenmeyen bir hata oluştu]');
      _finishStreamingMessage(aiMsgId);
      state = state.copyWith(isLoading: false);
    }
  }

  /// AI mesajlarında [CV_HAZIR] etiketi var mı kontrol et
  void _checkCvReady() {
    for (final msg in state.messages) {
      if (msg.role == AiRole.assistant && msg.content.contains('[CV_HAZIR]')) {
        state = state.copyWith(isCvReady: true);
        return;
      }
    }
  }

  /// AI mesajlarında [PROFIL_GUNCELLE] etiketi var mı kontrol et ve profili güncelle
  void _checkProfileUpdate() {
    for (final msg in state.messages) {
      if (msg.role == AiRole.assistant &&
          msg.content.contains('[PROFIL_GUNCELLE]')) {
        final match = RegExp(
          r'\[PROFIL_GUNCELLE\](.*?)\[/PROFIL_GUNCELLE\]',
        ).firstMatch(msg.content);
        if (match != null) {
          final updates = match.group(1)!;
          final profil = ref.read(profilProvider);
          final notifier = ref.read(profilProvider.notifier);

          // Key=Value pairs parse et
          final pairs = updates.split(',');
          String? city, district, institution, title, tcKimlik, name, phone;

          for (final pair in pairs) {
            final kv = pair.split('=');
            if (kv.length != 2) continue;
            final key = kv[0].trim().toLowerCase();
            final value = kv[1].trim();

            switch (key) {
              case 'city':
                if ((profil.city == null || profil.city!.isEmpty) &&
                    value.isNotEmpty) {
                  city = value;
                }
              case 'district':
                if ((profil.district == null || profil.district!.isEmpty) &&
                    value.isNotEmpty) {
                  district = value;
                }
              case 'institution':
                if ((profil.institution == null ||
                        profil.institution!.isEmpty) &&
                    value.isNotEmpty) {
                  institution = value;
                }
              case 'title':
                if ((profil.title == null || profil.title!.isEmpty) &&
                    value.isNotEmpty) {
                  title = value;
                }
              case 'tckimlik':
                if ((profil.tcKimlik == null || profil.tcKimlik!.isEmpty) &&
                    value.isNotEmpty) {
                  tcKimlik = value;
                }
              case 'name':
                if ((profil.name == null || profil.name!.isEmpty) &&
                    value.isNotEmpty) {
                  name = value;
                }
              case 'phone':
                if ((profil.phone == null || profil.phone!.isEmpty) &&
                    value.isNotEmpty) {
                  phone = value;
                }
            }
          }

          // Tüm bilgileri profilde güncelle
          if (name != null) {
            notifier.updateName(name);
          }
          if (phone != null) {
            notifier.updatePhone(phone);
          }
          if (city != null ||
              district != null ||
              institution != null ||
              title != null ||
              tcKimlik != null) {
            notifier.updatePersonalInfo(
              tcKimlik: tcKimlik ?? profil.tcKimlik,
              city: city ?? profil.city,
              district: district ?? profil.district,
              institution: institution ?? profil.institution,
              title: title ?? profil.title,
            );
          }
        }
      }
    }
  }

  /// CV hazır olduğunda tüm AI mesajlarından CV metnini çıkar
  String extractCvContent() {
    if (state.messages.isEmpty) return '';
    for (final msg in state.messages.reversed) {
      if (msg.role == AiRole.assistant && msg.content.contains('[CV_HAZIR]')) {
        // [CV_HAZIR] ve [PROFIL_GUNCELLE] etiketlerini temizle
        return msg.content
            .replaceAll('[CV_HAZIR]', '')
            .replaceAll(
              RegExp(r'\[PROFIL_GUNCELLE\].*?\[/PROFIL_GUNCELLE\]'),
              '',
            )
            .trim();
      }
    }
    final lastAiMsg = state.messages.lastWhere(
      (m) => m.role == AiRole.assistant,
      orElse: () => state.messages.last,
    );
    return lastAiMsg.content
        .replaceAll('[CV_HAZIR]', '')
        .replaceAll(RegExp(r'\[PROFIL_GUNCELLE\].*?\[/PROFIL_GUNCELLE\]'), '')
        .trim();
  }

  void _updateStreamingMessage(String messageId, String additionalContent) {
    if (additionalContent.isEmpty) return;
    final updatedMessages =
        state.messages.map((m) {
          if (m.id == messageId) {
            return m.copyWith(content: m.content + additionalContent);
          }
          return m;
        }).toList();
    state = state.copyWith(messages: updatedMessages);
  }

  void _finishStreamingMessage(String messageId) {
    final updatedMessages =
        state.messages.map((m) {
          if (m.id == messageId) {
            return m.copyWith(isStreaming: false);
          }
          return m;
        }).toList();
    state = state.copyWith(messages: updatedMessages);
  }
}

final cvBuilderProvider = NotifierProvider<CvBuilderNotifier, CvBuilderState>(
  () => CvBuilderNotifier(),
);
