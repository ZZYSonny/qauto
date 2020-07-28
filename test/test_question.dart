import 'package:flutter_test/flutter_test.dart';

import 'package:qauto/questions/all.dart';
import 'package:qauto/ui/all.dart';

void main() {
  //set up global stuff
  var testpage = TestQuestionPageState();
  Global.audio = new TestAudioController();

  test('SimpleQuestion运行顺序是正确的', () async {
    for (var i = 0; i < 10; i++) {
      logged = [];
      var q = new SimpleQuestion("caption", "detail", "audio", "answer");
      var res = await q.execute();
      expect(logged[0], "Display:Caption:caption");
      expect(logged[1], "Display:Detail:detail");
      expect(logged[2], "Audio:Question:audio");
      if (res) {
        expect(logged[3], "Audio:Answer:answer");
        expect(logged[4], "Audio:Question:答对了");
      } else {
        expect(logged[3], "Audio:Answer:我不会");
        expect(logged[4], "Audio:Question:答错了");
      }
    }
  });

  test('QuestionGroup Sequential顺序是正常的', () async{
    logged = [];
    var q1 = new SimpleQuestion("caption1", "detail1", "audio1", "answer1");
    var q2 = new SimpleQuestion("caption2", "detail2", "audio2", "answer2");
    var q3 = new SimpleQuestion("caption3", "detail3", "audio3", "answer3");
    await q1.execute();
    await q2.execute();
    await q3.execute();
    var logged1 = logged;
    logged = [];
    var qq = new QuestionGroup([q1,q2,q3], "Sequential");
    await qq.execute();
    for(var i=0;i<logged.length;i++){
      if(logged[i].startsWith("Display:Caption")) expect(logged[i],logged1[i]);
      //Audio有一些随机所有就不对比了
    }
  });
}
