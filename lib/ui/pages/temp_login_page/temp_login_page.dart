import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:temp_app/app.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/localization/generated/l10n.dart';
import 'package:temp_app/ui/pages/temp_next_rout_page/temp_next_rout_page.dart';
import 'package:temp_app/utils/extensions.dart';

import '../dropdown_test_page/dropdown_test.dart';

class TempLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TempLoginPageState();

}

class _TempLoginPageState extends State<TempLoginPage> {
  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Temp Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                globalBloc(context).add(LogOutEvent());
              },
              child: Text(s.log_in),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(TempNextRoutPage.route(1));
              },
              child: Text(s.next_page),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                setState(() {
                  S.delegate.supportedLocales.printAll();
                  Intl.defaultLocale = Intl.defaultLocale ==
                          S.delegate.supportedLocales.first.languageCode
                      ? S.delegate.supportedLocales.last.languageCode
                      : S.delegate.supportedLocales.first.languageCode;
                });
              },
              child: Text(s.change_locale),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(DropdownTestPage.route());
              },
              child: Text("Dropdown test"),
            ),
          ],
        ),
      ),
    );
  }
}
