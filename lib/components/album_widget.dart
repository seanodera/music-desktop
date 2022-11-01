import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_desktop/podo/router_manager.dart';

import '../podo/models.dart';

class AlbumWidget extends StatelessWidget {
  final Album album;
  final Function onTap;

  const AlbumWidget({Key? key, required this.album, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var image = NetworkImage(album.art);

    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(RouteName.albumPage, arguments: album);
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          image: DecorationImage(image: image, fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 50, sigmaX: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: image,
                    width: 200,
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album.name,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis
                              ),
                        ),
                        Text(
                          album.artistName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
