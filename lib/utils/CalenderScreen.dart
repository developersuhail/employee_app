import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();

  void _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Ensure selectedDate is defined
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Update the selected date
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Joseph Marsden',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            Text(
              'Selected date: ${DateFormat('d MMM yyyy').format(selectedDate)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now();
                    });
                  },
                  child: Text('Today'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now().add(Duration(days: (8 - DateTime.now().weekday) % 7));
                    });
                  },
                  child: Text('Next Monday'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now().add(Duration(days: (9 - DateTime.now().weekday) % 7));
                    });
                  },
                  child: Text('Next Tuesday'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now().add(Duration(days: 7));
                    });
                  },
                  child: Text('After 1 week'),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Cancel action
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Save action
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
