import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/features/wallet/bloc/wallet_event.dart';
import 'package:zetra/features/wallet/bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {

  WalletBloc() : super(WalletState.initial()) {
    on<WalletInitialized>(_onInitialized);
    on<AmountChanged>(_onAmountChanged);
    on<QuickAmountSelected>(_onQuickAmountSelected);
    on<PaymentMethodSelected>(_onPaymentMethodSelected);
    on<PaymentInitiated>(_onPaymentInitiated);
    on<PaymentResultReceived>(_onPaymentResultReceived);
  }

  void _onInitialized(WalletInitialized event, Emitter<WalletState> emit) {

    emit(state.copyWith(
        status: WalletStatus.loaded
    ));

  }

  void _onAmountChanged(AmountChanged event, Emitter<WalletState> emit) {

    emit(state.copyWith(
      enteredAmount: event.amount,
      clearQuickAmount: true,
      clearError: true
    ));

  }

  void _onQuickAmountSelected(QuickAmountSelected event, Emitter<WalletState> emit) {

    emit(state.copyWith(
      selectedQuickAmount: event.amount,
      enteredAmount: event.amount.toString(),
      clearError: true
    ));

  }

  void _onPaymentMethodSelected(PaymentMethodSelected event, Emitter<WalletState> emit) {

    emit(state.copyWith(
        selectedPaymentMethod: event.method
    ));

  }

  Future<void> _onPaymentInitiated(PaymentInitiated event, Emitter<WalletState> emit) async {

    final double amount = double.tryParse(state.enteredAmount) ?? 0;

    if (amount <= 0) {

      emit(state.copyWith(
          errorMessage: 'Please enter a valid amount'
      ));

      return;

    }

    emit(state.copyWith(
        status: WalletStatus.paying,
        clearError: true
    ));

    await Future<void>.delayed(const Duration(
        milliseconds: 1500
    ));

    if (amount == 999) {

      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: 'Transaction declined by bank'
      ));

      return;

    }

    final double newBalance = state.balance + amount;

    emit(state.copyWith(
      status: WalletStatus.success,
      balance: newBalance,
      isLowBalance: newBalance < 200
    ));

  }

  void _onPaymentResultReceived(PaymentResultReceived event, Emitter<WalletState> emit) {

    emit(state.copyWith(
        status: WalletStatus.loaded,
        clearError: true
    ));

  }

}