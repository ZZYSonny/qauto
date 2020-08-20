part of 'package:qauto/user/all.dart';

class SystemChannel {
  static const platform = const MethodChannel('com.example.qauto/file');

  ///如果应用是通过"打开方式"打开的,返回这个文件的内容
  ///否则返回null
  static Future<String> getOpenWithContent() async {
    return await platform.invokeMethod('getIntentFileContent');
  }

  ///请求所需的权限
  static void requestPermssion() async {
    await platform.invokeMethod('requestAllPermission');
  }
}
