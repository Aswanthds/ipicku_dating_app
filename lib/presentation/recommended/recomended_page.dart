import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/domain/bloc/matching_bloc.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({
    super.key,
  });

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  bool _isLoading = false;
  @override
  void initState() {
    if (!_isLoading) {
      BlocProvider.of<MatchingBloc>(context)
          .add(const GetRegionUsers(radius: 1.0));
      _isLoading = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recommended Profiles'),
        ),
        body: BlocBuilder<MatchingBloc, MatchingState>(
          builder: (context, state) {
            if (state is Regionprofiles) {
              return buildSection(
                "Location",
                ListView.builder(
                  itemCount: state.userProfile.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final data = state.userProfile[index];
                    return _buildProfileCard(
                      data['name'],
                      data['age'],
                      data['photoUrl'],
                      'Age',
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ));
  }

  Widget _buildProfileCard(
      String name, int description, String imagePath, String title) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 120,
        child: Stack(
          children: <Widget>[
            Container(
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(imagePath), fit: BoxFit.cover)),
            ),
            Container(
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: AppTheme.blackFade,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "$title :",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white,
                        ),
                        children: [
                          TextSpan(
                            text: description.toString(),
                            style: const TextStyle(color: AppTheme.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String s, ListView buildInterestProfiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Text(
            s,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: buildInterestProfiles,
        ),
      ],
    );
  }
}
