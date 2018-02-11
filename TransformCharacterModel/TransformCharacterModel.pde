ArrayList<CharaGraphics> charaGraphicsArray;

ArrayList<ArrayList<PointSet>> pointSetArray = new ArrayList<ArrayList<PointSet>>();
//ArrayList<ArrayList<PointSet>> outerPointSet = new ArrayList<PointSet>();
//ArrayList<ArrayList<PointSet>> innerPointSet = new ArrayList<PointSet>();
class PointSet {
  Pixel first  = new Pixel(0, 0);
  Pixel second = new Pixel(0, 0);
  PointSet(Pixel _first, Pixel _second) {
    first  = _first;
    second = _second;
  }

  //void SetByArray(int[] _array1, int[] _array2) {
  //  for (int i=0; i<_array1.length; i++) {
  //    pointSet.add(new PointSet(_array1[i], _array2[i]));
  //  }
  //}
}

void setup() {
  size(300, 300);
  charaGraphicsArray = new ArrayList<CharaGraphics>();
  charaGraphicsArray.add(new CharaGraphics("・"));
  charaGraphicsArray.add(new CharaGraphics("本"));

  //ArrayList<Integer> contourIndex = new ArrayList<Integer>();
  int borderSize = charaGraphicsArray.get(0).borderPixelsOrderedKey.size();
  CharaGraphics cg1 = charaGraphicsArray.get(0);
  CharaGraphics cg2 = charaGraphicsArray.get(1);
  for (int i=0; i<borderSize-1; i++) {
    pointSetArray.add( new ArrayList<PointSet>() );
    int intervalPlot1 = cg1.borderPixelsOrderedKey.get(i).size()/100;
    int intervalPlot2 = cg2.borderPixelsOrderedKey.get(i).size()/100;

    int j1 = 0, j2 = 0;
    while (j1<cg1.borderPixelsOrderedKey.get(i).size() || j2<cg2.borderPixelsOrderedKey.get(i).size()) {
    //while (j1<cg1.borderPixelsOrderedKey.get(i).size() ) {
      if(j1>=cg1.borderPixelsOrderedKey.get(i).size()) j1 = cg1.borderPixelsOrderedKey.get(i).size()-1;
      if(j2>=cg2.borderPixelsOrderedKey.get(i).size()) j2 = cg2.borderPixelsOrderedKey.get(i).size()-1;
      
      Pixel popPixel1 = cg1.searchedBorderPixels.get( cg1.borderPixelsOrderedKey.get(i).get(j1) );
      Pixel popPixel2 = cg2.searchedBorderPixels.get( cg2.borderPixelsOrderedKey.get(i).get(j2) );
      pointSetArray.get(pointSetArray.size()-1).add(new PointSet(popPixel1, popPixel2));

      j1 += intervalPlot1;
      j2 += intervalPlot2;
    }
    print("++", cg1.borderPixelsOrderedKey.get(i).size(), intervalPlot1, "++");
    print("++", cg2.borderPixelsOrderedKey.get(i).size(), intervalPlot2, "++");

    //    for (int j=0; j<cg1.borderPixelsOrderedKey.get(i).size(); j+=intervalPlot) {
    //      Pixel popPixel1 = cg1.searchedBorderPixels.get( cg1.borderPixelsOrderedKey.get(i).get(j) );
    //      Pixel popPixel2 = cg2.searchedBorderPixels.get( cg2.borderPixelsOrderedKey.get(i).get(j) );
    //      pointSetArray.get(pointSetArray.size()-1).add(new PointSet(popPixel1, popPixel2));
    //    }
  }


  //for (int i=0; i<borderPixelsOrderedKey.size()-1; i++) {
  //  if (borderInfoArray.get(i).isInline) continue;
  //  beginShape();
  //  {
  //    int intervalPlot = borderPixelsOrderedKey.get(i).size()/100;
  //    //println(intervalPlot);
  //    //for (int j=0; j<borderPixelsOrderedKey.get(i).size(); j++) {
  //    for (int j=0; j<borderPixelsOrderedKey.get(i).size(); j+=intervalPlot) {
  //      Pixel popPixel = searchedBorderPixels.get( borderPixelsOrderedKey.get(i).get(j));
  //      curveVertex(popPixel.x, popPixel.y);
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
}

void draw() {
  background(255);
  fill(200, 0, 0);
  //pushMatrix();
  //{
  //  translate(300, 0);
  //  fill(255, 0, 0);
  //  charaGraphicsArray.get(0).display();
  //}
  //popMatrix();

  //pushMatrix();
  //{
  //  translate(300, 0);
  //  fill(0, 255, 0);
  //  charaGraphicsArray.get(1).display();
  //}
  //popMatrix();

  //noFill();
  //fill(0);
  pushMatrix();
  {
    
    for (int i=0; i<pointSetArray.size(); i++) {
      beginShape();
      for (int j=0; j<pointSetArray.get(i).size(); j++) {
        Pixel first  = pointSetArray.get(i).get(j).first;
        Pixel second = pointSetArray.get(i).get(j).second;
        //line(first.x, first.y, second.x, second.y);
        curveVertex(
          (first.x+(second.x-first.x)/2)+(second.x-first.x)/2.0*sin(frameCount/(2*PI*4) ), 
          (first.y+(second.y-first.y)/2)+(second.y-first.y)/2.0*sin(frameCount/(2*PI*4) )
          );
        //point(
        //  (first.x+(second.x-first.x)/2)+abs(second.x-first.x)/2.0*sin( ), 
        //  (first.y+(second.y-first.y)/2)+abs(second.y-first.y)/2.0*sin( )
        //  );
      }
      endShape(CLOSE);
    }
  }
  popMatrix();


  String strokeNum = "[";
  for (CharaGraphics cg : charaGraphicsArray) {
    int outlineNum = 0;
    int inlineNum = 0;
    for (BorderInfo bi : cg.borderInfoArray) {
      if (bi.isInline) {
        inlineNum ++;
      } else {
        outlineNum ++;
      }
    }
    strokeNum += "["+outlineNum+","+inlineNum+"]";
  }
  strokeNum += "]";
  println(strokeNum);
}