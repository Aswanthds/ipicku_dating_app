import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/domain/theme/theme_bloc.dart';
import 'package:ipicku_dating_app/domain/theme/theme_event.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/age_pref_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool hideFromDiscovery = true;
  bool enableLikesNotification = true;
  bool enablePicksNotification = true;
  bool enableMessagesNotification = true;
  bool enableRecommendationsNotification = true;
  bool darkThemeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _enableListTile("Hide me from discovery", hideFromDiscovery, (value) {
            setState(() {
              hideFromDiscovery = value;
              // Perform actions based on the switch state
            });
          }),
          _ageListTile(context),
          _pushNotifications(),
          _themeListTile("Dark Theme", darkThemeEnabled, (value) {
            setState(() {
              darkThemeEnabled = value;
              // Perform actions based on the switch state
            });
          }),
        ],
      ),
    );
  }

  Column _pushNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 10,
          ),
          child: Text(
            "Push Notifications",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        _notificationListTile("Likes", enableLikesNotification, (value) {
          setState(() {
            enableLikesNotification = value;
            // Perform actions based on the switch state
          });
        }),
        _notificationListTile("Picks", enablePicksNotification, (value) {
          setState(() {
            enablePicksNotification = value;
            // Perform actions based on the switch state
          });
        }),
        _notificationListTile("Messages", enableMessagesNotification, (value) {
          setState(() {
            enableMessagesNotification = value;
            // Perform actions based on the switch state
          });
        }),
        _notificationListTile(
            "Recommendations", enableRecommendationsNotification, (value) {
          setState(() {
            enableRecommendationsNotification = value;
            // Perform actions based on the switch state
          });
        }),
      ],
    );
  }

  Widget _ageListTile(BuildContext context) {
    return BlocBuilder<FirebaseDataBloc, FirebaseDataState>(
      builder: (context, state) {
        if (state is FirebaseDataLoaded) {
          return ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => const AgeSelectionWidget(),
              );
            },
            title: Text(
              "Age Preference",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            trailing: SizedBox(
              width: 150,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  ageTextbox(state.data!.minAge.toString()),
                  const SizedBox(
                    width: 10,
                  ),
                  ageTextbox(state.data!.maxAge.toString()),
                ],
              ),
            ),
          );
        }
        if (state is FirebaseDataLoading) {
          return const SizedBox(
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
          );
        }
        return const SizedBox();
      },
    );
  }

  Container ageTextbox(String text) {
    return Container(
      width: 60,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffd9d9d9),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: AppTheme.kPrimary,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  ListTile _enableListTile(
      String text, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.displaySmall,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        splashRadius: 1.5,
        activeColor: AppTheme.black,
        activeTrackColor: AppTheme.secondaryColor,
      ),
    );
  }

  ListTile _notificationListTile(
      String text, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.displaySmall,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        splashRadius: 1.5,
        activeColor: AppTheme.black,
        activeTrackColor: AppTheme.secondaryColor,
      ),
    );
  }

  Widget _themeListTile(String text, bool value, ValueChanged<bool> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 10,
          ),
          child: Text(
            "Theme",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        ListTile(
          title: Text(
            text,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          trailing: BlocBuilder<ThemeBloc, ThemeData>(
            builder: (context, state) {
              return Switch(
                value: state == ThemeData.dark(),
                onChanged: (bool val) {
                  BlocProvider.of<ThemeBloc>(context).add(ThemeSwitchEvent());
                },
                splashRadius: 1.5,
                activeColor: AppTheme.white,
                activeTrackColor: AppTheme.kPrimary,
              );
            },
          ),
        ),
      ],
    );
  }
}



/*
 const Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              top: 10,
            ),
            child: Text(
              "Push Notifications",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),


*/