import 'package:flutter/material.dart';
import 'package:mood_tracker/widgets/custom_elevated_button.dart';
import '../widgets/prompt_button.dart';
import '../utils/diary_ai_assistant_service.dart';
import '../utils/save_feeling.dart';

enum PromptType { today, all, lastDays, advice, user }

class AiCompanionScreen extends StatefulWidget {
  const AiCompanionScreen({super.key});

  @override
  State<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends State<AiCompanionScreen> {
  String _response = 'Здесь будет ваш ответ!';
  bool _isLoading = false;
  late final TextEditingController _promptController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handlePrompt(PromptType type, [String? customPrompt]) async {
    if (type == PromptType.user) {
      final promptText = customPrompt ?? _promptController.text.trim();
      if (promptText.isEmpty) {
        setState(() {
          _response = 'Пожалуйста, введите сообщение перед отправкой.';
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _response = 'Думаю...';
    });

    try {
      String response;
      switch (type) {
        case PromptType.today:
          response = await DiaryAIAssistantService.askAboutToday();
          break;
        case PromptType.all:
          response = await DiaryAIAssistantService.askAboutAllEntries();
          break;
        case PromptType.lastDays:
          response = await DiaryAIAssistantService.askAboutLastDays(7);
          break;
        case PromptType.advice:
          response = await DiaryAIAssistantService.askForAdvice();
          break;
        case PromptType.user:
          final promptText = customPrompt ?? _promptController.text.trim();
          response = await DiaryAIAssistantService.userPrompt(promptText);
          if (mounted) {
            _promptController.clear();
            _focusNode.unfocus();
          }
          break;
      }

      if (mounted) {
        setState(() {
          _response = response;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _response =
              'Извините, произошла ошибка: ${e.toString().replaceAll('"', '')}. Пожалуйста, попробуйте позже.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  void _saveAiResponse(){
    saveAiResponse(context: context, aiResponse: _response);
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваш виртуальный помощник'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(1, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Text(
                            _response,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                ),
              ),

              if (_response != 'Здесь будет ваш ответ!' && !_isLoading)
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      CustomElevatedButton(text: 'Сохранить ответ',
                          textColor: Theme.of(context).colorScheme.secondary,
                          onPressed: _saveAiResponse),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              TextField(
                controller: _promptController,
                focusNode: _focusNode,
                enabled: !_isLoading,
                onSubmitted: _isLoading
                    ? null
                    : (value) => _handlePrompt(PromptType.user),
                maxLines: null,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: 'Введите сообщение...',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  suffixIcon: IconButton(
                    onPressed: _isLoading
                        ? null
                        : () => _handlePrompt(PromptType.user),
                    icon: Icon(
                      Icons.send_rounded,
                      color: _isLoading
                          ? colorScheme.onSurfaceVariant.withOpacity(0.5)
                          : colorScheme.primary,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'О чём мне вам рассказать?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      PromptButton(
                        text: 'Сегодняшний день',
                        onPressed: _isLoading
                            ? () {}
                            : () => _handlePrompt(PromptType.today),
                      ),
                      PromptButton(
                        text: 'Все записи',
                        onPressed: _isLoading
                            ? () {}
                            : () => _handlePrompt(PromptType.all),
                      ),
                      PromptButton(
                        text: 'Последние 7 дней',
                        onPressed: _isLoading
                            ? () {}
                            : () => _handlePrompt(PromptType.lastDays),
                      ),
                      PromptButton(
                        text: 'Дай мне совет',
                        onPressed: _isLoading
                            ? () {}
                            : () => _handlePrompt(PromptType.advice),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
