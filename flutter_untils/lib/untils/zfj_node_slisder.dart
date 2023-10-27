
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
    this.unitText = "",
    this.isShowNodeText = true,
    this.activeTrackColor,
    this.unActiveTrackColor,
    this.nodeBgColor,
    this.bubbleValueStyle,
    this.nodeValueStyle,
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
        // color: widget.bgColor ?? Colors.white,
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
                      (int.parse((widget.maxValue! * value).toStringAsFixed(0)) <= widget.minValue!) ?
                      '${widget.minValue}${widget.unitText}' : '${(widget.maxValue! * value).toStringAsFixed(0)}${widget.unitText}',
                      style: widget.bubbleValueStyle ?? const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // 下面的尖头
                  Container(
                    width: bubbleTipsWidth,
                    height: 3,
                    margin: EdgeInsets.only(left: left),
                    child: CustomPaint(
                      painter: ZFJDownArrowPainter(
                          bgColor: widget.activeTrackColor ?? hexToColor("#EBEBEB")
                      ),
                    ),
                  )
                ],
              ),
            ) : const SizedBox(),

            // slider
            Container(
              width: widget.width ,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.unActiveTrackColor ?? hexToColor("#EBEBEB"),
              ),
              child: CustomPaint(
                painter: ZFJSliderPainter (
                    activeTrackColor: widget.activeTrackColor ?? hexToColor("#FFBE3F"),
                    divisions: widget.divisions,
                    getDx: (double maxDx) {
                      maxX = maxDx;
                      return value * maxDx;
                    }
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
                    // 横向间距
                    spacing: spacing,
                    // 纵向间距
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
                            color: widget.nodeBgColor ?? Colors.white,
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
                      color: widget.nodeBgColor ?? Colors.white,
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

            // 节点文本
            widget.isShowNodeText ? Positioned(
                bottom: 3,
                child: SizedBox(
                  width: widget.width,
                  height: widget.height + 10,
                  child: CustomPaint(
                    painter: ZFJSliderTextPainter(
                      maxValue: widget.maxValue!,
                      minValue: widget.minValue!,
                      divisions: widget.divisions,
                      unitText: widget.unitText,
                      nodeValueStyle: widget.nodeValueStyle ?? const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF878E9A)
                      ),
                    ),
                  ),
                )
            ) : Container(),
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
      // 0.25秒以后再移除气泡
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
class ZFJSliderPainter extends CustomPainter {
  final Color? activeTrackColor;
  final double Function(double maxDx) getDx;
  final int divisions;

  ZFJSliderPainter({
    required this.getDx,
    this.activeTrackColor,
    this.divisions = 4,
  });

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

/// 节点文字
class ZFJSliderTextPainter extends CustomPainter {

  // 最大值
  final int maxValue;
  // 最小值
  final int minValue;
  // 段数
  final int divisions;
  // 单位
  final String unitText;
  // 节点文字样式
  final TextStyle nodeValueStyle;

  ZFJSliderTextPainter({
    required this.maxValue,
    required this.minValue,
    required this.divisions,
    required this.unitText,
    required this.nodeValueStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;

    for (int i = 0; i <= divisions; i++) {
      String textStr = (minValue > 0 && i == 0) ?
      '${minValue.toStringAsFixed(0)}$unitText' :
      '${((maxValue) / divisions * i).toStringAsFixed(0)}$unitText';

      TextPainter textPainter = TextPainter();
      final TextSpan textSpan = TextSpan(
        text: textStr,
        style: nodeValueStyle,
      );
      textPainter.text = textSpan;
      textPainter.textDirection =
      i == divisions ? TextDirection.rtl : TextDirection.ltr;
      textPainter.textAlign = i == divisions ? TextAlign.end : TextAlign.center;
      textPainter.layout(maxWidth: 35);

      // 文字位移宽度： 前移本身长度的1/2
      double space = i == 0 ? 0 : (i == divisions ? -textPainter.width : -(textPainter.width / 2)); //textPainter.width: 文字长度

      textPainter.paint(
        canvas,
        Offset(i * (width / divisions) + space, 0),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// 气泡向下的箭头
class ZFJDownArrowPainter extends CustomPainter {

  // 气泡背景颜色
  final Color bgColor;

  ZFJDownArrowPainter({
    required this.bgColor
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = bgColor;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ZFJDownArrowPainter oldDelegate) => false;

}