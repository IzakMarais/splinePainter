
class SplineWalker
{  

  //bezier curve points
  PVector p1;
  PVector p2;
  PVector p3;
  PVector p4;

  float t = 0;
  float tInc = 0.005;

  //location points
  float x;
  float y;
  //prev values for x and y
  float px;
  float py;

  boolean active;

  IBrush brush;    
  HarpPlayer harp;
  float harpStartTime;
  boolean hasPluckedString;

  SplineWalker(HarpPlayer _harp)
  {   
    harp = _harp;
    active = false;
  }

  void startWalking(int xPos, int yPos, PVector direction, float avgLength, IBrush newBrush)
  {    
    t = 0;
    active = true;

    hasPluckedString = false;
    harpStartTime = random(0, 1);

    direction.normalize();
    direction.mult(avgLength);

    brush = newBrush;

    p1 = new PVector(xPos, yPos);

    x = p1.x;
    y = p1.y;
    px = p1.x;   
    py = p1.y;

    p2 = PVector.add(p1, PVector.mult(direction, random(0.2, 0.8)));

    PVector p3Dir = new PVector(direction.x, direction.y);
    p3Dir.rotate(HALF_PI*(random(-0.7, 0.7)));

    p3 = PVector.add(p1, p3Dir);

    p3Dir.lerp(direction, random(0, 1));

    p4 = PVector.add(p1, PVector.mult(p3Dir, random(1.2, 1.7)));
  }

  void draw()
  {    
    if (active)
    {     
      updateWalk();
      pluckHarp();
      brush.draw(int(x), int(y), int(px), int(py), t);
    }
  }

  void updateWalk()
  {
    px = x;
    py = y;
    x = bezierPoint(p1.x, p2.x, p3.x, p4.x, t);
    y = bezierPoint(p1.y, p2.y, p3.y, p4.y, t);     

    t += tInc;

    if (t > 1)
    {
      active = false;
    }
  }  

  void pluckHarp()
  {
    if (t > harpStartTime && !hasPluckedString)
    {
      harp.pluckString(map(t, 0, 1, 0.5, 1));
      hasPluckedString = true;
    }
  }
}

