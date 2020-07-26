part of 'package:qauto/resource/all.dart';

///接收一个含有一句诗词及标点的字符串，并提供一些功能
class Verse extends Questionable{
  String rawVerse;
  ///奇数位为诗句，偶数位是标点
  List<String> brokeVerse;
  Verse(this.rawVerse){
    brokeVerse = rawVerse.split(new RegExp(r"(?<=[,|.])|(?=[,|.])"));
  }

  final String blankLine = "_____";
  @override
  Question toQuestion(int mode){
    if(mode==0){
      int n=brokeVerse.length;
      int chosenid=randInt((n/2).truncate().toInt())*2;
      String expectedAnswer = brokeVerse[chosenid];
      brokeVerse[chosenid] = blankLine;
      String displayDetail = brokeVerse.join();
      brokeVerse[chosenid] = expectedAnswer;
      //TODO: AudioSentence From Verse
      String audioSentence = "Not decided";
      return new SimpleQuestion( "填写上下文", displayDetail, audioSentence, expectedAnswer);
    }else throw Exception("Question Mode out of range");
  }
}


///完整记录一个诗词
class Poem extends Questionable{
  int id;
  String title;
  String author;
  List<Verse> phrase = [];

  Poem.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        author = json['email'],
        id = json['id'],
        phrase = json['phrase'];

  @override
  Question toQuestion(int mode) {
    if(mode==0){
      int n = phrase.length;
      return phrase[randInt(n)].toQuestion(0);
    }else throw Exception("Question Mode out of range");
  }
}
