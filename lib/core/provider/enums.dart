enum DrivingCategory { A, B, C, D, E }

extension ParseToString on DrivingCategory {
  String toShortString() {
    return toString().split('.').last;
  }
}
