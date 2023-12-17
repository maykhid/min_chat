extension DateTimeFormatting on DateTime {
  String get format {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inHours == 0) {
      // If time is today, show the exact time
      return formatToTime;
      // return '$hour:${minute.toString().padLeft(2, '0')}';
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

  String get formatDescriptive {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inHours == 0) {
      // If time is today, show the exact time
      return 'Today';
      // return '$hour:${minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // If time is yesterday, show "Yesterday"
      return 'Yesterday';
    } else if (difference.inDays <= 6) {
      // If time is within the week, show the day
      return _getDayOfWeek(weekday, isDescriptive: true);
    } else {
      // Else, show the date
      if (now.year == year) {
        return '${_getDayOfWeek(weekday)}, $day ${_getMonth(month)} ';
      }
      return '$day ${_getMonth(month, isDescriptive: true)}, $year';
    }
  }

  String get formatToTime => '$hour:${minute.toString().padLeft(2, '0')}';

  String _getDayOfWeek(int day, {bool isDescriptive = false}) {
    switch (day) {
      case DateTime.monday:
        return isDescriptive ? 'Monday' : 'Mon';
      case DateTime.tuesday:
        return isDescriptive ? 'Tuesday' : 'Tue';
      case DateTime.wednesday:
        return isDescriptive ? 'Wednesday' : 'Wed';
      case DateTime.thursday:
        return isDescriptive ? 'Thursday' : 'Thu';
      case DateTime.friday:
        return isDescriptive ? 'Friday' : 'Fri';
      case DateTime.saturday:
        return isDescriptive ? 'Saturday' : 'Sat';
      case DateTime.sunday:
        return isDescriptive ? 'Sunday' : 'Sun';
      default:
        return '';
    }
  }

  String _getMonth(int month, {bool isDescriptive = false}) {
    switch (month) {
      case DateTime.january:
        return isDescriptive ? 'January' : 'Jan';
      case DateTime.february:
        return isDescriptive ? 'February' : 'Feb';
      case DateTime.march:
        return isDescriptive ? 'March' : 'Mar';
      case DateTime.april:
        return isDescriptive ? 'April' : 'Apr';
      case DateTime.may:
        return isDescriptive ? 'May' : 'May';
      case DateTime.june:
        return isDescriptive ? 'June' : 'Jun';
      case DateTime.july:
        return isDescriptive ? 'July' : 'Jul';
      case DateTime.august:
        return isDescriptive ? 'August' : 'Aug';
      case DateTime.september:
        return isDescriptive ? 'September' : 'Sep';
      case DateTime.october:
        return isDescriptive ? 'October' : 'Oct';
      case DateTime.november:
        return isDescriptive ? 'November' : 'Nov';
      case DateTime.december:
        return isDescriptive ? 'December' : 'Dec';
      default:
        return '';
    }
  }
}
