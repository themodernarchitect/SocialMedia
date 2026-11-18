import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final firstController = TextEditingController();
  final secondController = TextEditingController();
  String result = '';

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  void calculate(String op) {
    final a = double.tryParse(firstController.text.trim());
    final b = double.tryParse(secondController.text.trim());

    if (a == null || b == null) {
      setState(() => result = 'Please enter two valid numbers.');
      return;
    }

    double value;
    switch (op) {
      case '+':
        value = a + b;
        break;
      case '-':
        value = a - b;
        break;
      case '×':
        value = a * b;
        break;
      default: // ÷
        if (b == 0) {
          setState(() => result = 'Cannot divide by zero.');
          return;
        }
        value = a / b;
    }
    setState(() => result = 'Result: $value');
  }

  void clear() {
    firstController.clear();
    secondController.clear();
    setState(() => result = '');
  }

  Widget opButton(String op) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => calculate(op),
          child: Text(op, style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const keyboard =
        TextInputType.numberWithOptions(decimal: true, signed: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: firstController,
            keyboardType: keyboard,
            decoration: const InputDecoration(
              labelText: 'First number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: secondController,
            keyboardType: keyboard,
            decoration: const InputDecoration(
              labelText: 'Second number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              opButton('+'),
              opButton('-'),
              opButton('×'),
              opButton('÷'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            result,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: clear, child: const Text('Clear')),
        ],
      ),
    );
  }
}