class CalculatorLogic {
  double _currentNumber = 0;
  double _result = 0;
  String _operation = '';

  double get result => _result;

  void applyNumber(double number) {
    _currentNumber = _currentNumber * 10 + number;
  }

  void applyOperator(String operator) {
    if (_operation.isNotEmpty) {
      _calculate();
    }
    _result = _currentNumber;
    _currentNumber = 0;
    _operation = operator;
  }

  void calculate() {
    _calculate();
    _operation = '';
  }

  void clear() {
    _currentNumber = 0;
    _result = 0;
    _operation = '';
  }

  void _calculate() {
    switch (_operation) {
      case '+':
        _result += _currentNumber;
        break;
      case '-':
        _result -= _currentNumber;
        break;
      case '*':
        _result *= _currentNumber;
        break;
      case '/':
        if (_currentNumber != 0) {
          _result /= _currentNumber;
        }
        break;
    }
  }
}