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
 
int shape;

void setup() {
  size(1000, 800);
  background(0);
  noLoop();
  frameRate(5);
}

void draw() {
  background(0);
  noFill();
  shape = (int)random(4,11);
  strokeWeight(10);
  stroke(random(0,255),random(0,255),random(0,255),50);
  polygon(width/2,height/2, 300, shape);
  strokeWeight(7);
  polygon(width/2,height/2, 270, shape);

  for (int k=0;k<3;k++) {
    petals((int)random(3,6) * 2,k*10);
  }
  
  noStroke();
  fill(random(0,255),random(0,255),random(0,255),150);
  ellipse(width/2,height/2,100,100);

}

void petals(int petalnum,int t) {
  pushMatrix(); // pushMatrix()와 popMatrix()를 사용하여 변환 행렬을 보존
  translate(width/2, height/2);
  
  noFill();
  int r = (int)random(0,255);
  int g = (int)random(0,255);
  int b = (int)random(0,255);

  for (int i=0; i<petalnum; i++) {
    for (int x=0;x<=80+(t*2);x+=5) {
      strokeWeight(3);
      stroke(r,g,b, 100-(t*3));
      bezier(40+t,0,x,random(0+5*t,50+5*t),x,random(100+5*t,150+5*t),40+t,150+5*t); 
    }
    rotate(TWO_PI / petalnum);
  }
  popMatrix(); // 변환 행렬을 복원
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
  redraw();
}
