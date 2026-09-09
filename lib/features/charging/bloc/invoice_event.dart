import 'package:flutter/foundation.dart';

@immutable
abstract class InvoiceEvent {

  const InvoiceEvent();

}

class InvoiceInitialized extends InvoiceEvent {

  final String? invoiceId;

  const InvoiceInitialized({this.invoiceId});

}

class InvoiceFetchRequested extends InvoiceEvent {

  final String? invoiceId;

  const InvoiceFetchRequested({this.invoiceId});

}

class InvoiceDownloadPdfRequested extends InvoiceEvent {

  final String invoiceId;

  const InvoiceDownloadPdfRequested({required this.invoiceId});

}