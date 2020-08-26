part of 'package:qauto/user/all.dart';

class QuestionPageController extends QuestionPageState {
  QuestionPageController() {
    Global.page = this;
  }

  ///修改当前显示的问题,同时初始化结果栏
  void setQuestion(String caption, String detail) {
    setState(() {
      _displayCaption = caption;
      _displayDetail = detail;
    });
  }

  ///修改结果栏，
  void setAnswer(String detail) {
    setState(() {
      _displayDetail = detail;
    });
  }

  ///更新统计数据
  void setStats(String stats) {
    setState(() {
      _statsDetail = stats;
    });
  }

  ///Init时使用，初始化标题,问题,标题
  void setAllState(PageState state, String detail, [String titleSuffix = ""]) {
    setState(() {
      _title = "背诗自动机：" + titleSuffix;
      _displayCaption = "";
      _displayDetail = detail;
      _state = state;
    });
  }

  ///根据应用的打开状态初始化界面
  Future<void> setQuestionResource(String fileContent) async {
    if (fileContent == null)
      setAllState(PageState.NOT_INITED, "未选择文件");
    else {
      _resource = await Questionable.fromString(fileContent);
      if (_resource == null)
        setAllState(PageState.NOT_INITED, "文件可能有误");
      else
        setAllState(PageState.INITED_NOT_STARTED, "已准备就绪", _resource.getName());
    }
  }

  Questionable _resource;
  @override
  void onStartButton() {
    assert(_state == PageState.INITED_NOT_STARTED);
    setAllState(PageState.STARTED, "", _resource.getName());
    Facade.askQuestion(_resource.toQuestion());
  }

  @override
  void onStopButton() {
    assert(_state == PageState.STARTED);
    Facade.stopQuestion();
  }

  @override
  void initState() {
    super.initState();
    Facade.prepare();
  }
}
