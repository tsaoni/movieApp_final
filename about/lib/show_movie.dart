// flutter
import 'package:flutter/material.dart';
import 'dart:math';
// my library
/*

Set themes = {};
int card_num = 3;
int subtitle_size = 10;
Set <int> choosed = {};
var rng = Random();

class SelectCard extends StatefulWidget {

  SelectCard(Set<String> set, {Key? key}) : super(key: key){
    themes = set;
  }

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {

  Set <int> _starting_pos = {};
  int _card_num = 0;

  void _count_start(){
    for(var t in themes){
      _starting_pos.add(_card_num);
      _card_num += questions[t]!.length;
    }
  }

  Set<String> _get_theme(int idx){
    if (idx == -1) {
      return {"選擇一個想問的故事"};
    }

    if(_card_num > card_num) {
      bool rechoose = true;
      while (rechoose) {
        idx = rng.nextInt(_card_num);
        rechoose = false;
        for (int ch in choosed) {
          if (ch == idx) {
            rechoose = true;
            break;
          }
        }
      }
      choosed.add(idx);
    }

    for(int i = 0; i < themes.length; i++){
      if(idx < _starting_pos.elementAt(i)){
        return {(idx - _starting_pos.elementAt(i-1)).toString(), themes.elementAt(i-1)};
      }
    }
    return {(idx - _starting_pos.last).toString(), themes.last};
  }

  @override
  Widget build(BuildContext context) {
    _count_start();
    return Scaffold(
        body: Center(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: card_num > _card_num ? _card_num + 1 : card_num + 1,
              itemBuilder: (BuildContext context, int index) {
                return myCard(_get_theme(index-1));
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            )
        )
    );
  }
}

class myCard extends StatelessWidget {
  String index = "";
  String theme = "";
  int isfirst = 0;

  myCard(Set <String> set, {Key? key}) : super(key: key) {
    index = set.first;
    theme = set.last;
    isfirst = set.length;
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
    if(isfirst == 1) {
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
                      child: ListTile(title: Text(theme, style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold) ),)
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
                title: Text('${questions[theme]![index]?.title}', style: TextStyle(fontSize: 28.sp) ),
                subtitle: Text('\n$theme: ${_subtitleInShort(questions[theme]![index]!.question)}', style: TextStyle(fontSize: 17.sp) ),
                onTap: () =>
                    Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => ShowAnswer({theme, index}),
                    ),
                    )
            ),
          ),
        ),
      );
    }
  }
}


 */