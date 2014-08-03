public class CellularAutomata {

  public CellularAutomata(int w, int h) {
    dimX = w;
    dimY = h;
    myWidth = width;
    myHeight = height;
    generation = 0;
    alive = 0;

    rule = new int[2];
    rule[0] = 2; // Stationary
    rule[1] = 3; // Growth

    cell = new int[dimX][dimY];
    newCell = new int[dimX][dimY];
    reset();

    r = 99;
    g = 99;
    b = 99;
  }

  public void reset() {
    for(int i=0; i<dimX; i++)
      for(int j=0; j<dimY; j++) {
        cell[i][j] = 0;
        newCell[i][j] = 0;
      }
  }

  public int getGeneration() {
    return generation;
  }

  public int getAlive() {
    return alive;
  }

  public int getCell(int x, int y) {
    return cell[x][y];
  }

  public void setCell(int x, int y) {
    cell[x][y] = 1;    
  }

  public void setCellFromMouse() {
    int i = (int) map(pmouseX, 0, myWidth-1, 0, dimX-1);
    int j = (int) map(pmouseY, 0, myHeight-1, 0, dimY-1);
    i = constrain(i, 0, dimX-1);
    j = constrain(j, 0, dimY-1);
    cell[i][j] = 1 - cell[i][j];

    // draw cell
    float w = (myWidth / dimX);
    float h = (myHeight / dimY);
    fill(255, 255, 255);
    rect(i*w, j*h, w, h, 10);
  }

  public void newGeneration() {
    alive = 0;
    for(int i=0; i<dimX; i++) {
      for(int j=0; j<dimY; j++) {
        int s = 0;
        int top = (j==0 ? dimY-1 : j-1);
        int right = (i+1) % dimX;
        int bottom = (j+1) % dimY;
        int left = (i==0 ? dimX-1 : i-1);
        s += cell[left][top]    +   cell[i][top]  + cell[right][top];
        s += cell[left][j]      +       0         + cell[right][j];
        s += cell[left][bottom] + cell[i][bottom] + cell[right][bottom];
        newCell[i][j] = cell[i][j];
        if(cell[i][j]==0 && s==rule[1]) {
          newCell[i][j] = 1;
        }
        else {
          if(s<rule[0] || rule[1]<s)
            newCell[i][j] = 0;
        }
        if(newCell[i][j] == 1) alive++;
      }
    }

    for(int i=0; i<dimX; i++)
      for(int j=0; j<dimY; j++)
        cell[i][j] = newCell[i][j];

    generation++;
    if(generation == 10000) generation = 0;
  }

  public void setDrawArea(int w, int h) {
    myWidth = w;
    myHeight = h;
  }

  public void draw() {
    float w = (myWidth / dimX);
    float h = (myHeight / dimY);
    
    strokeWeight(2);
    stroke(0, 0, 0);
    
    for(int i=0; i<dimX; i++) {
          r = (int) constrain(r + random(-15, 16), 95, 252);
          g = (int) constrain(g + random(-12, 10), 95, 252);
          b = (int) constrain(b + random(-10, 10), 95, 252);
          fill(r, g, b);
      for(int j=0; j<dimY; j++) {
        if(cell[i][j]==1) {
          int x, y;
          x = i;//(i + generation) % dimX;
          y = (j + generation) % dimY;
          rect(x*w, y*h, w, h, 10);
          //r += random(-2, 2);
          //g += random(-5, 5);
          //b += random(-8, 8);
        }
      }
    }
  }
  
  private int dimX, dimY, myWidth, myHeight, generation, alive;
  private int[][] cell, newCell;
  private int[] rule;
  private int r, g, b;
}
