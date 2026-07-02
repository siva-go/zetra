import 'package:flutter/foundation.dart';

@immutable
abstract class WalletEvent {
  const WalletEvent();
}

/// Fired when the wallet screen is first loaded.
class WalletInitialized extends WalletEvent {
  const WalletInitialized();
}

/// Fired when the user navigates to the Add Money screen.
class AddMoneyNavigated extends WalletEvent {
  const AddMoneyNavigated();
}

/// Fired when the entered amount changes.
class AmountChanged extends WalletEvent {
  final String amount;
  const AmountChanged(this.amount);
}

/// Fired when a quick-select chip is tapped (₹500 / ₹1000 / ₹2000).
class QuickAmountSelected extends WalletEvent {
  final int amount;
  const QuickAmountSelected(this.amount);
}

/// Fired when a payment method is selected.
class PaymentMethodSelected extends WalletEvent {
  final String method;
  const PaymentMethodSelected(this.method);
}

/// Fired when the user confirms payment.
class PaymentInitiated extends WalletEvent {
  const PaymentInitiated();
}

/// Fired after payment success/failure is received.
class PaymentResultReceived extends WalletEvent {
  final bool success;
  const PaymentResultReceived(this.success);
}
