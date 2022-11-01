import 'package:flutter/material.dart';
import 'package:music_desktop/utils.dart';

import '../podo/models.dart';

class AlbumPage extends StatefulWidget {
  final Album album;

  const AlbumPage({Key? key, required this.album}) : super(key: key);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  Color accent = Colors.redAccent.shade400;
  late ImageProvider image;

  @override
  void initState() {
    image = NetworkImage(widget.album.art);
    initialize() async {
      accent = await getDominantColor(image);
    }

    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: accent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image(
                image: image,
                height: 300,
                width: 300,
              )
            ],
          ),
        )
      ],
    );
  }
}
