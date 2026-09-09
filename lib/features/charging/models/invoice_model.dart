import 'package:zetra/features/charging/models/charging_session_model.dart';

class InvoiceTariffSnapshotModel {

  final String? id;
  final String? name;
  final String? taxRegion;
  final double pricePerKwh;
  final double pricePerMinute;
  final double connectionFee;

  const InvoiceTariffSnapshotModel({
    this.id,
    this.name,
    this.taxRegion,
    this.pricePerKwh = 0.0,
    this.pricePerMinute = 0.0,
    this.connectionFee = 0.0
  });

  factory InvoiceTariffSnapshotModel.fromJson(Map<String, dynamic> json) {

    return InvoiceTariffSnapshotModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      taxRegion: json['taxRegion']?.toString(),
      pricePerKwh: double.tryParse(json['pricePerKwh']?.toString() ?? '') ?? 0.0,
      pricePerMinute: double.tryParse(json['pricePerMinute']?.toString() ?? '') ?? 0.0,
      connectionFee: double.tryParse(json['connectionFee']?.toString() ?? '') ?? 0.0
    );

  }

}

class InvoiceOrganizationSnapshotModel {

  final String? name;
  final String? legalName;
  final String? tradeName;
  final String? gstNumber;
  final String? address;
  final String? state;
  final String? stateCode;
  final String? supportEmail;
  final String? supportPhone;
  final String? logoUrl;
  final String? invoiceFooter;

  const InvoiceOrganizationSnapshotModel({
    this.name,
    this.legalName,
    this.tradeName,
    this.gstNumber,
    this.address,
    this.state,
    this.stateCode,
    this.supportEmail,
    this.supportPhone,
    this.logoUrl,
    this.invoiceFooter
  });

  factory InvoiceOrganizationSnapshotModel.fromJson(Map<String, dynamic> json) {

    return InvoiceOrganizationSnapshotModel(
      name: json['name']?.toString(),
      legalName: json['legalName']?.toString(),
      tradeName: json['tradeName']?.toString(),
      gstNumber: json['gstNumber']?.toString(),
      address: json['address']?.toString(),
      state: json['state']?.toString(),
      stateCode: json['stateCode']?.toString(),
      supportEmail: json['supportEmail']?.toString(),
      supportPhone: json['supportPhone']?.toString(),
      logoUrl: json['logoUrl']?.toString(),
      invoiceFooter: json['invoiceFooter']?.toString()
    );

  }

}

class InvoiceListItemModel {

  final String id;
  final String invoiceNumber;
  final String status;
  final String type;
  final DateTime invoiceDate;
  final String currency;
  final int grandTotalPaise;
  final double grandTotal;
  final int taxableAmountPaise;
  final double taxableAmount;
  final int totalTaxPaise;
  final double totalTax;
  final int refundedAmountPaise;
  final bool isInterState;
  final String? sessionId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? vehicleNumber;
  final String? stationName;
  final String? chargePointId;
  final bool pdfAvailable;

  const InvoiceListItemModel({
    required this.id,
    required this.invoiceNumber,
    required this.status,
    required this.type,
    required this.invoiceDate,
    required this.currency,
    required this.grandTotalPaise,
    required this.grandTotal,
    required this.taxableAmountPaise,
    required this.taxableAmount,
    required this.totalTaxPaise,
    required this.totalTax,
    required this.refundedAmountPaise,
    required this.isInterState,
    this.sessionId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.vehicleNumber,
    this.stationName,
    this.chargePointId,
    required this.pdfAvailable
  });

  factory InvoiceListItemModel.fromJson(Map<String, dynamic> json) {

    int parsePaise(dynamic val) {

      if (val is num) {

        return val.toInt();

      }

      if (val != null) {

        return int.tryParse(val.toString()) ?? 0;

      }

      return 0;

    }

    final int grandPaise = parsePaise(json['grandTotalPaise']);
    final int taxPaise = parsePaise(json['taxableAmountPaise']);
    final int totalTaxP = parsePaise(json['totalTaxPaise']);

    return InvoiceListItemModel(
      id: json['id']?.toString() ?? '',
      invoiceNumber: json['invoiceNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PAID',
      type: json['type']?.toString() ?? 'SESSION',
      invoiceDate: json['invoiceDate'] != null ? DateTime.tryParse(json['invoiceDate'].toString()) ?? DateTime.now() : DateTime.now(),
      currency: json['currency']?.toString() ?? 'INR',
      grandTotalPaise: grandPaise,
      grandTotal: grandPaise / 100.0,
      taxableAmountPaise: taxPaise,
      taxableAmount: taxPaise / 100.0,
      totalTaxPaise: totalTaxP,
      totalTax: totalTaxP / 100.0,
      refundedAmountPaise: parsePaise(json['refundedAmountPaise']),
      isInterState: json['isInterState'] == true,
      sessionId: json['sessionId']?.toString(),
      customerName: json['customerName']?.toString(),
      customerEmail: json['customerEmail']?.toString(),
      customerPhone: json['customerPhone']?.toString(),
      vehicleNumber: json['vehicleNumber']?.toString(),
      stationName: json['stationName']?.toString(),
      chargePointId: json['chargePointId']?.toString(),
      pdfAvailable: json['pdfAvailable'] == true
    );

  }

  factory InvoiceListItemModel.fromSession(ChargingSessionModel session) {

    return InvoiceListItemModel(
      id: session.id,
      invoiceNumber: 'INV-${session.id.toUpperCase().split('-').first}',
      status: session.status,
      type: 'SESSION',
      invoiceDate: session.endTime ?? session.startTime,
      currency: 'INR',
      grandTotalPaise: session.totalCostPaise,
      grandTotal: session.totalCost,
      taxableAmountPaise: session.totalCostPaise,
      taxableAmount: session.totalCost,
      totalTaxPaise: 0,
      totalTax: 0,
      refundedAmountPaise: 0,
      isInterState: false,
      sessionId: session.id,
      stationName: session.stationName,
      chargePointId: session.stationId,
      pdfAvailable: false
    );

  }

}

class InvoiceDetailModel {

  final String id;
  final String invoiceNumber;
  final String status;
  final String type;
  final DateTime invoiceDate;
  final String currency;
  final int grandTotalPaise;
  final double grandTotal;
  final int taxableAmountPaise;
  final double taxableAmount;
  final int totalTaxPaise;
  final double totalTax;
  final int refundedAmountPaise;
  final bool isInterState;
  final String? sessionId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? vehicleNumber;
  final String? stationName;
  final String? chargePointId;
  final bool pdfAvailable;
  final int energyChargePaise;
  final int timeChargePaise;
  final int connectionFeePaise;
  final int discountPaise;
  final double? cgstRate;
  final int cgstAmountPaise;
  final double? sgstRate;
  final int sgstAmountPaise;
  final double? igstRate;
  final int igstAmountPaise;
  final String? placeOfSupply;
  final double energyDeliveredKwh;
  final int durationSeconds;
  final String? walletTransactionId;
  final InvoiceTariffSnapshotModel? tariffSnapshot;
  final InvoiceOrganizationSnapshotModel? organizationSnapshot;
  final DateTime? generatedAt;

  const InvoiceDetailModel({
    required this.id,
    required this.invoiceNumber,
    required this.status,
    required this.type,
    required this.invoiceDate,
    required this.currency,
    required this.grandTotalPaise,
    required this.grandTotal,
    required this.taxableAmountPaise,
    required this.taxableAmount,
    required this.totalTaxPaise,
    required this.totalTax,
    required this.refundedAmountPaise,
    required this.isInterState,
    this.sessionId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.vehicleNumber,
    this.stationName,
    this.chargePointId,
    required this.pdfAvailable,
    required this.energyChargePaise,
    required this.timeChargePaise,
    required this.connectionFeePaise,
    required this.discountPaise,
    this.cgstRate,
    required this.cgstAmountPaise,
    this.sgstRate,
    required this.sgstAmountPaise,
    this.igstRate,
    required this.igstAmountPaise,
    this.placeOfSupply,
    required this.energyDeliveredKwh,
    required this.durationSeconds,
    this.walletTransactionId,
    this.tariffSnapshot,
    this.organizationSnapshot,
    this.generatedAt
  });

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> rawJson) {

    final Map<String, dynamic> json = (rawJson.containsKey('data') && rawJson['data'] is Map<String, dynamic>)
        ? rawJson['data'] as Map<String, dynamic> : rawJson;

    int parsePaise(dynamic val) {

      if (val is num) {

        return val.toInt();

      }

      if (val != null) {

        return int.tryParse(val.toString()) ?? 0;

      }

      return 0;

    }

    double? parseRate(dynamic val) {

      if (val is num) {

        return val.toDouble();

      }

      if (val != null) {

        return double.tryParse(val.toString());

      }

      return null;

    }

    final int grandPaise = parsePaise(json['grandTotalPaise']);
    final int taxPaise = parsePaise(json['taxableAmountPaise']);
    final int totalTaxP = parsePaise(json['totalTaxPaise']);

    double energyKwh = 0;
    final dynamic rawEnergy = json['energyDeliveredWh'];

    if (rawEnergy is num) {

      energyKwh = rawEnergy.toDouble() / 1000.0;

    } else if (rawEnergy != null) {

      final double wh = double.tryParse(rawEnergy.toString()) ?? 0.0;
      energyKwh = wh / 1000.0;

    }

    int durationSec = 0;
    final dynamic rawDuration = json['durationSeconds'];

    if (rawDuration is num) {

      durationSec = rawDuration.toInt();

    } else if (rawDuration != null) {

      durationSec = int.tryParse(rawDuration.toString()) ?? 0;

    }

    return InvoiceDetailModel(
      id: json['id']?.toString() ?? '',
      invoiceNumber: json['invoiceNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PAID',
      type: json['type']?.toString() ?? 'SESSION',
      invoiceDate: json['invoiceDate'] != null
          ? DateTime.tryParse(json['invoiceDate'].toString()) ?? DateTime.now() : DateTime.now(),
      currency: json['currency']?.toString() ?? 'INR',
      grandTotalPaise: grandPaise,
      grandTotal: grandPaise / 100.0,
      taxableAmountPaise: taxPaise,
      taxableAmount: taxPaise / 100.0,
      totalTaxPaise: totalTaxP,
      totalTax: totalTaxP / 100.0,
      refundedAmountPaise: parsePaise(json['refundedAmountPaise']),
      isInterState: json['isInterState'] == true,
      sessionId: json['sessionId']?.toString(),
      customerName: json['customerName']?.toString(),
      customerEmail: json['customerEmail']?.toString(),
      customerPhone: json['customerPhone']?.toString(),
      vehicleNumber: json['vehicleNumber']?.toString(),
      stationName: json['stationName']?.toString(),
      chargePointId: json['chargePointId']?.toString(),
      pdfAvailable: json['pdfAvailable'] == true,
      energyChargePaise: parsePaise(json['energyChargePaise']),
      timeChargePaise: parsePaise(json['timeChargePaise']),
      connectionFeePaise: parsePaise(json['connectionFeePaise']),
      discountPaise: parsePaise(json['discountPaise']),
      cgstRate: parseRate(json['cgstRate']),
      cgstAmountPaise: parsePaise(json['cgstAmountPaise']),
      sgstRate: parseRate(json['sgstRate']),
      sgstAmountPaise: parsePaise(json['sgstAmountPaise']),
      igstRate: parseRate(json['igstRate']),
      igstAmountPaise: parsePaise(json['igstAmountPaise']),
      placeOfSupply: json['placeOfSupply']?.toString(),
      energyDeliveredKwh: energyKwh,
      durationSeconds: durationSec,
      walletTransactionId: json['walletTransactionId']?.toString(),
      tariffSnapshot: json['tariffSnapshot'] is Map<String, dynamic>
          ? InvoiceTariffSnapshotModel.fromJson(json['tariffSnapshot'] as Map<String, dynamic>) : null,
      organizationSnapshot: json['organizationSnapshot'] is Map<String, dynamic>
          ? InvoiceOrganizationSnapshotModel.fromJson(json['organizationSnapshot'] as Map<String, dynamic>) : null,
      generatedAt: json['generatedAt'] != null
          ? DateTime.tryParse(json['generatedAt'].toString()) : null
    );

  }

  factory InvoiceDetailModel.fromSession(ChargingSessionModel session) {

    return InvoiceDetailModel(
      id: session.id,
      invoiceNumber: 'INV-${session.id.toUpperCase().split('-').first}',
      status: session.status,
      type: 'SESSION',
      invoiceDate: session.endTime ?? session.startTime,
      currency: 'INR',
      grandTotalPaise: session.totalCostPaise,
      grandTotal: session.totalCost,
      taxableAmountPaise: session.totalCostPaise,
      taxableAmount: session.totalCost,
      totalTaxPaise: 0,
      totalTax: 0,
      refundedAmountPaise: 0,
      isInterState: false,
      sessionId: session.id,
      stationName: session.stationName,
      chargePointId: session.stationId,
      pdfAvailable: false,
      energyChargePaise: session.totalCostPaise,
      timeChargePaise: 0,
      connectionFeePaise: 0,
      discountPaise: 0,
      cgstAmountPaise: 0,
      sgstAmountPaise: 0,
      igstAmountPaise: 0,
      energyDeliveredKwh: session.energyConsumedKwh,
      durationSeconds: session.durationSeconds,
      generatedAt: session.endTime ?? session.startTime
    );

  }

}