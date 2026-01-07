import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'daily_timer_setup_screen.dart';
import 'home_screen.dart';

class TimerGate extends StatefulWidget {
  const TimerGate({Key? key}) : super(key: key);

  @override
  State<TimerGate> createState() => _TimerGateState();
}

class _TimerGateState extends State<TimerGate> {
  @override
  void initState() {
    super.initState();
    _checkDailyTimer();
  }

  Future<void> _checkDailyTimer() async {
  final prefs = await SharedPreferences.getInstance();

  // 🔥 FORCE RESET for testing
  await prefs.remove('lastTimerDate');

  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final lastTimerDate = prefs.getString('lastTimerDate');

  if (lastTimerDate == today) {
    Get.offAll(() => const HomeScreen());
  } else {
    Get.offAll(() => const DailyTimerSetupScreen());
  }
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
