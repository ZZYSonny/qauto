package com.example.qauto;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public abstract class Speech{
    protected SpeechStatus status = SpeechStatus.NO_AUTH_NO_ENGINE;

    /**
     * 注册设备
     * @param result    Flutter的Result
     */
    public abstract void auth(Result result);

    /**
     * 初始化引擎
     * 必须在auth后运行
     * @param result    Flutter的Result
     */
    public abstract void initEngine(Result result);

    /**
     * 合成指定文本并播放
     * @param text      文本
     * @param result    Flutter的Result
     */
    public abstract void speak(String text, Result result);

    /**
     * 识别语音，返回字符串
     * @param result    Flutter的Result
     */
    public abstract void listen(Result result);

    /**
     * 销毁所有引擎
     */
    public abstract void destroyEngine();

    /**
     * 根据Flutter的MethodCall选择函数
     * @param call      Flutter的MethodCall
     * @param result    Flutter的Result
     */
    public void dispatch(MethodCall call,Result result){
        switch (call.method) {
            case "auth":
                if(status==SpeechStatus.NO_AUTH_NO_ENGINE) auth(result);
                else result.success(true);
                break;
            case "initEngine":
                if(status==SpeechStatus.AUTHED_NO_ENGINE) initEngine(result);
                else if(status==SpeechStatus.AUTH_ENGINE) result.success(true);
                else result.error("","在创建引擎前还没有成功认证",status.toString());
                break;
            case "destroyEngine":
                if(status==SpeechStatus.AUTH_ENGINE) {destroyEngine();result.success(true);}
                else result.success(true);
                break;
            case "speak":
                if(status==SpeechStatus.AUTH_ENGINE) speak(call.argument("text"),result);
                else result.error("","在tts前还没有创建引擎",status.toString());
                break;
            case "listen":
                if(status==SpeechStatus.AUTH_ENGINE) listen(result);
                else result.error("","在asr前还没有创建引擎",status.toString());
                break;
            default:
                result.notImplemented();
                break;
        }

    }
}

enum SpeechStatus{
    NO_AUTH_NO_ENGINE,
    AUTHED_NO_ENGINE,
    AUTH_ENGINE;
}