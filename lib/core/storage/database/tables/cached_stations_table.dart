import 'package:drift/drift.dart';

@DataClassName('CachedStation')
class CachedStationsTable extends Table {

  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get status => text()();
  IntColumn get totalConnectors => integer()();
  IntColumn get availableConnectors => integer()();
  TextColumn get address => text().nullable()();

  @override
  Set<Column> get primaryKey => <Column<Object>>{id};

}