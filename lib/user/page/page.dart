part of 'package:qauto/user/all.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key}) : super(key: key);

  @override
  QuestionPageController createState() => QuestionPageController();
}

abstract class QuestionPageState extends State<QuestionPage> {
  String _title = "背诗自动机";
  String _displayCaption = "";
  String _displayDetail = "未选择文件";
  bool _buttonEnabled=false;
  String _statsDetail = "0 / 0";
  ///开始按钮被按后的反应
  void onStartButton();

  ///TODO:慢慢美化
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
              RaisedButton(
                onPressed: _buttonEnabled?onStartButton:null,
                child: Text("开始", style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ));
  }
}
