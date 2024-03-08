import java.util.ArrayList;
import peasy.PeasyCam;
import oscP5.*;
PeasyCam cam;
OscP5 oscP5;
PVector poseOrientation = new PVector();

int found;
float zoomScale;
float mouthHeight;
float Leyeopen, Reyeopen;

int rows=50, cols=150;

void setup() {
  size(800,800,P3D);
  background(0);
  cam = new PeasyCam(this,700);
  
  oscP5 = new OscP5(this,8338);
  oscP5.plug(this,"found","/found");
  oscP5.plug(this,"zoomScale","/pose/scale");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "mouthHeight", "/gesture/mouth/height");
  oscP5.plug(this, "Leyeopen", "/gesture/eye/left");
  oscP5.plug(this, "Reyeopen", "/gesture/eye/right");
  strokeWeight(2);
}

void draw() {
  background(0);
  scale(zoomScale*0.3);
 
  
  beginShape(POINTS);
  for(int theta = 0; theta<rows;theta +=1) {
    for(int pi=0;pi<cols;pi+=2){
      stroke(255,204-theta*2,204-theta);
      float r = (60*pow(abs(sin(radians(5/2*pi*360/cols))),1)+40*mouthHeight)*theta/rows;
      float x = r*cos(radians(pi*360/cols));
      float y = r*sin(radians(pi*360/cols)); 
      float bump = 10*sin(pi*10);
      float z = 300* pow(exp(1),-0.15*pow(abs(r/80),1.5))* 
                pow(abs(r/80),0.6)-200+bump;
      vertex(x,y,z);
    }
  }
  rotateX(0-poseOrientation.x*4);
  rotateY(0-poseOrientation.y*4);
  rotateZ(0-poseOrientation.z*4);
  endShape();
}

public void zoomScale(float s) {
  zoomScale = s;
}

public void poseOrientation(float x, float y, float z) {
  poseOrientation.set(x, y, z);
}

public void mouthHeight(float h){
  println(h);
  mouthHeight = h;
}

public void Leyeopen(float l){
  Leyeopen = l;
}

public void Reyeopen(float r){
  Reyeopen = r*25;
  Reyeopen = map(r,1,3,0,60);
}
