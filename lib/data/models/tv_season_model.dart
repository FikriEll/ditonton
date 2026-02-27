import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:equatable/equatable.dart';

class TvSeasonModel extends Equatable {
  const TvSeasonModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.episodeCount,
    required this.posterPath,
    required this.seasonNumber,
    required this.airDate,
  });

  final int id;
  final String? name;
  final String? overview;
  final int? episodeCount;
  final String? posterPath;
  final int? seasonNumber;
  final String? airDate;

  factory TvSeasonModel.fromJson(Map<String, dynamic> json) => TvSeasonModel(
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        episodeCount: json['episode_count'],
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'],
        airDate: json['air_date'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'episode_count': episodeCount,
        'poster_path': posterPath,
        'season_number': seasonNumber,
        'air_date': airDate,
      };

  TvSeason toEntity() => TvSeason(
        id: id,
        name: name,
        overview: overview,
        episodeCount: episodeCount,
        posterPath: posterPath,
        seasonNumber: seasonNumber,
        airDate: airDate,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        episodeCount,
        posterPath,
        seasonNumber,
        airDate,
      ];
}
