part of 'package:qauto/model/all.dart';

class QuestionStats{
  int totalCorrect=0;
  int totalWrong=0;
  bool lastResult;

  QuestionStats.single(bool result){
    if(result) {
      totalCorrect=1;
      lastResult=true;
      Global.stats.totalCorrect+=1;
    }else {
      totalWrong=1;
      lastResult=false;
      Global.stats.totalWrong+=1;
    }
    Global.stats.updateGlobalPage();
  }

  QuestionStats.empty();

  int totalProblem() {return totalCorrect + totalWrong;}

  void addStats(QuestionStats stats){
    this.totalCorrect+=stats.totalCorrect;
    this.totalWrong+=stats.totalWrong;
    this.lastResult=stats.lastResult;
  }

  void clear(){
    totalCorrect = 0;
    totalWrong = 0;
  }

  bool smartStop(){
    if(lastResult&&totalCorrect>1) return Global.randBool(totalCorrect/(totalProblem()+2));
    else return false;
  }

  void updateGlobalPage(){
    Global.page.showStats("$totalCorrect / ${totalProblem()}");
  }

  String toAudioText(){
    return "总共${totalProblem()}题,你答对了${totalCorrect}题。";
  }
}