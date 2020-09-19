import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

class RSCrashlytics {
  RSCrashlytics._();

  factory RSCrashlytics.getInstance() {
    return _instance;
  }

  static final RSCrashlytics _instance = RSCrashlytics._();

  Future<void> record(String message, dynamic exception, StackTrace stackTrace) async {
    RSLogger.d("クラッシュレポートを送ります");
    await FirebaseCrashlytics.instance.setCustomKey("message", message);
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
  }
}
