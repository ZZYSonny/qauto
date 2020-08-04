package com.example.qauto;

import android.Manifest;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;



public class MainActivity extends FlutterActivity{
    private static final String CHANNEL = "com.example.qauto/aispeech";
    Speech speech = new AiSpeech();
    @Override public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "init":
                                    requestPerms();
                                    speech.init(getApplicationContext(),result);
                                    break;
                                case "speak":
                                    speech.speak(call.argument("text"),result);
                                    break;
                                case "listen":
                                    speech.listen(result);
                                    break;
                                default:
                                    result.notImplemented();
                                    break;
                            }
                        }
                );
    }

    private void requestPerms(){
        String[] perms = {
                Manifest.permission.RECORD_AUDIO,
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.INTERNET,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.ACCESS_WIFI_STATE
        };
        requestPermissions(perms,0);
    }
}

