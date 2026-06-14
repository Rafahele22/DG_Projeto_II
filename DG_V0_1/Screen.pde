class Screen {
  
  PGraphics pg;
  int larguraCanvas;
  int alturaCanvas;
  int tamanhoPixel;
  int colunas;
  int linhas;
  
  int [][] grelhaR;
  int [][] grelhaG;
  int [][] grelhaB;
 
  
  ArrayList <Integer> ondasLevel = new ArrayList<Integer>();
  ArrayList <Integer> ondasVidaMax = new ArrayList<Integer>();
  ArrayList <Integer> ondasColor = new ArrayList<Integer>();
  ArrayList <PVector> ondasPos = new ArrayList<PVector>();

  Screen(PGraphics pg) {
    this.pg = pg;
    larguraCanvas = pg.width;
    alturaCanvas = pg.height;
    tamanhoPixel = 1;
    colunas = larguraCanvas / tamanhoPixel;
    linhas = alturaCanvas / tamanhoPixel;
    
    grelhaR = new int[colunas][linhas];
    grelhaG = new int[colunas][linhas];
    grelhaB = new int[colunas][linhas];
    
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        grelhaR[x][y] = 255;
        grelhaG[x][y] = 255;
        grelhaB[x][y] = 255;
       }
    }
  }
  
  void desenhar() {
    pg.background(238);

    // 1) superficie em repouso: repor a grelha a branco a cada frame
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        grelhaR[x][y] = 255;
      }
    }

    // 2) carimbar cada onda na grelha (de tras para a frente por causa do remove)
    for(int i = ondasLevel.size() - 1; i >= 0; i--){
      int level   = ondasLevel.get(i);
      int vidaMax = ondasVidaMax.get(i);

      int raio = vidaMax - level;                       // cresce a medida que o level cai
      int cor  = round(map(level, vidaMax, 0, 0, 255)); // forte ao nascer, desvanece no fim

      PVector p = ondasPos.get(i);
      onda(round(p.x), round(p.y), raio, cor);

      ondasLevel.set(i, level - 1);

      if(level - 1 <= 0){
        ondasLevel.remove(i);
        ondasVidaMax.remove(i);
        ondasPos.remove(i);
      }
    }

    // 3) desenhar a grelha
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        color cor = color(grelhaR[x][y], grelhaR[x][y], grelhaR[x][y]);

        pg.fill(cor);
        pg.rect(x, y, 1, 1);
      }
    }
  }
  
  void clicar(int x, int y){
    int vida = round(random(30,60));
    ondasPos.add(new PVector(x,y));
    ondasLevel.add(vida);
    ondasVidaMax.add(vida);
  }


  // desenha um anel de raio 'raio' centrado em (cx,cy) com a cor dada
  void onda(int cx, int cy, int raio, int cor){
    if(raio <= 0) return;

    float passo = 1.0 / raio;   // espacamento angular ~1px, evita buracos no anel
    for(float a = 0; a < TWO_PI; a += passo){
      int px = cx + round(raio * cos(a));
      int py = cy + round(raio * sin(a));

      if(px >= 0 && px < colunas && py >= 0 && py < linhas){
        grelhaR[px][py] = cor;
      }
    }
  }
}
