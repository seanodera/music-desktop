import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'storage_manager.dart';

class Player extends ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  bool paused = false, repeatQueu = false, repeatSong = false, shuffle = false;

  List<int> idOrder = [];
  Player() {
    var ss = StorageManager.sharedPreferences;
    repeatQueu = ss.getBool('krepeatQ') ?? false;
    repeatSong = ss.getBool('krepeatSong') ?? false;
    shuffle = ss.getBool('kshuffle') ?? false;
    (ss.getStringList('kpreShuffleIdOrder') ?? [])
        .map((e) => idOrder.add(int.parse(e)));
    audioPlayer.onPlayerStateChanged.listen((event) {
      paused = !(PlayerState.playing == event);
    });
  }

  void destroyPlayer(ProviderModel providerModel) {
    List<String> _idOrder = [];
    List<String> idOrderStringFrom = []; // actual Order
    providerModel.queue.map((e) => _idOrder.add(e.id.toString()));
    idOrder.map((e) => idOrderStringFrom.add(e.toString()));
    var ss = StorageManager.sharedPreferences;
    ss.setInt('kLastPos', providerModel.currentPos);
    ss.setStringList('kLastQueueOrder', _idOrder);
    ss.setStringList('kpreShuffleIdOrder', idOrderStringFrom);
    ss.setBool('krepeatQ', repeatQueu);
    ss.setBool('krepeatSong', repeatSong);
    ss.setBool('kshuffle', shuffle);
    audioPlayer.dispose();
  }

  void playSong(Song song, ProviderModel providerModel) {
    audioPlayer.stop();

    providerModel.setCurrentSong(song);
    audioPlayer.play(UrlSource(song.url));
    providerModel.addToRecent(song);


    audioPlayer.onPlayerComplete.listen((event) {

      if (!repeatSong) {
        // nextSong();
        nextSong(providerModel);
      }
    });
    audioPlayer.onDurationChanged.listen(
      (event) {
        if (providerModel.currentSong.duration == event && !repeatSong) {
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
      for (var element in idOrder) {
        newQueue.add(
            currentQueue.singleWhere((element) => element.id == currentSongId));
      }
      providerModel.currentPos = newPos;
      providerModel.queue = newQueue;
    } else {
      shuffle = true;
      setShuffle(providerModel);
    }
  }

  void setShuffle(ProviderModel providerModel) {
    if (shuffle) {
      shuffle = true;
      List<Song> currentQueue = providerModel.queue;
      List<Song> remainingQueue =
          currentQueue.sublist(providerModel.currentPos + 1);
      remainingQueue.map((e) => idOrder.add(e.id));
      List<Song> newQueue = currentQueue.sublist(0, providerModel.currentPos);
      remainingQueue.shuffle();
      newQueue.addAll(remainingQueue);
      providerModel.queue = newQueue;
    }
  }

  void previousSong(ProviderModel providerModel) {
    audioPlayer.pause();
    int currentPos = providerModel.currentPos;
    if (currentPos == 0) {
      providerModel.currentPos = providerModel.queue.length;
    }
    providerModel.currentSong =
        providerModel.queue.elementAt(providerModel.currentPos);
    audioPlayer.play(UrlSource(providerModel.currentSong.url));
    notifyListeners();
  }

  void nextSong(ProviderModel providerModel) {
    audioPlayer.pause();
    int currentPos = providerModel.currentPos;

    if (providerModel.queue.length == currentPos && repeatQueu) {
      currentPos = 0;
      providerModel.currentPos = 0;
    } else {
      providerModel.currentPos = (currentPos + 1);
    }
    print('current pos is ${providerModel.currentPos}The length is ${providerModel.queue.length}');
    providerModel.currentSong =
        providerModel.queue.elementAt(providerModel.currentPos);

    audioPlayer.play(UrlSource(providerModel.currentSong.url));
    notifyListeners();
  }

  void playSongsFromList(List<Song> songs,ProviderModel providerModel ){
    var localSongs = songs;
    localSongs.removeAt(0);
    playSong(songs.first, providerModel);
    providerModel.currentSong = songs.first;
    providerModel.queue = localSongs;
  }
}
