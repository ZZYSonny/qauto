part of 'package:qauto/model/all.dart';

///接收一个含有一句诗词及标点的字符串，并提供一些功能
class ShiJu extends Questionable{
  String rawVerse;
  ///奇数位为诗句，偶数位是标点
  List<String> brokeVerse;
  ShiJu(this.rawVerse){
    brokeVerse = rawVerse.split(new RegExp(r"(?<=[，|。|！])|(?=[，|。|！])"));
    assert(brokeVerse.length==4);
    assert(brokeVerse[1].length==1);
    assert(brokeVerse[3].length==1);
  }

  final String blankLine = "_____";
  @override
  Question toQuestion(){
    String displayDetail;
    String questionAnswer;
    String questionAudio;
    if(Global.randInt(2)==0){
      displayDetail = blankLine + brokeVerse[1] + "\n" + brokeVerse[2] + brokeVerse[3];
      questionAnswer = brokeVerse[0];
      questionAudio = brokeVerse[2] + "的前一句是？";
    }else{
      displayDetail = brokeVerse[0] + brokeVerse[1] + "\n" + blankLine + brokeVerse[3];
      questionAnswer = brokeVerse[2];
      questionAudio = brokeVerse[0] + "的后一句是？";
    }
    return InteractiveQuestion("填写上下文", displayDetail, questionAudio, questionAnswer, rawVerse);
    //TODO: 提问有[]的字
  }

  @override
  String getName() {
    return "";
  }
  
}

///完整记录一个诗词，并且能够从这个生成问题
///JSON定义：
///{
/// "类型":"诗",
/// "标题":"诗词名",
/// "作者":"作者名",
/// "策略",".../Smart",
/// "内容": [
///   "被分开一句一句的诗，其中被[]起来的是容易写错的字，会额外问问题" 
/// ] 或者是 一个字符串
///}
class Shi extends Questionable{
  String title;
  String author;
  String strategy;
  List<ShiJu> phrase = [];

  Shi.fromJSON(Map<String, dynamic> json){
    assert(json.containsKey('标题'));
    assert(json.containsKey('作者'));
    assert(json.containsKey('策略'));
    assert(json.containsKey('内容'));
    title = json['标题'];
    author = json['作者'];
    strategy = json['策略'];
    phrase = List<String>.from(json['内容']).map((x)=>(new ShiJu(x))).toList();
    assert(QuestionGroup.strategyMap.containsKey(strategy));
  }

  @override
  Question toQuestion() {
    var questions = phrase.map((x)=>x.toQuestion()).toList();
    //TODO:提问作者、题目
    return new QuestionGroup(questions,this.strategy);
  }

  @override
  String getName() {
    return title;
  }
}
