part of 'package:qauto/ui/all.dart';

abstract class AudioController{
  Future<void> readSentence(String sentence);
  Future<int> listenForSentences(List<String> expectedAnswers,
      [bool allowNoResult = true]);
}

///!!!这里的大部分函数都应该是async的
class PseudoAudioController extends AudioController{
  Future<void> fakeAudioDelay() async =>
    Future.delayed(Duration(milliseconds: 600));

  ///播放一句话，并且在播放接触后返回
  ///同一时间应该最多只有一个在跑
  bool _readLock = false;
  Future<void> readSentence(String sentence) async {
    if (_readLock) {
      throw Future.error("有两个毒瘤在朗读句子");
    } else {
      _readLock = true;
      log("Audio:Question:" + sentence);
      await fakeAudioDelay();
      _readLock = false;
    }
  }

  ///给定一些希望被听到的内容，在没有声音的时候停止录音
  ///返回听到内容对应的序号，如果没有分辨出来就再来一次
  Future<int> listenForSentences(List<String> expectedAnswers,
      [bool allowNoResult = true,int testFixedResult = -1]) async {
    int id;
    if(testFixedResult==-1){
      Random rng = new Random();
      id = rng.nextInt(expectedAnswers.length);
    }else id = testFixedResult;
    await fakeAudioDelay();
    log("Audio:Answer:" + expectedAnswers.asMap()[id]);
    return id;
  }
}