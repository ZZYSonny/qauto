part of 'package:qauto/model/all.dart';

///接收一个含有一句诗词及标点的字符串，并提供一些功能
class Verse extends Questionable{
  String rawVerse;
  ///奇数位为诗句，偶数位是标点
  List<String> brokeVerse;
  Verse(this.rawVerse){
    brokeVerse = rawVerse.split(new RegExp(r"(?<=[，|。|!])|(?=[，|。|!])"));
  }

  final String blankLine = "_____";
  @override
  Question toQuestion(){
    int n=brokeVerse.length;
    int chosenid=Global.randInt((n/2).truncate().toInt())*2;
    String expectedAnswer = brokeVerse[chosenid];
    brokeVerse[chosenid] = blankLine;
    String displayDetail = brokeVerse.join();
    brokeVerse[chosenid] = expectedAnswer;
    String audioSentence = "Not decided";
    return new SimpleQuestion( "填写上下文", displayDetail, audioSentence, expectedAnswer);
    //TODO: 提问有[]的字
  }
}

///完整记录一个诗词，并且能够从这个生成问题
///JSON定义：
///{
/// "type":"poem/文言文",
/// "title":"诗词名",
/// "author":"作者名",
/// "strategy",".../Smart",
/// "content": [
///   "被分开一句一句的诗，其中被[]起来的是容易写错的字，会额外问问题" 
/// ] 或者是 一个字符串
///}
class Poem extends Questionable{
  String title;
  String author;
  String strategy;
  List<Verse> phrase = [];

  Poem.fromJSON(Map<String, dynamic> json)
      : this.title = json['title'],
        this.author = json['author'],
        this.strategy = json['strategy'],
        this.phrase = List<String>.from(json['content']).map((x)=>(new Verse(x))).toList();

  @override
  Question toQuestion() {
    var questions = phrase.map((x)=>x.toQuestion()).toList();
    //TODO:提问作者、题目
    return new QuestionGroup(questions,this.strategy);
  }
}
