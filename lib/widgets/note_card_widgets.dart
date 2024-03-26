import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app1/models/note.dart';

final List<Color> lightColors = [
  Colors.amber.shade300,
  Colors.lightBlue.shade300,
  Colors.lightGreen.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.pinkAccent.shade100,
];

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({super.key, required this.note,required this.index}) ;


  final Note note;
  final int index;

  double getItemHeight(int index) {
    switch (index % 4) {
      case 0:
      case 3:
        return 100;
      case 1:
      case 2:
        return 150;
      default:
        return 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.yMMMd().add_jms().format(note.createdTime);
    final minHeight = getItemHeight(index); // Changed to getItemHeight
    final color = lightColors[index % lightColors.length]; // Changed to lightColors

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              note.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add other widgets here as needed
          ],
        ),
      ),
    );
  }
}
