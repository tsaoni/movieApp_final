import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'Post.dart';
import 'about.dart';


int subtitle_size = 10;

class SelectCard extends StatefulWidget {

  SelectCard({Key? key}) : super(key: key){
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
                  height: 200.h,
                  child:
                  Center(
                      child: ListTile(title: Text('my posts', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold) ),)
                  )
              )
          ),
        ),
      );
    }
    else{
      return Center(
        child: Card(
          color: const Color(0xffffd66b),
          child: SizedBox(
            width: 340.w,
            height: 136.h,
            child: ListTile(
                title: Text(posts[_index].title, style: TextStyle(fontSize: 28.sp) ),
                subtitle: Text('\n${_subtitleInShort(posts[_index].content)}', style: TextStyle(fontSize: 17.sp) ),
                onTap: () =>
                    Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => PostPage({_index}),
                    ),
                    )
            ),
          ),
        ),
      );
    }
  }
}

int post_id = 0;

class PostPage extends StatefulWidget {

  PostPage(Set<int> set, {Key? key}) : super(key: key){
    post_id = set.first;
  }

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        children: <Widget>[
          SizedBox(
            width: 200.w,
            height: 120.h,
            child:
                Align(
                  alignment: Alignment.center,
                  child: Text(posts[post_id].title, style: TextStyle(fontSize: 28.sp)),
                )
          ),
          Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: SizedBox(
            width: 400,
            height: 500,
            child: Text(posts[post_id].content, style: TextStyle(fontSize: 14.sp))
          ),
        ),
          SizedBox(
            width: 150.w,
            height: 50.h,
            child: Align(
              alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                  );
                },
              child: const Text('back'),
            ),
            )
          )
        ]
        )
      )
    );
  }

}

