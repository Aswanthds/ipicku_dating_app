import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recommended Profiles'),
        ),
        body: ListView(
          children: [
            buildSection('Interests', _buildInterestProfiles()),
            buildSection('Age 20 - 30', _buildAgeGroup2030Profiles()),
            buildSection('Region', _buildNewYorkProfiles()),
          ],
        ));
  }

  List<Widget> _buildInterestProfiles() {
    // Placeholder for interest-based profiles
    return [
      _buildProfileCard(
          'John',
          'Music, Travel',
          'https://i.pinimg.com/236x/be/b0/fc/beb0fcdf7cf7db7a539f53e0bf6a5c4e.jpg',
          'Interests '),
      _buildProfileCard(
          'Alice',
          'Hiking, Photography',
          'https://i.pinimg.com/736x/ec/a0/bb/eca0bb5f24b99b24e7f186a3d9948813.jpg',
          'Interests '),
      _buildProfileCard(
          'Emma',
          'Movies, Reading',
          'https://i.pinimg.com/236x/32/7f/35/327f35c84fe893c6be1efce8aa8930ee.jpg',
          'Interests '),
    ];
  }

  List<Widget> _buildAgeGroup2030Profiles() {
    // Placeholder for age group 20-30 profiles
    return [
      _buildProfileCard(
          'Michael',
          ' 25',
          'https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg',
          'Age '),
      _buildProfileCard(
          'Sophia',
          ' 28',
          'https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg',
          'Age '),
      _buildProfileCard(
          'Ethan',
          ' 22',
          'https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg',
          'Age '),
      // Add more profiles for age group 20-30
    ];
  }

  List<Widget> _buildNewYorkProfiles() {
    // Placeholder for profiles from New York region
    return [
      _buildProfileCard(
          'Olivia',
          'New York',
          'https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg',
          'Location '),
      _buildProfileCard(
          'William',
          'New York',
          'https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg',
          'Location '),
      _buildProfileCard(
          'Ava',
          'New York',
          'https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg',
          'Location '),
      _buildProfileCard(
          'Ava',
          'New York',
          'https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg',
          'Location '),
      _buildProfileCard(
          'Ava',
          'New York',
          'https://i.pinimg.com/236x/7f/30/bc/7f30bce838ae79bc1f85e8fd0717f1c7.jpg',
          'Location '),
      // Add more profiles from New York
    ];
  }

  Widget _buildProfileCard(
      String name, String description, String imagePath, String title) {
    return Card(
      elevation: 10,
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
                gradient: whiteFade,
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
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "$title :",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                            TextSpan(
                              text: description,
                              style: const TextStyle(color: Colors.black54),
                            )
                          ]),
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
            ))
      ],
    );
  }
}
