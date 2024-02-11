import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/theme.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ageListTile(context),
          _pushNotifications(),
          _themeListTile("Dark Theme", darkThemeEnabled, (value) {
            setState(() {
              darkThemeEnabled = value;
            });
            BlocProvider.of<ThemeBloc>(context).add(ThemeSwitchEvent());
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
            "Notifications",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        _notificationListTile("Likes", enableLikesNotification, (value) {
          setState(() {
            enableLikesNotification = value;
          });
          setLikesOn(value);
          BlocProvider.of<FirebaseDataBloc>(context)
              .add(UpdateUserFieldEvent('notifications_likes', value));
        }),
        _notificationListTile("Picks", enablePicksNotification, (value) async {
          setState(() {
            enablePicksNotification = value;
          });
          setPicksOn(value);
          BlocProvider.of<FirebaseDataBloc>(context).add(
              UpdateUserFieldEvent('notifications_picks', await isPicksOn()));
        }), //notifications_picks
        _notificationListTile("Messages", enableMessagesNotification,
            (value) async {
          setState(() {
            enableMessagesNotification = value;
          });
          setMessages(value);
          BlocProvider.of<FirebaseDataBloc>(context).add(UpdateUserFieldEvent(
              'notifications_messages', await isMessagesOn()));
        }),
        _notificationListTile(
            "Recommendations", enableRecommendationsNotification,
            (value) async {
          setState(() {
            enableRecommendationsNotification = value;
          });
          setRecommendations(value);
          BlocProvider.of<FirebaseDataBloc>(context).add(UpdateUserFieldEvent(
              'notifications_recomendations', await isRecomendations()));
        }),
      ],
    );
  }

  Widget _ageListTile(BuildContext context) {
    return BlocBuilder<FirebaseDataBloc, FirebaseDataState>(
      builder: (context, state) {
        if (state is FirebaseDataLoaded) {
          final minAge = state.data?.minAge;
          final maxAge = state.data?.maxAge;

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
                  ageTextbox(minAge.toString()),
                  const SizedBox(
                    width: 10,
                  ),
                  ageTextbox(maxAge.toString()),
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
          (text != "null") ? text : '',
          style: const TextStyle(
            color: AppTheme.kPrimary,
            fontSize: 18,
          ),
        ),
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
                onChanged: onChanged,
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