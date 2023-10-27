
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ZFJNodeSlisder extends StatefulWidget {

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
  /// 回调
  final Function(int) valueChanged;
  /// 指定初始化的值 0-1
  final double value;
  /// 是否可以滑动，默认可以滑动
  final bool isEnabled;
  /// 是否显示气泡
  final bool isShowBubble;
  /// 气泡单位
  final String bubbleUnit;
  /// 选中颜色
  final Color? activeTrackColor;
  /// 未选中颜色
  final Color? unActiveTrackColor;
  /// 节点字体样式
  final TextStyle? valueStyle;

  ZFJNodeSlisder({
    super.key,
    required this.valueChanged,
    this.width = double.infinity,
    this.height = 3.0,
    this.divisions = 4,
    this.maxValue = 100,
    this.minValue = 0,
    this.sliderWidth = 16,
    this.nodeWidth = 12,
    this.toNodeBool = false,
    this.value = 0,
    this.isEnabled = true,
    this.isShowBubble = false,
    this.bubbleUnit = "",
    this.activeTrackColor,
    this.unActiveTrackColor,
    this.valueStyle,
  });

  ///
  final GlobalKey<ZFJNodeSlisderState> myWidgetKey = GlobalKey<ZFJNodeSlisderState>();

  @override
  State<ZFJNodeSlisder> createState() => ZFJNodeSlisderState();
}

class ZFJNodeSlisderState extends State<ZFJNodeSlisder> {

  ///
  double dx = 0.0;
  ///
  double maxX = 0.0;
  /// 0-1
  double value = 0.0;
  /// 节点数组
  final List _divisionsList = [];
  /// 气泡是否显示
  late bool _showBubble = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.divisions + 1; i++) {
      _divisionsList.add(i);
    }
    setState(() {
      value = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = 4;
    double bubbleTipsWidth = 6;
    double bubbleWidth = 24;
    double left = size;
    left = (bubbleWidth - bubbleTipsWidth) * value ;
    if (left < size) {
      left = size;
    } else if (left > (bubbleWidth - bubbleTipsWidth - size)) {
      left = bubbleWidth - size - bubbleTipsWidth;
    }
    double spacing = (widget.width - widget.nodeWidth * (widget.divisions + 1)) / widget.divisions;
    return GestureDetector(
      behavior: widget.isEnabled ? null : HitTestBehavior.opaque,
      child: SizedBox(
        height: 16 + 20 + 20,
        width: widget.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 气泡
            _showBubble ? Align(
              alignment: FractionalOffset(value, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 上面的文字
                  Container(
                    width: bubbleWidth,
                    height: 16,
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.activeTrackColor ?? hexToColor("#FFBE3F"),
                      borderRadius: const BorderRadius.all(Radius.circular(3),),
                    ),
                    child: Text(
                      (int.parse((widget.maxValue! * value).toStringAsFixed(0)) <= widget.minValue!) ? '${widget.minValue}${widget.bubbleUnit}' : '${(widget.maxValue! * value).toStringAsFixed(0)}${widget.bubbleUnit}',
                      style: widget.valueStyle ?? TextStyle(
                        fontSize: 9,
                        color: hexToColor("#EBEBEB"),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // 下面的尖头
                  Container(
                    width: bubbleTipsWidth,
                    height: 3,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: left),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/slisder_bubble_tips.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),

            // slider
            Container(
              width: widget.width ,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.unActiveTrackColor ?? hexToColor("#EBEBEB"),
              ),
              child: CustomPaint(
                painter: SliderPainter((double maxDx) {
                  maxX = maxDx;
                  return value * maxDx;
                },
                    activeTrackColor: widget.activeTrackColor ?? hexToColor("#FFBE3F"),
                    divisions: widget.divisions
                ),
              ),
            ),

            // 节点-未选中的颜色
            SizedBox(
                width: widget.width,
                height: widget.nodeWidth,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: widget.nodeWidth,
                      minHeight: widget.nodeWidth,
                      maxWidth: widget.width
                  ),
                  child: Wrap(
                    /// 横向间距
                    spacing: spacing,
                    /// 纵向间距
                    runSpacing: double.infinity,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: _divisionsList.map((valueS) {
                      double currentValue = double.parse((widget.maxValue! * value).toStringAsFixed(0));
                      double nodeValue = double.parse((widget.maxValue! / widget.divisions).toString()) * _divisionsList.indexOf(valueS);
                      return Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          width: widget.nodeWidth,
                          height: widget.nodeWidth,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: currentValue >= nodeValue ? (widget.activeTrackColor ?? hexToColor("#FFBE3F")) : (widget.unActiveTrackColor ?? hexToColor("#EBEBEB")),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(widget.nodeWidth / 2),
                          ),
                          // transform: Matrix4.rotationZ(math.pi /4),
                        ),
                      );
                    }).toList(),
                  ),
                )
            ),

            // 滑块
            Align(
              alignment: FractionalOffset(value, 0.5),
              child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: widget.sliderWidth,
                    height: widget.sliderWidth,
                    margin: const EdgeInsets.only(top: 0, bottom: 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.activeTrackColor ?? hexToColor("#FFBE3F"),
                        width: 2,
                      ), // 边色与边宽度
                      borderRadius: BorderRadius.circular(widget.sliderWidth / 2.0),
                    ),
                    alignment: Alignment.center,
                  )
              ),
            ),
          ],
        ),
      ),
      onTapDown: (details) {
        double dxValue = getPoint(context, details.globalPosition).dx;
        int index = _getTapIndex(details, spacing);
        if (index != -1) {
          dxValue = widget.width * (index/4);
        }
        updateDx(dxValue, widget.isShowBubble);
      },
      onTapUp: (details) {
        setValue(true, false);
      },
      onPanUpdate: (details) {
        updateDx(getPoint(context, details.globalPosition).dx, widget.isShowBubble);
      },
      onPanEnd: (details) {
        setValue(true, false);
      },
    );
  }

  // 判断点击在哪个点上，如果不在分段的点上返回-1
  int _getTapIndex(TapDownDetails details, double spacing) {
    double dx = details.localPosition.dx;
    double pointSize = widget.nodeWidth + spacing;
    for(int index = 0; index < widget.divisions + 1; index ++) {
      if(dx >= pointSize * index && dx <= pointSize * index + widget.nodeWidth) {
        return index;
      }
    }
    return -1;
  }

  Offset getPoint(BuildContext context, Offset globalPosition) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(globalPosition);
  }

  /// 选择了全部
  void selectedAll() {
    setState(() {
      value = 1;
    });
  }

  /// 手动设置value值，0~1
  void updateValue(double val) {
    if (val < 0 || val > 1) return;
    setState(() {
      value = val;
    });
  }

  void updateDx(double dxValue, bool isShow) {
    dx = dxValue;
    dx = dx < 0 ? 0 : dx;
    dx = dx > maxX ? maxX : dx;
    setValue(false, isShow);
  }

  // 更新value值
  void setValue(bool isEnd, bool isShow) {
    setState(() {
      // 0-1
      value = dx / maxX;
      if (widget.toNodeBool) {
        gotoNode();
      }
    });
    if (isShow) {
      setState(() {
        _showBubble = true;
      });
    } else {
      // 0.5秒以后再移除气泡
      Future.delayed(const Duration(milliseconds: 250), () {
        setState(() {
          _showBubble = false;
        });
      });
    }
    /// 回调滑竿值-值取整数
    widget.valueChanged(
        int.parse(((dx / maxX) * widget.maxValue!).toStringAsFixed(0))
    );
  }

  // 直接跳到节点，无过渡
  void gotoNode() {
    int precent = int.parse(((dx / maxX) * widget.maxValue!).toStringAsFixed(0));
    double divisionsV = widget.maxValue! / widget.divisions;

    if (0 < precent && precent <= divisionsV * 1) {
      value = divisionsV * 1 / widget.maxValue!;
    } else if (divisionsV * 1 < precent && precent <= divisionsV * 2) {
      value = divisionsV * 2 / widget.maxValue!;
    } else if (divisionsV * 2 < precent && precent <= divisionsV * 3) {
      value = divisionsV * 3 / widget.maxValue!;
    } else if (divisionsV * 3 < precent && precent <= divisionsV * 4) {
      value = divisionsV * 4 / widget.maxValue!;
    } else if (divisionsV * 4 < precent && precent <= divisionsV * 5) {
      value = divisionsV * 5 / widget.maxValue!;
    } else if (divisionsV * 5 < value && value <= divisionsV * 6) {
      value = divisionsV * 6 / widget.maxValue!;
    } else if (divisionsV * 6 < value && value <= divisionsV * 7) {
      value = divisionsV * 7 / widget.maxValue!;
    } else if (divisionsV * 7 < value && value <= divisionsV * 8) {
      value = divisionsV * 8 / widget.maxValue!;
    } else if (divisionsV * 8 < value && value <= divisionsV * 9) {
      value = divisionsV * 9 / widget.maxValue!;
    } else if (divisionsV * 9 < value && value <= divisionsV * 10) {
      value = divisionsV * 10 / widget.maxValue!;
    }
  }

  Color hexToColor(String hexString) {
    String formattedString = hexString.replaceAll("#", "");
    int colorValue = int.parse(formattedString, radix: 16);
    return Color(colorValue).withOpacity(1.0);
  }

}

/// slider通道
class SliderPainter extends CustomPainter {
  final Color? activeTrackColor;

  final double Function(double maxDx) getDx;
  final int divisions;

  SliderPainter(
      this.getDx, {
        this.activeTrackColor,
        this.divisions = 4,
      }
      );

  /// 初始化画笔
  var lineP = Paint()..strokeCap = StrokeCap.butt;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    /// 背景线Paint
    lineP.strokeWidth = height;
    lineP.color = activeTrackColor!;

    double dx = getDx(width);
    Offset endPoint = Offset.zero;
    ///
    double centerW = height / 2;

    /// 通过canvas画线
    endPoint = Offset(dx, centerW);
    canvas.drawLine(Offset(0, centerW), endPoint, lineP);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}