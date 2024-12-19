import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime.now();
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(_currentDate.year, _currentDate.month);
  }

  List<Widget> _buildDaysOfWeek() {
    const daysOfWeek = ['Пон', 'Втр', 'Срд', 'Чтв', 'Пят', 'Суб', 'Вос'];
    return daysOfWeek.map((day) {
      return Text(day, style: TextStyle(fontWeight: FontWeight.bold));
    }).toList();
  }

  List<Widget> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month);
    final firstWeekday = (firstDayOfMonth.weekday - 1) % 7;
    final totalDays = DateUtils.getDaysInMonth(_selectedMonth.year, _selectedMonth.month);

    return List.generate(firstWeekday + totalDays, (index) {
      if (index < firstWeekday) {
        return const SizedBox();
      } else {
        final day = index - firstWeekday + 1;
        final isToday = _selectedMonth.year == _currentDate.year &&
            _selectedMonth.month == _currentDate.month &&
            day == _currentDate.day;
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isToday ? Colors.blueAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(day.toString())),
          ),
        );
      }
    });
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(
                        _selectedMonth.year, _selectedMonth.month - 1);
                  });
                },
              ),
              Column(
                children: [
                  Text(
                    _formatMonthYear(_selectedMonth),
                    style: const TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(
                                _selectedMonth.year - 1, _selectedMonth.month);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(
                                _selectedMonth.year + 1, _selectedMonth.month);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(
                        _selectedMonth.year, _selectedMonth.month + 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildDaysOfWeek(),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              children: _buildCalendarDays(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedMonth = DateTime(_currentDate.year, _currentDate.month);
          });
        },
        child: const Icon(Icons.today),
      ),
    );
  }
}
