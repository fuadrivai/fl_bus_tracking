import 'package:bus_tracking/models/model.dart';
import 'package:floor/floor.dart';

@dao
abstract class StudentDao {
  @Query('SELECT * FROM Students')
  Future<List<Student>> findAllStudent();

  @Query('SELECT * FROM Students WHERE action = :action ORDER BY childID ASC')
  Future<List<Student>> findByAction(String action);

  @Query('SELECT * FROM Students WHERE childID = :id')
  Stream<Student?> findStudentById(int id);

  @Query('UPDATE OR ABORT Students SET action = :action WHERE childID = :id')
  Future<int?> updateActionStudent(String action, int id);

  @Query(
      'UPDATE OR ABORT Students SET action = "Arrived" WHERE childID IN (:ids)')
  Future<int?> updatePickupStudent(List<int> ids);

  @insert
  Future<void> insertStudent(Student student);

  @insert
  Future<void> insertStudents(List<Student> students);

  @Update()
  Future<void> updateStudent(Student student);

  @delete
  Future<void> deleteStudent(Student student);

  @delete
  Future<void> deleteAllStudent(List<Student> students);
}
