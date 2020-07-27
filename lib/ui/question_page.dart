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
  String _displayCaption = "标题";
  String _displayDetail = "问题";

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
                  askFromFile("sample");
                },
                child: const Text('开始', style: TextStyle(fontSize: 20)),
              ),
              RaisedButton(
                onPressed: () {
                  //TODO:Test Only
                  log("I can still move");
                },
                child: const Text('开始', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ));
  }
}

class TestQuestionPageState extends QuestionPageState{
  TestQuestionPageState(){
    Global.page=this;
  }
  @override
  void showQuestion(String caption, String detail) {
    log("Display:Caption:$caption");
    log("Display:Detail:$detail");
  }
}