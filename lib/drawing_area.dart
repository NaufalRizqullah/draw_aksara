// sekarang kita akan coba membuat isolate untuk Paintnya, untuk setiap offset supaya bisa berbeda2 warna/size kek gitu (bisa beda2 setiap point offset yg dibuat)
import 'dart:ui';

class DrawingArea {

  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});

}