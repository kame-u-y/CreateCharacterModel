// beginningPixelの左側三方向の値が全て-1ならoutline
// 全てが!(-1)ならinline説

//内側だと判定されたborderPixelsは、左向きに進んで最初にぶつかったborderPixelの中にある説

//Pixelの中にborderPixelsOrderの情報を格納しておく


PGraphics vecterCharacter;

PFont font;
int[][] pixels2;
HashMap<String, Pixel> searchedBorderPixels;
ArrayList<ArrayList<String>> borderPixelsOrderedKey;
ArrayList<BorderInfo> borderInfoArray;
int oldDirectionKey = -1;
String shapingChara = "龗";

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

  searchedBorderPixels   = new HashMap<String, Pixel>();
  borderPixelsOrderedKey = new ArrayList<ArrayList<String>>();
  borderInfoArray = new ArrayList<BorderInfo>();
  background(255);

  fill(0, 100, 0);
  textAlign(CENTER);
  textSize(250);
  textFont(font);
  text(shapingChara, width/2, height/2 + 90);

  loadPixels();

  pixels2 = pixels1To2(pixels, width, height);

  //background(255);

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

  //無限ループ回避のcount2
  int count2 = 0;
shaping:
  while (count2<10000) {
    borderPixelsOrderedKey.add(new ArrayList<String>());
  searchBeginning:
    for (int i=oldBeginningPixel.x; i<pixels2.length; i++) {
      for (int j=0; j<pixels2[i].length; j++) {
        if (pixels2[i][j]==-16777216) {
          if (searchedBorderPixels.get(i+","+j)!=null) {
            println("this pixel has already saved");
            continue;
          }

          //borderPixels.add(new Pixel(i, j));
          searchedBorderPixels.put(i+","+j, new Pixel(i, j));
          borderPixelsOrderedKey.get(count2).add(i+","+j);

          if (pixels2[i-1][j-1]==-1 && pixels2[i-1][j]==-1 && pixels2[i-1][j+1]==-1) {
            borderInfoArray.add(new BorderInfo(false));
          } else {
            //beginningPixelIsInline.add(new Boolean(true));
            borderInfoArray.add(new BorderInfo(true));
            int leftPixelValue = 0;
            Pixel searchParentPixel = new Pixel(i, j);
            while (leftPixelValue!=-1) {
              searchParentPixel.setPixel(searchParentPixel.x-1, searchParentPixel.y);
              println(pixels2[searchParentPixel.x][searchParentPixel.y]);
              if (pixels2[searchParentPixel.x][searchParentPixel.y]==-16777216) {
                borderInfoArray.get(borderInfoArray.size()-1).parentBorderOrder = searchedBorderPixels.get(searchParentPixel.x+","+searchParentPixel.y).borderOrder;
                println("parentBorderOrder = "+ borderInfoArray.get(borderInfoArray.size()-1).parentBorderOrder);
                break;
              }
            }
          }
          //stop();

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

    //無限ループ回避のcount1
    int count1 = 0;
    String lastPutKey = "";
    Pixel beginningPixel = oldBeginningPixel;  //意味的な変数定義

  searchOutlines:
    while (count1<10000) {
      print(" (count1,count2="+count1+","+count2+")");
      count1++;

      Pixel lastPixel = (lastPutKey=="") ? beginningPixel : searchedBorderPixels.get(lastPutKey);
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
          searchedBorderPixels.put(searchX+","+searchY, new Pixel(searchX, searchY, count2));
          borderPixelsOrderedKey.get(count2).add(searchX+","+searchY);

          print(true, searchedBorderPixels.size());
          oldDirectionKey = i%8;
          lastPutKey = searchX+","+searchY;
          continue searchOutlines;
        }
      }
      //進む方向にborderPixelが存在しないとき元の方向に戻る
      println("couldn't discover the direction in forward");
      //print("hoge\n");
      searchedBorderPixels.put(lastPixel.x+","+lastPixel.y, lastPixel);
      borderPixelsOrderedKey.get(count2).add(lastPixel.x+","+lastPixel.y);
      oldDirectionKey = (oldDirectionKey + 4)%8;
      lastPutKey = lastPixel.x +","+ lastPixel.y;
    }

    for (int i=0; i<borderPixelsOrderedKey.get(count2).size(); i++) {
      for (int j=0; j<8; j++) {
        String key = borderPixelsOrderedKey.get(count2).get(i);
        int settingX = searchedBorderPixels.get(key).x + directionMap.get(j).x;
        int settingY = searchedBorderPixels.get(key).y + directionMap.get(j).y;
        searchedBorderPixels.put(settingX +","+ settingY, new Pixel(settingX, settingY, count2));
      }
    }

    count2++;
  }

  background(255);

  //vecterCharacter = createGraphics(300, 300);
  //vecterCharacter.beginDraw();
  //noFill();

  //println(borderPixelsOrderedKey.size());
  //println(borderPixelsOrderedKey.get(0).size());

  for (int i=0; i<borderPixelsOrderedKey.size()-1; i++) {
    //vecterCharacter.beginShape();
    if (borderInfoArray.get(i).isInline) {
      fill(255, 0, 0);

      println(borderInfoArray.get(i).parentBorderOrder);
    } else {
      noFill();
      fill(0, 255, 0);
    }
    if (borderInfoArray.get(i).isInline) {
      print(i);
      continue;
    }

    beginShape();

    for (int j=0; j<borderPixelsOrderedKey.get(i).size(); j++) {
      Pixel popPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(i).get(j) );

      //vecterCharacter.vertex(popPixel.x, popPixel.y);
      vertex(popPixel.x, popPixel.y);
    }
    //vecterCharacter.endShape(CLOSE);

    for (int p=0; p<borderPixelsOrderedKey.size()-1; p++) {
      print(i);
      beginContour();

      if (borderInfoArray.get(p).isInline && borderInfoArray.get(p).parentBorderOrder==i) {
        for (int q=borderPixelsOrderedKey.get(p).size()-1; q>=0; q--) {
          Pixel popContourPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(p).get(q) );
          //print(true);
          vertex(popContourPixel.x, popContourPixel.y);
        }
      }

      endContour();
    }

    endShape(CLOSE);
    //println(i);
  }

  //vecterCharacter.endDraw();

  //image(vecterCharacter, 0, 0);

  println("\n\nend\n\n");
}


void draw() {
  //background(255);
  //print(" ("+mouseX, mouseY+")");

  //image(vecterCharacter, 0, 0);
  //line(mouseX, 0, mouseX, height);
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