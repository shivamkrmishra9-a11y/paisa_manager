import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const RozRewardApp());
}

class RozRewardApp extends StatelessWidget {
  const RozRewardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RozReward',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF141414),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalCoins = 0;
  bool isCheckedIn = false;

  void _addCoins(int amount, String message) {
    setState(() {
      totalCoins += amount;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message! +$amount Coins'),
        backgroundColor: Colors.amber,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 RozReward', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: const Color(0xFF1E1E1E),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('USER BALANCE', style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('🪙 $totalCoins Coins', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black, padding: const EdgeInsets.all(15)),
              onPressed: isCheckedIn ? null : () {
                setState(() { isCheckedIn = true; });
                _addCoins(100, 'Daily Bonus Claimed');
              },
              child: Text(isCheckedIn ? 'Claimed Today' : 'Claim Daily Bonus (+100)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1E1E), foregroundColor: Colors.white, padding: const EdgeInsets.all(15)),
              onPressed: () {
                int scratchCoins = Random().nextInt(41) + 10;
                _addCoins(scratchCoins, 'Scratch Card Reward');
              },
              child: const Text('Tap to Scratch (Win 10-50 Coins)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1E1E), foregroundColor: Colors.white, padding: const EdgeInsets.all(15)),
              onPressed: () {
                _addCoins(200, 'Video Ad Reward');
              },
              child: const Text('Watch Video Ad (+200)'),
            ),
          ],
        ),
      ),
    );
  }
}
