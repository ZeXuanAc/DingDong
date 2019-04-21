package com.zxac.dingdong_flutter;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.media.AudioManager;
import android.os.Bundle;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.Toast;

import com.baidu.mapapi.walknavi.WalkNavigateHelper;
import com.baidu.mapapi.walknavi.adapter.IWNaviStatusListener;
import com.baidu.mapapi.walknavi.adapter.IWRouteGuidanceListener;
import com.baidu.mapapi.walknavi.model.RouteGuideKind;
import com.baidu.platform.comapi.walknavi.WalkNaviModeSwitchListener;
import com.baidu.platform.comapi.walknavi.widget.ArCameraView;
import com.baidu.tts.client.SpeechSynthesizer;
import com.baidu.tts.client.TtsMode;
import com.zxac.dingdong_flutter.utils.StatusBarUtil;

public class WalkGuideActivity extends Activity {

    private final static String TAG = WalkGuideActivity.class.getSimpleName();

    private WalkNavigateHelper mNaviHelper;

    protected String appId = "16073042";

    protected String appKey = "ydanCoMY3XdWPgBNl7rYFm9Y";

    protected String secretKey = "0jUQcS5D8psGXV7q8t7f7aq1mSoK9nDU";

    // TtsMode.MIX; 离在线融合，在线优先； TtsMode.ONLINE 纯在线； 没有纯离线
    private TtsMode ttsMode = TtsMode.ONLINE;

    protected SpeechSynthesizer mSpeechSynthesizer;


    @Override
    protected void onDestroy() {
        super.onDestroy();
        mNaviHelper.quit();
    }

    @Override
    protected void onResume() {
        super.onResume();
        mNaviHelper.resume();
    }

    @Override
    protected void onPause() {
        super.onPause();
        mNaviHelper.pause();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        StatusBarUtil.setStatusBarTranslucent(this, true);
        mNaviHelper = WalkNavigateHelper.getInstance();

        Log.i(TAG, "进入guide页面");

        initTTs();

        try {
            View view = mNaviHelper.onCreate(WalkGuideActivity.this);
            if (view != null) {
                setContentView(view);
            }
        } catch (Exception e) {
            Log.e(TAG,"获取mapView失败");
        }

        mNaviHelper.setWalkNaviStatusListener(new IWNaviStatusListener() {
            @Override
            public void onWalkNaviModeChange(int mode, WalkNaviModeSwitchListener listener) {
                Log.d(TAG, "onWalkNaviModeChange : " + mode);
                mNaviHelper.switchWalkNaviMode(WalkGuideActivity.this, mode, listener);
            }

            @Override
            public void onNaviExit() {
                Log.d(TAG, "onNaviExit");
            }
        });

        mNaviHelper.setTTsPlayer((s, b) -> {
            Log.d(TAG, "tts: " + s);
            speak(s);
            // todo
            return 0;
        });

        boolean startResult = mNaviHelper.startWalkNavi(WalkGuideActivity.this);
        Log.e(TAG, "startWalkNavi result : " + startResult);

        mNaviHelper.setRouteGuidanceListener(this, new IWRouteGuidanceListener() {
            @Override
            public void onRouteGuideIconUpdate(Drawable icon) {

            }

            @Override
            public void onRouteGuideKind(RouteGuideKind routeGuideKind) {
                Log.d(TAG, "onRouteGuideKind: " + routeGuideKind);
            }

            @Override
            public void onRoadGuideTextUpdate(CharSequence charSequence, CharSequence charSequence1) {
                Log.d(TAG, "onRoadGuideTextUpdate   charSequence=: " + charSequence + "   charSequence1 = : " +
                        charSequence1);

            }

            @Override
            public void onRemainDistanceUpdate(CharSequence charSequence) {
                Log.d(TAG, "onRemainDistanceUpdate: charSequence = :" + charSequence);

            }

            @Override
            public void onRemainTimeUpdate(CharSequence charSequence) {
                Log.d(TAG, "onRemainTimeUpdate: charSequence = :" + charSequence);

            }

            @Override
            public void onGpsStatusChange(CharSequence charSequence, Drawable drawable) {
                Log.d(TAG, "onGpsStatusChange: charSequence = :" + charSequence);

            }

            @Override
            public void onRouteFarAway(CharSequence charSequence, Drawable drawable) {
                Log.d(TAG, "onRouteFarAway: charSequence = :" + charSequence);

            }

            @Override
            public void onRoutePlanYawing(CharSequence charSequence, Drawable drawable) {
                Log.d(TAG, "onRoutePlanYawing: charSequence = :" + charSequence);

            }

            @Override
            public void onReRouteComplete() {

            }

            @Override
            public void onArriveDest() {

            }

            @Override
            public void onIndoorEnd(Message msg) {

            }

            @Override
            public void onFinalEnd(Message msg) {

            }

            @Override
            public void onVibrate() {

            }
        });
    }


    private void initTTs() {
        // 1. 获取实例
        mSpeechSynthesizer = SpeechSynthesizer.getInstance();
        mSpeechSynthesizer.setContext(this);

        // 3. 设置appId，appKey.secretKey
        mSpeechSynthesizer.setAppId(appId);
        mSpeechSynthesizer.setApiKey(appKey, secretKey);

        // 5. 以下setParam 参数选填。不填写则默认值生效
        // 设置在线发声音人： 0 普通女声（默认） 1 普通男声 2 特别男声 3 情感男声<度逍遥> 4 情感儿童声<度丫丫>
        mSpeechSynthesizer.setParam(SpeechSynthesizer.PARAM_SPEAKER, "4");
        // 设置合成的音量，0-9 ，默认 5
        mSpeechSynthesizer.setParam(SpeechSynthesizer.PARAM_VOLUME, "9");
        // 设置合成的语速，0-9 ，默认 5
        mSpeechSynthesizer.setParam(SpeechSynthesizer.PARAM_SPEED, "5");
        // 设置合成的语调，0-9 ，默认 5
        mSpeechSynthesizer.setParam(SpeechSynthesizer.PARAM_PITCH, "5");

        mSpeechSynthesizer.setAudioStreamType(AudioManager.MODE_IN_CALL);

        // 6. 初始化
        mSpeechSynthesizer.initTts(ttsMode);

    }

    private void speak(String text) {
        if (mSpeechSynthesizer == null) {
            Log.w(TAG, "语音工具初始化失败");
            return;
        }
        mSpeechSynthesizer.speak(text);
        Log.i(TAG, "合成并播放 ,text: " + text);
    }

    private void stop() {
        Log.i(TAG, "停止合成引擎");
        mSpeechSynthesizer.stop();
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == ArCameraView.WALK_AR_PERMISSION) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_DENIED) {
                Toast.makeText(WalkGuideActivity.this, "没有相机权限,请打开后重试", Toast.LENGTH_SHORT).show();
            } else if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                mNaviHelper.startCameraAndSetMapView(WalkGuideActivity.this);
            }
        }
    }


}
