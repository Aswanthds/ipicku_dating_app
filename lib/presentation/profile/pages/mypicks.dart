import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/domain/matches_data_bloc/matches_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/dialog_manager.dart';
import 'package:ipicku_dating_app/presentation/widgets/empty_list.dart';

class MyPicksPage extends StatelessWidget {
  const MyPicksPage({Key? key}) : super(key: key);
  static const route = '/picks';
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MatchesDataBloc>(context).add(MatchesLoadingEvent());
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Picks"),
        ),
        body: BlocBuilder<MatchesDataBloc, MatchesDataState>(
          builder: (context, state) {
            if (state is MatchesListLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.red,
                  strokeWidth: 5.0,
                ),
              );
            }
            if (state is MatchesListLoaded) {
              final data = state.userProfile;
              if (data.isNotEmpty) {
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
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserProfileBottomSheet(
                                  data: data[index],
                                  userid: id,
                                  isMyPick: true,
                                ),
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
                            subtitle: Text(
                                DateFormat('dd MMM yy').format(
                                  (data[index]['timestamp'] as Timestamp)
                                      .toDate(),
                                ),
                                style: const TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data[index]['photoUrl']),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                DialogManager.showdeletePickDialog(
                                    context: context, data: data[index]);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        );
                      }

                      return const Center(child: Text("No picks by others"));
                    });
              }
              return const EmptyListPage(
                text: 'No picks from you',
              );
            }
            if (state is MatchesListLoadError) {
              return const EmptyListPage(
                text: 'No picks from you',
              );
            }
            return const SizedBox();
          },
        ));
  }
}
