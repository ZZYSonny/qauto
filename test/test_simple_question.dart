import 'package:flutter_test/flutter_test.dart';

import 'package:qauto/questions/all.dart';
import 'package:qauto/ui/all.dart';
void main() {

  //set up global stuff
  var testpage = TestQuestionPageState();
  Global.audio = new PseudoAudioController();
  
  test('SimpleQuestion运行顺序是正确的', () async {
    logged="";
    var q = new SimpleQuestion("caption", "detail", "audio", "answer");
    await q.execute();
    String expectedLog1 ="Display:Caption:caption\n"
                        +"Display:Detail:detail\n"
                        +"Audio:Question:audio\n"
                        +"Audio:Answer:我不会\n"
                        +"Audio:Question:答错了\n";
    String expectedLog2 ="Display:Caption:caption\n"
                        +"Display:Detail:detail\n"
                        +"Audio:Question:audio\n"
                        +"Audio:Answer:answer\n"
                        +"Audio:Question:答对了\n";
    expect(logged==expectedLog1 || logged==expectedLog2,true);
  });

}
