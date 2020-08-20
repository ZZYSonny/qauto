part of 'package:qauto/user/all.dart';

class SystemChannel {
  static const platform = const MethodChannel('com.example.qauto/file');

  static Future<String> getOpenWithContent() async {
    return await platform.invokeMethod('getIntentFileContent');
  }

  static void requestPermssion() async {
    await platform.invokeMethod('requestAllPermission');
  }
}
