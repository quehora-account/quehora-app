import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashRepository {
  final FirebaseCrashlytics _instance = FirebaseCrashlytics.instance;

  Future<void> report(dynamic exception, StackTrace stack) async {
    if (kDebugMode) {
      print(exception);
      print(stack);
    } else {
      await _instance.recordError(exception, stack, fatal: true);
    }
  }
}
