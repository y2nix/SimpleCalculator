import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Импорт cloud_firestore
import 'converter_screen.dart';
import 'calculation_history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayValue = '0';
  String _operation = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _displayValue = '0';
        _operation = '';
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '*' ||
          buttonText == '/') {
        if (_displayValue != '0') {
          _operation += _displayValue + buttonText;
        } else {
          if (_operation.isNotEmpty) {
            _operation = _operation.substring(0, _operation.length - 1) + buttonText;
          }
        }
        _displayValue = '0';
      } else if (buttonText == '=') {
        _operation += _displayValue;
        Parser p = Parser();
        Expression exp = p.parse(_operation);
        ContextModel cm = ContextModel();
        _displayValue = exp.evaluate(EvaluationType.REAL, cm).toString();
        _saveToHistory(_operation + '=' + _displayValue);
        _operation = '';
      } else {
        if (_displayValue == '0') {
          _displayValue = buttonText;
        } else {
          _displayValue += buttonText;
        }
      }
    });
  }

  Future<void> _saveToHistory(String calculation) async {
    try {
      await _firestore.collection('calculation_history').add({
        'calculation': calculation,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  void _openHistoryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalculationHistoryScreen()),
    );
  }

  void _openConverterScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConverterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Calculator'),
        actions: [
          IconButton(
            onPressed: () => _openHistoryScreen(context),
            icon: Icon(Icons.history),
          ),
          IconButton(
            onPressed: () => _openConverterScreen(context),
            icon: Icon(Icons.compare_arrows),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                _displayValue,
                style: TextStyle(fontSize: 32.0),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CalculatorButton('7', _onButtonPressed),
                      CalculatorButton('8', _onButtonPressed),
                      CalculatorButton('9', _onButtonPressed),
                      CalculatorButton('/', _onButtonPressed),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CalculatorButton('4', _onButtonPressed),
                      CalculatorButton('5', _onButtonPressed),
                      CalculatorButton('6', _onButtonPressed),
                      CalculatorButton('*', _onButtonPressed),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CalculatorButton('1', _onButtonPressed),
                      CalculatorButton('2', _onButtonPressed),
                      CalculatorButton('3', _onButtonPressed),
                      CalculatorButton('-', _onButtonPressed),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CalculatorButton('0', _onButtonPressed),
                      CalculatorButton('.', _onButtonPressed),
                      CalculatorButton('C', _onButtonPressed),
                      CalculatorButton('+', _onButtonPressed),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CalculatorButton('=', _onButtonPressed),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function(String) onPressed;

  const CalculatorButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed(text);
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        textStyle: TextStyle(fontSize: 20),
        minimumSize: Size(64, 64),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
