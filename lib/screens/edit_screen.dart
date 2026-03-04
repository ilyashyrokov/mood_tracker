import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mood_tracker/models/feeling_data.dart';
import 'package:mood_tracker/models/emotions.dart';
import '../screens/home_screen.dart';
import '../utils/update_feeling.dart';
import '../widgets/feelings_form.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/horizontal_calendar.dart';

class EditScreen extends StatefulWidget {
  final FeelingData? item;
  final DateTime? initialDate;

  const EditScreen({super.key, this.item, this.initialDate});
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  Emotions? _selectedEmotion;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
    _selectedEmotion = widget.item?.emotion;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item == null) {
      return const Scaffold(
        body: Center(child: Text('Ошибка: запись не найдена')),
      );
    }

    final key = widget.item!.key;

    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать запись')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HorizontalCalendar(
              initialDate: _selectedDate,
              onDateSelected: (date) {
                setState(() => _selectedDate = date);
              },
            ),

            FeelingsForm(
              titleController: _titleController,
              descriptionController: _descriptionController,
              selectedEmotion: _selectedEmotion,
              selectedDate: _selectedDate,
              onEmotionChanged: (emotion) {
                setState(() {
                  _selectedEmotion = emotion;
                });
              },
              initialTitle: widget.item?.title,
              initialDescription: widget.item?.description,
              initialEmotion: widget.item?.emotion,
              buttonText: 'Сохранить изменения',
              onPressed: () async {
                await updateFeelingInHive(
                  context: context,
                  titleController: _titleController,
                  selectedEmotion: _selectedEmotion,
                  description: _descriptionController.text,
                  existingItem: widget.item!,
                );
                if (mounted) Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),

            CustomElevatedButton(
              text: 'Удалить запись',
              textColor: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              onPressed: () async {
                final box = Hive.box<FeelingData>('feelings');
                await box.delete(key);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Запись удалена')),
                  );
                }
              },
            ),

            const SizedBox(height: 10),

            CustomElevatedButton(
              text: 'Выйти на главный экран',
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}