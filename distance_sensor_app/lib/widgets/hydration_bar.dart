import 'package:flutter/material.dart';

class HydrationBar extends StatefulWidget {
  final double currentValue;
  final double goalValue;

  const HydrationBar({
    required this.currentValue,
    required this.goalValue,
    super.key,
  });

  @override
  State<HydrationBar> createState() => _HydrationBarState();
}

class _HydrationBarState extends State<HydrationBar> {
  late double displayedValue;

  @override
  void initState() {
    super.initState();
    displayedValue = widget.currentValue;
  }

  @override
  void didUpdateWidget(HydrationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != oldWidget.currentValue) {
      setState(() {
        displayedValue = widget.currentValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (displayedValue / widget.goalValue).clamp(0.0, 1.0) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hydration Progress",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
       
      ],
    );
  }
}
