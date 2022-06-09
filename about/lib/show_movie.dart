import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/presentation/widgets/item_card_list.dart';
import 'Post.dart';
import 'about.dart';


int subtitle_size = 10;
int current_tab = 0;

class TabsScreen extends StatelessWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('posts'),
          bottom: const TabBar(
            labelColor: Color.fromRGBO(116, 196, 199, 1),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.star), text: 'all posts'),
              Tab(icon: Icon(Icons.favorite), text: 'my posts')
            ],
          ),
        ),
        body: TabBarView(
          children: [SelectCard(const {0}), SelectCard(const {1})],
        ),
      ),
    );
  }
}


class SelectCard extends StatefulWidget {

  SelectCard(Set<int>set, {Key? key}) : super(key: key){
    current_tab = set.first;
  }

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {

  int _card_num = 0;

  @override
  Widget build(BuildContext context) {
    _card_num = posts.length;
    return Scaffold(
        body: Center(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _card_num + 1,
              itemBuilder: (BuildContext context, int index) {
                return myCard({index-1});
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            )
        )
    );
  }
}

class myCard extends StatelessWidget {

  int _index = -1;

  myCard(Set <int> set, {Key? key}) : super(key: key) {
    _index = set.first;
  }

  Object _subtitleInShort(String s){
    if(s.length < subtitle_size) {
      return s;
    }
    else {
      return s.substring(0, subtitle_size).padRight(subtitle_size + 3, '.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_index == -1) {
      return Center(
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child:
          Center(
              child: SizedBox(
                  width: 340.w,
                  height: 70.h,
                  child:
                  Center(
                      child: ListTile(title: Text('my posts', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(100, 100, 100, 1),) ),)
                  )
              )
          ),
        ),
      );
    }
    else{
      return GestureDetector(
        onTap: () =>
            Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => PostPage({_index}),
              ),
            ),
        child: Card(
          color: Colors.white,
          elevation: 3,
          child: SizedBox(
            height: 150,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 16,
                    bottom: 10,
                  ),
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: Urls.imageUrl(
                        posts[_index].movie.posterPath!,
                      ),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    SizedBox(
                      child: Text(posts[_index].title, style: TextStyle(fontSize: 20.sp, color: const Color.fromRGBO(116, 196, 199, 1)) ),
                    ),
                    SizedBox(
                      child: Text(
                        'movie : ${posts[_index].movie.title ?? '_'}',
                        style: TextStyle(fontSize: 15.sp, color: Color.fromRGBO(100, 100, 100, 1))
                      ),
                    ),
                    SizedBox(
                        child: Text(
                          'author:username',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color.fromRGBO(100, 100, 100, 1),
                          ),)
                    ),
                    SizedBox(height: 5,),
                    SizedBox(
                      width: 200,
                      child: Text(
                        posts[_index].content,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Color.fromRGBO(100, 100, 100, 1),
                        ),)
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

int post_id = 0;

class PostPage extends StatefulWidget {
  static const routeName = '/post';

  PostPage(Set<int> set, {Key? key}) : super(key: key){
    post_id = set.first;
  }

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final bool isLike = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(116, 196, 199, 1)//change your color here
        ),
        title: Text('Post', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Color.fromRGBO(116, 196, 199, 1))),
      ),
      body: SingleChildScrollView(
        key: const Key('postScrollView'),
        child: Column(
            children: <Widget>[
              SizedBox(
                  width: 200.w,
                  height: 120.h,
                  child:
                  Align(
                    alignment: Alignment.center,
                    child: Text(posts[post_id].title, style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Color.fromRGBO(116, 196, 199, 1))),
                  )
              ),
              SizedBox(
                child: ItemCard(
                  movie: posts[post_id].movie,
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('content',
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(100, 100, 100, 1)
                          ),
                          textAlign: TextAlign.left,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                print(isLike);
                              },
                              child: isLike
                                  ? const Icon(Icons.favorite, color: Color.fromRGBO(116, 196, 199, 1))
                                  : const Icon(Icons.favorite_outline, color: Color.fromRGBO(100, 100, 100, 1),),
                            ),
                            SizedBox(width: 3,),
                            Text('10', style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(100, 100, 100, 1),
                            ),),
                            SizedBox(width: 3,),
                          ]
                        )
                      ],
                    ),
                    Text(
                      'author:username',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(100, 100, 100, 1)
                      ),),
                    SizedBox(height: 10,),
                    Container(
                      width: 320,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.3,),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        child: Text(posts[post_id].content,
                          style: TextStyle(fontSize: 14.sp, color: Color.fromRGBO(100, 100, 100, 1)),
                          textAlign: TextAlign.left,),
                      )
                    ),
                    SizedBox(height: 40,)
                  ],
                )
              ),
            ]
        )
      )
    );
  }

}

