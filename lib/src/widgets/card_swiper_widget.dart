import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_app_flutter/src/models/movie_model.dart';


class CardSwiper extends StatelessWidget {

  final List<Movie> movies;

  CardSwiper({ @required this.movies });

  @override
  Widget build(BuildContext context) {

  final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 25.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {

          movies[index].uniqueId = '${movies[index].id}-cardMain';

          return Hero(
            tag: movies[index].uniqueId,
              child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
                child: GestureDetector(
                  onTap: ()=>Navigator.pushNamed(context, 'detailPage', arguments: movies[index] ),
                    child: FadeInImage(
                    image: NetworkImage( movies[index].getImagePoster() ),
                    // placeholder: AssetImage('assets/img/no-image.jpg'),
                    placeholder: AssetImage('assets/img/loading.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
    
  }
}