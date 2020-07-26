part of 'package:qauto/questions/all.dart';

///一群问题，可以是同一类型的问题，一整个文件，可以套娃
///JSON定义：
///{
///   "type":"group",
///   "name":"Name",                              //这一类问题的分类
///   "strategy": "Sequential/Random/Smart"       //采用的提问方式
///   "content": []                               //问题数组
///}
class QuestionGroup extends Question with Questionable{
  List<Question> questions;
  String strategy;
  QuestionGroup(this.questions,this.strategy);

  @override
  Future<bool> execute() async {
    if(strategy=="Sequential") await (new SequentialController(this.questions)).execute();
    return true;
  }

  QuestionGroup.fromJSON(Map<String, dynamic> json){
    this.strategy = json['strategy'];
    List<dynamic> subquestion = json['content'].map((x)=>(Questionable.fromJSON(x).toQuestion())).toList();
    this.questions = List<Question>.from(subquestion);
  }
    
    
  @override
  Question toQuestion() => this;
}