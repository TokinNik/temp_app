import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/ui/pages/temp_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          return TempPage(title: 'Test Page');
        },
      ),
    );
  }
}
