
CellularAutomata caut;
int caSize = 600;
float genSpeed = 6.0;
float counter = 0.0;

float minGenSpeed = 3.0;
float maxGenSpeed = 15.0;

PImage [] digit;

Maxim maxim;
AudioPlayer player1;
AudioPlayer player2;

//.qwe [[elisp:(processing-sketch-run)][Click here to run the CellularPainter]]

void setup()
{
  size(800, 600);

  caut = new CellularAutomata(20, 20);
  caut.setDrawArea(caSize, caSize);
  // Lets draw a glider
                     caut.setCell(4, 1);
                                        caut.setCell(5,2);
  caut.setCell(3,3); caut.setCell(4,3); caut.setCell(5,3);

  digit = loadImages("counter/num-h70-", ".png", 10); // w=41, h=70

  maxim = new Maxim(this);

  player1 = maxim.loadFile("atmos1.wav");
  player1.setLooping(true);
  player1.volume(0.25);
  player1.play();

  player2 = maxim.loadFile("bells.wav");
  player2.setLooping(true);
  player1.volume(0.25);
  player2.play();

  background(0);

  drawSpeed();

  noStroke();
  fill(166, 166, 166);
}

public void draw()
{
  if( ++counter % (60 / (int) genSpeed) == 0) {
    caut.newGeneration();
    caut.draw();

    fill(0);

    // generation
    rect(caSize+2, height-155, width, caSize);

    int gen = caut.getGeneration();
    int mil = floor(gen/1000);
    int cent = floor((gen - mil*1000) / 100);
    int dec = floor((gen - mil*1000 - cent*100) / 10);
    int uni = gen % 10;

    // digit size = 33x56   (* (/ 33.0 41.0) 70.0)
    int margin = 4;  //   (/ (- 200 (+ (* 4 3) (* 33 4))) 2)
    int left = caSize+28;
    int top = height-150;
    tint(180);
    image(digit[mil], left, top, 33, 56);
    image(digit[cent], left+margin+33, top, 33, 56);
    image(digit[dec], left+margin*2+66, top, 33, 56);
    image(digit[uni], left+margin*3+99, top, 33, 56);

    // alive cells
    int alive = caut.getAlive();
    cent = floor(alive/100);
    dec  = floor((alive - cent*100) / 10);
    uni  = alive % 10;

    //.del println("alive=", alive, cent, dec, uni);

    margin = 9;  //   (/ (- 200 (+ (* 9 2) (* 41 3))) 2)
    left = caSize+29;
    top = height-71-margin; 
    tint(0, 99, 0);
    image(digit[cent], left, top);
    image(digit[dec], left+41+margin, top);
    image(digit[uni], left+82+margin*2, top);
    tint(255);
  }
  fill(0, 8);
  rect(0, 0, 600, 600);
}

void drawSpeed()
{
  strokeWeight(2);
  stroke(66,66,200);
  fill(0);
  float radius = 80;
  smooth(8);
  ellipse(caSize+(width-caSize)/2, 10+radius, radius, radius);
  fill(66,66,200);
  float r = map(genSpeed, minGenSpeed, maxGenSpeed, 30.0, 80.0);
  noStroke();
  ellipse(caSize+(width-caSize)/2, 10+radius, r, r);
  stroke(0);
  strokeWeight(2);
  noFill();
  ellipse(caSize+(width-caSize)/2, 10+radius, 30.0, 30.0);
  noStroke();
  smooth(4);
}

void mouseDragged()
{
  if(mouseX <= caSize) { // inside CellularAutomata
    caut.setCellFromMouse();
  }
  else {
    float speed = map((float) mouseX, caSize, width, minGenSpeed, maxGenSpeed);
    genSpeed = constrain(speed, minGenSpeed, maxGenSpeed);
    player2.ramp(1.,1000);
    player2.speed(genSpeed/10.0);
    drawSpeed();
  }
}
