import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_list_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_list_state.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-the-air-tv';

  const OnTheAirTvsPage({Key? key}) : super(key: key);

  @override
  State<OnTheAirTvsPage> createState() => _OnTheAirTvsPageState();
}

class _OnTheAirTvsPageState extends State<OnTheAirTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TvListCubit>().fetchOnTheAirTvs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvListCubit, TvListState>(
          builder: (context, state) {
            if (state.onTheAirState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.onTheAirState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.onTheAirTvs[index];
                  return TvCard(tv);
                },
                itemCount: state.onTheAirTvs.length,
              );
            }
            if (state.onTheAirState == RequestState.Error) {
              return Center(
                child: Text(
                  state.message,
                  key: const Key('error_message'),
                ),
              );
            }
            return const Center(child: Text('No Data'));
          },
        ),
      ),
    );
  }
}
