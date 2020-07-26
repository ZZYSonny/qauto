part of 'package:qauto/questions/all.dart';


///定义问题，提供execute作为提问的接口
abstract class Question {
  ///整个问题的执行
  Future<bool> execute(QuestionPageState page,AudioController audio);
}

abstract class Questionable{
  Question toQuestion(int mode);
  Random rng = new Random();
  int randInt(int n){
    return rng.nextInt(n);
  }
}

///简单的问题，只期望一个固定的答案或者控制语句
class SimpleQuestion extends Question {
  String _displayCaption;
  String _displayDetail;
  String _audioSentence;
  String _expectedAnswer;

  SimpleQuestion(
    this._displayCaption,
    this._displayDetail,
    this._audioSentence,
    this._expectedAnswer,
  );

  Future<bool> execute(QuestionPageState page,AudioController audio) async{
    page.showQuestion(_displayCaption, _displayDetail);
    audio.readSentence(_audioSentence);
    return await audio.listenForSentences([_expectedAnswer, "我不会"]) == 0;
  }
}
