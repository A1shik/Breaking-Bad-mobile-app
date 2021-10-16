//import 'dart:html';

import 'package:flutter/material.dart';
import 'character_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.orange[900]),
        home: CharacterList());
  }
}
