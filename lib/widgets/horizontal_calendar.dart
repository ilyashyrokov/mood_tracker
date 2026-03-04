import 'package:flutter/material.dart';

class HorizontalCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;

  const HorizontalCalendar({
    super.key,
    this.initialDate,
    this.onDateSelected,
  });

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late DateTime _selectedDate;
  late final List<DateTime> _dates;
  final ScrollController _scrollController = ScrollController();

  final int _itemsBeforeToday = 1000;
  final int _itemsAfterToday = 1000;
  final double _itemWidth = 68;

  @override
  void initState() {
    super.initState();

    _selectedDate = _stripTime(
      widget.initialDate ?? DateTime.now(),
    );

    _dates = _generateDates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(covariant HorizontalCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialDate == null) return;

    final newDate = _stripTime(widget.initialDate!);

    if (!_isSameDay(newDate, _selectedDate)) {
      setState(() {
        _selectedDate = newDate;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedDate();
      });
    }
  }

  List<DateTime> _generateDates() {
    final today = _stripTime(DateTime.now());
    final dates = <DateTime>[];

    for (int i = _itemsBeforeToday; i > 0; i--) {
      dates.add(today.subtract(Duration(days: i)));
    }

    dates.add(today);

    for (int i = 1; i <= _itemsAfterToday; i++) {
      dates.add(today.add(Duration(days: i)));
    }

    return dates;
  }

  void _scrollToSelectedDate() {
    if (!_scrollController.hasClients) return;

    final index = _dates.indexWhere(
          (d) => _isSameDay(d, _selectedDate),
    );

    if (index == -1) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset =
        index * _itemWidth - (screenWidth / 2) + (_itemWidth / 2);

    _scrollController.animateTo(
      targetOffset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  DateTime _stripTime(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const SizedBox(width: 58),
            Expanded(
              child: Text(
                '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/settingsScreen');
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            itemBuilder: (context, index) {
              final date = _dates[index];
              final isToday = _isSameDay(date, DateTime.now());
              final isSelected = _isSameDay(date, _selectedDate);

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                  widget.onDateSelected?.call(date);
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : isToday
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 2)
                        : isToday
                        ? Border.all(color: Theme.of(context).colorScheme.primary)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _dayOfWeek(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onSecondary
                              : isToday
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onSecondary
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _month(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onSecondary
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Divider(color: Theme.of(context).colorScheme.secondaryFixedDim),
      ],
    );
  }

  String _dayOfWeek(DateTime date) {
    const days = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];
    return days[date.weekday % 7];
  }

  String _month(DateTime date) {
    const months = [
      'Янв',
      'Фев',
      'Мар',
      'Апр',
      'Май',
      'Июн',
      'Июл',
      'Авг',
      'Сен',
      'Окт',
      'Ноя',
      'Дек',
    ];
    return months[date.month - 1];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
