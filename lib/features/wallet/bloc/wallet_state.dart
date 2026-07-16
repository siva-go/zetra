import 'package:flutter/foundation.dart';

enum WalletStatus { initial, loading, loaded, paying, success, error }

@immutable
class WalletTransaction {

  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final bool isCredit;
  final DateTime date;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.date
  });

}

@immutable
class WalletState {

  final WalletStatus status;
  final double balance;
  final bool isLowBalance;
  final List<WalletTransaction> recentTransactions;
  final String enteredAmount;
  final int? selectedQuickAmount;
  final String selectedPaymentMethod;
  final String? errorMessage;

  const WalletState({
    required this.status,
    required this.balance,
    required this.isLowBalance,
    required this.recentTransactions,
    required this.enteredAmount,
    this.selectedQuickAmount,
    required this.selectedPaymentMethod,
    this.errorMessage
  });

  factory WalletState.initial() {

    return WalletState(
      status: WalletStatus.initial,
      balance: 100,
      isLowBalance: true,
      recentTransactions: <WalletTransaction>[
        WalletTransaction(
          id: 'txn1',
          title: 'ZETRA GreenCharge Hub',
          subtitle: 'May 26, 2024',
          amount: 120,
          isCredit: false,
          date: DateTime(2024, 5, 26)
        ),
        WalletTransaction(
          id: 'txn2',
          title: 'Added to Wallet',
          subtitle: 'May 24, 2024',
          amount: 500,
          isCredit: true,
          date: DateTime(2024, 5, 24)
        ),
        WalletTransaction(
          id: 'txn3',
          title: 'ZETRA EcoPower Station',
          subtitle: 'May 22, 2024',
          amount: 142,
          isCredit: false,
          date: DateTime(2024, 5, 22)
        ),
        WalletTransaction(
          id: 'txn4',
          title: 'Added to Wallet',
          subtitle: 'May 18, 2024',
          amount: 1000,
          isCredit: true,
          date: DateTime(2024, 5, 18)
        )
      ],
      enteredAmount: '500',
      selectedQuickAmount: 500,
      selectedPaymentMethod: 'UPI'
    );

  }

  WalletState copyWith({WalletStatus? status, double? balance, bool? isLowBalance, List<WalletTransaction>? recentTransactions, String? enteredAmount, int? selectedQuickAmount, bool clearQuickAmount = false, String? selectedPaymentMethod, String? errorMessage, bool clearError = false}) {

    return WalletState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      isLowBalance: isLowBalance ?? this.isLowBalance,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      enteredAmount: enteredAmount ?? this.enteredAmount,
      selectedQuickAmount: clearQuickAmount ? null : (selectedQuickAmount ?? this.selectedQuickAmount),
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage)
    );

  }

}