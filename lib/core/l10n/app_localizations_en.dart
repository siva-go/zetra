// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ZETRA';

  @override
  String get navHome => 'Home';

  @override
  String get navScanQr => 'Scan QR';

  @override
  String get navCharging => 'Charging';

  @override
  String get navProfile => 'Profile';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get walletBalance => 'Wallet Balance';

  @override
  String get addMoney => 'Add Money';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get savedStations => 'Saved Stations';

  @override
  String get chargingHistory => 'Charging History';

  @override
  String get invoice => 'Invoice';

  @override
  String get settings => 'Settings';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get evChargingNetwork => 'EV CHARGING NETWORK';

  @override
  String get welcomeBack => 'Welcome Back 👋';

  @override
  String get enterPhoneToContinue => 'Enter your phone number to continue';

  @override
  String get phoneValidationRequired => 'Please enter your phone number';

  @override
  String get phoneValidationLength => 'Phone number must be 10 digits';

  @override
  String get getOtp => 'Get OTP';

  @override
  String get newUser => 'New user? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get termsPrivacyPrompt =>
      'By continuing you agree to our Terms & Privacy Policy';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String enterDigitCodeSent(String phone) {
    return 'Enter the 6-digit code sent to\n$phone';
  }

  @override
  String resendOtpIn(String seconds) {
    return 'Resend OTP in 00:$seconds';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get otpVerifiedSuccess => 'OTP Verified Successfully!';

  @override
  String get createDriverAccount => 'CREATE DRIVER ACCOUNT';

  @override
  String get joinZetraNetwork => 'Join Zetra Network ';

  @override
  String get fillDetailsToGetStarted => 'Fill in your details to get started';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'John Doe';

  @override
  String get fullNameValidation => 'Please enter your full name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get emailAddressOptional => 'Email Address (Optional)';

  @override
  String get emailHint => 'abc@gmail.com';

  @override
  String get emailValidation => 'Please enter a valid email address';

  @override
  String get password => 'Password';

  @override
  String get passwordValidationEmpty => 'Please enter a password';

  @override
  String get passwordValidationLength =>
      'Password must be at least 6 characters';

  @override
  String get userRegisteredSuccess => 'User registered successfully';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get evChargingPlatform => 'EV Charging Platform';

  @override
  String get welcomeBackGreeting => 'Welcome back! 👋';

  @override
  String get startChargingSession => 'Start your charging session';

  @override
  String sessionsCount(String count) {
    return '$count Sessions';
  }

  @override
  String get thisWeek => 'This week';

  @override
  String get totalEnergy => 'Total energy';

  @override
  String get co2Saved => 'CO₂ saved';

  @override
  String get chargingFlow => 'CHARGING FLOW';

  @override
  String get plugIn => 'Plug-In';

  @override
  String get connectEvToCharger => 'Connect your EV to the charger';

  @override
  String get powerLink => 'Power Link';

  @override
  String get vehicleConnectedReady => 'Vehicle connected & ready to charge';

  @override
  String get chargingSession => 'Charging Session';

  @override
  String get monitorLiveStats => 'Monitor live charging stats & energy';

  @override
  String get viewPastSessions => 'View past sessions & energy usage';

  @override
  String get downloadViewInvoice => 'Download & view your charging invoice';

  @override
  String get lightTheme => 'LIGHT THEME';

  @override
  String get plugInLight => 'Plug-In  ·  Light';

  @override
  String get lightThemeConnectEv => 'Light theme — connect your EV';

  @override
  String get notificationsLight => 'Notifications  ·  Light';

  @override
  String get lightThemeSessionAlerts => 'Light theme — session alerts';

  @override
  String get notifications => 'Notifications';

  @override
  String get pluggedIn => 'Plugged In';

  @override
  String get vehicleConnectedSuccess => 'Vehicle connected successfully.';

  @override
  String get chargingStarted => 'Charging Started';

  @override
  String get sessionHasStarted => 'Your charging session has started.';

  @override
  String get lowBalance => 'Low Balance';

  @override
  String get walletBalanceIsLow => 'Your wallet balance is low.';

  @override
  String get chargingCompleted => 'Charging Completed';

  @override
  String get sessionCompletedAt => 'Session completed at ZETRA Hub.';

  @override
  String get newOffer => 'New Offer';

  @override
  String get offerCashbackBody => 'Get 10% cashback on your next 3 sessions!';

  @override
  String get searchLocationOrStation => 'Search location or station';

  @override
  String get stationsNearYou => 'Stations Near You';

  @override
  String resultsCount(String count) {
    return '$count results';
  }

  @override
  String get findingStationsNearYou => 'Finding stations near you…';

  @override
  String get failedToLoadStations => 'Failed to load stations';

  @override
  String get retry => 'Retry';

  @override
  String get noStationsFound =>
      'No stations found.\nTry a different location or keyword.';

  @override
  String kmAway(String distance) {
    return '$distance km away';
  }

  @override
  String get availableConnectors => 'Available Connectors';

  @override
  String get pricing => 'Pricing';

  @override
  String pricePerKwh(String price) {
    return '₹ $price /kWh';
  }

  @override
  String get stationTimings => 'Station Timings';

  @override
  String get alwaysOpen => '24 X 7 Open';

  @override
  String get startCharging => 'Start Charging';

  @override
  String get alignQrWithinFrame => 'Align QR code within the frame';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get enterStationIdManually => 'Enter Station ID Manually';

  @override
  String get chargingAt => 'Charging at';

  @override
  String get orderId => 'ORDER ID: #2CASB796';

  @override
  String get waitingForPlugIn => 'Waiting for Plug-In';

  @override
  String get connectHighSpeedPlug =>
      'Please connect the premium high-speed plug to your vehicle.';

  @override
  String get sessionInitiated => 'Session Initiated';

  @override
  String get paymentSuccessful => 'Payment Successful!';

  @override
  String get vehicleConnected => 'Vehicle Connected';

  @override
  String get chargingAutostart => 'Charging Autostart';

  @override
  String get letsCharge => 'Let\'s Charge';

  @override
  String get establishingConnection => 'Establishing Connection...';

  @override
  String get connected => 'Connected';

  @override
  String get powerLinkEstablished => 'Power Link\nEstablished! ⚡';

  @override
  String get chargingSessionSession => 'CHARGING SESSION';

  @override
  String get activeCharging => 'Active Charging';

  @override
  String get chargingCompletedStatus => 'Charging Completed';

  @override
  String get sessionPaused => 'Session Paused';

  @override
  String get stationInfo => 'Station Info';

  @override
  String get stationInfoDetails =>
      'Charger: Super DC-94\nLocation: Sector 4 EV Hub\nNetwork: Zetra Power\nStatus: Online';

  @override
  String get ok => 'OK';

  @override
  String get speed => 'SPEED';

  @override
  String get energy => 'ENERGY';

  @override
  String get remaining => 'REMAINING';

  @override
  String get dcFastCharge => 'DC Fast Charge';

  @override
  String get ccsType2 => 'CCS Type 2';

  @override
  String get slideToFinish => 'Slide to Finish';

  @override
  String get slideToStopCharging => 'Slide to Stop Charging';

  @override
  String get sessionSummary => 'Session Summary';

  @override
  String sessionSummaryDetails(
      String soc, String energy, String min, String sec, String temp) {
    return 'Charging session stopped successfully.\n\n• Final Charge: $soc%\n• Energy Delivered: $energy kWh\n• Elapsed Time: ${min}m ${sec}s\n• Average Temp: $temp°C';
  }

  @override
  String get finish => 'Finish';

  @override
  String get sessionSummaryHeader => 'SESSION SUMMARY';

  @override
  String get totalAmountPaid => 'Total Amount Paid';

  @override
  String get inclTaxes => 'INCL. TAXES';

  @override
  String get viewDigitalReceipt => 'View Digital Receipt';

  @override
  String get downloadInvoice => 'Download Invoice';

  @override
  String get chargingHub => 'Charging Hub';

  @override
  String get energyConsumed => 'Energy Consumed';

  @override
  String get duration => 'Duration';

  @override
  String get unitPrice => 'Unit Price';

  @override
  String get baseCost => 'Base Cost';

  @override
  String get gst => 'GST (12%)';

  @override
  String get convenienceFee => 'Convenience Fee';

  @override
  String get creditsApplied => 'Credits Applied';

  @override
  String get totalPaid => 'Total Paid';

  @override
  String get needHelpWithCharge => 'Need help with this charge?';

  @override
  String get wallet => 'Wallet';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get addMoneyContinue => 'Add money to continue charging';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get viewAll => 'View All';

  @override
  String get choosePaymentMethod => 'Choose Payment Method';

  @override
  String get pay => 'Pay';

  @override
  String payAmount(String amount) {
    return 'Pay  ₹$amount';
  }

  @override
  String get processing => 'Processing...';

  @override
  String get securedByZetraPay => 'Secured by Zetra Pay';

  @override
  String get other => 'Other';

  @override
  String get paymentFailed => 'Payment Failed';

  @override
  String get addedToWallet => 'Added to your wallet';

  @override
  String get paymentFailedSubtitle =>
      'Your payment could not be processed.\nPlease try again.';

  @override
  String get transactionDeclined => 'Transaction Declined';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get tryAgain => 'Try Again';
}
