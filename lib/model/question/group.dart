part of 'package:qauto/model/all.dart';

///提问一组问题，并且能够应用不同策略
class QuestionGroup extends Question {
  List<Question> questions;
  String strategy;
  QuestionGroup(this.questions, this.strategy);

  static var strategyMap = {
    "顺序全部" : (qs) => new QuestionGroupController(qs,false,false,false),
    "随机全部" : (qs) => new QuestionGroupController(qs,false,true,false),
    "顺序部分" : (qs) => new QuestionGroupController(qs,true,false,false),
    "随机部分" : (qs) => new QuestionGroupController(qs,true,true,false),
    "智慧"     : (qs) => new QuestionGroupController(qs,false,true,true)
  };

  @override
  Future<bool> execute() async {
    await strategyMap[strategy](questions).execute();
    return true;
  }
}
