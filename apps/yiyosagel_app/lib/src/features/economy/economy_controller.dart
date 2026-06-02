import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/economy_repository.dart';
import 'domain/economy_state.dart';

class EconomyController extends AsyncNotifier<EconomyState> {
  late final EconomyRepository _repository;

  @override
  Future<EconomyState> build() async {
    _repository = ref.watch(economyRepositoryProvider);
    return _repository.load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.load);
  }

  Future<void> purchase(String itemId, {String purchaseType = 'permanent'}) async {
    await _repository.purchaseStoreItem(itemId, purchaseType);
    await refresh();
  }

  Future<void> equip(String itemId, String slot) async {
    await _repository.equipCosmetic(itemId, slot);
    await refresh();
  }

  Future<void> unlockLimit(String actionKey) async {
    await _repository.spendForLimit(actionKey);
    await refresh();
  }
}

final economyControllerProvider = AsyncNotifierProvider<EconomyController, EconomyState>(EconomyController.new);
