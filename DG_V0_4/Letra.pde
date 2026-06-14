class Letra {
  String[] padrao;

  Letra(String[] padrao) {
    this.padrao = padrao;
  }

  void desenhar(int origemX, int origemY, int tamanho) {
    for (int y = 0; y < padrao.length; y++) {
      for (int x = 0; x < padrao[y].length(); x++) {
        if (padrao[y].charAt(x) == '1') {
          rect(origemX + x * tamanho, origemY + y * tamanho, tamanho, tamanho);
        }
      }
    }
  }

  void marcarNaGrade(boolean[][] grade, int origemXGrade, int origemYGrade) {
    int totalColunas = grade.length;
    int totalLinhas = grade[0].length;
    for (int y = 0; y < padrao.length; y++) {
      for (int x = 0; x < padrao[y].length(); x++) {
        if (padrao[y].charAt(x) == '1') {
          int gx = origemXGrade + x;
          int gy = origemYGrade + y;
          if (gx >= 0 && gx < totalColunas && gy >= 0 && gy < totalLinhas) {
            grade[gx][gy] = true;
          }
        }
      }
    }
  }

  int largura() {
    return padrao[0].length();
  }

  int altura() {
    return padrao.length;
  }
}

class LetraC extends Letra {
  LetraC() {
    super(new String[]{
      "01110",
      "10001",
      "10000",
      "10000",
      "10000",
      "10001",
      "01110"
    });
  }
}

class LetraH extends Letra {
  LetraH() {
    super(new String[]{
      "10001",
      "10001",
      "10001",
      "11111",
      "10001",
      "10001",
      "10001"
    });
  }
}

class LetraO extends Letra {
  LetraO() {
    super(new String[]{
      "01110",
      "10001",
      "10001",
      "10001",
      "10001",
      "10001",
      "01110"
    });
  }
}

class LetraS extends Letra {
  LetraS() {
    super(new String[]{
      "01111",
      "10000",
      "10000",
      "01110",
      "00001",
      "00001",
      "11110"
    });
  }
}

class LetraE extends Letra {
  LetraE() {
    super(new String[]{
      "11111",
      "10000",
      "10000",
      "11110",
      "10000",
      "10000",
      "11111"
    });
  }
}

class Espaco extends Letra {
  Espaco() {
    super(new String[]{
      "000",
      "000",
      "000",
      "000",
      "000",
      "000",
      "000"
    });
  }
}

class LetraL extends Letra {
  LetraL() {
    super(new String[]{
      "10000",
      "10000",
      "10000",
      "10000",
      "10000",
      "10000",
      "11111"
    });
  }
}

class LetraV extends Letra {
  LetraV() {
    super(new String[]{
      "10001",
      "10001",
      "10001",
      "10001",
      "10001",
      "01010",
      "00100"
    });
  }
}

class LetraA extends Letra {
  LetraA() {
    super(new String[]{
      "01110",
      "10001",
      "10001",
      "11111",
      "10001",
      "10001",
      "10001"
    });
  }
}

class LetraW extends Letra {
  LetraW() {
    super(new String[]{
      "1000001",
      "1000001",
      "1000001",
      "1010101",
      "1010101",
      "1010101",
      "0100010"
    });
  }
}

class LetraY extends Letra {
  LetraY() {
    super(new String[]{
      "10001",
      "10001",
      "01010",
      "00100",
      "00100",
      "00100",
      "00100"
    });
  }
}

class Ponto extends Letra {
  Ponto() {
    super(new String[]{
      "00",
      "00",
      "00",
      "00",
      "00",
      "11",
      "11"
    });
  }
}

class Apostrofo extends Letra {
  Apostrofo() {
    super(new String[]{
      "1",
      "1",
      "0",
      "0",
      "0",
      "0",
      "0"
    });
  }
}

class LetraB extends Letra {
  LetraB() {
    super(new String[]{
      "11110",
      "10001",
      "10001",
      "11110",
      "10001",
      "10001",
      "11110"
    });
  }
}

class LetraD extends Letra {
  LetraD() {
    super(new String[]{
      "11110",
      "10001",
      "10001",
      "10001",
      "10001",
      "10001",
      "11110"
    });
  }
}

class LetraF extends Letra {
  LetraF() {
    super(new String[]{
      "11111",
      "10000",
      "10000",
      "11110",
      "10000",
      "10000",
      "10000"
    });
  }
}

class LetraG extends Letra {
  LetraG() {
    super(new String[]{
      "01110",
      "10001",
      "10000",
      "10111",
      "10001",
      "10001",
      "01110"
    });
  }
}

class LetraI extends Letra {
  LetraI() {
    super(new String[]{
      "111",
      "010",
      "010",
      "010",
      "010",
      "010",
      "111"
    });
  }
}

class LetraJ extends Letra {
  LetraJ() {
    super(new String[]{
      "00111",
      "00010",
      "00010",
      "00010",
      "10010",
      "10010",
      "01100"
    });
  }
}

class LetraK extends Letra {
  LetraK() {
    super(new String[]{
      "10001",
      "10010",
      "10100",
      "11000",
      "10100",
      "10010",
      "10001"
    });
  }
}

class LetraM extends Letra {
  LetraM() {
    super(new String[]{
      "10001",
      "11011",
      "10101",
      "10101",
      "10001",
      "10001",
      "10001"
    });
  }
}

class LetraN extends Letra {
  LetraN() {
    super(new String[]{
      "10001",
      "11001",
      "10101",
      "10101",
      "10101",
      "10011",
      "10001"
    });
  }
}

class LetraP extends Letra {
  LetraP() {
    super(new String[]{
      "11110",
      "10001",
      "10001",
      "11110",
      "10000",
      "10000",
      "10000"
    });
  }
}

class LetraQ extends Letra {
  LetraQ() {
    super(new String[]{
      "01110",
      "10001",
      "10001",
      "10001",
      "10101",
      "10010",
      "01101"
    });
  }
}

class LetraR extends Letra {
  LetraR() {
    super(new String[]{
      "11110",
      "10001",
      "10001",
      "11110",
      "10100",
      "10010",
      "10001"
    });
  }
}

class LetraT extends Letra {
  LetraT() {
    super(new String[]{
      "11111",
      "00100",
      "00100",
      "00100",
      "00100",
      "00100",
      "00100"
    });
  }
}

class LetraU extends Letra {
  LetraU() {
    super(new String[]{
      "10001",
      "10001",
      "10001",
      "10001",
      "10001",
      "10001",
      "01110"
    });
  }
}

class LetraX extends Letra {
  LetraX() {
    super(new String[]{
      "10001",
      "10001",
      "01010",
      "00100",
      "01010",
      "10001",
      "10001"
    });
  }
}

class LetraZ extends Letra {
  LetraZ() {
    super(new String[]{
      "11111",
      "00001",
      "00010",
      "00100",
      "01000",
      "10000",
      "11111"
    });
  }
}

// vai buscar a Letra correspondente a um caracter (maiusculas; espaco e '.' tambem)
Letra letraDe(char c) {
  switch (Character.toUpperCase(c)) {
    case 'A': return new LetraA();
    case 'B': return new LetraB();
    case 'C': return new LetraC();
    case 'D': return new LetraD();
    case 'E': return new LetraE();
    case 'F': return new LetraF();
    case 'G': return new LetraG();
    case 'H': return new LetraH();
    case 'I': return new LetraI();
    case 'J': return new LetraJ();
    case 'K': return new LetraK();
    case 'L': return new LetraL();
    case 'M': return new LetraM();
    case 'N': return new LetraN();
    case 'O': return new LetraO();
    case 'P': return new LetraP();
    case 'Q': return new LetraQ();
    case 'R': return new LetraR();
    case 'S': return new LetraS();
    case 'T': return new LetraT();
    case 'U': return new LetraU();
    case 'V': return new LetraV();
    case 'W': return new LetraW();
    case 'X': return new LetraX();
    case 'Y': return new LetraY();
    case 'Z': return new LetraZ();
    case '.': return new Ponto();
    case '\'': return new Apostrofo();
    default:  return new Espaco();
  }
}
