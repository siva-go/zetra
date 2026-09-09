import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/features/charging/bloc/invoice_event.dart';
import 'package:zetra/features/charging/bloc/invoice_state.dart';
import 'package:zetra/features/charging/models/invoice_model.dart';
import 'package:zetra/features/wallet/repository/invoice_repository.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {

  final InvoiceRepository _repository;

  InvoiceBloc(this._repository) : super(InvoiceState.initial()) {

    on<InvoiceInitialized>((InvoiceInitialized event, Emitter<InvoiceState> emit) {
      add(InvoiceFetchRequested(invoiceId: event.invoiceId));
    });

    on<InvoiceFetchRequested>(_onFetchRequested);
    on<InvoiceDownloadPdfRequested>(_onDownloadPdfRequested);

  }

  Future<void> _onFetchRequested(InvoiceFetchRequested event, Emitter<InvoiceState> emit) async {

    emit(state.copyWith(
      status: InvoiceStatus.loading,
      clearError: true,
      clearDownloadedPdf: true
    ));

    final String? id = event.invoiceId;

    if (id != null && id.isNotEmpty) {

      final Result<InvoiceDetailModel> result = await _repository.fetchInvoiceDetail(id);

      if (result.isSuccess && result.dataOrNull != null) {

        emit(state.copyWith(
          status: InvoiceStatus.success,
          invoice: result.dataOrNull
        ));

      } else {

        emit(state.copyWith(
          status: InvoiceStatus.failure,
          errorMessage: result.failureOrNull?.toString() ?? 'Failed to load invoice details'
        ));

      }

    } else {

      final Result<InvoiceDetailModel> latestResult = await _repository.fetchLatestInvoice();

      if (latestResult.isSuccess && latestResult.dataOrNull != null) {

        emit(state.copyWith(
          status: InvoiceStatus.success,
          invoice: latestResult.dataOrNull
        ));

      } else {

        emit(state.copyWith(
          status: InvoiceStatus.failure,
          errorMessage: latestResult.failureOrNull?.toString() ?? 'No invoice available'
        ));

      }

    }

  }

  Future<void> _onDownloadPdfRequested(InvoiceDownloadPdfRequested event, Emitter<InvoiceState> emit) async {

    emit(state.copyWith(
      isDownloadingPdf: true,
      clearError: true,
      clearDownloadedPdf: true
    ));

    final Result<String> result = await _repository.downloadInvoicePdf(event.invoiceId);

    if (result.isSuccess && result.dataOrNull != null) {

      emit(state.copyWith(
        isDownloadingPdf: false,
        downloadedPdfPath: result.dataOrNull
      ));

    } else {

      emit(state.copyWith(
        isDownloadingPdf: false,
        errorMessage: result.failureOrNull?.toString() ?? 'Failed to download invoice PDF'
      ));

    }

  }

}