import 'dart:async';

import 'package:flutter/material.dart';

typedef BlocBuilder<T> = T Function();
typedef BlocDisposer<T> = Function(T);

abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.blocBuilder,
    this.blocDispose,
  }) : super(key: key);

  final Widget child;
  final BlocBuilder<T> blocBuilder;
  final BlocDisposer<T> blocDispose;

  @override
  State<StatefulWidget> createState() => BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final _BlocProviderInherited<T> provider =
        context.getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>()?.widget;
    return provider?.bloc;
  }
}

class BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  T bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.blocBuilder();
  }

  @override
  void dispose() {
    if (widget.blocDispose != null) {
      widget.blocDispose(bloc);
    } else {
      bloc?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited<T>(
      child: widget.child,
      bloc: bloc,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final BlocBase bloc;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

abstract class BlocEvent {}

abstract class BlocState {}

abstract class BlocEventStateBase<BlocEvent, BlocState> implements BlocBase {
  StreamController<BlocEvent> _eventController = StreamController<BlocEvent>();
  StreamController<BlocState> _stateController = StreamController<BlocState>();
  Stream<BlocState> _stateStream;

  Function(BlocEvent) get emitEvent => _eventController.sink.add;

  Stream<BlocState> get state => _stateStream;

  Stream<BlocState> eventHandler(BlocEvent event, BlocState currentState);

  final BlocState initialState;
  BlocState _currentState;

  BlocEventStateBase({@required this.initialState}) {
    _stateStream = _stateController.stream.asBroadcastStream();
    _eventController.stream.listen((event) {
      BlocState currentState = _currentState ?? initialState;
      eventHandler(event, currentState).forEach((BlocState newState) {
        _currentState = newState;
        _stateController.sink.add(newState);
      });
    });
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}

typedef Widget AsyncBlocEventStateBuilder<BlocState>(BuildContext context, BlocState state);

class BlocEventStateBuilder<BlocEvent, BlocState> extends StatelessWidget {
  const BlocEventStateBuilder({
    Key key,
    @required this.builder,
    @required this.bloc,
  })  : assert(builder != null),
        assert(bloc != null),
        super(key: key);

  final AsyncBlocEventStateBuilder<BlocState> builder;
  final BlocEventStateBase<BlocEvent, BlocState> bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BlocState>(
      stream: bloc.state,
      initialData: bloc.initialState,
      builder: (BuildContext context, AsyncSnapshot<BlocState> snapshot) {
        return builder(context, snapshot.data);
      },
    );
  }
}
