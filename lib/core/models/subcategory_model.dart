import 'package:chestionar_auto/core/models/questions_stats.dart';

Map<int, String> chapterIdToName = {
  1: 'Indicatoare și marcaje',
  2: 'Semnalele polițistului',
  3: 'Semnalele luminoase',
  4: 'Poziția și semnalele',
  5: 'Depășirea',
  6: 'Viteza și distanța',
  7: 'Manevre',
  8: 'Prioritatea de trecere',
  9: 'Calea ferată',
  10: 'Oprirea și staționarea',
  11: 'Circulația pe autostrăzi',
  12: 'Obligațiile conducătorilor auto',
  13: 'Sancțiuni și infracțiuni',
  14: 'Reguli generale',
  15: 'Conducerea preventivă',
  16: 'Măsuri de prim ajutor',
  17: 'Conducerea ecologică',
  18: 'Noțiuni de mecanică',
};

class Subcategory {
  final int chapter;
  final String name;

  QuestionsStats?
      stats; //these are the stats of the current subcategory -> should only get populated on the subcategory page

  @override
  String toString() {
    return "Subcategory(chapter: $chapter , name: $name)";
  }

  //the ids that may be passed here are in the range [1,18] and the categories chapters only have these ids
  Subcategory(this.chapter) : name = chapterIdToName[chapter]!;
}
