import gab.opencv.*;
import processing.video.*;
import processing.sound.*;
import controlP5.*;
import oscP5.*;
import netP5.*;



Capture cam;
OpenCV opencv;
ControlP5 cp5;
OscP5 oscP5;
NetAddress dest;
SoundFile BacodePlayer; //barcode

PImage cam_img; //camera로부터 받아오는 이미지 
PImage background_sub; //background 제거한 배경파일
PImage CanvasImage;
PImage PriceTag;
PImage user_barcode;
int sliderValue = 39;
String name;
Slider abc;

boolean stop = false; //스페이스바를 누르면 정지 
boolean submit = false;
int sliderheight= 20;
int AGE = 20;
float EDUCATION = 30;
float GRADE = 3.5;
float WEALTH = 40;
float FAMILY_BACKGROUND = 50;
float APPEARANCE = 50;
float PERSONALITY = 50;
float transparency = 100;
float tile = 30;
float envy = 0;
float truth = 0;
float affec = 0;

String price = " ";

void setup() {
  size(800,500,P3D);
  
  cam = new Capture(this, 800,500);
  cam.start();
  
  opencv = new OpenCV(this, 800,500);
  opencv.startBackgroundSubtraction(5, 3, 0.5); //openCV's backgroundSubtraction
  
  oscP5 = new OscP5(this,12000);
  dest = new NetAddress("127.0.0.1",6448);
  BacodePlayer = new SoundFile(this, "Barcode_Sound.mp3");
  
  PriceTag = loadImage("PRICETAG.png");
  
  noStroke();
  
  
  cp5 = new ControlP5(this);
  
     cp5.addTextfield("NAME")
       .setPosition(40,10)
       .setSize(100,20)
       .setColor(color(255))
       .setColorBackground(color(50))
     ;
     
     cp5.addSlider("AGE")
       .setPosition(40, 30+sliderheight)
       .setSize(100, 10)
       .setRange(10,50)
       .setColorCaptionLabel(color(20,20,20))
       .setColorForeground(color(255, 0, 0)) // 슬라이더 전경 색상
       .setColorBackground(color(50));       // 슬라이더 배경 색상
       
     cp5.addSlider("EDUCATION")
       .setPosition(40, 30+sliderheight*2)
       .setSize(100, 10)
       .setRange(0,100)
       .setColorCaptionLabel(color(20,20,20))
       .setColorForeground(color(255, 0, 0)) // 슬라이더 전경 색상
       .setColorBackground(color(50));       // 슬라이더 배경 색상


   cp5.addSlider("GRADE")
       .setPosition(40, 30+sliderheight*3)
       .setSize(100, 10)
       .setRange(0.0,4.5)
       .setColorCaptionLabel(color(20,20,20))
       .setColorForeground(color(255, 0, 0)) // 슬라이더 전경 색상
       .setColorBackground(color(50));       // 슬라이더 배경 색상
       
       
   cp5.addSlider("WEALTH")
       .setPosition(40, 30+sliderheight*4)
       .setSize(100, 10)
       .setRange(0,100)
       .setColorCaptionLabel(color(20,20,20))
       .setColorForeground(color(255, 0, 0)) // 슬라이더 전경 색상
       .setColorBackground(color(50));       // 슬라이더 배경 색상
  
   cp5.addSlider("FAMILY_BACKGROUND") 
       .setPosition(40, 30+sliderheight*5)
       .setSize(100, 10)
       .setRange(0,100)
       .setColorCaptionLabel(color(20,20,20))
       .setColorForeground(color(255, 0, 0)) // 슬라이더 전경 색상
       .setColorBackground(color(50));       // 슬라이더 배경 색상

   cp5.addSlider("APPEARANCE") 
       .setPosition(40, 30+sliderheight*6)
       .setSize(100, 10)
       .setRange(0,100)
       .setColorCaptionLabel(color(20,20,20))
       .setColorForeground(color(255, 0, 0)) // 슬라이더 전경 색상
       .setColorBackground(color(50));       // 슬라이더 배경 색상
       
   cp5.addSlider("PERSONALITY") 
       .setPosition(40, 30+sliderheight*7)
       .setSize(100, 10)
       .setRange(0,100)
       .setColorCaptionLabel(color(20,20,20))
       .setColorForeground(color(255, 0, 0)) // 슬라이더 전경 색상
       .setColorBackground(color(50));       // 슬라이더 배경 색상
       
}

void draw() {
  cam_opencv();
  

  if (submit) {
   
    barcodeClick();
    image(user_barcode,140,240);
    if (mousePressed && mouseButton == LEFT) {
      push();
      rectMode(CENTER);
      fill(255,0,0,40);
      rect(mouseX,mouseY,240,70);
      pop();
      price = nf(transparency*tile,0,2);
      BacodePlayer.play();
    }
    textSize(32);
    text(price,550,293);

  } else {
    drawBarcode();
    sendOsc();
      fill(0);
    name = cp5.get(Textfield.class,"NAME").getText();
  }

}

void drawBarcode() {
  background(255);
  fill(0);
  
  
  //float tile = 150;
  float tileSize = width/tile;
  
  push();
  translate(width/2,height/2);
  
  for (int x = 0;x<tile;x++) {
    for (int y = 0;y<tile;y++) {
      color col = background_sub.get(int(x*tileSize), int(y*tileSize));
      if (brightness(col) > 0) //if bright -> it means human
      fill(cam_img.get(int(x*tileSize), int(y*tileSize)),transparency);
      else fill(255);

      
      push();
      //println(tileSize);
      translate(x*tileSize-width/2, y*tileSize-width/2);
      rect(0+100,0+100,random(1,3),random(15,40));

      pop();
    }
   
    
  }
  pop();
  
  
}

void keyPressed() {
  if (key == ' ') {
  }
  if (key == ENTER) {
    hideAllCP5Components();
    if (!submit) {
      submit = !submit;
      user_barcode = get(300,0,500,500);
      //user_barcode.resize(350,50);
      user_barcode.resize(240,70);
      background(255);
      barcodeClick();

    }
  }
}

void barcodeClick() {
      PriceTag.resize(800,500);
      background(PriceTag);
      fill(0);
      textSize(30);
      
      String totalName = name + "(KOREA)";
      float x = width/2 - 50 - textWidth(totalName)/2; // 텍스트를 중앙에 정렬
      for (int i = 0; i < totalName.length(); i++) {
        text(totalName.charAt(i), x, 130);
        x += textWidth(totalName.charAt(i)) + 10;
      }
      //text(name+"(KOREA)",400,100);
      
      textSize(17);
      text(str(tile),450,220);
      text(str(transparency*10),600,220);
}

void cam_opencv() {
    if (cam.available()) {
    cam.read();
    }
    cam.loadPixels();
    cam_img = cam.get();
    image(cam,0,0,0,0);
    
    fill(0);
    opencv.loadImage(cam_img); //bring camera's image to opencv
    opencv.updateBackground(); //opencv로 Background 제거 
    opencv.dilate(); //highlight
    opencv.erode();
    background_sub = opencv.getOutput(); //save image that substracted background by opencv
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)AGE);
  msg.add(EDUCATION);
  msg.add(GRADE);
  msg.add(WEALTH);
  msg.add(FAMILY_BACKGROUND);
  msg.add(APPEARANCE);
  msg.add(PERSONALITY);
  
  oscP5.send(msg, dest);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/wek/outputs"))
  {
    msg.print();
    affec = msg.get(0).floatValue();
    truth =  msg.get(1).floatValue();
    
    transparency = 100*(1+affec)*(1+truth);
    tile = 30*(1+affec)*(1+truth);
    
    transparency = map(transparency,100,400,50,255);
    tile = map(tile,30,120,10,130);
    
    //println("trans : "+transparency + " tile : "+tile);
    
  } else {
    //msg.print();
  }
}

void hideAllCP5Components() {
  for (Controller c : cp5.getAll(Controller.class)) {
    c.hide(); 
  }
}
