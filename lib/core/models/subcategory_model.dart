import 'package:chestionar_auto/core/models/questions_stats.dart';

Map<int, String> chapterIdToName = {
  1: 'Indicatoare si marcaje',
  2: 'Semnalele politistului',
  3: 'Semnalele luminoase',
  4: 'Pozitia si semnalele',
  5: 'Depasirea',
  6: 'Viteza si distanta',
  7: 'Manevre',
  8: 'Prioritatea de trecere',
  9: 'Calea ferata',
  10: 'Oprirea si stationarea',
  11: 'Circulatia pe autostrazi',
  12: 'Obligatiile conducatorilor auto',
  13: 'Sanctiuni si infractiuni',
  14: 'Reguli generale',
  15: 'Conducerea preventiva',
  16: 'Masuri de prim ajutor',
  17: 'Conducerea ecologica',
  18: 'Notiuni de mecanica',
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
