import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/bloc/bloc.dart';

class CounterBloc implements BlocBase {
  int _count = 0;
  int get count => _count;

  final _counterController = StreamController<int>();
  Stream<int> get countStream => _counterController.stream;

  void increase() {
    debugPrint("Increase to $_count");
    _count++;
    _counterController.sink.add(_count);
  }

  @override
  void dispose() {
    _counterController.close();
  }
}

class BlocCounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = CounterBloc();
    return SafeArea(
        child: BlocProvider(
      child: Column(
        children: [ElevatedButton(onPressed: () => bloc.increase(), child: Text('Increase')), CounterDisplayer()],
      ),
      blocBuilder: () => bloc,
    ));
  }
}

class CounterDisplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterBlocStream = BlocProvider.of<CounterBloc>(context).countStream;
    debugPrint("stream is $counterBlocStream");
    return StreamBuilder<int>(
        stream: counterBlocStream,
        builder: (context, snapshot) {
          final countValue = snapshot.data;
          debugPrint('$countValue');
          if (countValue == null) {
            return Text("0");
          }
          return Text(countValue.toString());
        });
  }
}
