package com.example.qauto;

import android.content.Context;
import android.media.AudioManager;
import android.media.ToneGenerator;
import android.os.Handler;
import android.os.Looper;

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

import java.io.File;
import java.lang.reflect.Method;

import io.flutter.plugin.common.MethodChannel.Result;

public class AiSpeech extends Speech{
    private Result initResult;
    private Result ttsResult;
    private Result asrResult;
    private File cacheDir;
    //注册设备
    public void init(Context context, Result result){
        initResult = result;
        cacheDir = context.getExternalCacheDir();
        //产品认证需设置 apiKey, productId, productKey, productSecret
        DUILiteConfig config = new DUILiteConfig(
                "7dd4827f9b2f7dd4827f9b2f5f281027",
                "279596193",
                "ad50e99fc305084aaa95eaabc561e4cc",
                "304015f73706e80f20b010a650b4447e"
        );
        DUILiteSDK.init(context, config, new DUILiteSDK.InitListener() {
            @Override public void success() {
                initEngine();
                Log.d("TAG", "授权成功! ");
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        initResult.success(true);
                        initResult = null;
                    }
                });
            }
            @Override public void error(String errorCode,String errorInfo) {
                Log.d("TAG", "授权失败, errorcode: "+errorCode+",errorInfo:"+errorInfo);
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        initResult.error("FlutterChannel.AISpeechError","授权失败",null);
                        initResult = null;
                    }
                });
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
        ttsIntent.setSaveAudioPath(cacheDir + "/aispeech/tts");//设置合成音的保存路径
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
        //asrIntent.setPauseTime(500);
        //asrIntent.setWaitingTimeout(5000);
        asrIntent.setNoSpeechTimeOut(4000);
        asrIntent.setSaveAudioPath(cacheDir + "/aispeech/stt");
    }

    private AICloudTTSEngine ttsEngine;
    private AICloudTTSConfig ttsConfig;
    private AICloudTTSIntent ttsIntent;
    public void speak(String text, Result result){
        if(ttsResult!=null) result.error("FlutterChannel.AISpeechError","已经有一个语音合成了",null);
        ttsResult = result;
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
        @Override public void onError(String s, AIError error) {
            Log.e("TAG", "onError: " + s + "," + error.toString());
            ttsResult.error("FlutterChannel.AISpeechError",error.toString(),null);
            ttsResult=null;
        }
        @Override public void onReady(String s) {
            Log.e("TAG", "onReady: " + s);
        }
        @Override public void onCompletion(String s) {
            Log.e("TAG", "合成完成 onCompletion: " + s);
            ttsResult.success(true);
            ttsResult = null;
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

    public void listen(Result result){
        if(asrResult!=null) result.error("FlutterChannel.AISpeechError","已经有一个语音识别了",null);
        asrResult = result;
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
            asrEngine.cancel();
            asrResult.error("FlutterChannel.AISpeechError",aiError.toString(),null);
            asrResult = null;
        }

        @Override public void onResults(AIResult aiResult) {
            if (aiResult.isLast()) {
                if (aiResult.getResultType() == AIConstant.AIENGINE_MESSAGE_TYPE_JSON) {
                    asrEngine.cancel();
                    Log.i("Tag", "result JSON = " + aiResult.getResultObject().toString());
                    asrResult.success(aiResult.getResultObject().toString());
                    asrResult = null;
                    //使用asrEngine.stop()目前不会AudioRecord pause()，所以在获得结果后cancel()
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
