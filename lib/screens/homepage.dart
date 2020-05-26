import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:relaxing_rain/widgets/content_cards.dart';
import 'package:relaxing_rain/widgets/custom_slider_thumb.dart';
import 'package:relaxing_rain/kConstant.dart';
import 'package:audioplayers/audioplayers.dart';

class Homepage extends StatefulWidget {
  static const routeName = "/homepage";

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  Ticker _ticker;
  //Image _blueBg;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _ticker = Ticker((d) {
      setState(() {});
    })
      ..start();
  }

  @override
  void didChangeDependencies() {
    //precacheImage(_blueImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var time = DateTime.now().millisecondsSinceEpoch / 2000;
    var scaleX = 1.2 + sin(time) * .11;
    var scaleY = 1.2 + cos(time) * .1;
    var offsetY = 20 + cos(time) * 20;

    return Scaffold(
      backgroundColor: kBlueishDye,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Transform(
            transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
            child: Transform.translate(
              offset: Offset(
                  -(scaleX - 1) / 2 * MediaQuery.of(context).size.width,
                  -(scaleY - 1) / 2 * MediaQuery.of(context).size.height +
                      offsetY),
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: <Widget>[
                NavigationRail(
                  backgroundColor: Colors.transparent,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.ac_unit, color: Colors.white),
                      selectedIcon: Icon(Icons.ac_unit, color: Colors.white),
                      label: Text(
                        'Rain',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bookmark_border, color: Colors.white),
                      selectedIcon: Icon(Icons.book, color: Colors.white),
                      label: Text(
                        'Rain2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.star_border, color: Colors.white),
                      selectedIcon: Icon(Icons.star, color: Colors.white),
                      label: Text(
                        'Rain3',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                getRightContentCards(_selectedIndex),
                //ContentCards(selectedIndex: _selectedIndex,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getRightContentCards(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return ContentCards(
          selectedIndex: _selectedIndex,
          bgColor: kBlueCardBackground,
          assetName: "rain.mp3",
        );
        break;
      case 1:
        return ContentCards(
            selectedIndex: _selectedIndex,
            bgColor: kBlueishDye,
            assetName: "thunder.mp3");
        break;
      case 2:
        return ContentCards(
          selectedIndex: _selectedIndex,
          bgColor: Colors.deepOrange,
        );
        break;
      default:
        return Container();
        break;
    }
  }
}
