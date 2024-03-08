/*
  Project #1 by Bohyun Choi
  
  Place a polygon in the center of the background,
  and make one petal one by one and rotate it
  by the number of petals in the flower. 
  (For example, if a flower has eight petals,
  it must be rotated eight times at (2pi/8) angles.)

  The pointed degree or length of the petal is allocated as a random value,
  so it changes each time the process is implemented.
  
  Adjust the size of the flowers so that a total of three flowers overlap,
  and create the center of the flowers to complete the Korean traditional pattern.
  
  If you click mouse, the pattern will be change
 */

int[] NUM_PETALS = new int[3];
int petalnum = 0;
int shape;
int[] back_shape = new int[7];
float r, g, b;
float petal_sharp, petal_thin, petal_folded;

void setup() {
  size(1000, 800);
  background(0);
  noLoop();
  frameRate(5);
  int x = 6;
  int y = 4;

  for (int i = 0; i < 3; i++) {
    NUM_PETALS[i] = x;
    x += 2;
  }
  for (int i = 0; i < 7; i++) {
    back_shape[i] = y;
    y += 1;
  }

  petalnum = NUM_PETALS[int(random(0, 3))];
  shape = back_shape[int(random(0, 7))];
}

void draw() {
  background(0);
  r = random(0, 256);
  g = random(0, 256);
  b = random(0, 256);
  noFill();
  strokeWeight(10);
  stroke(r, g, b, 50);
  polygon(width/2, height/2, 300, shape);
  strokeWeight(7);
  polygon(width/2, height/2, 270, shape);

  noFill();
  petalnum = NUM_PETALS[int(random(0, 3))];
  petals3(petalnum);
  petalnum = NUM_PETALS[int(random(0, 3))];
  petals2(petalnum);
  petalnum = NUM_PETALS[int(random(0, 3))];
  petals1(petalnum);

  noStroke();
  r = random(0, 256);
  g = random(0, 256);
  b = random(0, 256);
  fill(r, g, b, 150);
  ellipse(width/2, height/2, 100,100);
}

void petals4(int petalnum) {
  pushMatrix(); // pushMatrix()와 popMatrix()를 사용하여 변환 행렬을 보존
  translate(width/2, height/2);

  r = random(0, 256);
  g = random(0, 256);
  b = random(0, 256);

  for (int i = 0; i < petalnum; i++) {
    for (int x = 0; x <= 120; x += 5) {
      strokeWeight(3);
      stroke(r, g, b, 20);
      bezier(60, 0, x, 100, x, 140, 60, 150);
    }
    rotate(TWO_PI / petalnum);
  }
  popMatrix(); // 변환 행렬을 복원
}

void petals3(int petalnum) {
  pushMatrix();
  translate(width/2, height/2);

  petal_thin = random(100, 150);
  petal_sharp = random(200, 300);
  petal_folded = random(0, 300);
  r = random(0, 256);
  g = random(0, 256);
  b = random(0, 256);

  for (int i = 0; i < petalnum; i++) {
    for (int x = 0; x <= 120; x += 5) {
      strokeWeight(3);
      stroke(r, g, b, 40);
      bezier(60, 0, x, petal_thin, x, petal_sharp, 60, 300);
    }
    rotate(TWO_PI / petalnum);
  }
  popMatrix();
}

void petals2(int petalnum) {
  pushMatrix();
  translate(width/2, height/2);

  r = random(0, 256);
  g = random(0, 256);
  b = random(0, 256);

  for (int i = 0; i < petalnum; i++) {
    for (int x = 0; x <= 100; x += 5) {
      strokeWeight(3);
      stroke(r, g, b, 70);
      bezier(50, 0, x, 150, x, 200, 50, 200);
    }
    rotate(TWO_PI / petalnum);
  }
  popMatrix();
}

void petals1(int petalnum) {
  pushMatrix();
  translate(width/2, height/2);

  petal_thin = random(0, 50);
  petal_sharp = random(100, 150);
  petal_folded = random(0, 300);
  r = random(0, 256);
  g = random(0, 256);
  b = random(0, 256);

  noFill();
  for (int i = 0; i < petalnum; i++) {
    for (int x = 0; x <= 80; x += 5) {
      strokeWeight(3);
      stroke(r, g, b, 100);
      bezier(40, 0, x, petal_thin, x, petal_sharp, 40, 150);
    }
    rotate(TWO_PI / petalnum);
  }
  popMatrix();
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void mousePressed() {
  background(0);
  shape = back_shape[int(random(0, 7))];
  redraw();
}
