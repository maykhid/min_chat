extension DateTimeFormatting on DateTime {
  String get format  {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      // If time is today, show the exact time
      return '$hour:${minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // If time is yesterday, show "Yesterday"
      return 'Yesterday';
    } else if (difference.inDays <= 6) {
      // If time is within the week, show the day
      return _getDayOfWeek(weekday);
    } else {
      // Else, show the date
      return '$day/$month/$year';
    }
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
