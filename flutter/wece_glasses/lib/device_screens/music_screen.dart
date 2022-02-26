//code from nowplaying as shown below
//https://pub.dev/packages/nowplaying
//s1: install the package
//s2: import the relevant package
//s3: install the dependencies and permissions in diff files, noted by parvati

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/globals.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:wece_glasses/music_permissions.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playify/playify.dart';
import 'package:playify_example/artists.dart';
import 'package:playify_example/songs.dart';

class MusicScreen extends DeviceScreen {
  Timer? _timer;
  bool fetchingAllSongs = false;
  bool playing = false;
  SongInformation? data;
  
  var myplayer = Playify();
  @override
  void startScreen() {
    _timer =
        Timer.periodic(const Duration(seconds: 30), (Timer t) => _getMusic());
  }
  void sendMusic(){
      await getNowPlaying();
      if (data==null)
        bleHandler.bluetoothWrite("");
      else
      {
        bleHandler.bluetoothWrite(data!.song.title+"/n"+data!.artist.name);
      }

  }
  @override
  void stopScreen() {
    _timer!.cancel();
  }

  void _getMusic() {
    void initState() {
      NowPlaying.instance.isEnabled().then((bool isEnabled) async {
        if (!isEnabled) {
          final shown = await NowPlaying.instance.requestPermissions();
          print('MANAGED TO SHOW PERMS PAGE: $shown');
        }
      });
    }

    NowPlayingTrack? initDataTrack;
    StreamProvider<NowPlayingTrack>.value(
        initialData: initDataTrack!,
        value: NowPlaying.instance.stream,
        child: MaterialApp(home: Scaffold(
            body: Consumer<NowPlayingTrack>(builder: (context, track, _) {
          if (track == null) return Container();

          return Container();
        }))));
  }
  Future<void> getNowPlaying() async {
    try {
      final SongInformation? res = await myplayer.nowPlaying();
      data=res;
      
    } catch (e) {
      
        fetchingAllSongs = false;
      
    }
  }
  Future<void> getIsPlaying() async {
    try {
      final bool isPlaying = await myplayer.isPlaying();
      setState(() {
        playing = isPlaying;
      });
    } catch (e) {
      setState(() {
        fetchingAllSongs = false;
      });
    }
  }
  void playPause() {
    if (!playing){
            
      await myplayer.play();
      await getIsPlaying();
      await getNowPlaying();
      }
      else
      {              
      await myplayer.pause();
      await getIsPlaying();
      await getNowPlaying();
      }
                      
  }

  void skipForward(){
    await myplayer.seekForward();
  }

  


//-___________________________________________________________

}
