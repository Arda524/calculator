import 'package:calculator/buttons/button.dart';
import 'package:calculator/history.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkModeEnabled = false;
  bool change = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // A light grey
        appBarTheme: const AppBarTheme(
          color: Color(0xFFF5F5F5), // Matching app bar
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
              color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        popupMenuTheme: const PopupMenuThemeData(color: Color(0xFFF5F5F5)),
      ),
      darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(color: Colors.black),
          popupMenuTheme:
              PopupMenuThemeData(elevation: 15, shadowColor: Colors.cyan)),
      themeMode: ThemeMode.system,
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Calculator",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            actions: [
              PopupMenuButton(
                offset: Offset(0, 45.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        padding: EdgeInsets.fromLTRB(0, 0, 125, 0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            "History",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return History();
                            })))
                  ];
                },
              )
            ],
            leading: IconButton(
              onPressed: () {
                setState(() {
                  change = !change;
                });
              },
              icon: Icon(
                  change ? Icons.fullscreen_exit_outlined : Icons.fullscreen),
            ),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SingleChildScrollView(
                          reverse: true,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              equation,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SingleChildScrollView(
                          reverse: true,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              answer,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 52.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    CustomRawMaterialButton2(context, 'Ac', () => btnclicked('AC')),
                    CustomRawMaterialButton2(context, '⌫', () => btnclicked('⌫')),
                    CustomRawMaterialButton2(context, '%', () => btnclicked('%')),
                    CustomRawMaterialButton2(context, '÷', () => btnclicked('÷'))
                  ],
                ),
                Row(
                  children: [
                    CustomRawMaterialButton(context, '7', () => btnclicked('7')),
                    CustomRawMaterialButton(context, '8', () => btnclicked('8')),
                    CustomRawMaterialButton(context, '9', () => btnclicked('9')),
                    CustomRawMaterialButton2(context, '×', () => btnclicked('×'))
                  ],
                ),
                Row(
                  children: [
                    CustomRawMaterialButton(context, '4', () => btnclicked('4')),
                    CustomRawMaterialButton(context, '5', () => btnclicked('5')),
                    CustomRawMaterialButton(context, '6', () => btnclicked('6')),
                    CustomRawMaterialButton2(context, '-', () => btnclicked('-'))
                  ],
                ),
                Row(
                  children: [
                    CustomRawMaterialButton(context, '1', () => btnclicked('1')),
                    CustomRawMaterialButton(context, '2', () => btnclicked('2')),
                    CustomRawMaterialButton(context, '3', () => btnclicked('3')),
                    CustomRawMaterialButton2(context, '+', () => btnclicked('+'))
                  ],
                ),
                Row(
                  children: [
                    CustomRawMaterialButton(context, '00', () => btnclicked('00')),
                    CustomRawMaterialButton(context, '0', () => btnclicked('0')),
                    CustomRawMaterialButton(context, '.', () => btnclicked('.')),                    CustomRawMaterialButton3(context, '=', () => btnclicked('='))
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String equation = "";
  String answer = "0";
  String expression = "";
  bool isCalculated = false;

  btnclicked(String buttonText) {
    String doesContainDecimal(dynamic result) {
      if (result.toString().contains('.')) {
        List<String> splitDecimal = result.toString().split('.');
        if (!(int.parse(splitDecimal[1]) > 0)) {
          return splitDecimal[0].toString();
        }
      }
      return result.toString();
    }

    setState(() {
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
          double number = double.parse(lastNumber);
          double percent = number / 100;
          equation =
              equation.substring(0, lastOperatorIndex + 1) + percent.toString();
        } else {
          double number = double.parse(equation);
          double percent = number / 100;
          equation = percent.toString();
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
          isCalculated = true;
        } catch (e) {
          answer = "Error";
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
            equation = buttonText;
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
    });
  }
}
