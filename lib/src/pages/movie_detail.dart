
import 'package:flutter/material.dart';
import 'package:movie_app_flutter/src/models/casting_model.dart';
import 'package:movie_app_flutter/src/models/movie_model.dart';
import 'package:movie_app_flutter/src/providers/movies_provider.dart';

class MovieDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppBar(movie),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0,),
                _titlePoster(context, movie),
                _synopsisText(movie),
                _createCasting(movie)
              ]
            )
          )
        ],
      ),
    );
  }

  Widget _createAppBar(Movie movie) {

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.black54,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // title: Text(
        //   movie.title, 
        //   style: TextStyle(color: Colors.white)
        // ),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'), 
          image: NetworkImage(movie.getImageBackground()),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _titlePoster(BuildContext context, Movie movie) {

     return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
            // ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: NetworkImage( movie.getImagePoster() ),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(movie.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis ),
                // Text(movie.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis ),
                Text(movie.title, style: TextStyle(color: Colors.white, fontSize: 30.0), overflow: TextOverflow.ellipsis ),
                Text(movie.originalTitle, style: TextStyle(color: Colors.white, fontSize: 20.0), overflow: TextOverflow.ellipsis ),
                Row(
                  children: <Widget>[
                    Icon( Icons.star_border, color: Colors.yellow),
                    // Text( movie.voteAverage.toString(), style: Theme.of(context).textTheme.subhead )
                    Text( movie.voteAverage.toString(), 
                          style: TextStyle(color: Colors.white, fontSize: 20.0) 
                        )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _synopsisText(Movie movie) {
     return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: TextStyle(color: Colors.white, fontSize: 20.0)
      ),
    );
  }
  
  Widget _createCasting(Movie movie){

    final movieProvider = new MoviesProvider();

      return FutureBuilder(
        future: movieProvider.getCast(movie.id.toString()),
        builder: (context, AsyncSnapshot<List> snapshot) {
          
          if( snapshot.hasData ) {
            return _createActoraPageView( snapshot.data );
          } else {
            return Center(child: CircularProgressIndicator());
          }

        },
      );

  }

  Widget _createActoraPageView( List<Actor> actorList ) {

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actorList.length,
        itemBuilder: (context, i) =>_actorCard( actorList[i] ),
      ),
    );
  }

  Widget _actorCard( Actor actor ) {
    return Container(
          margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              image: NetworkImage( actor.getPhotoActor() ),
              placeholder: AssetImage('assets/img/loading.gif'),
              height: 170.0,
              width: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 12.0) 
          )
        ],
      )
    );
  }

}
