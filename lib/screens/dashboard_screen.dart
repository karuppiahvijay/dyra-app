import 'package:flutter/material.dart';
import 'dart:ui';
import 'module_screens.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1; // Default to 'My Journey'

  Widget _buildTopBar(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
              const Expanded(
                child: Text('Hi, Ananya! 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const CircleAvatar(radius: 20, backgroundColor: Colors.red, child: Icon(Icons.person, color: Colors.white)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 48.0, bottom: 16.0),
            child: Text('Let\'s continue your learning journey.', style: TextStyle(color: Colors.grey)),
          ),
          Row(
            children: [
              Expanded(child: _buildStatBadge(Icons.local_fire_department, Colors.orange, '12', 'Day Streak')),
              const SizedBox(width: 8),
              Expanded(child: _buildStatBadge(Icons.star, Colors.amber, '450', 'DyRa Points')),
            ],
          ),
        ],
      );
    }
    
    // Desktop layout
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, Ananya! 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Let\'s continue your learning journey.', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        _buildStatBadge(Icons.local_fire_department, Colors.orange, '12', 'Day Streak'),
        const SizedBox(width: 8),
        _buildStatBadge(Icons.star, Colors.amber, '450', 'DyRa Points'),
        const SizedBox(width: 16),
        const CircleAvatar(radius: 20, backgroundColor: Colors.red, child: Icon(Icons.person, color: Colors.white)),
      ],
    );
  }

  Widget _buildStatBadge(IconData icon, Color iconColor, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLevelTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildLevelCard('Level 1', 'Explorer', Icons.explore, true),
          _buildLevelCard('Level 2', 'Planner', Icons.calendar_month, false),
          _buildLevelCard('Level 3', 'Investor', Icons.monetization_on, false),
          _buildLevelCard('Level 4', 'Wealth Builder', Icons.trending_up, false),
          _buildLevelCard('Level 5', 'Money Master', Icons.emoji_events, false),
        ],
      ),
    );
  }

  Widget _buildLevelCard(String level, String title, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF0F8FF) : Colors.white,
        border: Border.all(color: isActive ? const Color(0xFF6C5CE7) : Colors.grey.shade200, width: isActive ? 2 : 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: isActive ? Colors.white : Colors.grey.shade100, child: Icon(icon, color: isActive ? const Color(0xFF00B4D8) : Colors.grey)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(level, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? const Color(0xFF6C5CE7) : Colors.black)),
              Text(title, style: TextStyle(color: isActive ? Colors.black : Colors.grey)),
            ],
          ),
          if (!isActive) ...[
            const SizedBox(width: 16),
            const Icon(Icons.lock, size: 16, color: Colors.grey),
          ]
        ],
      ),
    );
  }

  Widget _buildMapArea() {
    return Container(
      width: 1200,
      height: 400,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Dotted line for 10 nodes
          Positioned.fill(child: CustomPaint(painter: DottedPathPainter10Nodes())),
          
          // Scenery and flags
          Positioned(left: 20, top: 220, child: Image.asset('assets/images/flags.png', width: 60)), // Start Flag
          Positioned(left: 1050, top: 250, child: Image.asset('assets/images/flags.png', width: 60)), // End Flag
          Positioned(left: 1000, top: 150, child: Image.asset('assets/images/treasure_chest.png', width: 80)), // Treasure
          Positioned(left: 300, top: 250, child: Image.asset('assets/images/scenery.png', width: 40)), // Scenery 1
          Positioned(left: 700, top: 100, child: Image.asset('assets/images/scenery.png', width: 40)), // Scenery 2
          Positioned(left: 900, top: 300, child: Image.asset('assets/images/scenery.png', width: 40)), // Scenery 3

          // Progress Circle (Top Left)
          Positioned(
            left: 30, top: 30,
            child: Container(
              width: 100, height: 100,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('2/10', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7))),
                    Text('Modules\nCompleted', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),

          // Nodes
          const Positioned(left: 150, top: 200, child: MapNode(number: '1', state: NodeState.completed)),
          const Positioned(left: 300, top: 120, child: CurrentMapNode()),
          const Positioned(left: 450, top: 160, child: MapNode(number: '3', state: NodeState.locked)),
          const Positioned(left: 600, top: 180, child: MapNode(number: '4', state: NodeState.locked)),
          const Positioned(left: 750, top: 150, child: MapNode(number: '5', state: NodeState.locked)),
          const Positioned(left: 150, top: 300, child: MapNode(number: '6', state: NodeState.locked)),
          const Positioned(left: 350, top: 300, child: MapNode(number: '7', state: NodeState.locked)),
          const Positioned(left: 550, top: 300, child: MapNode(number: '8', state: NodeState.locked)),
          const Positioned(left: 750, top: 300, child: MapNode(number: '9', state: NodeState.locked)),
          const Positioned(left: 950, top: 280, child: MapNode(number: '10', state: NodeState.locked)),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text('DyRa', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7))),
          const Text('Financial Literacy\nfor Young Minds', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF00B4D8), fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildSidebarItem(Icons.home, 'Home', 0),
          _buildSidebarItem(Icons.map, 'My Journey', 1),
          _buildSidebarItem(Icons.sports_esports, 'Arena (Games)', 2),
          _buildSidebarItem(Icons.leaderboard, 'Leaderboard', 3),
          _buildSidebarItem(Icons.card_giftcard, 'Rewards', 4),
          _buildSidebarItem(Icons.person, 'Profile', 5),
          const Spacer(),
          // Mascot Image
          SizedBox(
            height: 150,
            child: Image.asset('assets/images/mascot.png', fit: BoxFit.contain),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(16)),
            child: const Text('Every smart money decision today builds your wealthy tomorrow. ✨', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black54),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyScreen(bool isDesktop) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(!isDesktop),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map, color: Color(0xFF00B4D8), size: 32),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Journey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('You are in Level 1 - Explorer', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: isDesktop ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  const Text('Overall Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 150,
                        height: 8,
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(width: 30, height: 8, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4))),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('20%', style: TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          _buildLevelTabs(),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildMapArea(),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF5F6FA), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.orange, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontFamily: 'Nunito'),
                      children: [
                        TextSpan(text: 'Complete all '),
                        TextSpan(text: '10 modules', style: TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.bold)),
                        TextSpan(text: ' in this level to\nunlock exciting rewards and next level!'),
                      ],
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('View Rewards'),
                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF6C5CE7), side: const BorderSide(color: Color(0xFF6C5CE7))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaceholderScreen(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 16),
          const Text('Coming soon...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    Widget bodyContent;
    switch (_selectedIndex) {
      case 0:
        bodyContent = _buildPlaceholderScreen('Home');
        break;
      case 1:
        bodyContent = _buildJourneyScreen(isDesktop);
        break;
      case 2:
        bodyContent = _buildPlaceholderScreen('Arena (Games)');
        break;
      case 3:
        bodyContent = _buildPlaceholderScreen('Leaderboard');
        break;
      case 4:
        bodyContent = _buildPlaceholderScreen('Rewards');
        break;
      case 5:
        bodyContent = _buildPlaceholderScreen('Profile');
        break;
      default:
        bodyContent = _buildPlaceholderScreen('Not Found');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(),
          if (isDesktop) const VerticalDivider(width: 1, color: Colors.black12),
          Expanded(child: SafeArea(child: bodyContent)),
        ],
      ),
      bottomNavigationBar: !isDesktop ? BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: const Color(0xFF6C5CE7),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Journey'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Arena'),
        ],
      ) : null,
    );
  }
}

enum NodeState { completed, current, locked }

class MapNode extends StatelessWidget {
  final String number;
  final NodeState state;
  const MapNode({super.key, required this.number, required this.state});

  @override
  Widget build(BuildContext context) {
    Color bgColor = state == NodeState.completed ? Colors.green : Colors.grey.shade300;
    Color textColor = state == NodeState.completed ? Colors.white : Colors.black54;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Center(
            child: state == NodeState.locked 
              ? const Icon(Icons.lock, color: Colors.black54, size: 32)
              : Text(number, style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold)),
          ),
        ),
        if (state == NodeState.completed)
          Positioned(
            bottom: -5,
            right: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2))),
              child: const Icon(Icons.check, color: Colors.white, size: 24),
            ),
          )
      ],
    );
  }
}

class CurrentMapNode extends StatelessWidget {
  const CurrentMapNode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFF6C5CE7), borderRadius: BorderRadius.circular(20)),
          child: const Text('You are here', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const Icon(Icons.arrow_drop_down, color: Color(0xFF6C5CE7)),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF6C5CE7), width: 4),
            boxShadow: [BoxShadow(color: const Color(0xFF6C5CE7).withOpacity(0.3), blurRadius: 16, spreadRadius: 4)],
          ),
          child: ClipOval(child: Image.asset('assets/images/mystery_box.png', fit: BoxFit.cover)),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C5CE7), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ModuleIntroScreen()));
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Continue', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        )
      ],
    );
  }
}

class DottedPathPainter10Nodes extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
      
    var path = Path();
    path.moveTo(150, 240); // Node 1
    path.quadraticBezierTo(225, 200, 300, 160); // Node 2
    path.quadraticBezierTo(375, 140, 450, 200); // Node 3
    path.quadraticBezierTo(525, 250, 600, 220); // Node 4
    path.quadraticBezierTo(675, 180, 750, 190); // Node 5
    path.quadraticBezierTo(800, 250, 750, 340); // Curve back
    path.quadraticBezierTo(650, 380, 550, 340); // Node 8
    path.quadraticBezierTo(450, 300, 350, 340); // Node 7
    path.quadraticBezierTo(250, 380, 150, 340); // Node 6
    // Draw it simply to connect the coords of the nodes.
    // Re-adjusting the path to actually match the hardcoded node positions above...
    path.reset();
    path.moveTo(190, 240); // Node 1 (left 150)
    path.lineTo(320, 160); // Node 2 (left 300)
    path.lineTo(490, 200); // Node 3 (left 450)
    path.lineTo(640, 220); // Node 4 (left 600)
    path.lineTo(790, 190); // Node 5 (left 750)
    path.lineTo(990, 320); // Node 10 (left 950) - let's just make it a curvy snake!
    
    // Smooth snake
    path.reset();
    path.moveTo(190, 240); // N1
    path.quadraticBezierTo(250, 150, 330, 160); // N2
    path.quadraticBezierTo(400, 160, 480, 200); // N3
    path.quadraticBezierTo(560, 240, 630, 220); // N4
    path.quadraticBezierTo(710, 190, 790, 190); // N5
    path.quadraticBezierTo(850, 190, 850, 270); // Curve down
    path.quadraticBezierTo(850, 340, 790, 340); // N9
    path.quadraticBezierTo(700, 340, 590, 340); // N8
    path.quadraticBezierTo(500, 340, 390, 340); // N7
    path.quadraticBezierTo(300, 340, 190, 340); // N6
    
    // Draw dashed path
    double dashWidth = 10, dashSpace = 8;
    double distance = 0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(pathMetric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
