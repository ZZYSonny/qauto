part of 'package:qauto/model/all.dart';

class QuestionGroupController {
  List<Question> questions;
  bool smart;

  QuestionGroupController(
      List<Question> allQuestions, bool partial, bool random, this.smart) {
    if (partial) {
      for (var q in allQuestions) if (Global.randBool(0.5)) questions.add(q);
    } else
      questions = allQuestions;
    if (random) questions.shuffle(Global.rng);
  }

  ///按照一定顺序运行List中的问题
  Future<void> execute() async {
    for (var nowq in questions) {
      bool res = await nowq.execute();
      if (smart && res && Global.randBool(0.6)) break;
    }
  }

  ///显示统计数据
  String showStats() {
    // TODO: implement showStats
    return "还没写";
  }
}
