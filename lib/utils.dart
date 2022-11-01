import 'dart:io';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

double minSize({required double percentage,
  required double value,
  required double fullValue}) {
  double calcHeight = (percentage / 100) * fullValue;
  if (value >= calcHeight) {
    return value;
  } else {
    return calcHeight;
  }
}

clearStorage() async {
  /// eg:theme
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  /// eg: cookie
  Directory temporaryDirectory = await getTemporaryDirectory();

  ///  eg:user
  LocalStorage localStorage = LocalStorage('LocalStorage');

  await localStorage.ready.onError((error, stackTrace) {
    localStorage.clear();
    return false;
  });
  localStorage.clear();
  temporaryDirectory.delete();
  sharedPreferences.clear();
}

Future<bool> checkInternet() async {
  bool internet = false;
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      internet = true;
    }
  } on SocketException catch (_) {
    internet = false;
  }
  return internet;
}

Future<Color> getDominantColor(ImageProvider image) async {
  var gen = await PaletteGenerator.fromImageProvider(image);
  if (gen.dominantColor == null) {
    if (gen.vibrantColor == null) {
      return gen.dominantColor!.color;
    } else {
      return gen.vibrantColor!.color;
    }
  } else {
    return Colors.redAccent.shade400;
  }
}