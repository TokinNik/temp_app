import 'package:flutter/material.dart';
import 'package:temp_app/core/network/dio_utils/dio_factory.dart';
import 'package:temp_app/localization/generated/l10n.dart';
import 'package:temp_app/utils/test_isolate_repo.dart';

class TestPage1 extends Page {
  final Function()? onTap;

  TestPage1({this.onTap});

  @override
  Route createRoute(BuildContext context) {
    S.load(Locale('en'));
    return MaterialPageRoute(
      settings: this,
      builder: (context) => TestScreen1(onTap: onTap),
    );
  }
}

class TestScreen1 extends StatefulWidget {
  const TestScreen1({Key? key, this.onTap}) : super(key: key);

  final Function()? onTap;

  @override
  State<TestScreen1> createState() => _TestScreen1State();
}

class _TestScreen1State extends State<TestScreen1> {
  var _value = ValueNotifier(false);

  Dio _dio = DioFactory.buildClient();

  Future<void> _testFunc() async {
    var service = NetworkService(
      dio: _dio,
      authHolder: null, //getIt.get(),
      clearSessionUseCase: null, //getIt.get(),
    );

    service.addBasicAuth("83e70ff1d12ca16f236e95aaeae4e1f3b48dba5e");

    // var request = NetworkRequest(
    //   type: NetworkRequestType.GET,
    //   path:
    //       '/api/client/notification_center/messages/?type[]=info&type[]=critical',
    //   data: NetworkRequestBody.empty(),
    // );
    //
    var request = NetworkRequest(
      type: NetworkRequestType.GET,
      path: '/api/client/stats/',
      queryParams: {
        'date_from': '2015-06-07',
        'date_to': '2022-06-07',
        'group_by': 'date_time',
        'rate_model': '1',
      },
    );

    print(" == Start == ");
    var result = service.executeWithCancel(
      request,
      parser: (raw) {
        print("PARSER RAW = $raw");
        return "parsed data";
      },
      onReceiveProgress: (c, t) {
        print("onReceiveProgress: $c  $t");
      },
      onSendProgress: (c, t) {
        print("onSendProgress: $c  $t");
      },
    ).then((value) {
      print("RESULT = $value");
    });
    print("COMPUTE AFTER RESULT = ${result}");
  }

  bool reverse = false;

  Color getContrast(Color color, bool reverse) {
    var a = 255;
    var r = 65280;
    var g = 16711680;
    var b = 4278190080;
    var white = 4294967295;
    // var tt = color.value;
    var tt = color.value;
    var tr = color.red;
    var tg = color.green;
    var tb = color.blue;
    var ttr = ~tt;
    // var color1 = Color(tt).withAlpha(255);
    var color1 = Color.fromARGB(255, tr, tg, tb);
    // var color2 = Color(ttr).withAlpha(255);
    var color2 = Color.fromARGB(255, ~tr, ~tg, ~tb);

    return reverse ? color1 : color2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Page 1"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () {
                  widget.onTap?.call();
                },
                child: Text(S.current.log_in),
              ),
            ),
          ),
          _value.value ? CircularProgressIndicator() : SizedBox.shrink(),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    reverse = !reverse;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: getContrast(Colors.red, reverse),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                color: getContrast(Colors.green, reverse),
              ),
              Container(
                width: 50,
                height: 50,
                color: getContrast(Colors.blue, reverse),
              ),
              Container(
                width: 50,
                height: 50,
                color: getContrast(Colors.orange, reverse),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    reverse = !reverse;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: getContrast(Colors.red, !reverse),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                color: getContrast(Colors.green, !reverse),
              ),
              Container(
                width: 50,
                height: 50,
                color: getContrast(Colors.blue, !reverse),
              ),
              Container(
                width: 50,
                height: 50,
                color: getContrast(Colors.orange, !reverse),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _testFunc();
            },
            child: Container(
              width: 50,
              height: 50,
              color: Colors.blue,
            ),
          ),
          GestureDetector(
            onTap: () {
              //todo
            },
            child: Container(
              width: 50,
              height: 50,
              color: Colors.red,
              child: Text("${_value.value}"),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _value.value = !_value.value;
                });
              },
              child: Container(
                color: Colors.grey,
                child: SizedBox.square(
                  dimension: 50,
                  child: CustomPaint(
                    size: Size(50, 50),
                    painter: _TestCustomPainter(
                      repaint: _value,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TestCustomPainter extends CustomPainter {
  _TestCustomPainter({required Listenable repaint}) : super(repaint: repaint);
  final Paint _paint = Paint();

  int i = 0;

  DateTime lastTap = DateTime.now();

  bool flag = false;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = flag ? Colors.amber : Colors.green;

    // canvas.drawColor(Colors.amber, BlendMode.color);
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(
            size.width / 2,
            size.width / 2,
          ),
          width: size.width,
          height: size.width),
      _paint,
    );
    // canvas.drawPaint(_paint);
    // canvas.drawCircle(Offset.zero, 50, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    print("shouldRepaint ${(oldDelegate as _TestCustomPainter).flag}  $flag");
    flag = (oldDelegate as _TestCustomPainter).flag;
    return true; //(oldDelegate as _TestCustomPainter).flag != flag;
  }

  @override
  bool? hitTest(Offset position) {
    print("hitTest(${i++}) $position");
    var tapTime = DateTime.now();
    if (tapTime.difference(lastTap).inMilliseconds > 200) {
      print("tap time > 200ms");
      flag = !flag;
    } else {
      print("tap time <= 200ms");
    }
    lastTap = tapTime;
    return super.hitTest(position);
  }
}
