import processing.sound.*;
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

ArrayList<CharaGraphics> charaGraphicsArray;

int cnt_i = 10;
int cnt_j = 10;

int effect = 0;

void settings() {
  size(1000, 1000, P3D);
}

void setup() {
  //第二ウィンドウの作成
  second = new SecondApplet(this);

  setupGUI();
  setupAudio();

  charaGraphicsArray = new ArrayList<CharaGraphics>();
  charaGraphicsArray.add( 
    new CharaGraphics((int)random(100, 600), (int)random(100, 300), "総") 
    );
  hint(ENABLE_DEPTH_SORT);
  imageMode(CENTER);
}

void draw() {
  float diameter = map(amp.analyze(), 0.0, 1.0, 0.0, 1000);
  background(50);
  CharaGraphics cg2 = charaGraphicsArray.get(charaGraphicsArray.size()-1);
  if (frameCount%10==0) {
    cg2.vtxInterval = 10;
    cg2.vtxRandomX = 0;
    cg2.vtxRandomY  = 0;

    if (effect==0) {
      cg2.vtxInterval = (int)diameter+1;
    } else if (effect==1) {
      cg2.vtxRandomX  = diameter*0.2;
      cg2.vtxRandomY = diameter*0.2;
    } else if (effect==2) {
      cg2.vtxRandomX = diameter*0.4;
    } else if (effect==3) {
      cg2.vtxRandomY = diameter*0.4;
    }
    cg2.shapeModel();
  }

  //pushMatrix();
  //{
  //  translate(width/2, height/2, 0);
  //  rotateX(frameCount*0.01);
  //  rotateZ(frameCount*0.01);

  //  PShape shape = createShape(SPHERE, 100+diameter);
  //  shape.setTexture(cg2.image);
  //  shape(shape);
  //}
  //popMatrix();


  pushMatrix();
  {
    translate(width/2, height/2, 0);
    rotateX(frameCount*0.005);
    rotateZ(frameCount*0.005);
    int centerCnt = 100;
    for (int i=0; i<centerCnt; i++) {
      pushMatrix();
      scale(1.5);
      translate(0, 0, (-centerCnt+i)/5.0);
      image(cg2.image, 0, 0);
      popMatrix();
    }
  }
  popMatrix();


  pushMatrix();
  {
    translate(width/2, height/2, 0);
    rotateX(frameCount*0.005);
    rotateZ(frameCount*0.005);

    float radius = 300;
    for (float i=PI/cnt_i; i<PI; i+=PI/cnt_i) {
      float z = radius * cos(i);
      for (float j=0; j<2*PI; j+=2*PI/cnt_j) {
        float x = radius * sin(i) * cos(j);
        float y = radius * sin(i) * sin(j);

        pushMatrix();
        translate(x, y, z);
        scale(0.5);
        rotateX(frameCount*0.005);
        rotateY(frameCount*0.005);
        rotateZ(frameCount*0.005);

        colorMode(HSB, 360, 360, 100);
        tint(360-degrees(j), 378-2*degrees(i), 100);
        colorMode(RGB, 255, 255, 255);
        image(cg2.image, 0, 0);
        noTint();
        popMatrix();
      }
    }
  } 
  popMatrix();



  //for (int i=0; i<charaGraphicsArray.size(); i++) {
  //  pushMatrix();
  //  scale(0.5);

  //  CharaGraphics cg = charaGraphicsArray.get(i);

  //  translate(574, 398, 687);

  //  for (int j=0; j<38; j++) {
  //    //image(cg.image, 208, 1*j);
  //  }
  //  popMatrix();
  //}
}

void keyPressed() {
  if (keyCode==BACKSPACE) {
    charaGraphicsArray.remove(0);
  } else if (keyCode==UP) {
    cnt_i++;
  } else if (keyCode==DOWN) {
    cnt_i--;
  } else if (keyCode==RIGHT) {
    cnt_j++;
  } else if (keyCode==LEFT) {
    cnt_j--;
  } else if (key=='1') {
    effect = 0;
  } else if (key=='2') {
    effect = 1;
  } else if (key=='3') {
    effect = 2;
  } else if (key=='4') {
    effect = 3;
  }
}


void setupGUI() {
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
}


void setupAudio() {
  audioIn = new AudioIn(this, 0);
  audioIn.start();

  amp = new Amplitude(this);
  amp.input(audioIn);
}