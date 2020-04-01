import 'package:flutter/material.dart';
import 'package:movie_app_flutter/src/providers/movies_provider.dart';
import 'package:movie_app_flutter/src/search/search_delegate.dart';
import 'package:movie_app_flutter/src/widgets/card_swiper_widget.dart';
import 'package:movie_app_flutter/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget {

  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {

    moviesProvider.getPreferedMovies();

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        // title: Text('Movies in Theaters', style: Theme.of(context).textTheme.title),
        title: Text('Movies in Theaters', style: TextStyle(color: Colors.white) ),
        centerTitle: false,
        backgroundColor: Colors.black54,
        actions: <Widget>[
          IconButton(
            icon: Icon (Icons.search), 
            onPressed: (){
                showSearch(
                context: context, 
                delegate: DataSearch(),
              ); 
            }
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _swiperCards(),
            _footer(context)
          ],
        ),
      )
    );
  }

  Widget _swiperCards() {

    return FutureBuilder(
      future: moviesProvider.getNowOnCinema(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        
        if ( snapshot.hasData ) {
          return CardSwiper( movies: snapshot.data );
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context){

    return Container(
      padding: EdgeInsets.only(top:40.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            // child: Text('Prefered by users', style: Theme.of(context).textTheme.subtitle),    
            child: Text('Prefered by users', style: TextStyle(color: Colors.white, fontSize: 18.0) ),
            // color: Colors.redAccent,
          ),
          // SizedBox(height: 17.0),

          StreamBuilder(
            stream: moviesProvider.preferedStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              
              if ( snapshot.hasData ) {
                return MovieHorizontal( 
                  movies: snapshot.data,
                  nextPage: moviesProvider.getPreferedMovies
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

        ],
      ),
    );

  }
}