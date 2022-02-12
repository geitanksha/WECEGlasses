//new music file - using code from https://pub.dev/packages/nowplaying/example
//import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/globals.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class MusicScreen extends DeviceScreen {
  Timer? _timer;

  @override
  void startScreen() {
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getMusic());
  }

  @override
  void stopScreen() {
    _timer!.cancel();
  }

  void _getMusic() {
    SpotifySdk.connectToSpotifyRemote(),
    onPressed:
    (SpotifySdk.skipNext());
    SpotifySdk.getPlayerState();

  }

//-___________________________________________________________

}
