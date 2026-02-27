import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_season_model.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailResponse extends Equatable {
  const TvDetailResponse({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
    required this.episodeRunTime,
  });

  final String? backdropPath;
  final String? firstAirDate;
  final List<GenreModel> genres;
  final int id;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final int voteCount;
  final List<TvSeasonModel> seasons;
  final List<int> episodeRunTime;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        backdropPath: json['backdrop_path'],
        firstAirDate: json['first_air_date'],
        genres: List<GenreModel>.from(
            (json['genres'] as List).map((x) => GenreModel.fromJson(x))),
        id: json['id'],
        name: json['name'],
        numberOfEpisodes: json['number_of_episodes'],
        numberOfSeasons: json['number_of_seasons'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        voteAverage: (json['vote_average'] as num).toDouble(),
        voteCount: json['vote_count'],
        seasons: json['seasons'] != null
            ? List<TvSeasonModel>.from(
                (json['seasons'] as List).map((x) => TvSeasonModel.fromJson(x)))
            : <TvSeasonModel>[],
        episodeRunTime: json['episode_run_time'] != null
            ? List<int>.from(json['episode_run_time'].map((x) => x))
            : <int>[],
      );

  Map<String, dynamic> toJson() => {
        'backdrop_path': backdropPath,
        'first_air_date': firstAirDate,
        'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
        'id': id,
        'name': name,
        'number_of_episodes': numberOfEpisodes,
        'number_of_seasons': numberOfSeasons,
        'overview': overview,
        'poster_path': posterPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'seasons': List<dynamic>.from(seasons.map((x) => x.toJson())),
        'episode_run_time': List<dynamic>.from(episodeRunTime.map((x) => x)),
      };

  TvDetail toEntity() => TvDetail(
        backdropPath: backdropPath,
        firstAirDate: firstAirDate,
        genres: genres.map((x) => x.toEntity()).toList(),
        id: id,
        name: name,
        numberOfEpisodes: numberOfEpisodes,
        numberOfSeasons: numberOfSeasons,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
        seasons: seasons.map((x) => x.toEntity()).toList(),
        episodeRunTime: episodeRunTime,
      );

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        genres,
        id,
        name,
        numberOfEpisodes,
        numberOfSeasons,
        overview,
        posterPath,
        voteAverage,
        voteCount,
        seasons,
        episodeRunTime,
      ];
}
