part of 'package:qauto/model/all.dart';


///定义问题,提供execute作为提问的接口
abstract class Question {
  ///整个问题的执行
  Future<QuestionStats> execute();
}

///定义资源,这些资源能够生产Question
abstract class Questionable {
  Question toQuestion();

  ///从JSON中生成Questionable
  static Future<Questionable> fromString(String jsonStr) async {
    try {
      var jsonResult = await json.decode(jsonStr);
      return fromJSON(jsonResult);
    } catch (Exception) {
      return null;
    }
  }

  ///从解析好的jsonmap中生成Questionable
  static Questionable fromJSON(Map<String, dynamic> json) {
    switch (json['类型']) {
      case '问题组':
        return new QuestionableGroup.fromJSON(json);
      case '诗':
        return new Shi.fromJSON(json);
      default:
        throw Exception("No such type");
    }
  }
  
  ///获取名称
  String getName();
}
