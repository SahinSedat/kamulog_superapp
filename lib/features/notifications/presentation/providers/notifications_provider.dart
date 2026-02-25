import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Bildirim durumu — okunma takibi ve badge sayısı
class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final String iconName;
  final int colorValue;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    this.iconName = 'info',
    this.colorValue = 0xFF1565C0,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      timeAgo: timeAgo,
      iconName: iconName,
      colorValue: colorValue,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationsState {
  final List<NotificationItem> notifications;

  const NotificationsState({this.notifications = const []});

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({List<NotificationItem>? notifications}) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  NotificationsNotifier() : super(const NotificationsState()) {
    _loadNotifications();
  }

  void _loadNotifications() {
    // Varsayılan bildirimler + Hive'dan okunma durumu
    final readBox = Hive.box('notifications');
    final readIds = Set<String>.from(
      (readBox.get('readIds', defaultValue: <String>[]) as List).cast<String>(),
    );

    final allNotifications = [
      NotificationItem(
        id: 'notif_1',
        title: 'Becayiş Eşleşmesi!',
        body: 'İstanbul → Ankara becayiş ilanına uygun bir eşleşme bulundu.',
        timeAgo: '5 dk önce',
        iconName: 'swap',
        colorValue: 0xFF2E7D32,
        isRead: readIds.contains('notif_1'),
      ),
      NotificationItem(
        id: 'notif_2',
        title: 'Yeni İş İlanı',
        body: 'Aradığınız kriterlere uygun 3 yeni ilan yayınlandı.',
        timeAgo: '1 saat önce',
        iconName: 'work',
        colorValue: 0xFF1565C0,
        isRead: readIds.contains('notif_2'),
      ),
      NotificationItem(
        id: 'notif_3',
        title: 'AI Analiz Tamamlandı',
        body: 'CV analiziniz tamamlandı. Sonuçları görüntüleyin.',
        timeAgo: '3 saat önce',
        iconName: 'smart_toy',
        colorValue: 0xFF6A1B9A,
        isRead: readIds.contains('notif_3'),
      ),
      NotificationItem(
        id: 'notif_4',
        title: 'Üyelik Hatırlatma',
        body: 'Premium üyeliğinizin süresi 7 gün içinde dolacak.',
        timeAgo: '1 gün önce',
        iconName: 'card',
        colorValue: 0xFFC62828,
        isRead: readIds.contains('notif_4'),
      ),
    ];

    state = state.copyWith(notifications: allNotifications);
  }

  /// Bildirimi okundu olarak işaretle
  Future<void> markAsRead(String id) async {
    final updated =
        state.notifications.map((n) {
          if (n.id == id) return n.copyWith(isRead: true);
          return n;
        }).toList();
    state = state.copyWith(notifications: updated);
    await _saveReadIds();
  }

  /// Tüm bildirimleri okundu olarak işaretle
  Future<void> markAllAsRead() async {
    final updated =
        state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(notifications: updated);
    await _saveReadIds();
  }

  Future<void> _saveReadIds() async {
    final readBox = Hive.box('notifications');
    final readIds =
        state.notifications.where((n) => n.isRead).map((n) => n.id).toList();
    await readBox.put('readIds', readIds);
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>(
      (ref) => NotificationsNotifier(),
    );

/// Okunmamış bildirim sayısı
final unreadNotificationCountProvider = Provider<int>(
  (ref) => ref.watch(notificationsProvider).unreadCount,
);
