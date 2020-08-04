part of 'package:qauto/user/all.dart';

class AISpeechAudioController extends AudioController{
  static const platform = const MethodChannel('com.example.qauto/aispeech');
  
  @override
  Future<bool> init() async{
    return await platform.invokeMethod('init');
  }

  

  @override
  Future<RecognitionResult> listen(String expectedAnswer) async{
    String jsonString = await platform.invokeMethod('listen');
    //String jsonString = '{\"requestId\":\"5f279ee7332793635f000001\",\"eof\":1,\"recordId\":\"5f279ee7332793635f000001\",\"result\":{\"eof\":1,\"sn_start_time\":0,\"conf\":0.998,\"res\":\"comm4dui_v12_rtest_v1\",\"sn_end_time\":4546.062,\"processedWavTime\":4520,\"rec\":\"一 二 三 四 五 六 七 八 九十 十 一 十 二十 三十 四十 五十 六十 七十 八十 九 二十\",\"pinyin\":\"yi er san si wu liu qi ba jiu shi shi yi shi er shi san shi si shi wu shi liu shi qi shi ba shi jiu er shi\"}}';
    Map<String,dynamic> jsonMap = await json.decode(jsonString);
    String result = jsonMap['result']['rec'];
    result = result.replaceAll(" ", "");
    log(result);
    if(result==expectedAnswer) return RecognitionResult.ANSWER_CORRECT;
    else return RecognitionResult.ANSWER_WRONG;
  }

  @override
  Future<void> speak(String text) async{
    log(text);
    await platform.invokeMethod('speak',{"text":text});
  }

}