int canvasWidth = 350;
int canvasHeight = 24;

PGraphics canvas; // https://processing.org/reference/PGraphics.html
Tx tx;

void settings() {
  // Find the larger scaling that fits your screen
  float scaling = 10;
  while (canvasWidth * scaling > displayWidth) scaling--;
  size(int(canvasWidth * scaling), int(canvasHeight * scaling));
  pixelDensity(1); // Do not remove this line
  noSmooth(); // Do not remove this line
}

void setup() {
  frameRate(30);
  canvas = createGraphics(canvasWidth, canvasHeight);
  tx = new Tx(canvasWidth, canvasHeight);
}

void draw() {
  // Draw animation on a (offscreen) canvas
  canvas.beginDraw();
  float t = millis() * 0.001;
  for (int y = 0; y < canvas.height; y++) {
    for (int x = 0; x < canvas.width; x++) {
      int r = int(127 + 127 * sin(t + x * 0.04));
      int g = int(127 + 127 * sin(t * 1.3 + y * 0.1));
      int b = int(127 + 127 * sin(t * 0.7 + (x + y) * 0.1));
      canvas.stroke(r, g, b);
      canvas.point(x, y);
    }
  }
  canvas.endDraw();
  
  // Draw canvas on window
  image(canvas, 0, 0, width, height);
  
  // Send canvas to server
  tx.send(canvas);
}
