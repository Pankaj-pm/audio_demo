import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_demo/video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    _assetsAudioPlayer.open(Playlist(audios: [
      Audio("assets/chaleya.mp3"),
      Audio.network(
          "https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Music_for_Video/springtide/Sounds_strange_weird_but_unmistakably_romantic_Vol1/springtide_-_03_-_We_Are_Heading_to_the_East.mp3")
    ]),autoStart: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<Playing?>(
                stream: _assetsAudioPlayer.current,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  return Text(
                    snapshot.data?.audio.audio.metas.title??"",
                  );
                }),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<bool>(
                    stream: _assetsAudioPlayer.isPlaying,
                    builder: (context, snapshot) {
                      return IconButton(
                          onPressed: () {
                            _assetsAudioPlayer.playOrPause();
                          },
                          icon: Icon((snapshot.data ?? false)
                              ? Icons.pause
                              : Icons.play_arrow));
                    }),
                IconButton(onPressed: () {
                  _assetsAudioPlayer.next();
                }, icon: Icon(Icons.skip_next))
              ],
            ),
            InkWell(
              onTap: () {
                _assetsAudioPlayer.open(Audio("assets/chaleya.mp3"),
                    autoStart: false);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Chaleya"),
              ),
            ),
            StreamBuilder<double>(
                stream: _assetsAudioPlayer.volume,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Slider(
                      value: snapshot.data ?? 0,
                      onChanged: (value) {
                        _assetsAudioPlayer.setVolume(value);
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            InkWell(
                onTap: () {
                  _assetsAudioPlayer.open(
                      Audio(
                        "assets/heeriye.mp3",
                        metas: Metas(
                          id: 'Rock',
                          title: 'Heeriye playing...',
                          artist: 'Florent Champigny',
                          album: 'RockAlbum',

                        ),
                      ),
                      autoStart: false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Heeriye"),
                )),
            InkWell(
                onTap: () {
                  _assetsAudioPlayer.open(Audio("assets/maan_jan.mp3"),
                      autoStart: false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Maan meri jana"),
                )),
            InkWell(
                onTap: () {
                  _assetsAudioPlayer.open(
                      Audio.network(
                          "https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Music_for_Video/springtide/Sounds_strange_weird_but_unmistakably_romantic_Vol1/springtide_-_03_-_We_Are_Heading_to_the_East.mp3"),
                      autoStart: false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("We_Are_Heading_to_the_East"),
                )),
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(),));
            }, icon: Icon(Icons.near_me))
          ],
        ),
      ),
    );
  }
}
