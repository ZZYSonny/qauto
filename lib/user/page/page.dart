part of 'package:qauto/user/all.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key}) : super(key: key);

  @override
  QuestionPageController createState() => QuestionPageController();
}

abstract class QuestionPageState extends State<QuestionPage> {
  ///标题
  String _title = "";
  ///问题小字，用于显示问题类型
  String _displayCaption = "";
  ///问题主要部分
  String _displayDetail = "读取文件中";
  ///问题状态，用于确保流程正确
  PageState _state = PageState.NOT_INITED;
  ///显示的正确率
  String _statsDetail = "";
  ///开始按钮被按后的反应
  void onStartButton();
  ///停止按钮被按的反应
  void onStopButton();

  Widget controlButton(){
    switch(_state){
      case PageState.NOT_INITED:
        return RaisedButton(
                onPressed: null,
                child: Text("开始", style: TextStyle(fontSize: 20)),
              );
      case PageState.INITED_NOT_STARTED:
        return RaisedButton(
                onPressed: onStartButton,
                child: Text("开始", style: TextStyle(fontSize: 20)),
              );
      case PageState.STARTED:
        return RaisedButton(
                onPressed: onStopButton,
                child: Text("结束", style: TextStyle(fontSize: 20)),
              );
    }
    return null;
  }

  ///TODO:添加录音时的图标
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("背诗自动机:$_title")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _displayCaption,
                textAlign: TextAlign.left,
              ),
              Text(
                _displayDetail,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Text(
                _statsDetail,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              controlButton()
            ],
          ),
        ));
  }
  
  @override
  void initState() {
    super.initState();
    Facade.prepare();
  }

  @override
  void dispose(){
    System.dispose();
    super.dispose();
  }
}
