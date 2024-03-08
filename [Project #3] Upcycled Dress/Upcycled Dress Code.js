//https://editor.p5js.org/bohyuneeee/sketches/0lJP2814b

/**
 *  Upcylced Dress
 *
 *  Making dress by collage of fabric images of old clothes.
 *  Press Mouse Left Up -> square collage
 *              Left Down -> sprial collage
 *              Right Up -> line collage
 *              Right Up -> circular collage
 *
 *  Using createGrapics and image.mask() function
 *
 *  by Bohyun Choi 2023
 **/

let img=null, maskImage;
let luCanvas, ruCanvas, ldCanvas;
let cloth = [];
let mouse_point = "LU"; //mouse pointer 'Left Up'
let tileSize = 50; //turning tile Size
let portionX, portionY, portion;

function preload() {
  for (let i = 0; i < 17; i++)
    cloth[i] = loadImage("asset/" + str(i + 1) + ".png");

  maskImage = loadImage("DressMask.png");
  Model = loadImage("Model.png");
  DressLine = loadImage("DressLine.png");

  // ***** FONT *******
  font = loadFont("Font/Vogue.ttf");
}


function setup() {
  createCanvas(600, 800);
  luCanvas = createGraphics(600, 800);
  ruCanvas = createGraphics(600, 800);
  ldCanvas = createGraphics(600, 800);
  rdCanvas = createGraphics(600, 800);
  noLoop();
}


function draw() {
  background(0);
  imageMode(CENTER);
  maskImage = resizeImage(maskImage, 600, 800);
  
  luCanvas.imageMode(CENTER);
  for (let j = 0; j < 300; j++) {
    let i = int(random(0, 17));
    let temp = cloth[i].get(0,random(50, 100),random(50, 100),random(50, 100));
    luCanvas.image(temp, random(0, 800), random(0, 800));
  }
  img = luCanvas.get();
  
  let angle, radius=0;
  
  switch (mouse_point) {
    case "LU":
      luCanvas.imageMode(CENTER);
      for (let j = 0; j < 500; j++) {
        let i = int(random(0, 10));
        let temp = cloth[i].get(0,random(10,50),random(10,50),random(10,50));
        luCanvas.image(temp, random(0, 600), random(0, 800));
      }
      img = luCanvas.get();
      break; 
      
    case "LD":
      let radius = 10;
      let angle = 0; //changes overtime rotating
      while (radius < width/2-50)
      {
        portionX = int(random(0,img.width-tileSize));
        portionY = int(random(0,img.height-tileSize));
        portion = img.get(portionX, portionY, tileSize, tileSize);
      
        ldCanvas.push();
        ldCanvas.translate(width/2,height/2);
        ldCanvas.rotate(angle);
        ldCanvas.translate(radius,0);
        ldCanvas.rotate(random(0,TWO_PI));
        ldCanvas.image(portion,0,0);
        ldCanvas.pop();
        
        angle += radians(6);
        radius += 0.5;
      }
      img = ldCanvas.get();
      break;
    
    case "RU":
      
      for (let y = 0; y < height; y += 10) {
        let stripYPosition = int(random(0, img.height - 10));
        let strip = img.get(0, stripYPosition, img.width, random(1, 20));
        ruCanvas.image(strip, 0, y);
      }
      img = ruCanvas.get();
      break;
      
    case "RD":
      let radius_ = 10;
      let angle_ = 0; //changes overtime rotating
      while (radius_ < width/2-50)
      {
        tileSize = random(10,80);
        portionX = int(random(0,img.width-tileSize));
        portionY = int(random(0,img.height-tileSize));
        portion = img.get(portionX, portionY, tileSize, tileSize);
      
        rdCanvas.push();
        rdCanvas.translate(width/2,height/2);
        rdCanvas.rotate(angle_);
        rdCanvas.translate(radius_,0);
        rdCanvas.image(portion,0,0);
        rdCanvas.pop();
        
        angle_ += radians(8);
        radius_ += 0.3;
      }
      img = rdCanvas.get();
      break;      
      
  }


  // **********COLLAGUE**********///
  img.mask(maskImage);
  image(img, width / 2, height / 2);


  // ******* TEXT ******** //
  fill(255,255,255,200);
  textSize(130);
  textFont(font);
  textAlign(CENTER);
  text("FASHION", width / 2, 130);
  
  fill(255);
  textSize(20);
  text("pursue environmentally conscious fashion", width / 2, 170);



  textSize(15);
  text("2023, SOGANG", width / 2, height - 50);
  textSize(8);
  text("Designed by Bohyun", width / 2, height - 35);
  
  // *******Model****//
  fill(0);
  ellipseMode(CENTER);
  ellipse(width/2+10,150,130);
  

  
  image(Model, width / 2, height / 2);
  image(Model, width / 2, height / 2);
  image(DressLine, width / 2, height / 2);
}

function resizeImage(img, width, height) {
  let newImage = createImage(width, height);
  newImage.copy(img, 0, 0, img.width, img.height, 0, 0, width, height);
  return newImage;
}

function mouseClicked() {
  if (mouseX < width / 2 && mouseY < height/2) mouse_point = "LU";
  else if (mouseX < width / 2 && mouseY >= height/2) mouse_point = "LD";
  else if (mouseX >= width / 2 && mouseY >= height/2) mouse_point = "RD";
  else mouse_point = "RU";
  
  redraw();
}
