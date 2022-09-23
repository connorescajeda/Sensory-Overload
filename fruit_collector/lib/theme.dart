
import'package:flutter/material.dart';
import'package:provider/provider.dart';

class theme{
  final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  dividerColor: Colors.white54,
);
}
class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}
// vsync: this,
         // behaviour: RandomParticleBehaviour(
           // options: const ParticleOptions(
            //  baseColor: Colors.greenAccent,
           //   spawnOpacity: 0.0,
            //  opacityChangeRate: 0.25,
            //  minOpacity: 0.1,
             // maxOpacity: 0.4,
             // particleCount: 70,
             // spawnMaxRadius: 15.0,
             // spawnMaxSpeed: 100.0,
              //spawnMinSpeed: 30,
             // spawnMinRadius: 7.0,

            //) 
           // ),