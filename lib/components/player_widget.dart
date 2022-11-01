import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_desktop/podo/models.dart';
import 'package:music_desktop/podo/player.dart';

class PlayerWidget extends StatefulWidget {
  final ProviderModel providerModel;

  const PlayerWidget({Key? key, required this.providerModel}) : super(key: key);

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late Player player;
  late ProviderModel providerModel;
  double volume = 1;
  int msDuration = 1, msPosition = 0, repeat = 0;
  Duration duration = const Duration(seconds: 1),
      position = const Duration(seconds: 0);
  Song currentSong = Song(
      id: 0,
      artistId: 0,
      albumId: 0,
      artist: 'Nothing Playing',
      album: '',
      cover:
          'https://images.unsplash.com/photo-1433888104365-77d8043c9615?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2073&q=80',
      duration: const Duration(seconds: 0),
      title: 'Song name right here',
      url: '');
  bool fav = false, playing = false, shuffle = false;

  void initialize() async {
    currentSong = widget.providerModel.currentSong;
    setState(() {});
  }

  @override
  void initState() {
    player = widget.providerModel.player;
    player.audioPlayer.onPlayerStateChanged.listen((event) {
      (event == PlayerState.playing) ? playing = true : playing = false;
    });
    player.audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
    player.audioPlayer.onDurationChanged.listen((event) {
      duration = event;
    });
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    player.audioPlayer.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    providerModel = Provider.of<ProviderModel>(context, listen: true);
    currentSong = providerModel.currentSong;
    shuffle = player.shuffle;

    return ClipRect(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.surface,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 200, sigmaX: 200),
          child: Column(
            children: [
              LinearProgressIndicator(
                minHeight: 1,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.secondary),
                backgroundColor: Colors.transparent,
                value: (position.inMicroseconds / duration.inMicroseconds),
              ),
              // Slider(
              //   value: position.inMicroseconds.floorToDouble(),
              //   activeColor: colorScheme.secondary,
              //   onChanged: (double value) {
              //     player.audioPlayer.seek(Duration(microseconds: value.toInt()));
              //   },
              //   max: duration.inMicroseconds.floorToDouble(),
              // ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width / 3,
                    child: ListTile(
                      leading: Image.network(
                        currentSong.cover,
                        fit: BoxFit.cover,
                      ),
                      title: Text(currentSong.title),
                      subtitle: Text(currentSong.artist),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: (fav)
                              ? Icon(
                                  Icons.favorite,
                                  color: Theme.of(context).colorScheme.secondary,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                )),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                            onPressed: () {
                              player.setShuffle(providerModel);
                            },
                            icon: Icon(
                              Icons.shuffle,
                              color: (shuffle)
                                  ? colorScheme.secondary
                                  : colorScheme.onPrimary,
                            )),
                        IconButton(
                            onPressed: () {
                              player.previousSong(providerModel);
                            },
                            icon: const Icon(Icons.skip_previous)),
                        IconButton(
                            onPressed: () {
                              if (playing) {
                                player.pausePlayer();
                              } else {
                                player.pausePlayer();
                              }
                            },
                            icon:
                                Icon((playing) ? Icons.pause : Icons.play_arrow)),
                        IconButton(
                            onPressed: () {
                              player.nextSong(providerModel);
                            }, icon: const Icon(Icons.skip_next)),
                        IconButton(
                            onPressed: () {},
                            icon: (repeat == 0)
                                ? Icon(
                                    Icons.repeat,
                                    color: colorScheme.onPrimary,
                                  )
                                : (repeat == 1)
                                    ? Icon(
                                        Icons.repeat_on_outlined,
                                        color: colorScheme.secondary,
                                      )
                                    : Icon(
                                        Icons.repeat_one_on_outlined,
                                        color: colorScheme.secondary,
                                      ))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width / 3,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Row(
                            children: [
                              Icon(
                                Icons.volume_up_outlined,
                                color: colorScheme.onPrimary,
                              ),
                              SizedBox(
                                width: 170,
                                child: Slider(
                                  value: volume,
                                  activeColor: colorScheme.onPrimary,
                                  inactiveColor: colorScheme.surface,
                                  onChanged: (double value) {
                                    setState(() {
                                      volume = value;
                                      player.audioPlayer.setVolume(value);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
