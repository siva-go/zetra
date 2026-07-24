import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The main title of the application
  ///
  /// In en, this message translates to:
  /// **'ZETRA'**
  String get appTitle;

  /// Navigation bar item for home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Navigation bar item for QR scanning
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get navScanQr;

  /// Navigation bar item for active charging screen
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get navCharging;

  /// Navigation bar item for user profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Navigation bar item for notifications screen
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// Text label displaying wallet balance
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// Top-up wallet CTA text
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get addMoney;

  /// Menu option for payment methods
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// Menu option for saved stations
  ///
  /// In en, this message translates to:
  /// **'Saved Stations'**
  String get savedStations;

  /// Menu option for charging history
  ///
  /// In en, this message translates to:
  /// **'Charging History'**
  String get chargingHistory;

  /// Invoice screen appbar title
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// Menu option for app settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Menu option for help and support
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Sub-title text under app title
  ///
  /// In en, this message translates to:
  /// **'EV CHARGING NETWORK'**
  String get evChargingNetwork;

  /// Welcome header on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome Back 👋'**
  String get welcomeBack;

  /// Instruction label under welcome header
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get enterPhoneToContinue;

  /// Validation message when phone is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneValidationRequired;

  /// Validation message when phone is not 10 digits
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 digits'**
  String get phoneValidationLength;

  /// Button label to request OTP
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOtp;

  /// Prompt text for signup
  ///
  /// In en, this message translates to:
  /// **'New user? '**
  String get newUser;

  /// SignUp button / label text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Terms and privacy agreement footnote
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our Terms & Privacy Policy'**
  String get termsPrivacyPrompt;

  /// OTP screen header title
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// Instruction description for OTP entry
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to\n{phone}'**
  String enterDigitCodeSent(String phone);

  /// Cooldown timer label for resending OTP
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in 00:{seconds}'**
  String resendOtpIn(String seconds);

  /// Button text to resend OTP
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// Toast message on successful OTP verification
  ///
  /// In en, this message translates to:
  /// **'OTP Verified Successfully!'**
  String get otpVerifiedSuccess;

  /// Subtitle for signup screen
  ///
  /// In en, this message translates to:
  /// **'CREATE DRIVER ACCOUNT'**
  String get createDriverAccount;

  /// Header title on signup form card
  ///
  /// In en, this message translates to:
  /// **'Join Zetra Network '**
  String get joinZetraNetwork;

  /// Subtitle on signup form card
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to get started'**
  String get fillDetailsToGetStarted;

  /// Textfield label for full name
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Hint text for full name field
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNameHint;

  /// Validation error for full name
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get fullNameValidation;

  /// Label for phone number field
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Label for email field
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get emailAddressOptional;

  /// Hint text for email field
  ///
  /// In en, this message translates to:
  /// **'abc@gmail.com'**
  String get emailHint;

  /// Validation error for email field
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailValidation;

  /// Label for password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Validation error when password is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get passwordValidationEmpty;

  /// Validation error when password is too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordValidationLength;

  /// Toast message on successful registration
  ///
  /// In en, this message translates to:
  /// **'User registered successfully'**
  String get userRegisteredSuccess;

  /// Fallback error message on failed registration
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// Subtitle on home screen top bar
  ///
  /// In en, this message translates to:
  /// **'EV Charging Platform'**
  String get evChargingPlatform;

  /// Greeting text on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome back! 👋'**
  String get welcomeBackGreeting;

  /// Instruction subtitle on home screen
  ///
  /// In en, this message translates to:
  /// **'Start your charging session'**
  String get startChargingSession;

  /// Chip label displaying count of sessions
  ///
  /// In en, this message translates to:
  /// **'{count} Sessions'**
  String sessionsCount(String count);

  /// Chip subtitle for sessions count
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// Chip subtitle for total energy
  ///
  /// In en, this message translates to:
  /// **'Total energy'**
  String get totalEnergy;

  /// Chip subtitle for carbon offset
  ///
  /// In en, this message translates to:
  /// **'CO₂ saved'**
  String get co2Saved;

  /// Section header for charging cards list
  ///
  /// In en, this message translates to:
  /// **'CHARGING FLOW'**
  String get chargingFlow;

  /// Title for plugin card
  ///
  /// In en, this message translates to:
  /// **'Plug-In'**
  String get plugIn;

  /// Subtitle for plugin card
  ///
  /// In en, this message translates to:
  /// **'Connect your EV to the charger'**
  String get connectEvToCharger;

  /// Title for power link card
  ///
  /// In en, this message translates to:
  /// **'Power Link'**
  String get powerLink;

  /// Subtitle for power link card
  ///
  /// In en, this message translates to:
  /// **'Vehicle connected & ready to charge'**
  String get vehicleConnectedReady;

  /// Title for charging session card
  ///
  /// In en, this message translates to:
  /// **'Charging Session'**
  String get chargingSession;

  /// Subtitle for charging session card
  ///
  /// In en, this message translates to:
  /// **'Monitor live charging stats & energy'**
  String get monitorLiveStats;

  /// Subtitle for charging history card
  ///
  /// In en, this message translates to:
  /// **'View past sessions & energy usage'**
  String get viewPastSessions;

  /// Subtitle for invoice card
  ///
  /// In en, this message translates to:
  /// **'Download & view your charging invoice'**
  String get downloadViewInvoice;

  /// Header for light theme screens section
  ///
  /// In en, this message translates to:
  /// **'LIGHT THEME'**
  String get lightTheme;

  /// Title for light theme plugin screen
  ///
  /// In en, this message translates to:
  /// **'Plug-In  ·  Light'**
  String get plugInLight;

  /// Subtitle for light theme plugin screen
  ///
  /// In en, this message translates to:
  /// **'Light theme — connect your EV'**
  String get lightThemeConnectEv;

  /// Title for light theme notifications card
  ///
  /// In en, this message translates to:
  /// **'Notifications  ·  Light'**
  String get notificationsLight;

  /// Subtitle for light theme notifications screen
  ///
  /// In en, this message translates to:
  /// **'Light theme — session alerts'**
  String get lightThemeSessionAlerts;

  /// Header title for notifications screen
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notification title for plugged in state
  ///
  /// In en, this message translates to:
  /// **'Plugged In'**
  String get pluggedIn;

  /// Notification body for plugged in state
  ///
  /// In en, this message translates to:
  /// **'Vehicle connected successfully.'**
  String get vehicleConnectedSuccess;

  /// Notification title for charging start
  ///
  /// In en, this message translates to:
  /// **'Charging Started'**
  String get chargingStarted;

  /// Notification body for charging start
  ///
  /// In en, this message translates to:
  /// **'Your charging session has started.'**
  String get sessionHasStarted;

  /// Notification title for low balance alert
  ///
  /// In en, this message translates to:
  /// **'Low Balance'**
  String get lowBalance;

  /// Notification body for low balance alert
  ///
  /// In en, this message translates to:
  /// **'Your wallet balance is low.'**
  String get walletBalanceIsLow;

  /// Notification title for charging complete
  ///
  /// In en, this message translates to:
  /// **'Charging Completed'**
  String get chargingCompleted;

  /// Notification body for charging complete
  ///
  /// In en, this message translates to:
  /// **'Session completed at ZETRA Hub.'**
  String get sessionCompletedAt;

  /// Notification title for promotional offers
  ///
  /// In en, this message translates to:
  /// **'New Offer'**
  String get newOffer;

  /// Notification body for cashback promo
  ///
  /// In en, this message translates to:
  /// **'Get 10% cashback on your next 3 sessions!'**
  String get offerCashbackBody;

  /// Hint text for station search field
  ///
  /// In en, this message translates to:
  /// **'Search location or station'**
  String get searchLocationOrStation;

  /// Header for search results near user location
  ///
  /// In en, this message translates to:
  /// **'Stations Near You'**
  String get stationsNearYou;

  /// Text showing number of search results
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String resultsCount(String count);

  /// Loading message during search
  ///
  /// In en, this message translates to:
  /// **'Finding stations near you…'**
  String get findingStationsNearYou;

  /// Error message when search fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load stations'**
  String get failedToLoadStations;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Empty state description when search returns no matches
  ///
  /// In en, this message translates to:
  /// **'No stations found.\nTry a different location or keyword.'**
  String get noStationsFound;

  /// Distance label
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String kmAway(String distance);

  /// Header for connectors section
  ///
  /// In en, this message translates to:
  /// **'Available Connectors'**
  String get availableConnectors;

  /// Label for pricing row
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// Price unit value
  ///
  /// In en, this message translates to:
  /// **'₹ {price} /kWh'**
  String pricePerKwh(String price);

  /// Label for timings row
  ///
  /// In en, this message translates to:
  /// **'Station Timings'**
  String get stationTimings;

  /// Value for timing indicating always open
  ///
  /// In en, this message translates to:
  /// **'24 X 7 Open'**
  String get alwaysOpen;

  /// Call-to-action button to start EV charging
  ///
  /// In en, this message translates to:
  /// **'Start Charging'**
  String get startCharging;

  /// Helper instruction on scanner overlay
  ///
  /// In en, this message translates to:
  /// **'Align QR code within the frame'**
  String get alignQrWithinFrame;

  /// Title header for QR code scanner screen
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// Button to input station ID via keyboard
  ///
  /// In en, this message translates to:
  /// **'Enter Station ID Manually'**
  String get enterStationIdManually;

  /// Label for current charging location
  ///
  /// In en, this message translates to:
  /// **'Charging at'**
  String get chargingAt;

  /// Mock Order ID text string
  ///
  /// In en, this message translates to:
  /// **'ORDER ID: #2CASB796'**
  String get orderId;

  /// Status text waiting for connector
  ///
  /// In en, this message translates to:
  /// **'Waiting for Plug-In'**
  String get waitingForPlugIn;

  /// Instruction to plug in the charger connector
  ///
  /// In en, this message translates to:
  /// **'Please connect the premium high-speed plug to your vehicle.'**
  String get connectHighSpeedPlug;

  /// Connection checklist step 1
  ///
  /// In en, this message translates to:
  /// **'Session Initiated'**
  String get sessionInitiated;

  /// Successful topup title header
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessful;

  /// Connection checklist step 4
  ///
  /// In en, this message translates to:
  /// **'Vehicle Connected'**
  String get vehicleConnected;

  /// Connection checklist step 5
  ///
  /// In en, this message translates to:
  /// **'Charging Autostart'**
  String get chargingAutostart;

  /// Button text to transition to charging
  ///
  /// In en, this message translates to:
  /// **'Let\'s Charge'**
  String get letsCharge;

  /// Connecting button status
  ///
  /// In en, this message translates to:
  /// **'Establishing Connection...'**
  String get establishingConnection;

  /// Connected button status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Success link title header
  ///
  /// In en, this message translates to:
  /// **'Power Link\nEstablished! ⚡'**
  String get powerLinkEstablished;

  /// Active session header label
  ///
  /// In en, this message translates to:
  /// **'CHARGING SESSION'**
  String get chargingSessionSession;

  /// Status description when active
  ///
  /// In en, this message translates to:
  /// **'Active Charging'**
  String get activeCharging;

  /// Status description when completed
  ///
  /// In en, this message translates to:
  /// **'Charging Completed'**
  String get chargingCompletedStatus;

  /// Status description when paused
  ///
  /// In en, this message translates to:
  /// **'Session Paused'**
  String get sessionPaused;

  /// Title of station description dialog
  ///
  /// In en, this message translates to:
  /// **'Station Info'**
  String get stationInfo;

  /// Details text for station info
  ///
  /// In en, this message translates to:
  /// **'Charger: Super DC-94\nLocation: Sector 4 EV Hub\nNetwork: Zetra Power\nStatus: Online'**
  String get stationInfoDetails;

  /// Standard confirmation button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Label for charging speed metric
  ///
  /// In en, this message translates to:
  /// **'SPEED'**
  String get speed;

  /// Label for energy delivered metric
  ///
  /// In en, this message translates to:
  /// **'ENERGY'**
  String get energy;

  /// Label for remaining time metric
  ///
  /// In en, this message translates to:
  /// **'REMAINING'**
  String get remaining;

  /// Mock charger type label
  ///
  /// In en, this message translates to:
  /// **'DC Fast Charge'**
  String get dcFastCharge;

  /// Mock connector type label
  ///
  /// In en, this message translates to:
  /// **'CCS Type 2'**
  String get ccsType2;

  /// Slider action text on completion
  ///
  /// In en, this message translates to:
  /// **'Slide to Finish'**
  String get slideToFinish;

  /// Slider action text during active charge
  ///
  /// In en, this message translates to:
  /// **'Slide to Stop Charging'**
  String get slideToStopCharging;

  /// Header title of session summary dialog
  ///
  /// In en, this message translates to:
  /// **'Session Summary'**
  String get sessionSummary;

  /// Body summary values
  ///
  /// In en, this message translates to:
  /// **'Charging session stopped successfully.\n\n• Final Charge: {soc}%\n• Energy Delivered: {energy} kWh\n• Elapsed Time: {min}m {sec}s\n• Average Temp: {temp}°C'**
  String sessionSummaryDetails(
      String soc, String energy, String min, String sec, String temp);

  /// Action to finish session
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Header text for summary section
  ///
  /// In en, this message translates to:
  /// **'SESSION SUMMARY'**
  String get sessionSummaryHeader;

  /// Total amount paid subtitle
  ///
  /// In en, this message translates to:
  /// **'Total Amount Paid'**
  String get totalAmountPaid;

  /// Tax indicator subtitle
  ///
  /// In en, this message translates to:
  /// **'INCL. TAXES'**
  String get inclTaxes;

  /// Button to view receipt
  ///
  /// In en, this message translates to:
  /// **'View Digital Receipt'**
  String get viewDigitalReceipt;

  /// Button to download invoice file
  ///
  /// In en, this message translates to:
  /// **'Download Invoice'**
  String get downloadInvoice;

  /// Station type label
  ///
  /// In en, this message translates to:
  /// **'Charging Hub'**
  String get chargingHub;

  /// Stat label for energy
  ///
  /// In en, this message translates to:
  /// **'Energy Consumed'**
  String get energyConsumed;

  /// Stat label for duration
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Unit pricing detail label
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPrice;

  /// Base cost detail label
  ///
  /// In en, this message translates to:
  /// **'Base Cost'**
  String get baseCost;

  /// GST detail label
  ///
  /// In en, this message translates to:
  /// **'GST (12%)'**
  String get gst;

  /// Convenience fee detail label
  ///
  /// In en, this message translates to:
  /// **'Convenience Fee'**
  String get convenienceFee;

  /// Credits applied detail label
  ///
  /// In en, this message translates to:
  /// **'Credits Applied'**
  String get creditsApplied;

  /// Total paid bill detail label
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// Help center redirection prompt
  ///
  /// In en, this message translates to:
  /// **'Need help with this charge?'**
  String get needHelpWithCharge;

  /// Wallet screen title
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// Remaining wallet balance label
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// Illustration helper text to charge wallet
  ///
  /// In en, this message translates to:
  /// **'Add money to continue charging'**
  String get addMoneyContinue;

  /// Transactions history title
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// Redirection to see all items link
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Selection prompt for payment modes
  ///
  /// In en, this message translates to:
  /// **'Choose Payment Method'**
  String get choosePaymentMethod;

  /// Generic pay button label
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// Pay with amount details label
  ///
  /// In en, this message translates to:
  /// **'Pay  ₹{amount}'**
  String payAmount(String amount);

  /// Loading processing transaction status
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// Secure payment footnote
  ///
  /// In en, this message translates to:
  /// **'Secured by Zetra Pay'**
  String get securedByZetraPay;

  /// Chip for custom payment input option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Failed topup title header
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// Status text for successful payment
  ///
  /// In en, this message translates to:
  /// **'Added to your wallet'**
  String get addedToWallet;

  /// Detailed explanation of failure status
  ///
  /// In en, this message translates to:
  /// **'Your payment could not be processed.\nPlease try again.'**
  String get paymentFailedSubtitle;

  /// Short error label badge text
  ///
  /// In en, this message translates to:
  /// **'Transaction Declined'**
  String get transactionDeclined;

  /// Navigation action button
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Failure retry action button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
