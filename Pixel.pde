class Pixel {
  private int x;
  private int y;
  private int c;

  Pixel(int _x, int _y, int _c) {
    x = _x;
    y = _y;
    c = _c;
  }

  color getPixelColor() {
    return c;
  }
}