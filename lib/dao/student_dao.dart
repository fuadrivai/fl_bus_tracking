import 'package:bus_tracking/models/model.dart';
import 'package:floor/floor.dart';

@dao
abstract class StudentDao {
  @Query('SELECT * FROM Students')
  Future<List<Student>> findAllStudent();

  @Query('SELECT * FROM Students WHERE childID = :id')
  Stream<Student?> findStudentById(int id);

  @insert
  Future<void> insertStudent(Student student);

  @insert
  Future<void> insertStudents(List<Student> students);

  @delete
  Future<void> deleteStudent(Student student);

  @delete
  Future<void> deleteAllStudent(List<Student> students);
}
