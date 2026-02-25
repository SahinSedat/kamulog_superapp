import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';

/// İş ilanı değişiklik bildirimi servisi
/// - İlan kaldırılma, süre bitimi, güncelleme gibi değişiklikleri izler
/// - Favori ilanlardaki değişiklikleri push bildirim olarak gönderir
class JobChangeNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _boxName = 'jobChangeTracking';
  static late Box _trackingBox;

  // ════════════════════════════════════════════
  // KURULUM
  // ════════════════════════════════════════════

  static Future<void> initialize() async {
    // Hive box
    _trackingBox = await Hive.openBox(_boxName);

    // Local notifications plugin kurulumu
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  // ════════════════════════════════════════════
  // İLAN DEĞİŞİKLİK KONTROLÜ
  // ════════════════════════════════════════════

  /// Mevcut ilanları önceki snapshot ile karşılaştırır ve değişiklikleri bildirir
  static Future<void> checkForChanges(List<JobListingModel> currentJobs) async {
    final previousSnapshot = _loadPreviousSnapshot();

    if (previousSnapshot.isNotEmpty) {
      // 1. Kaldırılan ilanlar (öncekinde vardı, şimdikinde yok)
      final currentIds = currentJobs.map((j) => j.id).toSet();
      final removedJobs =
          previousSnapshot.entries
              .where((e) => !currentIds.contains(e.key))
              .toList();

      for (final removed in removedJobs) {
        await _sendNotification(
          title: '📋 İlan Kaldırıldı',
          body: '${removed.value['title']} ilanı artık mevcut değil.',
          id: removed.key.hashCode.abs() % 100000,
        );
      }

      // 2. Süresi yaklaşan ilanlar (son 3 gün)
      for (final job in currentJobs) {
        if (job.deadline != null) {
          final daysLeft = job.deadline!.difference(DateTime.now()).inDays;
          if (daysLeft <= 3 && daysLeft >= 0) {
            final wasNotified = _trackingBox.get('deadline_${job.id}') == true;
            if (!wasNotified) {
              await _sendNotification(
                title: '⏰ İlan Süresi Bitiyor',
                body:
                    '${job.title} ilanının süresi $daysLeft gün içinde sona eriyor!',
                id: (job.id.hashCode.abs() + 50000) % 100000,
              );
              await _trackingBox.put('deadline_${job.id}', true);
            }
          }
        }
      }

      // 3. Yeni eklenen ilanlar
      final previousIds = previousSnapshot.keys.toSet();
      final newJobs =
          currentJobs.where((j) => !previousIds.contains(j.id)).toList();
      if (newJobs.isNotEmpty && newJobs.length <= 5) {
        for (final job in newJobs) {
          await _sendNotification(
            title: '🆕 Yeni İlan',
            body: '${job.title} - ${job.company}',
            id: (job.id.hashCode.abs() + 80000) % 100000,
          );
        }
      }
    }

    // Mevcut snapshot'ı kaydet
    await _saveSnapshot(currentJobs);
  }

  // ════════════════════════════════════════════
  // BİLDİRİM GÖNDERME
  // ════════════════════════════════════════════

  static Future<void> _sendNotification({
    required String title,
    required String body,
    required int id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'job_changes',
      'İlan Değişiklikleri',
      channelDescription: 'İş ilanlarındaki değişiklik bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  // ════════════════════════════════════════════
  // SNAPSHOT YÖNETİMİ
  // ════════════════════════════════════════════

  static Map<String, Map<String, dynamic>> _loadPreviousSnapshot() {
    final raw = _trackingBox.get('jobSnapshot');
    if (raw == null) return {};
    try {
      final decoded = Map<String, dynamic>.from(jsonDecode(raw as String));
      return decoded.map(
        (k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)),
      );
    } catch (_) {
      return {};
    }
  }

  static Future<void> _saveSnapshot(List<JobListingModel> jobs) async {
    final snapshot = <String, Map<String, dynamic>>{};
    for (final job in jobs) {
      snapshot[job.id] = {
        'title': job.title,
        'company': job.company,
        'deadline': job.deadline?.toIso8601String(),
      };
    }
    await _trackingBox.put('jobSnapshot', jsonEncode(snapshot));
  }

  /// Tracking verilerini temizle (test/debug için)
  static Future<void> clearTracking() async {
    await _trackingBox.clear();
  }
}
