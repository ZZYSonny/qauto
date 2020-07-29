part of 'package:qauto/model/all.dart';

///一群问题，可以是同一类型的问题，一整个文件，可以套娃
///JSON定义：
///{
///   "type":"group",
///   "name":"Name",                              //这一类问题的分类
///   "strategy": "Sequential/Random/Smart"       //采用的提问方式
///   "content": []                               //问题数组
///}
class QuestionableGroup extends Questionable{
  List<Questionable> rawQuestions;
  String strategy;

  QuestionableGroup(this.rawQuestions);
  QuestionableGroup.fromJSON(Map<String, dynamic> json){
    this.strategy = json['strategy'];
    this.rawQuestions = new List<Questionable>.from(json['content'].map((x)=>(Questionable.fromJSON(x))).toList());
  }
  Question toQuestion() {
    List<Question> questions = rawQuestions.map((x)=>(x.toQuestion())).toList();
    return new QuestionGroup(questions, strategy);
  }
}