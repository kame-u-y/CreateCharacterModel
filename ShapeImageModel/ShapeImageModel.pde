PImage image;
CharaGraphics chara;

void setup(){
  size(600, 800, P2D);
  image = loadImage("kagerou.png");
  //image = loadImage("myu2.png");
  chara = new CharaGraphics(image);
}

void draw(){
  background(100);
  //image(image, 0, 0);
  chara.display();
}

void keyPressed(){
  if(keyCode==UP){
  chara.intervalPlot++;
  } else if(keyCode==DOWN) {
    chara.intervalPlot--;
  }
}