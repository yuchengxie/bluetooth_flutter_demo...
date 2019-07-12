package com.example.bluetooth_flutter_demo;

import android.os.Bundle;
import android.util.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.nationz.sim.sdk.NationzSimCallback;
import com.nationz.sim.sdk.NationzSim;


public class MainActivity extends FlutterActivity {
    private static final String BLUETOOTH_CHANNEL = "hzf.bluetooth";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), BLUETOOTH_CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
//                Log.i(TAG, "onMethodCall: %s",methodCall);
                System.out.printf("method: ", call);
                if (call.method.equals("connectBlueTooth")) {
                    System.out.println("android call connectBlueTooth");
                    Object bleName=call.arguments.toString();
                    System.out.printf("bleName:",bleName);
                    int res = connectBlueTooth();

                }else if(call.method.equals("disConnectBlueTooth")){
                    System.out.println("android call disConnectBlueTooth");
                }
            }
        });
    }

    private int connectBlueTooth(){
        return 0;
    }
}




















