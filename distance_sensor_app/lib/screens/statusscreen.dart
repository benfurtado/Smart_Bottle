import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  final double currentIntake;
  final double goalIntake;

  StatusScreen({required this.currentIntake, required this.goalIntake});

  String generateRemark() {
    double percentage = (currentIntake / goalIntake) * 100;

    if (percentage >= 100) {
      return "Excellent! 🎉 You've achieved your water intake goal for today!";
    } else if (percentage >= 70) {
      return "Great Job! 💪 You're almost there, keep sipping!";
    } else if (percentage >= 40) {
      return "Keep Going! 🚀 Hydration is important, drink some more.";
    } else {
      return "Uh oh! 😟 You need to drink more water to stay healthy!";
    }
  }

  String motivationalQuote() {
    return "\"Water is life’s matter and matrix, mother and medium. Stay Hydrated! 💧\"";
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (currentIntake / goalIntake) * 100;
    String remark = generateRemark();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[300]!, Colors.blue[800]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Today's Status",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),

                // Circular Percentage
                Container(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: percentage / 100,
                        strokeWidth: 15,
                        backgroundColor: Colors.white24,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${percentage.toStringAsFixed(1)}%",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${currentIntake} L / ${goalIntake} L",
                            style: TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Remark Box
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  child: Text(
                    remark,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 30),

                // Motivational Quote
                Text(
                  motivationalQuote(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),

                Spacer(),

                // Go Back Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text("Back to Dashboard"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
