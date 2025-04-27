import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/hydration_bar.dart';
import 'progress.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double currentIntake = 0.0;
  final double bottleCapacity = 1.0; // Max for one refill in Liters
  final double dailyGoal = 3.0;      // Daily target in Liters
  double lastVolume = 0.0;           // Stores the last known water volume
  String status = "Fetching...";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchWaterLevel();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchWaterLevel());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchWaterLevel() async {
    const String apiUrl = 'http://10.0.2.2:8000/api/get-distance/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        bool isStable = data['is_stable'] ?? false;

        if (isStable) {
          double volumeML = data['volume_ml'];
          double currentVolume = volumeML / 1000.0; // Convert to Liters
          double rawDistance = data['distance_cm'];

          if (lastVolume != 0.0 && currentVolume < lastVolume) {
            // User drank some water
            double delta = (lastVolume - currentVolume);
            currentIntake += delta;
            currentIntake = currentIntake.clamp(0.0, dailyGoal);
          }

          setState(() {
            lastVolume = currentVolume;
            status = "Stable water level updated.";
          });

          print("📥 Distance: ${rawDistance.toStringAsFixed(2)} cm");
          print("💧 Remaining in bottle: ${currentVolume.toStringAsFixed(2)} L");
          print("✅ Total intake: ${currentIntake.toStringAsFixed(2)} L");
        } else {
          setState(() => status = "Waiting for stable reading...");
        }
      } else {
        setState(() => status = "Server error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => status = "Failed to fetch: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Visual representation only for 1L capacity
    double progressPercent = (1.0 - lastVolume / bottleCapacity).clamp(0.0, 1.0);


    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Smart Bottle Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(status, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            // 🥤 Goal Info
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.local_drink, size: 40, color: Colors.blueAccent),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
"Goal: ${dailyGoal.toStringAsFixed(1)} Litres\nTotal Intake: ${currentIntake.toStringAsFixed(2)} L\nCurrent Bottle: ${lastVolume.clamp(0.0, bottleCapacity).toStringAsFixed(2)} L",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // 💧 Hydration bar (1L max)
            HydrationBar(
              currentValue: currentIntake % bottleCapacity,
              goalValue: bottleCapacity,
            ),

            SizedBox(height: 20),

            // 🌀 Circular progress bar (1L max)
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: progressPercent.clamp(0.0, 1.0),
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(progressPercent * 100).toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${(bottleCapacity - lastVolume).clamp(0.0, 1.0).toStringAsFixed(2)} L / 1.0 L",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),

            // ➡️ Navigate to progress screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProgressScreen()),
                );
              },
              child: Text("Next"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                backgroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
