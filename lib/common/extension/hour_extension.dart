extension HourExtension on DateTime {
  int getFormattedHour() {
    if (hour < 7 || hour > 21) {
      return 7;
    }
    return hour;
  }
}
