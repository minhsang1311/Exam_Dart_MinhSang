// lib/models/student.dart

class Student {
  String id;
  String name;
  List<Subject> subjects;

  Student({required this.id, required this.name, required this.subjects});

  factory Student.fromJson(Map<String, dynamic> json) {
    var list = json['subjects'] as List;
    List<Subject> subjectsList = list.map((i) => Subject.fromJson(i)).toList();

    return Student(
      id: json['id'],
      name: json['name'],
      subjects: subjectsList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subjects': subjects.map((s) => s.toJson()).toList(),
      };
}

class Subject {
  String name;
  List<int> score;

  Subject({required this.name, required this.score});

  factory Subject.fromJson(Map<String, dynamic> json) {
    var list = json['score'] as List;
    List<int> scoreList = List<int>.from(list);

    return Subject(
      name: json['name'],
      score: scoreList,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
      };
}
