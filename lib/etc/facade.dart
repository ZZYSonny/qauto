part of 'package:qauto/etc/all.dart';

Future<String> prepare() async {
  await Global.audio.auth();
  return await SystemChannel.getOpenWithContent();
}

void askQuestion(Question q) async {
  Global.stats.clear();
  await Global.audio.initEngine();
  await q.execute();
  await Global.audio.speak("问题结束。");
  await Global.audio.speak(Global.stats.toAudioText());
  await Global.audio.destoryEngine();
}
