
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_desktop/podo/song_model.dart';
import 'package:music_desktop/screens/AlbumPage.dart';
import '../screens/login.dart';
import '../screens/main_shell.dart';

import '../anim/PageRouteAnim.dart';
import '../screens/splash_page.dart';

class RouteName {
  static const String splash = '/splash';
  static const String tab = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String play = '/play';
  static const String albumPage = '/album';

}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(const SplashPage());
      case RouteName.tab:
        return MaterialPageRoute(builder: (context) => const MainShell());
      case RouteName.login:
        return CupertinoPageRoute(
            fullscreenDialog: true, builder: (_) => const LoginPage());
      case RouteName.albumPage:
        return MaterialPageRoute(builder: (_) => AlbumPage(album: settings.arguments as Album));
      // case RouteName.register:
      //   return CupertinoPageRoute(builder: (_) => RegisterPage());
      // case RouteName.articleDetail:
      //   var article = settings.arguments as Article;
      //   return CupertinoPageRoute(builder: (_) {
      //     // 根据配置调用页面
      //     return StorageManager.sharedPreferences.getBool(kUseWebViewPlugin) ??
      //             false
      //         ? ArticleDetailPluginPage(
      //             article: article,
      //           )
      //         : ArticleDetailPage(
      //             article: article,
      //           );
      //   });
      // case RouteName.structureList:
      //   var list = settings.arguments as List;
      //   Tree tree = list[0] as Tree;
      //   int index = list[1];
      //   return CupertinoPageRoute(
      //       builder: (_) => ArticleCategoryTabPage(tree, index));
      // case RouteName.favouriteList:
      //   return CupertinoPageRoute(builder: (_) => FavouriteListPage());
      // case RouteName.coinRecordList:
      //   return CupertinoPageRoute(builder: (_) => CoinRecordListPage());
      // case RouteName.coinRankingList:
      //   return CupertinoPageRoute(builder: (_) => CoinRankingListPage());
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 300);
  Widget child;

  PopRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
