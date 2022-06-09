import 'package:movie/domain/entities/movie.dart';

class Post{
  final Movie movie;
  String title = "";
  String content = "";
  String author = "";
  int like = 0;
  // constructor
  Post(this.title, this.movie, this.content, this.author);
}

// post
List<Post> posts = [];

// login
var count = 0;
List <String>arr = [];
List <String>arr1 = [];
List <String>arr2 = [];

int current_user = 0;