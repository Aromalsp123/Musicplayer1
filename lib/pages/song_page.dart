import 'package:flutter/material.dart';
import 'package:musicplayer/components/neu_box.dart';
import 'package:musicplayer/models/playlist_provider.dart';
import 'package:musicplayer/pages/settings_page.dart'; // Import settings page
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key, required int songIndex});

  // Format duration into mm:ss
  String formatTime(Duration duration) {
    String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inMinutes}:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        final playlist = value.playlist;
        final currentSong = playlist[value.currentSongIndex ?? 0];

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // App bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context); // Navigate back
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text("P L A Y L I S T"),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsPage()),
                          ); // Navigate to Settings Page
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),

                  // Album artwork
                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),
                              const Icon(Icons.favorite, color: Colors.red),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Song duration progress
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(value.currentDuration)),
                            IconButton(
                              onPressed: value.toggleShuffle,
                              icon: Icon(
                                Icons.shuffle,
                                color: value.isShuffling ? Colors.green : Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: value.toggleRepeat,
                              icon: Icon(
                                value.repeatMode == 'one'
                                    ? Icons.repeat_one
                                    : Icons.repeat,
                                color: value.repeatMode != 'none' ? Colors.green : Colors.black,
                              ),
                            ),
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),
                      Slider(
                        min: 0,
                        max: value.totalDuration.inSeconds.toDouble(),
                        value: value.currentDuration.inSeconds.toDouble(),
                        activeColor: Colors.green,
                        onChanged: (double newValue) {},
                        onChangeEnd: (double newValue) {
                          value.seek(Duration(seconds: newValue.toInt()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Playback controls
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: const NeuBox(child: Icon(Icons.skip_previous)),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            child: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: const NeuBox(child: Icon(Icons.skip_next)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
