package com.example.qauto;

import android.Manifest;
import android.media.AudioManager;
import android.media.ToneGenerator;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import com.aispeech.*;
import com.aispeech.common.AIConstant;
import com.aispeech.export.config.AICloudASRConfig;
import com.aispeech.export.config.AICloudTTSConfig;
import com.aispeech.export.engines2.AICloudASREngine;
import com.aispeech.export.engines2.AICloudTTSEngine;
import com.aispeech.export.intent.AICloudASRIntent;
import com.aispeech.export.intent.AICloudTTSIntent;
import com.aispeech.export.listeners.AIASRListener;
import com.aispeech.export.listeners.AITTSListener;
import com.aispeech.upload.util.Log;


public class MainActivity extends FlutterActivity{
    private <T> void returnError(String message){
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                result.error("FlutterChannel.AISpeechError",message,null);
                result = null;
            }
        });
    }


    private static final String CHANNEL = "com.example.qauto/aispeech";
    private MethodChannel.Result result;
    @Override public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, newResult) -> {
                            if(result!=null) returnError("Already doing sth else");
                            result = newResult;
                            switch (call.method) {
                                case "init":
                                    init();
                                    break;
                                case "speak":
                                    speak(call.argument("text"));
                                    break;
                                case "listen":
                                    listen();
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

    //注册设备
    private void init(){
        requestPerms();
        //产品认证需设置 apiKey, productId, productKey, productSecret
        DUILiteConfig config = new DUILiteConfig(
            "7dd4827f9b2f7dd4827f9b2f5f281027",
            "279596193",
            "ad50e99fc305084aaa95eaabc561e4cc",
            "304015f73706e80f20b010a650b4447e"
        );
        DUILiteSDK.init(getApplicationContext(), config, new DUILiteSDK.InitListener() {
            @Override public void success() {
                initEngine();
                Log.d("TAG", "授权成功! ");
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        result.success(true);
                        result = null;
                    }
                });
            }
            @Override public void error(String errorCode,String errorInfo) {
                Log.d("TAG", "授权失败, errorcode: "+errorCode+",errorInfo:"+errorInfo);
                returnError("授权失败");
            }
        });
    }

    //初始化引擎
    private void initEngine(){
        //tts
        ttsEngine = AICloudTTSEngine.createInstance();
        ttsConfig = new AICloudTTSConfig();
        ttsIntent = new AICloudTTSIntent();
        ttsEngine.init(ttsConfig, new AITTSListenerImpl());
        ttsIntent.setSaveAudioPath(Environment.getExternalStorageDirectory() + "/tts");//设置合成音的保存路径
        ttsIntent.setSpeaker("xijunma");
        ttsIntent.setVolume("100");
        ttsIntent.setSpeed("1.0");
        //asr
        asrConfig = new AICloudASRConfig();
        asrConfig.setLocalVadEnable(true);
        asrConfig.setVadResource("vad_aihome_v0.11.bin");
        asrEngine = AICloudASREngine.createInstance();
        asrEngine.init(asrConfig, new AICloudASRListenerImpl());
        asrIntent = new AICloudASRIntent();
        asrIntent.setEnablePunctuation(false);
        asrIntent.setResourceType("comm");
        asrIntent.setEnableNumberConvert(false);
        asrIntent.setEnableSNTime(false);
        asrIntent.setCloudVadEnable(false);
        asrIntent.setPauseTime(500);
        asrIntent.setWaitingTimeout(5000);
        asrIntent.setNoSpeechTimeOut(0);
        asrIntent.setSaveAudioPath(Environment.getExternalStorageDirectory() + "/stt");
    }

    private AICloudTTSEngine ttsEngine;
    private AICloudTTSConfig ttsConfig;
    private AICloudTTSIntent ttsIntent;
    private void speak(String text){
        ttsEngine.speak(ttsIntent, text, "1024");
    }

    class AITTSListenerImpl implements AITTSListener {
        @Override public void onInit(int status) {
            Log.d("TAG", "onInit()");
            if (status == AIConstant.OPT_SUCCESS) {
                Log.i("Tag", "初始化成功!");
            } else {
                Log.i("Tag", "初始化失败!");
            }
        }
        @Override public void onError(String s, AIError Error) {
            Log.e("TAG", "onError: " + s + "," + Error.toString());
            returnError(Error.toString());
        }
        @Override public void onReady(String s) {
            Log.e("TAG", "onReady: " + s);
        }
        @Override public void onCompletion(String s) {
            Log.e("TAG", "合成完成 onCompletion: " + s);
            result.success(true);
            result = null;
        }
        @Override public void onProgress(int currentTime, int totalTime, boolean isRefTextTTSFinished) {}
        @Override public void onSynthesizeStart(String s) {}
        @Override public void onSynthesizeDataArrived(String s, byte[] bytes) {}
        @Override public void onSynthesizeFinish(String s) {}
    }

    private AICloudASREngine asrEngine;
    private AICloudASRConfig asrConfig;
    private AICloudASRIntent asrIntent;

    ToneGenerator beepGen = new ToneGenerator(AudioManager.STREAM_MUSIC, 100);
    void beep(){
        beepGen.startTone(ToneGenerator.TONE_CDMA_PIP,100);
    }

    private void listen(){
        asrEngine.start(asrIntent);
    }

    private class AICloudASRListenerImpl  implements AIASRListener {
        @Override public void onInit(int status) {
            Log.i("TAG", "Init result " + status);
            if (status == AIConstant.OPT_SUCCESS) {
                Log.d("TAG", "初始化成功!");
            } else {
                Log.d("TAG", "初始化失败!code:" + status);
            }
        }

        @Override public void onError(AIError aiError) {
            Log.e("Tag", "error:" + aiError.toString());
            returnError(aiError.toString());
        }

        @Override public void onResults(AIResult aiResult) {
            if (aiResult.isLast()) {
                if (aiResult.getResultType() == AIConstant.AIENGINE_MESSAGE_TYPE_JSON) {
                    Log.i("Tag", "result JSON = " + aiResult.getResultObject().toString());
                    result.success(aiResult.getResultObject().toString());
                    result = null;
                    //使用asrEngine.stop()目前不会AudioRecord pause()，所以在获得结果后cancel()
                    asrEngine.cancel();
                }
            }
        }

        @Override public void onRmsChanged(float v) {}

        @Override public void onReadyForSpeech() {
            Log.d("TAG", "语音引擎就绪，用户可以说话");
            beep();
        }

        @Override public void onBeginningOfSpeech() {
            Log.d("TAG", "检测到用户开始说话");
        }

        @Override public void onEndOfSpeech() {
            Log.d("TAG", "用户停止说话");
            asrEngine.stop();
        }

        @Override public void onRawDataReceived(byte[] bytes, int i) {

        }

        @Override public void onResultDataReceived(byte[] bytes, int i) {

        }

        @Override public void onNotOneShot() {

        }
    }


}

