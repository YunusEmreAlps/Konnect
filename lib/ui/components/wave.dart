// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:audio_wave/audio_wave.dart';

class Wave extends StatefulWidget {
  final double height;
  final double width;
  final bool isFull;
  Wave({this.height, this.width, this.isFull});
  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> {
  @override
  Widget build(BuildContext context) {
    if (widget.isFull)
      return AudioWave(
        height: widget.height,
        width: widget.width,
        beatRate: Duration(milliseconds: 100),
        spacing: 2.5,
        bars: [
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
        ],
      );
    else
      return AudioWave(
        height: widget.height,
        width: widget.width,
        beatRate: Duration(milliseconds: 100),
        spacing: 2.5,
        bars: [
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
        ],
      );
  }
}
