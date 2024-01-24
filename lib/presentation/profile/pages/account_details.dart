import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/model/user.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/preferences_section.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_card.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/user_details_widget.dart';

class AccountDetails extends StatelessWidget {
  final UserModel state;
  final UserRepository userRepository;
  const AccountDetails({
    Key? key,
    required this.state,
    required this.userRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: BlocListener<FirebaseDataBloc, FirebaseDataState>(
        listener: (context, state) {
          if (state is FirebaseDataLoading) {
            ScaffoldMessenger.of(context)
              ..hideCurrentMaterialBanner()
              ..showSnackBar(SnackBarConstants.profileSuccessSnackBar);
          }
        },
        child: BlocBuilder<FirebaseDataBloc, FirebaseDataState>(
          builder: (context, state) {
            if (state is FirebaseDataLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              );
            }
            if (state is FirebaseDataLoaded) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //const SizedBox(height: 10),
                      ProfileCardWidget(
                          path: state.data?.photoPath ?? '',
                          age: state.data?.age.toString() ?? '',
                          id: state.data!.uid!
                              .substring(state.data!.uid!.length - 5),
                          name: state.data?.name ?? ''),
                      UserDetailsList(user: state.data),
                      const SizedBox(height: 20),
                      PreferencesSection(
                          model: state.data, repo: userRepository),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
