
import 'package:flutter/material.dart';
import 'package:music_desktop/components/sidebar.dart';
import 'package:music_desktop/podo/models.dart';
import 'package:music_desktop/screens/home.dart';
import 'package:music_desktop/screens/library.dart';
import 'package:music_desktop/screens/search.dart';

import '../components/player_widget.dart';

class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  Widget build(BuildContext context) {
    ProviderModel providerModel =
        Provider.of<ProviderModel>(context);
    // void playSomething() async {
    //   var songs = await Database().getCharts();
    //   var song = songs.elementAt(Random().nextInt(songs.length));
    //   providerModel.player.playSong(song, providerModel);
    //   providerModel.currentSong = song;
    //   providerModel.queue = songs;
    // }

    const double sideBarWidth = 250;
    double height = MediaQuery.of(context).size.height - 65;
    double width = MediaQuery.of(context).size.width - 250;
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/logo.jpg'), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Material(
                  child: SideBar(
                    width: sideBarWidth,
                    items: [
                      SideBarItem(
                        widget: Home(
                          width: width,
                        ),
                        text: 'home',
                        icon: Icons.home_outlined,
                      ),
                      SideBarItem(
                          widget: Search(width: width),
                          text: 'search',
                          icon: Icons.search_rounded),
                      SideBarItem(
                          widget: Library(width: width),
                          text: 'Library',
                          icon: Icons.vertical_split_outlined)
                    ],
                    widgetWidth: width,
                  ),
                ),
                Container(
                  width: width,
                  height: height,
                  color: Theme.of(context).colorScheme.primary,
                  child: Home(
                    width: width,
                  ),
                ),
              ],
            ),
            PlayerWidget(
              providerModel: providerModel,
            ),
          ],
        ),
      ),
    );
  }
}
