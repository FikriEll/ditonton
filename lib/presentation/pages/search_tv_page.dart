import 'package:ditonton/common/services/firebase_service.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_search_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_search_state.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTvPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';

  const SearchTvPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<TvSearchCubit>().fetchTvSearch(query);
                FirebaseService.logEvent(
                  'tv_search',
                  parameters: {
                    'query_length': query.length,
                  },
                );
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<TvSearchCubit, TvSearchState>(
              builder: (context, state) {
                if (state.state == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.state == RequestState.Loaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return TvCard(state.result[index]);
                      },
                      itemCount: state.result.length,
                    ),
                  );
                }
                return const Expanded(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
