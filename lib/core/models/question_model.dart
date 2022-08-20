import 'package:chestionar_auto/utils/sm_utils.dart';

class Answer {
  final String answer;

  Answer({
    required this.answer,
  });
}

int? getSecondsSinceEpoch(DateTime? datetime) {
  if (datetime == null) {
    return null;
  }
  return (datetime.millisecondsSinceEpoch / 1000).round();
}

enum QuestionType { Nevazute, Learning, Revizuire }

class Question {
  final int id;
  final int correctAnswer;
  final String text;
  final String? image;
  final String explanation;
  QuestionType type;
  List<Answer> answers;

  int stage;
  int repetitions;
  Duration interval;
  double easiness;
  DateTime? nextDueTime;

  String getTypeName() {
    if (type == QuestionType.Nevazute) {
      return 'N';
    }
    if (type == QuestionType.Learning) {
      return 'L';
    }
    if (type == QuestionType.Revizuire) {
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

  bool isSelectedCorrect(List<bool> selectedAnswers) {
    int sum = 0;
    selectedAnswers.forEach((element) => sum += element ? 1 : 0);
    if (sum == 1 && correctAnswer < 4) {
      return selectedAnswers[correctAnswer - 1];
    }
    if (sum == 3) {
      return correctAnswer == 7;
    }
    if (correctAnswer == 4) {
      return selectedAnswers[0] && selectedAnswers[1];
    }
    if (correctAnswer == 5) {
      return selectedAnswers[0] && selectedAnswers[2];
    }
    if (correctAnswer == 6) {
      return selectedAnswers[1] && selectedAnswers[2];
    }
    if (sum == 2) {
      return false;
    }
    throw ("correctAnswer not in the range [1,7]");
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
