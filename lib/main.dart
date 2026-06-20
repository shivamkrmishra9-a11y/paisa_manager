import 'package:flutter/material.dart';

void main() {
  runApp(const PaisaManagerApp());
}

class PaisaManagerApp extends StatelessWidget {
  const PaisaManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paisa Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1DB954),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _incomeController = TextEditingController();
  final _expenseController = TextEditingController();
  final _budgetLimitController = TextEditingController(text: "15000");
  
  String _selectedCategory = '🍔 Food';
  final List<Map<String, dynamic>> _kharchaList = [];
  double _totalExpenses = 0.0;
  double _predictedSavings = 0.0;
  bool _showPremiumChart = false;

  void _addKharcha() {
    double amount = double.tryParse(_expenseController.text) ?? 0.0;
    if (amount <= 0) return;

    setState(() {
      _kharchaList.insert(0, {
        'amount': amount,
        'category': _selectedCategory,
        'date': DateTime.now().toString().split(' ')[0],
      });
      _totalExpenses += amount;
    });
    _expenseController.clear();
  }

  void _predictSavings() {
    double income = double.tryParse(_incomeController.text) ?? 0.0;
    if (income <= 0) return;
    setState(() {
      _predictedSavings = income - (_totalExpenses * 1.05);
    });
  }

  @override
  Widget build(BuildContext context) {
    double budgetLimit = double.tryParse(_budgetLimitController.text) ?? 15000.0;
    bool isOverBudget = _totalExpenses >= (budgetLimit * 0.8);

    return Scaffold(
      appBar: AppBar(title: const Text('💰 Paisa Manager Pro'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly Income', prefixText: '₹ ', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _budgetLimitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Budget Limit', prefixText: '₹ ', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),

            if (isOverBudget) ...[
              Container(
                padding: const EdgeInsets.all(12),
                color: _totalExpenses >= budgetLimit ? Colors.red[900] : Colors.orange[900],
                child: Text(_totalExpenses >= budgetLimit ? "🚨 Budget Cross Ho Gaya!" : "⚠️ Warning: 80% Budget Used!"),
              ),
              const SizedBox(height: 15),
            ],

            Card(
              color: const Color(0xFF1F1F1F),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(controller: _expenseController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount spent', prefixText: '₹ ')),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      dropdownColor: const Color(0xFF212121),
                      items: ['🍔 Food', '🚗 Travel', '🛒 Shopping', '💡 Bills'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: _addKharcha, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)), child: const Text('Save Expense', style: TextStyle(color: Colors.black))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            Text("Total Spent: ₹ $_totalExpenses", style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _predictSavings, child: const Text('🔮 Predict Next Month Savings')),
            
            if (_predictedSavings != 0.0) ...[
              const SizedBox(height: 10),
              Text("Prediction: ₹ ${_predictedSavings.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, color: Colors.green)),
            ],
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () => setState(() => _showPremiumChart = true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              child: const Text("Unlock Premium Analytics"),
            ),

            if (_showPremiumChart) ...[
              const SizedBox(height: 10),
              Container(padding: const EdgeInsets.all(10), color: Colors.blue.withOpacity(0.1), child: const Text("📊 Food & Bills Breakdown Shown Here!")),
            ],
            const SizedBox(height: 15),

            const Text("📋 History:", style: TextStyle(fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _kharchaList.length,
              itemBuilder: (context, index) {
                final item = _kharchaList[index];
                return ListTile(title: Text(item['category']), trailing: Text("₹ ${item['amount']}"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
