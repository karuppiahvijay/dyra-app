import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:confetti/confetti.dart';
import 'package:video_player/video_player.dart';

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

  VideoPlayerController? _blinkController;
  VideoPlayerController? _clapController;
  bool _isBlinkInitialized = false;
  bool _isClapInitialized = false;

  @override
  void initState() {
    super.initState();

    _initVideoControllers();

    // 1. Popup Entrance Animation
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

    // 2. Icon Pop Animation
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

  Future<void> _initVideoControllers() async {
    try {
      final blink = VideoPlayerController.asset('assets/animations/blinking.mp4');
      _blinkController = blink;
      await blink.initialize();
      await blink.setVolume(0.0);
      await blink.setLooping(true);
      if (mounted) {
        setState(() {
          _isBlinkInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing blinking.mp4: $e");
    }

    try {
      final clap = VideoPlayerController.asset('assets/animations/clapping.mp4');
      _clapController = clap;
      await clap.initialize();
      await clap.setVolume(0.0);
      await clap.setLooping(true);
      if (mounted) {
        setState(() {
          _isClapInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing clapping.mp4: $e");
    }

    if (mounted) {
      _updateVideoPlayback(widget.state);
    }
  }

  @override
  void didUpdateWidget(DyRaCompanion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _triggerAnimationsForState(widget.state);
      _updateVideoPlayback(widget.state);
    }
  }

  void _updateVideoPlayback(DyRaState state) {
    final path = _getAvatarVideoPath(state);
    if (path == 'assets/animations/clapping.mp4') {
      if (_isBlinkInitialized && _blinkController != null) {
        _blinkController!.pause();
        _blinkController!.seekTo(Duration.zero);
      }
      if (_isClapInitialized && _clapController != null) {
        _clapController!.setVolume(0.0);
        _clapController!.play().catchError((e) => debugPrint("Clap play error: $e"));
      }
    } else {
      if (_isClapInitialized && _clapController != null) {
        _clapController!.pause();
        _clapController!.seekTo(Duration.zero);
      }
      if (_isBlinkInitialized && _blinkController != null) {
        _blinkController!.setVolume(0.0);
        _blinkController!.play().catchError((e) => debugPrint("Blink play error: $e"));
      }
    }
  }

  void _triggerAnimationsForState(DyRaState state) {
    if (state == DyRaState.entry) {
      _popupController.reset();
      _popupController.forward();
    }

    _iconPopController.reset();
    _iconPopController.forward();

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
    _blinkController?.dispose();
    _clapController?.dispose();
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

  String _getAvatarVideoPath(DyRaState state) {
    if (state == DyRaState.reaction || state == DyRaState.complete || state == DyRaState.encourage || state == DyRaState.typing) {
      return 'assets/animations/clapping.mp4'; 
    } else {
      return 'assets/animations/blinking.mp4'; 
    }
  }

  Widget _buildAvatarMedia() {
    bool isClapState = _getAvatarVideoPath(widget.state) == 'assets/animations/clapping.mp4';
    VideoPlayerController? activeController;

    if (isClapState && _isClapInitialized && _clapController != null) {
      activeController = _clapController;
    } else if (_isBlinkInitialized && _blinkController != null) {
      activeController = _blinkController;
    }

    if (activeController != null && activeController.value.isInitialized) {
      return SizedBox(
        width: 240,
        height: 240,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: activeController.value.size.width > 0 ? activeController.value.size.width : 240,
            height: activeController.value.size.height > 0 ? activeController.value.size.height : 240,
            child: VideoPlayer(activeController),
          ),
        ),
      );
    }

    // Fallback: Display Mascot avatar image so character is always visible
    return Image.asset(
      'assets/images/mascot.png',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
          
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
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
                        _buildAvatarMedia(),
                        _buildIconOverlay(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
