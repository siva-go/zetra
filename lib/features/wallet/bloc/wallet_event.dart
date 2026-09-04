import 'package:flutter/foundation.dart';
import 'package:zetra/features/wallet/bloc/wallet_state.dart';

@immutable
abstract class WalletEvent {

  const WalletEvent();

}

class WalletInitialized extends WalletEvent {

  const WalletInitialized();

}

class WalletLoadRequested extends WalletEvent {

  const WalletLoadRequested();

}

class WalletTransactionsLoadMore extends WalletEvent {

  const WalletTransactionsLoadMore();

}

class AddMoneyNavigated extends WalletEvent {

  const AddMoneyNavigated();

}

class AmountChanged extends WalletEvent {

  final String amount;
  const AmountChanged(this.amount);

}

class QuickAmountSelected extends WalletEvent {

  final int amount;
  const QuickAmountSelected(this.amount);

}

class PaymentMethodSelected extends WalletEvent {

  final String method;
  const PaymentMethodSelected(this.method);

}

class WalletTopupInitiated extends WalletEvent {

  final int amountPaise;
  const WalletTopupInitiated(this.amountPaise);

}

class PaymentInitiated extends WalletEvent {

  const PaymentInitiated();

}

class PaymentResultReceived extends WalletEvent {

  final bool success;
  const PaymentResultReceived(this.success);

}

class WalletVoucherRedeemed extends WalletEvent {

  final String code;
  const WalletVoucherRedeemed(this.code);

}

class WalletTopupVerified extends WalletEvent {

  final String paymentId;
  const WalletTopupVerified(this.paymentId);

}

class WalletTransactionFilterChanged extends WalletEvent {

  final WalletTransactionFilter filter;
  const WalletTransactionFilterChanged(this.filter);

}