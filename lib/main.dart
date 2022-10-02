import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gen_z_emoji/core/emoji_art.dart';
import 'package:gen_z_emoji/utils/enums/emotions.dart';
import 'package:gen_z_emoji/utils/painter/emoji_painter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Generation Z',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Emoji Generation Z'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EmojiArt artWork = EmojiArt();
  EmojiPainter? painter;
  int numberOfColors = Colors.primaries.length;
  GlobalKey paintAreaKey = GlobalKey();

  @override
  void initState() {
    painter = EmojiPainter(artWork);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomPaint(
              key: paintAreaKey,
              foregroundPainter: EmojiPainter(artWork),
              size: Size(width / 2, width),
            )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          var appDocDir = await getExternalStorageDirectory();
          String appDocPath = appDocDir!.path;

          var random = Random();
          for (int i = 0; i < 5; i++) {
            artWork.title = 'Emoji $i';
            artWork.mouthColorIndex = random.nextInt(numberOfColors);
            artWork.leftEyeColorIndex = random.nextInt(numberOfColors);
            artWork.rightEyeColorIndex = random.nextInt(numberOfColors);
            //Trying to pick a random emotion from enum
            var list = List.generate(10,
                (i) => Emotion.values[random.nextInt(Emotion.values.length)]);
            artWork.emotion = list[random.nextInt(list.length)];
            artWork.bodyColorIndex = random.nextInt(numberOfColors);
            //Preventing having same body color with the mouth and eyes
            while (artWork.bodyColorIndex == artWork.mouthColorIndex ||
                artWork.bodyColorIndex == artWork.leftEyeColorIndex ||
                artWork.bodyColorIndex == artWork.rightEyeColorIndex) {
              artWork.bodyColorIndex = random.nextInt(numberOfColors);
            }
            //Verifying image's uniqueness
            Uint8List pngBytes = await painter!.getPng(artWork);
            var file = File('$appDocPath/${artWork.title}.png');
            file.writeAsBytesSync(pngBytes);
            String emojiTraits =
                '[{"trait_type" : "bodyColor", "value" : "${artWork.bodyColorIndex}"}, {"trait_type" : "mouthColor", "value" : "${artWork.mouthColorIndex}"}, {"trait_type" : "leftEyeColor", "value" : "${artWork.leftEyeColorIndex}"}, {"trait_type" : "rightEyeColor", "value" : "${artWork.rightEyeColorIndex}"}, {"trait_type" : "emotion", "value" : "${artWork.emotion}"}]';
            String emojiJson =
                '{"name": "${artWork.title}", "description": "Emoji #$i", "image": "ipfs://IMAGES_CID/${artWork.title}.png", "attributes": $emojiTraits}';
            file = File('$appDocPath/${artWork.title}.json');
            file.writeAsStringSync(emojiJson);
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 1000));
          }
        },
        child: const Text('Generate Emojis'),
      ),
    );
  }
}
