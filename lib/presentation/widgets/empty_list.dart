import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';
import 'package:ipicku_dating_app/domain/theme/theme_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class EmptyListPage extends StatefulWidget {
  final String text;
  const EmptyListPage({
    super.key,
    required this.text,
  });

  @override
  State<EmptyListPage> createState() => _EmptyListPageState();
}

class _EmptyListPageState extends State<EmptyListPage>
    with TickerProviderStateMixin {
  late GifController controller;
  @override
  void initState() {
    controller = GifController(
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<ThemeBloc, ThemeData>(
            builder: (context, state) {
              if( state == AppTheme.darkTheme){
                return Gif(
                  controller: controller,
                  image: const AssetImage(
                    "assets/images/gif1.gif",
                  ),
                  height: 150,
                  autostart: Autostart.loop,
                  fps: 30,
                  placeholder: (context) => AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Loading...",
                            textStyle:
                                Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                        totalRepeatCount: 4,
                        pause: const Duration(milliseconds: 1000),
                      ));
              }else{
                return Gif(
                    controller: controller,
                    image: const AssetImage(
                      "assets/images/gif2.gif",
                    ),
                    height: 150,
                    autostart: Autostart.loop,
                    fps: 30,
                    placeholder: (context) => AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              "Loading...",
                              textStyle:
                                  Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                          totalRepeatCount: 4,
                          pause: const Duration(milliseconds: 1000),
                        ));
              }
            },
          ),
          Text(
            widget.text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
