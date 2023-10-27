import 'package:flutter/material.dart';
import 'package:flutter_untils/untils/zfj_node_slisder.dart';
import 'package:flutter_untils/untils/zfj_screen_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZFJ Flutter Untils',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ZFJ Flutter Untils'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<ZFJNodeSlisderState> _slisderStateKey_0 = GlobalKey();

  final GlobalKey<ZFJNodeSlisderState> _slisderStateKey_1 = GlobalKey();

  final GlobalKey<ZFJNodeSlisderState> _slisderStateKey_2 = GlobalKey();

  final GlobalKey<ZFJNodeSlisderState> _slisderStateKey_3 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _titleWidget("1、段数：4，有气泡，有单位，有节点文字"),
            ZFJNodeSlisder(
              key: _slisderStateKey_0,
              width: kZFJScreenUtil.screenWidth - 32,
              maxValue: 100,
              value: 0.4,
              unitText: "%",
              divisions: 4,
              isEnabled: true,
              isShowBubble: true,
              valueChanged: (value) {
                print("----------> value = $value");
              },
            ),
            _titleWidget("2、段数：1，有气泡，有单位，有节点文字"),
            ZFJNodeSlisder(
              key: _slisderStateKey_1,
              width: kZFJScreenUtil.screenWidth - 32,
              maxValue: 100,
              value: 0.4,
              unitText: "%",
              divisions: 1,
              activeTrackColor: Colors.red,
              isEnabled: true,
              isShowBubble: true,
              valueChanged: (value) {
                print("----------> value = $value");
              },
            ),
            _titleWidget("3、段数：3，有气泡，没单位，有节点文字"),
            ZFJNodeSlisder(
              key: _slisderStateKey_2,
              width: kZFJScreenUtil.screenWidth - 32,
              maxValue: 100,
              value: 0.2,
              unitText: "%",
              divisions: 3,
              activeTrackColor: Colors.green,
              isEnabled: true,
              isShowBubble: true,
              valueChanged: (value) {
                print("----------> value = $value");
              },
            ),
            _titleWidget("4、段数：4，有气泡，没单位，没节点文字"),
            ZFJNodeSlisder(
              key: _slisderStateKey_3,
              width: kZFJScreenUtil.screenWidth - 32,
              maxValue: 100,
              value: 0.1,
              unitText: "%",
              divisions: 4,
              activeTrackColor: Colors.yellow,
              isShowNodeText: false,
              isEnabled: true,
              isShowBubble: true,
              valueChanged: (value) {
                print("----------> value = $value");
              },
            ),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _titleWidget(text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 30),
      child: Text(text),
    );
  }
}
