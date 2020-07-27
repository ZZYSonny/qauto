part of 'package:qauto/resource/all.dart';

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