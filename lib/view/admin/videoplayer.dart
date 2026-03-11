import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class AdminVideoPlayer extends StatefulWidget {
  final List<String> urls;

  const AdminVideoPlayer({super.key, required this.urls});

  @override
  State<AdminVideoPlayer> createState() => _AdminVideoPlayerState();
}

class _AdminVideoPlayerState extends State<AdminVideoPlayer> {
  late BetterPlayerController _controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.urls[currentIndex]);
  }

  void _initializePlayer(String url) {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
    );

    _controller = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: true,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );

    _controller.addEventsListener((event) {
      if (event.betterPlayerEventType ==
          BetterPlayerEventType.finished) {
        _playNext();
      }
    });
  }

  void _playNext() {
    if (currentIndex < widget.urls.length - 1) {
      currentIndex++;
      _controller.setupDataSource(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.urls[currentIndex],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.urls.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "No Videos Available",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: BetterPlayer(controller: _controller),
      ),
    );
  }
}
