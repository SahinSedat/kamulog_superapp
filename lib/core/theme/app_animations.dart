import 'package:flutter/material.dart';

/// Centralized animation configuration for consistent motion across the app.
/// All durations and curves are defined here to ensure 60fps premium feel.
class AppAnimations {
  AppAnimations._();

  // ── Durations ──
  static const Duration fastest = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 400);

  // ── Curves ──
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve decelerate = Curves.decelerate;
  static const Curve snappy = Curves.easeOutQuart;
  static const Curve gentle = Curves.easeInOutCubic;

  // ── Stagger Delay ──
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Calculate stagger delay for list item at given index
  static Duration staggerFor(int index) {
    return Duration(milliseconds: 50 * index);
  }
}
