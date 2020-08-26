part of 'package:qauto/etc/all.dart';

Future<String> prepare() async {
  await Global.audio.auth();
  return await SystemChannel.getOpenWithContent();
}

Future<void> askQuestion(Question q) async {
  Global.stats.clear();
  await Global.audio.initEngine();
  try{
    await q.execute();
  }catch(Exception){
    //中间可能被打断，引擎被销毁然后报错
  }
  await questionSummary();
}

Future<void> questionSummary() async{
  await Global.audio.destoryEngine();
}