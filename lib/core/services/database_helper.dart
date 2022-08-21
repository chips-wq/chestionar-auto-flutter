import 'package:chestionar_auto/core/models/questions_stats.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:chestionar_auto/core/models/question_model.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  Future<Database> database() async {
    final DB_NAME = "main.db";
    //TODO: this is weird on windows as it is literally the documents dir
    String databasesPath = (await getApplicationDocumentsDirectory()).path;

    String path = join(databasesPath, DB_NAME);
    print("The path_provider path is $path");
    //await deleteDatabase(path);
    bool exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", DB_NAME));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      //not tested on linux and macOS, works on windows but i don't promise anything
      sqfliteFfiInit();
      return await databaseFactoryFfi.openDatabase(path);
    }
    // open the database
    return await openDatabase(path, version: 1);
  }

  Future<List<Question>> getQuestions(int numQuestions) async {
    int MIN_NEVER_SEEN = 10;
    print("limit is $numQuestions");
    numQuestions -= MIN_NEVER_SEEN;
    Database _db = await database();
    final List<Map> questionMap = [];
    // List<Map> initialNeverSeenQuestions = await _db.rawQuery(
    //     'SELECT * FROM questions WHERE CATEGORY=\'B\' and nextDueTime IS NULL ORDER BY RANDOM() LIMIT ${10};');
    // print(
    //     "We have ${initialNeverSeenQuestions.length} questions that have never been seen");
    // questionMap.addAll(initialNeverSeenQuestions);
    //add 5 questions we have never seen before
    List<Map> learningMode = await _db.rawQuery(
        'SELECT * FROM questions WHERE CATEGORY=\'B\' AND nextDueTime IS NOT NULL AND strftime(\'%s\' , \'now\') > nextDueTime AND stage=0 ORDER BY RANDOM() LIMIT ${numQuestions};');
    questionMap.addAll(learningMode);
    print("We have ${learningMode.length} questions in learning mode.");
    if (questionMap.length < numQuestions) {
      List<Map> reviewQuestions = await _db.rawQuery(
          'SELECT * FROM questions WHERE CATEGORY=\'B\' AND nextDueTime IS NOT NULL AND strftime(\'%s\' , \'now\') > nextDueTime AND stage=1 ORDER BY RANDOM() LIMIT ${numQuestions - questionMap.length};');
      print("We have ${reviewQuestions.length} questions in review mode.");
      questionMap.addAll(reviewQuestions);
    }
    print("Question map length ${questionMap.length}");
    print("num question length ${numQuestions}");
    int NEVER_SEEN = MIN_NEVER_SEEN + numQuestions - questionMap.length;
    List<Map> neverSeenQuestions = await _db.rawQuery(
        'SELECT * FROM questions WHERE CATEGORY=\'B\' and nextDueTime IS NULL ORDER BY RANDOM() LIMIT ${NEVER_SEEN};');
    print(
        "We have ${neverSeenQuestions.length} questions that have never been seen");
    questionMap.addAll(neverSeenQuestions);
    questionMap.shuffle();
    return List.generate(questionMap.length, (index) {
      return Question(
          id: questionMap[index]['id'],
          text: questionMap[index]['text'],
          correctAnswer: questionMap[index]['answer'],
          explanation: questionMap[index]['explanation'],
          answers: [
            Answer(
              answer: questionMap[index]['textA'],
            ),
            Answer(
              answer: questionMap[index]['textB'],
            ),
            Answer(
              answer: questionMap[index]['textC'],
            ),
          ],
          image: questionMap[index]['image'],
          repetitions: questionMap[index]['repetitions'],
          interval: questionMap[index]['interval'] == null
              ? Duration(days: 1)
              : Duration(seconds: questionMap[index]['interval']),
          easiness: questionMap[index]['easiness'],
          nextDueTime: questionMap[index]['nextDueTime'] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  questionMap[index]['nextDueTime'] * 1000,
                  isUtc: true),
          stage: questionMap[index]['stage'],
          type: questionMap[index]['nextDueTime'] == null
              ? QuestionType.notseen
              : questionMap[index]['stage'] == 0
                  ? QuestionType.learning
                  : QuestionType.review);
    });
  }

  void updateQuestion(Question question) async {
    final db = await database();

    // Update the given Question.
    await db.update(
      'questions',
      question.toMap(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  Future<QuestionsStats> getQuestionsStats() async {
    final db = await database();

    final int neverSeenQuestions = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM questions WHERE CATEGORY=\'B\' AND "
            "nextDueTime IS NULL;"))!;
    final int learningQuestions = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM questions WHERE CATEGORY=\'B\' AND "
            "stage=0 AND nextDueTime IS NOT NULL;"))!;
    final int reviewQuestions = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM questions WHERE CATEGORY=\'B\' AND "
            "stage=1;"))!;

    QuestionsStats questionsStats = QuestionsStats(
        totalQuestions:
            neverSeenQuestions + learningQuestions + reviewQuestions,
        neverSeenQuestions: neverSeenQuestions,
        learningQuestions: learningQuestions,
        reviewQuestions: reviewQuestions);

    return questionsStats;
  }
}
