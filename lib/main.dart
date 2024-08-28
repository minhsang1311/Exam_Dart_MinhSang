// lib/main.dart
import 'dart:io';
import 'services/student_service.dart';
import 'models/student.dart';

void main() async {
  final studentService = StudentService('data/Student.json');
  List<Student> students = await studentService.loadStudents();

  // Hiển thị menu cho người dùng
  while (true) {
    print('1. Hiển thị toàn bộ sinh viên');
    print('2. Thêm sinh viên');
    print('3. Sửa thông tin sinh viên');
    print('4. Tìm kiếm sinh viên theo Tên hoặc ID');
    print('5. Thoát');
    print('Chọn chức năng:');
    final choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1:
        studentService.displayStudents(students);
        break;
      case 2:
        students = await studentService.addStudent(students);
        break;
      case 3:
        students = await studentService.editStudent(students);
        break;
      case 4:
        studentService.searchStudent(students);
        break;
      case 5:
        exit(0);
      default:
        print('Lựa chọn không hợp lệ.');
    }
  }
}
