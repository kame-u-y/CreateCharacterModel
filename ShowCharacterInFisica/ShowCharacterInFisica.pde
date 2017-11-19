import fisica.*;
FWorld world;

String[] borderPixels;
ArrayList<FPoly> polys = new ArrayList<FPoly>();

void setup() {
  size(600, 600);
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();

  background(255);
  scale(0.3);

  borderPixels = loadStrings("borderPixels_kame.txt");

  for (int i=0; i<borderPixels.length; i++) {
    if (borderPixels[i].matches("beginShape")) {
      polys.add(new FPoly());
      //polys.get(polys.size()-1).setStaticBody(true);
    } else if (borderPixels[i].matches("endShape")) {
      world.add(polys.get(polys.size()-1));
    } else if (borderPixels[i].matches("beginContour") || borderPixels[i].matches("endContour")) {
      continue;
    } else {
      int x = int(borderPixels[i].split(",")[0]);
      int y = int(borderPixels[i].split(",")[1]);
      polys.get(polys.size()-1).vertex(x, y);
    }

    //poly.vertex(, );
    //poly.vertex(1, 1);
  }
}

void draw() {
  background(100);

  world.step();
  world.draw();
}