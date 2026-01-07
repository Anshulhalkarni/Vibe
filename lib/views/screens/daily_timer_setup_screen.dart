import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class DailyTimerSetupScreen extends StatefulWidget {
  const DailyTimerSetupScreen({Key? key}) : super(key: key);

  @override
  State<DailyTimerSetupScreen> createState() => _DailyTimerSetupScreenState();
}

class _DailyTimerSetupScreenState extends State<DailyTimerSetupScreen> {
  double _minutes = 30.0;

  Future<void> _saveTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await prefs.setString('lastTimerDate', today);
    await prefs.setInt('dailyLimitMinutes', _minutes.toInt());

    Get.offAll(() => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Set Today's Screen Time"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "How many minutes do you want to use Vibe today?",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            Slider(
              value: _minutes,
              min: 10,
              max: 120,
              divisions: 11,
              label: "${_minutes.toInt()} minutes",
              onChanged: (value) {
                setState(() => _minutes = value);
              },
            ),

            const SizedBox(height: 20),
            Text(
              "${_minutes.toInt()} minutes",
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveTimer,
              child: Text("Start Vibe (${_minutes.toInt()} min)"),
            )
          ],
        ),
      ),
    );
  }
}
