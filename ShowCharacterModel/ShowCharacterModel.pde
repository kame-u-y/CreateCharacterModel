import processing.sound.*;
//import picking.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

SecondApplet second;
JLayeredPane pane;
JTextField   field;
JButton      button;

AudioIn      audioIn;
Amplitude    amp;
//Picker       picker;
int pickId = -1;

ArrayList<CharaGraphics> charaGraphicsArray;


void settings() {
  size(1000, 600, P3D);
  //println(PFont.list());
}

void setup() {
  //第二ウィンドウの作成
  second = new SecondApplet(this);


  Canvas canvas = (Canvas) second.getSurface().getNative();
  pane = (JLayeredPane) canvas.getParent().getParent();

  field = new JTextField("");
  field.setBounds(20, 40, 100, 30);
  pane.add(field);

  button = new JButton("作成");
  button.setBounds(70, 70, 50, 30);

  button.addActionListener( new ActionListener() {
    @Override
      public void actionPerformed(ActionEvent event) {
      String[] inputCharas = field.getText().split("");
      for (int i=0; i<inputCharas.length; i++) {
        charaGraphicsArray.add( new CharaGraphics(0, 0, inputCharas[i]) );
      }
      field.setText("");
    }
  }
  );
  pane.add(button);

  setupAudio();
  //picker = new Picker(this);

  charaGraphicsArray = new ArrayList<CharaGraphics>();
  charaGraphicsArray.add( new CharaGraphics((int)random(100, 600), (int)random(100, 300), "総") );

  //hint(ENABLE_DEPTH_SORT);
}

void draw() {
  float diameter = map(amp.analyze(), 0.0, 1.0, 0.0, 1000);

  background(100);
  //rotateX(-0.04);
  //rotateY(0.25);
  //rotateZ(-0.15);
  //translate(-1.0, 61.8, 0.1);
  scale(1.0, 1.0, 1.0);

  for (int i=0; i<charaGraphicsArray.size(); i++) {
    //picker.start(i);
    pushMatrix();
    //translate(cg.imageX, cg.imageY, 0.0);
    //translate(cg.imageX, cg.imageY, 0);
    //scale(1.0, 1.0, 1.0);
    scale(0.5);

    CharaGraphics cg = charaGraphicsArray.get(i);
    if (frameCount%10==0) {
      cg.vtxInterval = (int)diameter+1;
      cg.shapeModel();
    }
    //beginShape();
    //textureMode(IMAGE);
    //texture(cg.image);
    //vertex(-100, -100, 0, 0, 0);
    //vertex(100, -100, 0, cg.image.width, 0);
    //vertex(100, 100, 0, cg.image.width, cg.image.height);
    //vertex(-100, 100, 0, 0, cg.image.height);
    //endShape();
    //PShape globe = createShape(SPHERE, 50);
    //globe.setTexture(cg.image);
    image(cg.image, i*300, 500);
    popMatrix();
  }
  //picker.stop();

  ellipse(0, 0, 50, 50);
}

void mousePressed() {
  //pickId = picker.get(mouseX, mouseY);
  print(pickId+",");
}

void keyPressed() {
  if (keyCode==BACKSPACE) {
    charaGraphicsArray.remove(0);
  }
  charaGraphicsArray.add(new CharaGraphics(0, 0, "は"));
}

void setupAudio() {
  audioIn = new AudioIn(this, 0);
  audioIn.start();

  amp = new Amplitude(this);
  amp.input(audioIn);
}