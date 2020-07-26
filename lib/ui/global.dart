part of 'package:qauto/ui/all.dart';

class Global{
  static QuestionPageState page;
  static AudioController audio=new PseudoAudioController();
  static Random rng = new Random();
  static int randInt(int n){
    return rng.nextInt(n);
  }
}