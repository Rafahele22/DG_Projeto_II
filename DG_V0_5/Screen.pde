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

  
  int [][] grelhaRdef;
  int [][] grelhaGdef;
  int [][] grelhaBdef;
  boolean [][] defOn;

  int [][] donoGrelha;
  float [][] intensGrelha;

  boolean [][] textoMask;  // pixeis onde existe texto: so aqui as ondas tem impacto

  float limiarCruz = 0.12;


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
    textoMask  = new boolean[colunas][linhas];

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

    definirTexto("You've gotta dance like there's nobody watching.");
  }

  // Marca a frase na mascara: alinhada a esquerda, com leve margem, centrada na vertical.
  void definirTexto(String frase){
    int margemX = 3;   // leve margem a esquerda
    int espaco  = 1;   // espaco entre letras
    int alturaLetra = 7;
    int origemY = max(0, (linhas - alturaLetra) / 2);

    int x = margemX;
    for(int i = 0; i < frase.length(); i++){
      Letra l = letraDe(frase.charAt(i));
      l.marcarNaGrade(textoMask, x, origemY);
      x += l.largura() + espaco;
    }
  }

  void desenhar() {
    pg.background(238);


    
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        color base;
        if(defOn[x][y]){
          base = color(grelhaRdef[x][y], grelhaGdef[x][y], grelhaBdef[x][y]);
        } else {
          base = color(255);
        }

        float op = intensGrelha[x][y];   
        color cor;
        if(donoGrelha[x][y] != -1 && op > 0.01){
          
          color corOnda = color(grelhaR[x][y], grelhaG[x][y], grelhaB[x][y]);
          cor = lerpColor(base, corOnda, constrain(op, 0, 1));
        } else {
          cor = base;
        }
        pg.fill(cor);
        pg.rect(x, y, 1, 1);
      }
    }

    
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        grelhaR[x][y] = 255;
        grelhaG[x][y] = 255;
        grelhaB[x][y] = 255;
        donoGrelha[x][y] = -1;   
        intensGrelha[x][y] = 0;
      }
    }

   
    for(int i = ondasLevel.size() - 1; i >= 0; i--){
      int level = ondasLevel.get(i);
      int Vida  = ondasVida.get(i);

      int raio  = Vida - level;
      float t   = map(level, Vida, 0, 0, 1); 
      float idade = 1 - t;                   

      PVector p = ondasPos.get(i);
     
      onda(round(p.x), round(p.y), raio,
           ondasColor.get(i*3), ondasColor.get(i*3+1), ondasColor.get(i*3+2),
           idade, i);

      ondasLevel.set(i, level - 1);

      if(level - 1 <= 0){
        ondasLevel.remove(i);
        ondasVida.remove(i);
        ondasPos.remove(i);
       
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


 
  void onda(int cx, int cy, int raio, int rPuro, int gPuro, int bPuro, float idade, int dono){
    if(raio <= 0) return;

    int esp = 8;                      
    int interno = max(1, raio - esp); 

 
    int x0 = max(0, cx - raio);
    int x1 = min(colunas - 1, cx + raio);
    int y0 = max(0, cy - raio);
    int y1 = min(linhas - 1, cy + raio);

    for(int px = x0; px <= x1; px++){
      for(int py = y0; py <= y1; py++){
        float d = dist(px, py, cx, cy);
        if(d >= interno && d <= raio){
          float a  = (raio > interno) ? constrain(map(d, interno, raio, 0.0, 1.0), 0, 1) : 1.0;
          float op = a * idade;
          if(op > 0.01){
            float opExist = intensGrelha[px][py];
            if(donoGrelha[px][py] != -1 && donoGrelha[px][py] != dono
               && op > limiarCruz && opExist > limiarCruz){
              color corExist = color(grelhaR[px][py], grelhaG[px][py], grelhaB[px][py]);
              color brilho = misturarCores(corExist, color(rPuro, gPuro, bPuro), opExist, op);
              grelhaRdef[px][py] = int(red(brilho));
              grelhaGdef[px][py] = int(green(brilho));
              grelhaBdef[px][py] = int(blue(brilho));
              defOn[px][py] = true;
            }

            if(donoGrelha[px][py] == -1 || op >= opExist){
              grelhaR[px][py] = rPuro;
              grelhaG[px][py] = gPuro;
              grelhaB[px][py] = bPuro;
              donoGrelha[px][py] = dono;
              intensGrelha[px][py] = op;
            }

            // Nos pixeis de texto a onda deixa marca permanente: revela e
            // acumula a cor da letra (mistura com o que la estava). So aqui.
            if(textoMask[px][py]){
              color existente = defOn[px][py]
                ? color(grelhaRdef[px][py], grelhaGdef[px][py], grelhaBdef[px][py])
                : color(255);
              color nova = lerpColor(existente, color(rPuro, gPuro, bPuro), constrain(op, 0, 1));
              grelhaRdef[px][py] = int(red(nova));
              grelhaGdef[px][py] = int(green(nova));
              grelhaBdef[px][py] = int(blue(nova));
              defOn[px][py] = true;
            }
          }
        }
      }
    }
  }

  
  color misturarCores(color c1, color c2, float p1, float p2){
    float soma = max(0.0001, p1 + p2);
    float r = (red(c1)   * p1 + red(c2)   * p2) / soma;
    float g = (green(c1) * p1 + green(c2) * p2) / soma;
    float b = (blue(c1)  * p1 + blue(c2)  * p2) / soma;
    return color(r, g, b);
  }
}
