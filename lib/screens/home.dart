import 'package:flutter/material.dart';
import 'package:music_desktop/components/album_widget.dart';
import 'package:music_desktop/components/common_view.dart';
import 'package:music_desktop/components/playlist_widget.dart';
import 'package:music_desktop/podo/models.dart';

class Home extends StatefulWidget {
  final double width;

  const Home({Key? key, required this.width}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    HomeModel homeModel = Provider.of<HomeModel>(context);
    ProviderModel providerModel = Provider.of<ProviderModel>(context);
    Size size = MediaQuery.of(context).size;
    List<Playlist> featured = homeModel.topPlaylist;
    List<Album> topAlbums = homeModel.albums;
    List<RecentlyPlayed> recent = List.generate(
        providerModel.recentlyPlayed.length,
        (index) => RecentlyPlayed(
            type: 'song',
            object: providerModel.recentlyPlayed[index])).reversed.toList();

    int maxItems = (widget.width ~/ 200);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: (topAlbums.isEmpty || featured.isEmpty)
          ? Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: 250,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(topAlbums.first.art),
                        fit: BoxFit.cover),
                  ),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.fromLTRB(12, 0, 30, 12),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topAlbums.first.name,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(topAlbums.first.artistName)
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              var songs = topAlbums.first.songs;
                              providerModel.player
                                  .playSongsFromList(songs, providerModel);
                            },
                            icon: const Icon(
                              Icons.play_circle_fill_outlined,
                              size: 50,
                            ))
                      ],
                    ),
                  ),
                ),
                (recent.isEmpty)
                    ? Container()
                    : const HomeTitle(title: 'Recently Played'),
                (recent.isEmpty)
                    ? Container()
                    : SizedBox(
                        width: widget.width,
                        height: 290,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            RecentlyPlayed played = recent.elementAt(index);
                            Song song = played.object;
                            return CommonWidget(
                                image: NetworkImage(song.cover),
                                title: song.album,
                                subtitle: song.artist);
                          },
                          shrinkWrap: true,
                          itemCount: (maxItems >= recent.length)
                              ? recent.length
                              : maxItems,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                const HomeTitle(title: 'Top Albums'),
                SizedBox(
                  width: widget.width,
                  height: 290,
                  child: ListView.builder(
                    itemBuilder: (context, index) => AlbumWidget(
                        album: topAlbums.elementAt(index), onTap: () {}),
                    shrinkWrap: true,
                    itemCount: (maxItems >= topAlbums.length)
                        ? topAlbums.length
                        : maxItems,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const HomeTitle(title: 'Featured Playlists'),
                SizedBox(
                  width: widget.width,
                  height: 290,
                  child: ListView.builder(
                      itemCount: (maxItems >= featured.length)
                          ? featured.length
                          : maxItems,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => PlaylistWidget(
                            playlist: featured.elementAt(index),
                            onTap: () {},
                          )),
                )
              ],
            ),
    );
  }
}

class HomeTitle extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final bool showRight;

  const HomeTitle(
      {Key? key, required this.title, this.onTap, this.showRight = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title,
              style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2)),
          (showRight)
              ? GestureDetector(
                  onTap: onTap,
                  child: const Text('View All',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      )),
                )
              : Container(),
        ],
      ),
    );
  }
}
