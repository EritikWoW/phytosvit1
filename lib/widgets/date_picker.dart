import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:phytosvit/style/colors.dart'; // Ваша кастомная палитра

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime selectedDate;
  late DateTime focusedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    focusedDate = widget.initialDate;
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: selectedDate.hour,
        minute: selectedDate.minute,
      ),
      builder: (BuildContext context, Widget? child) {
        // Получаем ширину родителя с помощью MediaQuery
        final double parentWidth = MediaQuery.of(context).size.width;
        final double parentHeight = MediaQuery.of(context).size.height;

        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: AppColors.greenTeeColor,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: AppColors.lightBackgroundColor,
          ),
          child: Center(
            child: SizedBox(
              width: parentWidth,
              height: parentHeight,
              child: child,
            ),
          ),
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _changeMonth(int offset) {
    setState(() {
      focusedDate = DateTime(focusedDate.year, focusedDate.month + offset, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Календарь с кастомным заголовком
          TableCalendar(
            locale: 'uk_UA',
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: focusedDate,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
            daysOfWeekVisible: false,
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDate = DateTime(
                  selected.year,
                  selected.month,
                  selected.day,
                  selectedDate.hour,
                  selectedDate.minute,
                );
                focusedDate = focused;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.blueAccent,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.greenTeeColor,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: const TextStyle(
                color: Colors.red,
              ),
              defaultTextStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                String monthName = DateFormat('MMMM', 'uk').format(day);
                return Column(
                  children: [
                    // Заголовок с месяцем и стрелками
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset('assets/svg/arrow_left.svg'),
                            onPressed: () => _changeMonth(-1),
                          ),
                          Text(
                            '${monthName[0].toUpperCase()}${monthName.substring(1)} ${day.year}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon:
                                SvgPicture.asset('assets/svg/arrow_right.svg'),
                            onPressed: () => _changeMonth(1),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade400, thickness: 1),
                    // Дни недели с кастомным фоном
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text("Пн",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Вт",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Ср",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Чт",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Пт",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Сб",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                          Text("Вс",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade400, thickness: 1),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Время и кнопка в строку
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _showTimePicker,
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${selectedDate.hour.toString().padLeft(2, '0')} : ${selectedDate.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                  backgroundColor: AppColors.greenTeeColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  widget.onDateSelected(selectedDate);
                  Navigator.of(context).pop(selectedDate);
                },
                child: const Text(
                  "Установить дату",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
