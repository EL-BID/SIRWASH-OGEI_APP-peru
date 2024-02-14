part of 'utils.dart';

Future<DateTime?> pickDate(BuildContext context, DateTime initialDateTime,
    {DateTime? firstDate, DateTime? lastDate}) async {
  final newDate = await showDatePicker(
    context: context,
    initialDate: initialDateTime,
    firstDate: firstDate ?? DateTime.now(),
    lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (BuildContext context, Widget? child) {
      if (child == null) return const SizedBox();

      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: akAccentColor,
            onPrimary: akTitleColor,
            surface: akAccentColor,
            onSurface: akTitleColor,
          ),
          dialogBackgroundColor: akScaffoldBackgroundColor,
        ),
        child: child,
      );
    },
  );
  return newDate;
}

Future<TimeOfDay?> pickTime(
    BuildContext context, DateTime initialDateTime) async {
  final newTime = await showTimePicker(
    context: context,
    initialTime:
        TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute),
    builder: (BuildContext context, Widget? child) {
      if (child == null) return const SizedBox();

      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: akAccentColor,
            onPrimary: akTitleColor,
            surface: akScaffoldBackgroundColor,
            onSurface: akTitleColor,
          ),
        ),
        child: child,
      );
    },
  );
  return newTime;
}
