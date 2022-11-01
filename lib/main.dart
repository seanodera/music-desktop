import 'package:flutter/material.dart';
import 'podo/models.dart';
import 'podo/storage_manager.dart';
import 'podo/temp_data.dart';
import 'podo/router_manager.dart' as router;

Future<void> main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderModel>(
            create: (context) => ProviderModel()),
        ChangeNotifierProvider<ThemeModel>(create: (context) => ThemeModel()),
        ChangeNotifierProvider<Favourites>(create: (context) => Favourites()),
        ChangeNotifierProvider<HomeModel>(create: (context) => HomeModel()),
      ],
      child: Consumer3<ProviderModel, ThemeModel, Favourites>(
          builder: ((context, providerModel, themeModel, favourites, child) {
        favourites.init;

        Database().getCharts().then((value) {
          // providerModel.queue = value;
        });
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeModel.themeData(),
          darkTheme: themeModel.themeData(platformDarkMode: true),
          themeMode: ThemeMode.dark,
          initialRoute: router.RouteName.splash,
          onGenerateRoute: router.Router.generateRoute,
        );
      })),
    );
  }
}
