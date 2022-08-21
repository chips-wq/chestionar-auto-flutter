import 'dart:math';

class SmResponse {
  final int stage;
  final Duration interval;
  final DateTime nextDueTime;
  final int repetitions;
  final double easiness;

  SmResponse(
      {required this.stage,
      required this.interval,
      required this.nextDueTime,
      required this.repetitions,
      required this.easiness});
}

class SmAlg {
  int stage;
  int repetitions;
  Duration interval;
  double easiness;
  int quality;

  SmAlg(
      {required this.stage,
      required this.repetitions,
      required this.interval,
      required this.easiness,
      required this.quality});

  SmResponse calc() {
    if (stage == 0) {
      return sm2Learn();
    }
    return sm2Review();
  }

  SmResponse sm2Learn() {
    //mock alghorithm for learning questions made by no other man but me
    if (quality > 2) {
      //graduate to stage 1(review stage)
      repetitions = 0;
      stage = 1;
      return sm2Review();
    }
    if (quality <= 2) {
      //question answered incorrectly
      if (quality == 0) {
        interval = Duration(minutes: 1);
        repetitions = 0;
      } else if (quality > 0) {
        interval = Duration(minutes: 10);
        repetitions = repetitions + 1;
      }
    }
    return SmResponse(
        stage: stage,
        interval: interval,
        nextDueTime: getNextDueTime(interval),
        repetitions: repetitions,
        easiness: easiness);
  }

  SmResponse sm2Review() {
    //you are in review mode so check if the quality is (0 should be dropped to relearn mode)
    if (quality == 0) {
      easiness = 2.5;
      repetitions = 0;
      stage = 0;
      return sm2Learn();
    }
    easiness = max(1.3,
        easiness + 0.1 - (5.0 - quality) * (0.08 + (5.0 - quality) * 0.02));

    // repetitions
    if (quality < 3) {
      repetitions = 0;
    } else {
      repetitions += 1;
    }

    // interval
    if (repetitions <= 1) {
      interval = Duration(days: 1);
    } else if (repetitions == 2) {
      interval = Duration(days: 3);
    } else {
      interval = Duration(days: (interval.inDays * easiness).round());
    }

    return SmResponse(
        stage: stage,
        interval: interval,
        nextDueTime: getNextDueTime(interval),
        repetitions: repetitions,
        easiness: easiness);
  }

  DateTime getNextDueTime(Duration interval) {
    DateTime now = DateTime.now().toUtc();
    return now.add(interval);
  }
}
