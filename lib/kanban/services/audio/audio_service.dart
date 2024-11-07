import 'package:audioplayers/audioplayers.dart';

final class AudioService {
  final _audioPlayer = AudioPlayer();

  Future<void> play(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
}