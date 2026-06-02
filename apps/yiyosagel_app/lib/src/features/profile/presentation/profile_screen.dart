import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/avatar_view.dart';
import '../../../shared/widgets/yg_card.dart';
import '../../auth/auth_controller.dart';
import '../../economy/economy_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).valueOrNull;
    final user = session?.user;
    final economy = ref.watch(economyControllerProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          YgCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 130,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xfffff1cc), Color(0xffe2be37)]),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AvatarView(avatar: user?.avatar ?? '🍄', photoUrl: user?.photoUrl, size: 86, frameColor: AppTheme.gold),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? 'Oyuncu', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                            Text(uid, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          YgCard(
            child: Row(
              children: [
                const Icon(Icons.stars, color: AppTheme.gold),
                const SizedBox(width: 8),
                Text('${economy?.balance ?? 0} YG', style: const TextStyle(fontWeight: FontWeight.w900)),
                const Spacer(),
                FilledButton(onPressed: () {}, child: const Text('Duzenle')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          YgCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sosyal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.person_add), label: const Text('Arkadas ekle')),
                    OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.message), label: const Text('Mesaj')),
                    OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.block), label: const Text('Engelle')),
                    OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.flag), label: const Text('Raporla')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
