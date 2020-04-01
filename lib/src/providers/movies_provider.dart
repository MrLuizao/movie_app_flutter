
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:movie_app_flutter/src/models/movie_model.dart';
import 'package:movie_app_flutter/src/models/casting_model.dart';

class MoviesProvider {

  String _apikey ='9ad3cad1dd42ef52d9da90c7930c78c7';
  String _url ='api.themoviedb.org';
  String _language ='en-US';

  int _preferedPage = 0;
  bool _loading    = false;

  List<Movie> _preferedMovies = new List();

  final _preferedStreamCtrl = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get preferedSink => _preferedStreamCtrl.sink.add;
  Stream<List<Movie>> get preferedStream => _preferedStreamCtrl.stream;

  void disposeStreams(){
    _preferedStreamCtrl?.close();
  }

  Future<List<Movie>> _procesRequest(Uri url) async {
    
    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }


  Future<List<Movie>> getNowOnCinema() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'langauge': _language
    });
    
    return _procesRequest(url);
    
  }

  Future<List<Movie>> getPreferedMovies() async {

     if (_loading) return [];

    _loading = true;
    _preferedPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'langauge': _language,
      'page': _preferedPage.toString()
    });

    final resp = await _procesRequest(url);

    _preferedMovies.addAll(resp);
    preferedSink(_preferedMovies);

    _loading = false;
    return resp;

  }

  Future<List<Actor>> getCast( String movieID) async {
    final url = Uri.https(_url, '3/movie/$movieID/credits', {
      'api_key'  : _apikey,
      'language' : _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode( resp.body );

    final casting = new Cast.fromJsonList(decodedData['cast']);

    return casting.actors;
  }

  Future<List<Movie>> searchingMovie( String query) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apikey,
      'langauge': _language,
      'query': query
    });
    
    return _procesRequest(url);
    
  }

}