part of 'package:qauto/ui/all.dart';

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
  var question = await Questionable.fromFile(filename);
  await askQuestion(question.toQuestion());
}
