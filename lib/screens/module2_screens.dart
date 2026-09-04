import 'package:flutter/material.dart';
import '../widgets/dyra_animated_widget.dart';
import 'dashboard_screen.dart';

// =============================================================================
// MODULE 2: DRAG & DROP GAME SCREEN
// =============================================================================
class Module2DragDropGameScreen extends StatefulWidget {
  const Module2DragDropGameScreen({super.key});

  @override
  State<Module2DragDropGameScreen> createState() => _Module2DragDropGameScreenState();
}

class _Module2Item {
  final String text;
  final String category; // 'unavoidable' or 'avoidable'
  final IconData icon;

  const _Module2Item({required this.text, required this.category, required this.icon});
}

class _Module2DragDropGameScreenState extends State<Module2DragDropGameScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isWrongDrop = false;
  bool _showSuccessFeedback = false;
  int _placedCount = 0;

  final List<_Module2Item> _items = const [
    _Module2Item(text: "Rice and vegetables for home meals", category: "unavoidable", icon: Icons.rice_bowl),
    _Module2Item(text: "Eating out at a restaurant every week", category: "avoidable", icon: Icons.restaurant),
    _Module2Item(text: "Monthly house rent", category: "unavoidable", icon: Icons.home),
    _Module2Item(text: "Repainting the house every year for looks", category: "avoidable", icon: Icons.format_paint),
    _Module2Item(text: "Bus fare to school", category: "unavoidable", icon: Icons.directions_bus),
    _Module2Item(text: "Taking a cab for a 5-minute walk", category: "avoidable", icon: Icons.local_taxi),
    _Module2Item(text: "Basic phone recharge/data pack", category: "unavoidable", icon: Icons.phone_android),
    _Module2Item(text: "Buying the newest phone model every year", category: "avoidable", icon: Icons.smartphone),
    _Module2Item(text: "Electricity bill", category: "unavoidable", icon: Icons.electric_bolt),
    _Module2Item(text: "A new video game every month", category: "avoidable", icon: Icons.sports_esports),
    _Module2Item(text: "School fees", category: "unavoidable", icon: Icons.school),
    _Module2Item(text: "Latest branded shoes", category: "avoidable", icon: Icons.shopping_bag),
  ];

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _onItemDropped(String targetCategory) {
    final currentItem = _items[_currentIndex];
    if (currentItem.category == targetCategory) {
      // Correct placement
      setState(() {
        _showSuccessFeedback = true;
        _placedCount++;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _showSuccessFeedback = false;
            if (_currentIndex < _items.length - 1) {
              _currentIndex++;
            }
          });
        }
      });
    } else {
      // Wrong placement -> Bounce back
      setState(() {
        _isWrongDrop = true;
      });
      _bounceController.forward(from: 0).then((_) => _bounceController.reverse());

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isWrongDrop = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isGameComplete = _placedCount == _items.length;
    final currentItem = isGameComplete ? null : _items[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF161515),
      appBar: AppBar(
        title: const Text("Expense Classifier Game", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF161515),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Tracker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Placed: $_placedCount / ${_items.length}",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _placedCount / _items.length,
                        backgroundColor: const Color(0xFF2D2A2A),
                        color: const Color(0xFFDA251D),
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Instructional Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                isGameComplete
                    ? "🎉 Awesome job! You classified all 12 expenses correctly!"
                    : "Drag the item card into the correct basket below:",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),

            const Spacer(),

            // Central Draggable Item Area
            if (!isGameComplete && currentItem != null) ...[
              AnimatedBuilder(
                animation: _bounceController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_bounceAnimation.value, 0),
                    child: child,
                  );
                },
                child: Draggable<String>(
                  data: currentItem.category,
                  feedback: Material(
                    color: Colors.transparent,
                    child: _buildItemCard(currentItem, isDragging: true),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: _buildItemCard(currentItem),
                  ),
                  child: _buildItemCard(currentItem),
                ),
              ),
              const SizedBox(height: 12),
              if (_showSuccessFeedback)
                const AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: Text("✨ Boom! Correct!", style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              if (_isWrongDrop)
                const AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: Text("😅 Uh-oh! Try the other basket!", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
            ],

            if (isGameComplete) ...[
              const Icon(Icons.stars_rounded, size: 80, color: Colors.amber),
              const SizedBox(height: 16),
              const Text("Mastery Completed!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDA251D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Module2TestSessionScreen()),
                  );
                },
                child: const Text("Continue to Test Session", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],

            const Spacer(),

            // Two Drop Target Baskets
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Unavoidable Basket
                  Expanded(
                    child: DragTarget<String>(
                      onWillAccept: (_) => true,
                      onAccept: (_) => _onItemDropped("unavoidable"),
                      builder: (context, candidateData, rejectedData) {
                        bool isHovered = candidateData.isNotEmpty;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 140,
                          decoration: BoxDecoration(
                            color: isHovered ? Colors.green.withOpacity(0.2) : const Color(0xFF262424),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isHovered ? Colors.greenAccent : const Color(0xFF383535),
                              width: isHovered ? 2.5 : 1,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2, size: 40, color: Colors.greenAccent),
                              SizedBox(height: 8),
                              Text("Unavoidable", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text("(Needs / Essential)", style: TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Avoidable Basket
                  Expanded(
                    child: DragTarget<String>(
                      onWillAccept: (_) => true,
                      onAccept: (_) => _onItemDropped("avoidable"),
                      builder: (context, candidateData, rejectedData) {
                        bool isHovered = candidateData.isNotEmpty;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 140,
                          decoration: BoxDecoration(
                            color: isHovered ? Colors.amber.withOpacity(0.2) : const Color(0xFF262424),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isHovered ? Colors.amberAccent : const Color(0xFF383535),
                              width: isHovered ? 2.5 : 1,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 40, color: Colors.amberAccent),
                              SizedBox(height: 8),
                              Text("Avoidable", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text("(Wants / Excess)", style: TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        );
                      },
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

  Widget _buildItemCard(_Module2Item item, {bool isDragging = false}) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2B2B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDA251D), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDA251D).withOpacity(isDragging ? 0.6 : 0.3),
            blurRadius: isDragging ? 16 : 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            item.text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("✋ Drag to basket", style: TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}

// =============================================================================
// MODULE 2: TEST SESSION SCREEN (5 Questions, 25 Marks Total)
// =============================================================================
class Module2TestSessionScreen extends StatefulWidget {
  const Module2TestSessionScreen({super.key});

  @override
  State<Module2TestSessionScreen> createState() => _Module2TestSessionScreenState();
}

class _TestQuestion {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String category;

  const _TestQuestion({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.category,
  });
}

class _Module2TestSessionScreenState extends State<Module2TestSessionScreen> {
  int _currentIndex = 0;
  int? _selectedIndex;
  int _score = 0;
  bool _isFinished = false;

  final List<_TestQuestion> _questions = const [
    _TestQuestion(
      questionText: "What did Arjun wear before he went to sleep in the story?",
      options: ["A blue jacket", "A brown shawl", "Nothing, just his shirt", "A red blanket"],
      correctIndex: 1,
      category: "Memory",
    ),
    _TestQuestion(
      questionText: "What did the shopkeeper ask Arjun to load onto the cart?",
      options: ["Fruits", "Boxes", "Sacks of rice", "Empty bottles"],
      correctIndex: 2,
      category: "Memory",
    ),
    _TestQuestion(
      questionText: "Which of these is an unavoidable expense?",
      options: ["Buying the newest phone every year", "Monthly house rent", "Eating out every week", "Repainting the house for looks"],
      correctIndex: 1,
      category: "Concept",
    ),
    _TestQuestion(
      questionText: "What does 'unavoidable doesn't mean unlimited' mean?",
      options: [
        "You should never spend money on food or rent",
        "You can spend as much as you want on needs",
        "You still need to eat, but wasting food is a choice, not a need",
        "Unavoidable expenses don't really matter"
      ],
      correctIndex: 2,
      category: "Concept",
    ),
    _TestQuestion(
      questionText: "Warren Buffett said: 'If you buy things you do not need, soon you will have to sell things you need.' What does this mean?",
      options: [
        "Never buy anything, ever",
        "Buying things you don't really need can cost you later",
        "Rich people don't need to save money",
        "Selling things is always a bad idea"
      ],
      correctIndex: 1,
      category: "Concept",
    ),
  ];

  void _submitAnswer() {
    if (_selectedIndex == null) return;

    if (_selectedIndex == _questions[_currentIndex].correctIndex) {
      _score += 5; // 5 marks each
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
      });
    } else {
      setState(() {
        _isFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return _buildResultsScreen();
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF161515),
      appBar: AppBar(
        title: const Text("Module 2 Test Session"),
        backgroundColor: const Color(0xFF161515),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Question ${_currentIndex + 1} of 5", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF2A2727), borderRadius: BorderRadius.circular(10)),
                    child: Text("${(_currentIndex + 1) * 5} / 25 Marks", style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Question Text Card
              Text(q.questionText, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.3)),
              const SizedBox(height: 24),

              // Options List
              Expanded(
                child: ListView.builder(
                  itemCount: q.options.length,
                  itemBuilder: (context, idx) {
                    bool isSelected = _selectedIndex == idx;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = idx),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFDA251D).withOpacity(0.2) : const Color(0xFF262424),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFDA251D) : const Color(0xFF383535),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? const Color(0xFFDA251D) : Colors.transparent,
                                border: Border.all(color: isSelected ? const Color(0xFFDA251D) : Colors.white38),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + idx),
                                  style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(q.options[idx], style: const TextStyle(color: Colors.white, fontSize: 15)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedIndex != null ? const Color(0xFFDA251D) : Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _selectedIndex != null ? _submitAnswer : null,
                  child: Text(
                    _currentIndex == 4 ? "Finish Test" : "Next Question",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF161515),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium, size: 90, color: Colors.amber),
              const SizedBox(height: 16),
              const Text("Test Completed!", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Your Module 2 Test Score:", style: TextStyle(color: Colors.white54, fontSize: 16)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF262424),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFDA251D), width: 2),
                ),
                child: Text("$_score / 25 Marks", style: const TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDA251D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Module2HomeTaskScreen()),
                  );
                },
                child: const Text("Start Home Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MODULE 2: HOME TASK SCREEN (Worked Example & Family Expenses Calculator)
// =============================================================================
class Module2HomeTaskScreen extends StatefulWidget {
  const Module2HomeTaskScreen({super.key});

  @override
  State<Module2HomeTaskScreen> createState() => _Module2HomeTaskScreenState();
}

class _Module2HomeTaskScreenState extends State<Module2HomeTaskScreen> {
  final TextEditingController _incomeCtrl = TextEditingController();
  final TextEditingController _rentCtrl = TextEditingController();
  final TextEditingController _foodCtrl = TextEditingController();
  final TextEditingController _transportCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();

  double? _calculatedTotal;
  double? _calculatedPercentage;

  void _calculateExpenses() {
    double income = double.tryParse(_incomeCtrl.text.trim()) ?? 0;
    double rent = double.tryParse(_rentCtrl.text.trim()) ?? 0;
    double food = double.tryParse(_foodCtrl.text.trim()) ?? 0;
    double transport = double.tryParse(_transportCtrl.text.trim()) ?? 0;
    double mobile = double.tryParse(_mobileCtrl.text.trim()) ?? 0;

    if (income <= 0) return;

    double total = rent + food + transport + mobile;
    double percentage = (total / income) * 100;

    setState(() {
      _calculatedTotal = total;
      _calculatedPercentage = percentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161515),
      appBar: AppBar(
        title: const Text("Home Task — Family Expenses"),
        backgroundColor: const Color(0xFF161515),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Worked Example Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF262424),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.menu_book, color: Colors.amber),
                        SizedBox(width: 8),
                        Text("Worked Example: Ramesh's Family", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text("• Family Income: ₹20,000 / month", style: TextStyle(color: Colors.white70)),
                    const Text("• Rent: ₹5,000  |  Food: ₹6,000", style: TextStyle(color: Colors.white70)),
                    const Text("• Transport: ₹2,000  |  Mobile/Internet: ₹1,000", style: TextStyle(color: Colors.white70)),
                    const Divider(color: Colors.white24, height: 20),
                    const Text("Total Expenses = ₹14,000", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const Text("Percentage = (14,000 ÷ 20,000) × 100 = 70%", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const DyRaCompanion(state: DyRaState.entry),
                    const SizedBox(height: 8),
                    const Text(
                      "“So Ramesh's family spends 70 out of every 100 rupees they earn on things they can't avoid. Now it's your turn — try this with your own family.”",
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Student Task Title
              const Text("Your Turn: Calculate Family Unavoidable Expenses", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Ask your parents about these 4 items only:", style: TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 16),

              // Inputs
              _buildInputField(_incomeCtrl, "Total Monthly Family Income (₹)", Icons.account_balance_wallet),
              _buildInputField(_rentCtrl, "1. Rent / House cost (₹)", Icons.home),
              _buildInputField(_foodCtrl, "2. Food (₹)", Icons.restaurant),
              _buildInputField(_transportCtrl, "3. Transport (₹)", Icons.directions_bus),
              _buildInputField(_mobileCtrl, "4. Mobile / Internet (₹)", Icons.phone_android),

              const SizedBox(height: 20),

              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDA251D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _calculateExpenses,
                  child: const Text("Calculate Percentage", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              // Results Calculation Card
              if (_calculatedTotal != null && _calculatedPercentage != null) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A2B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.greenAccent),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 48),
                      const SizedBox(height: 8),
                      const Text("Home Task Calculation Complete!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      Text("Total Unavoidable Expenses: ₹${_calculatedTotal!.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(
                        "Percentage of Income Spent: ${_calculatedPercentage!.toStringAsFixed(1)}%",
                        style: const TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                        onPressed: () {
                          AppProgressManager.instance.completeModule(2);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                            (route) => false,
                          );
                        },
                        child: const Text("Return to Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController ctrl, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54, fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFFDA251D)),
          filled: true,
          fillColor: const Color(0xFF262424),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFDA251D))),
        ),
      ),
    );
  }
}
