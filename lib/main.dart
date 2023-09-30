import 'package:flutter/material.dart';
import 'package:freo/search_results_model.dart';
import 'package:freo/search_results_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wikipedia Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => SearchResultsModel(),
        child: SearchResultsScreen(),
      ),
    );
  }
}
