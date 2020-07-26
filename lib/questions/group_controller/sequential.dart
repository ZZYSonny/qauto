part of 'package:qauto/questions/all.dart';

abstract class QGroupController {
  Future<void> execute();
  String showStats();
}

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
