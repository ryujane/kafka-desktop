import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
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
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

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
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'KafkaX'**
  String get appName;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Kafka Desktop Client'**
  String get homeTitle;

  /// No description provided for @homeAddConnection.
  ///
  /// In en, this message translates to:
  /// **'Add Connection'**
  String get homeAddConnection;

  /// No description provided for @homeNoConnections.
  ///
  /// In en, this message translates to:
  /// **'No saved connections'**
  String get homeNoConnections;

  /// No description provided for @sidebarDevelopment.
  ///
  /// In en, this message translates to:
  /// **'DEVELOPMENT'**
  String get sidebarDevelopment;

  /// No description provided for @sidebarAdmin.
  ///
  /// In en, this message translates to:
  /// **'ADMINISTRATION'**
  String get sidebarAdmin;

  /// No description provided for @sidebarTopics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get sidebarTopics;

  /// No description provided for @sidebarGroups.
  ///
  /// In en, this message translates to:
  /// **'Consumer Groups'**
  String get sidebarGroups;

  /// No description provided for @sidebarProduce.
  ///
  /// In en, this message translates to:
  /// **'Produce'**
  String get sidebarProduce;

  /// No description provided for @sidebarBrokers.
  ///
  /// In en, this message translates to:
  /// **'Brokers'**
  String get sidebarBrokers;

  /// No description provided for @sidebarSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sidebarSettings;

  /// No description provided for @sidebarSelectCluster.
  ///
  /// In en, this message translates to:
  /// **'Select Cluster'**
  String get sidebarSelectCluster;

  /// No description provided for @statusNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get statusNoConnection;

  /// No description provided for @logPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logPanelTitle;

  /// No description provided for @logLevelAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get logLevelAll;

  /// No description provided for @logLevelInfo.
  ///
  /// In en, this message translates to:
  /// **'INFO'**
  String get logLevelInfo;

  /// No description provided for @logLevelWarn.
  ///
  /// In en, this message translates to:
  /// **'WARN'**
  String get logLevelWarn;

  /// No description provided for @logLevelError.
  ///
  /// In en, this message translates to:
  /// **'ERROR'**
  String get logLevelError;

  /// No description provided for @logSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get logSearchHint;

  /// No description provided for @clusterOverview.
  ///
  /// In en, this message translates to:
  /// **'Cluster Overview'**
  String get clusterOverview;

  /// No description provided for @topicList.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topicList;

  /// No description provided for @topicCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Topic'**
  String get topicCreate;

  /// No description provided for @topicDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Topic'**
  String get topicDelete;

  /// No description provided for @topicName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get topicName;

  /// No description provided for @topicPartitions.
  ///
  /// In en, this message translates to:
  /// **'Partitions'**
  String get topicPartitions;

  /// No description provided for @topicReplication.
  ///
  /// In en, this message translates to:
  /// **'Replication Factor'**
  String get topicReplication;

  /// No description provided for @topicIsInternal.
  ///
  /// In en, this message translates to:
  /// **'Internal'**
  String get topicIsInternal;

  /// No description provided for @topicMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get topicMessages;

  /// No description provided for @topicConfig.
  ///
  /// In en, this message translates to:
  /// **'Config'**
  String get topicConfig;

  /// No description provided for @topicMetrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get topicMetrics;

  /// No description provided for @topicOffset.
  ///
  /// In en, this message translates to:
  /// **'Offset'**
  String get topicOffset;

  /// No description provided for @topicKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get topicKey;

  /// No description provided for @topicValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get topicValue;

  /// No description provided for @topicTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get topicTimestamp;

  /// No description provided for @topicHeaders.
  ///
  /// In en, this message translates to:
  /// **'Headers'**
  String get topicHeaders;

  /// No description provided for @topicPartitionFilter.
  ///
  /// In en, this message translates to:
  /// **'Partition'**
  String get topicPartitionFilter;

  /// No description provided for @topicSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search messages...'**
  String get topicSearchHint;

  /// No description provided for @topicAutoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto Refresh'**
  String get topicAutoRefresh;

  /// No description provided for @producerTitle.
  ///
  /// In en, this message translates to:
  /// **'Produce Message'**
  String get producerTitle;

  /// No description provided for @producerTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get producerTopic;

  /// No description provided for @producerPartition.
  ///
  /// In en, this message translates to:
  /// **'Partition (optional)'**
  String get producerPartition;

  /// No description provided for @producerKey.
  ///
  /// In en, this message translates to:
  /// **'Key (optional)'**
  String get producerKey;

  /// No description provided for @producerValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get producerValue;

  /// No description provided for @producerHeaders.
  ///
  /// In en, this message translates to:
  /// **'Headers'**
  String get producerHeaders;

  /// No description provided for @producerSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get producerSend;

  /// No description provided for @producerSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get producerSending;

  /// No description provided for @producerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully'**
  String get producerSuccess;

  /// No description provided for @producerError.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message'**
  String get producerError;

  /// No description provided for @groupList.
  ///
  /// In en, this message translates to:
  /// **'Consumer Groups'**
  String get groupList;

  /// No description provided for @groupMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get groupMembers;

  /// No description provided for @groupLag.
  ///
  /// In en, this message translates to:
  /// **'Lag'**
  String get groupLag;

  /// No description provided for @groupOffsets.
  ///
  /// In en, this message translates to:
  /// **'Offsets'**
  String get groupOffsets;

  /// No description provided for @groupId.
  ///
  /// In en, this message translates to:
  /// **'Group ID'**
  String get groupId;

  /// No description provided for @groupState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get groupState;

  /// No description provided for @groupMemberCount.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get groupMemberCount;

  /// No description provided for @groupResetOffsets.
  ///
  /// In en, this message translates to:
  /// **'Reset Offsets'**
  String get groupResetOffsets;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAddConnection.
  ///
  /// In en, this message translates to:
  /// **'Add Connection'**
  String get settingsAddConnection;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLangSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLangSystem;

  /// No description provided for @settingsLangEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLangEnglish;

  /// No description provided for @settingsLangChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get settingsLangChinese;

  /// No description provided for @connectionName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get connectionName;

  /// No description provided for @connectionBrokers.
  ///
  /// In en, this message translates to:
  /// **'Bootstrap Servers'**
  String get connectionBrokers;

  /// No description provided for @connectionAuth.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get connectionAuth;

  /// No description provided for @connectionAuthType.
  ///
  /// In en, this message translates to:
  /// **'Auth Type'**
  String get connectionAuthType;

  /// No description provided for @connectionUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get connectionUsername;

  /// No description provided for @connectionPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get connectionPassword;

  /// No description provided for @connectionTls.
  ///
  /// In en, this message translates to:
  /// **'TLS'**
  String get connectionTls;

  /// No description provided for @connectionTlsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable TLS'**
  String get connectionTlsEnabled;

  /// No description provided for @connectionCaCert.
  ///
  /// In en, this message translates to:
  /// **'CA Certificate Path'**
  String get connectionCaCert;

  /// No description provided for @connectionClientCert.
  ///
  /// In en, this message translates to:
  /// **'Client Certificate Path'**
  String get connectionClientCert;

  /// No description provided for @connectionClientKey.
  ///
  /// In en, this message translates to:
  /// **'Client Key Path'**
  String get connectionClientKey;

  /// No description provided for @connectionProperties.
  ///
  /// In en, this message translates to:
  /// **'Advanced Properties'**
  String get connectionProperties;

  /// No description provided for @connectionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get connectionSave;

  /// No description provided for @connectionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get connectionDelete;

  /// No description provided for @connectionConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectionConnect;

  /// No description provided for @connectionDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get connectionDisconnect;

  /// No description provided for @connectionTestConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get connectionTestConnection;

  /// No description provided for @brokerList.
  ///
  /// In en, this message translates to:
  /// **'Brokers'**
  String get brokerList;

  /// No description provided for @brokerId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get brokerId;

  /// No description provided for @brokerHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get brokerHost;

  /// No description provided for @brokerPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get brokerPort;

  /// No description provided for @brokerRack.
  ///
  /// In en, this message translates to:
  /// **'Rack'**
  String get brokerRack;

  /// No description provided for @brokerAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get brokerAddress;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

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

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'zh':
      return SZh();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
