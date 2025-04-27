import 'package:flutter/material.dart';
import '../widgets/bottom_nav_screen.dart';

class WaterLogScreen extends StatelessWidget {
  final List<Map<String, String>> waterLogs = [
    {"date": "March 9, 2025", "time": "10:00 AM", "amount": "250ml"},
    {"date": "March 9, 2025", "time": "12:30 PM", "amount": "500ml"},
    {"date": "March 9, 2025", "time": "3:00 PM", "amount": "350ml"},
    {"date": "March 9, 2025", "time": "6:00 PM", "amount": "300ml"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Light Sky Blue Background
      appBar: AppBar(
        title: Text(
          "Water Consumption Log",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue, // Sky Blue Header
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Show SnackBar on logout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out successfully!'),
                  backgroundColor: Colors.lightBlue,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );

              // Delay for the Snackbar to show
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pushReplacementNamed(context, '/login'); // Replace with your login route
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Water Intake History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: waterLogs.length,
                itemBuilder: (context, index) {
                  final log = waterLogs[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: Offset(3, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      title: Text(
                        "${log['date']} - ${log['time']}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        "💧 ${log['amount']}",
                        style: TextStyle(fontSize: 14, color: Colors.blue[800]),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.lightBlue[100],
                        child: Icon(Icons.local_drink, color: Colors.blue[700]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to Add New Entry (Can be linked to an input form or sensor call)
        },
        tooltip: "Add Water Log",
        elevation: 6,
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
