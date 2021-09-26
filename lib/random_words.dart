// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, annotate_overrides, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget{
  @override
  RandomWordState createState() => RandomWordState();
}

class RandomWordState extends State<RandomWords>{
  final _randomPairs = <WordPair>[];
  final _savedWords = Set<WordPair>();

  Widget _buildList(){
    return ListView.builder(
      padding: const EdgeInsets.all(15.0),
      itemBuilder: (context, item){
        if (item.isOdd) return Divider();
        
        final index = item ~/ 2;

        if (index >= _randomPairs.length){
          _randomPairs.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_randomPairs[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair){
    final alreadySaved = _savedWords.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase, 
        style: TextStyle(
          fontSize: 20.0,
          ),
        ),
      trailing: Icon(alreadySaved ? Icons.favorite:Icons.favorite_border,
              color: alreadySaved ? Colors.red:null,
        ),
      onTap: (){
        setState(() {
          if (alreadySaved){
            _savedWords.remove(pair);
          }
          else{
            _savedWords.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
            final Iterable<ListTile> tiles = _savedWords.map((WordPair pair) {
                return ListTile(
                  title: Text(pair.asPascalCase, 
                  style: TextStyle(fontSize: 16.0)
                  )
                );
            });

            final List<Widget> divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('Saved WordPairs'),
              ),
              body: ListView(children: divided),
            );
          }
        )
    );
  }

  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Pair Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildList(),
    );
  }
}