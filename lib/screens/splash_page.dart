import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_desktop/podo/router_manager.dart';

import '../podo/models.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      ProviderModel providerModel = Provider.of<ProviderModel>(context);
      providerModel.player.dispose();
      providerModel.dispose();
    }
  }

  @override
  void initState() {
    Timer.run(() => Timer(const Duration(seconds: 3), () {

          Navigator.of(context).pushNamed(RouteName.login);
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.background,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        'assets/logo.png',
        height: 200,
        width: 200,
      ),
    );
  }
}
