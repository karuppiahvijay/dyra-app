import 'package:flutter/material.dart';
import 'dart:ui';
import 'module_screens.dart';
import 'module2_screens.dart';

// =============================================================================
// REACTIVE GLOBAL APP STATE MANAGER
// =============================================================================
class AppProgressManager extends ChangeNotifier {
  static final AppProgressManager instance = AppProgressManager._internal();
  AppProgressManager._internal();

  int completedModulesCount = 0;
  int currentModuleIndex = 1; // Active module
  bool isModule1Completed = false;
  bool isModule2Completed = false;

  void completeModule(int moduleNumber) {
    if (moduleNumber == 1) {
      isModule1Completed = true;
      if (completedModulesCount < 1) completedModulesCount = 1;
      currentModuleIndex = 2;
    } else if (moduleNumber == 2) {
      isModule2Completed = true;
      if (completedModulesCount < 2) completedModulesCount = 2;
      currentModuleIndex = 3;
    }
    notifyListeners();
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final Color primaryRed = const Color(0xFFDA251D);
  final Color faintRed = const Color(0xFFFFF0F0);

  // Settings State
  bool _soundFxEnabled = true;
  bool _voiceGuidanceEnabled = true;
  bool _dailyRemindersEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    AppProgressManager.instance.addListener(_onProgressUpdated);
  }

  @override
  void dispose() {
    AppProgressManager.instance.removeListener(_onProgressUpdated);
    super.dispose();
  }

  void _onProgressUpdated() {
    if (mounted) setState(() {});
  }

  // =============================================================================
  // TOP BAR & HEADER BADGES
  // =============================================================================
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drawer Menu Icon
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryRed.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: primaryRed),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      const TextSpan(text: 'Hi, '),
                      TextSpan(text: 'Ananya!', style: TextStyle(color: primaryRed)),
                      const TextSpan(text: ' 👋'),
                    ],
                  ),
                ),
                const Text('Let\'s continue your learning journey.', style: TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          // Notification Bell
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('🔔 Notification: Module 2 Unavoidable Expenses challenge is active!')),
                  );
                },
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: primaryRed, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Avatar Icon (Taps to Profile tab)
          GestureDetector(
            onTap: () => setState(() => _selectedIndex = 4),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: faintRed,
                border: Border.all(color: primaryRed, width: 1.5),
                image: const DecorationImage(image: AssetImage('assets/images/mascot.png'), fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadges() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: faintRed,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryRed.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryRed.withOpacity(0.1),
                  radius: 18,
                  child: Icon(Icons.stars, color: primaryRed, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1,250', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryRed)),
                    const Text('Total Score', style: TextStyle(fontSize: 11, color: Colors.black54)),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: faintRed,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryRed.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryRed.withOpacity(0.1),
                  radius: 18,
                  child: Icon(Icons.monetization_on, color: primaryRed, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('450', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryRed)),
                    const Text('DyRa Points', style: TextStyle(fontSize: 11, color: Colors.black54)),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyBanner() {
    final progress = AppProgressManager.instance;
    int percentage = ((progress.completedModulesCount / 10) * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryRed,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: primaryRed.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.map_outlined, color: Colors.white, size: 26),
                  SizedBox(width: 10),
                  Text('Your Journey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const Text('Overall Progress', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Level 1 - Explorer', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Container(
                    width: 110,
                    height: 10,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(5)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: (progress.completedModulesCount / 10).clamp(0.05, 1.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('$percentage%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  int? _selectedLevelIndex = 1; // Level 1 active by default

  Widget _buildLevelTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildLevelCard(1, 'Level 1', 'Explorer', Icons.explore, _selectedLevelIndex == 1),
          _buildLevelCard(2, 'Level 2', 'Planner', Icons.calendar_month, _selectedLevelIndex == 2),
          _buildLevelCard(3, 'Level 3', 'Investor', Icons.emoji_nature, _selectedLevelIndex == 3),
          _buildLevelCard(4, 'Level 4', 'Wealth Builder', Icons.trending_up, _selectedLevelIndex == 4),
          _buildLevelCard(5, 'Level 5', 'Money Master', Icons.emoji_events, _selectedLevelIndex == 5),
        ],
      ),
    );
  }

  Widget _buildLevelCard(int index, String level, String title, IconData icon, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 1) {
            // Toggle Level 1 map visible/hidden
            _selectedLevelIndex = (_selectedLevelIndex == 1) ? null : 1;
          } else {
            _selectedLevelIndex = index;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$level ($title) is locked! Complete Level 1 modules to unlock.'),
                duration: const Duration(seconds: 2),
                backgroundColor: primaryRed,
              ),
            );
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 95,
        height: 135,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? faintRed : Colors.white,
          border: Border.all(color: isActive ? primaryRed : Colors.grey.shade300, width: isActive ? 1.5 : 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [BoxShadow(color: primaryRed.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: isActive ? Colors.white : Colors.grey.shade100,
              radius: 20,
              child: Icon(icon, color: isActive ? primaryRed : Colors.grey, size: 24),
            ),
            const Spacer(),
            Text(level, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? primaryRed : Colors.black87, fontSize: 13)),
            const SizedBox(height: 2),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 6),
            if (index != 1) const Icon(Icons.lock, size: 14, color: Colors.grey) else const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildMapArea() {
    final progress = AppProgressManager.instance;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: faintRed,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 8.0),
            child: Text('Modules Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          SizedBox(
            height: 560,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double w = constraints.maxWidth;

                // Exact Node Centers for 10 Modules
                final double cx1 = w * 0.18, cy1 = 140;
                final double cx2 = w * 0.50, cy2 = 90;
                final double cx3 = w * 0.82, cy3 = 130;
                final double cx4 = w * 0.82, cy4 = 230;
                final double cx5 = w * 0.50, cy5 = 260;
                final double cx6 = w * 0.18, cy6 = 300;
                final double cx7 = w * 0.18, cy7 = 400;
                final double cx8 = w * 0.50, cy8 = 430;
                final double cx9 = w * 0.82, cy9 = 430;
                final double cx10 = w * 0.50, cy10 = 500;

                return Stack(
                  children: [
                    // Dynamic Dotted Line Path connecting 1 -> 10
                    Positioned.fill(child: CustomPaint(painter: DottedPathPainterMobile())),

                    // Auto-updating Completed Badge (Green Circle)
                    Positioned(
                      left: w * 0.04,
                      top: 10,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green, width: 3.5),
                          boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 8)],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${progress.completedModulesCount}/10', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryRed)),
                            const Text('Modules\nCompleted', textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: Colors.black54, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),

                    // Decorative Scenery & Icons
                    Positioned(left: w * 0.75, top: 12, child: Image.asset('assets/images/scenery.png', width: 44)),
                    Positioned(left: w * 0.10, top: 220, child: Image.asset('assets/images/scenery.png', width: 28)),
                    Positioned(left: w * 0.75, top: 350, child: Image.asset('assets/images/treasure_chest.png', width: 48)),
                    Positioned(left: cx1 - 42, top: cy1 - 10, child: Image.asset('assets/images/flags.png', width: 36)),
                    Positioned(left: cx10 + 20, top: cy10 + 10, child: Image.asset('assets/images/flags.png', width: 36)),

                    // NODE 1
                    if (progress.currentModuleIndex == 1)
                      Positioned(left: cx1 - 35, top: cy1 - 55, child: const CurrentMapNode(moduleNum: 1))
                    else
                      Positioned(
                        left: cx1 - 27,
                        top: cy1 - 27,
                        child: MapNode(
                          number: '1',
                          state: progress.isModule1Completed ? NodeState.completed : NodeState.active,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoTeachingScreen())).then((_) => setState(() {}));
                          },
                        ),
                      ),

                    // NODE 2
                    if (progress.currentModuleIndex == 2)
                      Positioned(left: cx2 - 35, top: cy2 - 55, child: const CurrentMapNode(moduleNum: 2))
                    else
                      Positioned(
                        left: cx2 - 27,
                        top: cy2 - 27,
                        child: MapNode(
                          number: '2',
                          state: progress.isModule2Completed ? NodeState.completed : (progress.isModule1Completed ? NodeState.active : NodeState.locked),
                          onTap: progress.isModule1Completed ? () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const Module2DragDropGameScreen())).then((_) => setState(() {}));
                          } : () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Module 2 is locked! Complete Module 1 first.')));
                          },
                        ),
                      ),

                    // NODE 3
                    if (progress.currentModuleIndex == 3)
                      Positioned(left: cx3 - 35, top: cy3 - 55, child: const CurrentMapNode(moduleNum: 3))
                    else
                      Positioned(
                        left: cx3 - 27,
                        top: cy3 - 27,
                        child: MapNode(
                          number: '3',
                          state: progress.completedModulesCount >= 3 ? NodeState.completed : (progress.completedModulesCount == 2 ? NodeState.active : NodeState.locked),
                        ),
                      ),

                    // NODE 4
                    if (progress.currentModuleIndex == 4)
                      Positioned(left: cx4 - 35, top: cy4 - 55, child: const CurrentMapNode(moduleNum: 4))
                    else
                      Positioned(
                        left: cx4 - 27,
                        top: cy4 - 27,
                        child: MapNode(
                          number: '4',
                          state: progress.completedModulesCount >= 4 ? NodeState.completed : (progress.completedModulesCount == 3 ? NodeState.active : NodeState.locked),
                        ),
                      ),

                    // NODE 5
                    if (progress.currentModuleIndex == 5)
                      Positioned(left: cx5 - 35, top: cy5 - 55, child: const CurrentMapNode(moduleNum: 5))
                    else
                      Positioned(
                        left: cx5 - 27,
                        top: cy5 - 27,
                        child: MapNode(
                          number: '5',
                          state: progress.completedModulesCount >= 5 ? NodeState.completed : (progress.completedModulesCount == 4 ? NodeState.active : NodeState.locked),
                        ),
                      ),

                    // NODE 6
                    if (progress.currentModuleIndex == 6)
                      Positioned(left: cx6 - 35, top: cy6 - 55, child: const CurrentMapNode(moduleNum: 6))
                    else
                      Positioned(
                        left: cx6 - 27,
                        top: cy6 - 27,
                        child: MapNode(
                          number: '6',
                          state: progress.completedModulesCount >= 6 ? NodeState.completed : (progress.completedModulesCount == 5 ? NodeState.active : NodeState.locked),
                        ),
                      ),

                    // NODE 7
                    if (progress.currentModuleIndex == 7)
                      Positioned(left: cx7 - 35, top: cy7 - 55, child: const CurrentMapNode(moduleNum: 7))
                    else
                      Positioned(
                        left: cx7 - 27,
                        top: cy7 - 27,
                        child: MapNode(
                          number: '7',
                          state: progress.completedModulesCount >= 7 ? NodeState.completed : (progress.completedModulesCount == 6 ? NodeState.active : NodeState.locked),
                        ),
                      ),

                    // NODE 8
                    if (progress.currentModuleIndex == 8)
                      Positioned(left: cx8 - 35, top: cy8 - 55, child: const CurrentMapNode(moduleNum: 8))
                    else
                      Positioned(
                        left: cx8 - 27,
                        top: cy8 - 27,
                        child: MapNode(
                          number: '8',
                          state: progress.completedModulesCount >= 8 ? NodeState.completed : (progress.completedModulesCount == 7 ? NodeState.active : NodeState.locked),
                        ),
                      ),

                    // NODE 9
                    if (progress.currentModuleIndex == 9)
                      Positioned(left: cx9 - 35, top: cy9 - 55, child: const CurrentMapNode(moduleNum: 9))
                    else
                      Positioned(
                        left: cx9 - 27,
                        top: cy9 - 27,
                        child: MapNode(
                          number: '9',
                          state: progress.completedModulesCount >= 9 ? NodeState.completed : (progress.completedModulesCount == 8 ? NodeState.active : NodeState.locked),
                        ),
                      ),

                    // NODE 10 (Finish)
                    if (progress.currentModuleIndex == 10)
                      Positioned(left: cx10 - 35, top: cy10 - 55, child: const CurrentMapNode(moduleNum: 10))
                    else
                      Positioned(
                        left: cx10 - 27,
                        top: cy10 - 27,
                        child: MapNode(
                          number: '10',
                          state: progress.completedModulesCount == 10 ? NodeState.completed : NodeState.finish,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================================
  // MAIN BODY TAB VIEWS (Home, My Journey, Arena, Rewards, Profile)
  // =============================================================================
  Widget _buildHomeContent(bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          _buildStatBadges(),
          const SizedBox(height: 20),
          _buildJourneyBanner(),
          const SizedBox(height: 20),
          _buildLevelTabs(),
          if (_selectedLevelIndex == 1) ...[
            const SizedBox(height: 20),
            _buildMapArea(),
          ],
        ],
      ),
    );
  }

  Widget _buildJourneyContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          Text('My Learning Journey 🗺️', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryRed)),
          const SizedBox(height: 6),
          const Text('Track your financial literacy milestones from Grade 8 to Grade 12.', style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 20),
          _buildJourneyBanner(),
          const SizedBox(height: 20),
          _buildMapArea(),
        ],
      ),
    );
  }

  Widget _buildArenaContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          Text('Arena (Games) 🎮', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryRed)),
          const SizedBox(height: 6),
          const Text('Test your financial decision-making in real-time interactive games!', style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 20),

          _buildGameHubCard(
            title: 'Module 1: Bazaar Survival',
            subtitle: 'Navigate impulse traps & master budget decisions in the market.',
            badge: AppProgressManager.instance.isModule1Completed ? 'COMPLETED • 100 PTS' : 'ACTIVE NOW • 100 PTS',
            badgeColor: AppProgressManager.instance.isModule1Completed ? Colors.green : primaryRed,
            icon: Icons.storefront,
            buttonText: AppProgressManager.instance.isModule1Completed ? 'Play Again' : 'Play Game Now',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoTeachingScreen()));
            },
          ),
          const SizedBox(height: 16),

          _buildGameHubCard(
            title: 'Module 2: Unavoidable vs. Avoidable',
            subtitle: 'Drag 12 expense items into Unavoidable vs. Avoidable baskets!',
            badge: AppProgressManager.instance.isModule1Completed 
                   ? (AppProgressManager.instance.isModule2Completed ? 'COMPLETED • 500 PTS' : 'ACTIVE NOW • 500 PTS') 
                   : 'LOCKED • COMPLETE MOD 1',
            badgeColor: AppProgressManager.instance.isModule1Completed 
                        ? (AppProgressManager.instance.isModule2Completed ? Colors.green : primaryRed) 
                        : Colors.grey,
            icon: Icons.sports_esports,
            buttonText: AppProgressManager.instance.isModule1Completed 
                        ? (AppProgressManager.instance.isModule2Completed ? 'Play Again' : 'Play Game Now') 
                        : 'Locked',
            isLocked: !AppProgressManager.instance.isModule1Completed,
            onTap: AppProgressManager.instance.isModule1Completed ? () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Module2DragDropGameScreen()));
            } : null,
          ),
          const SizedBox(height: 16),

          _buildGameHubCard(
            title: 'Module 2 Home Task: Family Budget',
            subtitle: 'Calculate household percentages & evaluate Ramesh family budget.',
            badge: AppProgressManager.instance.isModule1Completed ? 'PRACTICE TASK' : 'LOCKED',
            badgeColor: AppProgressManager.instance.isModule1Completed ? Colors.blue : Colors.grey,
            icon: Icons.calculate,
            buttonText: AppProgressManager.instance.isModule1Completed ? 'Open Calculator' : 'Locked',
            isLocked: !AppProgressManager.instance.isModule1Completed,
            onTap: AppProgressManager.instance.isModule1Completed ? () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Module2HomeTaskScreen()));
            } : null,
          ),
          const SizedBox(height: 16),

          _buildGameHubCard(
            title: 'Module 3: Budgeting Battle',
            subtitle: 'Master income allocation & savings goals against rival AI.',
            badge: 'LOCKED • UNLOCKS AT LEVEL 2',
            badgeColor: Colors.grey,
            icon: Icons.lock,
            buttonText: 'Locked',
            isLocked: true,
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildGameHubCard({
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required String buttonText,
    required VoidCallback? onTap,
    bool isLocked = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isLocked ? Colors.grey.shade300 : primaryRed.withOpacity(0.3)),
        boxShadow: isLocked ? [] : [BoxShadow(color: primaryRed.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: badgeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isLocked ? Colors.grey.shade300 : faintRed,
                child: Icon(icon, color: isLocked ? Colors.grey.shade600 : primaryRed, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isLocked ? Colors.grey : Colors.black87)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLocked ? Colors.grey.shade400 : primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onTap,
              child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          Text('Rewards & Badges 🎁', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryRed)),
          const SizedBox(height: 6),
          const Text('Redeem your DyRa Points for exclusive avatar outfits & trophies!', style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryRed, Colors.redAccent.shade700]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Points', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    SizedBox(height: 4),
                    Text('⭐ 450 DyRa Points', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: primaryRed),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎉 Claimed 50 Bonus DyRa Points for daily check-in!')));
                  },
                  child: const Text('Claim Bonus', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Earned Badges', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBadgeItem('Bazaar Pioneer', '🏆', 'Completed Bazaar Survival', true),
              const SizedBox(width: 12),
              _buildBadgeItem('Needs Master', '⭐', '100% Score in Needs vs Wants', true),
              const SizedBox(width: 12),
              _buildBadgeItem('Budget Pro', '🎖️', 'Unlocked at Level 2', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String title, String emoji, String desc, bool isUnlocked) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? faintRed : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isUnlocked ? primaryRed.withOpacity(0.3) : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Opacity(
              opacity: isUnlocked ? 1.0 : 0.4,
              child: Text(emoji, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isUnlocked ? primaryRed : Colors.grey)),
            const SizedBox(height: 4),
            Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    final progress = AppProgressManager.instance;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: faintRed,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primaryRed.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: primaryRed,
                  child: const CircleAvatar(
                    radius: 34,
                    backgroundImage: AssetImage('assets/images/mascot.png'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ananya Sharma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryRed)),
                      const Text('Grade 8 • Level 1 Explorer', style: TextStyle(color: Colors.black87, fontSize: 13)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: primaryRed, borderRadius: BorderRadius.circular(10)),
                        child: const Text('🔥 12 Day Streak', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Performance Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildProfileStatRow('Modules Completed', '${progress.completedModulesCount} / 10 Modules', Icons.school),
          _buildProfileStatRow('Total Learning Score', '1,250 Points', Icons.stars),
          _buildProfileStatRow('DyRa Rewards Points', '450 DyRa Points', Icons.monetization_on),
          _buildProfileStatRow('Concept Mastery Rate', '95% Accuracy', Icons.trending_up),
        ],
      ),
    );
  }

  Widget _buildProfileStatRow(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: faintRed, child: Icon(icon, color: primaryRed, size: 18)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: primaryRed, fontSize: 13)),
        ],
      ),
    );
  }

  // =============================================================================
  // NAVIGATION DRAWER (MATCHING USER SCREENSHOT media_1787760313766.png)
  // =============================================================================
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // RED CURVED HEADER WITH PROFILE & STREAK / POINTS FLOATING CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 48, bottom: 20, left: 16, right: 16),
            decoration: BoxDecoration(
              color: primaryRed,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                  ),
                  child: ClipOval(
                    child: Image.asset('assets/images/mascot.png', fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 10),
                // Name
                const Text(
                  'Ananya',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Level 1 - Explorer',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),

                // Streak & DyRa Points White Floating Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Streak
                      Expanded(
                        child: Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('12', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                Text('Day Streak', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 28, color: Colors.grey.shade300),
                      // DyRa Points
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('450', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                Text('DyRa Points', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // DRAWER NAVIGATION ITEMS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              children: [
                // 1. HOME
                _buildDrawerTile(
                  icon: Icons.home,
                  title: 'Home',
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 0);
                  },
                ),
                // 2. MY JOURNEY
                _buildDrawerTile(
                  icon: Icons.map_outlined,
                  title: 'My Journey',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 1);
                  },
                ),
                // 3. ARENA (GAMES)
                _buildDrawerTile(
                  icon: Icons.sports_esports_outlined,
                  title: 'Arena (Games)',
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 2);
                  },
                ),
                // 4. LEADERBOARD
                _buildDrawerTile(
                  icon: Icons.bar_chart_outlined,
                  title: 'Leaderboard',
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    _showLeaderboardModal(context);
                  },
                ),
                // 5. REWARDS
                _buildDrawerTile(
                  icon: Icons.card_giftcard_outlined,
                  title: 'Rewards',
                  isSelected: _selectedIndex == 3,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 3);
                  },
                ),
                // 6. PROFILE
                _buildDrawerTile(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  isSelected: _selectedIndex == 4,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 4);
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Divider(),
                ),

                // 7. SETTINGS
                _buildDrawerTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    _showSettingsModal(context);
                  },
                ),
                // 8. HELP & SUPPORT
                _buildDrawerTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    _showHelpSupportModal(context);
                  },
                ),
                // 9. ABOUT DYRA
                _buildDrawerTile(
                  icon: Icons.info_outline,
                  title: 'About DyRa',
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDyRaModal(context);
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Divider(),
                ),

                // 10. LOGOUT
                _buildDrawerTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  isSelected: false,
                  iconColor: primaryRed,
                  textColor: primaryRed,
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? faintRed : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: iconColor ?? (isSelected ? primaryRed : Colors.black87), size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? (isSelected ? primaryRed : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout, color: primaryRed),
            const SizedBox(width: 10),
            const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('Are you sure you want to log out of your student account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // =============================================================================
  // MODAL DIALOGS / PAGES FOR NON-TAB ITEMS
  // =============================================================================
  
  // LEADERBOARD MODAL
  void _showLeaderboardModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Leaderboard 📊', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryRed)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildLeaderTile(1, 'Ananya (You)', '1,250 pts', '🥇 Gold Medal', true),
                  _buildLeaderTile(2, 'Rohan Sharma', '1,180 pts', '🥈 Silver Medal', false),
                  _buildLeaderTile(3, 'Priya Singh', '1,050 pts', '🥉 Bronze Medal', false),
                  _buildLeaderTile(4, 'Aarav Kumar', '980 pts', 'Top 5', false),
                  _buildLeaderTile(5, 'Diya Verma', '920 pts', 'Top 5', false),
                  _buildLeaderTile(6, 'Kabir Mehta', '850 pts', 'Top 10', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderTile(int rank, String name, String score, String badge, bool isUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? faintRed : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isUser ? primaryRed : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isUser ? primaryRed : Colors.grey.shade300,
            child: Text('$rank', style: TextStyle(color: isUser ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Text(name, style: TextStyle(fontWeight: isUser ? FontWeight.bold : FontWeight.w600, fontSize: 14, color: isUser ? primaryRed : Colors.black87)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(score, style: TextStyle(fontWeight: FontWeight.bold, color: primaryRed, fontSize: 13)),
              Text(badge, style: const TextStyle(fontSize: 10, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  // SETTINGS MODAL
  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('App Settings ⚙️', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryRed)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    SwitchListTile(
                      activeColor: primaryRed,
                      title: const Text('Sound Effects & Waveform FX', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Enable audio visualizer & sound effects'),
                      value: _soundFxEnabled,
                      onChanged: (val) {
                        setModalState(() => _soundFxEnabled = val);
                        setState(() => _soundFxEnabled = val);
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      activeColor: primaryRed,
                      title: const Text('DyRa Voice Companion', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Enable voice guidance during modules'),
                      value: _voiceGuidanceEnabled,
                      onChanged: (val) {
                        setModalState(() => _voiceGuidanceEnabled = val);
                        setState(() => _voiceGuidanceEnabled = val);
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      activeColor: primaryRed,
                      title: const Text('Daily Study Reminders', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Get notified to keep your day streak active'),
                      value: _dailyRemindersEnabled,
                      onChanged: (val) {
                        setModalState(() => _dailyRemindersEnabled = val);
                        setState(() => _dailyRemindersEnabled = val);
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      activeColor: primaryRed,
                      title: const Text('Dark Mode Theme', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Toggle dark aesthetic for night learning'),
                      value: _darkModeEnabled,
                      onChanged: (val) {
                        setModalState(() => _darkModeEnabled = val);
                        setState(() => _darkModeEnabled = val);
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: primaryRed,
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset All Learning Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        setState(() {
                          AppProgressManager.instance.completedModulesCount = 1;
                          AppProgressManager.instance.currentModuleIndex = 2;
                          AppProgressManager.instance.isModule1Completed = true;
                          AppProgressManager.instance.isModule2Completed = false;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('App progress has been reset to Module 1.')));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // HELP & SUPPORT MODAL
  void _showHelpSupportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Help & Support ❓', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryRed)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    title: const Text('How do I earn DyRa Points?', style: TextStyle(fontWeight: FontWeight.bold)),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Complete modules, score 100% in test sessions, and maintain your daily study streak!'),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('What is the difference between Unavoidable & Avoidable expenses?', style: TextStyle(fontWeight: FontWeight.bold)),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Unavoidable expenses are essential needs like rent, school fees, and food. Avoidable expenses are wants like eating out weekly or buying expensive shoes.'),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('How do I unlock Level 2 Planner?', style: TextStyle(fontWeight: FontWeight.bold)),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Complete all 10 Level 1 Explorer modules to automatically unlock Level 2 Planner!'),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.headset_mic),
                    label: const Text('Contact Support Team', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📩 Support request sent! DyRa team will contact you shortly.')));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ABOUT DYRA MODAL
  void _showAboutDyRaModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 40,
              backgroundColor: faintRed,
              child: CircleAvatar(
                radius: 36,
                backgroundImage: const AssetImage('assets/images/mascot.png'),
              ),
            ),
            const SizedBox(height: 12),
            Text('DyRa Financial Literacy App', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryRed)),
            const Text('Version 1.2.0 (All-in-One Edition)', style: TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 16),
            const Text(
              'DyRa is designed to empower students across Grades 8–12 with practical financial literacy skills. Learn budgeting, expense classification, saving strategies, and smart spending through fun, interactive games and AI companion guidance.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================================
  // MAIN SCAFFOLD BUILD
  // =============================================================================
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppProgressManager.instance,
      builder: (context, child) {
        Widget currentBody;
        switch (_selectedIndex) {
          case 0:
            currentBody = _buildHomeContent(true);
            break;
          case 1:
            currentBody = _buildJourneyContent();
            break;
          case 2:
            currentBody = _buildArenaContent();
            break;
          case 3:
            currentBody = _buildRewardsContent();
            break;
          case 4:
            currentBody = _buildProfileContent();
            break;
          default:
            currentBody = _buildHomeContent(true);
        }

        return Scaffold(
          backgroundColor: Colors.white,
          drawer: _buildDrawer(),
          body: SafeArea(child: currentBody),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (i) => setState(() => _selectedIndex = i),
            selectedItemColor: primaryRed,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'My Journey'),
              BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Arena'),
              BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Rewards'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}

enum NodeState { locked, completed, active, finish }

class MapNode extends StatelessWidget {
  final String number;
  final NodeState state;
  final VoidCallback? onTap;

  const MapNode({super.key, required this.number, required this.state, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (state == NodeState.completed || state == NodeState.active) {
      bgColor = const Color(0xFFDA251D);
      textColor = Colors.white;
    } else if (state == NodeState.finish) {
      bgColor = Colors.white;
      textColor = Colors.black54;
    } else {
      bgColor = Colors.grey.shade200;
      textColor = Colors.black54;
    }

    return GestureDetector(
      onTap: onTap ?? () {
        if (number == '2') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const Module2DragDropGameScreen()));
        } else if (state == NodeState.completed || state == NodeState.active) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoTeachingScreen()));
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: state == NodeState.finish ? Colors.grey.shade300 : Colors.white, width: 3),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Center(
              child: state == NodeState.locked
                  ? const Icon(Icons.lock, color: Colors.black54, size: 20)
                  : Text(number, style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
          if (state == NodeState.completed)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ),
        ],
      ),
    );
  }
}

class CurrentMapNode extends StatelessWidget {
  final int moduleNum;
  const CurrentMapNode({super.key, this.moduleNum = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDA251D),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: const Text('You are here', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const Icon(Icons.arrow_drop_down, color: Color(0xFFDA251D), size: 20),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDA251D), width: 3),
            boxShadow: [BoxShadow(color: const Color(0xFFDA251D).withOpacity(0.3), blurRadius: 10, spreadRadius: 2)],
          ),
          child: ClipOval(child: Image.asset('assets/images/mystery_box.png', fit: BoxFit.cover)),
        ),
        const SizedBox(height: 4),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDA251D),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            if (moduleNum == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Module2DragDropGameScreen()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoTeachingScreen()));
            }
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              SizedBox(width: 2),
              Icon(Icons.arrow_forward, size: 12),
            ],
          ),
        )
      ],
    );
  }
}

class DottedPathPainterMobile extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFFDA251D).withOpacity(0.4)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    var path = Path();
    double w = size.width;

    // Standardized Center Coordinates (Matching Stack Position math)
    Offset p1 = Offset(w * 0.18, 140);
    Offset p2 = Offset(w * 0.50, 90);
    Offset p3 = Offset(w * 0.82, 130);
    Offset p4 = Offset(w * 0.82, 230);
    Offset p5 = Offset(w * 0.50, 260);
    Offset p6 = Offset(w * 0.18, 300);
    Offset p7 = Offset(w * 0.18, 400);
    Offset p8 = Offset(w * 0.50, 430);
    Offset p9 = Offset(w * 0.82, 430);
    Offset p10 = Offset(w * 0.50, 500);

    path.moveTo(p1.dx, p1.dy);
    // P1 -> P2
    path.cubicTo((p1.dx + p2.dx) / 2, p1.dy - 20, (p1.dx + p2.dx) / 2, p2.dy + 20, p2.dx, p2.dy);
    // P2 -> P3
    path.cubicTo((p2.dx + p3.dx) / 2, p2.dy + 20, (p2.dx + p3.dx) / 2, p3.dy - 20, p3.dx, p3.dy);
    // P3 -> P4
    path.cubicTo(p3.dx + 20, (p3.dy + p4.dy) / 2, p4.dx + 20, (p3.dy + p4.dy) / 2, p4.dx, p4.dy);
    // P4 -> P5
    path.cubicTo((p4.dx + p5.dx) / 2, p4.dy + 20, (p4.dx + p5.dx) / 2, p5.dy - 20, p5.dx, p5.dy);
    // P5 -> P6
    path.cubicTo((p5.dx + p6.dx) / 2, p5.dy + 20, (p5.dx + p6.dx) / 2, p6.dy - 20, p6.dx, p6.dy);
    // P6 -> P7
    path.cubicTo(p6.dx - 20, (p6.dy + p7.dy) / 2, p7.dx - 20, (p6.dy + p7.dy) / 2, p7.dx, p7.dy);
    // P7 -> P8
    path.cubicTo((p7.dx + p8.dx) / 2, p7.dy + 20, (p7.dx + p8.dx) / 2, p8.dy - 20, p8.dx, p8.dy);
    // P8 -> P9
    path.cubicTo((p8.dx + p9.dx) / 2, p8.dy, (p8.dx + p9.dx) / 2, p9.dy, p9.dx, p9.dy);
    // P9 -> P10
    path.cubicTo(p9.dx + 10, (p9.dy + p10.dy) / 2, (p9.dx + p10.dx) / 2, p10.dy - 20, p10.dx, p10.dy);

    double dashWidth = 8, dashSpace = 6, distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(pathMetric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
