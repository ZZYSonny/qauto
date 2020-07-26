part of 'package:qauto/ui/all.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  QuestionPageState createState() => QuestionPageState();
}

class QuestionPageState extends State<QuestionPage> {
  String _displayCaption = "上下文填空";
  String _displayDetail = "床前明月光,\n_____";

  ///修改当前显示的问题,同时初始化结果栏
  void showQuestion(String caption, String detail) {
    setState(() {
      _displayCaption = caption;
      _displayDetail = detail;
    });
  }

  ///
  void showAnswerResult(){

  }

  ///
  void showStats(){

  }

  ///TODO:接受一个问题生成器，不停的问问题
  ///这个audio要不要留在State里？
  var audio = new AudioController();

  Future<void> askQuestions(QuestionGeneratorWithResult qgen) async {
    while (true) {
      Question question = qgen.next();
      bool res = await question.execute(this,audio);
      qgen.submitResult(res);
      log(qgen.showStats());
    }
  }

  var samplegen = new QuestionTesterGen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_displayCaption',
                textAlign: TextAlign.left,
              ),
              Text(
                '$_displayDetail',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                onPressed: () {
                  askQuestions(samplegen);
                },
                child: const Text('开始', style: TextStyle(fontSize: 20)),
              ),
              RaisedButton(
                onPressed: () {
                  log("I can still move");
                },
                child: const Text('开始', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ));
  }
}
