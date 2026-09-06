import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../widgets/dyra_avatar.dart';
import '../widgets/dyra_animated_widget.dart';
import 'dashboard_screen.dart' as dashboard;

// -----------------------------------------------------------------------------
// Video Teaching Screen (Unskippable)
// -----------------------------------------------------------------------------
class VideoTeachingScreen extends StatefulWidget {
  const VideoTeachingScreen({super.key});

  @override
  State<VideoTeachingScreen> createState() => _VideoTeachingScreenState();
}

class _VideoTeachingScreenState extends State<VideoTeachingScreen> {
  late VideoPlayerController _controller;
  bool _isError = false;
  bool _showControls = true;
  bool _isFullscreen = false;
  bool _showCaptions = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/initial_video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((e) {
        setState(() { _isError = true; });
        print("Video load error: $e");
      });

    _controller.addListener(() {
      setState(() {}); // Update progress bar and captions
      if (_controller.value.isInitialized && 
          !_controller.value.isPlaying && 
          _controller.value.position >= _controller.value.duration) {
        _exitFullscreen();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StoryInteractiveScreen()),
        );
      }
    });
  }

  void _exitFullscreen() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
      if (_isFullscreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        _exitFullscreen();
      }
    });
  }

  void _seekRelative(int seconds) {
    final newPosition = _controller.value.position + Duration(seconds: seconds);
    _controller.seekTo(newPosition);
  }

  String _getCurrentCaption() {
    if (!_showCaptions) return "";
    final pos = _controller.value.position.inSeconds;
    if (pos >= 0 && pos < 5) return "Where am I?...";
    if (pos >= 5 && pos < 10) return "I lost everything in the bazaar...";
    if (pos >= 10 && pos < 15) return "I need to figure out how to survive the day.";
    if (pos >= 15 && pos < 20) return "It's getting crowded here.";
    if (pos >= 20) return "[Bustling market noises]";
    return "";
  }

  @override
  void dispose() {
    _exitFullscreen(); // Ensure we don't trap the user in landscape
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white54, size: 48),
              const SizedBox(height: 16),
              const Text("Video not found.\nPlease make sure 'bazaar_video.mp4' is placed inside the 'assets/videos/' folder!", 
                style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const StoryInteractiveScreen()),
                ),
                child: const Text("Skip Video for now"),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Player
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(color: Colors.red),
          ),
          
          // Captions Overlay
          if (_showCaptions && _controller.value.isInitialized)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    _getCurrentCaption(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          // Controls Overlay
          if (_controller.value.isInitialized)
            GestureDetector(
              onTap: () {
                setState(() => _showControls = !_showControls);
              },
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: Colors.black38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Center Playback Controls
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 50,
                              color: Colors.white,
                              icon: const Icon(Icons.replay_10),
                              onPressed: () => _seekRelative(-10),
                            ),
                            const SizedBox(width: 24),
                            IconButton(
                              iconSize: 70,
                              color: Colors.white,
                              icon: Icon(_controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                });
                              },
                            ),
                            const SizedBox(width: 24),
                            IconButton(
                              iconSize: 50,
                              color: Colors.white,
                              icon: const Icon(Icons.forward_10),
                              onPressed: () => _seekRelative(10),
                            ),
                          ],
                        ),
                      ),
                      // Bottom Toolbar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.black54,
                        child: Row(
                          children: [
                            Text(
                              "${_controller.value.position.inMinutes}:${(_controller.value.position.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            Expanded(
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                colors: const VideoProgressColors(playedColor: Colors.red, backgroundColor: Colors.white54),
                              ),
                            ),
                            Text(
                              "${_controller.value.duration.inMinutes}:${(_controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              color: _showCaptions ? Colors.red : Colors.white,
                              icon: const Icon(Icons.closed_caption),
                              onPressed: () => setState(() => _showCaptions = !_showCaptions),
                              tooltip: "Toggle Captions",
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(_isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
                              onPressed: _toggleFullscreen,
                              tooltip: "Toggle Fullscreen",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
          // Top Label (Only visible if controls are shown)
          if (_showControls)
            const Positioned(
              top: 40,
              left: 20,
              child: Text("Module 1: Bazaar Survival", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Data Models
// -----------------------------------------------------------------------------
class StoryQuestion {
  final int id;
  final String text;
  final String type; // 'open', 'mcq', 'budget'
  final List<String>? options;
  final String concept;
  final String avatarLine;

  StoryQuestion({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    required this.concept,
    required this.avatarLine,
  });
}

final List<StoryQuestion> storyQuestions = [
  StoryQuestion(
      id: 1,
      text: "You wake up in a strange place with nothing with you. What is the first thing you would worry about?",
      type: 'open',
      concept: "General awareness / immediate priorities",
      avatarLine: "Interesting thought. Let's see what happens next."),
  StoryQuestion(
      id: 2,
      text: "You have not eaten since morning. What will you do now?",
      type: 'open',
      concept: "Food",
      avatarLine: "Good thinking! Let's move on to the next step."),
  StoryQuestion(
      id: 3,
      text: "It's getting dark and you have no place to sleep. What is your plan?",
      type: 'open',
      concept: "Shelter",
      avatarLine: "Great plan! Let me show you what happens next."),
  StoryQuestion(
      id: 4,
      text: "Someone tells you there is a safe place to stay, but it is very far away. You need to reach it before dark. What would you do?",
      type: 'mcq',
      options: ["Start walking", "Ask someone for a lift", "Find a way to pay for transport", "Look for another safe option nearby"],
      concept: "Transport",
      avatarLine: "You've made your choice. Let's keep going."),
  StoryQuestion(
      id: 5,
      text: "You finally remember one person who can help you - but they are far away. How could you reach them?",
      type: 'open',
      concept: "Phone / communication as access",
      avatarLine: "Good idea! Let's follow that plan."),
  StoryQuestion(
      id: 6,
      text: "A shopkeeper says he will pay you if you help him load some boxes. What do you do?",
      type: 'mcq',
      options: ["Do the work", "Ask how much he will pay first", "Say no and look elsewhere", "Ask what work needs to be done"],
      concept: "Earning / effort for money",
      avatarLine: "That is a smart decision. Let's see where it takes you."),
  StoryQuestion(
      id: 7,
      text: "You finally earn Rs. 100. You cannot afford everything. What will you choose?",
      type: 'budget',
      concept: "First money decision / prioritization",
      avatarLine: "You've made your budget choices. Let's review the results."),
  StoryQuestion(
      id: 8,
      text: "After everything you faced today, which needs felt impossible to ignore - and why?",
      type: 'open',
      concept: "Closing reflection",
      avatarLine: "Wonderful reflection! You have completed this module."),
];

final List<String> genericFeedbackPool = [
  "Interesting choice - let's see what happens next.",
  "You're thinking it through - keep going.",
  "Let's follow that idea.",
  "Okay, let's see where that takes you.",
  "Let's find out what happens next.",
  "You've made your choice - let's continue.",
  "Good thinking - let's follow that idea.",
  "You've noticed something important - keep going.",
];

// -----------------------------------------------------------------------------
// Screens
// -----------------------------------------------------------------------------

class ModuleIntroScreen extends StatefulWidget {
  const ModuleIntroScreen({super.key});

  @override
  State<ModuleIntroScreen> createState() => _ModuleIntroScreenState();
}

class _ModuleIntroScreenState extends State<ModuleIntroScreen> {
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
                        const DyRaCompanion(state: DyRaState.entry),
                        const SizedBox(height: 32),
                          const Text('Module 1', style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Bazaar Survival', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          const Text('A boy loses his memory, money, and belongings in a busy bazaar and must figure out how to survive the day.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 48),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF6C5CE7), padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                            onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VideoTeachingScreen()),
      ),
                            child: const Text('Start Story', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

class StoryInteractiveScreen extends StatefulWidget {
  const StoryInteractiveScreen({super.key});

  @override
  State<StoryInteractiveScreen> createState() => _StoryInteractiveScreenState();
}

enum AssistantState { appearing, listening, hinting, reacting, guiding }

class _StoryInteractiveScreenState extends State<StoryInteractiveScreen> {
  int _currentIndex = 0;
  final TextEditingController _textController = TextEditingController();
  
  // Budget game state
  int _budget = 100;
  Map<String, int> _budgetItems = {
    "Food": 40,
    "Bus": 30,
    "Phone call/data": 10,
    "Safe place for the night": 50,
    "Fun item/snack": 30
  };
  List<String> _selectedBudgetItems = [];

  String _errorText = "";
  AssistantState _assistantState = AssistantState.appearing;
  Timer? _hintTimer;
  bool _isAnswerCorrect = true; // used to show green check vs red x (open ended is always true)
  
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
    _startAppearingSequence();
    _textController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  void _playSuccessChime() {
    try {
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  void _playErrorChime() {
    try {
      SystemSound.play(SystemSoundType.alert);
    } catch (_) {}
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  void _startAppearingSequence() {
    setState(() {
      _assistantState = AssistantState.appearing;
    });
    
    // Welcome sequence
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _assistantState = AssistantState.listening;
        });
        _startHintTimer();
      }
    });
  }

  void _safeSpeak(String text) {
    try {
      flutterTts.stop();
      flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS error: $e");
    }
  }

  void _startHintTimer() {
    _hintTimer?.cancel();
  }

  void _submitAnswer() {
    final currentQ = storyQuestions[_currentIndex];

    if (currentQ.type == 'open') {
      if (_textController.text.trim().isEmpty) {
        _playErrorChime();
        setState(() {
          _errorText = "Please enter your answer.";
        });
        _safeSpeak("Oh oo! Please enter your answer.");
        return;
      }
    } else if (currentQ.type == 'budget') {
      if (_selectedBudgetItems.isEmpty) {
        _playErrorChime();
        setState(() {
          _errorText = "Please select at least one item.";
        });
        _safeSpeak("Oh oo! Please select an item.");
        return;
      }
    }

    _hintTimer?.cancel();
    _playSuccessChime();

    setState(() {
      _errorText = "";
      _assistantState = AssistantState.reacting;
      _isAnswerCorrect = true;
    });
    
    _safeSpeak("Good! We move to next question.");

    // Auto-advance logic
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _assistantState = AssistantState.guiding);
      }
      
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _nextQuestion();
      });
    });
  }

  void _nextQuestion() {
    setState(() {
      _textController.clear();
      _selectedBudgetItems.clear();
      _budget = 100;
      
      if (_currentIndex < storyQuestions.length - 1) {
        _currentIndex++;
        _startAppearingSequence();
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SurvivalPouchScreen()));
      }
    });
  }

  Widget _buildOpenEnded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _textController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          enabled: _assistantState == AssistantState.listening || _assistantState == AssistantState.hinting,
          decoration: InputDecoration(
            hintText: "Type your answer...",
            hintStyle: const TextStyle(color: Colors.white38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFDA251D), width: 1.5),
            ),
            filled: true,
            fillColor: const Color(0xFF262424),
            errorText: _errorText.isNotEmpty ? _errorText : null,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 16),
        if (_assistantState == AssistantState.listening || _assistantState == AssistantState.hinting)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDA251D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            onPressed: _submitAnswer,
            child: const Text("Submit Answer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
      ],
    );
  }

  Widget _buildMCQ(List<String> options) {
    return Column(
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: (_assistantState == AssistantState.listening || _assistantState == AssistantState.hinting) ? _submitAnswer : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: (_assistantState != AssistantState.listening && _assistantState != AssistantState.hinting) 
                    ? const Color(0xFF1E1C1C) 
                    : const Color(0xFF262424),
                border: Border.all(color: const Color(0xFF383535)),
              ),
              child: Text(
                option, 
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBudgetGame() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A2B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
          ),
          child: Text(
            "Balance: Rs. $_budget", 
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent),
          ),
        ),
        const SizedBox(height: 16),
        ..._budgetItems.entries.map((e) {
          bool isSelected = _selectedBudgetItems.contains(e.key);
          bool canAfford = _budget >= e.value || isSelected;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF262424),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CheckboxListTile(
              title: Text(e.key, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text("Rs. ${e.value}", style: const TextStyle(color: Colors.white54)),
              value: isSelected,
              activeColor: const Color(0xFFDA251D),
              checkColor: Colors.white,
              onChanged: (canAfford && (_assistantState == AssistantState.listening || _assistantState == AssistantState.hinting)) ? (bool? val) {
                setState(() {
                  if (val == true) {
                    _selectedBudgetItems.add(e.key);
                    _budget -= e.value;
                  } else {
                    _selectedBudgetItems.remove(e.key);
                    _budget += e.value;
                  }
                });
              } : null,
            ),
          );
        }).toList(),
        if (_errorText.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(_errorText, style: const TextStyle(color: Colors.redAccent))),
        const SizedBox(height: 24),
        if (_assistantState == AssistantState.listening || _assistantState == AssistantState.hinting)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDA251D), 
              foregroundColor: Colors.white, 
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: _submitAnswer,
            child: const Text("Confirm Choices", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
      ],
    );
  }
  
  DyRaState _getDyRaState() {
    if ((_assistantState == AssistantState.listening || _assistantState == AssistantState.hinting) &&
        _textController.text.trim().isNotEmpty) {
      return DyRaState.typing;
    }
    switch (_assistantState) {
      case AssistantState.appearing: return DyRaState.entry;
      case AssistantState.listening: return DyRaState.listening;
      case AssistantState.hinting: return DyRaState.hint;
      case AssistantState.reacting: return DyRaState.reaction;
      case AssistantState.guiding: return DyRaState.encourage;
    }
  }



  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Level 1 - Explorer',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Text(
                'Exercise 1 of 10',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2727),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.star, color: Colors.amber, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStepProgress() {
    final int totalSteps = storyQuestions.length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(totalSteps, (index) {
          int stepNum = index + 1;
          bool isCurrent = stepNum == (_currentIndex + 1);
          bool isCompleted = stepNum < (_currentIndex + 1);

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent || isCompleted ? const Color(0xFFDA251D) : const Color(0xFF2A2727),
                    border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: const Color(0xFFDA251D).withOpacity(0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      "$stepNum",
                      style: TextStyle(
                        color: isCurrent || isCompleted ? Colors.white : Colors.white38,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                if (index < totalSteps - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted ? const Color(0xFFDA251D) : const Color(0xFF2A2727),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = storyQuestions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header (Level + Star)
            _buildHeader(),
            
            // Stepper (1 to 7)
            _buildStepProgress(),
            
            Expanded(
              child: Stack(
                children: [
                  // Main Question & Activity Content
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 280.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question ${_currentIndex + 1} of ${storyQuestions.length}",
                          style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                currentQ.text,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.volume_up_rounded, color: Color(0xFFDA251D), size: 28),
                              tooltip: "Listen to Question",
                              onPressed: () => _safeSpeak(currentQ.text),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (currentQ.type == 'open') _buildOpenEnded(),
                        if (currentQ.type == 'mcq') _buildMCQ(currentQ.options!),
                        if (currentQ.type == 'budget') _buildBudgetGame(),
                      ],
                    ),
                  ),
                  
                  // Bottom Avatar & Waveform Area
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      ignoring: false,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0xFF161515),
                              const Color(0xFF161515).withOpacity(0.9),
                              const Color(0xFF161515).withOpacity(0.0),
                            ],
                          ),
                        ),
                        child: DyRaCompanion(
                          state: _getDyRaState(),
                        ),
                      ),
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
}

class ConceptRevealScreen extends StatelessWidget {
  const ConceptRevealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3B54),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You were hungry, so food mattered.\n\nYou needed somewhere safe for the night, so shelter mattered.\n\nYou needed to travel, so transport mattered.\n\nAnd when help was far away, communication mattered.',
                style: TextStyle(color: Colors.white70, fontSize: 18, height: 1.5),
              ),
              const SizedBox(height: 48),
              const Center(
                child: Text('INEVITABLE EXPENSES', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFDA251D), fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 2)),
              ),
              const SizedBox(height: 24),
              const Text('"Different choices, but notice the pattern? Some needs keep coming back. They are difficult to simply ignore because they help everyday life keep running. We call these Inevitable Expenses." - DyRa',
                style: TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 48),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [Icon(Icons.restaurant, color: Colors.amber), Text('Food', style: TextStyle(color: Colors.white))]),
                  Column(children: [Icon(Icons.house, color: Colors.amber), Text('Shelter', style: TextStyle(color: Colors.white))]),
                  Column(children: [Icon(Icons.directions_bus, color: Colors.amber), Text('Transport', style: TextStyle(color: Colors.white))]),
                  Column(children: [Icon(Icons.phone, color: Colors.amber), Text('Phone', style: TextStyle(color: Colors.white))]),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00B4D8), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SurvivalPouchScreen())),
                  child: const Text('Unlock Survival Pouch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuickCheckGameScreen extends StatefulWidget {
  const QuickCheckGameScreen({super.key});

  @override
  State<QuickCheckGameScreen> createState() => _QuickCheckGameScreenState();
}

class _QuickCheckGameScreenState extends State<QuickCheckGameScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _situations = [
    {"situation": "Your stomach is growling during class.", "answer": "Food", "reason": "You need energy to focus!"},
    {"situation": "It's pouring rain and you are outside.", "answer": "Shelter", "reason": "Shelter keeps you safe and dry."},
    {"situation": "Your school is 10km away.", "answer": "Transport", "reason": "Transport is essential for reaching far places."},
    {"situation": "You need to ask your mom to pick you up.", "answer": "Phone", "reason": "Communication connects you in emergencies."},
  ];

  void _handleChoice(String choice) {
    if (choice == _situations[_currentIndex]["answer"]) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Correct! ${_situations[_currentIndex]["reason"]}'), backgroundColor: Colors.green));
      if (_currentIndex < _situations.length - 1) {
        setState(() => _currentIndex++);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SurvivalPouchScreen()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not quite. Try again!'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Check'), backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Situation ${_currentIndex + 1}/${_situations.length}", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: const Color(0xFFF0F8FF), borderRadius: BorderRadius.circular(24)),
              child: Text(_situations[_currentIndex]["situation"], textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            ),
            const SizedBox(height: 48),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: ["Food", "Shelter", "Transport", "Phone", "Video Games"].map((cat) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cat == 'Video Games' ? Colors.grey : const Color(0xFF00B4D8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  onPressed: () => _handleChoice(cat),
                  child: Text(cat, style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

class SurvivalPouchScreen extends StatelessWidget {
  const SurvivalPouchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDA251D),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DyraAvatar(expression: DyraExpression.celebrate, size: 150),
              const SizedBox(height: 24),
              const Text('Survival Pouch Unlocked!', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              const Text('"You found the needs that keep everyday life running. Your Survival Pouch is unlocked!" - DyRa', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white70, fontStyle: FontStyle.italic)),
              const SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFFDA251D), padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  dashboard.AppProgressManager.instance.completeModule(1);
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
