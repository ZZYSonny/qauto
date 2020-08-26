part of 'package:qauto/etc/all.dart';

Future<String> prepare() async {
  var fileContent = await IntentChannel.getOpenWithContent();
  await Global.audio.auth();
  requestAllPermission();
  return fileContent;
}

Future<void> requestAllPermission() async {
  while (true) {
    var status = await Permission.microphone.request();
    assert(!status.isPermanentlyDenied);
    if (status.isGranted) break;
  }
}

Future<void> askQuestion(Question q) async {
  Global.stats.clear();
  await Global.audio.initEngine();
  try {
    await q.execute();
  } catch (Exception) {
    //中间可能被打断，引擎被销毁然后报错
  }
  await Global.audio.speak("问题结束。");
  await Global.audio.speak(Global.stats.toAudioText());
  await Global.audio.destoryEngine();
}

Future<void> stopQuestion() async {
  await Global.audio.destoryEngine();
}
