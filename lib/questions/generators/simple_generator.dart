part of 'package:qauto/questions/all.dart';

abstract class QuestionGenerator {
  Question next();
}

abstract class QuestionGeneratorWithResult extends QuestionGenerator {
  bool _lastResult = true;
  int _totalProblem = 0;
  int _totalCorrect = 0;

  void submitResult(bool res) {
    _lastResult = res;
    if (res) _totalCorrect += 1;
    _totalProblem += 1;
  }

  String showStats() {
    return "$_totalCorrect / $_totalProblem";
  }

  bool getLastResult() {
    return _lastResult;
  }
}

class QuestionTesterGen extends QuestionGeneratorWithResult {  
  Question next() {
    return new SimpleQuestion("计算", "1+1=_", "一加一等于几？", "二");
  }
}
