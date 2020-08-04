part of 'package:qauto/user/all.dart';

class TestQuestionPageState extends QuestionPageState{
  TestQuestionPageState(){
    Global.page=this;
  }
  @override
  void showQuestion(String caption, String detail) {
    //修改界面是同时log
    log("Display:Caption:$caption");
    log("Display:Detail:$detail");
  }
}

///通过log来模拟声音输出和回答
class TestAudioController extends AudioController{
  Future<bool> init() async {return true;}

  Future<void> fakeAudioDelay() async =>
    Future.delayed(Duration(milliseconds: 600));

  bool _readLock = false;
  Future<void> speak(String sentence) async {
    if (_readLock) {
      throw Future.error("有两个毒瘤在朗读句子");
    } else {
      _readLock = true;
      log("Audio:Question:" + sentence);
      await fakeAudioDelay();
      _readLock = false;
    }
  }

  Future<RecognitionResult> listen(String expectedAnswer) async{
    int id = Global.randInt(RecognitionResult.values.length);
    RecognitionResult result = RecognitionResult.values[id];
    if(result==RecognitionResult.ANSWER_CORRECT) log("Audio:Answer:$expectedAnswer");
    else log("Audio:Answer:我不会");
    fakeAudioDelay();
    return result;
  }
}