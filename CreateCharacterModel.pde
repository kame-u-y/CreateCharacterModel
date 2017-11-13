String inputCharacter = "";
//PGraphics text;
color textColor;
color colorOnMouse;

color[][] pixels2;

ArrayList<Pixel> borderPixels;

void setup() {
  size(200, 200);
  borderPixels = new ArrayList<Pixel>();

  fill(0, 100, 0);
  background(255);
  textAlign(CENTER);
  textSize(250);
  text("m", width/2, height/2 + 70);

  loadPixels();

  pixels2 = pixels1To2(pixels, width, height);

  //for(int i=0; i<pixels2.length; i++) {
  //  for(int j=0; j<pixels2[i].length; j++){
  //    if(pixels2[i][j]!=-1){

  //    }
  //  }
  //}

  for (int i=1; i<pixels2.length-1; i++) {
    for (int j=1; j<pixels2[i].length-1; j++) {
      //文字と背景の境界を取得
      if ( (pixels2[i-1][j]==-1 && pixels2[i][j]!=-1) 
        || (pixels2[i][j-1]==-1 && pixels2[i][j]!=-1) 
        || (pixels2[i][j]!=-1 && pixels2[i+1][j]==-1) 
        || (pixels2[i][j]!=-1 && pixels2[i][j+1]==-1) ) {
        borderPixels.add( new Pixel(i, j, pixels2[i][j]) );
      }

      if (pixels2[i][j]==-1) {
        //print(pixels2[i][j]+",");
        print(0);
      } else {
        print(1);
      }
    }
    println();
  }

  background(255);

  for (int i=0; i<borderPixels.size(); i++) {
    print("("+borderPixels.get(i).x +","+ borderPixels.get(i).y +")");
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