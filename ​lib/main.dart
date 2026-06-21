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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
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
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 10,000 Coins = ₹100, matlab 1 Coin = ₹0.01
    double rupees = totalCoins * 0.01;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RozReward', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Coin Balance Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Your Balance',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.amber, size: 36),
                        const SizedBox(width: 8),
                        Text(
                          '$totalCoins Coins',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estimated Value: ₹${rupees.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white90, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tasks Section
            const Text(
              'Daily Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // 1. Daily Check-in Task
            _buildTaskCard(
              icon: Icons.calendar_today,
              iconColor: Colors.orange,
              title: 'Daily Check-In',
              subtitle: 'Claim your 100 daily coins',
              trailing: ElevatedButton(
                onPressed: isCheckedIn
                    ? null
                    : () {
                        setState(() {
                          isCheckedIn = true;
                        });
                        _addCoins(100, 'Daily Check-in Successful');
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text(isCheckedIn ? 'Claimed' : 'Claim'),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Scratch & Win Task
            _buildTaskCard(
              icon: Icons.layers,
              iconColor: Colors.purple,
              title: 'Scratch & Win',
              subtitle: 'Win between 10 to 50 coins',
              trailing: ElevatedButton(
                onPressed: () {
                  // Random coins between 10 and 50
                  int scratchCoins = Random().nextInt(41) + 10;
                  _showScratchDialog(scratchCoins);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: const Text('Scratch'),
              ),
            ),
            const SizedBox(height: 12),

            // 3. Watch Video Ad Task
            _buildTaskCard(
              icon: Icons.play_circle_fill,
              iconColor: Colors.red,
              title: 'Watch Video Ad',
              subtitle: 'Watch a full ad to earn 200 coins',
              trailing: ElevatedButton(
                onPressed: () {
                  _showVideoAdSimulate();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Watch'),
              ),
            ),
            const SizedBox(height: 24),

            // Withdrawal Info Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.amberDeep),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Minimum Withdrawal: 10,000 Coins = ₹100',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }

  // Scratch Card Dialog Box
  void _showScratchDialog(int coinsWon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scratch & Win!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.card_giftcard, size: 80, color: Colors.purple),
            const SizedBox(height: 16),
            const Text('You have revealed the card!'),
            const SizedBox(height: 8),
            Text(
              '+$coinsWon Coins',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addCoins(coinsWon, 'Scratch Card Bonus');
            },
            child: const Text('Collect'),
          ),
        ],
      ),
    );
  }

  // Video Ad Simulation Box
  void _showVideoAdSimulate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Automatically close ad after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
          _addCoins(200, 'Video Ad Reward');
        });

        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Watching Video Advertisement...', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Do not close. Loading reward in 3 seconds.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }
}
