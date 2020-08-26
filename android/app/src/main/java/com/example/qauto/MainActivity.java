package com.example.qauto;

import android.Manifest;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.InputStream;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;


public class MainActivity extends FlutterActivity {
    Speech speech;
    Result permissionResult;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        //初始化speech
        speech = new AiSpeech(getApplicationContext());
        //语音API的MethodChannel
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "com.example.qauto/speech")
                .setMethodCallHandler((call, result) -> speech.dispatch(call, result));
    }

    @Override
    public void onStop(){
        speech.destroyEngine();
        super.onStop();
    }
}
