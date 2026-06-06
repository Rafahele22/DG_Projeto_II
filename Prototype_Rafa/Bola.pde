class Bola{
  PVector Pos;
  float vecX, vecY;
  
  Bola(float x, float y){
    Pos = new PVector(x,y);
    
    vecX = 1;
    vecY = 1;
  }
  
  void draw(){
    circle(Pos.x, Pos.y,20);
    update();
  }
  
  void update(){
    if(Pos.x > width + 10 || Pos.x < -10){
      vecX = -(vecX);
    }
    if(Pos.y > height + 10 || Pos.y < -10){
      vecY = -(vecY);
    }
    
    Pos.x= Pos.x + vecX;
    Pos.y= Pos.y + vecY;
    
  }
}
