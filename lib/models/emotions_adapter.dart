import 'package:hive/hive.dart';
import 'emotions.dart';

class EmotionsAdapter extends TypeAdapter<Emotions> {
  @override
  final int typeId = 1;

  @override
  Emotions read(BinaryReader reader) {
    final index = reader.readInt();
    return Emotions.values[index];
  }

  @override
  void write(BinaryWriter writer, Emotions obj) {
    writer.writeInt(obj.index);
  }
}