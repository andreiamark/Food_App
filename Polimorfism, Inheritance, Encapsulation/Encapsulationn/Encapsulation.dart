import 'package:untitled/untitled.dart' as untitled;
class Student {
  double gpa;
  bool  isFailing;
  String university;
  //void printUniversity() {
  // print(university);
  // }

  // void setGpa(double gpa) {
  // if (gpa < 0){
  //  throw Exception("Gpa cant be negative");
  // }
  //if (gpa < 2.0) {_isFailing = true;
  // }
  //else
  // {
  //  _isFailing=false;
  // }
  // _gpa = gpa;
  //}
//}
//Student({double gpa, bool isFailing, String university}){//
//this.gpa = gpa;
  //this.isFailing = isFailing;
  //this.university = university;
  Student({required this.gpa, required this.isFailing, required this.university});
  Student.positional(this.gpa, this.isFailing, this.university);
}





