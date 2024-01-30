import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/domain/bloc/matches_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/presentation/homepage/progfilepage.dart';

class WhoPicksMePag extends StatelessWidget {
  final UserModel user;

  const WhoPicksMePag({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MatchesDataBloc>(context).add(SelectedListLoadingEvent());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Who Picks ME"),
        ),
        body: BlocBuilder<MatchesDataBloc, MatchesDataState>(
          builder: (context, state) {
            if (state is SelectedListLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.red,
                  strokeWidth: 5.0,
                ),
              );
            }
            if (state is SelectedListLoaded) {
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
                                  UserProfileBottomSheet(data: data[index]),
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
                            onPressed: () {},
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
            return const SizedBox();
          },
        ));
  }
}
