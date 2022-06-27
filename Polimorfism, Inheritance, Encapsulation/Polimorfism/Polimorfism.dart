import 'dart:math' as math;
abstract class Shape {
  double getArea();
}
class Rectangle implements Shape
{ double width;
double height;

Rectangle({required this.width, required this.height});

@override
double getArea() {
  print("Getting rectangles area");
  return width*height;
}
}
class Square extends Rectangle {
  double side;
  Square(this.side) : super(width:side, height:side);
}
class Oval implements Shape {
  final double minorRadius;
  final double majorRadius;
  Oval({required this.minorRadius, required this.majorRadius});

  @override
  double getArea() {
    print("getting ovals area");
    return minorRadius * majorRadius * math.pi;
  }}
class Circle extends Oval {
  final double radius;
  Circle(this.radius)
      : super(minorRadius: radius, majorRadius:radius);
}
void main() {
  Rectangle rectangle = Rectangle(width: 2, height: 4);
  Square square = Square(4);
  Oval oval = Oval(majorRadius: 10, minorRadius: 5);
  Circle circle = Circle(7.5);
  List<Shape> shapesList = [rectangle, square, oval, circle];
  shapesList.forEach((e) {
    e.getArea();
  });
}