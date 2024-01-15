import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/preferences_section.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/profile_card.dart';
import 'package:ipicku_dating_app/presentation/profile/widgets/user_details_widget.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              ProfileCardWidget(),
              UserDetailsList(),
              SizedBox(height: 20),
              PreferencesSection(),
            ],
          ),
        ),
      ),
    );
  }
}
