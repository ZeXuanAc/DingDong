package com.zxac.dingdong_flutter;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.*;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    CustomFlutterPlugins.registerLogger(getFlutterView());
  }
}
