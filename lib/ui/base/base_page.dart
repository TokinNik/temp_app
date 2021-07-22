import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BasePage<T extends BlocBase> extends StatelessWidget {
  final BlocBase Function(BuildContext) bloc;
  final State<BaseStatefulWidget> state;

  const BasePage({
    Key key,
    this.bloc,
    @required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bloc != null
        ? BlocProvider<T>(
            create: (context) => bloc(context),
            child: BaseStatefulWidget(state: state),
          )
        : BaseStatefulWidget(state: state);
  }
}

class BaseStatefulWidget extends StatefulWidget {
  final State state;

  const BaseStatefulWidget({
    Key key,
    @required this.state,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => state;
}
