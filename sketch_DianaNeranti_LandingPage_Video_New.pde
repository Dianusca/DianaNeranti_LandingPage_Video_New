import processing.video.*;
import gab.opencv.*;

import milchreis.imageprocessing.*;

Movie dancem;
OpenCV opencv;

PFont font;
String message = "Diana Neranti";
// An array of Letter objects


color c1 = #00ffc2;/*#ff003d; #39ff14;*/
color c2 = #ff0893;
color c3 = #08ffee;
color c4 = #2808ff;
color c5;


// Mechanism
ArrayList<PVector> poop = new ArrayList();
int R = 50;
int k=0;
float N = 4;
float m=0;
float minX=720;
float minY=720;
float maxX=0;
float maxY=0;

float boxX;
float boxY;
float boxWidth;
float boxHeight;

String textMouse;

// Dimensions for the Sketch: 1280 x 720 -  original video
static final int sketchWidth = 1280;
static final int sketchHeight = 720;

int stringLogoX = 50;
int stringLogoY = 180;
int fontLogoSize = 18;

boolean frozen = false;

void setup() {

  size(1280, 720);
  textAlign(CENTER);

  dancem = new Movie(this, "DD_Fluid_Reverse-Vimeo 720p Upload.mov");
  opencv = new OpenCV(this, sketchWidth, sketchHeight);
  opencv.startBackgroundSubtraction(5, 3, 0.5);

  dancem.loop();

  font = createFont("DINPro-Regular-48", 48);
  textFont(font);
}

void movieEvent(Movie m) {  
  m.read();
}

void draw() {

  image(dancem, 0, 0, dancem.width, dancem.height);

  int intensity = (int) map(mouseY, 0, height, 0, 1.5);
  image(Glitch.apply(dancem, intensity), 0, 0);

  // initialize the min and max
  maxX = maxY = 0;
  minX = minY = 720;

  // motion tracking
  opencv.loadImage(dancem);
  opencv.updateBackground();
  opencv.dilate();
  opencv.erode();

  noFill();
  stroke(c1);
  strokeWeight(2);
  int c = 0;
  for (Contour contour : opencv.findContours()) {
    //contour.draw();

    float boxX = (float)(contour.getBoundingBox().getX());
    float boxY = (float)(contour.getBoundingBox().getY());
    float boxWidth = (float)(contour.getBoundingBox().getWidth());
    float boxHeight = (float)(contour.getBoundingBox().getHeight());
    //noFill();
    c++;
    colorMode(HSB);
    c5 = color(random(0, c+100), int(saturation(c1)),int(brightness(c1)));
    fill(c5, 100);
    //tint(c5, 100);
    
    rect(boxX, 
      boxY, 
      boxWidth, 
      boxHeight);

    if (minX > boxX) minX = boxX;
    if (maxX < boxX) maxX = boxX;
    if (minY > boxY) minY = boxY;
    if (maxY < boxY) maxY = boxY;


    if (frozen) {
      fill(c1);
      textSize(14);
      text("▲ Hold", boxX+boxWidth/2, boxY+boxHeight/2);
    }
  }

  // value or string on the cursor  
  N = map(maxX, 0, width, 4, 10);
  m = map(maxY, 0, height, -1, 1);

  fill(0);

  //saveFrame("./video/frame_#####.png");
}

void mousePressed() {
  dancem.pause();
  frozen = true;
}

void mouseReleased() {  
  dancem.play();
  frozen = false;
}