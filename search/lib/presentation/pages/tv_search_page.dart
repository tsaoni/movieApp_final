import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/widgets/item_card_list.dart';
import '../bloc/search_bloc.dart';

class TvSearchPage extends StatelessWidget {
  static const routeName = '/tv-search';

  const TvSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(116, 196, 199, 1),
        title: const Text('Search Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 16.0,
            left: 5.0,
            right: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key('enterTvQuery'),
              onChanged: (query) {
                context.read<TvSearchBloc>().add(OnQueryChanged(query));
              },
              style: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
              decoration: InputDecoration(
                hintText: 'Search tv shows',
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
                cursorColor: Color.fromRGBO(116, 196, 199, 1)
            ),
            BlocBuilder<TvSearchBloc, SearchState>(
              builder: (context, state) {
                if (state is TvSearchHasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Search result',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(100, 100, 100, 1)
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            BlocBuilder<TvSearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvSearchHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: result.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final tv = result[index];
                        return ItemCard(
                          tv: tv,
                        );
                      },
                    ),
                  );
                } else if (state is SearchError) {
                  return Expanded(
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
