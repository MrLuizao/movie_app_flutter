import 'package:flutter/material.dart';
import 'package:movie_app_flutter/src/pages/home_page.dart';
import 'package:movie_app_flutter/src/pages/movie_detail.dart';


void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MOVIES',
      initialRoute: '/',
      routes: {
        '/' : ( BuildContext context ) => HomePage(),
        'detailPage' : ( BuildContext context ) => MovieDetail(),
      },
    );
  }
}