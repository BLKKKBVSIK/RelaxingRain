import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:relaxing_rain/kConstant.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:relaxing_rain/widgets/custom_slider_thumb.dart';

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


  @override
  void initState() {
    if (fixedPlayer.state == AudioPlayerState.PLAYING) {
      playState = true;
    } else {
      playState = false;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBlueBackground,
        title: Text(
          "Back",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: Container(
          color: kBlueBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Hero(
                  tag: 'picto',
                  child: Image.asset(
                    'assets/picto.png',
                    height: MediaQuery.of(context).size.width * .5,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * .08,),
              Text("Breathe and focus", style: TextStyle(color: Colors.white, fontSize: 30),),
              SizedBox(height: MediaQuery.of(context).size.width * .08,),
              Flexible(
                child: InkWell(
                  onTap: () {
                    fixedPlayer.state == AudioPlayerState.PLAYING
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
                          size: MediaQuery.of(context).size.width * .4,
                        )
                      : Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * .4,
                        ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * .08,),
              volumeSlider()
            ],
          )),
    );
  }
}