import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:relaxing_rain/widgets/custom_slider_thumb.dart';
import 'package:relaxing_rain/kConstant.dart';
import 'package:audioplayers/audioplayers.dart';

class Homepage extends StatefulWidget {
  static const routeName = "/homepage";

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool playState = false;
  static AudioPlayer fixedPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  AudioCache audioCache = AudioCache(fixedPlayer: fixedPlayer);
  double volumeValue = 70.0;
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
    if (fixedPlayer.state == AudioPlayerState.PLAYING) {
      playState = true;
    } else {
      playState = false;
    }
  }

  @override
  void didChangeDependencies() {
    //precacheImage(_blueImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var time = DateTime.now().millisecondsSinceEpoch / 2000;
    var scaleX = 1.2 + sin(time) * .05;
    var scaleY = 1.2 + cos(time) * .07;
    var offsetY = 20 + cos(time) * 20;

    return Scaffold(
      backgroundColor: kBlueishDye,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Back",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
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
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/vgv-flutter-vignettes.appspot.com/o/gooey_edge%2FBg-Blue.png?alt=media&token=e00eaf19-3a5f-4133-a0f7-68ab7afe95ab',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
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
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      child: Hero(
                        tag: 'picto',
                        child: Image.asset(
                          'assets/picto.png',
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 80),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(30)),
                            color: kBlueBackground,
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: MediaQuery.of(context).size.width * .08,
                              ),
                              Text(
                                "Breathe and focus",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * .08,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    fixedPlayer.state ==
                                            AudioPlayerState.PLAYING
                                        ? pauseLocal()
                                        : playLocal();
                                    setState(() {
                                      playState = !playState;
                                    });
                                  },
                                  child: playState
                                      ? Icon(
                                          Icons.pause_circle_outline,
                                          color: Colors.white,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
                                        )
                                      : Icon(
                                          Icons.play_circle_outline,
                                          color: Colors.white,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * .08,
                              ),
                              volumeSlider()
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  playLocal() async {
    if (fixedPlayer.state == AudioPlayerState.PAUSED) {
      fixedPlayer.resume();
    } else {
      fixedPlayer =
          await audioCache.loop('rain.mp3', volume: 0.7, stayAwake: true);
    }
  }

  pauseLocal() async {
    fixedPlayer.pause();
  }

  Widget volumeSlider() {
    return Container(
      width: (48) * 5.5,
      height: (48),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(
          Radius.circular((48 * .3)),
        ),
        gradient: new LinearGradient(
            colors: [
              const Color(0xFF00c6ff),
              const Color(0xFF0072ff),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.00),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(48 * .2, 2, 48 * .2, 2),
        child: Row(
          children: <Widget>[
            Text(
              '0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48 * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 48 * .1,
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white.withOpacity(1),
                    inactiveTrackColor: Colors.white.withOpacity(.5),

                    trackHeight: 4.0,
                    thumbShape: CustomSliderThumbCircle(
                      thumbRadius: 48 * .4,
                      min: 0,
                      max: 100,
                    ),
                    overlayColor: Colors.white.withOpacity(.4),
                    //valueIndicatorColor: Colors.white,
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.red.withOpacity(.7),
                  ),
                  child: Slider(
                      value: volumeValue,
                      max: 100,
                      min: 0,
                      onChanged: (value) {
                        setState(() {
                          volumeValue = value;
                        });
                        fixedPlayer.setVolume(value / 100);
                      }),
                ),
              ),
            ),
            SizedBox(
              width: 48 * .1,
            ),
            Text(
              '100',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48 * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
