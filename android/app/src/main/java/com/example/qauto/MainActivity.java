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
        //获取OpenWith Intent的MethodChannel
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "com.example.qauto/file")
                .setMethodCallHandler((call, result) -> {
                            switch (call.method) {
                                case "getIntentFileContent":
                                    result.success(readIntentFileContent());
                                    break;
                                case "requestAllPermission":
                                    requestAllPermission();
                                    result.success(true);
                                    break;
                                default:
                                    result.notImplemented();
                                    break;
                            }
                        }
                );
    }

    private String readIntentFileContent() {
        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();
        if (Intent.ACTION_VIEW.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                try {
                    Uri uri = intent.getData();
                    assert (uri != null);
                    InputStream is = getContentResolver().openInputStream(uri);
                    byte[] buffer = new byte[is.available()];
                    is.read(buffer);
                    return new String(buffer);
                } catch (Exception e) {
                    return null;
                }
            }
        }
        return null;
    }

    private void requestAllPermission() {
        String[] permissions = {
                Manifest.permission.RECORD_AUDIO,
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.INTERNET,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.ACCESS_WIFI_STATE
        };
        requestPermissions(permissions, 0);
    }
}
