import 'package:flutter/material.dart';
import 'package:music_app/models/music_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/widgets/player_buttons.dart';

class MusicDetailsScreen extends StatefulWidget {
  const MusicDetailsScreen({super.key, required this.musicData});

  final MusicData musicData;

  @override
  State<MusicDetailsScreen> createState() => _MusicDetailsScreenState();
}

class _MusicDetailsScreenState extends State<MusicDetailsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _audioPlayer.positionStream.listen((Duration position) {
      setState(() {
        sliderValue = position.inMilliseconds.toDouble();
      });
    });
    _audioPlayer.playerStateStream.listen((playerState) {});
  }

  Future<void> _initAudioPlayer() async {
    try {
      _audioPlayer.setUrl(widget.musicData.source.toString());
    } catch (e) {
      print('Error loading audio $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Center(
        child: Column(
          children: [
            Slider(
              min: 0.0,
              max: _audioPlayer.duration!.inMilliseconds.toDouble(),
              value: sliderValue,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              },
              onChangeEnd: (value) async {
                await _audioPlayer.seek(Duration(milliseconds: value.toInt()));
              },
            ),
            const SizedBox(
              height: 12,
            ),
            //PlayerButtons(audioPlayer: _audioPlayer),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await _audioPlayer.();
                  } else {
                    await _audioPlayer.resume();
                  }
                },
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
