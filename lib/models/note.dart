const String tableNotes = 'notes';

class NoteFields {
  static const String id = 'Id';
  static const String isImportant = 'is_important';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class Note {
  int? id;
  bool isImportant;
  int number;
  String title;
  String description;
  DateTime createdTime;

  Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copyC({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) {
    return Note(
      id: id ?? this.id,
      isImportant: isImportant ?? this.isImportant,
      number: number ?? this.number,
      title: title ?? this.title,
      description: description ?? this.description,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  static Note fromJson(Map<String, Object?> json) {
    return Note(
      id: json[NoteFields.id] as int?,
      isImportant: json[NoteFields.isImportant] == 1,
      number: json[NoteFields.number] as int,
      title: json[NoteFields.title] as String,
      description: json[NoteFields.description] as String,
      createdTime: DateTime.parse(json[NoteFields.time] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      NoteFields.id: id,
      NoteFields.isImportant: isImportant,
      NoteFields.number: number,
      NoteFields.title: title,
      NoteFields.description: description,
      NoteFields.time: createdTime.toIso8601String(),
    };
  }
}