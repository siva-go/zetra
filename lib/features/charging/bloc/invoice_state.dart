import 'package:flutter/foundation.dart';
import 'package:zetra/features/charging/models/invoice_model.dart';

enum InvoiceStatus { initial, loading, success, failure }

@immutable
class InvoiceState {

  final InvoiceStatus status;
  final InvoiceDetailModel? invoice;
  final bool isDownloadingPdf;
  final String? downloadedPdfPath;
  final String? errorMessage;

  const InvoiceState({
    this.status = InvoiceStatus.initial,
    this.invoice,
    this.isDownloadingPdf = false,
    this.downloadedPdfPath,
    this.errorMessage
  });

  factory InvoiceState.initial() {

    return const InvoiceState();

  }

  InvoiceState copyWith({InvoiceStatus? status, InvoiceDetailModel? invoice, bool? isDownloadingPdf, String? downloadedPdfPath, String? errorMessage, bool clearError = false, bool clearDownloadedPdf = false}) {

    return InvoiceState(
      status: status ?? this.status,
      invoice: invoice ?? this.invoice,
      isDownloadingPdf: isDownloadingPdf ?? this.isDownloadingPdf,
      downloadedPdfPath: clearDownloadedPdf ? null : (downloadedPdfPath ?? this.downloadedPdfPath),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage)
    );

  }

}