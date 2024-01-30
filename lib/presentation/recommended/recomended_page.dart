import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/domain/matching_bloc/matching_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';

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
      appBar: AppBar(
        title: const Text('Recommended Profiles'),
      ),
      body: BlocBuilder<MatchingBloc, MatchingState>(
        builder: (context, state) {
          if (state is Regionprofiles) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SectionRecommendedPage(
                      state: state.locationUsers, title: "Location"),
                  SectionRecommendedPage(
                      state: state.interest, title: "Interest")
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

class SectionRecommendedPage extends StatelessWidget {
  final List<Map<String, dynamic>> state;
  final String title;
  const SectionRecommendedPage({
    Key? key,
    required this.state,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(title, style: Theme.of(context).textTheme.displayMedium),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              itemCount: state.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final data = state[index];
                return RecommendedCard(data: data);
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class RecommendedCard extends StatelessWidget {
  const RecommendedCard({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserProfileBottomSheet(data: data),
        ));
        //print(data['location']);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Container(
              height: 220,
              width: 120,
              foregroundDecoration: BoxDecoration(
                gradient: AppTheme.blackFade,
              ),
              decoration: BoxDecoration(
                  color: AppTheme.black26,
                  image: DecorationImage(
                    image: NetworkImage(data['photoUrl']),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
            ),
            Positioned(
              bottom: 20,
              left: 12,
              child: Row(
                children: [
                  Text(
                    '${data['name'].toString().split(' ').first} , ${data['age'].toString()}',
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
