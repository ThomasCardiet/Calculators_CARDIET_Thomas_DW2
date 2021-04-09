import 'package:calculator_flutter/res/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculatrice',
      theme: ThemeData(
        primaryColor: AppColors.inputContainerBackground,
        accentColor: AppColors.displayContainerBackground,
        primaryColorBrightness: Brightness.light,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  double? input;
  double? previousInput;
  String? symbol;
  bool? decimal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(color: AppColors.white, fontSize: 22.0),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                color: AppColors.displayContainerBackground,
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsets.all(22.0),
                child: Text(input?.toString() ?? "0"),
              ),
            ),
            Flexible(
              flex: 8,
              child: Column(
                // Pour chaque nouvelle ligne, on itère sur chaque cellule
                children: grid.map((List<String> line) {
                  return Expanded(
                    child: Row(
                        children: line
                            .map(
                              (String cell) => Expanded(
                            child: InputButton(
                              label: cell,
                              onTap: onItemClicked,
                            ),
                          ),
                        )
                            .toList(growable: false)),
                  );
                }).toList(growable: false),
              ),
            )
          ],
        ),
      ),
    );
  }

  static const List<List<String>> grid = <List<String>>[
    <String>["", "", "C", "CE"],
    <String>["7", "8", "9", "-"],
    <String>["4", "5", "6", "*"],
    <String>["1", "2", "3", "/"],
    <String>["0", ".", "=", "+"],
  ];

  void onItemClicked(String value) {

    switch (value) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        onNewDigit(value);
        break;
      case '+':
      case '-':
      case '/':
      case '*':
        onNewSymbol(value);
        break;
      case '=':
        onEquals();
        break;

      // QUESTION 2
      case '.':
        if(decimal == true || input.toString().contains(".")) break;
        decimal = true;
        break;

      case 'C':
        onClear(false);
        break;
      case 'CE':
        onClear(true);
        break;
    }

    // Force l'interface à se redessiner
    setState(() {});
  }

  // QUESTION 1
  void onNewDigit(String digit) {
    // QUESTION 2
    if(decimal == true) {
      input = input == null ? double.parse("0."+digit) : double.parse(input.toString() + "." + digit);
      decimal = false;
    }
    else input = input == null ? double.parse(digit) : double.parse(input.toString() + digit);
  }

  void onNewSymbol(String symbol) {
    previousInput = input;
    input = 0;
    this.symbol = symbol;
  }

  void onEquals() {
    if(previousInput == null || symbol == null) return;
    double? result = 0;
    switch(symbol) {
      case '+':
        input = previousInput! + input!;
        break;
      case '-':
        input = previousInput! - input!;
        break;
      case '*':
        input = previousInput! * input!;
        break;
      case '/':
        // QUESTION 3
        if (input == 0) {
          return;
        }
        input = (previousInput! ~/ input!) as double?;
        break;
    }

    previousInput = 0;
    symbol = null;

  }

  // QUESTION 4
  void onClear(bool all) {
    if(all) {
      input = 0;
      previousInput = 0;
      symbol = null;
    }else {
      if(input.toString().length <= 1) {
        input = 0;
        return;
      }
      input = double.parse(input.toString().substring(0, input.toString().length-1));
    }
    decimal = false;
  }

}

class InputButton extends StatelessWidget {
  final String label;
  final ValueChanged<String>? onTap;

  InputButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(label),
      child: Ink(
        height: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.white, width: 0.5),
            color: AppColors.inputContainerBackground),
        child: Center(
          child: Text(
            label,
          ),
        ),
      ),
    );
  }
}