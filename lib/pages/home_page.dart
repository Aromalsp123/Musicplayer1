import 'package:flutter/material.dart';
import 'package:musicplayer/components/my_drawer.dart';
import 'package:musicplayer/models/playlist_provider.dart';
import 'package:musicplayer/models/song.dart';
import 'package:musicplayer/pages/song_page.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // get the playlist provider
  late final dynamic playlistProvider;

  @override
  void initState(){
    super.initState();
    // get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }
  // go to a song
  void goToSong(int songIndex) {
    // update current song index
    playlistProvider.currentSongIndex = songIndex;
    // navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>
          SongPage(songIndex: songIndex),),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("P L A Y L I S T")),
      drawer: const  MyDrawer(),
      body: Consumer<PlaylistProvider>(builder: (context,value,child){
        // get the playlist
        final List<Song> playlist = value.playlist;
            // return list view Ui
        return ListView.builder(
        itemCount: playlist.length,
            itemBuilder: (context,index) {
          // get individual song
              final Song song = playlist[index];
               //return list tile UI
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumArtImagePath),
                onTap: () => goToSong(index),
              );
            },
        );
      },
      ),

      // bottom Navigation Bar
      bottomNavigationBar: Container(
        color: Colors.grey.shade500,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
          child: GNav(
            backgroundColor: Colors.grey.shade500,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.grey.shade400,
            gap: 8,
            onTabChange: (index){
              print(index);
            },
            padding: EdgeInsets.all(16),
            tabs: const [
               GButton(icon: Icons.home,text: "Home",),
               GButton(icon: Icons.favorite_border,text: "Likes",),
               GButton(icon: Icons.search, text: "Search",),
               GButton(icon: Icons.person,text: "Profile",),

            ]
          ),
        ),
      ),
    );
  }
}

