import 'package:calculator/buttons/button.dart';
import 'package:calculator/history.dart';
import 'package:calculator/logic/calculator_logic.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalculatorLogic _logic = CalculatorLogic();
  bool change = true;

  void _onButtonPressed(String buttonText) {
    setState(() {
      _logic.btnclicked(buttonText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton(
            offset: Offset(0, 45.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    onTap: () =>
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
          icon:
              Icon(change ? Icons.fullscreen_exit_outlined : Icons.fullscreen),
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
                          _logic.equation,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 35.0, fontWeight: FontWeight.w400),
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
                          _logic.answer,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 52.0, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                CustomRawMaterialButton2(context, 'Ac', () => _onButtonPressed('AC')),
                CustomRawMaterialButton2(context, '⌫', () => _onButtonPressed('⌫')),
                CustomRawMaterialButton2(context, '%', () => _onButtonPressed('%')),
                CustomRawMaterialButton2(context, '÷', () => _onButtonPressed('÷'))
              ],
            ),
            Row(
              children: [
                CustomRawMaterialButton(context, '7', () => _onButtonPressed('7')),
                CustomRawMaterialButton(context, '8', () => _onButtonPressed('8')),
                CustomRawMaterialButton(context, '9', () => _onButtonPressed('9')),
                CustomRawMaterialButton2(context, '×', () => _onButtonPressed('×'))
              ],
            ),
            Row(
              children: [
                CustomRawMaterialButton(context, '4', () => _onButtonPressed('4')),
                CustomRawMaterialButton(context, '5', () => _onButtonPressed('5')),
                CustomRawMaterialButton(context, '6', () => _onButtonPressed('6')),
                CustomRawMaterialButton2(context, '-', () => _onButtonPressed('-'))
              ],
            ),
            Row(
              children: [
                CustomRawMaterialButton(context, '1', () => _onButtonPressed('1')),
                CustomRawMaterialButton(context, '2', () => _onButtonPressed('2')),
                CustomRawMaterialButton(context, '3', () => _onButtonPressed('3')),
                CustomRawMaterialButton2(context, '+', () => _onButtonPressed('+'))
              ],
            ),
            Row(
              children: [
                CustomRawMaterialButton(context, '00', () => _onButtonPressed('00')),
                CustomRawMaterialButton(context, '0', () => _onButtonPressed('0')),
                CustomRawMaterialButton(context, '.', () => _onButtonPressed('.')),
                CustomRawMaterialButton3(context, '=', () => _onButtonPressed('='))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
