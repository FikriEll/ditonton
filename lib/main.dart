import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/services/firebase_service.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movies/movie_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/movie_list_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/movie_search_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tvs_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tvs_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_list_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_search_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_cubit.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/on_the_air_tvs_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tvs_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await FirebaseService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<MovieListCubit>()),
        BlocProvider(create: (_) => di.locator<MovieDetailCubit>()),
        BlocProvider(create: (_) => di.locator<MovieSearchCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieCubit>()),
        BlocProvider(create: (_) => di.locator<TvListCubit>()),
        BlocProvider(create: (_) => di.locator<TvDetailCubit>()),
        BlocProvider(create: (_) => di.locator<TvSearchCubit>()),
        BlocProvider(create: (_) => di.locator<PopularTvsCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvsCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvCubit>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [
          routeObserver,
          if (FirebaseService.analyticsObserver != null)
            FirebaseService.analyticsObserver!,
        ],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case HomeTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const HomeTvPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const WatchlistPage());
            case PopularTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const PopularTvsPage());
            case TopRatedTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedTvsPage());
            case OnTheAirTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const OnTheAirTvsPage());
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case SearchTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const SearchTvPage());
            case WatchlistTvsPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const WatchlistTvsPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
