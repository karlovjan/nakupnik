import 'package:flutter/foundation.dart';

import '../repositories/hive_repository.dart';

abstract class SettingService {
  Future<void> init();

  bool isDarkMode();

  ValueListenable<bool> darkModeChangedListenable();

  void changeDarkMode(bool newValue);

  void dispose();
}

class SettingServiceImpl implements SettingService {
  final HiveRepository _repo;

  SettingServiceImpl(this._repo);

  @override
  Future<void> init() async {
    if (!_repo.isHiveInitialized) {
      await _repo.initHive();
    }

    await _repo.openSettingBox();
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
  void dispose() {
    //TODO use it in statefull widget
    _repo.closeSettingBox();
  }
}
