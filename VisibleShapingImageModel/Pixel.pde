class Pixel {
  int x;
  int y;
  int borderOrder;

  Pixel(int _x, int _y) {
    x = _x;
    y = _y;
  }
  
  Pixel(int _x, int _y, int _order) {
    x = _x;
    y = _y;
    borderOrder = _order;
  }
  
  void setPixel(int _x, int _y){
    x = _x;
    y = _y;
  }
}