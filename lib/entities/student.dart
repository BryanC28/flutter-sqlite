class Student{
  int? id;
  String? name;
  String? address;
  String? phone;

  Student({this.id, this.name, this.address, this.phone});

  Student.fromJson(Map<String, dynamic> map){
    this.id = map['id'];
    this.name = map['name'];
    this.address = map['address'];
    this.phone = map['phone'];
  }

  Map<String, dynamic> toJson(){
    var map = <String, dynamic>{
      'id'      : this.id,
      'name'    : this.name,
      'address' : this.address,
      'phone'   : this.phone
    };
    return map;
  }
}