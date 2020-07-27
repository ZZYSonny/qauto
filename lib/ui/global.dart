part of 'package:qauto/ui/all.dart';

class Global{
  static QuestionPageState page;
  static AudioController audio=new PseudoAudioController();
  static Random rng = new Random();
  static int randInt(int n){
    return rng.nextInt(n);
  }
  static bool underTest = false;
}

///Memorize logged data for test
String logged = "";
void log(String str){
  dev.log(str);
  logged+=str+"\n";
}