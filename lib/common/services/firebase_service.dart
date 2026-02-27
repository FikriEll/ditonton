import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static FirebaseAnalytics? analytics;
  static FirebaseAnalyticsObserver? analyticsObserver;

  static Future<void> initialize() async {
    try {
      final options = _firebaseOptionsFromEnvironment();
      if (options == null) {
        if (kDebugMode) {
          debugPrint(
            'Firebase init skipped: missing --dart-define Firebase config.',
          );
        }
        return;
      }

      await Firebase.initializeApp(options: options);

      analytics = FirebaseAnalytics.instance;
      analyticsObserver = FirebaseAnalyticsObserver(analytics: analytics!);

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Firebase init skipped: $error');
      }
    }
  }

  static Future<void> logScreenView(String screenName) async {
    await analytics?.logScreenView(screenName: screenName);
  }

  static Future<void> logException(Object error, StackTrace stackTrace) async {
    if (Firebase.apps.isEmpty) return;
    await FirebaseCrashlytics.instance
        .recordError(error, stackTrace, fatal: false);
  }

  static FirebaseOptions? _firebaseOptionsFromEnvironment() {
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    const messagingSenderId =
        const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');

    if (apiKey.isEmpty ||
        appId.isEmpty ||
        messagingSenderId.isEmpty ||
        projectId.isEmpty) {
      return null;
    }

    const storageBucket =
        const String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
    const iosBundleId = String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');
    const androidClientId =
        const String.fromEnvironment('FIREBASE_ANDROID_CLIENT_ID');
    const iosClientId = String.fromEnvironment('FIREBASE_IOS_CLIENT_ID');
    const iosGoogleAppId =
        const String.fromEnvironment('FIREBASE_IOS_GOOGLE_APP_ID');
    const measurementId = String.fromEnvironment('FIREBASE_MEASUREMENT_ID');

    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket.isEmpty ? null : storageBucket,
        measurementId: measurementId.isEmpty ? null : measurementId,
      );
    }

    if (Platform.isAndroid) {
      return FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket.isEmpty ? null : storageBucket,
        androidClientId: androidClientId.isEmpty ? null : androidClientId,
      );
    }

    if (Platform.isIOS || Platform.isMacOS) {
      return FirebaseOptions(
        apiKey: apiKey,
        appId: iosGoogleAppId.isEmpty ? appId : iosGoogleAppId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket.isEmpty ? null : storageBucket,
        iosClientId: iosClientId.isEmpty ? null : iosClientId,
        iosBundleId: iosBundleId.isEmpty ? null : iosBundleId,
      );
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
    );
  }
}
