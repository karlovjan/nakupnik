import 'repositories/hive_repository.dart';
import 'services/settings_service.dart';

final SettingService settingService = SettingServiceImpl(HiveRepository());