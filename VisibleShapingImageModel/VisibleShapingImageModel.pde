PFont font;

//探索済みで次回以降に探索を回避するためのHashMap 入力例：<"x,y", new Pixel(x,y)>
HashMap<String, Pixel> searchedBorderPixels;

//輪郭ごと、追跡した順番にHashMapのキーを保存
ArrayList<ArrayList<String>> borderPixelsOrderedKey = new ArrayList<ArrayList<String>>();

//輪郭ごとの情報を格納したArrayList、追跡した順番に保存
//  (borderPixelsOrderedKeyの一次元目のインデックスと対応)
ArrayList<BorderInfo> borderInfoArray = new ArrayList<BorderInfo>();

float randomValue=5;

enum Flag {
  first, 
    second, 
    third
}

Flag flag = Flag.first;
boolean firstInitial = true;
boolean increment_i = false;
int countI = 1;
int countJ = 1;
ArrayList<Pixel> firstDots = new ArrayList<Pixel>();

boolean secondInitial = true;
Pixel oldBeginningPixel;
int searchOutlinesCount;
String lastPutKey;
Pixel beginningPixel;
boolean searchBeginningFlag = true;
int oldDirectionKey = -1;
int shapingCount = 0;

float cnt = 0;

PImage image;

void setup() {

  size(600, 600);
  font = createFont("Zapfino", 250);
  //shapeChara("鬱");
  frameRate(1000);
  
  image = loadImage("gonbe.png");
}

void draw() {
  //randomValue = 5;

  //PrintWriter output = createWriter("borderPixels_kick.txt");

  //fill(0, 100, 0);
  //noFill();

  //println(countI, countJ, firstInitial, increment_i);
  if (flag!=Flag.third) {
    if (frameCount%1==0) {
      background(100);

      shapeChara("鬱", countI);
      countI++;
    }

    if (searchedBorderPixels!=null) {
      background(0);

      for (Pixel p : searchedBorderPixels.values()) {
        set(p.x, p.y, color(255, 0, 0));
      }
    }
  } else {
    frameRate(10);
    background(0);
    noFill();
    stroke(255, 0, 0);
    //cnt = cnt%360==0 ? 0 : ++cnt;
    cnt+=0.1;
    //if (cnt>360) cnt = 0;
    //print(","+(int)10*abs(sin(radians(cnt)))+1+",");
    // 図形の最終的な描画
    //print((int)(10+10*noise(cnt)));
    for (int i=0; i<borderPixelsOrderedKey.size()-1; i++) {

      if (borderInfoArray.get(i).isInline) continue;
      beginShape();
      {
        for (int j=0; j<borderPixelsOrderedKey.get(i).size(); j++) {
          Pixel popPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(i).get(j) );
          //if ( j%2==0 ) {
          //  vertex(popPixel.x + 50*cos(radians(cnt)), popPixel.y + 50*sin(radians(cnt)));
          //} else {
          //  vertex(popPixel.x, popPixel.y );
          //}

          if (j%((int)(10+50*noise(cnt)))==0) {
            curveVertex(popPixel.x, popPixel.y );
          }
        }
        // 内側輪郭の穴を作成
        for (int p=0; p<borderPixelsOrderedKey.size()-1; p++) {
          beginContour();
          if (borderInfoArray.get(p).isInline && borderInfoArray.get(p).parentBorderOrder==i) {
            for (int q=borderPixelsOrderedKey.get(p).size()-1; q>=0; q--) {
              Pixel popContourPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(p).get(q) );
              //if ( q%2==0 ) {
              //  vertex(popContourPixel.x + 50*cos(radians(cnt)), popContourPixel.y + 50*sin(radians(cnt)));
              //} else {
              //  vertex(popContourPixel.x, popContourPixel.y );
              //}
              if (q%((int)(10+50*noise(cnt)))==0) {
                vertex(popContourPixel.x, popContourPixel.y );
              }
            }
          }
          endContour();
        }
      }
      endShape(CLOSE);
    }
  }
}


void keyPressed() {
  //font = createFont( "Arial", 250 );
  //shapeChara(str(key));
  if (keyCode==UP) randomValue++;
  if (keyCode==DOWN) randomValue--;
}

//一次元配列のpixelsを二次元配列に変換するための関数
int[][] pixels1to2(int[] _pixels, int _width, int _height) {
  int[][] outputPixels2 = new int[_width][_height];
  for (int i=0; i<_pixels.length; i++) {
    outputPixels2[i%_width][int(i/_width)] = _pixels[i];
  }
  return outputPixels2;
}