import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mood_tracker/screens/edit_screen.dart';
import '../widgets/horizontal_calendar.dart';
import '../widgets/feelings.dart';
import 'feeling_screen.dart';
import '../models/feeling_data.dart';

class FeelingsList extends StatefulWidget {
  final DateTime? initialDate;

  const FeelingsList({super.key, this.initialDate});

  @override
  State<FeelingsList> createState() => _FeelingsListState();
}

class _FeelingsListState extends State<FeelingsList> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  List<FeelingData> _getFilteredList() {
    final box = Hive.box<FeelingData>('feelings');
    final currentList = box.values.toList();

    return currentList.where((item) {
      final itemDate = DateTime(
        item.dateTime.year,
        item.dateTime.month,
        item.dateTime.day,
      );

      final selectedDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );

      return itemDate == selectedDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<FeelingData>('feelings').listenable(),
      builder: (context, box, child) {
        final filteredList = _getFilteredList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Записи за день'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, _selectedDate);
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  HorizontalCalendar(
                    initialDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_selectedDate?.isAfter(DateTime.now()) ?? false)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Этот день ещё не настал',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                 else if (filteredList.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.sentiment_neutral,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Вы ничем не поделились за этот день',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          final item = filteredList[index];
                          return Feelings(
                            title: item.title,
                            description:
                                item.description ?? 'Вы ничем не поделились',
                            emotion: item.emotion,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FeelingScreen(item: item),
                                ),
                              );
                            },
                           onEditTap: () async {
                            final selectedDateFromList = await Navigator.push<DateTime>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditScreen(initialDate: _selectedDate, item: item),
                              ),
                            );
                            if (selectedDateFromList != null) {
                              setState(() => _selectedDate = selectedDateFromList);
                            }
                          },
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                        itemCount: filteredList.length,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
