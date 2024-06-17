import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';
import 'package:ipicku_dating_app/domain/theme/theme_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class EmptyPageGif extends StatefulWidget {
  final String text;
  const EmptyPageGif({
    super.key,
    required this.text,
  });

  @override
  State<EmptyPageGif> createState() => _EmptyPageGifState();
}

class _EmptyPageGifState extends State<EmptyPageGif>
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
              if (state == AppTheme.darkTheme) {
                return Gif(
                    controller: controller,
                    image: const AssetImage(
                      "assets/images/gif4.gif",
                    ),
                    height: 150,
                    autostart: Autostart.loop,
                    fps: 30,
                   
                    placeholder: (context) => const Text(
                        "Loading...."
                        ));
              } else {
                return Gif(
                    controller: controller,
                    image: const AssetImage(
                      "assets/images/gif3.gif",
                    ),
                    height: 150,
                    autostart: Autostart.loop,
                    fps: 30,
                    placeholder: (context) => const Text("Loading..."));
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
