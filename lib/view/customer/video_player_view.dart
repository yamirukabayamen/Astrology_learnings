import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerView extends StatefulWidget {
  final List<String> urls;
  final int startIndex;

  const VideoPlayerView({
    super.key,
    required this.urls,
    required this.startIndex,
  });

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late BetterPlayerController _controller;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.startIndex;
    _initializePlayer(widget.urls[currentIndex]);
  }

  void _initializePlayer(String url) {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
    );

    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        fit: BoxFit.contain,
        aspectRatio: 16 / 9,
        allowedScreenSleep: false,
        handleLifecycle: true,
        eventListener: (event) {
          if (event.betterPlayerEventType ==
              BetterPlayerEventType.finished) {
            _playNext();
          }
        },
      ),
      betterPlayerDataSource: dataSource,
    );
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
    } else {
      // Optional: close player when finished
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: BetterPlayer(controller: _controller),
        ),
      ),
    );
  }
}

// class _VideoPlayerViewState extends State<VideoPlayerView> {
//
//   late BetterPlayerController _betterPlayerController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     debugPrint("🎬 Playing URL: ${widget.url}");
//
//     /// Data source
//     BetterPlayerDataSource dataSource = BetterPlayerDataSource(
//       BetterPlayerDataSourceType.network,
//       widget.url,
//       cacheConfiguration: const BetterPlayerCacheConfiguration(
//         useCache: true,
//         maxCacheSize: 200 * 1024 * 1024,
//         maxCacheFileSize: 50 * 1024 * 1024,
//       ),
//     );
//
//     /// Player configuration
//     _betterPlayerController = BetterPlayerController(
//       const BetterPlayerConfiguration(
//         autoPlay: true,
//         looping: false,
//         fit: BoxFit.contain,
//         aspectRatio: 16 / 9,
//         allowedScreenSleep: false,
//         handleLifecycle: true,
//         fullScreenByDefault: false,
//         autoDetectFullscreenDeviceOrientation: true,
//         controlsConfiguration: BetterPlayerControlsConfiguration(
//           enablePlayPause: true,
//           enableMute: true,
//           enableFullscreen: true,
//           enableProgressBar: true,
//           enableSkips: true,
//           enableProgressText: true,
//           enablePlaybackSpeed: true,
//         ),
//       ),
//       betterPlayerDataSource: dataSource,
//     );
//   }
//
//   @override
//   void dispose() {
//     _betterPlayerController.dispose();
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Center(
//           child: BetterPlayer(controller: _betterPlayerController),
//         ),
//       ),
//     );
//   }
// }
