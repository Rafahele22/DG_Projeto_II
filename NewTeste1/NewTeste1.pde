int canvasWidth = 350;
int canvasHeight = 24;
int escalaJanela = 1;

int tamanhoPixel = 1;
float espacamento = 1.2;
boolean pinturaSempreLigada = true;
Letra[] palavra;
Efeitos efeitos;
PGraphics canvas;
Tx tx;

void settings() {
  float scaling = 10;
  while (canvasWidth * scaling > displayWidth || canvasHeight * scaling > displayHeight) {
    scaling--;
  }
  if (scaling < 1) {
    scaling = 1;
  }
  escalaJanela = int(scaling);
  size(canvasWidth * escalaJanela, canvasHeight * escalaJanela);
  pixelDensity(1);
  noSmooth();
}

void setup(){
  frameRate(30);
  canvas = createGraphics(canvasWidth, canvasHeight);
  tx = new Tx(canvasWidth, canvasHeight);
  palavra = new Letra[]{
    new LetraC(),
    new LetraH(),
    new LetraO(),
    new LetraO(),
    new LetraS(),
    new LetraE(),
    new Espaco(),
    new LetraL(),
    new LetraO(),
    new LetraV(),
    new LetraE(),
    new Espaco(),
    new LetraA(),
    new LetraL(),
    new LetraW(),
    new LetraA(),
    new LetraY(),
    new LetraS(),
    new Ponto()
  };
  efeitos = new Efeitos(canvas, tamanhoPixel, espacamento, palavra, pinturaSempreLigada);
}

void draw(){
  canvas.beginDraw();
  canvas.noStroke();
  efeitos.desenhar();
  canvas.endDraw();
  image(canvas, 0, 0, width, height);
  tx.send(canvas);
}

void mousePressed() {
  int mx = int(map(mouseX, 0, width, 0, canvasWidth));
  int my = int(map(mouseY, 0, height, 0, canvasHeight));
  mx = constrain(mx, 0, canvasWidth - 1);
  my = constrain(my, 0, canvasHeight - 1);
  efeitos.adicionarOnda(mx, my);
}

void keyPressed() {
  if (key == 'p' || key == 'P') {
    efeitos.alternarModoPintura();
  }
  if (key == 'c' || key == 'C') {
    efeitos.limparPintura();
  }
}
