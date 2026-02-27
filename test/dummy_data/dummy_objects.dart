import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:ditonton/data/models/tv_table.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTv = Tv(
  adult: null,
  backdropPath: 'backdropPath',
  genreIds: [1, 2],
  id: 100,
  originalName: 'Original Name',
  overview: 'Overview TV',
  popularity: 10,
  posterPath: 'posterPath',
  firstAirDate: '2021-09-17',
  name: 'TV Title',
  voteAverage: 8.0,
  voteCount: 100,
  originCountry: const ['US'],
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  backdropPath: 'backdropPath',
  firstAirDate: '2021-09-17',
  genres: [Genre(id: 1, name: 'Action')],
  id: 100,
  name: 'TV Title',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  overview: 'Overview TV',
  posterPath: 'posterPath',
  voteAverage: 8.0,
  voteCount: 100,
  seasons: const [
    TvSeason(
      id: 1001,
      name: 'Season 1',
      overview: 'Season Overview',
      episodeCount: 10,
      posterPath: 'posterPath',
      seasonNumber: 1,
      airDate: '2021-09-17',
    )
  ],
  episodeRunTime: const [50],
);

final testWatchlistTv = Tv.watchlist(
  id: 100,
  overview: 'Overview TV',
  posterPath: 'posterPath',
  name: 'TV Title',
);

final testTvTable = TvTable(
  id: 100,
  name: 'TV Title',
  posterPath: 'posterPath',
  overview: 'Overview TV',
);

final testTvMap = {
  'id': 100,
  'name': 'TV Title',
  'posterPath': 'posterPath',
  'overview': 'Overview TV',
};
