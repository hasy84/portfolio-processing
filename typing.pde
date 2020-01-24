import fisica.*;
FWorld world;
PImage zekkei[] = new PImage[12];
String[] names = {"eiffel", "pissa", "sagradafamilia", "burjkhalifah", "tajmahal", "colosseo", "pyramid", "operahouse", "angkorwat", "basils", "statueofliberty", "montsaintmichel"};
FCircle heritage;
String input = "";
FBox roter, roter2, roter3;
float theta = 0;
PShape earth;

void setup() {
  Fisica.init(this);
  world = new FWorld();
  imageMode(CORNER);
  noStroke();

  for (int i = 0; i < 12; i++) {
    zekkei[i] = loadImage("view"+i+".jpg");
  }
  size(900, 700, P3D);
  earth = createShape(SPHERE, 180);
  earth.setTexture(loadImage("earth.jpeg"));
  earth.setStroke(false);

  world.setEdges();

  FCircle pivot = createCircle(30, 300, 550, true);
  roter = createBox(200, 20, 300, 550, 0, false);
  FRevoluteJoint joint = new FRevoluteJoint(roter, pivot);
  world.add(joint);

  FCircle pivot2 = createCircle(30, 450, 150, true);
  roter2 = createBox(200, 20, 450, 150, 0, false);
  FRevoluteJoint joint2 = new FRevoluteJoint(roter2, pivot2);
  world.add(joint2);

  FCircle pivot3 = createCircle(30, 600, 550, true);
  roter3 = createBox(200, 20, 600, 550, 0, false);
  FRevoluteJoint joint3 = new FRevoluteJoint(roter3, pivot3);
  world.add(joint3);

  roter.setFillColor(#000000);
  roter2.setFillColor(#000000);
  roter3.setFillColor(#000000);
  pivot.setFillColor(#000000);
  pivot2.setFillColor(#000000);
  pivot3.setFillColor(#000000);
  joint.setFillColor(#000000);
  joint2.setFillColor(#000000);
  joint3.setFillColor(#000000);
}

void draw() {
  int r= (int)random(12);
  int alpha =+r;
  background(0);

  pushMatrix();
  translate(width/2, height/2);
  //directionalLight(100, 100, 120, 1, -1, -1);
  theta +=0.05;
  rotateY(theta);
  shape(earth);
  popMatrix();

  //rect(0, 0, heritage.getSize(), 10);
  lights();

  if (frameCount % 200 == 0) {
    heritage = new FCircle(30);
    heritage.setPosition(random(270, 500), random(170, 400));
    heritage.setRestitution(1.25);
    heritage.attachImage(zekkei[r]);
    heritage.setVelocity(50, 100);
    heritage.setRotation(alpha);

    for (int i = 0; i < 12; i++) {
      if (r == i) {
        heritage.setName(names[i]);
      }
    }

    world.add(heritage);
  }


  fill(255);
  textSize(20);
  ArrayList<FBody> bodies = world.getBodies();
  for (int i = 0; i < bodies.size(); i++) {
    FBody b = bodies.get(i);
    String n = b.getName();
    if (n != null) {
      text(b.getName(), b.getX()+80, b.getY());
      println(b.getName(), b.getX(), b.getY());
    }
  }

  fill(255);
  textSize(50);
  text(input, 50, 100);

  roter.addTorque(200);
  roter2.addTorque(100);
  roter3.addTorque(200);

  world.step();
  world.draw();
}

void keyPressed() {
  if (keyCode == ENTER) {
    ArrayList<FBody> bodies = world.getBodies();
    for (int i = 0; i < bodies.size(); i++) {
      FBody b = bodies.get(i);
      //println(b.getName());
      if (input.equalsIgnoreCase(b.getName())) {
        world.remove(b);
        break;
      }
    }

    input = "";
  } else if ('a' <= key && key <= 'z' || 'A' <= key && key <= 'Z' || key == ' ') {
    input +=key;
  }
}

FCircle createCircle(float size, float x, float y, boolean isStatic) {
  FCircle c = new FCircle(size);
  c.setPosition(x, y);
  c.setStatic(isStatic);
  world.add(c);
  return c;
}


FBox createBox(float w, float h, float x, float y, float r, boolean isStatic) {
  FBox b = new FBox(w, h);
  b.setPosition(x, y);
  b.setRotation(r);
  b.setStatic(isStatic);
  world.add(b);
  return b;
}
