import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:my_app/navigator2/my_router_delegate.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/shopping.dart';
import 'package:provider/provider.dart';
import 'bloc/bloc.dart';
import 'cartapp.dart';
import 'layout.dart';
import 'animation.dart';
import 'navigator2/route_state.dart';
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
    final appState = RouteState();

    final authenticationBloc = AuthenticationBloc();
    authenticationBloc.state.listen((event) {
      appState.isLogin = event.isAuthenticated;
    });
    return ChangeNotifierProvider<RouteState>(
        create: (_) => appState,
        child: BlocProvider(
          blocBuilder: () => authenticationBloc,
          child: MaterialApp.router(
            title: 'Welcome to Flutter',
            theme: new ThemeData(primaryColor: Colors.blue),
            // home: DecisionPage(),
            routeInformationParser: MyRouteInformationParser(),
            routerDelegate: MyRouterDelegate(appState),
          ),
        ));
  }
}

class SwitchPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context)!;
    final RouteState appState = Provider.of<RouteState>(context, listen: false);
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
                  appState.push(RouteState.PATH_LAYOUT);
                },
              ),
              ElevatedButton(
                child: Text('Shopping'),
                onPressed: () => appState.push(RouteState.PATH_SHOPPING),
              ),
              ElevatedButton(
                child: Text('RandomWords'),
                onPressed: () => appState.push(RouteState.PATH_RANDOM_WORDS),
              ),
              ElevatedButton(
                child: Text('MyAppBar'),
                onPressed: () => appState.push(RouteState.PATH_MY_APP_BAR),
              ),
              ElevatedButton(
                child: Text('Animation'),
                onPressed: () => appState.push(RouteState.PATH_ANIMATION),
              ),
              ElevatedButton(
                child: Text('Catalog'),
                onPressed: () => appState.push(RouteState.PATH_CATALOG),
              ),
              ElevatedButton(child: Text('SnackBar'), onPressed: () => appState.push(RouteState.PATH_SNACK_BAR)),
              ElevatedButton(
                child: Text('Bloc Counter'),
                onPressed: () {
                  appState.push(RouteState.PATH_BLOC_COUNTER);
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
