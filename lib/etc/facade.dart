part of 'package:qauto/etc/all.dart';

class Facade {
  static Future<void> prepare() async {
    IntentChannel.getOpenWithContent()
        .then((String fileContent) => Global.page.setQuestionResource(fileContent));
    Global.audio.auth();
    requestAllPermission();
  }

  static Future<void> requestAllPermission() async {
    while (true) {
      var status = await Permission.microphone.request();
      assert(!status.isPermanentlyDenied);
      if (status.isGranted) break;
    }
  }

  static Future<void> askQuestion(Question q) async {
    Global.stats.clear();
    try {
      await Global.audio.initEngine();
      await q.execute();
      await Global.audio.speak("问题结束。");
      await Global.audio.speak(Global.stats.toAudioText());
    } catch (Exception) {
      //中间可能被打断，引擎被销毁然后报错
    }
    await stopQuestion();
  }

  static Future<void> stopQuestion() async {
    await Global.audio.destoryEngine();
    Global.page.setAllState(PageState.INITED_NOT_STARTED, "已停止");
  }
}
