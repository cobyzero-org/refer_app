import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back.'**
  String get welcomeBack;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The perfect roast is just a sign-in away.'**
  String get welcomeSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@editorialroast.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'........'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'OR CONTINUE WITH'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'SECURITY'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLogin;

  /// No description provided for @supportLegal.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT & LEGAL'**
  String get supportLegal;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Begin your sensory journey with us.'**
  String get signupSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Elias Thorne'**
  String get fullNameHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms and Conditions and Privacy Policy.'**
  String get acceptTerms;

  /// No description provided for @keepUpdated.
  ///
  /// In en, this message translates to:
  /// **'Keep me updated with seasonal collections and exclusive roastery news.'**
  String get keepUpdated;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get alreadyHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Referral App'**
  String get appName;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String goodMorning(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your daily brew is ready to be discovered.'**
  String get homeSubtitle;

  /// No description provided for @starsUntilNextReward.
  ///
  /// In en, this message translates to:
  /// **'{count} more stars until your next free artisanal brew'**
  String starsUntilNextReward(int count);

  /// No description provided for @seasonalBrews.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Brews'**
  String get seasonalBrews;

  /// No description provided for @viewMenu.
  ///
  /// In en, this message translates to:
  /// **'View menu'**
  String get viewMenu;

  /// No description provided for @noSeasonalBrews.
  ///
  /// In en, this message translates to:
  /// **'No seasonal brews available'**
  String get noSeasonalBrews;

  /// No description provided for @quickOrder.
  ///
  /// In en, this message translates to:
  /// **'Quick Order'**
  String get quickOrder;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffee;

  /// No description provided for @tea.
  ///
  /// In en, this message translates to:
  /// **'Tea'**
  String get tea;

  /// No description provided for @bakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get bakery;

  /// No description provided for @merchandise.
  ///
  /// In en, this message translates to:
  /// **'Merchandise'**
  String get merchandise;

  /// No description provided for @productDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'The Sensory Sommelier'**
  String get productDetailsTitle;

  /// No description provided for @selectSize.
  ///
  /// In en, this message translates to:
  /// **'SELECT SIZE'**
  String get selectSize;

  /// No description provided for @milkChoice.
  ///
  /// In en, this message translates to:
  /// **'MILK CHOICE'**
  String get milkChoice;

  /// No description provided for @enhancements.
  ///
  /// In en, this message translates to:
  /// **'ENHANCEMENTS'**
  String get enhancements;

  /// No description provided for @extraEspresso.
  ///
  /// In en, this message translates to:
  /// **'Extra Espresso Shot'**
  String get extraEspresso;

  /// No description provided for @sweetener.
  ///
  /// In en, this message translates to:
  /// **'Sweetener'**
  String get sweetener;

  /// No description provided for @addToOrder.
  ///
  /// In en, this message translates to:
  /// **'Add to Order'**
  String get addToOrder;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'CALORIES'**
  String get calories;

  /// No description provided for @caffeine.
  ///
  /// In en, this message translates to:
  /// **'CAFFEINE'**
  String get caffeine;

  /// No description provided for @tall.
  ///
  /// In en, this message translates to:
  /// **'Tall'**
  String get tall;

  /// No description provided for @grande.
  ///
  /// In en, this message translates to:
  /// **'Grande'**
  String get grande;

  /// No description provided for @venti.
  ///
  /// In en, this message translates to:
  /// **'Venti'**
  String get venti;

  /// No description provided for @wholeMilk.
  ///
  /// In en, this message translates to:
  /// **'Whole Milk'**
  String get wholeMilk;

  /// No description provided for @oatMilk.
  ///
  /// In en, this message translates to:
  /// **'Oat Milk'**
  String get oatMilk;

  /// No description provided for @almondMilk.
  ///
  /// In en, this message translates to:
  /// **'Almond Milk'**
  String get almondMilk;

  /// No description provided for @sensoryRoastSeries.
  ///
  /// In en, this message translates to:
  /// **'Sensory Roast Series'**
  String get sensoryRoastSeries;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for coffee, tea, or treats...'**
  String get searchHint;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @pickupTime.
  ///
  /// In en, this message translates to:
  /// **'Pickup Time'**
  String get pickupTime;

  /// No description provided for @yourOrder.
  ///
  /// In en, this message translates to:
  /// **'Your Order'**
  String get yourOrder;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get serviceFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed!'**
  String get orderPlaced;

  /// No description provided for @orderSuccessDetail.
  ///
  /// In en, this message translates to:
  /// **'Your artisanal brew will be ready in 10-15 minutes.'**
  String get orderSuccessDetail;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @selectFutureTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time in the future'**
  String get selectFutureTime;

  /// No description provided for @errorLoadingOrders.
  ///
  /// In en, this message translates to:
  /// **'Error loading orders'**
  String get errorLoadingOrders;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'THIS MONTH'**
  String get thisMonth;

  /// No description provided for @yourCollection.
  ///
  /// In en, this message translates to:
  /// **'YOUR COLLECTION'**
  String get yourCollection;

  /// No description provided for @pastExperiences.
  ///
  /// In en, this message translates to:
  /// **'Past\nexperiences'**
  String get pastExperiences;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @statusOrdered.
  ///
  /// In en, this message translates to:
  /// **'ORDERED'**
  String get statusOrdered;

  /// No description provided for @statusPreparing.
  ///
  /// In en, this message translates to:
  /// **'PREPARING'**
  String get statusPreparing;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'READY FOR PICKUP'**
  String get statusReady;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get statusCancelled;

  /// No description provided for @viewFullMonth.
  ///
  /// In en, this message translates to:
  /// **'View full month'**
  String get viewFullMonth;

  /// No description provided for @yourRituals.
  ///
  /// In en, this message translates to:
  /// **'Your Rituals'**
  String get yourRituals;

  /// No description provided for @ritualsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tracking your current cravings and past favorites from the roastery.'**
  String get ritualsSubtitle;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get activeOrders;

  /// No description provided for @activeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String activeCount(int count);

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @viewFullArchive.
  ///
  /// In en, this message translates to:
  /// **'View full archive'**
  String get viewFullArchive;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{number}'**
  String orderNumber(String number);

  /// No description provided for @statusBrewing.
  ///
  /// In en, this message translates to:
  /// **'BREWING'**
  String get statusBrewing;

  /// No description provided for @estimatedPickup.
  ///
  /// In en, this message translates to:
  /// **'Estimated pickup'**
  String get estimatedPickup;

  /// No description provided for @estimatedPickupDetail.
  ///
  /// In en, this message translates to:
  /// **'Approximately 6-8 minutes at the 5th Ave Roastery.'**
  String get estimatedPickupDetail;

  /// No description provided for @viewDirections.
  ///
  /// In en, this message translates to:
  /// **'View Directions'**
  String get viewDirections;

  /// No description provided for @reorderAll.
  ///
  /// In en, this message translates to:
  /// **'Reorder All'**
  String get reorderAll;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'CURRENT BALANCE'**
  String get currentBalance;

  /// No description provided for @starsRewards.
  ///
  /// In en, this message translates to:
  /// **'Stars Rewards'**
  String get starsRewards;

  /// No description provided for @redeemYourStars.
  ///
  /// In en, this message translates to:
  /// **'Redeem your Stars'**
  String get redeemYourStars;

  /// No description provided for @earningPerks.
  ///
  /// In en, this message translates to:
  /// **'Earning & Perks'**
  String get earningPerks;

  /// No description provided for @starsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} more Stars until your {reward}'**
  String starsRemaining(int count, String reward);

  /// No description provided for @recentProducts.
  ///
  /// In en, this message translates to:
  /// **'Recent Products'**
  String get recentProducts;

  /// No description provided for @insufficientStars.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough stars for this reward.'**
  String get insufficientStars;

  /// No description provided for @redeemReward.
  ///
  /// In en, this message translates to:
  /// **'Redeem Reward'**
  String get redeemReward;

  /// No description provided for @confirmRedemption.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to spend {stars} stars on this reward?'**
  String confirmRedemption(int stars);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @currentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get currentPasswordHint;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password (min. 6 chars)'**
  String get newPasswordHint;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get passwordChangedSuccessfully;

  /// No description provided for @errorChangingPassword.
  ///
  /// In en, this message translates to:
  /// **'Error changing password. Please check your credentials.'**
  String get errorChangingPassword;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
