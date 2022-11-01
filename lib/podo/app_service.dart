import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_desktop/podo/models.dart';
import 'package:music_desktop/podo/song_model.dart';
import 'package:music_desktop/podo/storage_manager.dart';
import 'package:music_desktop/podo/temp_data.dart';

class ProviderModel extends ChangeNotifier {
  Song currentSong = Song.none();
  List<Song> queue = [];
  List<Song> recentlyPlayed = [];
  int currentPos = 0;
  late bool paused, shuffle;
  int? repeat;
  AudioPlayer audioPlayer = AudioPlayer();
  List<int> idOrderNum = [];

  ProviderModel() {
    var ss = StorageManager.sharedPreferences;
    ss.getStringList('kRecentlyPlayed');
    List<String> idOrder = (ss.getStringList('kLastQueueOrder') ?? []);
    int lastPos = (ss.getInt('kLastPos') ?? 0);
    idOrder.forEach((element) async {
      Song song = await Database().getSong(int.parse(element));
      queue.add(song);
    });
    currentPos = lastPos;

    repeat = ss.getDouble('kRepeat')!.toInt() ;
    shuffle = ss.getBool('kshuffle') ?? false;
    (ss.getStringList('kpreShuffleIdOrder') ?? [])
        .map((e) => idOrderNum.add(int.parse(e)));
    audioPlayer.onPlayerStateChanged.listen((event) {
      paused = !(PlayerState.playing == event);
    });
  }

  int nextPosition(int pos) {
    currentPos = pos;

    return pos;
  }

  List<Song> addToRecent(Song song) {
    bool add = true;
    int count = 0;
    for (var element in recentlyPlayed) {
      if (element.album == song.album) {
        add = false;
      }
      count++;
    }
    if (add) {
      recentlyPlayed.add(song);
      notifyListeners();
    } else {
      recentlyPlayed.removeAt(count);
      recentlyPlayed.add(song);
      notifyListeners();
    }
    List<String> recent = [];
    recentlyPlayed.map((e) => recent.add(e.id.toString()));
    StorageManager.sharedPreferences.setStringList('kRecentlyPlayed', recent);
    return recentlyPlayed;
  }

  void playSong(Song song){
    audioPlayer.stop();
    currentSong = song;
    audioPlayer.play(UrlSource(song.url));
    addToRecent(song);

    audioPlayer.onPlayerComplete.listen((event) {

      if (repeat == 0) {
        // nextSong();
        nextSong();
      }
    });
    audioPlayer.onDurationChanged.listen(
          (event) {
        if (currentSong.duration == event && repeat == 0) {
          // nextSong();
        }
      },
    );

    notifyListeners();
  }

  pausePlayer() {
    if (paused) {
      audioPlayer.resume();
      paused = false;
    } else {
      audioPlayer.pause();
      paused = true;
    }
    notifyListeners();
  }

  void changeShuffle(ProviderModel providerModel) {
    if (shuffle) {
      shuffle = false;
      List<Song> currentQueue = providerModel.queue;
      int currentSongId = currentQueue[providerModel.currentPos].id;
      int newPos =
      currentQueue.indexWhere((element) => element.id == currentSongId);
      List<Song> newQueue = [];
      for (var element in idOrderNum) {
        newQueue.add(
            currentQueue.singleWhere((element) => element.id == currentSongId));
      }
      providerModel.currentPos = newPos;
      providerModel.queue = newQueue;
    } else {
      shuffle = true;
      setShuffle();
    }
  }

  void setShuffle() {
    if (shuffle) {
      shuffle = true;
      List<Song> currentQueue = queue;
      List<Song> remainingQueue =
      currentQueue.sublist(currentPos + 1);
      remainingQueue.map((e) => idOrderNum.add(e.id));
      List<Song> newQueue = currentQueue.sublist(0, currentPos);
      remainingQueue.shuffle();
      newQueue.addAll(remainingQueue);
      queue = newQueue;
    }
  }

  void previousSong() {
    audioPlayer.pause();

    if (currentPos == 0) {
      currentPos = queue.length;
    }
    currentSong =
        queue.elementAt(currentPos);
    audioPlayer.play(UrlSource(currentSong.url));
    notifyListeners();
  }

  void nextSong() {
    audioPlayer.pause();

    if (queue.length == currentPos && !(repeat == 0)) {
      currentPos = 0;
      currentPos = 0;
    } else {
      currentPos = (currentPos + 1);
    }
    currentSong =
        queue.elementAt(currentPos);

    audioPlayer.play(UrlSource(currentSong.url));
    notifyListeners();
  }

  void playSongsFromList(List<Song> songs){
    var localSongs = songs;
    localSongs.removeAt(0);
    playSong(songs.first);
    currentSong = songs.first;
    queue = localSongs;
  }

}


