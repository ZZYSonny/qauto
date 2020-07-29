part of 'package:qauto/model/all.dart';

class QuestionGroup extends Question{
  List<Question> questions;
  String strategy;
  QuestionGroup(this.questions,this.strategy);

  @override
  Future<bool> execute() async {
    if(strategy=="Sequential") await (new SequentialController(this.questions)).execute();
    return true;
  }
}