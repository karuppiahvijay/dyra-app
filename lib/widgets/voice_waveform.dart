import 'package:flutter/material.dart';
import 'dart:math';

class VoiceWaveform extends StatefulWidget {
  final bool isSpeaking;
  final Color color;

  const VoiceWaveform({
    super.key,
    required this.isSpeaking,
    this.color = const Color(0xFFDA251D),
  });

  @override
  State<VoiceWaveform> createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<VoiceWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSpeaking) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.volume_up, color: Colors.white, size: 28),
        const SizedBox(width: 12),
        ...List.generate(9, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double height = 12 + 20 * sin(_controller.value * pi + index * 0.7).abs();
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: 5,
                height: height,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
