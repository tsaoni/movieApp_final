import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/genre.dart';
import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import '../provider/tv_detail_notifier.dart';
import '../provider/tv_season_episodes_notifier.dart';
import '../widgets/minimal_detail.dart';

class TvDetailPage extends StatefulWidget {
  static const routeName = '/tv-detail';

  final int id;
  const TvDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvDetailNotifier>(context, listen: false)
          .fetchTvDetail(widget.id);
      Provider.of<TvDetailNotifier>(context, listen: false)
          .loadFavoriteStatus(widget.id);
      Provider.of<TvSeasonEpisodesNotifier>(context, listen: false)
          .fetchTvSeasonEpisodes(widget.id, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.tvState == RequestState.loaded) {
            final tv = provider.tv;
            return TvDetailContent(
              tv: tv,
              seasonNumber: tv.numberOfSeasons,
              recommendations: provider.recommendations,
              isAddedToFavorite: provider.isAddedToFavorite,
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }
}

class TvDetailContent extends StatefulWidget {
  final TvDetail tv;
  final int seasonNumber;
  final List<Tv> recommendations;
  final bool isAddedToFavorite;
  const TvDetailContent({
    Key? key,
    required this.tv,
    required this.seasonNumber,
    required this.recommendations,
    required this.isAddedToFavorite,
  }) : super(key: key);

  @override
  State<TvDetailContent> createState() => _TvDetailContentState();
}

class _TvDetailContentState extends State<TvDetailContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final List<int> _seasons = [];
  int _currentSeason = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    for (int i = 1; i <= widget.seasonNumber; i++) {
      _seasons.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const Key('tvDetailScrollView'),
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            background: FadeIn(
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                      Colors.black,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.5, 1.0, 1.0],
                  ).createShader(
                    Rect.fromLTRB(0.0, 0.0, rect.width, rect.height),
                  );
                },
                blendMode: BlendMode.dstIn,
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  imageUrl: Urls.imageUrl(widget.tv.backdropPath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeInUp(
            from: 20,
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tv.name,
                    style: kHeading5.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Color.fromRGBO(100, 100, 100, 1)
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(116, 196, 199, 1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          widget.tv.firstAirDate.split('-')[0],
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color.fromRGBO(116, 196, 199, 1),
                            size: 20.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            (widget.tv.voteAverage / 2).toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                              color: Color.fromRGBO(100, 100, 100, 1)
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '(${widget.tv.voteAverage})',
                            style: const TextStyle(
                              fontSize: 1.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        '${widget.tv.numberOfSeasons} Seasons',
                        style: const TextStyle(
                          color: Color.fromRGBO(100, 100, 100, 1),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        _showEpisodeDuration(widget.tv.episodeRunTime[0]),
                        style: const TextStyle(
                          color: Color.fromRGBO(100, 100, 100, 1),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    key: const Key('tvToFavorite'),
                    onPressed: () async {
                      if (!widget.isAddedToFavorite) {
                        await Provider.of<TvDetailNotifier>(context,
                                listen: false)
                            .addToFavorite(widget.tv);
                      } else {
                        await Provider.of<TvDetailNotifier>(context,
                                listen: false)
                            .removeFromFavorite(widget.tv);
                      }

                      final message =
                          Provider.of<TvDetailNotifier>(context, listen: false)
                              .favoriteMessage;

                      if (message ==
                              TvDetailNotifier.favoriteAddSuccessMessage ||
                          message ==
                              TvDetailNotifier.favoriteRemoveSuccessMessage) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(message)));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(message),
                            );
                          },
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.isAddedToFavorite
                            ? const Icon(Icons.favorite, color: Colors.white )
                            : const Icon(Icons.favorite_outline, color: Color.fromRGBO(100, 100, 100, 1),),
                        const SizedBox(width: 16.0),
                        Text(
                          widget.isAddedToFavorite
                              ? 'Added to favorite'
                              : 'Add to favorite',
                          style: TextStyle(
                            color: widget.isAddedToFavorite
                                ? Colors.white
                                : Color.fromRGBO(100, 100, 100, 1),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      primary: widget.isAddedToFavorite
                          ? Color.fromRGBO(116, 196, 199, 1)
                          : Colors.white,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width,
                        42.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.tv.overview,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                      color: Color.fromRGBO(100, 100, 100, 1),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Genres: ${_showGenres(widget.tv.genres)}',
                    style: const TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 16.0),
          sliver: SliverToBoxAdapter(
            child: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(116, 196, 199, 1),
                      style: BorderStyle.solid,
                      width: 4.0,
                    ),
                  ),
                ),
                labelColor: Color.fromRGBO(116, 196, 199, 1),
                tabs: [
                  Tab(text: 'Episodes'.toUpperCase()),
                  Tab(text: 'More like this'.toUpperCase()),
                ],
              ),
            ),
          ),
        ),
        Builder(builder: (context) {
          _tabController.addListener(() {
            if (!_tabController.indexIsChanging) {
              setState(() {
                _selectedIndex = _tabController.index;
              });
            }
          });

          return _selectedIndex == 0
              ? SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  sliver: SliverToBoxAdapter(
                    child: FadeIn(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(116, 196, 199, 1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<int>(
                              onChanged: (value) {
                                setState(() {
                                  _currentSeason = value!;
                                });
                                Provider.of<TvSeasonEpisodesNotifier>(
                                  context,
                                  listen: false,
                                ).fetchTvSeasonEpisodes(
                                  widget.tv.id,
                                  _currentSeason,
                                );
                              },
                              items: _seasons
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        'Season $item',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              value: _currentSeason,
                              style: const TextStyle(
                                fontSize: 16.0,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SliverToBoxAdapter();
        }),
        Builder(builder: (context) {
          _tabController.addListener(() {
            if (!_tabController.indexIsChanging) {
              setState(() {
                _selectedIndex = _tabController.index;
              });
            }
          });

          return _selectedIndex == 0
              ? SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
                  sliver: _showSeasonEpisodes(),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
                  sliver: _showRecommendations(),
                );
        }),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showEpisodeDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _showRecommendations() {
    return Consumer<TvDetailNotifier>(
      builder: (context, data, child) {
        if (data.recommendationsState == RequestState.loaded) {
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final recommendation = data.recommendations[index];
                return FadeInUp(
                  from: 20,
                  duration: const Duration(milliseconds: 500),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return MinimalDetail(
                            tv: recommendation,
                          );
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      child: CachedNetworkImage(
                        imageUrl: Urls.imageUrl(recommendation.posterPath!),
                        placeholder: (context, url) => Shimmer.fromColors(
                          child: Container(
                            height: 170.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          baseColor: Colors.grey[850]!,
                          highlightColor: Colors.grey[800]!,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        height: 180.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              childCount: data.recommendations.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.7,
              crossAxisCount:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 3
                      : 4,
            ),
          );
        } else if (data.recommendationsState == RequestState.error) {
          return SliverToBoxAdapter(child: Center(child: Text(data.message)));
        } else {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _showSeasonEpisodes() {
    return Consumer<TvSeasonEpisodesNotifier>(
      builder: (context, data, child) {
        if (data.seasonEpisodesState == RequestState.loaded) {
          return data.seasonEpisodes.isEmpty
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Comming Soon!',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromRGBO(100, 100, 100, 1)),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final seasonEpisode = data.seasonEpisodes[index];
                      return FadeInUp(
                        from: 20,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0),
                                      ),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: Urls.imageUrl(
                                            seasonEpisode.stillPath!),
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 200.0,
                                          child: Text(
                                            '${seasonEpisode.episodeNumber}. ${seasonEpisode.name}',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(100, 100, 100, 1)
                                            ),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(
                                            DateTime.parse(
                                                seasonEpisode.airDate),
                                          ),
                                          style: const TextStyle(
                                            color: Color.fromRGBO(100, 100, 100, 1),
                                            fontSize: 12.0,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  seasonEpisode.overview,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(100, 100, 100, 1),
                                    fontSize: 10.0,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: data.seasonEpisodes.length,
                  ),
                );
        }
        if (data.seasonEpisodesState == RequestState.error) {
          return SliverToBoxAdapter(child: Center(child: Text(data.message)));
        } else {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
