import 'package:flutter/material.dart';
import 'package:movie_app_flutter/src/models/movie_model.dart';

import 'package:movie_app_flutter/src/providers/movies_provider.dart';


class DataSearch extends SearchDelegate {

  String selection = '';
  final moviesProvider = new MoviesProvider();

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.black,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      primaryColorBrightness: Brightness.dark,
      textTheme: theme.textTheme.copyWith(title: theme.textTheme.title.copyWith(color: theme.primaryTextTheme.title.color))
      
    );
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon( Icons.clear, color: Colors.white, ),
        onPressed: () {
          query = '';
        },
      ),
  
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        color: Colors.white,
        progress: transitionAnimation,
      ),
      onPressed: (){
          close( context, null );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Text(selection),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if ( query.isEmpty ) {
      return Container(
      );
    }

    return FutureBuilder(
      future: moviesProvider.searchingMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        

          if( snapshot.hasData ) {
            
            final movies = snapshot.data;

            return ListView(
              
              children: movies.map( (movie) {
              
                  return ListTile(
                    
                    leading: FadeInImage(
                      image: NetworkImage( movie.getImagePoster()),
                      placeholder: AssetImage('assets/img/loading.gif'),
                      width: 50.0,
                      fit: BoxFit.fitHeight,
                    ),

                    title: Text( movie.title ),
                    subtitle: Text( movie.originalTitle ),
                    onTap: (){
                      close( context, null);
                      movie.uniqueId = '';
                      Navigator.pushNamed(context, 'detailPage', arguments: movie);
                    },
                  );
              }).toList()
            );

          } else {
            return Center(
              child: CircularProgressIndicator()
            );
          }

      },
    );

  }

}

