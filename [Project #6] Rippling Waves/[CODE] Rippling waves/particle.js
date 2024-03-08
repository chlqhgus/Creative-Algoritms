//using Daniel Shiffman's code


class Particle {
  constructor() {
    this.posit = createVector(random(width), random(height));
    this.veloc = createVector(0, 0);
    this.acc = createVector(0, 0);
    this.maxspeed = 4;
    this.prevPos = this.posit.copy();
  }

  update() {
    this.veloc.add(this.acc);
    this.veloc.limit(this.maxspeed);
    this.posit.add(this.veloc);
    this.acc.mult(0);
  }

  follow(vectors) {
    var x = floor(this.posit.x / scl);
    var y = floor(this.posit.y / scl);
    var index = x + y * cols;
    var force = vectors[index];
    this.applyForce(force);
  }

  applyForce(force) {
    this.acc.add(force);
  }
  
  show(r,g,b) {
    stroke(r,g,b,10);
    strokeWeight(1);
    line(this.posit.x, this.posit.y, this.prevPos.x, this.prevPos.y);
    this.updatePrev();
  }
  
  show2() {
    stroke(255,5);
    strokeWeight(1);
    line(this.posit.x, this.posit.y, this.prevPos.x, this.prevPos.y);
    this.updatePrev();
  }

  show3() {
    stroke(11,83,148,10);
    strokeWeight(2);
    line(this.posit.x, this.posit.y, this.prevPos.x, this.prevPos.y);
    this.updatePrev();
  }

  updatePrev() {
    this.prevPos.x = this.posit.x;
    this.prevPos.y = this.posit.y;
  }

  edges() {
    if (this.posit.x > width) {
      this.posit.x = 0;
      this.updatePrev();
    }
    if (this.posit.x < 0) {
      this.posit.x = width;
      this.updatePrev();
    }
    if (this.posit.y > height) {
      this.posit.y = 0;
      this.updatePrev();
    }
    if (this.posit.y < 0) {
      this.posit.y = height;
      this.updatePrev();
    }

  }

}