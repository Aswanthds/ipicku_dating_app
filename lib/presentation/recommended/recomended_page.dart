import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/matching_bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/presentation/recommended/widgets/card.dart';
import 'package:ipicku_dating_app/presentation/recommended/widgets/recommended_section.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({
    super.key,
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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Events and Recommendations'),
          surfaceTintColor: Colors.transparent,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BlocBuilder<MatchingBloc, MatchingState>(
                builder: (context, state) {
                  if (state is Regionprofiles) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.width - 60,
                      child: ListView.builder(
                        itemCount: state.interestSeparately.keys.length + 1,
                        itemBuilder: (context, index) {
                          return SectionRecommendedPage(
                            state: state.locationUsers,
                            title: "Location",
                            //id: widget.repository,
                          );
                        },
                      ),
                    );
                  }
                  if (state is RegionprofilesLoading) {
                    return const SizedBox(
                      height: 280,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                        ),
                      ),
                    );
                  }
                  if (state is RegionprofilesError) {
                    return const SizedBox();
                  }
                  return const SizedBox();
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Events",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 20,
                      ),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 3,
              children: List<Widget>.generate(
                6,
                (index) {
                  return FitnessCard(
                    imagePath: arr[index],
                    title: "Event ${index + 1}",
                    toPage: Scaffold(),
                  );
                },
                growable: false,
              ),
            )
          ],
        ));
  }
}

var arr = [
  "assets/images/dates.svg",
  "assets/images/park.svg",
  "assets/images/beach.svg",
  "assets/images/online.svg",
  "assets/images/party.svg",
  "assets/images/private.svg",
];
