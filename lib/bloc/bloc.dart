import 'dart:async';

import 'package:flutter/material.dart';

typedef BlocBuilder<T> = T Function();
typedef BlocDisposer<T> = Function(T);

abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    required this.child,
    required this.blocBuilder,
    this.blocDispose,
  });

  final Widget child;
  final BlocBuilder<T> blocBuilder;
  final BlocDisposer<T>? blocDispose;

  @override
  State<StatefulWidget> createState() => BlocProviderState<T>();

  static T? of<T extends BlocBase>(BuildContext context) {
    final _BlocProviderInherited<T>? provider = context.dependOnInheritedWidgetOfExactType<_BlocProviderInherited<T>>();
    return provider?.bloc;
  }
}

class BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  late T bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.blocBuilder();
  }

  @override
  void dispose() {
    if (widget.blocDispose != null) {
      widget.blocDispose!(bloc);
    } else {
      bloc.dispose();
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

class _BlocProviderInherited<T extends BlocBase> extends InheritedWidget {
  _BlocProviderInherited({
    required Widget child,
    required this.bloc,
  }) : super(child: child);

  final T bloc;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

abstract class BlocEvent {}

abstract class BlocState {}

abstract class BlocEventStateBase<BlocEvent, BlocState> implements BlocBase {
  StreamController<BlocEvent> _eventController = StreamController<BlocEvent>.broadcast();
  StreamController<BlocState> _stateController = StreamController<BlocState>.broadcast();

  Function(BlocEvent) get emitEvent => _eventController.sink.add;

  Stream<BlocState> get state => _stateController.stream;

  Stream<BlocState> eventHandler(BlocEvent event, BlocState currentState);

  final BlocState initialState;
  BlocState? _currentState;

  BlocEventStateBase({required this.initialState}) {
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
    required this.builder,
    required this.bloc,
  });

  final AsyncBlocEventStateBuilder<BlocState> builder;
  final BlocEventStateBase<BlocEvent, BlocState> bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BlocState>(
      stream: bloc.state,
      initialData: bloc.initialState,
      builder: (BuildContext context, AsyncSnapshot<BlocState> snapshot) {
        return builder(context, snapshot.data!);
      },
    );
  }
}
