import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/constants.dart';

class VideoChatPage extends StatelessWidget {
  const VideoChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey900,
      appBar: AppBar(
        title: const Text('Video Chat'),
        iconTheme: const IconThemeData(color: AppTheme.white),
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.grey900,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Video stream placeholder (replace with actual video stream widget)
            Container(
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 130,
              margin: const EdgeInsets.all(12),
              color: AppTheme.black,
              child: const Center(
                child: Text(
                  'User Video', // Replace with actual video stream
                  style: TextStyle(color: AppTheme.white),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 100,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    IconButton.filled(
                        style: IconButton.styleFrom(
                            backgroundColor: AppTheme.white),
                        onPressed: () {
                          // Implement end call logic
                        },
                        icon: const Icon(
                          Icons.call_end_rounded,
                          color: AppTheme.red,
                          size: 40,
                        )),
                    const SizedBox(width: 16),
                    IconButton(
                        onPressed: () {
                          // Implement mute microphone logic
                        },
                        icon: const Icon(Icons.mic_rounded,
                            color: AppTheme.white, size: 40)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*

Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      // Implement end call logic
                    },
                    icon: Icon(Icons.call_end_rounded)),
                SizedBox(width: 16),
                IconButton(
                    onPressed: () {
                      // Implement mute microphone logic
                    },
                    icon: Icon(Icons.mic_rounded)),
              ],
            ),

            */