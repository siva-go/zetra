import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/features/wallet/bloc/wallet_event.dart';
import 'package:zetra/features/wallet/bloc/wallet_state.dart';
import 'package:zetra/features/wallet/models/wallet_model.dart';
import 'package:zetra/features/wallet/repository/wallet_repository.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {

  final WalletRepository _repository;

  WalletBloc(this._repository) : super(WalletState.initial()) {
    on<WalletInitialized>((WalletInitialized event, Emitter<WalletState> emit) => add(const WalletLoadRequested()));
    on<WalletLoadRequested>(_onLoadRequested);
    on<WalletTransactionsLoadMore>(_onLoadMoreTransactions);
    on<AmountChanged>(_onAmountChanged);
    on<QuickAmountSelected>(_onQuickAmountSelected);
    on<PaymentMethodSelected>(_onPaymentMethodSelected);
    on<PaymentInitiated>(_onPaymentInitiated);
    on<WalletTopupInitiated>(_onTopupInitiated);
    on<WalletVoucherRedeemed>(_onVoucherRedeemed);
    on<WalletTopupVerified>(_onTopupVerified);
    on<PaymentResultReceived>(_onPaymentResultReceived);
    on<WalletTransactionFilterChanged>(_onTransactionFilterChanged);
  }

  Future<void> _onLoadRequested(WalletLoadRequested event, Emitter<WalletState> emit) async {

    emit(state.copyWith(
        status: WalletStatus.loading
    ));

    final Result<WalletModel> walletRes = await _repository.fetchWallet();
    final Result<WalletTransactionsPage> txnsRes = await _repository.fetchTransactions();

    if (walletRes.isSuccess) {

      final WalletModel wallet = walletRes.dataOrNull!;
      final List<WalletTransactionModel> txns = txnsRes.dataOrNull?.data ?? <WalletTransactionModel>[];
      final bool hasMore = txnsRes.dataOrNull?.hasMore ?? false;

      emit(state.copyWith(
        status: WalletStatus.loaded,
        walletId: wallet.id,
        balancePaise: wallet.balancePaise,
        balance: wallet.balance,
        isLowBalance: wallet.balancePaise < 20000,
        recentTransactions: txns,
        transactionPage: 1,
        hasMoreTransactions: hasMore
      ));

    } else {

      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: walletRes.failureOrNull?.toString() ?? 'Failed to load wallet details'
      ));

    }

  }

  Future<void> _onLoadMoreTransactions(WalletTransactionsLoadMore event, Emitter<WalletState> emit) async {

    if (!state.hasMoreTransactions || state.isLoadingTransactions) {

      return;

    }

    emit(state.copyWith(
        isLoadingTransactions: true
    ));

    final int nextPage = state.transactionPage + 1;
    final Result<WalletTransactionsPage> res = await _repository.fetchTransactions(
        page: nextPage
    );

    if (res.isSuccess) {

      final WalletTransactionsPage page = res.dataOrNull!;
      emit(state.copyWith(
        recentTransactions: <WalletTransactionModel>[...state.recentTransactions, ...page.data],
        transactionPage: nextPage,
        hasMoreTransactions: page.hasMore,
        isLoadingTransactions: false
      ));

    } else {

      emit(state.copyWith(
          isLoadingTransactions: false
      ));

    }

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

    final int amountPaise = (amount * 100).round();
    add(WalletTopupInitiated(amountPaise));

  }

  Future<void> _onTopupInitiated(WalletTopupInitiated event, Emitter<WalletState> emit) async {

    emit(state.copyWith(
        status: WalletStatus.paying,
        clearError: true,
        clearCheckoutUrl: true
    ));

    final String idempotencyKey = 'topup_${DateTime.now().millisecondsSinceEpoch}';
    final Result<TopupResponseModel> res = await _repository.initiateTopup(
      amountPaise: event.amountPaise,
      idempotencyKey: idempotencyKey
    );

    if (res.isSuccess) {

      final TopupResponseModel topup = res.dataOrNull!;
      emit(state.copyWith(
        status: WalletStatus.loaded,
        checkoutUrl: topup.checkoutUrl,
        paymentId: topup.paymentId
      ));

    } else {

      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: res.failureOrNull?.toString() ?? 'Failed to initiate wallet top-up'
      ));

    }

  }

  Future<void> _onVoucherRedeemed(WalletVoucherRedeemed event, Emitter<WalletState> emit) async {

    emit(state.copyWith(
        status: WalletStatus.loading,
        clearError: true
    ));

    final Result<WalletModel> res = await _repository.redeemVoucher(event.code);

    if (res.isSuccess) {

      final WalletModel wallet = res.dataOrNull!;
      emit(state.copyWith(
        status: WalletStatus.success,
        balancePaise: wallet.balancePaise,
        balance: wallet.balance,
        isLowBalance: wallet.balancePaise < 20000
      ));

      add(const WalletLoadRequested());

    } else {

      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: res.failureOrNull?.toString() ?? 'Voucher redemption failed'
      ));

    }

  }

  Future<void> _onTopupVerified(WalletTopupVerified event, Emitter<WalletState> emit) async {

    emit(state.copyWith(
        status: WalletStatus.loading,
        clearError: true
    ));

    final Result<void> res = await _repository.verifyTopup(event.paymentId);

    if (res.isSuccess) {

      add(const WalletLoadRequested());

    } else {

      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: res.failureOrNull?.toString() ?? 'Verification failed'
      ));

    }

  }

  void _onPaymentResultReceived(PaymentResultReceived event, Emitter<WalletState> emit) {

    emit(state.copyWith(
        status: WalletStatus.loaded,
        clearError: true
    ));

  }

  void _onTransactionFilterChanged(WalletTransactionFilterChanged event, Emitter<WalletState> emit) {

    emit(state.copyWith(
      transactionFilter: event.filter,
    ));

  }

}