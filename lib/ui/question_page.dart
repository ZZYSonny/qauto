part of 'package:qauto/ui/all.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  QuestionPageState createState() => QuestionPageState();
}

class QuestionPageState extends State<QuestionPage> {
  QuestionPageState(){
    //注册自己为问题窗口
    Global.page=this;
  }

  //tmp
  String _displayCaption = "上下文填空";
  String _displayDetail = "床前明月光,\n_____";

  ///修改当前显示的问题,同时初始化结果栏
  void showQuestion(String caption, String detail) {
    setState(() {
      _displayCaption = caption;
      _displayDetail = detail;
    });
  }

  ///TODO:修改结果栏
  void showAnswer(){

  }

  ///TODO:修改
  void showStats(){

  }

  //确保只有一个问题在跑
  bool _running=false;
  Future<void> askQuestion(Question q) async {
    if(!_running){
      _running=true;
      await q.execute();
      _running=false;
    }
  }

  void askFromFile(String filename) async {
    var question = await Questionable.fromFile(filename);
    await askQuestion(question.toQuestion());
  }

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
                  //TODO:Test Only
                  /*var question = new QuestionGroup([
                      new SimpleQuestion("计算", "1+1=?", "一加一等于几", "二"),
                      new SimpleQuestion("计算", "1+2=?", "一加二等于几", "三")
                    ],"Sequential");*/
                  askFromFile("sample");
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
