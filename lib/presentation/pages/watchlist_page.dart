import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-all';

  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistMovieCubit>().fetchWatchlistMovies();
      context.read<WatchlistTvCubit>().fetchWatchlistTvs();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieCubit>().fetchWatchlistMovies();
    context.read<WatchlistTvCubit>().fetchWatchlistTvs();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Series'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MoviesWatchlist(),
            _TvWatchlist(),
          ],
        ),
      ),
    );
  }
}

class _MoviesWatchlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieCubit, WatchlistMovieState>(
        builder: (context, state) {
          if (state.state == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.state == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return MovieCard(state.movies[index]);
              },
              itemCount: state.movies.length,
            );
          }
          if (state.state == RequestState.Error) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No watchlist'));
        },
      ),
    );
  }
}

class _TvWatchlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistTvCubit, WatchlistTvState>(
        builder: (context, state) {
          if (state.state == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.state == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return TvCard(state.tvs[index]);
              },
              itemCount: state.tvs.length,
            );
          }
          if (state.state == RequestState.Error) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No watchlist'));
        },
      ),
    );
  }
}
