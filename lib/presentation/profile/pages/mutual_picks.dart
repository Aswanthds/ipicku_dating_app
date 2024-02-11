import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_list.dart';

class MutualPicks extends StatelessWidget {
  final UserModel user;

  const MutualPicks({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MatchesDataBloc>(context).add(MutualListLoadingEvent());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mutual Picks"),
        ),
        body: BlocBuilder<MatchesDataBloc, MatchesDataState>(
          builder: (context, state) {
            if (state is MutualListLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.red,
                  strokeWidth: 5.0,
                ),
              );
            }
            if (state is MutualListLoaded) {
              final data = state.userProfile;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    if (data.isNotEmpty) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.all(10),
                        elevation: 5.0,
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UserProfileBottomSheet(data: data[index],userid: user.uid ?? '',isMyPick: false),
                            ));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: AppTheme.green,
                          title: Text("${data[index]['name']}",
                              style: const TextStyle(
                                  color: AppTheme.black26,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold)),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(data[index]['photoUrl']),
                          ),
                        ),
                      );
                    }
                    return const Center(child: Text("No picks by others"));
                  });
            }
            if (state is MutualListLoadError) {
              return const EmptyListPage(text: 'No mutual Picks');
            }
            return const SizedBox();
          },
        ));
  }
}
