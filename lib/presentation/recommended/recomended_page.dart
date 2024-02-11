import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/matching_bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/presentation/recommended/widgets/recommended_section.dart';

class RecommendedPage extends StatefulWidget {
  final String repository;
  const RecommendedPage({
    super.key,
    required this.repository,
  });

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MatchingBloc>(context)
        .add(const GetRegionUsers(radius: 1.0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Profiles'),
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocBuilder<MatchingBloc, MatchingState>(
        builder: (context, state) {
          if (state is Regionprofiles) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SectionRecommendedPage(
                    state: state.locationUsers,
                    title: "Location",
                    id: widget.repository,
                  ),
                  SectionRecommendedPage(
                    state: state.interest,
                    title: "Interest",
                    id: widget.repository,
                  )
                ],
              ),
            );
          }
          if (state is RegionprofilesLoading) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 5.0,
            ));
          }
          if (state is RegionprofilesError) {
            return const SizedBox();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
