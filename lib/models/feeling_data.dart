// lib/data/models/feeling_data.dart
import 'package:hive/hive.dart';
import 'emotions.dart';

part 'feeling_data.g.dart';

@HiveType(typeId: 0)
class FeelingData extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final Emotions emotion;

  @HiveField(3)
  final DateTime dateTime;

  FeelingData({
    required this.title,
    this.description,
    required this.emotion,
    required this.dateTime,
  });
}