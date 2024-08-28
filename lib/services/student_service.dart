// lib/services/student_service.dart
import 'dart:convert';
import 'dart:io';
import '../models/student.dart';

class StudentService {
  final String filename;

  StudentService(this.filename);

  Future<List<Student>> loadStudents() async {
    final file = File(filename);
    if (!file.existsSync()) {
      return [];
    }
    final jsonString = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((json) => Student.fromJson(json)).toList();
  }

  Future<void> saveStudents(List<Student> students) async {
    final file = File(filename);
    final jsonString = jsonEncode(students.map((s) => s.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  void displayStudents(List<Student> students) {
    for (var student in students) {
      print('ID: ${student.id}');
      print('Tên: ${student.name}');
      for (var subject in student.subjects) {
        print('  Môn học: ${subject.name}');
        print('    Điểm: ${subject.score.join(', ')}');
      }
      print('---');
    }
  }

  Future<List<Student>> addStudent(List<Student> students) async {
    print('Nhập ID sinh viên:');
    final id = stdin.readLineSync()!;
    print('Nhập tên sinh viên:');
    final name = stdin.readLineSync()!;
    
    List<Subject> subjects = [];
    while (true) {
      print('Nhập tên môn học (hoặc "x" để kết thúc):');
      final subjectName = stdin.readLineSync()!;
      if (subjectName.toLowerCase() == 'x') break;

      print('Nhập điểm (cách nhau bởi dấu phẩy):');
      final scores = stdin.readLineSync()!.split(',').map(int.parse).toList();

      subjects.add(Subject(name: subjectName, score: scores));
    }

    students.add(Student(id: id, name: name, subjects: subjects));
    await saveStudents(students);
    return students;
  }

  Future<List<Student>> editStudent(List<Student> students) async {
    print('Nhập ID sinh viên cần chỉnh sửa:');
    final id = stdin.readLineSync()!;
    final student = students.firstWhere((s) => s.id == id, orElse: () => throw Exception('Sinh viên không tồn tại'));

    print('Nhập tên mới (hoặc nhấn Enter để giữ nguyên):');
    final newName = stdin.readLineSync()!;
    if (newName.isNotEmpty) student.name = newName;

    print('Nhập môn học cần chỉnh sửa (hoặc "x" để kết thúc):');
    while (true) {
      final subjectName = stdin.readLineSync()!;
      if (subjectName.toLowerCase() == 'x') break;

      final subject = student.subjects.firstWhere(
          (s) => s.name == subjectName,
          orElse: () => Subject(name: subjectName, score: []));
      
      print('Nhập điểm mới (cách nhau bởi dấu phẩy):');
      final scores = stdin.readLineSync()!.split(',').map(int.parse).toList();

      subject.score = scores;
      if (!student.subjects.contains(subject)) student.subjects.add(subject);
    }

    await saveStudents(students);
    return students;
  }

  void searchStudent(List<Student> students) {
    print('Tìm kiếm theo (1) Tên hoặc (2) ID:');
    final choice = int.parse(stdin.readLineSync()!);

    print('Nhập từ khóa:');
    final keyword = stdin.readLineSync()!;
    
    final result = (choice == 1)
        ? students.where((s) => s.name.contains(keyword)).toList()
        : students.where((s) => s.id == keyword).toList();

    displayStudents(result);
  }
}
