import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Favori ogeleri — kategoriye gore yonetim
/// Veritabani entegrasyonu icin bu sinif uzerinden islenecek
class FavoriteItem {
  final String id;
  final String title;
  final String subtitle;
  final String category; // 'job', 'becayis', 'other'
  final String? routePath; // Yonlendirme rotasi
  final Map<String, dynamic>? extraData; // Ek bilgiler
  final DateTime addedAt;

  const FavoriteItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    this.routePath,
    this.extraData,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'category': category,
    'routePath': routePath,
    'extraData': extraData,
    'addedAt': addedAt.toIso8601String(),
  };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
    id: json['id'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    category: json['category'] as String,
    routePath: json['routePath'] as String?,
    extraData: json['extraData'] as Map<String, dynamic>?,
    addedAt: DateTime.parse(json['addedAt'] as String),
  );
}

class FavoritesNotifier extends StateNotifier<List<FavoriteItem>> {
  static const _storageKey = 'favorites_list';

  FavoritesNotifier() : super([]) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr != null) {
      try {
        final list =
            (jsonDecode(jsonStr) as List)
                .map((e) => FavoriteItem.fromJson(e as Map<String, dynamic>))
                .toList();
        state = list;
      } catch (e) {
        debugPrint('Favori yukleme hatasi: $e');
      }
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  /// Favoriye ekle
  Future<void> addFavorite(FavoriteItem item) async {
    if (state.any((e) => e.id == item.id && e.category == item.category)) {
      return; // Zaten favoride
    }
    state = [...state, item];
    await _saveToStorage();
  }

  /// Favoriden cikar
  Future<void> removeFavorite(String id, String category) async {
    state =
        state.where((e) => !(e.id == id && e.category == category)).toList();
    await _saveToStorage();
  }

  /// Favori mi kontrol et
  bool isFavorite(String id, String category) {
    return state.any((e) => e.id == id && e.category == category);
  }

  /// Kategoriye gore filtrele
  List<FavoriteItem> getByCategory(String category) {
    return state.where((e) => e.category == category).toList();
  }

  /// Favoriyi toggle et
  Future<void> toggleFavorite(FavoriteItem item) async {
    if (isFavorite(item.id, item.category)) {
      await removeFavorite(item.id, item.category);
    } else {
      await addFavorite(item);
    }
  }
}

/// Favori provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<FavoriteItem>>((ref) {
      return FavoritesNotifier();
    });
