import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:zetra/core/storage/database/tables/cached_stations_table.dart';
import 'package:zetra/core/storage/database/tables/charging_history_table.dart';
import 'package:zetra/core/storage/database/tables/user_preferences_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: <Type>[
  ChargingHistoryTable,
  CachedStationsTable,
  UserPreferencesTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final Directory dbFolder = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dbFolder.path, 'zetra.db'));
    return NativeDatabase.createInBackground(file);
  });
}
