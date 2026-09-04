import 'package:flutter/foundation.dart';
import 'package:zetra/features/wallet/models/wallet_model.dart';

enum WalletStatus { initial, loading, loaded, paying, success, error }

enum WalletTransactionFilter { all, credits, debits }

typedef WalletTransaction = WalletTransactionModel;

@immutable
class WalletState {

  final WalletStatus status;
  final String walletId;
  final int balancePaise;
  final double balance;
  final bool isLowBalance;
  final List<WalletTransactionModel> recentTransactions;
  final int transactionPage;
  final bool hasMoreTransactions;
  final bool isLoadingTransactions;
  final WalletTransactionFilter transactionFilter;
  final String enteredAmount;
  final int? selectedQuickAmount;
  final String selectedPaymentMethod;
  final String? checkoutUrl;
  final String? paymentId;
  final String? errorMessage;

  const WalletState({
    required this.status,
    required this.walletId,
    required this.balancePaise,
    required this.balance,
    required this.isLowBalance,
    required this.recentTransactions,
    required this.transactionPage,
    required this.hasMoreTransactions,
    required this.isLoadingTransactions,
    required this.transactionFilter,
    required this.enteredAmount,
    this.selectedQuickAmount,
    required this.selectedPaymentMethod,
    this.checkoutUrl,
    this.paymentId,
    this.errorMessage
  });

  factory WalletState.initial() {

    return const WalletState(
      status: WalletStatus.initial,
      walletId: '',
      balancePaise: 0,
      balance: 0,
      isLowBalance: true,
      recentTransactions: <WalletTransactionModel>[],
      transactionPage: 1,
      hasMoreTransactions: false,
      isLoadingTransactions: false,
      transactionFilter: WalletTransactionFilter.all,
      enteredAmount: '500',
      selectedQuickAmount: 500,
      selectedPaymentMethod: 'UPI'
    );

  }

  List<WalletTransactionModel> get filteredTransactions {

    switch (transactionFilter) {

      case WalletTransactionFilter.credits:
        return recentTransactions.where((WalletTransactionModel txn) => txn.isCredit).toList();

      case WalletTransactionFilter.debits:
        return recentTransactions.where((WalletTransactionModel txn) => !txn.isCredit).toList();

      case WalletTransactionFilter.all:
        return recentTransactions;

    }

  }

  WalletState copyWith({
    WalletStatus? status,
    String? walletId,
    int? balancePaise,
    double? balance,
    bool? isLowBalance,
    List<WalletTransactionModel>? recentTransactions,
    int? transactionPage,
    bool? hasMoreTransactions,
    bool? isLoadingTransactions,
    WalletTransactionFilter? transactionFilter,
    String? enteredAmount,
    int? selectedQuickAmount,
    bool clearQuickAmount = false,
    String? selectedPaymentMethod,
    String? checkoutUrl,
    bool clearCheckoutUrl = false,
    String? paymentId,
    String? errorMessage,
    bool clearError = false
  }) {

    return WalletState(
      status: status ?? this.status,
      walletId: walletId ?? this.walletId,
      balancePaise: balancePaise ?? this.balancePaise,
      balance: balance ?? this.balance,
      isLowBalance: isLowBalance ?? this.isLowBalance,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      transactionPage: transactionPage ?? this.transactionPage,
      hasMoreTransactions: hasMoreTransactions ?? this.hasMoreTransactions,
      isLoadingTransactions: isLoadingTransactions ?? this.isLoadingTransactions,
      transactionFilter: transactionFilter ?? this.transactionFilter,
      enteredAmount: enteredAmount ?? this.enteredAmount,
      selectedQuickAmount: clearQuickAmount ? null : (selectedQuickAmount ?? this.selectedQuickAmount),
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      checkoutUrl: clearCheckoutUrl ? null : (checkoutUrl ?? this.checkoutUrl),
      paymentId: paymentId ?? this.paymentId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage)
    );

  }

}