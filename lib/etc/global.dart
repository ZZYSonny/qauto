part of 'package:qauto/etc/all.dart';

///全局变量,这些变量只能同时存在一个
class Global {
  ///提问界面,提供修改界面的函数
  static QuestionPageController page;

  ///语言控制,提供语音合成和识别
  static AudioController audio = new AISpeechAudioController();
  static Random rng = new Random();

  ///生成一个[0,n)的数字
  static int randInt(int n) {
    return rng.nextInt(n);
  }

  ///p的概率生成true
  static bool randBool(double p) {
    return rng.nextInt(10000) < 10000 * p;
  }
}

///Memorize logged data for test
List<String> logged = [];
void log(String str) {
  dev.log(str);
  logged.insert(logged.length, str);
}
