import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  MyAppBar({this.title: const Text('')});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(color: Colors.blue[500]),
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.menu), tooltip: 'Navigation menu', onPressed: null),
            Expanded(child: title),
            IconButton(icon: Icon(Icons.search), tooltip: 'Search', onPressed: null)
          ],
        ));
  }
}

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example title'),
        actions: <Widget>[IconButton(icon: Icon(Icons.search), tooltip: 'Search', onPressed: null)],
      ),
      body: Center(child: Counter()),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: Icon(Icons.add),
        onPressed: null,
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'My app', home: TutorialHome());
  }
}

class CounterDisplay extends StatelessWidget {
  CounterDisplay({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  CounterIncrementor({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: onPressed, child: Text('Increment'));
  }
}

class Counter extends StatefulWidget {
  @override
  _CounterState createState() {
    return _CounterState();
  }
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[CounterIncrementor(onPressed: _increment), CounterDisplay(count: _counter)],
    );
  }
}
