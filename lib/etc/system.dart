part of 'package:qauto/etc/all.dart';

class System {
  static Future<void> requestPermission() async {
    await Permission.microphone.request();
  }

  static StreamSubscription<String> intentSubscription;

  static void checkOpenWith() {
    intentSubscription =
        ReceiveSharingIntent.getTextStream().listen(handleURI);
    ReceiveSharingIntent.getInitialText().then(handleURI);
  }

  static Future<void> handleURI(String uri) async {
    print(uri);
    String fileContent;
    if (uri != null) {
      String path = await FlutterAbsolutePath.getAbsolutePath(uri);
      fileContent = File(path).readAsStringSync();
    }
    Global.page.setQuestionResource(fileContent);
  }

  static void dispose(){
    if(intentSubscription!=null) intentSubscription.cancel();
  }
}