import 'package:flutter/material.dart';
import '../models/emotions.dart';
import '../models/feeling_data.dart';
import '../data/hive_service.dart';
import '../widgets/horizontal_calendar.dart';


FeelingData? saveFeeling({
  required BuildContext context,
  required TextEditingController titleController,
  required Emotions? selectedEmotion,
  required String description,
  required DateTime selectedDate,
}) {
  final title = titleController.text.trim();

  if(selectedDate?.isAfter(DateTime.now()) ?? false) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Этот день еще не настал')),
    );
    return null;
  }


  if (title.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Что у вас случилось?')),
    );
    return null;
  }

  if (selectedEmotion == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Что вы чувствовали?')),
    );
    return null;
  }

  return FeelingData(
    title: title,
    description: description.isNotEmpty ? description : null,
    emotion: selectedEmotion,
    dateTime: selectedDate,
  );
}

Future<void> saveFeelingToHive({
  required BuildContext context,
  required TextEditingController titleController,
  required Emotions? selectedEmotion,
  required String description,
  required DateTime selectedDate,
}) async {
  final feeling = saveFeeling(
    context: context,
    titleController: titleController,
    selectedEmotion: selectedEmotion,
    description: description,
    selectedDate: selectedDate,
  );

  if (feeling != null) {
    try {
      await HiveService.feelingsBox.add(feeling);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Запись сохранена!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка сохранения: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<void> saveAiResponse({
required BuildContext context,
required String aiResponse,
}) async {
  final titleController = TextEditingController(text: 'Ответ помощника');
  final selectedDate = DateTime.now();
  final emotion = Emotions.neutral;

  final feeling = saveFeeling(
    context: context,
    titleController: titleController,
    selectedEmotion: emotion,
    description: aiResponse,
    selectedDate: selectedDate,
  );


  titleController.dispose();
  if (feeling != null) {
    try {
      await HiveService.feelingsBox.add(feeling);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ответ ИИ сохранен в дневник!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка сохранения: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}