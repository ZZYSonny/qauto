part of 'package:qauto/model/all.dart';

///定义问题，提供execute作为提问的接口
abstract class Question {
  ///整个问题的执行
  Future<bool> execute();
}

abstract class Questionable {
  Question toQuestion();
  static Questionable fromJSON(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'group':
        return new QuestionableGroup.fromJSON(json);
      case 'poem':
        return new Poem.fromJSON(json);
      default:
        throw Exception("No such type");
    }
  }

  /*
  应该在JSONLoader里面搞这一步的
  static Future<Questionable> fromFile(String filename) async {
    String str = await rootBundle.loadString('assets/$filename.json');
    var jsonResult = json.decode(str);
    return fromJSON(jsonResult);
  }
  */
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

  Future<bool> execute() async {
    await onInit();
    bool res = await judge();
    await onResult(res);
    return res;
  }

  ///初始化显示
  Future<void> onInit() async {
    Global.page.showQuestion(_displayCaption, _displayDetail);
  }

  Future<bool> judge() async {
    await Global.audio.speak(_audioSentence);
    return await Global.audio.listen(_expectedAnswer) == RecognitionResult.ANSWER_CORRECT;
  }

  Future<void> onResult(bool res) async {
    if(res) await Global.audio.speak("答对了");
    else await Global.audio.speak("答错了");
    
  }
}
