import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/avatar_view.dart';
import '../../../shared/widgets/yg_card.dart';
import '../../auth/auth_controller.dart';
import '../../economy/economy_controller.dart';
import '../../settings/settings_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).valueOrNull;
    final user = session?.user;
    final economy = ref.watch(economyControllerProvider);
    final balance = economy.valueOrNull?.balance ?? 0;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    const _Brand(),
                    const Spacer(),
                    _GoldPill(balance: balance),
                    IconButton(
                      onPressed: () => ref.read(settingsControllerProvider.notifier).toggleTheme(),
                      icon: const Icon(Icons.dark_mode_outlined),
                    ),
                    InkWell(
                      onTap: () => context.go('/profile/${user?.uid ?? 'me'}'),
                      child: AvatarView(
                        avatar: user?.avatar ?? AppConstants.defaultGuestAvatar,
                        photoUrl: user?.photoUrl,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              sliver: SliverList.list(
                children: [
                  TextField(
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Kullanici ara'),
                    onSubmitted: (query) {},
                  ),
                  const SizedBox(height: 14),
                  _ModeCard(
                    title: 'GUNLUK REKABETCI',
                    subtitle: 'Bugunun soru setini oyna, ilk 100 siralamaya gir.',
                    icon: Icons.calendar_month,
                    color: AppTheme.red,
                    route: '/game/daily',
                  ),
                  _ModeCard(
                    title: 'TUR',
                    subtitle: '7/24 canli tur odasinda hizli cevap ver.',
                    icon: Icons.radio_button_checked,
                    color: AppTheme.green,
                    route: '/game/tour',
                  ),
                  _ModeCard(
                    title: 'ODA KUR',
                    subtitle: 'Arkadaslarinla ozel oda kur veya davet koduyla katil.',
                    icon: Icons.groups_2,
                    color: AppTheme.gold,
                    route: '/game/room',
                  ),
                  _ModeCard(
                    title: 'OYUN OLUSTUR',
                    subtitle: 'Topluluk oyunlari olustur, yorumla ve begendir.',
                    icon: Icons.edit_note,
                    color: AppTheme.blue,
                    route: '/game/custom',
                  ),
                  _ModeCard(
                    title: 'KELIME TAHMIN',
                    subtitle: 'Gunluk veya kullanici olusturmus kelimeyi 5 hamlede bul.',
                    icon: Icons.grid_4x4,
                    color: const Color(0xff8b5cf6),
                    route: '/game/wordle',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('YiyosaGel', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: AppTheme.gold)),
        Text('Online kelime arenasi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.muted)),
      ],
    );
  }
}

class _GoldPill extends StatelessWidget {
  const _GoldPill({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/store'),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Theme.of(context).cardColor,
          border: Border.all(color: AppTheme.line),
        ),
        child: Row(children: [const Icon(Icons.stars, color: AppTheme.gold, size: 18), const SizedBox(width: 4), Text('$balance')]),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: YgCard(
        onTap: () => context.go(route),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(subtitle, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: () => context.go(route), child: const Text('Ac')),
          ],
        ),
      ),
    );
  }
}
