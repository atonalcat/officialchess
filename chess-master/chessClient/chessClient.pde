import processing.net.*;

Client myClient;

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
boolean turn = true;
boolean pawnpromotion;
boolean isblack;
int row1, col1, row2, col2, num;
char RAGERAGERAGE;

char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

void setup() {
  size(800, 800);
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(20);
  myClient = new Client(this, "127.0.0.1", 1234);
  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
}

void draw() {
  drawBoard();
  drawPieces();
  receiveMove();

  fill(0);
  if (turn) {
    text("Your Move", width/2, height/2-50);
  } 
  if (pawnpromotion) {
    fill(0);
    rect(width/2-150, height/2-150, 300, 300);
    fill(0,100);
    rect(0, 0, width, height);
    fill(255);
    text("Pawn Promotion (epic)", 375,300);
    text("Q = Queen", 350,325);
    text("N = Knight", 350,350);
    text("R = Rook", 350,375);
    text("B = Bishop", 350, 400);
  }
}

void receiveMove() {
  if (myClient.available() > 0) {
    String incoming = myClient.readString();
    int r1 = int(incoming.substring(0, 1));
    int c1 = int(incoming.substring(2, 3));
    int r2 = int(incoming.substring(4, 5));
    int c2 = int(incoming.substring(6, 7));
    int ctrl = int(incoming.substring(8, 9));   
    char smallpp = incoming.charAt(10);
    if (ctrl == 0) {
      grid[r2][c2] = grid[r1][c1];
      grid[r1][c1] = ' ';
      turn = true;
    } else if (ctrl == 1) {

      char tempE = grid[r2][c2];
      grid[r2][c2] = smallpp;
      grid[r1][c1] = tempE;
      turn = false;
    } else if (ctrl == 2) {
      if (r1 == 1) {
        grid[7][c2]='R';
      } else if (r1 == 2) {
        grid[7][c2]='B';
      } else if (r1 == 3) {
        grid[7][c2]='Q';
      } else if (r1 == 4) {
        grid[7][c2]='N';
      }
      turn = true;
    }
  }
}
void pawnPromotion() {
  if (key == 'r' || key == 'R') {
    grid[0][col2] = 'r';
    num =1;
  } else if (key == 'b' || key == 'B') {
    grid[0][col2] = 'b';
    num =2;
  } else if (key == 'q' || key == 'Q') {
    grid[0][col2] = 'q';
    num =3;
  } else if (key == 'n' || key == 'N') {
    grid[0][col2] = 'n';
    num =4;
  }
  myClient.write(num + "," + col1 + "," + row2 + "," + col2 + "," + "2" + "," + RAGERAGERAGE);
  pawnpromotion = false;
}
void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}
void mouseReleased() {
  if (firstClick) {
    row1 = mouseY/100;
    col1 = mouseX/100;
    firstClick = false;
  } else {
    row2 = mouseY/100;
    col2 = mouseX/100;
    if (!(turn && row2 == row1 && col2 == col1)) {
      RAGERAGERAGE = grid[row2][col2];
      if (grid[row1][col1] == 'p' && row2 == 0) {
        pawnpromotion = true;
      }
      grid[row2][col2] = grid[row1][col1];
      grid[row1][col1] = ' ';
      myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + ","+ "0"+ "," + RAGERAGERAGE);
      firstClick = true;
      turn = false;
    }
  }
}
void keyReleased() {
  if ((key == 'z' || key == 'Z') && !turn) {
    grid[row1][col1] = grid[row2][col2];
    grid[row2][col2] = RAGERAGERAGE;
    myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + "1" + "," + RAGERAGERAGE);
    turn = true;
  }
  if (pawnpromotion) {
    pawnPromotion();
  }
}
