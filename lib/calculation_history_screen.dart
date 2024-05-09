import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import DateFormat
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class CalculationHistoryScreen extends StatefulWidget {
  @override
  _CalculationHistoryScreenState createState() =>
      _CalculationHistoryScreenState();
}

class _CalculationHistoryScreenState extends State<CalculationHistoryScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _calculationHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('calculation_history').get();
      setState(() {
        _calculationHistory = List<Map<String, dynamic>>.from(querySnapshot.docs
            .map((DocumentSnapshot doc) => doc.data())
            .toList());
      });
    } catch (e) {
      print('Error loading history from Firestore: $e');
    }
  }

  void _clearHistory() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('calculation_history').get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      setState(() {
        _calculationHistory.clear();
      });
    } catch (e) {
      print('Error clearing history from Firestore: $e');
    }
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
          Map<String, dynamic> historyEntry = _calculationHistory[index];
          String equation = historyEntry['calculation'];
          String result = equation.split('=')[1].trim();
          String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(historyEntry['timestamp'].toDate());
          return ListTile(
            title: Text(equation),
            subtitle: Text('$result ($timestamp)'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearHistory,
        child: Icon(Icons.delete),
      ),
    );
  }
}
