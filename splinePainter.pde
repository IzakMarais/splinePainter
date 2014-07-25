int noWalkers = 1000;
int size = 700;
int minSplineLength = size/50;
int maxSplineLength = size/5;
int numBrushes = 7;
float rotation = PI/8;

int TRIANGLE_SCALE = 0;
int RAMP_SCALE = 1;


int currentBrushCombo;
int numSymmetry;
int circleBrushSize;
int scaleType;

Maxim maxim;
HarpPlayer harp; 

SplineWalker[] sw = new SplineWalker[noWalkers];
ChainedBrush prevBrush;
PVector splineDir;
int newSplineCounter;

color backGroundColor;
color stokeColor;

void setup()
{  
  size(size, size);  
  noStroke();  
  noFill();
  //frameRate(30);
  rectMode(CENTER);
  colorMode(HSB);

  maxim = new Maxim(this);
  harp = new HarpPlayer();

  for (int i = 0; i < noWalkers; i++)
  {
    sw[i] = new SplineWalker(harp);
  }

  splineDir = PVector.random2D();
  newSplineCounter = 0;

  currentBrushCombo = getRandomBrush();
  numSymmetry = getRandomSymmetryCount();
  circleBrushSize = getRandomCircleBrushSize();
  
  backGroundColor = color(255);
  stokeColor = color(0);
  
  background(backGroundColor);   
}

void draw()
{      
  for (int i = 0; i < noWalkers; i++)
  {
    if (sw[i].active)
    {      
      stroke(red(stokeColor), green(stokeColor), blue(stokeColor), mapAlpha(sw[i].t));     
      sw[i].draw();
    }
  }
}



void mouseDragged()
{
  float speed = dist(pmouseX, pmouseY, mouseX, mouseY);

  if (speed>2)
  {
    PVector mouseDir = new PVector(mouseX-pmouseX, mouseY-pmouseY);

    splineDir = mouseDir;
  } else
  {
    splineDir.rotate(random(0, rotation));
  }

  float splineLength = map(speed, 0, 10, minSplineLength, maxSplineLength);

  switch(currentBrushCombo) {
  case 0: 
    ChainedBrush curBrush = new ChainedBrush(prevBrush);
    prevBrush = curBrush;
    sw[newSplineCounter].startWalking(mouseX, mouseY, splineDir, splineLength, new CircleSymmetryBrush(curBrush, numSymmetry));
    break;
  case 1: 
    sw[newSplineCounter].startWalking(mouseX, mouseY, splineDir, splineLength, new CircleSymmetryBrush(new ScaleBrush(new CircleBrush(5), scaleType), numSymmetry));
    break;
  case 2:
    sw[newSplineCounter].startWalking(mouseX, mouseY, splineDir, splineLength, new CircleSymmetryBrush(new ScaleBrush(new CircleBrush(speed*5), scaleType), numSymmetry));
    break;
  case 3:
    sw[newSplineCounter].startWalking(mouseX, mouseY, splineDir, splineLength, new CircleSymmetryBrush(new ConnectPrevLocationLineBrush(), numSymmetry));
    break;
  case 4:
    sw[newSplineCounter].startWalking(mouseX, mouseY, splineDir, splineLength, new CircleSymmetryBrush(new SquareBrush(speed*5), numSymmetry));
    break;
  case 5:
    sw[newSplineCounter].startWalking(mouseX, mouseY, splineDir, splineLength, new CircleSymmetryBrush(new ScaleBrush(new SquareBrush(speed*5), scaleType), numSymmetry));
    break;
  case 6:
    sw[newSplineCounter].startWalking(mouseX, mouseY, splineDir, splineLength, new CircleSymmetryBrush(new ScaleBrush(new SplatterBrush(speed*10), RAMP_SCALE), numSymmetry));
    break;
  default:
    print("ERROR currentBrushCombo out of range");
  }

  newSplineCounter+=1;
  if (newSplineCounter >= noWalkers)
  {
    newSplineCounter = 0;
  }
}

void mousePressed()
{
  harp.setSpeed(random(0.5, 2));
  if (mouseButton == CENTER)
  {
    backGroundColor = color(random(255), random(0,150),random(125,255));
    stokeColor = getInverseColor(backGroundColor);
  }
  
  if (mouseButton == RIGHT || mouseButton == CENTER)
  {
    background(backGroundColor); 
    
    currentBrushCombo = getRandomBrush();
    numSymmetry = getRandomSymmetryCount();
    circleBrushSize = getRandomCircleBrushSize();
    scaleType = getRandomScaleType();
  }
  
}

float mapAlpha(float t)
{
  float baseAplha = 20;
  if (t<0.75)
    return map(t, 0, 0.75, baseAplha/20.0, baseAplha);   

  return map(t, 0.75, 1, baseAplha, 1);
}

void keyPressed()
{
  if (key == 's')
  {
    saveFrame();
  }  
}

int getRandomBrush()
{
  return int(random(0, numBrushes));
  //return 6;
}

int getRandomSymmetryCount()
{
  return int(random(1, 10));
}

int getRandomCircleBrushSize()
{
  return int(random(3, 15));
}

int getRandomScaleType()
{
  if (random(2) > 1)
    return RAMP_SCALE;
  else
    return TRIANGLE_SCALE;
}

color getInverseColor(color in)
{
  return color(255-red(in), 255-green(in), 255-blue(in));
}

