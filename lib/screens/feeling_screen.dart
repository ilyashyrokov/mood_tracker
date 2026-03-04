import 'package:flutter/material.dart';
import 'package:mood_tracker/models/feeling_data.dart';
import '../screens/home_screen.dart';

class FeelingScreen extends StatefulWidget {
  final FeelingData? item;


  const FeelingScreen({super.key, this.item});

  @override
  State<FeelingScreen> createState() => _FeelingScreenState();
}

class _FeelingScreenState extends State<FeelingScreen> {
  Color cardBorderColor = Colors.grey; // Default fallback
  Color cardBackgroundColor = Colors.white;
  Color titleTextColor = Colors.black87;
Color boxShadowColor = Colors.white38;
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    if (item != null) {
      cardBorderColor = item.emotion.color.withOpacity(0.3);
      titleTextColor = item.emotion.color.withOpacity(0.9);
      cardBackgroundColor = item.emotion.color.withOpacity(0.1);
      boxShadowColor = item.emotion.color.withOpacity(0.2);
    }


    if (item == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Запись'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Нет данных',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Запись'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: cardBackgroundColor,
                    elevation: 8,
                    shadowColor: boxShadowColor,
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: cardBorderColor, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title ?? 'Без названия',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: titleTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Expanded для прокрутки описания
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                item.description ?? 'Вы ничем не поделились',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  ),
                  child: const Text('Выйти на главный экран'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
