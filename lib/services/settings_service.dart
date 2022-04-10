import 'package:flutter/foundation.dart';

import '../repositories/settings_repository.dart';

abstract class SettingService {
  Future<void> init();

  bool isDarkMode();

  ValueListenable<bool> darkModeChangedListenable();

  void changeDarkMode(bool newValue);

  Future<void> dispose();
}

class SettingServiceImpl implements SettingService {
  final SettingsRepository _repo;

  const SettingServiceImpl(SettingsRepository settingsRepository)
      : _repo = settingsRepository;

  @override
  Future<void> init() async {
    if (!_repo.isHiveInitialized) {
      await _repo.initHive();
    }

    await _repo.openBox();
  }

  @override
  bool isDarkMode() {
    return _repo.isDarkMode;
  }

  @override
  ValueListenable<bool> darkModeChangedListenable() {
    return _repo.getDarkModeChangedListenable();
  }

  @override
  void changeDarkMode(bool newValue) {
    _repo.setDarkMode(newValue);
  }

  @override
  Future<void> dispose() async {
    //TODO use it in statefull widget
    await _repo.closeBox();
  }
}
