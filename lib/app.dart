import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/core/network/dio_utils/dio_factory.dart';
import 'package:temp_app/di/dependencies.dart';
import 'package:temp_app/ui/pages/temp_login_page/temp_login_page.dart';
import 'package:temp_app/ui/pages/temp_logout_page/temp_logout_page.dart';
import 'package:temp_app/utils/test_isolate_repo.dart';

import 'localization/generated/l10n.dart';

GlobalBloc globalBloc(context) => BlocProvider.of<GlobalBloc>(context);

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class RouterState extends ChangeNotifier {
  bool get taped => _taped;
  bool _taped = false;

  set taped(bool value) {
    _taped = value;
    notifyListeners();
  }
}

class _AppState extends State<App> {
  late GlobalBloc _globalBloc;

  RouterState rState = RouterState();

  @override
  void initState() {
    super.initState();
    rState.addListener(rStateListener);
    _globalBloc = GlobalBloc();
  }

  rStateListener() {
    setState(() {
      //rebuild
    });
  }

  @override
  void dispose() {
    rState.removeListener(rStateListener);
    _globalBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GlobalBloc>(
      create: (BuildContext context) => _globalBloc,
      child: BlocBuilder<GlobalBloc, GlobalState>(
        bloc: _globalBloc,
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            //  locale: Locale('en', ''), //TODO: change locale if need
            home: Router(
              routerDelegate: TestRouterDelegate(rState),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(GlobalState state) {
    switch (state.appState) {
      case AppState.LOG_IN:
        return TempLoginPage();
      case AppState.LOG_OUT:
        return TempLogoutPage();
    }
  }
}

class TestRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  TestRouterDelegate(this.state) : navigatorKey = GlobalKey() {
    state.addListener(notifyListeners);
  }

  void dispose() {
    state.removeListener(notifyListeners);
  }

  final RouterState state;

  bool taped = false;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  void addListener(VoidCallback listener) {
    //todo
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, result) => route.didPop(result),
      pages: [
        TestPage1(onTap: () {
          // taped = true;
          state.taped = true;
          print("tap1 ${state.taped}");
        }),
        if (state.taped)
          TestPage2(onTap: () {
            // taped = false;
            state.taped = false;
            print("tap2 ${state.taped}");
          }),
      ],
    );
  }

  @override
  Future<bool> popRoute() {
    //todo
    return Future.value(true);
  }

  @override
  void removeListener(VoidCallback listener) {
    //todo
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    //todo
    return Future.value(null);
  }
}

class TestEmpty extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => SizedBox.shrink(),
    );
  }
}

class TestPage1 extends Page {
  final Function() onTap;

  TestPage1({required this.onTap});

  @override
  Route createRoute(BuildContext context) {
    S.load(Locale('en'));
    return MaterialPageRoute(
      settings: this,
      builder: (context) => TestScreen1(onTap: onTap),
    );
  }
}

class TestPage2 extends Page {
  final Function() onTap;

  TestPage2({required this.onTap});

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => TestScreen2(onTap: onTap),
    );
  }
}

class TestScreen1 extends StatefulWidget {
  const TestScreen1({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  State<TestScreen1> createState() => _TestScreen1State();
}

class ComputeCallData<T> {
  final Future<dynamic> Function() apiCall;
  final T Function(dynamic data) parser;

  ComputeCallData(
    this.apiCall,
    this.parser,
  );
}

class ComputeCallData2<T> {
  final Dio dio;
  final dynamic parserData;

  ComputeCallData2(this.dio, this.parserData);
}

Future<T> computeCall2<T>(ComputeCallData2 data) async {
  print("COMPUTE2 START IN CALL");
  return Future.delayed(Duration(seconds: 2), () {
    print("COMPUTE2 DONE ${data.dio}");
    return data.parserData.call("result");
  });
}

Future<T> computeCall<T>(ComputeCallData data) async {
  var result = await data.apiCall.call();
  var parsed = data.parser.call(result);
  return parsed;
}

abstract class Test1 {
  static String str = "qwer";
}

class Test2 extends Test1 {
  Test2(this.s);

  String s = "";

  static String func(String data) {
    print(Test1.str);

    return "parsed $data";
  }

  factory Test2.fromJson(String data) {
    return Test2("fromJson $data");
  }

  @override
  String toString() {
    return 'Test2{s: $s}';
  }
}

class _TestScreen1State extends State<TestScreen1> {
  var _value = ValueNotifier(false);

  Dio _dio = DioFactory.buildClient();

  Future<dynamic> _testCall() {
    return Future.delayed(Duration(seconds: 2), () {
      return "result";
    });
  }

  Future<void> _testFunc() async {
    var service = NetworkService(
      dio: _dio,
      // authHolder: getIt.get(),
      // clearSessionUseCase: getIt.get(),
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
    var result = service.execute(
      request,
      parser: (raw) {
        print("PARSER RAW = $raw");
        return "parsed data";
      },
    ).then((value) {
      print("RESULT = $value");
    });
    print("COMPUTE AFTER RESULT = ${result}");
  }

  Future<void> _testFunc2() async {
    print("COMPUTE2 START");
    var result = await compute(
      computeCall2,
      ComputeCallData2(
        _dio,
        (data) {
          print("in calback result = ${data}");
          return data;
        },
      ),
    );
    print("COMPUTE2 AFTER RESULT = ${result}");
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
                onPressed: widget.onTap,
                child: Text(S.current.log_in),
              ),
            ),
          ),
          _value.value ? CircularProgressIndicator() : SizedBox.shrink(),
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
              _testFunc2();
            },
            child: Container(
              width: 50,
              height: 50,
              color: Colors.red,
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

class TestScreen2 extends StatefulWidget {
  const TestScreen2({Key? key, required this.onTap}) : super(key: key);
  final Function() onTap;

  @override
  State<TestScreen2> createState() => _TestScreen2State();
}

class _TestScreen2State extends State<TestScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Page 2"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: widget.onTap,
                child: Text("back to test_1"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
