import 'package:hive_flutter/hive_flutter.dart';

/// Deletes the temporary [Hive].
Future<void> tearDownTestHive(String boxName) async {
  // await Hive.deleteFromDisk();
  await Hive.deleteBoxFromDisk(boxName);
}
