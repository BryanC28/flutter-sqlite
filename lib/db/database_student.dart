import 'dart:io';

import 'package:manage_student/entities/course.dart';
import 'package:manage_student/entities/student.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StudentDatabase{
  static const String dbName = 'studentdb';

  static const String studentTable = 'student';
  static const String courseTable = 'course';

  static const String idColumn = 'id';
  static const String nameColumn = 'name';
  static const String addressColumn = 'address';
  static const String phoneColumn = 'phone';
  static const String scoreColumn = 'score';
  static const String studnentIdColumn = 'student_id';

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    var db = await openDatabase(path, version: 1,
      onCreate: onCreateDB,
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute('drop table $studentTable');
        db.execute('drop table $courseTable');
        onCreateDB(db, newVersion);
        print('onUpgrade---------------------------');
      },);
    return db;
  }

  void onCreateDB(Database db, int newVersion) async {
    db.execute('create table $studentTable('
        '$idColumn integer primary key autoincrement, '
        '$nameColumn text,'
        '$addressColumn text,'
        '$phoneColumn text'
        ')');

    db.execute('create table $courseTable('
        '$idColumn integer primary key autoincrement, '
        '$nameColumn text, '
        '$scoreColumn integer, '
        '$studnentIdColumn integer, '
        'foreign key ($studnentIdColumn) references $studentTable($idColumn)'
        ')');
  }

  Future<List<Student>> findAllStudent() async{
    var dbClient = await db;
    List<Map<String, dynamic>> rows = await dbClient.query(studentTable);
    List<Student> students = [];
    if(rows.isNotEmpty){
      for( var row in rows){
        students.add(Student.fromJson(row));
      }
    }
    return students;
  }

  Future<bool> addStudent(Student student) async{
    var dbClient = await db;
    var row = await dbClient.insert(studentTable, student.toJson());
    return row > 0;
  }

  Future<bool> deleteStudent(Student student) async {
    var dbClient = await db;
    var row = await dbClient.delete(studentTable, where: '$idColumn = ?', whereArgs: [student.id]);
    return row > 0;
  }

  Future<bool> editStudent(Student student) async {
    var dbClient = await db;
    var row = await dbClient.update(studentTable, student.toJson(),
        where: '$idColumn = ?', whereArgs: [student.id]);
    return row > 0;
  }

  Future<bool> addCourse(Course course) async{
    var dbClient = await db;
    var row = await dbClient.insert(courseTable, course.toJson());
    return row > 0;
  }
  Future<bool> deleteCourse(Course course) async {
    var dbClient = await db;
    var row = await dbClient.delete(courseTable, where: '$idColumn = ?', whereArgs: [course.id]);
    return row > 0;
  }

  Future<bool> editCourse(Course course) async {
    var dbClient = await db;
    var row = await dbClient.update(courseTable, course.toJson(),
        where: '$idColumn = ?', whereArgs: [course.id]);
    return row > 0;
  }

  Future<List<Course>> findallCourse() async{
    var dbClient = await db;
    List<Map<String, dynamic>> rows = await dbClient.query(courseTable);
    List<Course> courses = [];
    if(rows.isNotEmpty){
      for(var row in rows){
        courses.add(Course.fromJson(row));
      }
    }
    return courses;
  }

  Future<List<Course>> findbyId(int id) async{
    var dbClient = await db;
    List<Map<String, dynamic>> rows = await dbClient.query(courseTable,
                where: '$studnentIdColumn = ?',whereArgs: [id]);
    List<Course> courses = [];
    if(rows.isNotEmpty){
      for(var row in rows){
        courses.add(Course.fromJson(row));
      }
    }
    return courses;
  }

  Future sum(int id) async{
    var dbClient = await db;
    var sum = Sqflite.firstIntValue(await dbClient.rawQuery(
        'SELECT SUM($scoreColumn) FROM $courseTable WHERE $studnentIdColumn = $id'));
    // return int.parse(average.toString());
    return sum;
  }

  Future count(int id) async{
    var dbClient = await db;
    var count = Sqflite.firstIntValue(await dbClient.rawQuery(
        'SELECT COUNT($scoreColumn) FROM $courseTable WHERE $studnentIdColumn = $id'));
    // return int.parse(average.toString());
    return count;
  }


}