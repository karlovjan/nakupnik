import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {
  static const boxName = 'settings';
  static const darkModeKey = 'darkMode';

  late final Box _box;

  late ValueListenable<Box> _darkModeBoxListenable;
  late ValueNotifier<bool> _darkModeChangeListenable;

  Future<void> openBox() async {
    _box = await Hive.openBox(boxName);

    _darkModeChangeListenable = ValueNotifier(isDarkMode);

    _darkModeBoxListenable = _box.listenable(keys: <String>[darkModeKey]);
    _darkModeBoxListenable.addListener(_darkModeValueChanged);
  }

  void _darkModeValueChanged() {
    _darkModeChangeListenable.value =
        _darkModeBoxListenable.value.get(darkModeKey);
  }

  bool get isDarkMode => _box.get(darkModeKey, defaultValue: false);

  void setDarkMode(bool newValue) {
    _box.put(darkModeKey, newValue);
  }

  ValueListenable<bool> getDarkModeChangedListenable() =>
      _darkModeChangeListenable;

  Future<void> closeBox() async {
    _darkModeBoxListenable.removeListener(_darkModeValueChanged);
    _darkModeChangeListenable.dispose();
    await _box.close();
  }
}
