import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/features/salary/presentation/providers/salary_provider.dart';

class SalaryCalculatorScreen extends ConsumerStatefulWidget {
  const SalaryCalculatorScreen({super.key});

  @override
  ConsumerState<SalaryCalculatorScreen> createState() =>
      _SalaryCalculatorScreenState();
}

class _SalaryCalculatorScreenState
    extends ConsumerState<SalaryCalculatorScreen> {
  final _dailyWageController = TextEditingController();

  @override
  void dispose() {
    _dailyWageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final salaryState = ref.watch(salaryProvider);
    final isWorker = user?.employmentType == EmploymentType.kamuIsci;

    return Scaffold(
      appBar: AppBar(title: const Text('Maaş Hesaplama')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isWorker ? Icons.engineering : Icons.account_balance,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isWorker ? 'Kamu İşçisi (4D)' : 'Devlet Memuru',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Maaş Hesaplama Modülü',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Inputs
            if (isWorker) ...[
              _buildWorkerInputs(salaryState),
            ] else ...[
              _buildCivilServantInputs(salaryState),
            ],

            const SizedBox(height: AppTheme.spacingXl),

            // Result
            if (salaryState.calculatedSalary != null) ...[
              const Divider(),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                'Tahmini Net Maaş',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '₺${salaryState.calculatedSalary!.toStringAsFixed(2)}',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '* Bu hesaplama yaklaşık değerdir ve resmi bordro yerine geçmez.',
                style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              const Center(child: Text('Hesaplama için verileri giriniz.')),
            ],

            const SizedBox(height: AppTheme.spacingXxl),

            KamulogButton(
              text: 'Detaylı Hesapla',
              onPressed: () {},
              isOutlined: true,
              icon: Icons.assignment_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerInputs(SalaryState state) {
    return Column(
      children: [
        TextFormField(
          controller: _dailyWageController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Günlük Brüt Ücret (₺)',
            prefixIcon: Icon(Icons.currency_lira),
          ),
          onChanged: (v) {
            final val = double.tryParse(v);
            if (val != null) {
              ref.read(salaryProvider.notifier).updateDailyWage(val);
            }
          },
        ),
        const SizedBox(height: AppTheme.spacingMd),
        DropdownButtonFormField<int>(
          initialValue: state.workDays,
          decoration: const InputDecoration(
            labelText: 'Çalışma Günü',
            prefixIcon: Icon(Icons.calendar_today),
          ),
          items:
              [28, 29, 30, 31]
                  .map((d) => DropdownMenuItem(value: d, child: Text('$d Gün')))
                  .toList(),
          onChanged: (v) {
            // updateWorkDays notifier'a eklenecek
          },
        ),
      ],
    );
  }

  Widget _buildCivilServantInputs(SalaryState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: state.degree,
                decoration: const InputDecoration(labelText: 'Derece'),
                items:
                    List.generate(9, (i) => i + 1)
                        .map(
                          (d) => DropdownMenuItem(value: d, child: Text('$d')),
                        )
                        .toList(),
                onChanged: (v) {
                  if (v != null) {
                    ref.read(salaryProvider.notifier).updateDegree(v);
                  }
                },
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: state.step,
                decoration: const InputDecoration(labelText: 'Kademe'),
                items:
                    List.generate(4, (i) => i + 1)
                        .map(
                          (d) => DropdownMenuItem(value: d, child: Text('$d')),
                        )
                        .toList(),
                onChanged: (v) {
                  if (v != null) {
                    ref.read(salaryProvider.notifier).updateStep(v);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),
        TextFormField(
          initialValue: state.serviceYears.toString(),
          decoration: const InputDecoration(
            labelText: 'Hizmet Yılı',
            prefixIcon: Icon(Icons.timer),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
