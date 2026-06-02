import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  const SettingsState({this.darkMode = false});

  final bool darkMode;

  SettingsState copyWith({bool? darkMode}) {
    return SettingsState(darkMode: darkMode ?? this.darkMode);
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState());

  void toggleTheme() {
    state = state.copyWith(darkMode: !state.darkMode);
  }
}

final settingsControllerProvider = StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController();
});
