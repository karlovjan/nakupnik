import 'repositories/settings_repository.dart';
import 'services/settings_service.dart';

final SettingService settingService = SettingServiceImpl(SettingsRepository());