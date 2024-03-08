/*
 *  Barcode Player
 *
 *  Making sound by barcode scanner! It will become a kind of instruments.
 *  If user's mouse going to right, the barcode will be create densely.
 *  If press 'space bar', you can stop with a barcode at a certain point in time.
 
 *  click/drag your mouse to create a sound!
 *  The sound will vary depending on the type(shape) of barcode.
 *
 *  by Bohyun Choi, 2023
*/


import processing.sound.*;

SoundFile BacodePlayer;
FFT fft;
Reverb reverb;
Delay delay;

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;
SqrOsc sqrOsc; // SqrOsc 추가
SinOsc sine;

PImage img_load;
PImage CanvasImage; // 이미지를 저장할 변수
boolean barcode;
float point;
float pointSize;
float width_size;

float left_width;
float right_width;
float up_width;
float down_width;
color c;

float pitch=1;
float amp=1;

void setup()
{
  size(700,700);
  img_load = loadImage("angel.png");
  img_load.resize(700,700);
  
  BacodePlayer = new SoundFile(this, "Barcode_Sound.mp3");
  
  rectMode(CENTER);
  barcode = true;
  CanvasImage = createImage(width, height, RGB);
  
  oscP5 = new OscP5(this,12000);
  dest = new NetAddress("127.0.0.1",6448);
  reverb = new Reverb(this);
  reverb.process(BacodePlayer);
  
  delay = new Delay(this);
  delay.process(BacodePlayer, 0.8, 0.7);
  delay.time(2);
}

void draw() {
  
  if (barcode)
  {
    background(255);
    fill(0);
    noStroke();
    
    point = mouseX/random(3,10);
    pointSize = width/point;
    
    translate(pointSize/2,pointSize /2);
    
    for (int i=0;i<point;i++) 
    {
      for (int j=0;j<point;j++)
      {
        c = img_load.get(int(i*pointSize),int(j*pointSize)); //return image color val by array
        width_size = map(brightness(c),0,255,random(1,6),0);
        rect(i*pointSize,j*pointSize,width_size,width_size*7);
      }
    }
  }
  
  if (mousePressed && mouseButton == LEFT) {
    println("pitch : "+pitch+" rate : "+amp);
    BacodePlayer.rate(pitch);
    BacodePlayer.amp(amp);
    BacodePlayer.play();
    //player.loop();
    if (!barcode){
      background(255);
      image(CanvasImage, 0, 0);
    }
    fill(255,0,0,40);
    rect(mouseX,mouseY, 130,15);
  }
  
  color mousecol = get(mouseX, mouseY); //get current mousepoint's color val
  color mousecol_left = get(mouseX-5,mouseY);
  color mousecol_right = get(mouseX+5,mouseY);
  color mousecol_up = get(mouseX,mouseY-30);
  color mousecol_down = get(mouseX,mouseY+30);
  
  left_width = (red(mousecol)+green(mousecol)+blue(mousecol))
  -(red(mousecol_left)+green(mousecol_left)+blue(mousecol_left));
  
  right_width = (red(mousecol)+green(mousecol)+blue(mousecol))
  -(red(mousecol_right)+green(mousecol_right)+blue(mousecol_right));
  
  up_width = (red(mousecol)+green(mousecol)+blue(mousecol))
  -(red(mousecol_up)+green(mousecol_up)+blue(mousecol_up));
  
  down_width = (red(mousecol)+green(mousecol)+blue(mousecol))
  -(red(mousecol_down)+green(mousecol_down)+blue(mousecol_down));
 
  //only play sound when pressing left mouse button
  sendOsc();
}

void keyPressed() {
  if (key == ' ') {
    println("Making barcode stopped");
    saveFrame("Canvas.png");
    //use saveFrame to save current Canva's graphics
    CanvasImage = loadImage("Canvas.png");  
    barcode = !barcode;
  }

}

void mouseReleased() {
  if (BacodePlayer != null) {
    if (BacodePlayer.isPlaying()) {
      BacodePlayer.cue(0);
      BacodePlayer.stop();
    }
  }
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)left_width); 
  msg.add((float)right_width);
  msg.add((float)up_width);
  msg.add((float)down_width);
  msg.add((float)get(mouseX,mouseY));
  oscP5.send(msg, dest);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/wek/outputs"))
  {
    msg.print();
    float receive_pitch = msg.get(0).floatValue();
    float receive_amp = msg.get(1).floatValue();
    
    pitch = map(receive_pitch,0,1,0.01,1);
    amp = receive_amp*0.7;

  } else {
    //msg.print();
  }
}
