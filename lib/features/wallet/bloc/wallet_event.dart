import 'package:flutter/foundation.dart';

@immutable
abstract class WalletEvent {

  const WalletEvent();

}

class WalletInitialized extends WalletEvent {

  const WalletInitialized();

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

class PaymentInitiated extends WalletEvent {

  const PaymentInitiated();

}

class PaymentResultReceived extends WalletEvent {

  final bool success;

  const PaymentResultReceived(this.success);

}