import 'package:ditonton/common/services/firebase_service.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movies/movie_search_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/movie_search_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<MovieSearchCubit>().fetchMovieSearch(query);
                FirebaseService.logEvent(
                  'movie_search',
                  parameters: {
                    'query_length': query.length,
                  },
                );
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<MovieSearchCubit, MovieSearchState>(
              builder: (context, state) {
                if (state.state == RequestState.Loading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state.state == RequestState.Loaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return MovieCard(state.result[index]);
                      },
                      itemCount: state.result.length,
                    ),
                  );
                }
                return Expanded(child: Container());
              },
            ),
          ],
        ),
      ),
    );
  }
}
