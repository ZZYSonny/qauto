package com.example.qauto;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public abstract class Speech{
    protected boolean inited = false;
    public abstract void init(Result result);
    public abstract void speak(String text, Result result);
    public abstract void listen(Result result);
    public void dispatch(MethodCall call,Result result){
        switch (call.method) {
            case "init":
                if(!inited) init(result);
                break;
            case "speak":
                speak(call.argument("text"),result);
                break;
            case "listen":
                listen(result);
                break;
            default:
                result.notImplemented();
                break;
        }

    }
}
