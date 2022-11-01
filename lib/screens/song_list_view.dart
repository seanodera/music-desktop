import 'package:flutter/material.dart';

import '../podo/song_model.dart';


class SongListView extends StatelessWidget {
  const SongListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PreLoaded {
  List<Song> songs;
  PreLoaded({required this.songs});
}