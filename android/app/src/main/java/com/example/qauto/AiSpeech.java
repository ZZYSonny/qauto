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

import io.flutter.Log;
import java.io.File;

import io.flutter.plugin.common.MethodChannel.Result;

public class AiSpeech extends Speech{
    private Result authResult = null;
    private Result ttsResult = null;
    private Result asrResult = null;
    private Result initResult = null;
    private File cacheDir;
    private Context context;

    private AICloudTTSEngine ttsEngine;
    private AICloudTTSConfig ttsConfig;
    private AICloudTTSIntent ttsIntent;

    private AICloudASREngine asrEngine;
    private AICloudASRConfig asrConfig;
    private AICloudASRIntent asrIntent;

    private String API_KEY = "fd6e07bbba54fd6e07bbba545f3b8494";
    private String PRODUCT_ID = "279596536";
    private String PRODUCT_KEY = "883ceea2b13e08056730935daa032c95";
    private String PRODUCT_SECRET = "229678678e5c1532ac57170dd17a9c98";
    private String DEVICE_ID = "1620fc49-129b-4b73-9f09-b344d556fa2a";
    private String DEVICE_NAME = "afd6a522ffccb0e06c12ae92da688e4d";

    ToneGenerator beepGen = new ToneGenerator(AudioManager.STREAM_MUSIC, 100);
    private Boolean ttsInitSuccess = false;
    private Boolean asrInitSuccess = false;
    public AiSpeech(Context _context){
        context = _context;
        initConfig();
    }

    public void auth(Result result){
        if(DUILiteSDK.isAuthorized(context)) {
            status = SpeechStatus.AUTHED_NO_ENGINE;
            result.success(true);
        } else {
            authResult = result;
            cacheDir = context.getExternalCacheDir();
            DUILiteConfig config = new DUILiteConfig(API_KEY, PRODUCT_ID, PRODUCT_KEY, PRODUCT_SECRET);
            config.setExtraParameter("DEVICE_ID", DEVICE_ID);
            config.setExtraParameter("DEVICE_NAME", DEVICE_NAME);
            DUILiteSDK.init(context, config, new InitListenerImpl());
        }
    }

    public void initEngine(Result result){
        ttsInitSuccess = false;
        asrInitSuccess = false;
        initResult = result;
        ttsEngine = AICloudTTSEngine.createInstance();
        ttsEngine.init(ttsConfig, new TTSListenerImpl());
        asrEngine = AICloudASREngine.createInstance();
        asrEngine.init(asrConfig, new ASRListenerImpl());
    }

    public void speak(String text, Result result){
        if(ttsResult!=null) result.error("AISpeech-TTS-init","已经有一个语音合成了",null);
        ttsResult = result;
        ttsEngine.speak(ttsIntent, text, "1024");
    }

    public void listen(Result result){
        if(asrResult!=null) result.error("AISpeech-ASR-init","已经有一个语音识别了",null);
        asrResult = result;
        asrEngine.start(asrIntent);
    }

    public void destroyEngine() {
        if(ttsEngine!=null) {
            ttsEngine.stop();
            ttsEngine.destroy();
            ttsEngine = null;
        }
        if(asrEngine!=null) {
            asrEngine.cancel();
            asrEngine.stop();
            asrEngine.destroy();
            asrEngine = null;
        }
        ttsResult = null;
        asrResult = null;
        initResult = null;
        status = SpeechStatus.AUTHED_NO_ENGINE;
    }

    void beep(){
        beepGen.startTone(ToneGenerator.TONE_CDMA_PIP,100);
    }

    public void initConfig(){
        ttsConfig = new AICloudTTSConfig();
        ttsIntent = new AICloudTTSIntent();
        ttsIntent.setSaveAudioPath(cacheDir + "/aispeech/tts");//设置合成音的保存路径
        ttsIntent.setSpeaker("xijunma");
        ttsIntent.setVolume("100");
        ttsIntent.setSpeed("1.0");

        asrConfig = new AICloudASRConfig();
        asrConfig.setLocalVadEnable(true);
        asrConfig.setVadResource("vad.bin");
        asrIntent = new AICloudASRIntent();
        asrIntent.setEnablePunctuation(false);
        asrIntent.setResourceType("comm");
        asrIntent.setEnableNumberConvert(false);
        asrIntent.setEnableSNTime(false);
        asrIntent.setCloudVadEnable(false);
        asrIntent.setNoSpeechTimeOut(4000);
        asrIntent.setSaveAudioPath(cacheDir + "/aispeech/stt");
    }

    void engineInitUpdate(){
        if(ttsInitSuccess&&asrInitSuccess) {
            status = SpeechStatus.AUTH_ENGINE;
            initResult.success(true);
        }
    }

    class InitListenerImpl implements DUILiteSDK.InitListener{
        private String TAG = "AISpeech-Auth";
        @Override public void success() {
            Log.d(TAG, "Auth授权成功! ");
            new Handler(Looper.getMainLooper()).post(() -> {
                status = SpeechStatus.AUTHED_NO_ENGINE;
                authResult.success(true);
                authResult = null;
            });
        }
        @Override public void error(String errorCode,String errorInfo) {
            new Handler(Looper.getMainLooper()).post(() -> {
                authResult.error("AISpeech-Auth","Auth授权失败",errorCode + errorInfo);
                authResult = null;
            });
        }
    }

    class TTSListenerImpl implements AITTSListener {
        private String TAG = "AISpeech-TTS";
        @Override public void onInit(int status) {
            if (status == AIConstant.OPT_SUCCESS){
                ttsInitSuccess = true;
                engineInitUpdate();
            } else initResult.error("AISpeech-InitEngine","ASR初始化失败","");
        }
        @Override public void onError(String s, AIError error) {
            ttsResult.error(TAG,error.toString(),s);
            ttsResult = null;
        }
        @Override public void onCompletion(String s) {
            Log.i(TAG, "合成完成 onCompletion: " + s);
            ttsResult.success(true);
            ttsResult = null;
        }
        @Override public void onReady(String s) {}
        @Override public void onProgress(int currentTime, int totalTime, boolean isRefTextTTSFinished) {}
        @Override public void onSynthesizeStart(String s) {}
        @Override public void onSynthesizeDataArrived(String s, byte[] bytes) {}
        @Override public void onSynthesizeFinish(String s) {}
    }

    private class ASRListenerImpl implements AIASRListener {
        private String TAG = "AISpeech-ASR";
        @Override public void onInit(int status) {
            if (status == AIConstant.OPT_SUCCESS) {
                asrInitSuccess = true;
                engineInitUpdate();
            } else initResult.error("AISpeech-InitEngine","ASR初始化失败","");
        }
        @Override public void onError(AIError aiError) {
            if(aiError.getErrId()==70904) asrResult.success("");
            else asrResult.error(TAG,aiError.toString(),null);
            asrResult = null;
        }
        @Override public void onResults(AIResult aiResult) {
            if (aiResult.isLast()) {
                if (aiResult.getResultType() == AIConstant.AIENGINE_MESSAGE_TYPE_JSON) {
                    asrEngine.stop();
                    asrResult.success(aiResult.getResultObject().toString());
                    asrResult = null;
                }
            }
        }
        @Override public void onEndOfSpeech() {
            Log.i(TAG, "用户停止说话");
            asrEngine.stop();
        }
        @Override public void onRmsChanged(float v) {}
        @Override public void onReadyForSpeech() {beep();}
        @Override public void onBeginningOfSpeech() {Log.d(TAG, "检测到用户开始说话");}
        @Override public void onRawDataReceived(byte[] bytes, int i) {}
        @Override public void onResultDataReceived(byte[] bytes, int i) {}
        @Override public void onNotOneShot() {}
    }
}
