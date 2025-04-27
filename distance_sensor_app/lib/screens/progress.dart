import 'package:flutter/material.dart';
import '../widgets/graph_widget.dart';
import 'water_log_screen.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isWeekly = true; // Toggle between weekly & monthly

  // Example/mock data for demonstration
  List<double> weeklyIntake = [2.0, 2.5, 3.0, 2.8, 2.2, 2.4, 2.7];
  List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<double> monthlyIntake = [10, 12, 15, 14];
  List<String> monthLabels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
  double totalIntake = 18.0;
  double dailyGoal = 3.0;
  double bestDayIntake = 3.2;
  String bestDay = 'Wednesday';

  @override
  Widget build(BuildContext context) {
    double avgDaily = isWeekly
        ? (weeklyIntake.reduce((a, b) => a + b) / weeklyIntake.length)
        : (monthlyIntake.reduce((a, b) => a + b) / monthlyIntake.length);
    double goalCompletion = totalIntake / (dailyGoal * (isWeekly ? 7 : 30));

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Hydration Progress"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(   // 👈 wrap with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle Option (Weekly / Monthly) with underline
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isWeekly = true;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Weekly",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isWeekly ? FontWeight.bold : FontWeight.normal,
                            color: isWeekly ? Colors.blue : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        if (isWeekly)
                          Container(
                            height: 2,
                            width: 60,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isWeekly = false;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Monthly",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: !isWeekly ? FontWeight.bold : FontWeight.normal,
                            color: !isWeekly ? Colors.blue : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        if (!isWeekly)
                          Container(
                            height: 2,
                            width: 70,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Bar Chart
              GraphWidget(
                graphType: GraphType.bar,
                data: isWeekly ? weeklyIntake : monthlyIntake,
                labels: isWeekly ? weekDays : monthLabels,
                title: isWeekly ? 'Daily Intake (L)' : 'Weekly Intake (L)',
                color: Colors.blueAccent,
              ),

              SizedBox(height: 20),

              // Pie Chart
              GraphWidget(
                graphType: GraphType.pie,
                data: [totalIntake, (dailyGoal * (isWeekly ? 7 : 30)) - totalIntake],
                labels: ['Consumed', 'Remaining'],
                title: 'Goal Completion',
                color: Colors.green,
              ),

              SizedBox(height: 20),

              // Water Log Summary
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                ),
                child: Column(
                  children: [
                    _summaryRow("Total Water Intake", "${totalIntake.toStringAsFixed(1)}L"),
                    Divider(),
                    _summaryRow("Average Daily Intake", "${avgDaily.toStringAsFixed(2)}L"),
                    Divider(),
                    _summaryRow("Best Hydrated Day", "$bestDay - ${bestDayIntake.toStringAsFixed(1)}L"),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Navigation Button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WaterLogScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("View Log", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for summary rows
  Widget _summaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
      ],
    );
  }
}
