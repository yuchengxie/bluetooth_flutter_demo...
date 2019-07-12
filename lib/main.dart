import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
    },
    theme: ThemeData(
      brightness: Brightness.dark,
      // accentColor: Colors.cyan,
      buttonTheme: ButtonThemeData(
        height: 40,
        // highlightColor: Colors.cyan,
      ),
    ),
  ));
}

TextEditingController bleNameController;
TextEditingController pinCodeController;

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel methodChannel = MethodChannel('hzf.bluetooth');
  static const EventChannel eventChannel = EventChannel('hzf.bluetoothState');
  String _connectState;

  Future<void> _connectBlueTooth(String a, String b) async {
    String connectState = '';
    try {
      final String s =
          await methodChannel.invokeMethod('connectBlueTooth', [a, b]);
      // connectState = '连接结果:$result';
      this._showToast("connectBlueTooth返回$s", duration: 3, gravity: Toast.TOP);
    } on PlatformException {
      connectState = 'bluetooth connect error';
    }
    setState(() {
      // this._connectState = connectState;
    });
  }

  Future<void> _disConnectBlueTooth() async {
    String connectState = '';
    try {
      final int result =
          await methodChannel.invokeMethod('disConnectBlueTooth');
      connectState = '连接结果:$result';
    } on PlatformException {
      connectState = 'bluetooth connect error';
    }
    setState(() {
      this._connectState = connectState;
    });
  }

  Future<void> _selectApp() async {
    try {
      print('dark调用_selectApp');
      String s = await methodChannel.invokeMethod('selectApp');
      print('接收到返回s:$s');
      this._showToast("selectApp返回$s", duration: 3, gravity: Toast.TOP);
    } on PlatformException {}
  }

  Future<void> _verifPIN() async {
    try {
      print('dark调用_verifyPIN');
      String s = await methodChannel.invokeMethod('verifPIN');
      print('接收到返回s:$s');
      this._showToast("verifypin返回$s", duration: 3, gravity: Toast.TOP);
    } on PlatformException {}
  }

  void _showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bleNameController = TextEditingController();
    pinCodeController = TextEditingController();
    bleNameController.text = "BLESIM111111";
    pinCodeController.text = "123456";
    this._connectState = '请连接蓝牙';
    print('state:${this._connectState}');
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  _onEvent(Object event) {
    setState(() {
      _connectState = '$event';
    });
  }
  
  _onError(Object error) {
    setState(() {
      _connectState = '连接状态:unknow';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('蓝牙SIM'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: bleNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.bluetooth),
                hintText: '请输入蓝牙设备名称',
              ),
            ),
            TextField(
              controller: pinCodeController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.payment),
                hintText: '请输入pin码',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    child: Text('连 接 蓝 牙'),
                    highlightedBorderColor: Colors.cyan,
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      this._connectBlueTooth(
                          bleNameController.text, pinCodeController.text);
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    child: Text('断 开 蓝 牙'),
                    highlightedBorderColor: Colors.cyan,
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      this._disConnectBlueTooth();
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              this._connectState,
              style: TextStyle(
                color: Colors.cyan,
            ),),
            SizedBox(
              height: 25,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    child: Text('选 择 应 用'),
                    highlightedBorderColor: Colors.cyan,
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      this._selectApp();
                    },
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    child: Text('验 证 PIN 码'),
                    highlightedBorderColor: Colors.cyan,
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      this._verifPIN();
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
