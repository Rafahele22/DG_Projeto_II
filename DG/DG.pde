int canvasWidth = 350;
int canvasHeight = 24;
int escalaJanela = 1;

PGraphics canvas;
Screen ecra;
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

void setup() {
  frameRate(30);
  canvas = createGraphics(canvasWidth, canvasHeight);
  tx = new Tx(canvasWidth, canvasHeight);
  ecra = new Screen(canvas);
}

void draw() {
  canvas.beginDraw();
  canvas.noStroke();
  ecra.desenhar();
  canvas.endDraw();
  image(canvas, 0, 0, width, height);
  tx.send(canvas);
}

void mousePressed() {
  // Converte as coordenadas do ecrã (com escala) para coordenadas do canvas.
  int mx = int(map(mouseX, 0, width, 0, canvasWidth));
  int my = int(map(mouseY, 0, height, 0, canvasHeight));
  mx = constrain(mx, 0, canvasWidth - 1);
  my = constrain(my, 0, canvasHeight - 1);
  // TODO: usar (mx, my) no teu efeito.
  ecra.clicar(mx, my);
  
}
