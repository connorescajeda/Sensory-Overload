import 'dart:math' as math;

class Fruit {
  bool grabbed = false;
  math.Point<int> location;
  Fruit(this.location);

  int get x {
    return location.x;
  }

  int get y {
    return location.y;
  }
}
