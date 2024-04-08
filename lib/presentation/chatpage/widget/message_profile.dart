import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/lovepercantage.dart';

class MessageProfilePage extends StatelessWidget {
  final Map<String, dynamic> userDataA, userDataB;

  const MessageProfilePage(
      {super.key, required this.userDataA, required this.userDataB});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(userDataB['photoUrl']),
            radius: 50,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '${userDataB['name']}',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Column(
                    children: [
                      const Icon(
                        EvaIcons.personOutline,
                        size: 40,
                      ),
                      Text(
                        "Profile",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Column(
                    children: [
                      const Icon(
                        EvaIcons.bellOutline,
                        size: 40,
                      ),
                      Text(
                        "Mute",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Column(
                    children: [
                      const Icon(
                        EvaIcons.alertTriangleOutline,
                        size: 40,
                      ),
                      Text(
                        "Block User",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ))
            ],
          ),
          const Divider(),
          // Expanded(
          //   child: FutureBuilder(
          //     future: ProfileFunctions.showImages(
          //         userDataA['uid'], userDataB['uid']),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         if (snapshot.data != null && snapshot.data!.isEmpty) {
          //           return GridView.builder(
          //             itemCount: snapshot.data?.length,
          //             gridDelegate:
          //                 const SliverGridDelegateWithFixedCrossAxisCount(
          //                     crossAxisCount: 2, crossAxisSpacing: 1.0),
          //             itemBuilder: (context, index) =>
          //                 Image.network(snapshot.data![index]),
          //           );
          //         }
          //         return const Center(
          //           child: Text("No data found"),
          //         );
          //       }
          //       return SizedBox();
          //     },
          //   ),
          // )
          const LovePercentageWidget(percentage: 10.2,)
        ],
      ),
    );
  }
}
