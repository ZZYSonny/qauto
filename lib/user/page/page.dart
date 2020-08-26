part of 'package:qauto/user/all.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key}) : super(key: key);

  @override
  QuestionPageController createState() => QuestionPageController();
}

abstract class QuestionPageState extends State<QuestionPage> {
  String _title = "背诗自动机";
  String _displayCaption = "";
  String _displayDetail = "读取文件中";
  PageState _state = PageState.NOT_INITED;
  String _statsDetail = "0 / 0";
  ///开始按钮被按后的反应
  void onStartButton();
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

  ///TODO:添加录音时的标记
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
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
}
