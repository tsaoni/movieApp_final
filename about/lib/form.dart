import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/widgets/item_card_list.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'Post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Movie _selectedMovie;
  var _movieController = "please select a movie!";
  bool _movieSelected = false;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        key: const Key('commentScrollView'),
        child: Column(
          children: [
            SizedBox(height: 20,),
            SizedBox(
              width: 330.w,
              height: 50.h,
              child: Text('Add comment', style: TextStyle(fontSize: 28.sp, color: Color.fromRGBO(100, 100, 100, 1))),
            ),
            Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 300.w,
                        height: 50.h,
                        child: TextFormField(
                            controller: titleController,
                            style: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(100, 100, 100, 1), width: 1.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(116, 196, 199, 1), width: 2.0),
                                ),
                                hintText: 'please enter title',
                                hintStyle: TextStyle(color: Color.fromRGBO(100, 100, 100, 1))
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'title necessary';
                              }
                              return null;
                            },
                            cursorColor: Color.fromRGBO(116, 196, 199, 1)
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      SizedBox(
                        width: 300.w,
                        child:
                        TextField(
                            controller: contentController,
                            style: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            // textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              hintText: 'please enter your comment',
                              hintStyle: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(100, 100, 100, 1), width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(116, 196, 199, 1), width: 2.0),
                              ),
                            ),
                            cursorColor: Color.fromRGBO(116, 196, 199, 1)
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      SizedBox(
                        width: 300.w,
                        // height: 30.h,
                        child: Text(
                          'movie : $_movieController',
                          style: TextStyle(
                            color: _movieSelected ? Color.fromRGBO(100, 100, 100, 1) : Color.fromRGBO(116, 196, 199, 1),
                            fontSize: 18,),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 20,
                              right: 20),
                          child: Column(
                            children: [
                              TextField(
                                key: const Key('enterMovieQuery'),
                                onChanged: (query) {
                                  context.read<MovieSearchBloc>().add(OnQueryChanged(query));
                                },
                                style: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
                                decoration: InputDecoration(
                                  hintText: 'Search movies',
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(100, 100, 100, 1)
                                  ),
                                  prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color.fromRGBO(100, 100, 100, 1)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(color: Color.fromRGBO(100, 100, 100, 1))
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Color.fromRGBO(116, 196, 199, 1)),
                                  ),
                                ),
                                textInputAction: TextInputAction.search,
                                cursorColor: Color.fromRGBO(116, 196, 199, 1),
                              ),
                              SizedBox(height: 10,),
                              BlocBuilder<MovieSearchBloc, SearchState>(
                                builder: (context, state) {
                                  if (state is SearchLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is MovieSearchHasData) {
                                    final result = state.result;
                                    return SizedBox(
                                      height: 240,
                                      child: ListView.builder(
                                        itemCount: result.length,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final movie = result[index];
                                          return GestureDetector(
                                            onTap: (){
                                              setState((){
                                                _movieController = movie.title ?? '-';
                                                _selectedMovie = movie;
                                                _movieSelected = true;
                                              });
                                              print(_movieController);
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.3,
                                                      )
                                                  )
                                              ),
                                              child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        child: CachedNetworkImage(
                                                          imageUrl: Urls.imageUrl(
                                                            movie.posterPath!,
                                                          ),
                                                          placeholder: (context, url) => const Center(
                                                            child: CircularProgressIndicator(),
                                                          ),
                                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 16),
                                                    SizedBox(
                                                        width: 250,
                                                        child:Text(
                                                          movie.title ?? '-',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color.fromRGBO(100, 100, 100, 1)),)
                                                    )
                                                  ]
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else if (state is SearchError) {
                                    return SizedBox(
                                      height: 30,
                                      child: Center(
                                        child: Text(state.message),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      height: 0,
                                      child: Container(),
                                    );
                                  }
                                },
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 10.h,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if(!_movieSelected){
                              setState((){
                                _movieController = "PLEASE SELECT A MOVIE!!!";
                              });
                            }else if (_formKey.currentState!.validate()) {
                              posts.add(Post(titleController.text, _selectedMovie, contentController.text));
                              titleController.clear();
                              contentController.clear();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(116, 196, 199, 1)),
                          ),
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      )
    );
  }
}
