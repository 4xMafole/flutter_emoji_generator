import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gen_z_emoji/core/emoji_art.dart';

import '../enums/emotions.dart';

class EmojiPainter extends CustomPainter {
  EmojiArt artWork;
  EmojiPainter(this.artWork);

  @override
  void paint(Canvas canvas, Size size) {
    drawArt(artWork, canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawArt(EmojiArt artWork, Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    List<Color> listOfColors = Colors.primaries;
    //Drawing body
    var bodyPaint = Paint()..color = listOfColors[artWork.bodyColorIndex];
    canvas.drawCircle(center, radius, bodyPaint);
    //Drawing mouth (happy and sad), through emotion we can detect which face to draw.
    //Smile mouth
    var mouthPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = listOfColors[artWork.mouthColorIndex]
      ..strokeWidth = 10;
    if (artWork.emotion == Emotion.happy) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius / 2), 0, pi,
          false, mouthPaint);
    } else {
      canvas.drawArc(
          Rect.fromCircle(
              center: Offset(center.dx, center.dy + radius / 2),
              radius: radius / 2),
          pi,
          pi,
          false,
          mouthPaint);
    }

    //Drawing eyes ()
    //Left eye
    var leftEyePaint = Paint()..color = listOfColors[artWork.leftEyeColorIndex];
    canvas.drawCircle(Offset(center.dx - radius / 2, center.dy - radius / 2),
        10, leftEyePaint);
    //Right eye
    var rightEyePaint = Paint()
      ..color = listOfColors[artWork.rightEyeColorIndex];
    canvas.drawCircle(Offset(center.dx + radius / 2, center.dy - radius / 2),
        10, rightEyePaint);
  }

  Future<Uint8List> getPng(EmojiArt artWork) async {
    var size = const Size(500, 500);
    PictureRecorder pictureRecorder = PictureRecorder();
    Canvas canvas =
        Canvas(pictureRecorder, Rect.fromLTWH(0, 0, size.width, size.height));
    drawArt(artWork, canvas, size);
    final Picture picture = pictureRecorder.endRecording();
    var image = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }
}
