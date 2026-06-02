import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/yg_card.dart';
import '../../economy/economy_controller.dart';

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final economy = ref.watch(economyControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Magaza'), centerTitle: true),
      body: economy.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Magaza yuklenemedi: $error')),
        data: (state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              YgCard(
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: AppTheme.gold),
                    const SizedBox(width: 8),
                    Text('${state.balance} YG', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _LimitSection(limits: state.limits),
              const SizedBox(height: 14),
              ...state.storeItems.map((item) => _StoreItemCard(item: item)),
              if (state.storeItems.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(child: Text('Magaza verisi henuz yok.')),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _LimitSection extends ConsumerWidget {
  const _LimitSection({required this.limits});

  final Map<String, dynamic> limits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (limits.isEmpty) return const SizedBox.shrink();
    return YgCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Limitler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ...limits.entries.map((entry) {
            final data = Map<String, dynamic>.from((entry.value as Map?) ?? {});
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${data['label'] ?? entry.key}', style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('Ucretsiz: ${data['freeLimit'] ?? '-'} / Sert limit: ${data['hardLimit'] ?? '-'}'),
              trailing: FilledButton(
                onPressed: () => ref.read(economyControllerProvider.notifier).unlockLimit(entry.key),
                child: Text('${data['ygCost'] ?? '?'} YG'),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StoreItemCard extends ConsumerWidget {
  const _StoreItemCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemId = '${item['id'] ?? ''}';
    final name = '${item['name'] ?? itemId}';
    final price = item['finalPrice'] ?? item['price'] ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: YgCard(
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(color: AppTheme.goldSoft, borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: const Icon(Icons.auto_awesome, color: AppTheme.gold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                  Text('${item['description'] ?? item['type'] ?? ''}', maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            FilledButton(
              onPressed: itemId.isEmpty ? null : () => ref.read(economyControllerProvider.notifier).purchase(itemId),
              child: Text('$price YG'),
            ),
          ],
        ),
      ),
    );
  }
}
