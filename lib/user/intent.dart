part of 'package:qauto/user/all.dart';

class IntentReceiver {
  static const platform = const MethodChannel('com.example.qauto/file');

  static Future<void> startFromOpenWith() async {
    String fileContent = await platform.invokeMethod('getIntentFileContent');
    if (fileContent != null) {
      askFromString(fileContent);
    }
  }

  static Future<void> requestPermssion() async {
    await platform.invokeMethod('requestAllPermission');
  }

  static Future<void> startup() async {
    await requestPermssion();
    await startFromOpenWith();
  }
}
