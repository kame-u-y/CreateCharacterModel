import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

SecondApplet second;
JLayeredPane pane;

String[]  borderPixels;
PGraphics defChara;
PGraphics showChara;
int[][]   pixels2;

String shapingChara = "総";

void settings() {
  size(600, 600, P3D);
}

void setup() {
  
  //第二ウィンドウの作成
  second = new SecondApplet(this);
  println( second.getSurface() );
  Canvas canvas = (Canvas) second.getSurface().getNative();
  pane = (JLayeredPane) canvas.getParent().getParent();
  JTextField field = new JTextField("総合");
  field.setBounds(20, 40, 100, 30);
  field.addActionListener( new ActionListener(){
    @Override
    public void actionPerformed(ActionEvent event) {
      
    }
  });
  pane.add(field);
  
  background(100);

  //探索済みで次回以降に探索を回避するためのHashMap 例：<"x,y", new Pixel(x,y)>
  HashMap<String, Pixel> searchedBorderPixels = new HashMap<String, Pixel>();

  //輪郭ごと、追跡した順番にHashMapのキーを保存
  ArrayList<ArrayList<String>> borderPixelsOrderedKey 
    = new ArrayList<ArrayList<String>>();

  //輪郭ごとの情報を格納したArrayList、追跡した順番に保存
  ArrayList<BorderInfo> borderInfoArray = new ArrayList<BorderInfo>();

  int oldDirectionKey = -1;

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

  borderPixels = loadStrings("borderPixels_kame.txt");
  defChara = createGraphics(300, 300);
  PFont font = createFont("Zapfino", 250);

  defChara.beginDraw();

  defChara.background(255);
  defChara.fill(0, 100, 0);
  defChara.textAlign(CENTER);
  defChara.textSize(250);
  defChara.textFont(font);
  defChara.text(shapingChara, defChara.width/2, defChara.height/2 + 90);
  defChara.loadPixels();
  pixels2 = pixels1to2(defChara.pixels, defChara.width, defChara.height);

  //輪郭を全て黒にする
  for (int i=1; i<pixels2.length-1; i++) {
    for (int j=1; j<pixels2[i].length-1; j++) {
      if ( pixels2[i][j]!=-1) {
        for (int p=0; p<8; p++) {
          int x = i+directionMap.get(p).x;
          int y = j+directionMap.get(p).y;
          if ( pixels2[x][y]==-1 ) {
            defChara.set(i, j, color(0));
            break;
          }
        }
      }
    }
  }

  defChara.loadPixels();
  pixels2 = pixels1to2(defChara.pixels, defChara.width, defChara.height);

  Pixel oldBeginningPixel = new Pixel(0, 0);
  //無限ループ回避のためのshapingCount
  int shapingCount = 0;


shaping:
  while (shapingCount<30) {

    borderPixelsOrderedKey.add(new ArrayList<String>());

  searchBeginning:
    for (int i=oldBeginningPixel.x; i<pixels2.length; i++) {
      for (int j=0; j<pixels2[i].length; j++) {

        //pixel2[i][j]の色が黒(つまり輪郭）ならば
        if (pixels2[i][j]==color(0)) {

          if (searchedBorderPixels.get(i+","+j)!=null) {
            println("this pixel has already saved");
            continue;
          }

          searchedBorderPixels.put(i+","+j, new Pixel(i, j));
          borderPixelsOrderedKey.get(shapingCount).add(i+","+j);

          //もし、左三方向が白ならば、外側の輪郭であると判定できる
          if (pixels2[i-1][j-1]==-1 && pixels2[i-1][j]==-1 && pixels2[i-1][j+1]==-1) {
            boolean isInline = false;
            borderInfoArray.add(new BorderInfo(isInline));
          } else {
            boolean isInline = true;
            borderInfoArray.add(new BorderInfo(isInline));

            //内側の輪郭であるとき、左方向へ輪郭を探索し、最初にぶつかったものが,
            //もし、また別の内側の輪郭であればその親が、外側の輪郭であればその輪郭が、これにとって外側の輪郭
            int leftPixelValue = 0;
            Pixel searchParentPixel = new Pixel(i, j);


            while (leftPixelValue!=-1 && searchParentPixel.x>0) {
              searchParentPixel.setPixel(searchParentPixel.x-1, searchParentPixel.y);
              //左側が黒ならば
              if (pixels2[searchParentPixel.x][searchParentPixel.y]==color(0)) {

                int searchedBorderOrder = searchedBorderPixels.get(searchParentPixel.x+","+searchParentPixel.y).borderOrder;
                BorderInfo searchedBorderInfo = borderInfoArray.get( searchedBorderOrder );

                if ( searchedBorderInfo.isInline ) {
                  borderInfoArray.get(borderInfoArray.size()-1).parentBorderOrder = searchedBorderInfo.parentBorderOrder;
                } else {
                  borderInfoArray.get(borderInfoArray.size()-1).parentBorderOrder = searchedBorderOrder;
                }
                println("parentBorderOrder = "+ borderInfoArray.get(borderInfoArray.size()-1).parentBorderOrder);
                break;
              }
            }
          }

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


    //無限ループ回避のsearchOutlinesCount
    int searchOutlinesCount = 0;
    String lastPutKey = "";
    Pixel beginningPixel = oldBeginningPixel;

  searchOutlines:
    while (searchOutlinesCount<10000) {
      searchOutlinesCount++;

      Pixel lastPixel = (lastPutKey=="") ? beginningPixel : searchedBorderPixels.get(lastPutKey);
      print("lastPixel.x="+lastPixel.x +", lastPixel.y="+ lastPixel.y);
      int startDirectionKey = (oldDirectionKey==-1) ? 0 : (oldDirectionKey+6)%8;

      //反時計回りに周囲を探索
      for (int i=startDirectionKey; i<startDirectionKey+5; i++) {
        int searchX = lastPixel.x + directionMap.get(i).x;
        int searchY = lastPixel.y + directionMap.get(i).y;

        if (pixels2[searchX][searchY] == color(0)) {
          //探索し始めまで帰ってきたら終了
          if (searchX==beginningPixel.x && searchY==beginningPixel.y) {
            println("returned beginningPixel");
            break searchOutlines;
          }

          println("searching...");
          searchedBorderPixels.put(searchX+","+searchY, new Pixel(searchX, searchY, shapingCount));
          borderPixelsOrderedKey.get(shapingCount).add(searchX+","+searchY);

          oldDirectionKey = i%8;
          lastPutKey = searchX+","+searchY;
          continue searchOutlines;
        }
      }
      //進む方向にborderPixelが存在しないとき元の方向に戻る
      println("couldn't discover the direction in forward");
      searchedBorderPixels.put(lastPixel.x+","+lastPixel.y, lastPixel);
      borderPixelsOrderedKey.get(shapingCount).add(lastPixel.x+","+lastPixel.y);

      oldDirectionKey = (oldDirectionKey + 4)%8;
      lastPutKey = lastPixel.x +","+ lastPixel.y;
    }

    // 探索した輪郭付近に未探索の黒点が残る可能性があるため、
    // 便宜上、探索したそれぞれの点より八方向を探索済みに設定
    for (int i=0; i<borderPixelsOrderedKey.get(shapingCount).size(); i++) {
      for (int j=0; j<8; j++) {
        String key = borderPixelsOrderedKey.get(shapingCount).get(i);
        int settingX = searchedBorderPixels.get(key).x + directionMap.get(j).x;
        int settingY = searchedBorderPixels.get(key).y + directionMap.get(j).y;
        searchedBorderPixels.put(settingX +","+ settingY, new Pixel(settingX, settingY, shapingCount));
      }
    }

    shapingCount++;
  }

  defChara.background(255);

  defChara.fill(0, 100, 0);

  // 図形の最終的な描画
  for (int i=0; i<borderPixelsOrderedKey.size()-1; i++) {
    if (borderInfoArray.get(i).isInline) continue;
    //output.println("border"+i);
    defChara.beginShape();
    {
      for (int j=0; j<borderPixelsOrderedKey.get(i).size(); j++) {
        Pixel popPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(i).get(j) );
        defChara.vertex(popPixel.x, popPixel.y);
      }
      // 内側輪郭の穴を作成
      for (int p=0; p<borderPixelsOrderedKey.size()-1; p++) {
        defChara.beginContour();
        if (borderInfoArray.get(p).isInline && borderInfoArray.get(p).parentBorderOrder==i) {
          for (int q=borderPixelsOrderedKey.get(p).size()-1; q>=0; q--) {
            Pixel popContourPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(p).get(q) );
            defChara.vertex(popContourPixel.x, popContourPixel.y);
          }
        }
        defChara.endContour();
      }
    }
    defChara.endShape(CLOSE);
  }

  println("\n\nend\n\n");

  defChara.endDraw();


  //showChara = createGraphics(300, 300);
  //showChara.noFill();
  //showChara.
  // 図形の最終的な描画
  //for (int i=0; i<borderPixelsOrderedKey.size()-1; i++) {
  //  if (borderInfoArray.get(i).isInline) continue;
  //  //output.println("border"+i);
  //  beginShape();
  //  {
  //    for (int j=0; j<borderPixelsOrderedKey.get(i).size(); j++) {
  //      Pixel popPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(i).get(j) );
  //      vertex(popPixel.x, popPixel.y);
  //    }
  //    // 内側輪郭の穴を作成
  //    for (int p=0; p<borderPixelsOrderedKey.size()-1; p++) {
  //      beginContour();
  //      if (borderInfoArray.get(p).isInline && borderInfoArray.get(p).parentBorderOrder==i) {
  //        for (int q=borderPixelsOrderedKey.get(p).size()-1; q>=0; q--) {
  //          Pixel popContourPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(p).get(q) );
  //          vertex(popContourPixel.x, popContourPixel.y);
  //        }
  //      }
  //      endContour();
  //    }
  //  }
  //  endShape(CLOSE);
  //}


  //stroke(1);

  //rotateX(0.01);
  //rotateY(0.70);
  //rotateZ(0.31);
  //translate(100.1, 100.1, 0.1);

  showChara = createGraphics(300, 300);

  showChara.beginDraw();
  {
    showChara.noFill();
    // 図形の最終的な描画
    for (int i=0; i<borderPixelsOrderedKey.size()-1; i++) {
      if (borderInfoArray.get(i).isInline) continue;
      //output.println("border"+i);
      showChara.beginShape();
      {
        //output.println("beginShape");
        for (int j=0; j<borderPixelsOrderedKey.get(i).size(); j++) {
          Pixel popPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(i).get(j) );
          showChara.vertex(popPixel.x, popPixel.y);
          //output.println(popPixel.x+","+popPixel.y);
        }
        // 内側輪郭の穴を作成
        for (int p=0; p<borderPixelsOrderedKey.size()-1; p++) {
          showChara.beginContour();
          //output.println("beginContour");
          if (borderInfoArray.get(p).isInline && borderInfoArray.get(p).parentBorderOrder==i) {
            for (int q=borderPixelsOrderedKey.get(p).size()-1; q>=0; q--) {
              Pixel popContourPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(p).get(q) );
              showChara.vertex(popContourPixel.x, popContourPixel.y);
              //output.println(popContourPixel.x+","+popContourPixel.y);
            }
          }
          showChara.endContour();
          //output.println("endContour");
        }
      }
      showChara.endShape(CLOSE);
      //output.println("endShape");
    }
  }
  showChara.endDraw();
}

void draw() {
  background(100);
  rotateX(-0.04);
  rotateY(0.05);
  rotateZ(-0.15);
  translate(-1.0, 61.8, 0.1);

  scale(1, 1, 0.0008);
  for (int i=0; i<2; i++) {
    translate(0, 0, i);
    fill(242, 0, 0);
    image(showChara, 100, 100);
  }
}

int[][] pixels1to2(int[] _pixels, int _width, int _height) {
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

//void createModel(String _chara) {
//  String chara = _chara;
//}