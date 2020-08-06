part of 'package:qauto/model/all.dart';


///对语音识别的不同结果做不同的回应
///达到增强记忆的目的
class InteractiveQuestion extends Question {
  String _displayCaption;
  String _displayDetail;
  String _questionAudio;
  String _questionQuickAnswer;
  String _questionFullAnswer;

  //TODO：阴阳人语音包
  ///对不同结果的回应
  static const Map<RecognitionResult, String> reaction = {
    RecognitionResult.ANSWER_CORRECT: "答对了",
    RecognitionResult.ANSWER_WRONG: "答错了，答案应该是",
    RecognitionResult.ANSWER_INCOMPLETE: "卡住了？我来告诉你答案",
    RecognitionResult.ANSWER_NOSOUND: "没声音?再来一次吧",
    RecognitionResult.ANSWER_UNSURE: "好的，我来告诉你答案"
  };

  InteractiveQuestion(this._displayCaption, this._displayDetail,
      this._questionAudio, this._questionQuickAnswer, this._questionFullAnswer);

  ///运行问题，返回第一次回答时是否答对
  Future<bool> execute() async {
    //Init
    Global.page.showQuestion(_displayCaption, _displayDetail);

    //Main
    await Global.audio.speak(_questionAudio);
    var res = await Global.audio.recognize(_questionQuickAnswer);
    await Global.audio.speak(reaction[res]);

    switch (res) {
      case RecognitionResult.ANSWER_CORRECT:
        return true;
        break;
      case RecognitionResult.ANSWER_NOSOUND:
        return execute();
        break;
      default:
        await Global.audio.speak(_questionFullAnswer);
        await Global.audio.speak("再试一下吧");
        await Future.delayed(Duration(milliseconds: 2000));
        //这里先不识别了，怕出锅
        return false;
    }
  }
}
