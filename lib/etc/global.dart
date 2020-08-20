part of 'package:qauto/etc/all.dart';

class Global{
  static QuestionPageController page;
  static AudioController audio=new AISpeechAudioController();
  static Random rng = new Random();
  static int randInt(int n){
    return rng.nextInt(n);
  }
  static bool randBool(double p){
    return rng.nextInt(10000)<10000*p;
  }
}

///Memorize logged data for test
List<String> logged = [];
void log(String str){
  dev.log(str);
  logged.insert(logged.length, str);
}