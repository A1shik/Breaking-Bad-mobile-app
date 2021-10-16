import 'dart:convert';
import './character_api.dart';
import './character.dart';
import 'package:flutter/material.dart';

class CharacterList extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CharacterList({Key? key}) : super(key: key);

  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  List<Character> characterList = [];
  final _savedCharacters = Set<Character>();

  void getCharactersfromApi() async {
    CharacterApi.getCharacters().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        characterList = list.map((model) => Character.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCharactersfromApi();
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedCharacters.map((Character ch) {
        return ListTile(
            title: Text(ch.nickname, style: TextStyle(fontSize: 16.0)),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(ch.img),
            ));
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
          appBar: AppBar(title: Text('Favorited contacts')),
          body: ListView(children: divided));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Breaking Bad phone contacts"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: Container(
          child: ListView.builder(
              itemCount: characterList.length,
              itemBuilder: (context, index) {
                if (index.isOdd) return Divider(color: Colors.blue[900]);
                final alreadySaved =
                    _savedCharacters.contains(characterList[index]);
                return ListTile(
                  title: Text(characterList[index].name),
                  trailing: Icon(alreadySaved ? Icons.star : Icons.star_border,
                      color: alreadySaved ? Colors.orange : null),
                  onTap: () {
                    setState(() {
                      if (alreadySaved) {
                        _savedCharacters.remove(characterList[index]);
                      } else {
                        _savedCharacters.add(characterList[index]);
                      }
                    });
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(characterList[index].img),
                  ),
                );
              }),
        ));
  }
}
