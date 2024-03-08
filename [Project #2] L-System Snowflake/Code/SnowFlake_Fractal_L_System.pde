/**
 *  Making snowflake fractal by using L-System
 *  Refer to L_System_Template
 *
 * by Bohyun Choi 2023
*/

String S = "A";
String Rule_F = ">F<";
String Rule_A = "[+X][-X]FA";
String Rule_X = "A";

float length_factor = 1.2; //factor how regulate length of line
float angle = radians(30);

void setup() {
  size(900, 600);
}

void draw() {
  background(0);   
  frameRate(5);
  translate(width/2, height/2);
  rotate( -HALF_PI );
  //float branchLen = map(mouseY, 0, height, 30, 0.1);
  
  //blue background snow
  for (int i=0;i<5;i++) {
  pushMatrix();
  float branchLen = 10;
  strokeWeight(1.4); 
  stroke(153,204,255,40);
  render( S, branchLen );
  popMatrix();
  rotate(radians(72));
  }
  
  //white background snow
  rotate(radians(30));
  for (int i=0;i<5;i++) {
  pushMatrix();
  strokeWeight(3); 
  stroke(228,241,255,20);
  float branchLen = 8;
  render( S, branchLen );
  popMatrix();
  rotate(radians(72));
  }
  
  //blue background snow
  rotate(radians(20));
  for (int i=0;i<6;i++) {
  pushMatrix();
  strokeWeight(2); 
  stroke(153,199,247,10);
  float branchLen = 6;
  render( S, branchLen );
  popMatrix();
  rotate(radians(60));
  }
  
  rotate(radians(30));
  for (int i=0;i<5;i++) {
  pushMatrix();
  strokeWeight(1.5); 
  stroke(199,226,255,40);
  float branchLen = 5;
  render( S, branchLen );
  popMatrix();
  rotate(radians(72));
  }
  
  //black inside snow
  rotate(radians(30));
  for (int i=0;i<5;i++) {
  pushMatrix();
  stroke(0,0,0,20);
  strokeWeight(1.5); 
  float branchLen = 3;
  render( S, branchLen );
  popMatrix();
  rotate(radians(72));
  }
}

void render(String S, float branchLen) {
  int strLen = S.length();
  for (int i=0; i<strLen; i++) {
    switch( S.charAt(i) ) {
    case 'F': 
      line(0, 0, branchLen, 0);
      translate(branchLen, 0);
      break;
    case '+': 
      rotate(angle);
      break;
    case '-': 
      rotate(-angle);
      break;
    case '[': 
      pushMatrix();
      break;
    case ']': 
      popMatrix();
      break;
    case '<':
      branchLen /= length_factor;
      break;
    case '>':
      branchLen *= length_factor;
      break;
    }
  }
}

void keyPressed() {
  S = ApplyRule( S );
}

String ApplyRule( String str ) {
  String result = "";
  int strLen = str.length();
  for (int i=0; i<strLen; ++i) {
    char c = str.charAt(i);
    if (c == 'F') {
      result += Rule_F;
    } else if (c == 'A'){
      result += Rule_A;
    } else if (c == 'X') {
      result += Rule_X;
    } else {
      result += c;
    }
  }
  return result;
}
