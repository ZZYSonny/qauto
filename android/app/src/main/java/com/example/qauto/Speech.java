package com.example.qauto;

import android.content.Context;

import java.io.File;
import io.flutter.plugin.common.MethodChannel.Result;

public abstract class Speech{
    public abstract void init(Context context, Result result);
    public abstract void speak(String text, Result result);
    public abstract void listen(Result result);

}
