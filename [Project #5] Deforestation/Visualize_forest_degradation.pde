/**
 *  Data Visualization for Forest degradation
 *  Refer to Daniel_codingtrain
 *
 * if you press spacebar, the earth will be rotate faster
 * if you click mouse, year data increases and object changed
 * by Bohyun Choi 2023
*/


/* we have to set latitude and longitutde
   to make object rotate with sphere in correct location */
float lon = 144.9631; //경도 longitude (width of sphere) : 144.9631 E
float lat = 3; //위도 latitude (height of sphere) : 37.8136 S
float angle = 0;
int year = 1990;
Table forestTable;
PImage earth_img;
float r = 200; //earth radius
PShape texture_earth;
float leave_max=80, leave_min=0, leave_col_level = leave_max/6;
PFont font;
PVector textPosition3D;

void setup(){
  size(700,700,P3D);
  forestTable = loadTable("forest degradation.csv","header");
  earth_img = loadImage("earth.png");
  noStroke();
  texture_earth = createShape(SPHERE,r);
  texture_earth.setTexture(earth_img);
  font = createFont("Lexend-Regular.ttf",50);
  textFont(font);
  textPosition3D = new PVector(0,0,0);
}

void draw() {
  background(239,246,242);
  translate(width/2,height/2); //move to center
  
  rotateY(angle);
  angle += 0.01;
  lights();
  fill(200);
  noStroke();
  //sphere(r);
  shape(texture_earth);
  
  //text
  float screenXPos = screenX(textPosition3D.x, textPosition3D.y, textPosition3D.z);
  float screenYPos = screenY(textPosition3D.x, textPosition3D.y, textPosition3D.z);
  
  fill(0);
  text(str(year),screenXPos,screenYPos);
  
  
  for (TableRow row : forestTable.rows()) {
    float lat = row.getFloat("Latitude");
    float lon = row.getFloat("Longitude");
    float forest = row.getFloat(str(year));
    
    float theta = radians(lat) + PI/2;
    float phi = radians(lon) + PI;
    float x = r * sin(theta) * cos(phi);
    float y = r  * sin(theta) * sin(phi);
    float z = r * cos(theta);
    float h = RangeofH(forest);
    PVector pos = new PVector(x,y,z);
    
    PVector xaxis = new PVector(1,0,0);
    float angleb = PVector.angleBetween(xaxis,pos);
    PVector raxis = xaxis.cross(pos);
    
    pushMatrix();
    translate(x,y,z);
    rotate(angleb,raxis.x,raxis.y,raxis.z);
    fill(189,171,152);
    box(h,6,6);
    translate(h/2,0,0);
   
    float leaves = h/5;
    leaves = RangeofLeaves(leaves);
    if (leaves>=(leave_col_level*5)) fill(39,78,19);
    else if (leaves>=(leave_col_level*4)) fill(56,118,29);
    else if (leaves >=(leave_col_level*3)) fill(106,168,79);
    else if (leaves >=(leave_col_level*2)) fill(147,196,125);
    else if (leaves>=leave_col_level) fill(182,215,168);
    else fill(217,234,211);
    
    sphere(leaves/2);
    popMatrix();
    if (keyPressed && key == ' ') angle += 0.05;
  }
}

void mousePressed() {
  year++;
  if (year >= 2022) year = 1990;
}

float RangeofH(float h){
  if (!Float.isNaN(h))
    h = map(h, 0, 90, 0, 100);
  return h;
}

float RangeofLeaves(float l){
  if (!Float.isNaN(l))
    l = map(l,0,25,leave_min,leave_max);
  return l;
}
