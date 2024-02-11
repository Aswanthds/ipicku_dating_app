import 'package:flutter/material.dart';

import 'package:ipicku_dating_app/presentation/recommended/widgets/recomended_card.dart';

class SectionRecommendedPage extends StatelessWidget {
  final List<Map<String, dynamic>> state;
  final String title, id;
  const SectionRecommendedPage({
    Key? key,
    required this.state,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: (state.isNotEmpty)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title,
                        style: Theme.of(context).textTheme.displayMedium),
                  ),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      itemCount: state.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final data = state[index];
                        return RecommendedCard(
                          data: data,
                          id: id,
                        );
                      },
                    ),
                  ),
                ],
              )
            : const SizedBox());
  }
}
