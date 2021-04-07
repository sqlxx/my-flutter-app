import 'package:flutter/material.dart';

class SnakeBarDemo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SnackBar Demo')),
      body: SnakeBarPage(),
    );
  }
}

class SnakeBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('Yay, a snack bar'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {},
            )
          );

          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text('Show Snackbar'),
      )
    );
  }
}