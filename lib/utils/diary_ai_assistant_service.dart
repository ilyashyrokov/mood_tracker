import 'package:mood_tracker/data/hive_service.dart';
import 'package:mood_tracker/models/feeling_data.dart';
import 'siliconflow_service.dart';

class DiaryAIAssistantService {

  static List<FeelingData> getTodayEntries() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return HiveService.feelingsBox.values.where((entry) {
      final entryDate = DateTime(
          entry.dateTime.year,
          entry.dateTime.month,
          entry.dateTime.day
      );
      return entryDate.isAtSameMomentAs(today);
    }).toList();
  }

  static List<FeelingData> getAllEntries() {
    return HiveService.feelingsBox.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  static List<FeelingData> getLastDaysEntries(int days) {
    final now = DateTime.now();
    final cutoffDate = DateTime(now.year, now.month, now.day - days);

    return HiveService.feelingsBox.values.where((entry) {
      return entry.dateTime.isAfter(cutoffDate);
    }).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  static String formatEntriesForAI(List<FeelingData> entries) {
    if (entries.isEmpty) {
      return "Записей не найдено.";
    }

    StringBuffer buffer = StringBuffer();
    buffer.writeln("Вот записи из дневника (в хронологическом порядке):\n");

    for (var entry in entries) {
      buffer.writeln("📅 ${_formatDate(entry.dateTime)}");
      buffer.writeln("📝 Заголовок: ${entry.title}");
      buffer.writeln("😊 Настроение: ${entry.emotion}");

      if (entry.description != null && entry.description!.isNotEmpty) {
        buffer.writeln("💭 Описание: ${entry.description}");
      }

      buffer.writeln("---");
    }

    return buffer.toString();
  }

  static String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  static Future<String> askAboutToday() async {
    final entries = getTodayEntries();
    final formattedEntries = formatEntriesForAI(entries);

    String systemPrompt = """
Ты - эмпатичный AI ассистент для дневника настроения. Твоя задача - анализировать записи пользователя и давать полезные советы.
Отвечай дружелюбно, поддерживающе и конструктивно. Используй эмодзи для большей выразительности.
Анализируй записи и давай персонализированные советы на основе настроения и описаний.
""";

    String userPrompt = """
Проанализируй записи пользователя за сегодняшний день и дай краткий анализ и совет.

$formattedEntries

Пожалуйста, ответь на русском языке, будь дружелюбным и поддерживающим.
""";

    return await SiliconFlowService.sendMessage(userPrompt, systemPrompt: systemPrompt);
  }

  // Все записи
  static Future<String> askAboutAllEntries() async {
    final entries = getAllEntries();
    final formattedEntries = formatEntriesForAI(entries);

    String systemPrompt = """
Ты - эмпатичный AI ассистент для дневника настроения. Твоя задача - анализировать записи пользователя и давать полезные советы.
Отвечай дружелюбно, поддерживающе и конструктивно. Используй эмодзи для большей выразительности.
Анализируй все записи, выявляй паттерны в настроении и давай рекомендации.
""";

    String userPrompt = """
Проанализируй все записи пользователя и дай общий анализ. Выяви паттерны в настроении, частоту записей, и дай рекомендации.

$formattedEntries

Пожалуйста, ответь на русском языке, будь дружелюбным и поддерживающим.
""";

    return await SiliconFlowService.sendMessage(userPrompt, systemPrompt: systemPrompt);
  }

  // Последние несколько дней
  static Future<String> askAboutLastDays(int days) async {
    final entries = getLastDaysEntries(days);
    final formattedEntries = formatEntriesForAI(entries);

    String systemPrompt = """
Ты - эмпатичный AI ассистент для дневника настроения. Твоя задача - анализировать записи пользователя и давать полезные советы.
Отвечай дружелюбно, поддерживающе и конструктивно. Используй эмодзи для большей выразительности.
""";

    String userPrompt = """
Проанализируй записи пользователя за последние $days дней и дай анализ. Сравни настроение, выяви тенденции.

$formattedEntries

Пожалуйста, ответь на русском языке, будь дружелюбным и поддерживающим.
""";

    return await SiliconFlowService.sendMessage(userPrompt, systemPrompt: systemPrompt);
  }

  // Дай совет
  static Future<String> askForAdvice() async {
    final entries = getAllEntries();
    final formattedEntries = formatEntriesForAI(entries);

    String systemPrompt = """
Ты - эмпатичный AI ассистент для дневника настроения. Твоя задача - давать полезные советы на основе записей пользователя.
Отвечай дружелюбно, поддерживающе и конструктивно. Используй эмодзи для большей выразительности.
Давай конкретные, персонализированные советы, которые помогут улучшить настроение и общее состояние.
""";

    String userPrompt = """
На основе всех записей пользователя, дай несколько полезных советов. 
Учти его текущее настроение, частоту записей и описанные ситуации.

$formattedEntries

Пожалуйста, ответь на русском языке, дай 3-5 конкретных советов, будь дружелюбным.
""";

    return await SiliconFlowService.sendMessage(userPrompt, systemPrompt: systemPrompt);
  }


  static Future<String> userPrompt(String prompt) async{
    final entries = getAllEntries();
    final formattedEntries = formatEntriesForAI(entries);
    String systemPrompt = """
Ты - эмпатичный AI ассистент для дневника настроения. Твоя задача - анализировать записи пользователя и давать полезные советы.
Отвечай дружелюбно, поддерживающе и конструктивно. Используй эмодзи для большей выразительности.
""";
    String userPrompt = """
$prompt

$formattedEntries

Пожалуйста, ответь на русском языке, дай 3-5 конкретных советов, будь дружелюбным.
""";

    return await SiliconFlowService.sendMessage(userPrompt, systemPrompt: systemPrompt);
  }
}

