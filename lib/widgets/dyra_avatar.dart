import 'package:flutter/material.dart';

enum DyraExpression {
  welcome, goodJob, thinking, teaching, idea, save, grow, plan, celebrate, youCanDoIt
}

class DyraAvatar extends StatefulWidget {
  final DyraExpression expression;
  final double size;
  final bool isSpeaking;

  const DyraAvatar({
    super.key, 
    required this.expression, 
    this.size = 100,
    this.isSpeaking = false,
  });

  @override
  State<DyraAvatar> createState() => _DyraAvatarState();
}

class _DyraAvatarState extends State<DyraAvatar> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _talkingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _talkingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _talkingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _talkingAnimation = Tween<double>(begin: 0.0, end: -4.0).animate(
      CurvedAnimation(parent: _talkingController, curve: Curves.easeInOut),
    );

    if (widget.isSpeaking) {
      _talkingController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(DyraAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking != oldWidget.isSpeaking) {
      if (widget.isSpeaking) {
        _talkingController.repeat(reverse: true);
      } else {
        _talkingController.stop();
        _talkingController.animateTo(0.0);
      }
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _talkingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (widget.expression) {
      case DyraExpression.welcome: imagePath = 'assets/images/avatars/avatar_0.png'; break;
      case DyraExpression.goodJob: imagePath = 'assets/images/avatars/avatar_1.png'; break;
      case DyraExpression.thinking: imagePath = 'assets/images/avatars/avatar_2.png'; break;
      case DyraExpression.teaching: imagePath = 'assets/images/avatars/avatar_3.png'; break;
      case DyraExpression.idea: imagePath = 'assets/images/avatars/avatar_4.png'; break;
      case DyraExpression.save: imagePath = 'assets/images/avatars/avatar_5.png'; break;
      case DyraExpression.grow: imagePath = 'assets/images/avatars/avatar_6.png'; break;
      case DyraExpression.plan: imagePath = 'assets/images/avatars/avatar_7.png'; break;
      case DyraExpression.celebrate: imagePath = 'assets/images/avatars/avatar_8.png'; break;
      case DyraExpression.youCanDoIt: imagePath = 'assets/images/avatars/avatar_9.png'; break;
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _talkingAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _talkingAnimation.value),
            child: child,
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain, // Changed to contain so portrait isn't cropped
          ),
        ),
      ),
    );
  }
}
