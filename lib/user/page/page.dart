part of 'package:qauto/user/all.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  QuestionPageController createState() => QuestionPageController();
}

class QuestionPageState extends State<QuestionPage> {
  String _displayCaption = "";
  String _displayDetail = "未选择文件";
  bool _buttonEnabled=false;

  void onStartButton() {}

  ///TODO:慢慢美化
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
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
              RaisedButton(
                onPressed: _buttonEnabled?onStartButton:null,
                child: Text("开始", style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ));
  }
}
