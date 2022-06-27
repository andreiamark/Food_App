class Person {

  void sayHello() {
    print("Hello everyone");

  }
  void eat () {
    print("cigarettes");
  }
}
class Student extends Person with Driver{
  void study() {
    print("i gotta get that a+");
  }
  @override
  void eat() {
    print("noodles");
  }
  void drive() {
    print("driving nice");
  }
}
class Rebel implements Person, Driver {
  void sayHello() {
    print("why you talking to me");
  }

  void eat() {
    print("cigarets");
  }
  void drive() {
    print("just driving");
  }
}

@override
void drive() {
  print("driving nice and safe");
}

mixin Driver{
  void drive(){
    print("Driving nice and safe");
  }
}

void main(){
  Person person = Person();
  Student student = Student();
  Rebel rebel = Rebel();

  person.sayHello();
  person.eat();


  student.sayHello();
  student.eat();
  student.study();
  student.drive();

  rebel.sayHello();
  rebel.eat();
  rebel.drive();
}