import 'package:flutter/material.dart';

void main() {
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

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConverterScreen()),
            );
          },
          child: Text('Open Converter'),
        ),
      ),
    );
  }
}

class ConverterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kilometer to Mile Converter'),
      ),
      body: ConverterBody(),
    );
  }
}

class ConverterBody extends StatefulWidget {
  @override
  _ConverterBodyState createState() => _ConverterBodyState();
}

class _ConverterBodyState extends State<ConverterBody> {
  TextEditingController _kilometerController = TextEditingController();
  TextEditingController _mileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _kilometerController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Kilometers',
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              double kilometers = double.tryParse(_kilometerController.text) ?? 0;
              double miles = kilometers * 0.621371; // Conversion factor
              _mileController.text = miles.toStringAsFixed(2);
            },
            child: Text('Convert'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _mileController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Miles',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _kilometerController.dispose();
    _mileController.dispose();
    super.dispose();
  }
}