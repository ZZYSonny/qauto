part of 'package:qauto/user/all.dart';

class QuestionPageController extends QuestionPageState{
  QuestionPageController() {
    Global.page = this;
  }

  ///Init时使用，初始化标题,问题,标题
  void showInit(
      String caption, String detail, PageState button, String titleSuffix) {
    setState(() {
      _title = "背诗自动机：" + titleSuffix;
      _displayCaption = caption;
      _displayDetail = detail;
      _state = button;
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
    assert(_state == PageState.INITED_NOT_STARTED);
    setState(() {
      _state = PageState.STARTED;
      _title = "背诗自动机：" + _resource.getName();
    });
    askQuestion(_resource.toQuestion());
  }

  @override
  void onStopButton(){
    assert(_state == PageState.STARTED);
    showInit("", "已停止", PageState.INITED_NOT_STARTED, "已停止");
    stopQuestion();
  }

  ///根据应用的打开状态初始化界面
  void init() async {
    String fileContent = await prepare();
    if (fileContent != null) {
      var resource = await Questionable.fromString(fileContent);
      if (resource == null)
        showInit("", "文件可能有误", PageState.NOT_INITED, "");
      else {
        _resource = resource;
        showInit("", "已准备就绪", PageState.INITED_NOT_STARTED , resource.getName());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    Global.audio.destoryEngine();
    super.dispose();
  }
}
