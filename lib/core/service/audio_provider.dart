// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:konnect/core/service/upload_audio.dart';

class AudioProvider extends ChangeNotifier {
  FlutterSoundPlayer _mPlayer;
  FlutterSoundRecorder _mRecorder;
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = true;
  String _mPath;
  String dur = "0:00";
  String tmpUrl = "www";

  //getters
  bool get isPlaying => _mPlayer.isPlaying;
  bool get isRecStopped => _mRecorder.isStopped;
  String get mPath => _mPath;
  String get durat => dur;
  String get tUrl => tmpUrl;

//aud log
  Future<void> openTheRecorder() async {
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  //For initState
  void initRec() {
    _mPlayer = FlutterSoundPlayer();
    _mRecorder = FlutterSoundRecorder();
    _mPlayer.openAudioSession().then((value) {
      _mPlayerIsInited = true;
      notifyListeners();
    });
    openTheRecorder().then((value) {
      _mRecorderIsInited = true;
      notifyListeners();
    });
  }

  //For dispose
  void dispRec() {
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    stopRecorder();
    _mRecorder.closeAudioSession();
    _mRecorder = null;
    if (_mPath != null) {
      var outputFile = File(_mPath);
      if (outputFile.existsSync()) {
        outputFile.delete();
      }
    }
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
    notifyListeners();
  }

  Future<void> stopRecorder() async {
    await _mRecorder.stopRecorder();
    _mplaybackReady = true;
  }

  Future<void> record() async {
    var tempDir = await getApplicationDocumentsDirectory();
    String newFilePath = p.join(tempDir.path, randomString(10));
    _mPath = '$newFilePath.aac';
    var outputFile = File(_mPath);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }

    assert(_mRecorderIsInited && _mPlayer.isStopped);
    await _mRecorder.startRecorder(
      toFile: _mPath,
      codec: Codec.aacADTS,
    );
    notifyListeners();
  }

  void play(String url) async {
    tmpUrl = url;
    print(url);

    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder.isStopped &&
        _mPlayer.isStopped);

    await _mPlayer.startPlayer(
        fromURI: url,
        codec: Codec.aacADTS,
        whenFinished: () {
          notifyListeners();
        });
    notifyListeners();
  }

  Future<void> duration() async {
    await flutterSoundHelper.duration(_mPath).then((value) {
      if (value.inSeconds < 10) {
        dur = "0:0${value.inSeconds}";
      } else {
        dur = "0:${value.inSeconds}";
      }
      notifyListeners();
    });
  }

  void getRecorder() async {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return null;
    }

    _mRecorder.isStopped
        ? record()
        : stopRecorder().then((value) async {
            await duration();
          });
  }
}
