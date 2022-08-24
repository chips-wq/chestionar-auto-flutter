import 'package:chestionar_auto/core/models/questions_stats.dart';
import 'package:chestionar_auto/core/models/subcategory_model.dart';
import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:chestionar_auto/core/models/question_model.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite_common/sqlite_api.dart';
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

  Future<List<Map>> getPracticeQuestions(
      int numQuestions, DrivingCategory drivingCategory,
      [Subcategory? subcategory]) async {
    int MIN_NEVER_SEEN = 10;
    print("limit is $numQuestions");
    print("The driving category is $drivingCategory");
    numQuestions -= MIN_NEVER_SEEN;
    Database _db = await database();
    final List<Map> questionMap = [];
    //LEARNING QUESTIONS

    List<String> queryArgs = [drivingCategory.toShortString()];
    if (subcategory != null) {
      queryArgs.add(subcategory.chapter.toString());
    }
    List<Map> learningMode = await _db.query('questions',
        where:
            'category = ? AND strftime(\'%s\' , \'now\') > nextDueTime AND stage=0 ${subcategory == null ? "" : "AND chapter = ?"}',
        orderBy: 'RANDOM()',
        limit: numQuestions,
        whereArgs: queryArgs);
    questionMap.addAll(learningMode);
    print("We have ${learningMode.length} questions in learning mode.");

    //REVIEW QUESTIONS
    if (questionMap.length < numQuestions) {
      List<Map> reviewQuestions = await _db.query('questions',
          where:
              'category = ? AND strftime(\'%s\' , \'now\') > nextDueTime AND stage=1 ${subcategory == null ? "" : "AND chapter = ?"}',
          orderBy: 'RANDOM()',
          limit: numQuestions - questionMap.length,
          whereArgs: queryArgs);
      print("We have ${reviewQuestions.length} questions in review mode.");
      questionMap.addAll(reviewQuestions);
    }

    int NEVER_SEEN = MIN_NEVER_SEEN + numQuestions - questionMap.length;
    //NEVER SEEN QUESTIONS
    List<Map> neverSeenQuestions = await _db.query('questions',
        where:
            'category = ? AND nextDueTime IS NULL ${subcategory == null ? "" : "AND chapter = ?"}',
        orderBy: 'RANDOM()',
        limit: NEVER_SEEN,
        whereArgs: queryArgs);
    print(
        "We have ${neverSeenQuestions.length} questions that have never been seen");
    questionMap.addAll(neverSeenQuestions);
    questionMap.shuffle();
    return questionMap;
  }

  Future<List<Question>> getQuestions(
    int numQuestions,
    DrivingCategory drivingCategory, [
    Subcategory? subcategory,
    bool practice = true,
  ]) async {
    List<Map> questionMap = [];
    if (practice) {
      questionMap = await getPracticeQuestions(
          numQuestions, drivingCategory, subcategory);
    } else {
      Database db = await database();
      questionMap.addAll(await db.query('questions',
          where: 'category = ?',
          whereArgs: [drivingCategory.toShortString()],
          limit: numQuestions,
          orderBy: 'RANDOM ()'));
    }
    if (questionMap.isEmpty) {
      return [];
    }
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

  Future<List<Subcategory>> getSubcategories(
      DrivingCategory drivingCategory) async {
    Database db = await database();
    final List<Map> subcategoriesId = await db.rawQuery(
        "SELECT DISTINCT(chapter) FROM questions WHERE category = ? ORDER BY chapter;",
        [drivingCategory.toShortString()]);

    final List<Subcategory> subcategoriesList =
        subcategoriesId.map((e) => Subcategory(e['chapter'])).toList();

    return subcategoriesList;
  }

  Future<QuestionsStats> getQuestionsStats(DrivingCategory drivingCategory,
      [Subcategory? subcategory]) async {
    final db = await database();
    List<String> queryArgs = [drivingCategory.toShortString()];
    if (subcategory != null) {
      queryArgs.add(subcategory.chapter.toString());
    }
    final int neverSeenQuestions = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM questions WHERE CATEGORY= ? AND "
        "nextDueTime IS NULL ${subcategory == null ? "" : "AND chapter = ?"};",
        queryArgs))!;
    final int learningQuestions = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM questions WHERE CATEGORY=? AND "
        "stage=0 AND nextDueTime IS NOT NULL ${subcategory == null ? "" : "AND chapter = ?"};",
        queryArgs))!;
    final int reviewQuestions = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM questions WHERE CATEGORY= ? AND "
        "stage=1 ${subcategory == null ? "" : "AND chapter = ?"};",
        queryArgs))!;

    final int toLearnNowQuestions = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM questions WHERE CATEGORY= ? AND "
        "stage=0 AND strftime(\'%s\') > nextDueTime ${subcategory == null ? "" : "AND chapter = ?"};",
        queryArgs))!;

    final int toReviewNowQuestions = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM questions WHERE CATEGORY= ? AND "
        "stage=1 AND strftime(\'%s\') > nextDueTime ${subcategory == null ? "" : "AND chapter = ?"};",
        queryArgs))!;

    //await Future.delayed(Duration(milliseconds: 500));

    QuestionsStats questionsStats = QuestionsStats(
      totalQuestions: neverSeenQuestions + learningQuestions + reviewQuestions,
      neverSeenQuestions: neverSeenQuestions,
      learningQuestions: learningQuestions,
      reviewQuestions: reviewQuestions,
      toLearnNowQuestions: toLearnNowQuestions,
      toReviewNowQuestions: toReviewNowQuestions,
    );

    return questionsStats;
  }
}
