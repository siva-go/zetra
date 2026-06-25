// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

class $ChargingHistoryTableTable extends ChargingHistoryTable
    with TableInfo<$ChargingHistoryTableTable, ChargingHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChargingHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stationIdMeta =
      const VerificationMeta('stationId');
  @override
  late final GeneratedColumn<String> stationId = GeneratedColumn<String>(
      'station_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _socMeta = const VerificationMeta('soc');
  @override
  late final GeneratedColumn<double> soc = GeneratedColumn<double>(
      'soc', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _chargingSpeedKwMeta =
      const VerificationMeta('chargingSpeedKw');
  @override
  late final GeneratedColumn<double> chargingSpeedKw = GeneratedColumn<double>(
      'charging_speed_kw', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _energyDeliveredKwhMeta =
      const VerificationMeta('energyDeliveredKwh');
  @override
  late final GeneratedColumn<double> energyDeliveredKwh =
      GeneratedColumn<double>('energy_delivered_kwh', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timeRemainingSecondsMeta =
      const VerificationMeta('timeRemainingSeconds');
  @override
  late final GeneratedColumn<int> timeRemainingSeconds = GeneratedColumn<int>(
      'time_remaining_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _elapsedTimeSecondsMeta =
      const VerificationMeta('elapsedTimeSeconds');
  @override
  late final GeneratedColumn<int> elapsedTimeSeconds = GeneratedColumn<int>(
      'elapsed_time_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _batteryTempCMeta =
      const VerificationMeta('batteryTempC');
  @override
  late final GeneratedColumn<double> batteryTempC = GeneratedColumn<double>(
      'battery_temp_c', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        sessionId,
        stationId,
        status,
        soc,
        chargingSpeedKw,
        energyDeliveredKwh,
        timeRemainingSeconds,
        elapsedTimeSeconds,
        batteryTempC,
        startedAt,
        endedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charging_history_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChargingHistoryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('station_id')) {
      context.handle(_stationIdMeta,
          stationId.isAcceptableOrUnknown(data['station_id']!, _stationIdMeta));
    } else if (isInserting) {
      context.missing(_stationIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('soc')) {
      context.handle(
          _socMeta, soc.isAcceptableOrUnknown(data['soc']!, _socMeta));
    } else if (isInserting) {
      context.missing(_socMeta);
    }
    if (data.containsKey('charging_speed_kw')) {
      context.handle(
          _chargingSpeedKwMeta,
          chargingSpeedKw.isAcceptableOrUnknown(
              data['charging_speed_kw']!, _chargingSpeedKwMeta));
    } else if (isInserting) {
      context.missing(_chargingSpeedKwMeta);
    }
    if (data.containsKey('energy_delivered_kwh')) {
      context.handle(
          _energyDeliveredKwhMeta,
          energyDeliveredKwh.isAcceptableOrUnknown(
              data['energy_delivered_kwh']!, _energyDeliveredKwhMeta));
    } else if (isInserting) {
      context.missing(_energyDeliveredKwhMeta);
    }
    if (data.containsKey('time_remaining_seconds')) {
      context.handle(
          _timeRemainingSecondsMeta,
          timeRemainingSeconds.isAcceptableOrUnknown(
              data['time_remaining_seconds']!, _timeRemainingSecondsMeta));
    } else if (isInserting) {
      context.missing(_timeRemainingSecondsMeta);
    }
    if (data.containsKey('elapsed_time_seconds')) {
      context.handle(
          _elapsedTimeSecondsMeta,
          elapsedTimeSeconds.isAcceptableOrUnknown(
              data['elapsed_time_seconds']!, _elapsedTimeSecondsMeta));
    } else if (isInserting) {
      context.missing(_elapsedTimeSecondsMeta);
    }
    if (data.containsKey('battery_temp_c')) {
      context.handle(
          _batteryTempCMeta,
          batteryTempC.isAcceptableOrUnknown(
              data['battery_temp_c']!, _batteryTempCMeta));
    } else if (isInserting) {
      context.missing(_batteryTempCMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  ChargingHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChargingHistoryEntry(
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      stationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}station_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      soc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}soc'])!,
      chargingSpeedKw: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}charging_speed_kw'])!,
      energyDeliveredKwh: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}energy_delivered_kwh'])!,
      timeRemainingSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}time_remaining_seconds'])!,
      elapsedTimeSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}elapsed_time_seconds'])!,
      batteryTempC: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}battery_temp_c'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at']),
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
    );
  }

  @override
  $ChargingHistoryTableTable createAlias(String alias) {
    return $ChargingHistoryTableTable(attachedDatabase, alias);
  }
}

class ChargingHistoryEntry extends DataClass
    implements Insertable<ChargingHistoryEntry> {
  final String sessionId;
  final String stationId;
  final String status;
  final double soc;
  final double chargingSpeedKw;
  final double energyDeliveredKwh;
  final int timeRemainingSeconds;
  final int elapsedTimeSeconds;
  final double batteryTempC;
  final DateTime? startedAt;
  final DateTime? endedAt;
  const ChargingHistoryEntry(
      {required this.sessionId,
      required this.stationId,
      required this.status,
      required this.soc,
      required this.chargingSpeedKw,
      required this.energyDeliveredKwh,
      required this.timeRemainingSeconds,
      required this.elapsedTimeSeconds,
      required this.batteryTempC,
      this.startedAt,
      this.endedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['station_id'] = Variable<String>(stationId);
    map['status'] = Variable<String>(status);
    map['soc'] = Variable<double>(soc);
    map['charging_speed_kw'] = Variable<double>(chargingSpeedKw);
    map['energy_delivered_kwh'] = Variable<double>(energyDeliveredKwh);
    map['time_remaining_seconds'] = Variable<int>(timeRemainingSeconds);
    map['elapsed_time_seconds'] = Variable<int>(elapsedTimeSeconds);
    map['battery_temp_c'] = Variable<double>(batteryTempC);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  ChargingHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return ChargingHistoryTableCompanion(
      sessionId: Value(sessionId),
      stationId: Value(stationId),
      status: Value(status),
      soc: Value(soc),
      chargingSpeedKw: Value(chargingSpeedKw),
      energyDeliveredKwh: Value(energyDeliveredKwh),
      timeRemainingSeconds: Value(timeRemainingSeconds),
      elapsedTimeSeconds: Value(elapsedTimeSeconds),
      batteryTempC: Value(batteryTempC),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory ChargingHistoryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChargingHistoryEntry(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      stationId: serializer.fromJson<String>(json['stationId']),
      status: serializer.fromJson<String>(json['status']),
      soc: serializer.fromJson<double>(json['soc']),
      chargingSpeedKw: serializer.fromJson<double>(json['chargingSpeedKw']),
      energyDeliveredKwh:
          serializer.fromJson<double>(json['energyDeliveredKwh']),
      timeRemainingSeconds:
          serializer.fromJson<int>(json['timeRemainingSeconds']),
      elapsedTimeSeconds: serializer.fromJson<int>(json['elapsedTimeSeconds']),
      batteryTempC: serializer.fromJson<double>(json['batteryTempC']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'stationId': serializer.toJson<String>(stationId),
      'status': serializer.toJson<String>(status),
      'soc': serializer.toJson<double>(soc),
      'chargingSpeedKw': serializer.toJson<double>(chargingSpeedKw),
      'energyDeliveredKwh': serializer.toJson<double>(energyDeliveredKwh),
      'timeRemainingSeconds': serializer.toJson<int>(timeRemainingSeconds),
      'elapsedTimeSeconds': serializer.toJson<int>(elapsedTimeSeconds),
      'batteryTempC': serializer.toJson<double>(batteryTempC),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  ChargingHistoryEntry copyWith(
          {String? sessionId,
          String? stationId,
          String? status,
          double? soc,
          double? chargingSpeedKw,
          double? energyDeliveredKwh,
          int? timeRemainingSeconds,
          int? elapsedTimeSeconds,
          double? batteryTempC,
          Value<DateTime?> startedAt = const Value.absent(),
          Value<DateTime?> endedAt = const Value.absent()}) =>
      ChargingHistoryEntry(
        sessionId: sessionId ?? this.sessionId,
        stationId: stationId ?? this.stationId,
        status: status ?? this.status,
        soc: soc ?? this.soc,
        chargingSpeedKw: chargingSpeedKw ?? this.chargingSpeedKw,
        energyDeliveredKwh: energyDeliveredKwh ?? this.energyDeliveredKwh,
        timeRemainingSeconds: timeRemainingSeconds ?? this.timeRemainingSeconds,
        elapsedTimeSeconds: elapsedTimeSeconds ?? this.elapsedTimeSeconds,
        batteryTempC: batteryTempC ?? this.batteryTempC,
        startedAt: startedAt.present ? startedAt.value : this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt,
      );
  ChargingHistoryEntry copyWithCompanion(ChargingHistoryTableCompanion data) {
    return ChargingHistoryEntry(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      stationId: data.stationId.present ? data.stationId.value : this.stationId,
      status: data.status.present ? data.status.value : this.status,
      soc: data.soc.present ? data.soc.value : this.soc,
      chargingSpeedKw: data.chargingSpeedKw.present
          ? data.chargingSpeedKw.value
          : this.chargingSpeedKw,
      energyDeliveredKwh: data.energyDeliveredKwh.present
          ? data.energyDeliveredKwh.value
          : this.energyDeliveredKwh,
      timeRemainingSeconds: data.timeRemainingSeconds.present
          ? data.timeRemainingSeconds.value
          : this.timeRemainingSeconds,
      elapsedTimeSeconds: data.elapsedTimeSeconds.present
          ? data.elapsedTimeSeconds.value
          : this.elapsedTimeSeconds,
      batteryTempC: data.batteryTempC.present
          ? data.batteryTempC.value
          : this.batteryTempC,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChargingHistoryEntry(')
          ..write('sessionId: $sessionId, ')
          ..write('stationId: $stationId, ')
          ..write('status: $status, ')
          ..write('soc: $soc, ')
          ..write('chargingSpeedKw: $chargingSpeedKw, ')
          ..write('energyDeliveredKwh: $energyDeliveredKwh, ')
          ..write('timeRemainingSeconds: $timeRemainingSeconds, ')
          ..write('elapsedTimeSeconds: $elapsedTimeSeconds, ')
          ..write('batteryTempC: $batteryTempC, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      sessionId,
      stationId,
      status,
      soc,
      chargingSpeedKw,
      energyDeliveredKwh,
      timeRemainingSeconds,
      elapsedTimeSeconds,
      batteryTempC,
      startedAt,
      endedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChargingHistoryEntry &&
          other.sessionId == this.sessionId &&
          other.stationId == this.stationId &&
          other.status == this.status &&
          other.soc == this.soc &&
          other.chargingSpeedKw == this.chargingSpeedKw &&
          other.energyDeliveredKwh == this.energyDeliveredKwh &&
          other.timeRemainingSeconds == this.timeRemainingSeconds &&
          other.elapsedTimeSeconds == this.elapsedTimeSeconds &&
          other.batteryTempC == this.batteryTempC &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class ChargingHistoryTableCompanion
    extends UpdateCompanion<ChargingHistoryEntry> {
  final Value<String> sessionId;
  final Value<String> stationId;
  final Value<String> status;
  final Value<double> soc;
  final Value<double> chargingSpeedKw;
  final Value<double> energyDeliveredKwh;
  final Value<int> timeRemainingSeconds;
  final Value<int> elapsedTimeSeconds;
  final Value<double> batteryTempC;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> rowid;
  const ChargingHistoryTableCompanion({
    this.sessionId = const Value.absent(),
    this.stationId = const Value.absent(),
    this.status = const Value.absent(),
    this.soc = const Value.absent(),
    this.chargingSpeedKw = const Value.absent(),
    this.energyDeliveredKwh = const Value.absent(),
    this.timeRemainingSeconds = const Value.absent(),
    this.elapsedTimeSeconds = const Value.absent(),
    this.batteryTempC = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChargingHistoryTableCompanion.insert({
    required String sessionId,
    required String stationId,
    required String status,
    required double soc,
    required double chargingSpeedKw,
    required double energyDeliveredKwh,
    required int timeRemainingSeconds,
    required int elapsedTimeSeconds,
    required double batteryTempC,
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : sessionId = Value(sessionId),
        stationId = Value(stationId),
        status = Value(status),
        soc = Value(soc),
        chargingSpeedKw = Value(chargingSpeedKw),
        energyDeliveredKwh = Value(energyDeliveredKwh),
        timeRemainingSeconds = Value(timeRemainingSeconds),
        elapsedTimeSeconds = Value(elapsedTimeSeconds),
        batteryTempC = Value(batteryTempC);
  static Insertable<ChargingHistoryEntry> custom({
    Expression<String>? sessionId,
    Expression<String>? stationId,
    Expression<String>? status,
    Expression<double>? soc,
    Expression<double>? chargingSpeedKw,
    Expression<double>? energyDeliveredKwh,
    Expression<int>? timeRemainingSeconds,
    Expression<int>? elapsedTimeSeconds,
    Expression<double>? batteryTempC,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (stationId != null) 'station_id': stationId,
      if (status != null) 'status': status,
      if (soc != null) 'soc': soc,
      if (chargingSpeedKw != null) 'charging_speed_kw': chargingSpeedKw,
      if (energyDeliveredKwh != null)
        'energy_delivered_kwh': energyDeliveredKwh,
      if (timeRemainingSeconds != null)
        'time_remaining_seconds': timeRemainingSeconds,
      if (elapsedTimeSeconds != null)
        'elapsed_time_seconds': elapsedTimeSeconds,
      if (batteryTempC != null) 'battery_temp_c': batteryTempC,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChargingHistoryTableCompanion copyWith(
      {Value<String>? sessionId,
      Value<String>? stationId,
      Value<String>? status,
      Value<double>? soc,
      Value<double>? chargingSpeedKw,
      Value<double>? energyDeliveredKwh,
      Value<int>? timeRemainingSeconds,
      Value<int>? elapsedTimeSeconds,
      Value<double>? batteryTempC,
      Value<DateTime?>? startedAt,
      Value<DateTime?>? endedAt,
      Value<int>? rowid}) {
    return ChargingHistoryTableCompanion(
      sessionId: sessionId ?? this.sessionId,
      stationId: stationId ?? this.stationId,
      status: status ?? this.status,
      soc: soc ?? this.soc,
      chargingSpeedKw: chargingSpeedKw ?? this.chargingSpeedKw,
      energyDeliveredKwh: energyDeliveredKwh ?? this.energyDeliveredKwh,
      timeRemainingSeconds: timeRemainingSeconds ?? this.timeRemainingSeconds,
      elapsedTimeSeconds: elapsedTimeSeconds ?? this.elapsedTimeSeconds,
      batteryTempC: batteryTempC ?? this.batteryTempC,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (stationId.present) {
      map['station_id'] = Variable<String>(stationId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (soc.present) {
      map['soc'] = Variable<double>(soc.value);
    }
    if (chargingSpeedKw.present) {
      map['charging_speed_kw'] = Variable<double>(chargingSpeedKw.value);
    }
    if (energyDeliveredKwh.present) {
      map['energy_delivered_kwh'] = Variable<double>(energyDeliveredKwh.value);
    }
    if (timeRemainingSeconds.present) {
      map['time_remaining_seconds'] = Variable<int>(timeRemainingSeconds.value);
    }
    if (elapsedTimeSeconds.present) {
      map['elapsed_time_seconds'] = Variable<int>(elapsedTimeSeconds.value);
    }
    if (batteryTempC.present) {
      map['battery_temp_c'] = Variable<double>(batteryTempC.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChargingHistoryTableCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('stationId: $stationId, ')
          ..write('status: $status, ')
          ..write('soc: $soc, ')
          ..write('chargingSpeedKw: $chargingSpeedKw, ')
          ..write('energyDeliveredKwh: $energyDeliveredKwh, ')
          ..write('timeRemainingSeconds: $timeRemainingSeconds, ')
          ..write('elapsedTimeSeconds: $elapsedTimeSeconds, ')
          ..write('batteryTempC: $batteryTempC, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedStationsTableTable extends CachedStationsTable
    with TableInfo<$CachedStationsTableTable, CachedStation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedStationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalConnectorsMeta =
      const VerificationMeta('totalConnectors');
  @override
  late final GeneratedColumn<int> totalConnectors = GeneratedColumn<int>(
      'total_connectors', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _availableConnectorsMeta =
      const VerificationMeta('availableConnectors');
  @override
  late final GeneratedColumn<int> availableConnectors = GeneratedColumn<int>(
      'available_connectors', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        latitude,
        longitude,
        status,
        totalConnectors,
        availableConnectors,
        address
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_stations_table';
  @override
  VerificationContext validateIntegrity(Insertable<CachedStation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('total_connectors')) {
      context.handle(
          _totalConnectorsMeta,
          totalConnectors.isAcceptableOrUnknown(
              data['total_connectors']!, _totalConnectorsMeta));
    } else if (isInserting) {
      context.missing(_totalConnectorsMeta);
    }
    if (data.containsKey('available_connectors')) {
      context.handle(
          _availableConnectorsMeta,
          availableConnectors.isAcceptableOrUnknown(
              data['available_connectors']!, _availableConnectorsMeta));
    } else if (isInserting) {
      context.missing(_availableConnectorsMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedStation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedStation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      totalConnectors: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_connectors'])!,
      availableConnectors: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}available_connectors'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
    );
  }

  @override
  $CachedStationsTableTable createAlias(String alias) {
    return $CachedStationsTableTable(attachedDatabase, alias);
  }
}

class CachedStation extends DataClass implements Insertable<CachedStation> {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String status;
  final int totalConnectors;
  final int availableConnectors;
  final String? address;
  const CachedStation(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.status,
      required this.totalConnectors,
      required this.availableConnectors,
      this.address});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['status'] = Variable<String>(status);
    map['total_connectors'] = Variable<int>(totalConnectors);
    map['available_connectors'] = Variable<int>(availableConnectors);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    return map;
  }

  CachedStationsTableCompanion toCompanion(bool nullToAbsent) {
    return CachedStationsTableCompanion(
      id: Value(id),
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      status: Value(status),
      totalConnectors: Value(totalConnectors),
      availableConnectors: Value(availableConnectors),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
    );
  }

  factory CachedStation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedStation(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      status: serializer.fromJson<String>(json['status']),
      totalConnectors: serializer.fromJson<int>(json['totalConnectors']),
      availableConnectors:
          serializer.fromJson<int>(json['availableConnectors']),
      address: serializer.fromJson<String?>(json['address']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'status': serializer.toJson<String>(status),
      'totalConnectors': serializer.toJson<int>(totalConnectors),
      'availableConnectors': serializer.toJson<int>(availableConnectors),
      'address': serializer.toJson<String?>(address),
    };
  }

  CachedStation copyWith(
          {String? id,
          String? name,
          double? latitude,
          double? longitude,
          String? status,
          int? totalConnectors,
          int? availableConnectors,
          Value<String?> address = const Value.absent()}) =>
      CachedStation(
        id: id ?? this.id,
        name: name ?? this.name,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        status: status ?? this.status,
        totalConnectors: totalConnectors ?? this.totalConnectors,
        availableConnectors: availableConnectors ?? this.availableConnectors,
        address: address.present ? address.value : this.address,
      );
  CachedStation copyWithCompanion(CachedStationsTableCompanion data) {
    return CachedStation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      status: data.status.present ? data.status.value : this.status,
      totalConnectors: data.totalConnectors.present
          ? data.totalConnectors.value
          : this.totalConnectors,
      availableConnectors: data.availableConnectors.present
          ? data.availableConnectors.value
          : this.availableConnectors,
      address: data.address.present ? data.address.value : this.address,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedStation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('totalConnectors: $totalConnectors, ')
          ..write('availableConnectors: $availableConnectors, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, latitude, longitude, status,
      totalConnectors, availableConnectors, address);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedStation &&
          other.id == this.id &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.status == this.status &&
          other.totalConnectors == this.totalConnectors &&
          other.availableConnectors == this.availableConnectors &&
          other.address == this.address);
}

class CachedStationsTableCompanion extends UpdateCompanion<CachedStation> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> status;
  final Value<int> totalConnectors;
  final Value<int> availableConnectors;
  final Value<String?> address;
  final Value<int> rowid;
  const CachedStationsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.status = const Value.absent(),
    this.totalConnectors = const Value.absent(),
    this.availableConnectors = const Value.absent(),
    this.address = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedStationsTableCompanion.insert({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required String status,
    required int totalConnectors,
    required int availableConnectors,
    this.address = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        latitude = Value(latitude),
        longitude = Value(longitude),
        status = Value(status),
        totalConnectors = Value(totalConnectors),
        availableConnectors = Value(availableConnectors);
  static Insertable<CachedStation> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? status,
    Expression<int>? totalConnectors,
    Expression<int>? availableConnectors,
    Expression<String>? address,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (status != null) 'status': status,
      if (totalConnectors != null) 'total_connectors': totalConnectors,
      if (availableConnectors != null)
        'available_connectors': availableConnectors,
      if (address != null) 'address': address,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedStationsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String>? status,
      Value<int>? totalConnectors,
      Value<int>? availableConnectors,
      Value<String?>? address,
      Value<int>? rowid}) {
    return CachedStationsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      totalConnectors: totalConnectors ?? this.totalConnectors,
      availableConnectors: availableConnectors ?? this.availableConnectors,
      address: address ?? this.address,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalConnectors.present) {
      map['total_connectors'] = Variable<int>(totalConnectors.value);
    }
    if (availableConnectors.present) {
      map['available_connectors'] = Variable<int>(availableConnectors.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedStationsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('totalConnectors: $totalConnectors, ')
          ..write('availableConnectors: $availableConnectors, ')
          ..write('address: $address, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTableTable extends UserPreferencesTable
    with TableInfo<$UserPreferencesTableTable, UserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  UserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreference(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $UserPreferencesTableTable createAlias(String alias) {
    return $UserPreferencesTableTable(attachedDatabase, alias);
  }
}

class UserPreference extends DataClass implements Insertable<UserPreference> {
  final String key;
  final String value;
  const UserPreference({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesTableCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory UserPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreference(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  UserPreference copyWith({String? key, String? value}) => UserPreference(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  UserPreference copyWithCompanion(UserPreferencesTableCompanion data) {
    return UserPreference(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreference(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.key == this.key &&
          other.value == this.value);
}

class UserPreferencesTableCompanion extends UpdateCompanion<UserPreference> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const UserPreferencesTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<UserPreference> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesTableCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return UserPreferencesTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChargingHistoryTableTable chargingHistoryTable =
      $ChargingHistoryTableTable(this);
  late final $CachedStationsTableTable cachedStationsTable =
      $CachedStationsTableTable(this);
  late final $UserPreferencesTableTable userPreferencesTable =
      $UserPreferencesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [chargingHistoryTable, cachedStationsTable, userPreferencesTable];
}

typedef $$ChargingHistoryTableTableCreateCompanionBuilder
    = ChargingHistoryTableCompanion Function({
  required String sessionId,
  required String stationId,
  required String status,
  required double soc,
  required double chargingSpeedKw,
  required double energyDeliveredKwh,
  required int timeRemainingSeconds,
  required int elapsedTimeSeconds,
  required double batteryTempC,
  Value<DateTime?> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});
typedef $$ChargingHistoryTableTableUpdateCompanionBuilder
    = ChargingHistoryTableCompanion Function({
  Value<String> sessionId,
  Value<String> stationId,
  Value<String> status,
  Value<double> soc,
  Value<double> chargingSpeedKw,
  Value<double> energyDeliveredKwh,
  Value<int> timeRemainingSeconds,
  Value<int> elapsedTimeSeconds,
  Value<double> batteryTempC,
  Value<DateTime?> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});

class $$ChargingHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChargingHistoryTableTable> {
  $$ChargingHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stationId => $composableBuilder(
      column: $table.stationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get soc => $composableBuilder(
      column: $table.soc, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get chargingSpeedKw => $composableBuilder(
      column: $table.chargingSpeedKw,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get energyDeliveredKwh => $composableBuilder(
      column: $table.energyDeliveredKwh,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeRemainingSeconds => $composableBuilder(
      column: $table.timeRemainingSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get elapsedTimeSeconds => $composableBuilder(
      column: $table.elapsedTimeSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get batteryTempC => $composableBuilder(
      column: $table.batteryTempC, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));
}

class $$ChargingHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChargingHistoryTableTable> {
  $$ChargingHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stationId => $composableBuilder(
      column: $table.stationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get soc => $composableBuilder(
      column: $table.soc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get chargingSpeedKw => $composableBuilder(
      column: $table.chargingSpeedKw,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get energyDeliveredKwh => $composableBuilder(
      column: $table.energyDeliveredKwh,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeRemainingSeconds => $composableBuilder(
      column: $table.timeRemainingSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get elapsedTimeSeconds => $composableBuilder(
      column: $table.elapsedTimeSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get batteryTempC => $composableBuilder(
      column: $table.batteryTempC,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));
}

class $$ChargingHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChargingHistoryTableTable> {
  $$ChargingHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get stationId =>
      $composableBuilder(column: $table.stationId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get soc =>
      $composableBuilder(column: $table.soc, builder: (column) => column);

  GeneratedColumn<double> get chargingSpeedKw => $composableBuilder(
      column: $table.chargingSpeedKw, builder: (column) => column);

  GeneratedColumn<double> get energyDeliveredKwh => $composableBuilder(
      column: $table.energyDeliveredKwh, builder: (column) => column);

  GeneratedColumn<int> get timeRemainingSeconds => $composableBuilder(
      column: $table.timeRemainingSeconds, builder: (column) => column);

  GeneratedColumn<int> get elapsedTimeSeconds => $composableBuilder(
      column: $table.elapsedTimeSeconds, builder: (column) => column);

  GeneratedColumn<double> get batteryTempC => $composableBuilder(
      column: $table.batteryTempC, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);
}

class $$ChargingHistoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChargingHistoryTableTable,
    ChargingHistoryEntry,
    $$ChargingHistoryTableTableFilterComposer,
    $$ChargingHistoryTableTableOrderingComposer,
    $$ChargingHistoryTableTableAnnotationComposer,
    $$ChargingHistoryTableTableCreateCompanionBuilder,
    $$ChargingHistoryTableTableUpdateCompanionBuilder,
    (
      ChargingHistoryEntry,
      BaseReferences<_$AppDatabase, $ChargingHistoryTableTable,
          ChargingHistoryEntry>
    ),
    ChargingHistoryEntry,
    PrefetchHooks Function()> {
  $$ChargingHistoryTableTableTableManager(
      _$AppDatabase db, $ChargingHistoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChargingHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChargingHistoryTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChargingHistoryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> sessionId = const Value.absent(),
            Value<String> stationId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> soc = const Value.absent(),
            Value<double> chargingSpeedKw = const Value.absent(),
            Value<double> energyDeliveredKwh = const Value.absent(),
            Value<int> timeRemainingSeconds = const Value.absent(),
            Value<int> elapsedTimeSeconds = const Value.absent(),
            Value<double> batteryTempC = const Value.absent(),
            Value<DateTime?> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChargingHistoryTableCompanion(
            sessionId: sessionId,
            stationId: stationId,
            status: status,
            soc: soc,
            chargingSpeedKw: chargingSpeedKw,
            energyDeliveredKwh: energyDeliveredKwh,
            timeRemainingSeconds: timeRemainingSeconds,
            elapsedTimeSeconds: elapsedTimeSeconds,
            batteryTempC: batteryTempC,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String sessionId,
            required String stationId,
            required String status,
            required double soc,
            required double chargingSpeedKw,
            required double energyDeliveredKwh,
            required int timeRemainingSeconds,
            required int elapsedTimeSeconds,
            required double batteryTempC,
            Value<DateTime?> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChargingHistoryTableCompanion.insert(
            sessionId: sessionId,
            stationId: stationId,
            status: status,
            soc: soc,
            chargingSpeedKw: chargingSpeedKw,
            energyDeliveredKwh: energyDeliveredKwh,
            timeRemainingSeconds: timeRemainingSeconds,
            elapsedTimeSeconds: elapsedTimeSeconds,
            batteryTempC: batteryTempC,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChargingHistoryTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ChargingHistoryTableTable,
        ChargingHistoryEntry,
        $$ChargingHistoryTableTableFilterComposer,
        $$ChargingHistoryTableTableOrderingComposer,
        $$ChargingHistoryTableTableAnnotationComposer,
        $$ChargingHistoryTableTableCreateCompanionBuilder,
        $$ChargingHistoryTableTableUpdateCompanionBuilder,
        (
          ChargingHistoryEntry,
          BaseReferences<_$AppDatabase, $ChargingHistoryTableTable,
              ChargingHistoryEntry>
        ),
        ChargingHistoryEntry,
        PrefetchHooks Function()>;
typedef $$CachedStationsTableTableCreateCompanionBuilder
    = CachedStationsTableCompanion Function({
  required String id,
  required String name,
  required double latitude,
  required double longitude,
  required String status,
  required int totalConnectors,
  required int availableConnectors,
  Value<String?> address,
  Value<int> rowid,
});
typedef $$CachedStationsTableTableUpdateCompanionBuilder
    = CachedStationsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> latitude,
  Value<double> longitude,
  Value<String> status,
  Value<int> totalConnectors,
  Value<int> availableConnectors,
  Value<String?> address,
  Value<int> rowid,
});

class $$CachedStationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedStationsTableTable> {
  $$CachedStationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalConnectors => $composableBuilder(
      column: $table.totalConnectors,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get availableConnectors => $composableBuilder(
      column: $table.availableConnectors,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));
}

class $$CachedStationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedStationsTableTable> {
  $$CachedStationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalConnectors => $composableBuilder(
      column: $table.totalConnectors,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get availableConnectors => $composableBuilder(
      column: $table.availableConnectors,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));
}

class $$CachedStationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedStationsTableTable> {
  $$CachedStationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalConnectors => $composableBuilder(
      column: $table.totalConnectors, builder: (column) => column);

  GeneratedColumn<int> get availableConnectors => $composableBuilder(
      column: $table.availableConnectors, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);
}

class $$CachedStationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedStationsTableTable,
    CachedStation,
    $$CachedStationsTableTableFilterComposer,
    $$CachedStationsTableTableOrderingComposer,
    $$CachedStationsTableTableAnnotationComposer,
    $$CachedStationsTableTableCreateCompanionBuilder,
    $$CachedStationsTableTableUpdateCompanionBuilder,
    (
      CachedStation,
      BaseReferences<_$AppDatabase, $CachedStationsTableTable, CachedStation>
    ),
    CachedStation,
    PrefetchHooks Function()> {
  $$CachedStationsTableTableTableManager(
      _$AppDatabase db, $CachedStationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedStationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedStationsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedStationsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> totalConnectors = const Value.absent(),
            Value<int> availableConnectors = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedStationsTableCompanion(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            status: status,
            totalConnectors: totalConnectors,
            availableConnectors: availableConnectors,
            address: address,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double latitude,
            required double longitude,
            required String status,
            required int totalConnectors,
            required int availableConnectors,
            Value<String?> address = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedStationsTableCompanion.insert(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            status: status,
            totalConnectors: totalConnectors,
            availableConnectors: availableConnectors,
            address: address,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedStationsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedStationsTableTable,
    CachedStation,
    $$CachedStationsTableTableFilterComposer,
    $$CachedStationsTableTableOrderingComposer,
    $$CachedStationsTableTableAnnotationComposer,
    $$CachedStationsTableTableCreateCompanionBuilder,
    $$CachedStationsTableTableUpdateCompanionBuilder,
    (
      CachedStation,
      BaseReferences<_$AppDatabase, $CachedStationsTableTable, CachedStation>
    ),
    CachedStation,
    PrefetchHooks Function()>;
typedef $$UserPreferencesTableTableCreateCompanionBuilder
    = UserPreferencesTableCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$UserPreferencesTableTableUpdateCompanionBuilder
    = UserPreferencesTableCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$UserPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$UserPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$UserPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$UserPreferencesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserPreferencesTableTable,
    UserPreference,
    $$UserPreferencesTableTableFilterComposer,
    $$UserPreferencesTableTableOrderingComposer,
    $$UserPreferencesTableTableAnnotationComposer,
    $$UserPreferencesTableTableCreateCompanionBuilder,
    $$UserPreferencesTableTableUpdateCompanionBuilder,
    (
      UserPreference,
      BaseReferences<_$AppDatabase, $UserPreferencesTableTable, UserPreference>
    ),
    UserPreference,
    PrefetchHooks Function()> {
  $$UserPreferencesTableTableTableManager(
      _$AppDatabase db, $UserPreferencesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPreferencesTableCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPreferencesTableCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserPreferencesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UserPreferencesTableTable,
        UserPreference,
        $$UserPreferencesTableTableFilterComposer,
        $$UserPreferencesTableTableOrderingComposer,
        $$UserPreferencesTableTableAnnotationComposer,
        $$UserPreferencesTableTableCreateCompanionBuilder,
        $$UserPreferencesTableTableUpdateCompanionBuilder,
        (
          UserPreference,
          BaseReferences<_$AppDatabase, $UserPreferencesTableTable,
              UserPreference>
        ),
        UserPreference,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChargingHistoryTableTableTableManager get chargingHistoryTable =>
      $$ChargingHistoryTableTableTableManager(_db, _db.chargingHistoryTable);
  $$CachedStationsTableTableTableManager get cachedStationsTable =>
      $$CachedStationsTableTableTableManager(_db, _db.cachedStationsTable);
  $$UserPreferencesTableTableTableManager get userPreferencesTable =>
      $$UserPreferencesTableTableTableManager(_db, _db.userPreferencesTable);
}
