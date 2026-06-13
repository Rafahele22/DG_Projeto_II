class Screen {
  
  PGraphics pg;
  int larguraCanvas;
  int alturaCanvas;
  int tamanhoPixel;
  int colunas;
  int linhas;
  
  int [][] grelhaUsado;
 
  
  ArrayList <integer> ondasLevel;
  ArrayList <color> ondasColor;
  ArrayList <PVector> ondasPos;


  Screen(PGraphics pg) {
    this.pg = pg;
    larguraCanvas = pg.width;
    alturaCanvas = pg.height;
    tamanhoPixel = 1;
    colunas = larguraCanvas / tamanhoPixel;
    linhas = alturaCanvas / tamanhoPixel;
    grelhaUsado = new int[colunas][linhas];
    
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        grelhaUsado[x][y] = 0;
      }
    }
  }
  
  void desenhar() {
    pg.background(238);
       
    for(int x = 0; x < colunas; x++){
      for(int y = 0; y < linhas; y++){
        color cor = color(map(grelhaUsado[x][y], 0, 10, 255, 0));

        pg.fill(cor);
        pg.rect(x, y, 1, 1);
    }
    
    for(int i = 0; i < ondas.size(); i++){
      ondas.get(i)--;
        
      if(ondas.get(i) == 0){
        ondas.remove(i);
      }
    }
  }
  
  void clicar(int x, int y){
    
    
  }
  
  
  void onda(int x, int y, int vol){
    
  }
}
