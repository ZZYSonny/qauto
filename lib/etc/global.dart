part of 'package:qauto/etc/all.dart';

class Global{
  static QuestionPageState page;
  static AudioController audio=new TestAudioController();
  static Random rng = new Random();
  static int randInt(int n){
    return rng.nextInt(n);
  }
  static bool underTest = false;
}

///Memorize logged data for test
List<String> logged = [];
void log(String str){
  dev.log(str);
  logged.insert(logged.length, str);
}