/** 
 * Racing Game
 * 
 * using MotionSender with Wekinator
 * if you tilt phone, the car's position will be changed
 * if your car get in the grass, the speed will be lower
 *
 * by Bohyun Choi, 2023
 *
**/

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

float angleX = 0.0;
float angleY = 0.0;
float radius = 650;
int wekinatorOutput;
float direction;
float currentX = width+100;
float acc = 0.05;

PImage roadImg;
PImage taxiImg;
PImage user_car_img;

PShape roadCircuit;
PShape red_car;
PShape taxi;


void setup() {
  camera();
  size(1000, 800, P3D);
  roadImg = loadImage("road2.png");
  taxiImg = loadImage("low_poly_car_texture.png");
  user_car_img = loadImage("user_car.png");
  
  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("192.168.200.119", 6448);
  
  noStroke();
  roadCircuit = createShape(SPHERE, radius);
  
  red_car = loadShape("Car_Low_Poly.obj");
  taxi = loadShape("low_poly_taxi.obj");
  taxi.setTexture(taxiImg);
  imageMode(CENTER);
}

void draw() {
 
  background(207, 226, 243);
  
  //making turning roadcircuit sphere
  translate(width / 2, height / 2 + 600, 0);
  rotateX(angleX+acc);
  rotateZ(30);
  
  roadCircuit.setTexture(roadImg);
  noStroke();
  shape(roadCircuit);
  //angleX -= 0.02;
  
  //if theta(first parameter) bigger, it will be placed down
  //if pi(second parameter) value bigger, it will be placed to left
  CreateCar(radians(130) + PI / 2,radians(80)+PI/2,"red");
  CreateCar(radians(80)+PI/2,radians(30)+PI/2,"taxi");
  CreateCar(radians(40) + PI / 2,radians(100)+PI/2,"red");
  CreateCar(radians(20) + PI / 2,radians(90)+PI/2,"taxi");
  CreateCar(radians(0) + PI / 2,radians(80)+PI/2,"red");
  CreateCar(radians(170) + PI / 2,radians(30)+PI/2,"red");
  
  //User Gesture Car (Controlled by user's gesture)
  //To make this, we have to add hint() to use 2D with 3D
  hint(DISABLE_DEPTH_TEST);
  camera();
  //noLights();
  fill(255);
  float movement = 40;
  
  switch(str(direction)) {
    case "1.0":
      currentX -= movement;
      break;
      
    case "2.0":
      currentX = currentX;
      break;

    case "3.0":
      currentX += movement;
      break;
      
  }
  noLights();
  
  //if the car goes inside to grass, the speed will be slower
  if (currentX>width-50 || currentX<50){
    angleX -= 0.01;
  } else {
    angleX -= 0.03;
  }
  if (currentX < 0) currentX = 0;
  if (currentX > width) currentX = width;
  image(user_car_img, currentX+100, height-100, 250, 200);
  
  hint(ENABLE_DEPTH_TEST);
  
}

void CreateCar(float theta, float pi, String CarType)
{
  //changing spherical coordinate to orthogonal coordinate system
  float x = radius * sin(theta) * cos(pi);
  float y = radius  * sin(theta) * sin(pi);
  float z = radius * cos(theta);
  
  PVector pos = new PVector(x,y,z);
  PVector xaxis = new PVector(1,0,0);
  float angleb = PVector.angleBetween(xaxis,pos);
  PVector raxis = xaxis.cross(pos);
  
  pushMatrix();
  translate(x,y,z);
  rotate(angleb,raxis.x,raxis.y, raxis.z);
  rotateZ(-20.5);
  lights();
  scale(15);
  switch (CarType)
  {
    case "red":
      shape(red_car);
      break;
    case "taxi":
      shape(taxi);
      break;
    
  }
  popMatrix();

}

void oscEvent(OscMessage m) {
  m.print();
  if (m.checkAddrPattern("/wek/outputs") == true) {
      direction = m.get(0).floatValue(); // Wekinator 출력 값을 정수로 변환하여 저장
  }
  println(direction);
}
