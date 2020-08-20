part of 'package:qauto/model/all.dart';

///填空题
///JSON定义：
///{
/// "类型":"填空",
/// "内容":"[答案/提问词]是...的(de)"
///}
class BlankedQuestion extends Questionable{
  @override
  Question toQuestion() {
    // TODO: implement toQuestion
    throw UnimplementedError();
  }

  @override
  String getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }

}