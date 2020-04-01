import 'package:flutter/material.dart';
import 'package:movie_app_flutter/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Movie> movies;
  final Function nextPage;

  MovieHorizontal({ @required this.movies, @required this.nextPage });

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener( () {

      if ( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ){
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: ( context, i ) => _singleCard(context, movies[i] ),
      ),
      
    );
  }

  List <Widget> _cards(BuildContext context) {

     return movies.map( (movie) {

      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage( movie.getImagePoster() ),
                placeholder: AssetImage('assets/img/loading.gif'),
                fit: BoxFit.cover,
                height: 130.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle,
            )
          ],
        ),
      );
    }).toList();
  }

  Widget _singleCard(BuildContext context, Movie movie) {
    
    movie.uniqueId = '${ movie.id }-horizontalMovies';

    final singleCard = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: movie.uniqueId, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  image: NetworkImage( movie.getImagePoster() ),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                  height: 150.0,
                  width: 150.0,
                ),
              ),
            ),
            // SizedBox(height: 25.0),
            // Text(
            //   movie.title,
            //   overflow: TextOverflow.ellipsis,
            //   style: Theme.of(context).textTheme.subtitle,
            // )
          ],
        ),
      );

    return GestureDetector(
      child: singleCard,
      onTap: (){
        print('MOVIE ONTAP:  ${movie.title}');
        Navigator.pushNamed(context, 'detailPage', arguments: movie );
      },
    );
  }
}