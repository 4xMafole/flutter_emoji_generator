import 'package:gen_z_emoji/utils/enums/emotions.dart';

class EmojiArt {
  String title;
  int bodyColorIndex;
  int mouthColorIndex;
  int leftEyeColorIndex;
  int rightEyeColorIndex;
  Emotion emotion;

  EmojiArt({
    this.title = 'Emoji art',
    this.bodyColorIndex = 12,
    this.mouthColorIndex = 16,
    this.leftEyeColorIndex = 16,
    this.rightEyeColorIndex = 16,
    this.emotion = Emotion.happy,
  });
}
