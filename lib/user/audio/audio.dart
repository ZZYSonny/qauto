part of 'package:qauto/user/all.dart';

///!!!这里的大部分函数都应该是async的
abstract class AudioController{
  Future<bool> init();

  ///播放一句话，并且在播放接触后返回
  ///同一时间应该最多只有一个在跑
  Future<void> readSentence(String sentence);
  
  ///给定一些希望被听到的内容，在没有声音的时候停止录音
  ///返回听到内容对应的序号，如果没有分辨出来就再来一次
  Future<int> listenForSentences(List<String> expectedAnswers,
      [bool allowNoResult = true]);
}