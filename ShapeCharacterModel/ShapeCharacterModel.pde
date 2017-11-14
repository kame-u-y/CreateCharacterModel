PFont font;
int[][] pixels2;
HashMap<String, Pixel> borderPixels;
ArrayList<ArrayList<String>> borderPixelsOrder;
int oldDirectionKey = -1;
String shapingChara = "i";

//探索方向のmap
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

void setup() {
  size(300, 300);
  font = createFont("Ricty-Regular-48.vlw", 250);
  //borderPixels = new ArrayList<Pixel>();
  borderPixels = new HashMap<String, Pixel>();
  borderPixelsOrder = new ArrayList<ArrayList<String>>();

  fill(0, 100, 0);
  background(255);
  textAlign(CENTER);
  textSize(250);
  textFont(font);
  text(shapingChara, width/2, height/2 + 90);

  loadPixels();

  pixels2 = pixels1To2(pixels, width, height);

  background(255);

  //縁を全て黒にする
  for (int i=1; i<pixels2.length-1; i++) {
    for (int j=1; j<pixels2[i].length-1; j++) {
      if ( pixels2[i][j]!=-1) {
        for (int p=0; p<8; p++) {
          int x = i+directionMap.get(p).x;
          int y = j+directionMap.get(p).y;
          if ( pixels2[x][y]==-1 ) {
            set(i, j, color(0));
            break;
          }
        }
      }
    }
  }

  loadPixels();
  pixels2 = pixels1To2(pixels, width, height);

  Pixel oldBeginningPixel = new Pixel(0, 0);

  int count2 = 0;
shaping:
  while (count2<10000) {
    borderPixelsOrder.add(new ArrayList<String>());
  searchBeginning:
    for (int i=oldBeginningPixel.x; i<pixels2.length; i++) {
      for (int j=0; j<pixels2[i].length; j++) {
        if (pixels2[i][j]==-16777216) {
          if (borderPixels.get(i+","+j)!=null) {
            println("this pixel has already saved");
            continue;
          }

          //borderPixels.add(new Pixel(i, j));
          borderPixels.put(i+","+j, new Pixel(i, j));
          borderPixelsOrder.get(count2).add(i+","+j);
          oldBeginningPixel = new Pixel(i, j);  //次にbeginingPixelを利用するときに使う
          break searchBeginning;
        }
      }
      //shaping終了
      if (i==pixels2.length-1) {
        println("end shaping");
        break shaping;
      }
    }


    int count1 = 0;
    String lastPutKey = "";
    Pixel beginningPixel = oldBeginningPixel;  //意味的な変数定義

  searchOutlines:
    while (count1<10000) {
      print(" (count1,count2="+count1+","+count2+")");
      count1++;

      Pixel lastPixel = (lastPutKey=="") ? beginningPixel : borderPixels.get(lastPutKey);
      print("lastPixel.x="+lastPixel.x +", lastPixel.y="+ lastPixel.y);
      int startDirectionKey = (oldDirectionKey==-1) ? 0 : (oldDirectionKey+6)%8;
      //反時計回りに周囲を探索
      for (int i=startDirectionKey; i<startDirectionKey+5; i++) {
        //print(" (count1,count2="+count1+","+count2+")");

        int searchX = lastPixel.x + directionMap.get(i).x;
        int searchY = lastPixel.y + directionMap.get(i).y;
        if (pixels2[searchX][searchY] == -16777216) {
          //探索し始めまで帰ってきたら終了
          //println(true);
          if (searchX==beginningPixel.x && searchY==beginningPixel.y) {
            println("returned beginningPixel");
            break searchOutlines;
          }
          println("searching...");
          borderPixels.put(searchX+","+searchY, new Pixel(searchX, searchY));
          borderPixelsOrder.get(count2).add(searchX+","+searchY);

          print(true, borderPixels.size());
          oldDirectionKey = i%8;
          lastPutKey = searchX+","+searchY;
          continue searchOutlines;
        }
      }
      //進む方向にborderPixelが存在しないとき元の方向に戻る
      println("couldn't discover the direction in forward");
      //print("hoge\n");
      borderPixels.put(lastPixel.x+","+lastPixel.y, lastPixel);
      borderPixelsOrder.get(count2).add(lastPixel.x+","+lastPixel.y);
      oldDirectionKey = (oldDirectionKey + 4)%8;
      lastPutKey = lastPixel.x +","+ lastPixel.y;
    }

    for (int i=0; i<borderPixelsOrder.get(count2).size(); i++) {
      for (int j=0; j<8; j++) {
        String key = borderPixelsOrder.get(count2).get(i);
        int settingX = borderPixels.get(key).x + directionMap.get(j).x;
        int settingY = borderPixels.get(key).y + directionMap.get(j).y;
        borderPixels.put(settingX +","+ settingY, new Pixel(settingX, settingY));
      }
    }

    count2++;
  }


  background(255);

  noFill();

  for (int i=0; i<borderPixelsOrder.size(); i++) {
    beginShape();
    for (int j=0; j<borderPixelsOrder.get(i).size(); j++) {
      Pixel popPixel = borderPixels.get( borderPixelsOrder.get(i).get(j) );
      vertex(popPixel.x, popPixel.y);
    }
    endShape(CLOSE);
  }
  
  println("\n\nend\n\n");
}


void draw() {
  //print(" ("+mouseX, mouseY+")");
}

int[][] pixels1To2(int[] _pixels, int _width, int _height) {
  int[][] outputPixels2 = new int[_width][_height];
  for (int i=0; i<_pixels.length; i++) {
    outputPixels2[i%_width][int(i/_width)] = _pixels[i];
  }
  return outputPixels2;
}

void keyPressed() {
  shapingChara = str(key);
  setup();
}