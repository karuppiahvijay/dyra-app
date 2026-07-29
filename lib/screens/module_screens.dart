import 'package:flutter/material.dart';

class ModuleIntroScreen extends StatefulWidget {
  const ModuleIntroScreen({super.key});

  @override
  State<ModuleIntroScreen> createState() => _ModuleIntroScreenState();
}

class _ModuleIntroScreenState extends State<ModuleIntroScreen> with SingleTickerProviderStateMixin {
  bool _showContent = false;
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C5CE7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: _showContent 
                  ? Column(
                      key: const ValueKey(1),
                      children: [
                        const Icon(Icons.account_balance_wallet, size: 100, color: Colors.white),
                        const SizedBox(height: 32),
                        const Text('Module 2', style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('Inevitable Expenses', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        const Text('Learn how to identify and manage the costs you simply can\'t avoid in life.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 48),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF6C5CE7), padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeachingScreen())),
                          child: const Text('Start Learning', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  : Column(
                      key: const ValueKey(2),
                      children: const [
                        Icon(Icons.lock, size: 80, color: Colors.white54),
                        SizedBox(height: 24),
                        Text('Unlocking Module...', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TeachingScreen extends StatelessWidget {
  const TeachingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Time'), backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.menu_book, color: Color(0xFF00B4D8), size: 48),
            const SizedBox(height: 24),
            const Text('What is an "Inevitable Expense"?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text(
              'Some things in life are fun to buy, but others you HAVE to buy to survive. These are called Needs or Inevitable Expenses.\n\nExamples include:\n• Groceries (Food)\n• Rent (Shelter)\n• Electricity & Water (Utilities)',
              style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00B4D8), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
                child: const Text('Take the Quiz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Quiz'), backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Question 1/1', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Which of the following is an Inevitable Expense?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _buildQuizOption(context, 'A new Video Game', false),
            const SizedBox(height: 12),
            _buildQuizOption(context, 'Going to the Movies', false),
            const SizedBox(height: 12),
            _buildQuizOption(context, 'Monthly Grocery Bill', true),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizOption(BuildContext context, String text, bool isCorrect) {
    return InkWell(
      onTap: () {
        if (isCorrect) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correct! You unlocked the game!'), backgroundColor: Colors.green));
          Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops! Try again.'), backgroundColor: Colors.red));
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(16)),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> items = ['Groceries', 'Movie Tickets', 'Rent/Mortgage', 'New Video Game', 'Electricity Bill'];
  int currentIndex = 0;

  void _handleChoice(bool isNeed) {
    if (currentIndex < items.length - 1) {
      setState(() => currentIndex++);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CompletionScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Needs vs Wants Game'), backgroundColor: Colors.white, elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Item ${currentIndex + 1} of ${items.length}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(color: const Color(0xFFF0F8FF), borderRadius: BorderRadius.circular(24)),
                child: Text(items[currentIndex], textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      onPressed: () => _handleChoice(false),
                      child: const Text('WANT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade500, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      onPressed: () => _handleChoice(true),
                      child: const Text('NEED', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00B4D8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 120, color: Colors.amber),
              const SizedBox(height: 24),
              const Text('Module Complete!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              const Text('You earned +50 Points', style: TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF00B4D8), padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                child: const Text('Return to Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
