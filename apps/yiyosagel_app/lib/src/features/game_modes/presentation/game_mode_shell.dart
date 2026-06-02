import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/yg_card.dart';

class GameModeShell extends StatelessWidget {
  const GameModeShell({super.key, required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context) {
    final meta = _meta(mode);

    return Scaffold(
      appBar: AppBar(title: Text(meta.title), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          YgCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(meta.icon, color: meta.color, size: 38),
                const SizedBox(height: 12),
                Text(meta.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(meta.description, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w700)),
                const SizedBox(height: 18),
                FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow), label: const Text('Baslat')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          YgCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Liderlik', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                ...List.generate(3, (index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: const Text('Oyuncu bekleniyor'),
                    trailing: const Text('0'),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          YgCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Raporlama ve moderasyon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(
                  'Bu modda yorum, sohbet, ozel mesaj ve oyun icerigi raporlanabilir olacak. Kritik yazmalar server tarafinda dogrulanacak.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_ModeMeta _meta(String mode) {
  switch (mode) {
    case 'tour':
      return const _ModeMeta('TUR', 'Canli rekabet odasi ve gunluk tur siralamasi.', Icons.radio_button_checked, AppTheme.green);
    case 'room':
      return const _ModeMeta('ODA KUR', 'Ozel oda kodu, oyuncu listesi, oda sohbeti ve round akisi.', Icons.groups_2, AppTheme.gold);
    case 'custom':
      return const _ModeMeta('OYUN OLUSTUR', 'Topluluk oyunlari, yorumlar, begeniler ve onay akisi.', Icons.edit_note, AppTheme.blue);
    case 'wordle':
      return const _ModeMeta('KELIME TAHMIN', 'Gunluk kelime, ozel kelime ve ilk 100 liderlik tablosu.', Icons.grid_4x4, Color(0xff8b5cf6));
    default:
      return const _ModeMeta('GUNLUK REKABETCI', 'Gunluk soru seti, skor kaydi ve podyum liderligi.', Icons.calendar_month, AppTheme.red);
  }
}

class _ModeMeta {
  const _ModeMeta(this.title, this.description, this.icon, this.color);

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
