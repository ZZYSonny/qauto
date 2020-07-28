part of 'package:qauto/questions/all.dart';

abstract class QGroupController {
  ///按照一定顺序运行List中的问题
  Future<void> execute();

  ///显示统计数据
  String showStats();
}

///按照List中的顺序一个一个问问题
class SequentialController extends QGroupController {
  List<Question> q;
  SequentialController(this.q);

  @override
  Future<void> execute() async{
    for(var nowq in q){
      await nowq.execute();
    }
  }

  @override
  String showStats() {
    // TODO: implement showStats
    return "还没写";
  }

}
