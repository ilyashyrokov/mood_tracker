import 'package:flutter/material.dart';
import 'package:mood_tracker/screens/feelings_list.dart';
import '../widgets/horizontal_calendar.dart';
import '../widgets/feelings_form.dart';
import '../widgets/custom_elevated_button.dart';

class HomeScreen extends StatefulWidget {
  final DateTime? initialDate;

  const HomeScreen({super.key, this.initialDate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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

                  const SizedBox(height: 8),

                  FeelingsForm(
                    selectedDate: _selectedDate,
                  ),

                  const SizedBox(height: 12),

                  CustomElevatedButton(
                    textColor: Theme.of(context).colorScheme.secondary,
                    text: 'Посмотреть события за этот день',
                    onPressed: () async {
                      final selectedDateFromList = await Navigator.push<DateTime>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeelingsList(initialDate: _selectedDate),
                        ),
                      );
                      if (selectedDateFromList != null) {
                        setState(() => _selectedDate = selectedDateFromList);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  CustomElevatedButton(
                    text: 'Ваш личный помощник',
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () => Navigator.pushNamed(context, '/aiCompanionScreen'),
                  ),

                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}