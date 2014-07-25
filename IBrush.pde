interface IBrush
{
  void draw(int x, int y, int px, int py, float t);
}


class ConnectPrevLocationLineBrush implements IBrush
{ 
  void draw(int x, int y, int px, int py, float t)
  {    
    line(px, py, x, y);
  }
}


class ChainedBrush implements IBrush
{
  int x;
  int y;
  int px;
  int py;
  
  ChainedBrush neighbour;

  ChainedBrush(ChainedBrush other)
  {
    neighbour = other;
  }

  void draw(int _x, int _y, int _px, int _py, float t)
  {
    if (neighbour != null)
    {      
      quad(px, py, x, y, neighbour.x, neighbour.y, neighbour.px, neighbour.py);
      x = _x;
      y= _y;
      px = _px;
      py = _py;
    }
  }
}


class CircleBrush implements IBrush
{
  float size;

  CircleBrush(float s)
  {
    size= s;
  }

  void draw(int x, int y, int px, int py, float t)
  {
    ellipse(x, y, size, size);
  }
}

class SquareBrush implements IBrush
{
  float size;

  SquareBrush(float s)
  {
    size= s;
  }

  void draw(int x, int y, int px, int py, float t)
  {
    rect(x, y, size, size);
  }
}

class SplatterBrush implements IBrush
{
  PVector[] points;
  int NUMBER_POINTS = 5;
  
  SplatterBrush(float size)
  {
    points = new PVector[NUMBER_POINTS];
    
    for (int i = 0; i< NUMBER_POINTS; i++)
    {
      points[i] = PVector.random2D();
      points[i].mult(size);
    }
  }
  
  void draw(int x, int y, int px, int py, float t)
  {    
    for (int i = 0; i< NUMBER_POINTS; i++)
    {
      line(points[i].x+px, points[i].y+py, points[i].x+x, points[i].y+y);     
    }      
  }
}


class CircleSymmetryBrush implements IBrush
{
  int angularReps;  
  IBrush brush;

  CircleSymmetryBrush(IBrush _brush, int numAngularReps)
  {
    angularReps = numAngularReps;   
    brush = _brush;
  }

  void draw(int x, int y, int px, int py, float t)
  {
    float angleInc = PI/(float(angularReps)/2.0);
    int xCentre = width/2;
    int yCentre = height/2;

    int xOff = x-xCentre;
    int yOff = y-yCentre;
    int pxOff = px-xCentre;
    int pyOff = py-yCentre;

    for (int i = 0; i < angularReps; i++)
    {
      pushMatrix();
      translate(xCentre, yCentre);
      rotate(angleInc*i);            
      brush.draw(xOff, yOff, pxOff, pyOff, t);
      popMatrix();
    }
  }
}


class ScaleBrush implements IBrush
{
  IBrush brush;  
  int scaleMethod;

  //method = {1,2}
  ScaleBrush(IBrush toScale, int method)
  {
    brush = toScale;
    scaleMethod = method;
  }

  void draw(int x, int y, int px, int py, float t)
  {
    pushMatrix();   
    translate(x, y);
    scale(mapT(t));
    brush.draw(0, 0, px-x, py-y, t);
    popMatrix();
  }
  
  float mapT(float t)
  {
    if (scaleMethod == 0)   
      return mapTTriangle(t);
    else
      return mapTRamp(t);   
  }

  float mapTTriangle(float t)
  {
    if (t<0.7)
      return map(t, 0, 0.7, 0, 1);

    return map(t, 0.7, 1, 1, 0);
  }
  
  float mapTRamp(float t)
  {
    return map(t, 0, 1, 1, 0);
  }
}

