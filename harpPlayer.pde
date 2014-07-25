
int numPlayers = 45;

class HarpPlayer
{
  float speed;
  AudioPlayer[] players = new AudioPlayer[numPlayers];
  HarpPlayer()
  {  
    speed = 1.0;
    String [] names = new String[6];
    names[0] = new String("harp-g4.wav");
    names[1] = new String("harp-c4.wav");
    names[2] = new String("harp-c6.wav");
    names[3] = new String("harp-g5.wav");
    names[4] = new String("harp-d5.wav");
    names[5] = new String("harp-e4.wav");
    
    for (int i = 0; i<numPlayers; i++)
    {
      players[i] = maxim.loadFile(names[i%6]);
      players[i].setLooping(false);
    }
  }
  
  void setSpeed(float s)
  {
    speed = s;
  }
  
  void pluckString(float vol)
  {
     for (int i = 0; i<numPlayers*2; i++)
    {
      int randomIndex = (int) random(0,numPlayers);
      if (!players[randomIndex].isPlaying())
      {
        players[randomIndex].volume(vol);
        players[randomIndex].speed(speed);
        players[randomIndex].play();
        break;
      }
    }
  }
}
