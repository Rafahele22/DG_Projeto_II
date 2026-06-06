class Efeitos {
  PGraphics pg;
  int larguraCanvas;
  int alturaCanvas;
  int tamanhoPixel;
  float espacamento;
  Letra[] palavra;
  ArrayList<Onda> ondas;
  boolean[][] gradeLetras;
  boolean[][] gradeEntorno;
  float[][] tintaFixa;
  color[][] corFixa;
  color[] paleta;
  int colunas;
  int linhas;
  boolean modoPinturaPermanente;
  boolean pinturaSempreLigada;
  int indiceProximaCorOnda;

  Efeitos(PGraphics pg, float tamanhoPixel, float espacamento, Letra[] palavra, boolean pinturaSempreLigada) {
    this.pg = pg;
    larguraCanvas = pg.width;
    alturaCanvas = pg.height;
    this.tamanhoPixel = int(tamanhoPixel);
    this.espacamento = espacamento;
    this.palavra = palavra;
    this.pinturaSempreLigada = pinturaSempreLigada;
    ondas = new ArrayList<Onda>();
    paleta = new color[]{
      color(0, 0, 0),
      color(36, 197, 244),
      color(10, 145, 209),
      color(235, 39, 156),
      color(252, 232, 67),
      color(144, 77, 158),
      color(239, 241, 234),
      color(8, 170, 158),
      color(157, 95, 72)
    };
    colunas = larguraCanvas / int(tamanhoPixel);
    linhas = alturaCanvas / int(tamanhoPixel);
    gradeLetras = new boolean[colunas][linhas];
    gradeEntorno = new boolean[colunas][linhas];
    tintaFixa = new float[colunas][linhas];
    corFixa = new color[colunas][linhas];
    construirGradeTexto();
    modoPinturaPermanente = pinturaSempreLigada;
    indiceProximaCorOnda = 1;
  }

  void desenhar() {
    pg.background(238);
    desenharOndaGlobal();
    desenharTipografiaComEfeito();
    desenharNucleoLegivel();
    atualizarOndas();
  }

  void desenharOndaGlobal() {
    if (ondas.size() == 0) {
      return;
    }

    for (int gy = 0; gy < linhas; gy++) {
      for (int gx = 0; gx < colunas; gx++) {
        float px = gx * tamanhoPixel;
        float py = gy * tamanhoPixel;
        float cx = px + tamanhoPixel * 0.5;
        float cy = py + tamanhoPixel * 0.5;
        float maisForte = 0;
        float segundaMaisForte = 0;
        color corMaisForte = color(0, 0, 0);
        color corSegunda = color(0, 0, 0);

        for (int i = 0; i < ondas.size(); i++) {
          Onda onda = ondas.get(i);
          float impacto = onda.intensidadeAnel(cx, cy) + onda.intensidadeHalo(cx, cy) * 0.35;
          if (impacto > maisForte) {
            segundaMaisForte = maisForte;
            corSegunda = corMaisForte;
            maisForte = impacto;
            corMaisForte = onda.cor;
          } else if (impacto > segundaMaisForte) {
            segundaMaisForte = impacto;
            corSegunda = onda.cor;
          }
        }

        if (maisForte < 0.03) {
          continue;
        }

        boolean cruzou = segundaMaisForte >= 0.035;
        float impacto;
        color brilho;
        if (cruzou) {
          impacto = constrain(sqrt(maisForte * segundaMaisForte) * 1.55, 0, 1);
          brilho = misturarCores(corMaisForte, corSegunda, maisForte, segundaMaisForte);
        } else {
          impacto = constrain(maisForte * 1.1, 0, 1);
          brilho = corMaisForte;
        }

        float alpha = cruzou ? 200 * impacto : 95 * impacto;
        pg.fill(red(brilho), green(brilho), blue(brilho), alpha);
        pg.rect(px, py, tamanhoPixel, tamanhoPixel);
        if (pinturaAtiva() && cruzou && impacto > 0.08) {
          gravarPintura(gx, gy, brilho, impacto * 0.85);
        }
      }
    }
  }

  void adicionarOnda(int mouseX, int mouseY) {
    int centroX = (mouseX / tamanhoPixel) * tamanhoPixel + tamanhoPixel / 2;
    int centroY = (mouseY / tamanhoPixel) * tamanhoPixel + tamanhoPixel / 2;
    color corOnda = paleta[indiceProximaCorOnda];
    indiceProximaCorOnda++;
    if (indiceProximaCorOnda >= paleta.length) {
      indiceProximaCorOnda = 1;
    }
    ondas.add(new Onda(centroX, centroY, tamanhoPixel, max(larguraCanvas, alturaCanvas), corOnda));
  }

  void alternarModoPintura() {
    if (pinturaSempreLigada) {
      return;
    }
    modoPinturaPermanente = !modoPinturaPermanente;
  }

  boolean modoPinturaAtivo() {
    return pinturaAtiva();
  }

  boolean pinturaAtiva() {
    return pinturaSempreLigada || modoPinturaPermanente;
  }

  void limparPintura() {
    for (int gx = 0; gx < colunas; gx++) {
      for (int gy = 0; gy < linhas; gy++) {
        tintaFixa[gx][gy] = 0;
        corFixa[gx][gy] = color(0, 0, 0);
      }
    }
  }

  void atualizarOndas() {
    for (int i = ondas.size() - 1; i >= 0; i--) {
      Onda onda = ondas.get(i);
      onda.atualizar();
      if (onda.terminou()) {
        ondas.remove(i);
      }
    }
  }

  void construirGradeTexto() {
    for (int gx = 0; gx < colunas; gx++) {
      for (int gy = 0; gy < linhas; gy++) {
        gradeLetras[gx][gy] = false;
        gradeEntorno[gx][gy] = false;
      }
    }

    int x = tamanhoPixel;
    int y = (alturaCanvas - palavra[0].altura() * tamanhoPixel) / 2;
    int origemGX = x / tamanhoPixel;
    int origemGY = y / tamanhoPixel;

    for (int i = 0; i < palavra.length; i++) {
      palavra[i].marcarNaGrade(gradeLetras, origemGX, origemGY);
      origemGX += palavra[i].largura() + espacamento;
    }

    int raioEntorno = 3;
    for (int gx = 0; gx < colunas; gx++) {
      for (int gy = 0; gy < linhas; gy++) {
        if (!gradeLetras[gx][gy]) {
          continue;
        }
        for (int dx = -raioEntorno; dx <= raioEntorno; dx++) {
          for (int dy = -raioEntorno; dy <= raioEntorno; dy++) {
            int nx = gx + dx;
            int ny = gy + dy;
            if (nx >= 0 && nx < colunas && ny >= 0 && ny < linhas) {
              gradeEntorno[nx][ny] = true;
            }
          }
        }
      }
    }
  }

  void desenharTipografiaComEfeito() {
    for (int gy = 0; gy < linhas; gy++) {
      for (int gx = 0; gx < colunas; gx++) {
        boolean ehLetra = gradeLetras[gx][gy];
        boolean noEntorno = gradeEntorno[gx][gy];
        float fixa = tintaFixa[gx][gy];
        boolean temPintura = fixa > 0.01;
        if (!ehLetra && !noEntorno && !temPintura) {
          continue;
        }

        float px = gx * tamanhoPixel;
        float py = gy * tamanhoPixel;
        float cx = px + tamanhoPixel * 0.5;
        float cy = py + tamanhoPixel * 0.5;
        float anel = 0;
        float halo = 0;
        float deslocX = 0;
        float deslocY = 0;
        float maisForte = 0;
        float segundaMaisForte = 0;
        color corMaisForte = color(36, 197, 244);

        for (int i = 0; i < ondas.size(); i++) {
          Onda onda = ondas.get(i);
          float impactoAnel = onda.intensidadeAnel(cx, cy);
          float impactoHalo = onda.intensidadeHalo(cx, cy);
          float impactoLocal = impactoAnel + impactoHalo * 0.35;
          anel = max(anel, impactoAnel);
          halo = max(halo, impactoHalo);
          if (impactoLocal > maisForte) {
            segundaMaisForte = maisForte;
            maisForte = impactoLocal;
            corMaisForte = onda.cor;
          } else if (impactoLocal > segundaMaisForte) {
            segundaMaisForte = impactoLocal;
          }
          float forca = impactoAnel + impactoHalo * 0.45;
          if (forca > 0) {
            float ang = atan2(cy - onda.y, cx - onda.x);
            deslocX += cos(ang) * forca * tamanhoPixel * 0.9;
            deslocY += sin(ang) * forca * tamanhoPixel * 0.4;
          }
        }

        boolean cruzou = segundaMaisForte >= 0.035;

        float ruidoX = noise(gx * 0.23, gy * 0.17, frameCount * 0.04) - 0.5;
        float ruidoY = noise(gx * 0.19 + 41, gy * 0.21 + 13, frameCount * 0.04) - 0.5;
        float tremor = max(0, anel * 1.4 + halo * 0.8 - 0.08);
        float jitterX = ruidoX * tremor * tamanhoPixel * 1.2;
        float jitterY = ruidoY * tremor * tamanhoPixel * 0.9;

        if (ehLetra) {
          float tinta = constrain(anel * 1.35 + halo * 0.9, 0, 1);
          color corAtiva = corMaisForte;
          color corCamada = corAtiva;
          if (fixa > 0.01) {
            corCamada = lerpColor(corAtiva, corFixa[gx][gy], 0.55);
          }
          float alphaCamada = 150 * max(tinta, fixa * 0.45);
          if (alphaCamada > 0.5) {
            pg.fill(red(corCamada), green(corCamada), blue(corCamada), alphaCamada);
            pg.rect(px + deslocX * 0.55 + jitterX * 0.45, py + deslocY * 0.55 + jitterY * 0.45, tamanhoPixel, tamanhoPixel);
          }
          if (pinturaAtiva() && cruzou && tinta > 0.16) {
            gravarPintura(gx, gy, corAtiva, tinta);
          }
          if (tinta > 0.16) {
            desenharRasto(gx, gy, tinta, deslocX + jitterX, deslocY + jitterY, corAtiva, cruzou);
          }
        } else {
          if (temPintura) {
            color fixaCor = corFixa[gx][gy];
            pg.fill(red(fixaCor), green(fixaCor), blue(fixaCor), 255 * fixa);
            pg.rect(px, py, tamanhoPixel, tamanhoPixel);
          }
          float poeira = constrain(anel * 0.95 + halo * 1.15 - 0.14, 0, 1);
          if (poeira > 0) {
            float presenca = noise(gx * 0.37 + 77, gy * 0.43 + 17, frameCount * 0.08);
            if (presenca > 0.42) {
              color brilho = corMaisForte;
              pg.fill(red(brilho), green(brilho), blue(brilho), 210 * poeira);
              pg.rect(px, py, tamanhoPixel, tamanhoPixel);
              if (pinturaAtiva() && cruzou && poeira > 0.24) {
                gravarPintura(gx, gy, brilho, poeira * 0.75);
              }
            }
          }
        }
      }
    }
  }

  void desenharNucleoLegivel() {
    for (int gy = 0; gy < linhas; gy++) {
      for (int gx = 0; gx < colunas; gx++) {
        if (!gradeLetras[gx][gy]) {
          continue;
        }

        float px = gx * tamanhoPixel;
        float py = gy * tamanhoPixel;
        float cx = px + tamanhoPixel * 0.5;
        float cy = py + tamanhoPixel * 0.5;
        float fixa = tintaFixa[gx][gy];

        color corBase = color(0);
        if (fixa > 0.01) {
          float mistura = constrain(fixa * 0.24, 0, 0.24);
          corBase = lerpColor(corBase, corFixa[gx][gy], mistura);
        }

        pg.fill(corBase);
        pg.rect(px, py, tamanhoPixel, tamanhoPixel);

        float brilho = 0;
        float impactoDominante = 0;
        color corDominante = color(36, 197, 244);
        for (int i = 0; i < ondas.size(); i++) {
          Onda onda = ondas.get(i);
          float impacto = onda.intensidadeAnel(cx, cy) + onda.intensidadeHalo(cx, cy) * 0.35;
          if (impacto > impactoDominante) {
            impactoDominante = impacto;
            corDominante = onda.cor;
          }
          float realce = onda.intensidadeAnel(cx, cy) * 0.45 + onda.intensidadeHalo(cx, cy) * 0.25;
          brilho = max(brilho, realce);
        }

        if (brilho > 0.05 && impactoDominante > 0.03) {
          color acento = corDominante;
          int margem = max(1, tamanhoPixel / 4);
          int miolo = max(1, tamanhoPixel - margem * 2);
          pg.fill(red(acento), green(acento), blue(acento), 95 * brilho);
          pg.rect(px + margem, py + margem, miolo, miolo);
        }
      }
    }
  }

  void desenharRasto(int gx, int gy, float intensidade, float deslocX, float deslocY, color corBase, boolean cruzou) {
    int direcao = noise(gx * 0.31, gy * 0.27, frameCount * 0.03) > 0.5 ? 1 : -1;
    int comprimento = 1 + int(intensidade * 5);
    for (int passo = 1; passo <= comprimento; passo++) {
      int nx = gx + direcao * passo;
      if (nx < 0 || nx >= colunas) {
        break;
      }
      if (gradeLetras[nx][gy]) {
        continue;
      }
      if (!gradeEntorno[nx][gy]) {
        break;
      }
      color faixa = corBase;
      float alpha = (190 * intensidade) / (passo + 0.5);
      pg.fill(red(faixa), green(faixa), blue(faixa), alpha);
      pg.rect(nx * tamanhoPixel + deslocX * 0.45, gy * tamanhoPixel + deslocY * 0.45, tamanhoPixel, tamanhoPixel);
      if (pinturaAtiva() && cruzou) {
        gravarPintura(nx, gy, faixa, intensidade / (passo + 0.8));
      }
    }
  }

  void gravarPintura(int gx, int gy, color novaCor, float intensidade) {
    if (gx < 0 || gx >= colunas || gy < 0 || gy >= linhas) {
      return;
    }
    float ganho = constrain(intensidade * 0.35, 0.03, 0.32);
    float atual = tintaFixa[gx][gy];
    float acumulada = constrain(atual + ganho, 0, 1);
    if (atual <= 0.001) {
      corFixa[gx][gy] = novaCor;
    } else {
      corFixa[gx][gy] = lerpColor(corFixa[gx][gy], novaCor, 0.42);
    }
    tintaFixa[gx][gy] = acumulada;
  }

  color misturarCores(color c1, color c2, float p1, float p2) {
    float soma = max(0.0001, p1 + p2);
    float r = (red(c1) * p1 + red(c2) * p2) / soma;
    float g = (green(c1) * p1 + green(c2) * p2) / soma;
    float b = (blue(c1) * p1 + blue(c2) * p2) / soma;
    return color(r, g, b);
  }

  color corGlitch(int gx, int gy, float tempo) {
    float n = noise(gx * 0.16 + tempo, gy * 0.22 - tempo * 0.9);
    int idx = int(n * paleta.length);
    idx = constrain(idx, 0, paleta.length - 1);
    return paleta[idx];
  }
}
