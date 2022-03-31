import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveRepository {
  static const settingBoxName = 'settings';
  static const darkModeKey = 'darkMode';

  late final Box _settingBox;

  var _hiveInitialized = false;

  late ValueListenable<Box> _darkModeBoxListenable;
  late ValueNotifier<bool> _darkModeChangeListenable;

  Future<void> initHive() async {
    await Hive.initFlutter();
    _hiveInitialized = true;
  }

  get isHiveInitialized => _hiveInitialized;

  Future<void> openSettingBox() async {
    _settingBox = await Hive.openBox(settingBoxName);

    _darkModeChangeListenable = ValueNotifier(isDarkMode);

    _darkModeBoxListenable =
        _settingBox.listenable(keys: <String>[darkModeKey]);
    _darkModeBoxListenable.addListener(_darkModeValueChanged);
  }

  void _darkModeValueChanged() {
    _darkModeChangeListenable.value =
        _darkModeBoxListenable.value.get(darkModeKey);
  }

  bool get isDarkMode => _settingBox.get(darkModeKey, defaultValue: false);

  ValueListenable<Box> getSettingsBoxListenable() {
    return _settingBox.listenable();
  }

  void setDarkMode(bool newValue) {
    _settingBox.put(darkModeKey, newValue);
  }

  ValueListenable<bool> getDarkModeChangedListenable() =>
      _darkModeChangeListenable;

  void closeSettingBox() {
    _settingBox.close();
    _darkModeBoxListenable.removeListener(_darkModeValueChanged);
  }
}
