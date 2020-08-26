part of 'package:qauto/model/all.dart';

///提问一个固定的问题要求回答一个固定的答案
///判断回答并对不同结果做不同的回应
class InteractiveQuestion extends Question {
  String _displayCaption;
  String _displayDetail;
  String _questionAudio;
  String _questionQuickAnswer;
  String _questionFullAnswer;

  //TODO：语音包
  ///对不同结果的回应
  static const Map<RecognitionResult, String> reaction = {
    RecognitionResult.ANSWER_CORRECT: "答对了",
    RecognitionResult.ANSWER_WRONG: "答错了,答案应该是",
    RecognitionResult.ANSWER_INCOMPLETE: "卡住了？我来告诉你答案",
    RecognitionResult.ANSWER_NOSOUND: "没声音?再来一次吧",
    RecognitionResult.ANSWER_UNSURE: "好的,我来告诉你答案"
  };

  InteractiveQuestion(this._displayCaption, this._displayDetail,
      this._questionAudio, this._questionQuickAnswer, this._questionFullAnswer);

  ///运行问题,返回第一次回答时是否答对
  Future<QuestionStats> execute() async {
    //Init
    Global.page.setQuestion(_displayCaption, _displayDetail);
    
    //Main
    await Global.audio.speak(_questionAudio);
    var res = await Global.audio.recognize(_questionQuickAnswer);
    Global.page.setAnswer(_questionFullAnswer);
    await Global.audio.speak(reaction[res]);

    switch (res) {
      case RecognitionResult.ANSWER_CORRECT:
        return QuestionStats.single(true);
        break;
      case RecognitionResult.ANSWER_NOSOUND:
        return execute();
        break;
      default:
        await Global.audio.speak(_questionFullAnswer);
        await Global.audio.speak("再试一下吧");
        await Future.delayed(Duration(milliseconds: 2000));
        //这里再试一下就不判断了
        return QuestionStats.single(false);
    }
  }
}
