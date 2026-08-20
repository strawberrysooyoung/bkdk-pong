import processing.serial.*;
Serial myPort;
float bk;
float dk;
float x;
float y;
float xspeed;
float negativetwo = -2;
float positivetwo = 2;
float yspeed;
PFont f;
int bkpoint = 0;
int dkpoint = 0;
float radius = 5;

void setup(){
  size(600, 600);
  background(255);
  f = loadFont("CooperBlack-48.vlw");
  // switch COM5 to the correct port
  myPort = new Serial(this, "COM5", 9600);
  myPort.bufferUntil('\n');
  x = width/2;
  y = height/2;
}

void draw(){
  background(255);
  // when dk is winning, secret msg appears + background becomes green
  if (dkpoint > bkpoint){
    background(179, 230, 192);
    textFont(f, 20);
    fill(255, 160, 77);
    text("Izuku, can I still catch up to you?", 125, 150);
  }
  // when bk is winning, background becomes orange
  if (bkpoint > dkpoint){
    background(252, 189, 134);
  }
  // when points equal
  if (bkpoint == dkpoint){
    // background becomes white
  }
  // left paddle (bk)
  fill(255, 160, 77);
  rect(0, bk, 10, 50);
  // right paddle (dk)
  fill(103, 163, 91);
  rect(590, dk, 10, 50);
  // draw ball
  fill(x, 0, y);
  ellipse(x, y, radius * 2, radius * 2);
  // move ball
  x = x + xspeed;
  y = y + yspeed;
  
  // --- COLLISION LOGIC FOR LEFT PADDLE (BK) ---
  float closestLeftX = constrain(x, 0, 10);
  float closestLeftY = constrain(y, bk, bk + 50);
  float distLeftSq = sq(x - closestLeftX) + sq(y - closestLeftY);
  
  if (distLeftSq < sq(radius) && xspeed < 0) { // Only bounce if moving left
    xspeed *= -1.05;
    x = 10 + radius; // Displace ball outside paddle to prevent sticking
  }
  
  // --- COLLISION LOGIC FOR RIGHT PADDLE (DK) ---
  float closestRightX = constrain(x, 590, 600);
  float closestRightY = constrain(y, dk, dk + 50);
  float distRightSq = sq(x - closestRightX) + sq(y - closestRightY);
  
  if (distRightSq < sq(radius) && xspeed > 0) { // Only bounce if moving right
    xspeed *= -1.05;
    x = 590 - radius; // Displace ball outside paddle to prevent sticking
  }

  // Goal: Right wall (BK Scores)
  if (x > width){
    bkpoint += 1;
    resetBall();
  }
  
  // Goal: Left wall (DK Scores)
  if (x < 0){
    dkpoint += 1;
    resetBall();
  }
  
  // Top and Bottom Walls
  if (y > height || y < 0){
    yspeed *= -1;
  }
  
  // Scores Display
  textFont(f, 60);
  fill(0);
  text(bkpoint, 100, 100);
  text(dkpoint, 450, 100);
}

// Reusable ball reset function
void resetBall() {
  xspeed = (random(1) < 0.5) ? negativetwo : positivetwo;
  yspeed = (random(1) < 0.5) ? negativetwo : positivetwo;
  x = width/2;
  y = height/2;
  delay(1000); // Keeps your original point delay
}

void serialEvent(Serial port) {
  String inputString = port.readStringUntil('\n');
  if (inputString == null) return;
  
  inputString = trim(inputString);
  String receiveddata[] = split(inputString, ' ');
  
  if (receiveddata.length >= 2 && receiveddata[0] != null && receiveddata[1] != null){
    float bk4 = float(receiveddata[1]);
    float dk1 = float(receiveddata[0]);
    bk = map(bk4, 0, 1023, -75, 600);
    dk = map(dk1, 0, 1023, -100, 600);
  }
}

void mousePressed(){
  xspeed = (random(1) < 0.5) ? negativetwo : positivetwo;
  yspeed = (random(1) < 0.5) ? negativetwo : positivetwo;
}
