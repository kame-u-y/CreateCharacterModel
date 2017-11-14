
void setup() {
  size(300, 300);

  background(255);
  fill(0, 100, 0);
  textAlign(CENTER);
  textSize(250);
  text("b", width/2, height/2 + 90);  

  loadPixels();

  int[][] pixels2 = pixels1To2(pixels, width, height);

  HashMap<Integer, Pixel> directionMap = new HashMap<Integer, Pixel>() {
    {
      put(0, new Pixel(-1, 1));
      put(1, new Pixel(0, 1));
      put(2, new Pixel(1, 1));
      put(3, new Pixel(1, 0));
      put(4, new Pixel(1, -1));
      put(5, new Pixel(0, -1));
      put(6, new Pixel(-1, -1));
      put(7, new Pixel(-1, 0));
      put(8, new Pixel(-1, 1));
      put(9, new Pixel(0, 1));
      put(10, new Pixel(1, 1));
      put(11, new Pixel(1, 0));
    }
  };

  ArrayList<Pixel> borderPixels = new ArrayList<Pixel>();


  for (int i=1; i<pixels2.length-1; i++) {
    for (int j=1; j<pixels2[i].length-1; j++) {
      if ( pixels2[i][j]!=-1) {
        for (int p=0; p<8; p++) {
          int x = i+directionMap.get(p).x;
          int y = j+directionMap.get(p).y;
          if ( pixels2[x][y]==-1 ) {
            set(i, j, color(0));
            borderPixels.add(new Pixel(i, j));
            break;
          }
        }
      }
    }
  }

  loadPixels();
  pixels2 = pixels1To2(pixels, width, height);

  for (int i=0; i<pixels2.length; i++) {
    for (int j=0; j<pixels2[i].length; j++) {
      print( pixels2[i][j] );
    }
    println();
  }

  background(255);

  for (int i=0; i<borderPixels.size(); i++) {
    point(borderPixels.get(i).x, borderPixels.get(i).y);
  }
}

int[][] pixels1To2(int[] _pixels, int _width, int _height) {
  int[][] outputPixels2 = new int[_width][_height]; 
  for (int i=0; i<_pixels.length; i++) {
    outputPixels2[i%_width][int(i/_width)] = _pixels[i];
  }
  return outputPixels2;
}