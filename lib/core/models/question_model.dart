import 'package:chestionar_auto/core/utils/sm_utils.dart';
import 'package:chestionar_auto/core/utils/time_utils.dart';

class Answer {
  final String answer;

  Answer({
    required this.answer,
  });
}

enum QuestionType { notseen, learning, review }

class Question {
  final int id;
  final int correctAnswer;
  final String text;
  final String? image;
  final String? explanation;
  QuestionType type;
  List<Answer> answers;

  int stage;
  int repetitions;
  Duration interval;
  double easiness;
  DateTime? nextDueTime;

  String get typeName {
    if (type == QuestionType.notseen) {
      return 'N';
    }
    if (type == QuestionType.learning) {
      return 'L';
    }
    if (type == QuestionType.review) {
      return 'R';
    }
    return 'Error';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'repetitions': repetitions,
      'interval': interval.inSeconds,
      'easiness': easiness,
      'stage': stage,
      'nextDueTime': getSecondsSinceEpoch(nextDueTime)
    };
  }

  @override
  String toString() {
    Map m = toMap();
    m['nextDueTime'] = DateTime.fromMillisecondsSinceEpoch(
        m['nextDueTime'] * 1000,
        isUtc: true);
    return m.toString();
  }

  void updateSm2(int quality) {
    //quality in the range[0,5]
    SmAlg sm = SmAlg(
        stage: stage,
        repetitions: repetitions,
        interval: interval,
        easiness: easiness,
        quality: quality);
    SmResponse smResp = sm.calc();
    repetitions = smResp.repetitions;
    stage = smResp.stage;
    interval = smResp.interval;
    easiness = smResp.easiness;
    nextDueTime = smResp.nextDueTime;
    return;
  }

  Question(
      {required this.id,
      required this.text,
      required this.image,
      required this.correctAnswer,
      required this.answers,
      required this.repetitions,
      required this.interval,
      required this.easiness,
      required this.nextDueTime,
      required this.stage,
      required this.type,
      required this.explanation});
}
