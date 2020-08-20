part of 'package:qauto/model/all.dart';

///一群问题，可以是同一类型的问题，一整个文件，可以套娃
///JSON定义：
///{
///   "类型":"问题组",
///   "名称":"name",                              //这一类问题的分类
///   "策略": "Sequential/Random/Smart"       //采用的提问方式
///   "内容": []                               //问题数组
///}
class QuestionableGroup extends Questionable{
  List<Questionable> rawQuestions;
  String name;
  String strategy;

  QuestionableGroup(this.rawQuestions);
  QuestionableGroup.fromJSON(Map<String, dynamic> json){
    this.name = json['名称'];
    this.strategy = json['策略'];
    this.rawQuestions = new List<Questionable>.from(json['内容'].map((x)=>(Questionable.fromJSON(x))).toList());
  }
  Question toQuestion() {
    List<Question> questions = rawQuestions.map((x)=>(x.toQuestion())).toList();
    return new QuestionGroup(questions, strategy);
  }

  @override
  String getName() {
    return name;
  }
}