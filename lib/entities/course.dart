class Course{
  int? id;
  String? name;
  int? score;
  int? student_id;

  Course({this.id, this.name, this.score, this.student_id});

  Course.fromJson(Map<String, dynamic> map){
    this.id = map['id'];
    this.name = map['name'];
    this.score = map['score'];
    this.student_id = map['student_id'];
  }

  Map<String, dynamic> toJson(){
    var map = <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'score': this.score,
      'student_id': this.student_id
    };
    return map;
  }
}