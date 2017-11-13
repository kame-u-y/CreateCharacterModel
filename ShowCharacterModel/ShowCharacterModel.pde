String[] borderPixels;
PGraphics character;

void setup() {
  size(600, 600, P3D);
  background(100);

  borderPixels = loadStrings("borderPixels.txt");


  stroke(1);

  rotateX(0.01);
  rotateY(0.70);
  rotateZ(0.31);
  translate(100.1, 100.1, 0.1);

  character = createGraphics(300, 300);
  character.beginDraw();
  {
    character.beginShape();
    {
      for (int i=0; i<borderPixels.length; i++) {
        int x = int(borderPixels[i].split(",")[0]);
        int y = int(borderPixels[i].split(",")[1]);
        println(x, y);
        character.vertex(x, y);
      }
    }
    character.endShape();
  }
  character.endDraw();
}

void draw() {
  background(100);
  rotateX(0.56);
  rotateY(0.02);
  rotateZ(-0.15);
  translate(-1.0, 35.5, 0.1);

  scale(1, 1, 0.02);
  for (int i=0; i<50; i++) {
    translate(0, 0, i);
    image(character, 100, 100);
  }
}