import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/hive_service.dart';
import '../models/emotions.dart';
import '../models/feeling_data.dart';

Future<void> updateFeelingInHive({
  required BuildContext context,
  required TextEditingController titleController,
  required Emotions? selectedEmotion,
  required String description,
  required FeelingData existingItem,
}) async {
  final title = titleController.text.trim();

  if (title.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Что у вас случилось?')),
    );
    return;
  }

  if (selectedEmotion == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Что вы чувствовали?')),
    );
    return;
  }

  final updatedFeeling = FeelingData(
    title: title,
    description: description.isNotEmpty ? description : null,
    emotion: selectedEmotion,
    dateTime: existingItem.dateTime,
  );

  try {
    await HiveService.feelingsBox.put(existingItem.key, updatedFeeling);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Запись обновлена!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ошибка обновления: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}