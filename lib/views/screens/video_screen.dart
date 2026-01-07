import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/controllers/video_controller.dart';
import 'package:tiktok_tutorial/views/screens/comment_screen.dart';
import 'package:tiktok_tutorial/views/widgets/circle_animation.dart';
import 'package:tiktok_tutorial/views/widgets/video_player_iten.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final VideoController videoController = Get.put(VideoController());

  // Timer variables
  int _watchSeconds = 0;
  int _limitSeconds = 0;
  bool _timerCompleted = false;
  Timer? _watchTimer;

  bool _boringMode = false;

  @override
  void initState() {
    super.initState();
    _loadLimitAndStartTimer();
  }

  // 🔥 AI-like randomized nudge generator
  String generateDynamicNudge(int level) {
    final List<String> nudge1 = [
      "You've used your planned time. Want to refresh your mind?",
      "Time’s up! A short break can boost your focus.",
      "You've reached your limit. Take a moment to breathe?",
      "Your brain needs rest too. Maybe pause for a bit?",
    ];

    final List<String> nudge2 = [
      "Still scrolling? A short break will help you reset.",
      "You skipped the first reminder — try stepping away briefly.",
      "Your attention is valuable. Protect it with a pause.",
      "Deep breaths. Time to relax your mind for a moment.",
    ];

    final List<String> nudge3 = [
      "You've ignored all nudges. Switching to calmer content now.",
      "Alright, that's enough — shifting to low-dopamine mode.",
      "Your mental energy matters. Redirecting your recommendations.",
      "Final reminder reached. Adjusting your feed now.",
    ];

    if (level == 1) return (nudge1..shuffle()).first;
    if (level == 2) return (nudge2..shuffle()).first;
    return (nudge3..shuffle()).first;
  }

  Future<void> _loadLimitAndStartTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final minutes = prefs.getInt('dailyLimitMinutes') ?? 30;

    _limitSeconds = 10; // For testing purpose (change later)

    _watchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCompleted) return;

      _watchSeconds++;

      if (_watchSeconds >= _limitSeconds) {
        _timerCompleted = true;
        _watchTimer?.cancel();
        _showFirstNudge();
      }
    });
  }

  // 🔥 FIRST NUDGE
  void _showFirstNudge() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "⏳ Time’s Up",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            generateDynamicNudge(1),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _scheduleSecondNudge();
              },
              child: const Text("Dismiss", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // 🔥 SECOND NUDGE (after delay)
  void _scheduleSecondNudge() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) _showSecondNudge();
    });
  }

  void _showSecondNudge() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "⚠️ Still Watching?",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            generateDynamicNudge(2),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _scheduleThirdNudge();
              },
              child: const Text("Dismiss", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // 🔥 THIRD NUDGE
  void _scheduleThirdNudge() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) _showThirdNudge();
    });
  }

  void _showThirdNudge() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "🚨 Final Reminder",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            generateDynamicNudge(3),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _activateBoringMode();
              },
              child:
                  const Text("Continue", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // 🔥 Activate low-dopamine mode
  void _activateBoringMode() {
    setState(() {
      _boringMode = true;
    });

    Get.snackbar(
      "Low-Dopamine Mode Activated",
      "Your content feed has been adjusted.",
      backgroundColor: Colors.black,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    _watchTimer?.cancel();
    super.dispose();
  }

  // UI Widgets
  Widget buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.grey, Colors.white],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];

            return Stack(
              children: [
                VideoPlayerItem(videoUrl: data.videoUrl),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    data.username,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    data.caption,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.music_note,
                                          size: 15, color: Colors.white),
                                      Text(
                                        data.songName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: size.height / 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfile(data.profilePhoto),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          videoController.likeVideo(data.id),
                                      child: Icon(
                                        Icons.favorite,
                                        size: 40,
                                        color: data.likes.contains(
                                                authController.user.uid)
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.likes.length.toString(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CommentScreen(id: data.id),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.comment,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.commentCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.reply,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.shareCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ),
                                CircleAnimation(
                                  child: buildMusicAlbum(data.profilePhoto),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
