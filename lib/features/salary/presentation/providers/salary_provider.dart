import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalaryState {
  final bool isLoading;
  final double? calculatedSalary;
  final String? error;

  // Memur Fields
  final int degree;
  final int step;
  final int serviceYears;

  // İşçi Fields
  final double dailyGrossWage;
  final int workDays;

  SalaryState({
    this.isLoading = false,
    this.calculatedSalary,
    this.error,
    this.degree = 9,
    this.step = 1,
    this.serviceYears = 0,
    this.dailyGrossWage = 0.0,
    this.workDays = 30,
  });

  SalaryState copyWith({
    bool? isLoading,
    double? calculatedSalary,
    String? error,
    int? degree,
    int? step,
    int? serviceYears,
    double? dailyGrossWage,
    int? workDays,
  }) {
    return SalaryState(
      isLoading: isLoading ?? this.isLoading,
      calculatedSalary: calculatedSalary ?? this.calculatedSalary,
      error: error ?? this.error,
      degree: degree ?? this.degree,
      step: step ?? this.step,
      serviceYears: serviceYears ?? this.serviceYears,
      dailyGrossWage: dailyGrossWage ?? this.dailyGrossWage,
      workDays: workDays ?? this.workDays,
    );
  }
}

class SalaryNotifier extends StateNotifier<SalaryState> {
  SalaryNotifier() : super(SalaryState());

  void updateDegree(int degree) {
    state = state.copyWith(degree: degree);
    _calculate();
  }

  void updateStep(int step) {
    state = state.copyWith(step: step);
    _calculate();
  }

  void updateDailyWage(double wage) {
    state = state.copyWith(dailyGrossWage: wage);
    _calculate();
  }

  void updateWorkDays(int days) {
    state = state.copyWith(workDays: days);
    _calculate();
  }

  void updateServiceYears(int years) {
    state = state.copyWith(serviceYears: years);
    _calculate();
  }

  // Placeholder calculation logic
  void _calculate() {
    double salary = 0;
    if (state.dailyGrossWage > 0) {
      // İşçi calculation mock
      salary = state.dailyGrossWage * state.workDays * 0.71; // Net approx
    } else {
      // Memur calculation mock
      salary = 30000 + (9 - state.degree) * 1500 + state.step * 500;
    }

    state = state.copyWith(calculatedSalary: salary);
  }

  void reset() {
    state = SalaryState();
  }
}

final salaryProvider = StateNotifierProvider<SalaryNotifier, SalaryState>((
  ref,
) {
  return SalaryNotifier();
});
