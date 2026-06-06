int w = 350;
int h = 24;

ArrayList <Bola> bolas = new ArrayList <Bola> ();


void setup(){
  size(350*4, 24*4);
}

void draw(){
  background(255);
  
  for (int i = 0; i < bolas.size(); i++) {
    Bola unit = bolas.get(i);
    unit.draw();
  }
}

void novaBola(){
  bolas.add(new Bola(0,0));
}

void keyPressed(){
   if (keyPressed == true) {
   novaBola();
   }
}
