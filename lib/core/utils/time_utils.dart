int? getSecondsSinceEpoch(DateTime? datetime) {
  if (datetime == null) {
    return null;
  }
  return (datetime.millisecondsSinceEpoch / 1000).round();
}
