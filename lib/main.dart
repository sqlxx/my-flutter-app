import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:my_app/shopping.dart';
import 'cartapp.dart';
import 'layout.dart';
import 'animation.dart';
import 'screens/cart.dart';
import 'screens/catalog.dart';
import 'shopping.dart';
import 'appbar.dart';

// void main() => runApp(LayoutApp());
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(primaryColor: Colors.blue),
      home: SwitchPanel(),
    );
  }
}

class SwitchPanel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text('Main Screen')), 
        body: Center(child: Wrap(
          
          children: <Widget>[
            RaisedButton(child: Text('Layout'), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LayoutApp()));
            },),
            RaisedButton(child: Text('Shopping'), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (conext) => ShoppingApp()));
            },),
            RaisedButton(child: Text('RandomWords'), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (conext) => RandomWords()));
            },),
            RaisedButton(child: Text('MyAppBar'), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (conext) => TutorialHome()));
            },),
            RaisedButton(child: Text('Animation'), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (conext) => LogoApp()));
            },),
            RaisedButton(child: Text('Catalog'), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (conext) => CartApp()));
            },),
          ],
        ))

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

      } 
    );
  }

  Widget _buildRow(WordPair wordPair) {
    final bool alreadySaved = _saved.contains(wordPair);
    return ListTile (
      title: Text(
        wordPair.asPascalCase, style: _biggerFont
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null
      ),
      onTap: () {
        setState((){
          if (alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      }
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                )
              );
          });

          final List<Widget> divided = ListTile.divideTiles(context: context, tiles: tiles).toList();

          return new Scaffold(appBar: new AppBar(title: const Text('Saved Suggestions')),
            body: new ListView(children: divided),
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
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