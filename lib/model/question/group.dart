part of 'package:qauto/model/all.dart';

///提问一组问题，并且能够应用不同策略
class QuestionGroup extends Question {
  List<Question> questions;
  String strategy;
  QuestionGroup(this.questions, this.strategy);

  @override
  Future<bool> execute() async {
    switch (strategy) {
      case "顺序全部":
        await (new QuestionGroupController(this.questions,false,false,false)).execute();
        break;
      case "随机全部":
        await (new QuestionGroupController(this.questions,false,true,false)).execute();
        break;
      case "顺序部分":
        await (new QuestionGroupController(this.questions,true,false,false)).execute();
        break;
      case "随机部分":
        await (new QuestionGroupController(this.questions,true,true,false)).execute();
        break;
      case "智慧":
        await (new QuestionGroupController(this.questions,false,true,true)).execute();
        break;
      default:
        throw Exception("没有对应的运行方式");
    }
    return true;
  }
}
