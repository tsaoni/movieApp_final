import 'package:movie/domain/entities/movie.dart';

class Post{
  final Movie movie;
  String title = "";
  String content = "";
  // constructor
  Post(this.title, this.movie, this.content);
}

List<Post> posts = [];