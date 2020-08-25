part of 'package:qauto/user/all.dart';

class QuestionPageController extends QuestionPageState {
  QuestionPageController() {
    Global.page = this;
  }

  ///Init时使用，初始化标题,问题,标题
  void showInit(String caption, String detail, bool button, String titleSuffix){
    setState(() {
      _title = "背诗自动机：" + titleSuffix;
      _displayCaption = caption;
      _displayDetail = detail;
      _buttonEnabled = button;
    });
  }

  ///修改当前显示的问题,同时初始化结果栏
  void showQuestion(String caption, String detail) {
    setState(() {
      _displayCaption = caption;
      _displayDetail = detail;
    });
  }

  ///修改结果栏
  void showAnswer(String detail) {
    setState(() {
      _displayDetail = detail;
    });
  }

  ///更新统计数据
  void showStats(String stats) {
    setState(() {
      _statsDetail = stats;
    });
  }

  Questionable _resource;
  @override
  void onStartButton() {
    askQuestion(_resource.toQuestion());
  }

  ///根据应用的打开状态初始化界面
  void init() async {
    String fileContent = await prepare();
    if (fileContent != null) {
      var resource = await Questionable.fromString(fileContent);
      if (resource == null) showInit("", "文件可能有误", false, "");
      else {
        _resource = resource;
        showInit("", "已准备就绪", true, resource.getName());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose(){
    super.dispose();
    Global.audio.destoryEngine();
  }
}
