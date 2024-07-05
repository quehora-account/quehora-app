import 'package:cloud_firestore/cloud_firestore.dart';

class Level {
  final String id;
  final int level;
  final String title;
  final String imagePath;
  final String blankImagePath;
  final String displayedLevel;
  final int experienceRequired;

  /// Initialized in the user bloc.
  static late List<Level> levels;

  factory Level.fromSnapshot(QueryDocumentSnapshot doc) {
    return Level(
      id: doc.id,
      level: doc['level'],
      title: doc['title'],
      imagePath: doc['imagePath'],
      experienceRequired: doc['experienceRequired'],
      blankImagePath: doc['blankImagePath'],
      displayedLevel: doc['displayedLevel'],
    );
  }

  Level(
      {required this.id,
      required this.level,
      required this.title,
      required this.imagePath,
      required this.blankImagePath,
      required this.displayedLevel,
      required this.experienceRequired});

  static List<Level> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Level> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Level.fromSnapshot(doc));
    }
    return list;
  }

  static int getLevelFromExperience(int experience) {
    int i = 1;

    for (Level level in Level.levels) {
      if (experience >= level.experienceRequired) {
        i = level.level;
      }
    }

    return i;
  }

  static Level getLevel(int index) {
    for (Level level in Level.levels) {
      if (level.level == index) {
        return level;
      }
    }
    throw Exception('Level not found');
  }

  Level? getNextLevel() {
    /// Position in array
    int pos = level - 1;

    /// The operation sounds stupid ( - then + ), but it's more clear to understand.
    if (pos + 1 >= levels.length) {
      return null;
    }
    return levels[pos + 1];
  }
}
