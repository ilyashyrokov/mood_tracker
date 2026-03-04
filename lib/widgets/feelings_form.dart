import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/save_feeling.dart';
import 'custom_elevated_button.dart';
import '../models/emotions.dart';

class FeelingsForm extends StatefulWidget {
  final String? buttonText;
  final String? initialTitle;
  final String? initialDescription;
  final Emotions? initialEmotion;
  final VoidCallback? onPressed;
  final TextEditingController? titleController;
  final TextEditingController? descriptionController;
  final ValueChanged<Emotions?>? onEmotionChanged;
  final Emotions? selectedEmotion;
  final DateTime selectedDate;

  const FeelingsForm({
    super.key,
    this.buttonText,
    this.initialTitle,
    this.initialDescription,
    this.initialEmotion,
    this.onPressed,
    this.titleController,
    this.descriptionController,
    this.onEmotionChanged,
    this.selectedEmotion,
    required this.selectedDate,
  });

  @override
  State<FeelingsForm> createState() => _FeelingsFormState();
}

class _FeelingsFormState extends State<FeelingsForm> {
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  Emotions? selectedEmotion;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = widget.titleController ?? TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController = widget.descriptionController ?? TextEditingController(text: widget.initialDescription ?? '');
    selectedEmotion = widget.selectedEmotion ?? widget.initialEmotion;
  }

  @override
  void didUpdateWidget(FeelingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialTitle != widget.initialTitle) {
      _titleController.text = widget.initialTitle ?? '';
    }
    if (oldWidget.initialDescription != widget.initialDescription) {
      _descriptionController.text = widget.initialDescription ?? '';
    }
    if (oldWidget.initialEmotion != widget.initialEmotion) {
      setState(() {
        selectedEmotion = widget.initialEmotion;
      });
    }
  }

  @override
  void dispose() {
    if (widget.titleController == null) _titleController.dispose();
    if (widget.descriptionController == null) _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveFeeling() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await saveFeelingToHive(
        context: context,
        titleController: _titleController,
        selectedEmotion: selectedEmotion,
        description: _descriptionController.text,
        selectedDate: widget.selectedDate,
      );

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        selectedEmotion = null;
      });
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(1, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Ситуация...',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(1, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 4,
            minLines: 4,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: 'Что вы чувствуете? Опишите подробнее...',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ),

        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: Emotions.values.map((emotion) {
                return emotion.ovalButton(
                  onPressed: () {
                    setState(() {
                      HapticFeedback.mediumImpact();
                      selectedEmotion = emotion;
                    });
                    widget.onEmotionChanged?.call(emotion);
                  },
                  isSelected: selectedEmotion == emotion,
                );
              }).toList(),
            );
          },
        ),

        const SizedBox(height: 12),

        Center(
          child: _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : CustomElevatedButton(
                  textColor: Theme.of(context).colorScheme.secondary,
                  text: widget.buttonText ?? 'Добавить запись',
                  onPressed: widget.onPressed ?? _saveFeeling,
                ),
        ),
        const SizedBox(height: 2),
      ],
    );
  }
}
