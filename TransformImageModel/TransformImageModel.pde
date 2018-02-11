//PImage image;
//CharaGraphics chara;
ArrayList<CharaGraphics> charaGraphicsArray;

ArrayList<ArrayList<PointSet>> pointSetArray = new ArrayList<ArrayList<PointSet>>();
PImage image3;

class PointSet {
  Pixel first = new Pixel(0, 0);
  Pixel second = new Pixel(0, 0);
  PointSet(Pixel _first, Pixel _second) {
    first = _first;
    second = _second;
  }
}

void setup() {
  size(600, 600, P2D);
  charaGraphicsArray = new ArrayList<CharaGraphics>();
  //image = loadImage("kagerou.png");
  PImage image1 = loadImage("e_vi.png");
  PImage image2 = loadImage("e_phi.png");
  image3 = image2.copy();
  charaGraphicsArray.add(new CharaGraphics(image1));
  charaGraphicsArray.add(new CharaGraphics(image2));
  //chara = new CharaGraphics(image);

  int borderSize = charaGraphicsArray.get(0).borderPixelsOrderedKey.size();
  CharaGraphics cg1 = charaGraphicsArray.get(0);
  CharaGraphics cg2 = charaGraphicsArray.get(1);
  for (int i=0; i<1; i++) {
    pointSetArray.add( new ArrayList<PointSet>() );
    int intervalPlot1 = cg1.borderPixelsOrderedKey.get(i).size()/300;
    int intervalPlot2 = cg2.borderPixelsOrderedKey.get(i).size()/300;

    print("**", "i="+i, "**");

    int j1 = 0, j2 = 0;
    while (j1<cg1.borderPixelsOrderedKey.get(i).size() || j2<cg2.borderPixelsOrderedKey.get(i).size()) {
      //while (j1<cg1.borderPixelsOrderedKey.get(i).size() ) {
      if (j1>=cg1.borderPixelsOrderedKey.get(i).size()) j1 = cg1.borderPixelsOrderedKey.get(i).size()-1;
      if (j2>=cg2.borderPixelsOrderedKey.get(i).size()) j2 = cg2.borderPixelsOrderedKey.get(i).size()-1;

      Pixel popPixel1 = cg1.searchedBorderPixels.get( cg1.borderPixelsOrderedKey.get(i).get(j1) );
      Pixel popPixel2 = cg2.searchedBorderPixels.get( cg2.borderPixelsOrderedKey.get(i).get(j2) );
      pointSetArray.get(pointSetArray.size()-1).add(new PointSet(popPixel1, popPixel2));

      j1 += intervalPlot1;
      j2 += intervalPlot2;
    }
  }
}

void draw() {
  background(100);
  //image(image, 0, 0);

  //charaGraphicsArray.get(0).display();
  //charaGraphicsArray.get(1).display();

  pushMatrix();
  {
    for (int i=0; i<pointSetArray.size(); i++) {
      beginShape();
      for (int j=0; j<pointSetArray.get(i).size(); j++) {
        Pixel first  = pointSetArray.get(i).get(j).first;
        Pixel second = pointSetArray.get(i).get(j).second;
        //line(first.x, first.y, second.x, second.y);
        curveVertex(
          (first.x+(second.x-first.x)/2)+(second.x-first.x)/2.0*cos(frameCount*(frameCount*0.001)/(2*PI) + PI ), 
          (first.y+(second.y-first.y)/2)+(second.y-first.y)/2.0*cos(frameCount*(frameCount*0.001)/(2*PI) + PI )
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
}

//void keyPressed() {
//  if (keyCode==UP) {
//    chara.intervalPlot++;
//  } else if (keyCode==DOWN) {
//    chara.intervalPlot--;
//  }
//}