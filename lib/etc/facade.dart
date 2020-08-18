part of 'package:qauto/etc/all.dart';

//确保只有一个问题在跑
bool _running = false;
Future<void> askQuestion(Question q) async {
  if (!_running) {
    _running = true;
    await q.execute();
    _running = false;
  }
}

void askFromFile(String filename) async {
  String str = await rootBundle.loadString('assets/$filename.json');
  await askFromString(str);
}

Future<void> askFromString(String str) async{
  await Global.audio.init();
  var jsonResult = json.decode(str);
  var question = Questionable.fromJSON(jsonResult);
  await askQuestion(question.toQuestion());
}