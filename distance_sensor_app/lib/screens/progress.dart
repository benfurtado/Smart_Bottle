import 'package:flutter/material.dart';
import '../widgets/graph_widget.dart';
import 'water_log_screen.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isWeekly = true; // Toggle between weekly & monthly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Hydration Progress"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Toggle Option (Weekly / Monthly) with underline
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

            // ✅ Graph Widget
            GraphWidget(isWeekly: isWeekly),

            SizedBox(height: 20),

            // ✅ Water Log Summary
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
              ),
              child: Column(
                children: [
                  _summaryRow("Total Water Intake", "18L"),
                  Divider(),
                  _summaryRow("Average Daily Intake", "2.5L"),
                  Divider(),
                  _summaryRow("Best Hydrated Day", "Wednesday - 3.2L"),
                ],
              ),
            ),

            Spacer(),

            // ✅ Navigation Button to Water Log
            Align(
              alignment: Alignment.bottomRight,
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
    );
  }

  // ✅ Helper function for summary rows
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
