import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:my_app/navigator2/my_router_delegate.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/shopping.dart';
import 'bloc/bloc.dart';
import 'cartapp.dart';
import 'layout.dart';
import 'animation.dart';
import 'navigator2/appstate.dart';
import 'navigator2/my_route_information_parser.dart';
import 'screens/bloc_counter.dart';
import 'screens/cart.dart';
import 'screens/catalog.dart';
import 'shopping.dart';
import 'appbar.dart';
import 'snakebar.dart';

// void main() => runApp(LayoutApp());
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = MyAppState();

    final authenticationBloc = AuthenticationBloc();
    authenticationBloc.state.listen((event) {
      appState.isLogin = event.isAuthenticated;
    });
    return BlocProvider(
      blocBuilder: () => authenticationBloc,
      child: MaterialApp.router(
        title: 'Welcome to Flutter',
        theme: new ThemeData(primaryColor: Colors.blue),
        // home: DecisionPage(),
        routeInformationParser: MyRouteInformationParser(),
        routerDelegate: MyRouterDelegate(appState),
      ),
    );
  }
}

class SwitchPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context)!;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: Text('Main Screen')),
        body: Center(
          child: Wrap(
            children: <Widget>[
              ElevatedButton(
                child: Text('Layout'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LayoutApp()));
                },
              ),
              ElevatedButton(
                child: Text('Shopping'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingApp()));
                },
              ),
              ElevatedButton(
                child: Text('RandomWords'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RandomWords()));
                },
              ),
              ElevatedButton(
                child: Text('MyAppBar'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialHome()));
                },
              ),
              ElevatedButton(
                child: Text('Animation'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LogoApp()));
                },
              ),
              ElevatedButton(
                child: Text('Catalog'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartApp()));
                },
              ),
              ElevatedButton(
                child: Text('SnackBar'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SnakeBarDemo()));
                },
              ),
              ElevatedButton(
                child: Text('Bloc Counter'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BlocCounterScreen()));
                },
              ),
              ElevatedButton(
                child: Text('Logout'),
                onPressed: () {
                  authenticationBloc.emitEvent(AuthenticationEventLogout());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair wordPair) {
    final bool alreadySaved = _saved.contains(wordPair);
    return ListTile(
        title: Text(wordPair.asPascalCase, style: _biggerFont),
        trailing:
            new Icon(alreadySaved ? Icons.favorite : Icons.favorite_border, color: alreadySaved ? Colors.red : null),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(wordPair);
            } else {
              _saved.add(wordPair);
            }
          });
        });
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
        return new ListTile(
            title: new Text(
          pair.asPascalCase,
          style: _biggerFont,
        ));
      });

      final List<Widget> divided = ListTile.divideTiles(context: context, tiles: tiles).toList();

      return new Scaffold(
        appBar: new AppBar(title: const Text('Saved Suggestions')),
        body: new ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Startup Name Generator'), actions: <Widget>[
        new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
      ]),
      body: _buildSuggestions(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
