import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF22252D),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "";
  String output = ""; // To store the result of the calculation
  String equation = ""; // To store the equation for display
  double num1 = 0;
  double num2 = 0;
  String operator = ""; // To store the operator for calculation
  String displayNum1 = ""; // To store first number for display
  bool showingResult = false;
  bool enteringSecondNumber = false;

  void buttonPressed(String value) {
    setState(() {
      // Clear button
      if (value == "C") {
        input = "";
        output = "";
        equation = "";
        displayNum1 = "";
        num1 = 0;
        num2 = 0;
        operator = "";
        showingResult = false;
        enteringSecondNumber = false;
      }
      // Backspace button
      else if (value == "⌫") {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      }
      // Equals button
      else if (value == "=") {
        if (input.isNotEmpty && operator.isNotEmpty) {
          try {
            num2 = double.parse(input);
            equation = "$num1 $operator $num2";

            switch (operator) {
              case "+":
                output = (num1 + num2).toString();
                break;
              case "-":
                output = (num1 - num2).toString();
                break;
              case "×":
                output = (num1 * num2).toString();
                break;
              case "÷":
                output = num2 != 0 ? (num1 / num2).toString() : "Error";
                break;
              default:
                output = input;
            }

            // Format output to remove .0 for whole numbers
            if (output.endsWith(".0")) {
              output = output.substring(0, output.length - 2);
            }

            input = output;
            displayNum1 = "";
            operator = "";
            showingResult = true;
            enteringSecondNumber = false;
          } catch (e) {
            output = "Error";
          }
        }
      }
      // Operator buttons
      else if (value == "+" || value == "-" || value == "×" || value == "÷") {
        if (input.isNotEmpty) {
          try {
            // If we already have an operator and a first number
            if (operator.isNotEmpty &&
                displayNum1.isNotEmpty &&
                enteringSecondNumber) {
              num2 = double.parse(input);

              // Calculate the result of the current operation
              switch (operator) {
                case "+":
                  num1 = num1 + num2;
                  break;
                case "-":
                  num1 = num1 - num2;
                  break;
                case "×":
                  num1 = num1 * num2;
                  break;
                case "÷":
                  num1 = num2 != 0 ? num1 / num2 : double.nan;
                  break;
              }

              // Format displayNum1
              displayNum1 = num1.toString();
              if (displayNum1.endsWith(".0")) {
                displayNum1 = displayNum1.substring(0, displayNum1.length - 2);
              }

              input = "";
            } else {
              // First time selecting an operator
              num1 = double.parse(input);
              displayNum1 = input;
              input = "";
            }

            operator = value;
            showingResult = false;
            enteringSecondNumber = true;
          } catch (e) {
            output = "Error";
          }
        } else if (showingResult) {
          // If we're showing a result and press an operator
          num1 = double.parse(output);
          displayNum1 = output;
          operator = value;
          input = "";
          output = "";
          showingResult = false;
          enteringSecondNumber = true;
        }
      }
      // Percentage button
      else if (value == "%") {
        if (input.isNotEmpty) {
          try {
            double val = double.parse(input) / 100;
            input = val.toString();
            if (input.endsWith(".0")) {
              input = input.substring(0, input.length - 2);
            }
          } catch (e) {
            output = "Error";
          }
        }
      }
      // Decimal point
      else if (value == ".") {
        if (!input.contains(".")) {
          input = input.isEmpty ? "0." : input + ".";
        }
      }
      // Number buttons
      else {
        if (showingResult) {
          // If showing result, start new calculation
          input = value;
          output = "";
          displayNum1 = "";
          operator = "";
          showingResult = false;
          enteringSecondNumber = false;
        } else {
          input += value;
        }
      }
    });
  }

  Widget buildButton(String text, Color textColor, Color btnColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(20),
            backgroundColor: btnColor,
            shadowColor: Colors.black45,
            elevation: 5,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define colors
    final operatorColor = Colors.amber[700]!;
    final functionColor = Colors.grey[700]!;
    final numberColor = const Color(0xFF2D2F39);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF22252D),
        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "App: Simple Calculator",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Creator:\nLuu Phuc Khang - 22119188\nNguyen Dinh Thong - 22119236",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Function: +, -, ×, ÷, %",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Display
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF2D2F39), const Color(0xFF1A1B20)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Previous operation status (first number and operator)
                    if (displayNum1.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                displayNum1,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                operator,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: operatorColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),

                    // Current input or result
                    Text(
                      showingResult ? output : (input.isEmpty ? "0" : input),
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1B20),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Row 1
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("C", Colors.white, functionColor),
                          buildButton("⌫", Colors.white, functionColor),
                          buildButton("%", Colors.white, functionColor),
                          buildButton("÷", Colors.white, operatorColor),
                        ],
                      ),
                    ),
                    // Row 2
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("7", Colors.white, numberColor),
                          buildButton("8", Colors.white, numberColor),
                          buildButton("9", Colors.white, numberColor),
                          buildButton("×", Colors.white, operatorColor),
                        ],
                      ),
                    ),
                    // Row 3
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("4", Colors.white, numberColor),
                          buildButton("5", Colors.white, numberColor),
                          buildButton("6", Colors.white, numberColor),
                          buildButton("-", Colors.white, operatorColor),
                        ],
                      ),
                    ),
                    // Row 4
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("1", Colors.white, numberColor),
                          buildButton("2", Colors.white, numberColor),
                          buildButton("3", Colors.white, numberColor),
                          buildButton("+", Colors.white, operatorColor),
                        ],
                      ),
                    ),
                    // Row 5
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("0", Colors.white, numberColor),
                          buildButton(".", Colors.white, numberColor),
                          buildButton("=", Colors.white, operatorColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
