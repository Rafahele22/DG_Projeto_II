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
