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

  // camada definitiva: guarda a cor dos cruzamentos (permanente, nao se apaga)
  int [][] grelhaRdef;
  int [][] grelhaGdef;
  int [][] grelhaBdef;
  boolean [][] defOn;      // true onde ja houve um cruzamento

  int [][] donoGrelha;     // que onda pintou cada pixel NESTE frame (-1 = ninguem)
  float [][] intensGrelha; // intensidade (0..1) da onda que ocupa o pixel neste frame

  float limiarCruz = 0.12; // so conta como cruzamento se ambas as ondas tiverem intensidade acima disto


  ArrayList <Integer> ondasLevel = new ArrayList<Integer>();
  ArrayList <Integer> ondasVida = new ArrayList<Integer>();
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

    grelhaRdef = new int[colunas][linhas];
    grelhaGdef = new int[colunas][linhas];
    grelhaBdef = new int[colunas][linhas];
    defOn      = new boolean[colunas][linhas];
    donoGrelha = new int[colunas][linhas];
    intensGrelha = new float[colunas][linhas];

    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        grelhaR[x][y] = 255;
        grelhaG[x][y] = 255;
        grelhaB[x][y] = 255;

        grelhaRdef[x][y] = 255;
        grelhaGdef[x][y] = 255;
        grelhaBdef[x][y] = 255;
        defOn[x][y] = false;
        donoGrelha[x][y] = -1;
        intensGrelha[x][y] = 0;
       }
    }
  }
  
  void desenhar() {
    pg.background(238);


    // 3) desenhar: a onda (translucida) por cima da base; ao esbater REVELA a base
    //    (transparente, nao pinta branco). base = cruzamento definitivo ou fundo branco.
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        color base;
        if(defOn[x][y]){
          base = color(grelhaRdef[x][y], grelhaGdef[x][y], grelhaBdef[x][y]);
        } else {
          base = color(255);
        }

        float op = intensGrelha[x][y];   // opacidade da onda neste pixel (0..1)
        color cor;
        if(donoGrelha[x][y] != -1 && op > 0.01){
          // onda por cima da base com a sua opacidade -> quando esbate (op->0) revela a base
          color corOnda = color(grelhaR[x][y], grelhaG[x][y], grelhaB[x][y]);
          cor = lerpColor(base, corOnda, constrain(op, 0, 1));
        } else {
          cor = base;
        }
        pg.fill(cor);
        pg.rect(x, y, 1, 1);
      }
    }

    // 1) camada de movimento (transiente): repor a branco + limpar os donos do frame
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        grelhaR[x][y] = 255;
        grelhaG[x][y] = 255;
        grelhaB[x][y] = 255;
        donoGrelha[x][y] = -1;   // ninguem pintou este pixel ainda neste frame
        intensGrelha[x][y] = 0;
      }
    }

    // 2) carimbar cada onda na camada de movimento (de tras para a frente por causa do remove)
    for(int i = ondasLevel.size() - 1; i >= 0; i--){
      int level = ondasLevel.get(i);
      int Vida  = ondasVida.get(i);

      int raio  = Vida - level;
      float t   = map(level, Vida, 0, 0, 1); // 0=acaba de nascer, 1=vai morrer
      float idade = 1 - t;                    // 1=forte no inicio, 0=desvanece no fim

      PVector p = ondasPos.get(i);
      // passa a cor PURA + idade; a opacidade e o esbatimento sao tratados dentro de onda()
      onda(round(p.x), round(p.y), raio,
           ondasColor.get(i*3), ondasColor.get(i*3+1), ondasColor.get(i*3+2),
           idade, i);

      ondasLevel.set(i, level - 1);

      if(level - 1 <= 0){
        ondasLevel.remove(i);
        ondasVida.remove(i);
        ondasPos.remove(i);
        // remover os 3 canais de cor desta onda
        ondasColor.remove(i*3);
        ondasColor.remove(i*3);
        ondasColor.remove(i*3);
      }
    }

    
  }
  
  void clicar(int x, int y){
    int vida = round(random(30,60));
    ondasPos.add(new PVector(x,y));
    ondasLevel.add(vida);
    
    for(int i = 0; i < 3; i++){
      ondasColor.add(round(random(0,255)));
    }
    
    ondasVida.add(vida);
  }


  // desenha um anel GROSSO. Guarda a cor PURA + a opacidade (op = gradiente x idade),
  // para o render poder compor a onda translucida e esbate-la de forma transparente.
  void onda(int cx, int cy, int raio, int rPuro, int gPuro, int bPuro, float idade, int dono){
    if(raio <= 0) return;

    int esp = 8;                      // espessura da onda (px)
    int interno = max(1, raio - esp); // raio interior da banda

    // percorre a caixa que envolve o anel e pinta POR DISTANCIA -> sem buracos
    int x0 = max(0, cx - raio);
    int x1 = min(colunas - 1, cx + raio);
    int y0 = max(0, cy - raio);
    int y1 = min(linhas - 1, cy + raio);

    for(int px = x0; px <= x1; px++){
      for(int py = y0; py <= y1; py++){
        float d = dist(px, py, cx, cy);
        if(d < interno || d > raio) continue;   // so a banda [interno, raio]

        // gradiente da banda (forte na frente, fraco atras) x esbatimento pela idade = opacidade
        float a  = (raio > interno) ? constrain(map(d, interno, raio, 0.0, 1.0), 0, 1) : 1.0;
        float op = a * idade;
        if(op <= 0.01) continue;                // praticamente transparente -> nem pinta

        float opExist = intensGrelha[px][py];

        // CRUZAMENTO: este pixel ja foi pintado neste frame por uma onda DIFERENTE?
        if(donoGrelha[px][py] != -1 && donoGrelha[px][py] != dono
           && op > limiarCruz && opExist > limiarCruz){
          // a grelha ja guarda a cor PURA da onda que la estava -> misturar ponderado
          color corExist = color(grelhaR[px][py], grelhaG[px][py], grelhaB[px][py]);
          color brilho = misturarCores(corExist, color(rPuro, gPuro, bPuro), opExist, op);
          grelhaRdef[px][py] = int(red(brilho));
          grelhaGdef[px][py] = int(green(brilho));
          grelhaBdef[px][py] = int(blue(brilho));
          defOn[px][py] = true;
        }

        // guardar a cor PURA + opacidade (a onda mais opaca fica neste pixel)
        if(donoGrelha[px][py] == -1 || op >= opExist){
          grelhaR[px][py] = rPuro;
          grelhaG[px][py] = gPuro;
          grelhaB[px][py] = bPuro;
          donoGrelha[px][py] = dono;
          intensGrelha[px][py] = op;
        }
      }
    }
  }

  // mistura duas cores ponderada pela intensidade de cada uma (portado do NewTeste)
  color misturarCores(color c1, color c2, float p1, float p2){
    float soma = max(0.0001, p1 + p2);
    float r = (red(c1)   * p1 + red(c2)   * p2) / soma;
    float g = (green(c1) * p1 + green(c2) * p2) / soma;
    float b = (blue(c1)  * p1 + blue(c2)  * p2) / soma;
    return color(r, g, b);
  }
}
