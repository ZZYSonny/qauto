part of 'package:qauto/model/all.dart';

///定义问题，提供execute作为提问的接口
abstract class Question {
  ///整个问题的执行
  Future<bool> execute();
}

abstract class Questionable {
  Question toQuestion();

  static Future<Questionable> fromString(String jsonStr) async{
    var jsonResult = await json.decode(jsonStr);
    return fromJSON(jsonResult);
  }

  static Questionable fromJSON(Map<String, dynamic> json) {
    switch (json['类型']) {
      case '问题组':
        return new QuestionableGroup.fromJSON(json);
      case '诗':
        return new Shi.fromJSON(json);
      default:
        throw Exception("No such type");
    }
  }
  String getName();
}

///简单的问题，只期望一个固定的答案或者控制语句
class SimpleQuestion extends Question {
  String _displayCaption;
  String _displayDetail;
  String _questionAudio;
  String _questionAnswer;

  SimpleQuestion(
    this._displayCaption,
    this._displayDetail,
    this._questionAudio,
    this._questionAnswer,
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
    await Global.audio.speak(_questionAudio);
    return await Global.audio.recognize(_questionAnswer) ==
        RecognitionResult.ANSWER_CORRECT;
  }

  Future<void> onResult(bool res) async {
    if (res)
      await Global.audio.speak("答对了");
    else
      await Global.audio.speak("答错了");
  }
}
