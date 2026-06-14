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

  float [][] textoEco;  // 0 = sem texto, 1 = nucleo da letra, intermedio = eco a volta

  String[] frases;            // frases lidas de data/frases.txt
  int fraseAtual = 0;
  int ondasParaApagar = 25;   // ondas a revelar antes de comecar a apagar
  int contaOndas = 0;
  boolean aApagar = false;    // true durante a fase em que as ondas apagam o texto
  boolean[][] aApagarPix;     // rasto da frase a sair: so as ondas o limpam

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
    textoEco   = new float[colunas][linhas];
    aApagarPix = new boolean[colunas][linhas];

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

    // carrega as frases de data/frases.txt (ignora linhas vazias)
    String[] linhasFich = loadStrings("frases.txt");
    ArrayList<String> lista = new ArrayList<String>();
    if(linhasFich != null){
      for(String s : linhasFich){
        if(s != null && s.trim().length() > 0) lista.add(s.trim());
      }
    }
    if(lista.size() == 0) lista.add("...");
    frases = lista.toArray(new String[0]);

    definirTexto(frases[fraseAtual]);
  }

  // Marca a frase na grelha: alinhada a esquerda, com leve margem, centrada na vertical.
  // As letras podem ser escaladas (mais altas/largas) e engrossadas (bold).
  void definirTexto(String frase){
    int margemX = 2;   // leve margem a esquerda
    int espaco  = 2;   // espaco entre letras
    int escalaX = 1;   // largura das letras
    int escalaY = 2;   // altura das letras (mais altas)
    int bold    = 0;   // espessura extra (0 = normal, 1 = levemente mais grossas)

    int alturaLetra = 7 * escalaY;
    int origemY = max(0, (linhas - alturaLetra - bold) / 2);

    // 1) marca o nucleo das letras, ja escaladas
    boolean[][] nucleo = new boolean[colunas][linhas];
    int x = margemX;
    for(int i = 0; i < frase.length(); i++){
      Letra l = letraDe(frase.charAt(i));
      marcarLetra(nucleo, l, x, origemY, escalaX, escalaY);
      x += l.largura() * escalaX + espaco;
    }

    // 2) engrossa (bold) e passa para textoEco
    for(int px = 0; px < colunas; px++){
      for(int py = 0; py < linhas; py++){
        boolean on = false;
        for(int dx = 0; dx <= bold; dx++){
          for(int dy = 0; dy <= bold; dy++){
            int nx = px - dx;
            int ny = py - dy;
            if(nx >= 0 && ny >= 0 && nucleo[nx][ny]) on = true;
          }
        }
        textoEco[px][py] = on ? 1.0 : 0.0;
      }
    }
  }

  // Marca uma letra na grelha, repetindo cada pixel do padrao escalaX x escalaY vezes.
  void marcarLetra(boolean[][] grade, Letra l, int origemX, int origemY, int escalaX, int escalaY){
    for(int y = 0; y < l.padrao.length; y++){
      for(int x = 0; x < l.padrao[y].length(); x++){
        if(l.padrao[y].charAt(x) == '1'){
          for(int sy = 0; sy < escalaY; sy++){
            for(int sx = 0; sx < escalaX; sx++){
              int gx = origemX + x * escalaX + sx;
              int gy = origemY + y * escalaY + sy;
              if(gx >= 0 && gx < grade.length && gy >= 0 && gy < grade[0].length){
                grade[gx][gy] = true;
              }
            }
          }
        }
      }
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

    // troca de frase so quando as ondas tiverem apagado todo o rasto (nada forcado)
    if(aApagar && nadaParaApagar()){
      proximaFrase();
    }
  }

  // verdadeiro quando ja nao ha nenhum pixel por apagar (rasto todo limpo pelas ondas)
  boolean nadaParaApagar(){
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        if(aApagarPix[x][y]) return false;
      }
    }
    return true;
  }

  void clicar(int x, int y){
    int vida = round(random(30,60));
    ondasPos.add(new PVector(x,y));
    ondasLevel.add(vida);
    
    for(int i = 0; i < 3; i++){
      ondasColor.add(round(random(0,255)));
    }
    
    ondasVida.add(vida);

    // conta ondas; ao fim de ondasParaApagar marca a frase para as ondas apagarem.
    // A troca para a frase seguinte so acontece quando o rasto estiver limpo (ver desenhar).
    if(!aApagar){
      contaOndas++;
      if(contaOndas >= ondasParaApagar){
        iniciarApagar();
      }
    }
  }

  // Marca a frase atual como rasto a apagar e deixa de a revelar.
  // Nada desaparece de imediato: so as ondas, ao passarem, e que a limpam.
  void iniciarApagar(){
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        if(textoEco[x][y] > 0) aApagarPix[x][y] = true;
        textoEco[x][y] = 0;   // deixa de revelar; passa so a apagar
      }
    }
    aApagar = true;
    contaOndas = 0;
  }

  // Passa para a frase seguinte (so chamada quando o rasto ja foi todo apagado).
  void proximaFrase(){
    fraseAtual = (fraseAtual + 1) % frases.length;
    definirTexto(frases[fraseAtual]);
    aApagar = false;
    contaOndas = 0;
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

            // Texto: as ondas REVELAM o alvo atual (textoEco) e APAGAM o rasto da
            // frase a sair (aApagarPix). So acontece aqui, e so onde a onda passa.
            float forca = textoEco[px][py];
            if(forca > 0){
              color existente = defOn[px][py]
                ? color(grelhaRdef[px][py], grelhaGdef[px][py], grelhaBdef[px][py])
                : color(255);
              color nova = lerpColor(existente, color(rPuro, gPuro, bPuro), constrain(op * forca, 0, 1));
              grelhaRdef[px][py] = int(red(nova));
              grelhaGdef[px][py] = int(green(nova));
              grelhaBdef[px][py] = int(blue(nova));
              defOn[px][py] = true;
            } else if(aApagarPix[px][py]){
              if(defOn[px][py]){
                color atual = color(grelhaRdef[px][py], grelhaGdef[px][py], grelhaBdef[px][py]);
                color nova = lerpColor(atual, color(255), constrain(op, 0, 1));
                grelhaRdef[px][py] = int(red(nova));
                grelhaGdef[px][py] = int(green(nova));
                grelhaBdef[px][py] = int(blue(nova));
                if(red(nova) > 250 && green(nova) > 250 && blue(nova) > 250){
                  defOn[px][py] = false;
                  aApagarPix[px][py] = false;
                }
              } else {
                aApagarPix[px][py] = false;   // ja estava em branco aqui: nada a apagar
              }
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
