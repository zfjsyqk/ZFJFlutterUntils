# 【Flutter】ZFJ自定义分段选择器Slider

## 前言
在开发一个APP的时候，需要用到一个分段选择器，系统的不满足就自己自定义了一个；

可以自定义节点的数量、自定义节点的大小、自定义滑竿的粗细，自定义气泡的有无等等...

基本上满足你的常用需求。

## 效果
<p align = "center">    
    <img src="https://zfjwork.top/images/zfjblog/node_slisder_0.png" width="300" />
</p>


## 参数


```
  /// 滑杆的宽度
  final double width;
  /// 滑杆的高度
  final double height;
  /// 最大值
  final int? maxValue;
  /// 最小值
  final int? minValue;
  /// 段数
  final int divisions;
  /// 滑块的宽度
  final double sliderWidth;
  /// 节点的宽度
  final double nodeWidth;
  /// 滑动跳到节点
  final bool toNodeBool;
  /// 滑竿回调
  final Function(int) valueChanged;
  /// 指定初始化的值 0-1
  final double value;
  /// 是否可以滑动，默认可以滑动
  final bool isEnabled;
  /// 是否显示气泡
  final bool isShowBubble;
  /// 气泡和节点单位
  final String unitText;
  /// 是否显示节点文字
  final bool isShowNodeText;
  /// 选中颜色
  final Color? activeTrackColor;
  /// 未选中颜色
  final Color? unActiveTrackColor;
  /// 节点背景颜色
  final Color? nodeBgColor;
  /// 气泡字体样式
  final TextStyle? bubbleValueStyle;
  /// 节点字体样式
  final TextStyle? nodeValueStyle;
```
## 事例

### 1、使用
```
            // 1、段数：4，有气泡，有单位，有节点文字
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
            
            // 2、段数：1，有气泡，有单位，有节点文字
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
            
            // 3、段数：3，有气泡，没单位，有节点文字
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
            
            // 4、段数：4，有气泡，没单位，没节点文字
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

```
### 2、获取进度条的值

获取当前进度条的值参与计算等业务；
```
_slisderStateKey.currentState?.value;
```

### 3、更新进度条的值

其他的事件更新进度条的值；

```
_slisderStateKey.currentState?.updateValue(progress);
```

进度条全选

```
_slisderStateKey.currentState?.selectedAll();
```

## 源码

喜欢的点个小心心吧⭐️

[ZFJFlutterUntils/zfj_node_slisder.dart](https://github.com/zfjsyqk/ZFJFlutterUntils/blob/main/flutter_untils/lib/untils/zfj_node_slisder.dart)https://github.com/zfjsyqk/ZFJFlutterUntils/blob/main/flutter_untils/lib/untils/zfj_node_slisder.dart)