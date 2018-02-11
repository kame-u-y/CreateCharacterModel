ArrayList<CharaGraphics> charaGraphicsArray;

void setup() {
  size(300, 300);
  charaGraphicsArray = new ArrayList<CharaGraphics>();
  charaGraphicsArray.add(new CharaGraphics("総"));
  charaGraphicsArray.add(new CharaGraphics("亀"));
}

void draw() {
  background(255);
  fill(0, 100, 0);
  pushMatrix();
  {
    charaGraphicsArray.get(0).display();
  }
  popMatrix();

  pushMatrix();
  {
    translate(300, 0);
    charaGraphicsArray.get(1).display();
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