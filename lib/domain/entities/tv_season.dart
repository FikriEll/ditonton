import 'package:equatable/equatable.dart';

class TvSeason extends Equatable {
  const TvSeason({
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
