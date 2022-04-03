import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {
  static const boxName = 'settings';
  static const darkModeKey = 'darkMode';

  late final Box _box;

  var _hiveInitialized = false;

  late ValueListenable<Box> _darkModeBoxListenable;
  late ValueNotifier<bool> _darkModeChangeListenable;

  Future<void> initHive() async {
    await Hive.initFlutter();
    _hiveInitialized = true;
  }

  get isHiveInitialized => _hiveInitialized;

  Future<void> openBox() async {
    _box = await Hive.openBox(boxName);

    _darkModeChangeListenable = ValueNotifier(isDarkMode);

    _darkModeBoxListenable =
        _box.listenable(keys: <String>[darkModeKey]);
    _darkModeBoxListenable.addListener(_darkModeValueChanged);
  }

  void _darkModeValueChanged() {
    _darkModeChangeListenable.value =
        _darkModeBoxListenable.value.get(darkModeKey);
  }

  bool get isDarkMode => _box.get(darkModeKey, defaultValue: false);

  ValueListenable<Box> getSettingsBoxListenable() {
    return _box.listenable();
  }

  void setDarkMode(bool newValue) {
    _box.put(darkModeKey, newValue);
  }

  ValueListenable<bool> getDarkModeChangedListenable() =>
      _darkModeChangeListenable;

  Future<void> closeBox() async {
    _darkModeBoxListenable.removeListener(_darkModeValueChanged);
    await _box.close();
  }
}
