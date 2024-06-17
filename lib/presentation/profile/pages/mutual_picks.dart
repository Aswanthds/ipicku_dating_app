import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_list.dart';

class MutualPicks extends StatelessWidget {
  const MutualPicks({
    super.key,
  });

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
                          onTap: () async {
                            final id = await UserRepository().getUser();
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              
                              return UserProfileBottomSheet(
                                  data: data[index],
                                  userid: id,
                                  isMyPick: false);
                            }));
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
                            backgroundImage: CachedNetworkImageProvider(
                                data[index]['photoUrl']),
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
