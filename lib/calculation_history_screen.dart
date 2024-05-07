import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import DateFormat

class CalculationHistoryScreen extends StatefulWidget {
  @override
  _CalculationHistoryScreenState createState() =>
      _CalculationHistoryScreenState();
}

class _CalculationHistoryScreenState extends State<CalculationHistoryScreen> {
  List<String> _calculationHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _calculationHistory =
          prefs.getStringList('calculation_history') ?? <String>[];
    });
  }

  Future<void> _clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('calculation_history');
    setState(() {
      _calculationHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History'),
      ),
      body: _calculationHistory.isEmpty
          ? Center(child: Text('No calculation history'))
          : ListView.builder(
        itemCount: _calculationHistory.length,
        itemBuilder: (context, index) {
          String historyEntry = _calculationHistory[index];
          List<String> parts =
          historyEntry.split('='); // Split equation and result
          if (parts.length >= 2) {
            String equation = parts[0].trim();
            String result = parts[1].trim();
            // Check if there's a datetime part
            String formattedDateTime = parts.length > 2
                ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(parts[2].trim()))
                : '';
            return ListTile(
              title: Text('$equation = $result'),
              subtitle: Text(formattedDateTime), // Display formatted date and time
            );
          } else {
            return ListTile(
              title: Text('Invalid history entry'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearHistory,
        child: Icon(Icons.delete),
      ),
    );
  }
}
