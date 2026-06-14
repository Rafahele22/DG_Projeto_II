class Onda {
  float x;
  float y;
  float raio;
  float velocidade;
  float espessura;
  float opacidade;
  float limiteDim;

  Onda(float x, float y, float tamanhoPixelRef, float limiteDim) {
    this.x = x;
    this.y = y;
    this.limiteDim = limiteDim;
    raio = 0;
    velocidade = 2.6;
    espessura = tamanhoPixelRef * 1.4;
    opacidade = 220;
  }

  void atualizar() {
    raio += velocidade;
    velocidade *= 0.997;
    opacidade -= 1.25;
  }

  float intensidadeAnel(float px, float py) {
    float d = dist(px, py, x, y);
    float largura = espessura * 2.6;
    float base = 1.0 - abs(d - raio) / largura;
    if (base <= 0) {
      return 0;
    }
    return base * (opacidade / 220.0);
  }

  float intensidadeHalo(float px, float py) {
    float d = dist(px, py, x, y);
    float centro = raio - espessura * 0.7;
    float alcance = espessura * 6.2;
    float base = 1.0 - abs(d - centro) / alcance;
    if (base <= 0) {
      return 0;
    }
    return base * (opacidade / 340.0);
  }

  boolean terminou() {
    return opacidade <= 0 || raio > limiteDim + espessura * 6;
  }
}
