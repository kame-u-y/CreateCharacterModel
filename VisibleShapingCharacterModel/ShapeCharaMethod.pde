
//図形の作成関数
void shapeChara(String _chara, int _i) {
  String shapingChara = _chara;

  int[][] pixels2 = {{}};

  /////////////////////////
  /////描画セットアップ////
  /////////////////////////

  //キャンバスの初期化
  background(255);

  //テキストの描画
  fill(0, 200, 200);
  textAlign(CENTER);
  textSize(250);
  textFont(font);
  text(shapingChara, width/2, height/2 + 90);

  firstInitial = false;
  //println(pixels2);

  for (int i=0; i<firstDots.size(); i++) {
    set(firstDots.get(i).x, firstDots.get(i).y, color(0));
  }
  //テキストが描画されたpixelsを取得
  loadPixels();
  //updatePixels();
  //二次元配列へ変換
  pixels2 = pixels1to2(pixels, width, height);

  ///////////////////////////
  ///////////////////////////
  ///////////////////////////

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


  //oldDirectionKey = -1;

  //無限ループ回避のためのshapingCount
  //shapingCount = 0;

  if (flag==Flag.first) {

    int i = _i;
    //int j = _j;
    if (i==pixels2.length-1) {
      flag = Flag.second;
      countI = 0;
      return;
    }

    //輪郭を全て黒にする
    //for (int i=1; i<pixels2.length-1; i++) {
    for (int j=1; j<pixels2[i].length-1; j++) {
      if ( pixels2[i][j]!=-1) {
        for (int p=0; p<8; p++) {
          int x = i+directionMap.get(p).x;
          int y = j+directionMap.get(p).y;
          if ( pixels2[x][y]==-1 ) {
            //set(i, j, color(0));
            firstDots.add( new Pixel(i, j) );
            break;
          }
        }
      }
    }

    return;
  } else if (flag==Flag.second) {

    if (secondInitial) {
      //前回の輪郭追跡の開始点を格納する変数
      oldBeginningPixel = new Pixel(0, 0);

      //探索済みで次回以降に探索を回避するためのHashMap 入力例：<"x,y", new Pixel(x,y)>
      searchedBorderPixels = new HashMap<String, Pixel>();

      //輪郭ごと、追跡した順番にHashMapのキーを保存
      borderPixelsOrderedKey = new ArrayList<ArrayList<String>>();

      //輪郭ごとの情報を格納したArrayList、追跡した順番に保存
      //  (borderPixelsOrderedKeyの一次元目のインデックスと対応)
      borderInfoArray = new ArrayList<BorderInfo>();

      secondInitial = false;
      return;
    }

    if (searchBeginningFlag) {
      //shaping:  //輪郭の輪の数だけループ
      //while (shapingCount<30) {


      borderPixelsOrderedKey.add(new ArrayList<String>());

    searchBeginning: //輪郭の追跡が終わるまでループ
      for (int i=oldBeginningPixel.x; i<pixels2.length; i++) {
        for (int j=0; j<pixels2[i].length; j++) {

          //pixel2[i][j]の色が黒(つまり輪郭）ならば
          if (pixels2[i][j]==color(0)) {

            //探索済みであったらスルー
            if (searchedBorderPixels.get(i+","+j)!=null) {
              println("this pixel has already saved");
              continue;
            }

            //追跡開始&最初の値を格納
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

                  //内側にとっての親の輪郭候補のborderInfoを取得
                  BorderInfo searchedBorderInfo = borderInfoArray.get( searchedBorderOrder );

                  if ( searchedBorderInfo.isInline ) {
                    //もし親候補も他に対して内側の輪郭であれば、その親こそが自分にとっても親に当たる
                    borderInfoArray.get(borderInfoArray.size()-1).parentBorderOrder = searchedBorderInfo.parentBorderOrder;
                  } else {
                    //親候補が外側の輪郭であれば、その親候補こそが自分にとっての親である
                    borderInfoArray.get(borderInfoArray.size()-1).parentBorderOrder = searchedBorderOrder;
                  }
                  break;
                }
              }
            }

            oldBeginningPixel = new Pixel(i, j);  //次のbeginningPixelで探索開始点として使う
            searchBeginningFlag = false;
            break searchBeginning;
          }
        }

        //黒のピクセルが見つからずキャンバスの最後まで到達したら、shaping終了
        if (i==pixels2.length-1) {
          println("end shaping");
          flag = Flag.third;
          countI = 0;
          searchBeginningFlag = false;
          return;
          //break shaping;
        }
      }

      searchOutlinesCount = 0;
      lastPutKey = "";
    }

    //無限ループ回避のsearchOutlinesCount
    //int searchOutlinesCount = _i;

    //一つ前のピクセルが格納されているsearchedBorderPixelsのキー

    //前回の輪郭追跡開始点は今回の探索開始点
    beginningPixel = oldBeginningPixel;
    searchOutlinesCount = _i;
    if (searchOutlinesCount == 10000) {
      countI = 0;
      searchBeginningFlag = true;
    }

    //searchOutlines:
    //while (searchOutlinesCount<1000) {
    //searchOutlinesCount++;

    Pixel lastPixel = (lastPutKey=="") ? beginningPixel : searchedBorderPixels.get(lastPutKey);
    print("lastPixel.x="+lastPixel.x +", lastPixel.y="+ lastPixel.y);

    //追跡探索開始方向の決定
    int startDirectionKey = (oldDirectionKey==-1) ? 0 : (oldDirectionKey+6)%8;
    boolean reverseFlag = true;
    //反時計回りに周囲を探索
    for (int i=startDirectionKey; i<startDirectionKey+5; i++) {
      int searchX = lastPixel.x + directionMap.get(i).x;
      int searchY = lastPixel.y + directionMap.get(i).y;

      if (pixels2[searchX][searchY] == color(0)) {
        //探索し追跡開始点まで帰ってきたら終了
        if (searchX==beginningPixel.x && searchY==beginningPixel.y) {
          println("returned beginningPixel");
          countI = 0;
          searchBeginningFlag = true;
          //return;
          reverseFlag = false;
          break;
        }

        println("searching...");
        //探索済み情報を保存
        searchedBorderPixels.put(searchX+","+searchY, new Pixel(searchX, searchY, shapingCount));
        //輪郭のピクセルを保存
        borderPixelsOrderedKey.get(shapingCount).add(searchX+","+searchY);

        oldDirectionKey = i%8;
        lastPutKey = searchX+","+searchY;
        return;
        //break;
      }
    }
    if (reverseFlag) {
      //進む方向にborderPixelが存在しないとき元の方向に戻る
      println("couldn't discover the direction in forward");
      //探索済み情報を保存
      searchedBorderPixels.put(lastPixel.x+","+lastPixel.y, lastPixel);
      //輪郭のピクセルを保存
      borderPixelsOrderedKey.get(shapingCount).add(lastPixel.x+","+lastPixel.y);

      oldDirectionKey = (oldDirectionKey + 4)%8;
      lastPutKey = lastPixel.x +","+ lastPixel.y;
      return;
    }
    //}
    //} else if (flag==Flag.third) {
    //stop();
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




  println("\n\nend\n\n");
  //output.close();
  //}
}