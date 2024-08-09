
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manage_student/db/database_student.dart';

import 'entities/course.dart';
import 'entities/student.dart';
import 'main.dart';

class StudentListPage extends StatefulWidget{
  // const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return StudentListPageState();
  }
}

class StudentListPageState extends State<StudentListPage>{

  var studentName = TextEditingController();
  var courseName = TextEditingController();
  var address = TextEditingController();
  var phone = TextEditingController();
  var score = TextEditingController();
  var xeploai = '';
  int? student_id;
  StudentDatabase? database;
  Future<List<Student>>? students;
  Future<List<Course>>? courses;

  @override
  void initState() {
    database = StudentDatabase();
    students = database!.findAllStudent();
    courses = database!.findallCourse();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text("Student List",style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.black,
        ),
        body: FutureBuilder(
          future: students,
          builder: (context, AsyncSnapshot<List<Student>> snapshot){
            if(snapshot.hasData){
              return Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        child: Card(
                          color: Colors.orangeAccent,
                          margin: EdgeInsets.only(top: 10,bottom: 10),
                          child: ListTile(
                            leading: Icon(Icons.perm_contact_cal, color: Colors.blueAccent,),
                            title: Text("${snapshot.data![index].name!.toUpperCase()} - ${snapshot.data![index].phone!}" ),
                            subtitle: Text(snapshot.data![index].address!),
                            trailing:  PopupMenuButton(
                              itemBuilder: (context){
                                return<PopupMenuItem>[
                                  PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      leading: Icon(Icons.edit,color: Colors.indigo,),
                                      title: Text('Edit',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      leading: Icon(Icons.delete_forever,color: Colors.red,),
                                      title: Text('Delete',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    child: ListTile(
                                      leading: Icon(Icons.score, color: CupertinoColors.activeGreen,),
                                      title: Text('Add Course',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 4,
                                    child: ListTile(
                                      leading: Icon(Icons.view_agenda_outlined, color: CupertinoColors.activeGreen,),
                                      title: Text('View Course',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (value) => optionMenuSelected(context, value, snapshot.data![index]),
                            ),
                          ),
                        ),
                        onTap: (){
                          average(snapshot.data![index].id!);
                        },
                      );
                    }),
              );
            }
            else{ return CircularProgressIndicator();}
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addStudent(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      );
  }

  void optionMenuSelected(BuildContext context, int value, Student student){
    if(value == 1){
      editMenuSelected(context, student);
    }
    else if( value == 2){
      deleteMenuSelected(context, student);
    }
    else if( value == 3){
      scoreMenuSelected(context, student);
    }
    else if( value == 4){
      viewScoreMenuSelected(context, student);
    }
  }

  void addStudent(BuildContext context){
    Dialog addStudent = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add Student', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
            Container(margin: EdgeInsets.only(top: 10, bottom: 10),),
            TextFormField(
              controller: studentName,
              decoration: InputDecoration(
                hintText: 'Student name.....'
              ),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: address,
              decoration: InputDecoration(
                  hintText: 'Address....'
              ),
              keyboardType: TextInputType.streetAddress,
            ),
            TextFormField(
              controller: phone,
              decoration: InputDecoration(
                  hintText: 'Phone number.....'
              ),
              keyboardType: TextInputType.phone,
            ),
            Container(margin: EdgeInsets.only(top: 10, bottom: 10),),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(
                    onPressed: (){
                      add();
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add student', style: TextStyle(fontSize: 20),)))
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context) => addStudent);
  }

  void add() async{
    var db = StudentDatabase();
    var student = Student(
      name: studentName.text,
      address: address.text,
      phone: phone.text
    );
    if(await db!.addStudent(student)){
      Fluttertoast.showToast(msg: 'Success');
      Navigator.of(context,rootNavigator: true).pop(context);
      setState(() {
        students = db!.findAllStudent();
      });
    }
    else{
      Fluttertoast.showToast(msg: 'Failed');
      Navigator.of(context,rootNavigator: true).pop(context);
    }
  }

  void editMenuSelected(BuildContext context, Student student) {
    studentName.text = student.name!;
    address.text = student.address!;
    phone.text = student.phone!;
    Dialog editStudent = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit Student', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
            Container(margin: EdgeInsets.only(top: 10, bottom: 10),),
            TextFormField(
              controller: studentName,
              decoration: InputDecoration(
                  hintText: 'Student name.....'
              ),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: address,
              decoration: InputDecoration(
                  hintText: 'Address....'
              ),
              keyboardType: TextInputType.streetAddress,
            ),
            TextFormField(
              controller: phone,
              decoration: InputDecoration(
                  hintText: 'Phone number.....'
              ),
              keyboardType: TextInputType.phone,
            ),
            Container(margin: EdgeInsets.only(top: 10, bottom: 10),),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(
                    onPressed: (){
                      edit(student);
                    },
                    icon: Icon(Icons.add),
                    label: Text('Edit student', style: TextStyle(fontSize: 20),)))
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context) => editStudent);
  }
  void edit(Student student) async{
    var db = StudentDatabase();
    student.name = studentName.text;
    student.address = address.text;
    student.phone = phone.text;
    if(await db!.editStudent(student)){
      Fluttertoast.showToast(msg: 'Success');
      Navigator.of(context,rootNavigator: true).pop(context);
      setState(() {
        students = db!.findAllStudent();
        studentName.text = '';
        address.text = '';
        phone.text = '';
      });
    }
    else{
      Fluttertoast.showToast(msg: 'Failed');
      Navigator.of(context,rootNavigator: true).pop(context);
    }
  }

  void deleteMenuSelected(BuildContext context, Student student) {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            icon: Icon(Icons.question_mark_outlined),
            title: Text('Confirm'),
            content: Text('Do you want to delete ${student.name}?'),
            actions: [
              Row(
                children: [
                  Expanded(
                    child:  TextButton(
                        onPressed: () async{
                          if(await database!.deleteStudent(student)){
                            Fluttertoast.showToast(msg: 'Success');
                            setState(() {
                              students = database!.findAllStudent();
                            });
                          }
                          else{
                            Fluttertoast.showToast(msg: 'Failed');
                          }
                          Navigator.of(context, rootNavigator: true).pop(context);
                        },
                        child: Text('OK')),
                  ),
                  Expanded(
                    child:   TextButton(
                        onPressed: (){
                          Navigator.of(context, rootNavigator: true).pop(context);
                        },
                        child: Text('Cancel')),
                  )
                ],
              ),
            ],
          );
        });
  }

  void scoreMenuSelected(BuildContext context, Student student) {
    student_id = student.id!;
    Dialog addScoreDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add Course', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
            Container(margin: EdgeInsets.only(top: 10, bottom: 10),),
            TextFormField(
              controller: courseName,
              decoration: InputDecoration(
                  hintText: 'Course name.....'
              ),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: score,
              decoration: InputDecoration(
                  hintText: '5.5'
              ),
              keyboardType: TextInputType.number,
            ),
            Container(margin: EdgeInsets.only(top: 10, bottom: 10),),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(
                    onPressed: (){
                      addscore();
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Course', style: TextStyle(fontSize: 20),)))
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context) => addScoreDialog);
  }

  void addscore() async {
    var database = StudentDatabase();
    var diem = int.parse(score.text);
    var course = Course(
      name: courseName.text,
      score: diem,
      student_id: student_id
    );
    if(await database!.addCourse(course)){
      Fluttertoast.showToast(msg: 'success');
      Navigator.of(context,rootNavigator: true).pop(context);
      setState(() {
        courses = database!.findallCourse();
        courseName.text = '';
        score.text = '';
      });
    }
    else{
      Fluttertoast.showToast(msg: 'fail');
      Navigator.of(context,rootNavigator: true).pop(context);
    }
  }

  void average(int id) async {
    courses = database!.findbyId(id);
    var sum = await database!.sum(id);
    var count = await database!.count(id);
    var average = (sum/count);
    xepLoai(average);
    Dialog course = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child:  FutureBuilder(
        future: courses,
        builder: (context, AsyncSnapshot<List<Course>> snapshot){
          if(snapshot.hasData){
            return Container(
                height: 400 ,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                child: ListTile(
                                leading: Icon(Icons.score, color: Colors.red,),
                                title: Text("${snapshot.data![index].name!.toUpperCase()}" ),
                                trailing: Text("${snapshot.data![index].score!}",style: TextStyle(fontSize: 20),),
                                ),
                              );
                            }),
                      ),
                      Container(margin: EdgeInsets.only(top: 5,bottom: 5),),
                      Text("Average: ${average.toStringAsFixed(2)}",style: TextStyle(fontSize: 30, color: Colors.blueAccent,),),
                      Card(
                        child: ListTile(
                          leading: Text('Xep loai',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueAccent),),
                          trailing: Text(xeploai,style: TextStyle(fontSize: 30, color: Colors.red),),
                        ),
                      )
                    ],
                  ),
                )
            );
          }
          else{
            return CircularProgressIndicator();
          }
        },
      ),
    );

    showDialog(context: context, builder: (context) => course);
  }

  void xepLoai(var average){
    if(average < 5){
      xeploai = 'Yeu';
    }
    else if( average >= 5 && average < 6.5 )
    {xeploai = 'Trung binh';}
    else if( average >= 6.5 && average < 8 ){xeploai = 'Kha';}
    else if( average >= 8 ){xeploai = 'Gioi';}
  }

  void viewScoreMenuSelected(BuildContext context, Student student) {
    var database = StudentDatabase();
    courses = database!.findbyId(student.id!);
    Dialog viewScore = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: FutureBuilder(
        future: courses,
        builder: (context, AsyncSnapshot<List<Course>> snapshot){
          if(snapshot.hasData){
            return Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Icon(Icons.score, color: Colors.blueAccent,),
                          title: Text("${snapshot.data![index].name!.toUpperCase()} - ${snapshot.data![index].score!}" ),
                          // trailing: SizedBox(
                          //   width: 100,
                          //   child: Row(
                          //     children: [
                          //       Expanded(child: Icon(Icons.edit)),
                          //       Expanded(child: Icon(Icons.delete)),
                          //     ],
                          //   ),
                          // ),
                          trailing:  PopupMenuButton(
                            itemBuilder: (context){
                              return<PopupMenuItem>[
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    leading: Icon(Icons.edit,color: Colors.indigo,),
                                    title: Text('Edit',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: ListTile(
                                    leading: Icon(Icons.delete_forever,color: Colors.red,),
                                    title: Text('Delete',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) =>  optionMenuScoreSelected(context, value, snapshot.data![index]),
                          ),
                        ),
                      ),
                      onTap: (){
                        average(snapshot.data![index].id!);
                      },
                    );
                  }),
            );
          }
          else{ return CircularProgressIndicator();}
        },
      ),
    );
    showDialog(context: context, builder: (context) => viewScore);
  }

  void optionMenuScoreSelected(BuildContext context, value, Course course) {
    if(value == 1){
      updateCourseSelected(context, course);
    }
    else if( value == 2){
      deleteCourseSelected(context, course);
    }
  }

  void updateCourseSelected(BuildContext context, Course course) {  Navigator.of(context,rootNavigator: true).pop(context);

    courseName.text = course.name!;
    score.text = course.score!.toString();

    Dialog updateScoreDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update Course', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
            Container(margin: EdgeInsets.only(top: 10, bottom: 10),),
            TextFormField(
              controller: courseName,
              decoration: InputDecoration(
                  hintText: 'Course name.....'
              ),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: score,
              decoration: InputDecoration(
                  hintText: '5.5'
              ),
              keyboardType: TextInputType.number,
            ),
            Container(margin: EdgeInsets.only(top: 10, bottom: 10),),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(
                    onPressed: (){
                      updatescore(course);
                    },
                    icon: Icon(Icons.add),
                    label: Text('Update Course', style: TextStyle(fontSize: 20),)))
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context) => updateScoreDialog);
  }

  void deleteCourseSelected(BuildContext context, Course course) {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            icon: Icon(Icons.question_mark_outlined),
            title: Text('Confirm'),
            content: Text('Do you want to delete?'),
            actions: [
              Row(
                children: [
                  Expanded(
                    child:  TextButton(
                        onPressed: () async{
                          if(await database!.deleteCourse(course)){
                            Fluttertoast.showToast(msg: 'Success');
                            Navigator.of(context, rootNavigator: true).pop(context);
                          }
                          else{
                            Fluttertoast.showToast(msg: 'Failed');
                          }
                          Navigator.of(context, rootNavigator: true).pop(context);
                        },
                        child: Text('OK')),
                  ),
                  Expanded(
                    child:   TextButton(
                        onPressed: (){
                          Navigator.of(context, rootNavigator: true).pop(context);
                        },
                        child: Text('Cancel')),
                  )
                ],
              ),
            ],
          );
        });
  }

  void updatescore(Course course) async{
    var db = StudentDatabase();
    course.name = courseName.text;
    course.score = int.parse(score.text);
    if(await db!.editCourse(course)){
      Fluttertoast.showToast(msg: 'Success');
      Navigator.of(context,rootNavigator: true).pop(context);
      setState(() {
        score.text ='';
        courseName.text = '';
      });
    }
    else{
      Fluttertoast.showToast(msg: 'Failed');
      Navigator.of(context,rootNavigator: true).pop(context);
    }

  }







}