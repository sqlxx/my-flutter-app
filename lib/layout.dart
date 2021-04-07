import 'package:flutter/material.dart';

class LayoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('Oeschinen Lake Campground', style: TextStyle(fontWeight: FontWeight.bold))
                ),
                Text('Kandersteg, Switzerland', style: TextStyle(color: Colors.grey[500]))
              ],
            )
          ),
          FavoriteWidget()
        ],
      )
    );

    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButtonColumn(color, Icons.call, 'CALL'),
          _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          _buildButtonColumn(color, Icons.share, 'SHARE'),
        ],
        
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(    'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
        'Alps. Situated 1,578 meters above sea level, it is one of the '
        'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
        'half-hour walk through pastures and pine forest, leads you to the '
        'lake, which warms to 20 degrees Celsius in the summer. Activities '
        'enjoyed here include rowing, and riding the summer toboggan run.',
        softWrap: true)
    );


    return 
      Scaffold(
        appBar: AppBar(title: Text('Flutter layout demo')),
        body: ListView(children: <Widget>[
          Image.asset('images/lake.jpg', height:260, width: 600, fit: BoxFit.cover),
          titleSection,
          buttonSection,
          textSection
        ],) 
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color
            )
          )
        )
      ]
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {

  bool _isFavorite = false;
  int _favoriteCount = 41;

  void _onPress() {
    print('$_favoriteCount');
    setState(() {
    if (_isFavorite) {
      _isFavorite = false;
      _favoriteCount --;
    } else {
      _isFavorite = true;
      _favoriteCount ++;
    }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: IconButton(icon: _isFavorite? Icon(Icons.star) : Icon(Icons.star_border), 
            color: Colors.red[500],
            onPressed: _onPress),

        ),
        Text('$_favoriteCount'),
      ]
    ); 
  }

}