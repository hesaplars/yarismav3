import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/yg_card.dart';
import '../auth_controller.dart';

class AccessGateScreen extends ConsumerStatefulWidget {
  const AccessGateScreen({super.key});

  @override
  ConsumerState<AccessGateScreen> createState() => _AccessGateScreenState();
}

class _AccessGateScreenState extends ConsumerState<AccessGateScreen> {
  final _name = TextEditingController();
  bool _accepted = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: YgCard(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'YiyosaGel',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: AppTheme.gold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Oynamak icin sozlesmeyi kabul et ve bir giris sec.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.muted),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _name,
                      maxLength: 18,
                      decoration: const InputDecoration(labelText: 'Misafir kullanici adi'),
                    ),
                    CheckboxListTile(
                      value: _accepted,
                      onChanged: (value) => setState(() => _accepted = value == true),
                      title: const Text('Kullanici sozlesmesi ve kullanim sartlarini kabul ediyorum.'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: auth.isLoading || !_accepted
                          ? null
                          : () => ref.read(authControllerProvider.notifier).continueAsGuest(_name.text, _accepted),
                      icon: const Icon(Icons.person_outline),
                      label: const Text('Misafir olarak devam et'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: auth.isLoading || !_accepted
                          ? null
                          : () => ref.read(authControllerProvider.notifier).continueWithGoogle(_accepted),
                      icon: const Icon(Icons.g_mobiledata, size: 30),
                      label: const Text('Google ile giris yap'),
                    ),
                    if (auth.hasError) ...[
                      const SizedBox(height: 12),
                      Text('${auth.error}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.red)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
