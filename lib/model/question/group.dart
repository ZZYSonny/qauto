part of 'package:qauto/model/all.dart';

///提问一组问题,并且能够应用不同策略
class QuestionGroup extends Question {
  List<Question> questions;
  String strategy;
  QuestionGroup(this.questions, this.strategy);

  static var strategyMap = {
    "顺序全部": (qs) => new QuestionGroupController(qs, false, false, false),
    "随机全部": (qs) => new QuestionGroupController(qs, false, true, false),
    "顺序部分": (qs) => new QuestionGroupController(qs, true, false, false),
    "随机部分": (qs) => new QuestionGroupController(qs, true, true, false),
    "智慧": (qs) => new QuestionGroupController(qs, false, true, true)
  };

  @override
  Future<bool> execute() async {
    await strategyMap[strategy](questions).execute();
    return true;
  }
}

///控制一类提问的顺序
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
