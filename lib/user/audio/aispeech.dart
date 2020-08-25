part of 'package:qauto/user/all.dart';

class AISpeechAudioController extends AudioController {
  static const platform = const MethodChannel('com.example.qauto/speech');

  @override
  Future<bool> _auth() async {
    return await platform.invokeMethod('auth');
  }

  @override
  Future<void> speak(String text) async {
    log(text);
    await platform.invokeMethod('speak', {"text": text});
  }

  Future<String> listen() async {
    var jsonString = await platform.invokeMethod('listen');
    if (jsonString == "")
      return "";
    else {
      var resultMap = await json.decode(jsonString);
      return resultMap['result']['rec'].replaceAll(" ", "");
    }
  }

  @override
  Future<RecognitionResult> recognize(String expectedAnswer) async {
    String result = await listen();
    log(result);
    //TODO:一个更能够应对识别出错的检测
    if (result.contains(expectedAnswer))
      return RecognitionResult.ANSWER_CORRECT;
    else if (result == "")
      return RecognitionResult.ANSWER_NOSOUND;
    else if (expectedAnswer.contains(result))
      return RecognitionResult.ANSWER_INCOMPLETE;
    else
      return RecognitionResult.ANSWER_WRONG;
  }

  @override
  Future<void> initEngine() async {
    await platform.invokeMethod('initEngine');
  }

  @override
  Future<void> destoryEngine() async {
    await platform.invokeMethod('destroyEngine');
  }
}
