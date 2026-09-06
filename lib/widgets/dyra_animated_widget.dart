import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:confetti/confetti.dart';

enum DyRaState { entry, listening, hint, reaction, encourage, complete, typing }

class DyRaCompanion extends StatefulWidget {
  final DyRaState state;
  const DyRaCompanion({Key? key, required this.state}) : super(key: key);

  @override
  State<DyRaCompanion> createState() => _DyRaCompanionState();
}

class _DyRaCompanionState extends State<DyRaCompanion> with TickerProviderStateMixin {
  late AnimationController _popupController;
  late Animation<double> _popupScaleAnimation;
  late Animation<Offset> _popupSlideAnimation;
  late Animation<double> _popupFadeAnimation;

  late AnimationController _iconPopController;
  late Animation<double> _iconPopAnimation;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    // 1. Popup Entrance Animation (smooth, springy popup when question appears)
    _popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _popupScaleAnimation = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(parent: _popupController, curve: Curves.easeOutBack),
    );

    _popupSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.22), end: Offset.zero).animate(
      CurvedAnimation(parent: _popupController, curve: Curves.easeOutCubic),
    );

    _popupFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _popupController, curve: Curves.easeIn),
    );

    _popupController.forward();

    // 2. Icon Pop Animation (Elastic bounce when an icon appears)
    _iconPopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _iconPopAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconPopController, curve: Curves.elasticOut),
    );

    // 3. Confetti for completion
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    _triggerAnimationsForState(widget.state);
  }

  @override
  void didUpdateWidget(DyRaCompanion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _triggerAnimationsForState(widget.state);
    }
  }

  void _triggerAnimationsForState(DyRaState state) {
    // Re-play popup if entering a new question
    if (state == DyRaState.entry) {
      _popupController.reset();
      _popupController.forward();
    }

    // Reset and play icon pop
    _iconPopController.reset();
    _iconPopController.forward();

    // Trigger confetti if complete
    if (state == DyRaState.complete) {
      _confettiController.play();
    } else {
      _confettiController.stop();
    }
  }

  @override
  void dispose() {
    _popupController.dispose();
    _iconPopController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Widget _buildIconOverlay() {
    IconData? iconData;
    Color? iconColor;
    Alignment alignment = Alignment.topRight;

    switch (widget.state) {
      case DyRaState.listening:
        iconData = Icons.help_outline;
        iconColor = Colors.orangeAccent;
        break;
      case DyRaState.hint:
        iconData = Icons.lightbulb;
        iconColor = Colors.yellowAccent;
        break;
      case DyRaState.reaction:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        alignment = Alignment.bottomRight;
        break;
      case DyRaState.encourage:
        iconData = Icons.double_arrow;
        iconColor = Colors.cyanAccent;
        alignment = Alignment.bottomRight;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Align(
      alignment: alignment,
      child: ScaleTransition(
        scale: _iconPopAnimation,
        child: Container(
          margin: const EdgeInsets.only(top: 8, right: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.55),
                blurRadius: 14,
                spreadRadius: 3,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(iconData, color: iconColor, size: 34),
          ),
        ),
      ),
    );
  }

  String _getAvatarGifPath(DyRaState state) {
    if (state == DyRaState.reaction || state == DyRaState.complete || state == DyRaState.encourage || state == DyRaState.typing) {
      return 'assets/animations/dyra_clap.gif'; // Clapping GIF after submitting answer or while typing
    } else {
      return 'assets/images/dyra_girl_sample.jpg'; // Perfectly static, crystal-clear image (no continuous shaking)
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define states
    bool isListening = widget.state == DyRaState.listening || widget.state == DyRaState.typing;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background Confetti (Only plays on complete)
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
          
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Character Avatar with Springy Popup Entrance (matches media_1788374090845.png)
              SlideTransition(
                position: _popupSlideAnimation,
                child: ScaleTransition(
                  scale: _popupScaleAnimation,
                  child: FadeTransition(
                    opacity: _popupFadeAnimation,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            _getAvatarGifPath(widget.state),
                            key: ValueKey(_getAvatarGifPath(widget.state)),
                            width: 240,
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                          _buildIconOverlay(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Animated Voice Hearing Waveform
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isListening ? 1.0 : 0.0,
                child: const _VoiceWaveform(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom animated voice hearing waveform
class _VoiceWaveform extends StatefulWidget {
  const _VoiceWaveform({Key? key}) : super(key: key);

  @override
  _VoiceWaveformState createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<_VoiceWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(27, (index) {
          return AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              // Create gentle audio waveform height calculation
              double waveMultiplier = math.sin((index / 27) * math.pi); // Bell curve center height
              double val = math.sin(_waveController.value * math.pi * 2 + (index * 0.2));
              double height = 4 + (val.abs() * 12 * waveMultiplier); // Reduced from 24 to 12

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: 3.5,
                height: height,
                decoration: BoxDecoration(
                  color: const Color(0xFFDA251D),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDA251D).withOpacity(0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
