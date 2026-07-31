import 'package:drift/drift.dart';

@DataClassName('ChargingHistoryEntry')
class ChargingHistoryTable extends Table {

  TextColumn get sessionId => text()();
  TextColumn get stationId => text()();
  TextColumn get status => text()();
  RealColumn get soc => real()();
  RealColumn get chargingSpeedKw => real()();
  RealColumn get energyDeliveredKwh => real()();
  IntColumn get timeRemainingSeconds => integer()();
  IntColumn get elapsedTimeSeconds => integer()();
  RealColumn get batteryTempC => real()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => <Column<Object>>{sessionId};

}