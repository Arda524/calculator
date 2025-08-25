// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calculator/models/history_entry.dart';

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

  Future<void> btnclicked(String buttonText) async {
    String formatResult(double result) {
      // Format the result to remove trailing .0 if it's an integer
      if (result % 1 == 0) {
        return result.toInt().toString();
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
      if (equation.isEmpty) {
        answer = "0";
      }
      isCalculated = false;
    } else if (buttonText == '%') {
      if (equation.isEmpty) return;
      
      try {
        // Parse the entire equation to handle percentage correctly
        String tempExpression = equation.replaceAll('×', '*').replaceAll('÷', '/');
        final p = ShuntingYardParser();
        Expression exp = p.parse(tempExpression);
        ContextModel cm = ContextModel();
        double currentResult = exp.evaluate(EvaluationType.REAL, cm);
        
        // Calculate percentage of the current result
        double percentResult = currentResult / 100;
        equation = percentResult.toString();
        answer = formatResult(percentResult);
      } catch (e) {
        answer = "Error";
      }
    } else if (buttonText == "=") {
      if (equation.isEmpty) return;
      
      expression = equation;
      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');
      
      try {
        final p = ShuntingYardParser();
        Expression exp = p.parse(expression);
        ContextModel cm = ContextModel();
        double result = exp.evaluate(EvaluationType.REAL, cm);
        
        // Handle division by zero
        if (result.isInfinite || result.isNaN) {
          answer = "Error";
          return;
        }
        
        answer = formatResult(result);
        history.add(HistoryEntry('$equation = $answer', DateTime.now()));
        await _saveHistory(); // Save history after adding new entry
        isCalculated = true;
      } catch (e) {
        answer = "Error";
      }
    } else if (buttonText == ".") {
      if (isCalculated) {
        equation = "0.";
        answer = "0";
        isCalculated = false;
        return;
      }
      if (equation.isEmpty) {
        equation = "0.";
        return;
      }

      // Find the last number in the equation
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

      // Only add decimal if the last number doesn't already have one
      if (!lastNumber.contains(".")) {
        equation = equation + ".";
      }
    } else {
      if (isCalculated) {
        if (buttonText == "÷" ||
            buttonText == "×" ||
            buttonText == "-" ||
            buttonText == "+") {
          equation = answer + buttonText;
          answer = "0";
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
          // Prevent consecutive operators
          if ((buttonText == "÷" ||
                  buttonText == "×" ||
                  buttonText == "-" ||
                  buttonText == "+") &&
              (equation.endsWith("÷") ||
                  equation.endsWith("×") ||
                  equation.endsWith("-") ||
                  equation.endsWith("+"))) {
            equation = equation.substring(0, equation.length - 1) + buttonText;
          } else {
            equation = equation + buttonText;
          }
        }
      }
    }
  }
}
