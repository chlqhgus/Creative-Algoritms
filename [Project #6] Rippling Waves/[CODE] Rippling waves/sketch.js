/** Rippling waves
 *
 * Refer to Daniel Shiffman_codingtrain
 * if you press spacebar, color of particle will be changed
 * if you click mouse, particles will move to other way
 * Change inc, scl value for make diffrent patterns!
 *
 * by Bohyun Choi 2023
*/


let r_val = 61;
let g_val = 133;
let b_val = 198;

// change inc, scl to (0.1,10),(1,100) or else
var inc = 0.1;  
var scl = 10;
var cols, rows;
let rand=1;
var zoff = 0;


var particles = [];
var particles2 = [];

var flowfield;

function setup() {

  createCanvas(1000, 800);
  cols = floor(width / scl);
  rows = floor(height / scl);
  fr = createP('');

  flowfield = new Array(cols * rows);

  for (var i = 0; i < 10000; i++) {
    particles[i] = new Particle();
  }
  
  for (i = 0; i < 10000; i++) {
    particles2[i] = new Particle();
  }

  background(30);
  
}

function draw() {
  frameRate(40);
  var yoff = 0;
  for (var y = 0; y < rows; y++) {
    var xoff = 0;
    for (var x = 0; x < cols; x++) {
      var index = x + y * cols;
      var angle = noise(xoff, yoff, zoff) * TWO_PI * rand ;
      
      //each vector's angle angle from x-axis
      //if you change PI value to something, the particle's movement gonna be diffrent
      
      var v = p5.Vector.fromAngle(angle);
      v.setMag(1);
      flowfield[index] = v;
      
      // var v2 = p5.Vector.fromAngle(sin(rows) * cos(cols));
//       var v2 = p5.Vector.fromAngle(cols/2-x, rows/2-y, 0);
//       v2.add(v);
//       v2.setMag(1);

//       flowfield[index] = v2;
      xoff += inc;
      
    }
    yoff += inc;

    zoff += 0.0002;
  }

  for (var i = 0; i < particles.length; i++) {
    
    particles[i].follow(flowfield);
    particles[i].update();
    particles[i].edges();
    particles[i].show(r_val,g_val,b_val);
    
    particles2[i].follow(flowfield);
    particles2[i].update();
    particles2[i].edges();
    particles2[i].show2();
  }
}


function mouseClicked() {
  rand += 1;
  if (rand == 5) rand=1;
}

function keyPressed() {
  if (key === ' '){
    r_val -= 10;
    g_val -= 10;
    b_val -= 10;

  }

}