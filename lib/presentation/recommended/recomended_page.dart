import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Profiles'),
      ),
      body: ListView(
        children: [
          buildSection('Age 20 - 30', _buildAgeGroup2030Profiles()),
        ],
      ),
    );
  }

  List<Widget> _buildAgeGroup2030Profiles() {
    return [
      _buildProfileCard(
        'Drishya',
        '23',
        'https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg',
        'Age',
      ),
      _buildProfileCard(
        'Arya',
        ' 25',
        'https://i.pinimg.com/236x/3a/a4/09/3aa4097d7709bfb26b169eb82e457c52.jpg',
        'Age',
      ),
      _buildProfileCard(
        'Aishwarya',
        ' 22',
        'https://i.pinimg.com/236x/87/8e/e9/878ee9986c7c5d8625edb1197a26a1fd.jpg',
        'Age',
      ),
      _buildProfileCard(
        'Arpitha',
        '26',
        'https://i.pinimg.com/236x/1e/ae/7f/1eae7f5954ba954362bf482b7eae430c.jpg',
        'Age',
      ),
      _buildProfileCard(
        'Priya',
        '28',
        'https://i.pinimg.com/236x/9c/c1/6f/9cc16fc7fcc9beaca9b4d9ac4246e6e5.jpg',
        'Age',
      ),
      _buildProfileCard(
        'Srividya',
        '25',
        'https://i.pinimg.com/236x/43/54/db/4354dbcd90e8b1851d82c7838f9399ca.jpg',
        'Age',
      ),
    ];
  }

  Widget _buildProfileCard(
      String name, String description, String imagePath, String title) {
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
                gradient: blackFade,
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
                        color: Colors.white,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "$title :",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: description,
                            style: const TextStyle(color: Colors.white),
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

  Widget buildSection(String s, List<Widget> buildInterestProfiles) {
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: buildInterestProfiles.length,
            itemBuilder: (context, index) => buildInterestProfiles[index],
          ),
        ),
      ],
    );
  }
}
