part of 'package:qauto/etc/all.dart';

Future<String> prepare() async {
  await Global.audio.auth();
  return await SystemChannel.getOpenWithContent();
}

void askQuestion(Question q) async {
  await Global.audio.initEngine();
  await q.execute();
  await Global.audio.destoryEngine();
}
