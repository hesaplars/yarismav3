import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../domain/economy_state.dart';

class EconomyRepository {
  EconomyRepository(this._functions);

  final FirebaseFunctions _functions;

  Future<EconomyState> load() async {
    final result = await _functions.httpsCallable('getEconomyState').call();
    return EconomyState.fromJson(Map<String, dynamic>.from(result.data as Map));
  }

  Future<void> purchaseStoreItem(String itemId, String purchaseType) async {
    await _functions.httpsCallable('purchaseStoreItem').call({
      'itemId': itemId,
      'purchaseType': purchaseType,
    });
  }

  Future<void> equipCosmetic(String itemId, String slot) async {
    await _functions.httpsCallable('equipCosmetic').call({
      'itemId': itemId,
      'slot': slot,
    });
  }

  Future<void> spendForLimit(String actionKey) async {
    await _functions.httpsCallable('spendForLimit').call({'actionKey': actionKey});
  }
}

final economyRepositoryProvider = Provider<EconomyRepository>((ref) {
  return EconomyRepository(FirebaseFunctions.instanceFor(region: AppConstants.functionsRegion));
});
