import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Reminder'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Next: 06:00 AM (5 h 56 min left)', style: TextStyle(fontSize: 16)),
              Switch(value: true, onChanged: (val) {})
            ],
          ),
          SizedBox(height: 20),
          Text('Reminder Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ListTile(
            title: Text('Standard'),
            trailing: Icon(Icons.edit),
            onTap: () {},
          ),
          SizedBox(height: 10),
          _reminderTile('After Wake-up', '06:00 AM', true),
          _reminderTile('Before Breakfast', '06:50 AM', true),
          _reminderTile('After Breakfast', '08:00 AM', true),
          _reminderTile('Before Lunch', '10:00 AM', true),
          _reminderTile('After Lunch', '12:00 PM', true),
          _reminderTile('Before Dinner', '08:00 PM', true),
          _reminderTile('After Dinner', '10:00 PM', true),
          _reminderTile('Before Sleep', '10:40 PM', true),
          SizedBox(height: 20),
          Text('Reminder Weekend Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Switch(value: false, onChanged: (val) {}),
          Divider(),
          SizedBox(height: 10),
          Text('Skip & Stop', style: TextStyle(fontSize: 16, color: Colors.blue)),
          SizedBox(height: 10),
          _settingOption('Stop when goal achieved', true),
          _smartSkipOption('Smart Skip', '1 hour', true),
        ],
      ),
    );
  }

  Widget _reminderTile(String label, String time, bool isOn) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white,
      title: Text(label),
      subtitle: Text(time),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, color: Colors.grey),
          SizedBox(width: 8),
          Switch(value: isOn, onChanged: (val) {}),
        ],
      ),
    );
  }

  Widget _settingOption(String title, bool isOn) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white,
      title: Text(title),
      trailing: Switch(value: isOn, onChanged: (val) {}),
    );
  }

  Widget _smartSkipOption(String title, String subtitle, bool isOn) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(value: isOn, onChanged: (val) {}),
    );
  }
}
