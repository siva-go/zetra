import 'package:flutter/foundation.dart';
import 'package:zetra/features/charging/models/invoice_model.dart';

enum InvoiceStatus { initial, loading, success, failure }

@immutable
class InvoiceState {

  final InvoiceStatus status;
  final InvoiceDetailModel? invoice;
  final String? errorMessage;

  const InvoiceState({
    this.status = InvoiceStatus.initial,
    this.invoice,
    this.errorMessage,
  });

  factory InvoiceState.initial() {
    return const InvoiceState();
  }

  InvoiceState copyWith({
    InvoiceStatus? status,
    InvoiceDetailModel? invoice,
    String? errorMessage,
    bool clearError = false
  }) {

    return InvoiceState(
      status: status ?? this.status,
      invoice: invoice ?? this.invoice,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage)
    );

  }

}
