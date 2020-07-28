import 'package:flutter_test/flutter_test.dart';

import 'package:qauto/resource/all.dart';
import 'package:qauto/ui/all.dart';

void main() {
  //set up global stuff
  var testpage = TestQuestionPageState();
  Global.audio = new TestAudioController();

  test("Verse在构造时,如果标点有错会报错",(){

  });

  test("Verse在构造时,能处理结尾没标点的句子",(){

  });

  test("Verse.toQuestion返回的问题来自原诗句 ",(){

  });

  test("Verse能够提问[]中的字",(){
  });

  test("Poem.fromJSON能够正确导入数据及数据类型",(){

  });

  test("Poem.fromJSON在缺少数据时会报错",(){

  });

  test("Poem.toQuestsion返回的QuestionGroup包含所有句子和其他问题",(){

  });
}
