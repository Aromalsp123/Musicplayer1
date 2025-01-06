import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // Private list of songs
  final List<Song> _playlist = [
    Song(
      songName: "Big Drawgs",
      artistName: "Hanumankind",
      albumArtImagePath: "assets/images/images.jpeg",
      audioPath: "audio/bigdawgs.mp3",
    ),
    Song(
      songName: "NSYNC",
      artistName: "Deadpool",
      albumArtImagePath: "assets/images/bye.jpg",
      audioPath: "audio/nsync.mp3",
    ),
  ];

  // Current song index
  int? _currentSongIndex;

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Initially not playing
  bool _isPlaying = false;

  // Shuffle and repeat states
  bool _isShuffling = false;
  String _repeatMode = 'none'; // 'none', 'one', 'all'

  // Constructor
  PlaylistProvider() {
    _currentSongIndex = 0; // Initialize to the first song
    listenToDuration();
  }

  // Play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // Stop current song
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // Pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  // Seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Play next song
  void playNextSong() {
    if (_repeatMode == 'one') {
      play();
      return;
    }
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = _repeatMode == 'all' ? 0 : _currentSongIndex;
      }
    }
  }

  // Play previous song
  void playPreviousSong() {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero); // Restart the current song
    } else {
      if (_currentSongIndex != null && _currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1; // Loop back to the last song
      }
    }
  }

  // Toggle shuffle
  void toggleShuffle() {
    _isShuffling = !_isShuffling;
    if (_isShuffling) {
      _playlist.shuffle();
    } else {
      _playlist.sort((a, b) => a.songName.compareTo(b.songName)); // Sort back to original
    }
    notifyListeners();
  }

  // Toggle repeat
  void toggleRepeat() {
    if (_repeatMode == 'none') {
      _repeatMode = 'one';
    } else if (_repeatMode == 'one') {
      _repeatMode = 'all';
    } else {
      _repeatMode = 'none';
    }
    notifyListeners();
  }

  // Listen to duration
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // Getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  bool get isShuffling => _isShuffling;
  String get repeatMode => _repeatMode;

  // Setters
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
