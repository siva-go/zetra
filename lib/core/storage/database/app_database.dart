import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/charging_history_table.dart';
import 'tables/cached_stations_table.dart';
import 'tables/user_preferences_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
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
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'zetra.db'));
    return NativeDatabase.createInBackground(file);
  });
}
