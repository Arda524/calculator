// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryEntry {
  final String calculation;
  final DateTime timestamp;

  HistoryEntry(this.calculation, this.timestamp);

  // Convert HistoryEntry to a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'calculation': calculation,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create HistoryEntry from a Map
  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      json['calculation'],
      DateTime.parse(json['timestamp']),
    );
  }
}

class CalculatorLogic {
  String equation = "";
  String answer = "0";
  String expression = "";
  bool isCalculated = false;
  List<HistoryEntry> history = [];

  // Initialize and load history from shared preferences
  Future<void> initialize() async {
    await _loadHistory();
  }

  // Save history to shared preferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = history.map((entry) => entry.toJson()).toList();
    await prefs.setString('calculator_history', json.encode(historyJson));
  }

  // Load history from shared preferences
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJsonString = prefs.getString('calculator_history');
    
    if (historyJsonString != null) {
      try {
        final List<dynamic> historyJson = json.decode(historyJsonString);
        history = historyJson.map((json) => HistoryEntry.fromJson(json)).toList();
      } catch (e) {
        // If there's an error parsing, start with empty history
        history = [];
      }
    } else {
      history = [];
    }
  }

  // Update history from external sources (like when deleting items)
  Future<void> updateHistory(List<HistoryEntry> newHistory) async {
    history = newHistory;
    await _saveHistory();
  }

  void btnclicked(String buttonText) {
    String doesContainDecimal(dynamic result) {
      if (result.toString().contains('.')) {
        List<String> splitDecimal = result.toString().split('.');
        if (!(int.parse(splitDecimal[1]) > 0)) {
          return splitDecimal[0].toString();
        }
      }
      return result.toString();
    }

    if (buttonText == "AC") {
      equation = "";
      answer = "0";
      isCalculated = false;
    } else if (buttonText == "⌫") {
      if (equation.isNotEmpty) {
        equation = equation.substring(0, equation.length - 1);
      }
      if (equation == "") {
        equation = "";
      }
      isCalculated = false;
    } else if (buttonText == '%') {
      if (equation.isEmpty) return;
      
      String lastNumber = "";
      int lastOperatorIndex = -1;
      for (int i = equation.length - 1; i >= 0; i--) {
        if (equation[i] == '+' ||
            equation[i] == '-' ||
            equation[i] == '×' ||
            equation[i] == '÷') {
          lastOperatorIndex = i;
          break;
        }
      }

      try {
        if (lastOperatorIndex != -1) {
          lastNumber = equation.substring(lastOperatorIndex + 1);
          if (lastNumber.isNotEmpty) {
            double number = double.parse(lastNumber);
            double percent = number / 100;
            equation =
                equation.substring(0, lastOperatorIndex + 1) + percent.toString();
          }
        } else {
          double number = double.parse(equation);
          double percent = number / 100;
          equation = percent.toString();
        }
      } catch (e) {
        // Handle parsing errors gracefully
        return;
      }
    } else if (buttonText == "=") {
      expression = equation;
      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');
      expression = expression.replaceAll('%', '%');

      try {
        final p = ShuntingYardParser();
        Expression exp = p.parse(expression);
        ContextModel cm = ContextModel();
        double result = exp.evaluate(EvaluationType.REAL, cm);
        answer = doesContainDecimal(result);
        history.add(HistoryEntry('$equation = $answer', DateTime.now()));
        _saveHistory(); // Save history after adding new entry
        isCalculated = true;
      } catch (e) {
        answer = "Error";
      }
    } else if (buttonText == ".") {
      if (isCalculated) {
        equation = "0.";
        isCalculated = false;
        return;
      }
      if (equation.isEmpty) {
        equation = "0.";
        return;
      }

      String lastNumber = "";
      int lastOperatorIndex = -1;
      for (int i = equation.length - 1; i >= 0; i--) {
        if (equation[i] == '+' ||
            equation[i] == '-' ||
            equation[i] == '×' ||
            equation[i] == '÷') {
          lastOperatorIndex = i;
          break;
        }
      }

      if (lastOperatorIndex != -1) {
        lastNumber = equation.substring(lastOperatorIndex + 1);
      } else {
        lastNumber = equation;
      }

      if (!lastNumber.contains(".")) {
        if (lastNumber.isEmpty) {
          equation = equation + "0.";
        } else {
          equation = equation + ".";
        }
      }
    } else {
      if (isCalculated) {
        if (buttonText == "÷" ||
            buttonText == "×" ||
            buttonText == "-" ||
            buttonText == "+") {
          equation = answer + buttonText;
        } else {
          equation = buttonText;
          answer = "0";
        }
        isCalculated = false;
      } else {
        if (equation == "0") {
          if (buttonText == "0" || buttonText == "00") {
            equation = "0";
          } else {
            equation = buttonText;
          }
        } else {
          if ((buttonText == "÷" ||
                  buttonText == "×" ||
                  buttonText == "-" ||
                  buttonText == "+") &&
              (equation.endsWith("÷") ||
                  equation.endsWith("×") ||
                  equation.endsWith("-") ||
                  equation.endsWith("+"))) {
            equation =
                equation.substring(0, equation.length - 1) + buttonText;
          } else {
            equation = equation + buttonText;
          }
        }
      }
    }
  }
}
