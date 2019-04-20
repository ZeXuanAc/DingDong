package com.zxac.dingdong_flutter;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.*;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    CustomFlutterPlugins.registerLogger(getFlutterView());

    GeneratedPluginRegistrant.registerWith(this);
    registerCustomPlugin(this);
  }


  private static void registerCustomPlugin(PluginRegistry registrar) {
    BaiduMapFlutterPlugin.registerWith(registrar.registrarFor(BaiduMapFlutterPlugin.CHANNEL));
  }

}
