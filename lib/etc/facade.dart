part of 'package:qauto/etc/all.dart';

class Facade {
  static Future<void> prepare() async {
    System.checkOpenWith();
    Global.audio.auth();
    System.requestPermission();
  }

  static Future<void> askQuestion(Question q) async {
    Global.stats.clear();
    Global.stats.updateGlobalPage();
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
    Global.page.setPageState(PageState.INITED_NOT_STARTED, "已停止");
  }
}
