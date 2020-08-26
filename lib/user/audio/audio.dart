part of 'package:qauto/user/all.dart';

abstract class AudioController {

  ///初始化
  Future<bool> auth();

  Future<void> initEngine();

  Future<void> destoryEngine();

  ///播放一句话,并且在播放接触后返回
  ///同一时间应该最多只有一个在跑
  Future<void> speak(String sentence);

  ///给定一些希望被听到的内容,在没有声音的时候停止录音
  ///返回enum结果
  Future<RecognitionResult> recognize(String expectedAnswer);
}

enum RecognitionResult {
  ANSWER_CORRECT,
  ANSWER_WRONG,
  ANSWER_INCOMPLETE,
  ANSWER_UNSURE,
  ANSWER_NOSOUND
}
