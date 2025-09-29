int[][] grid = new int[9][9];
boolean[][] locked = new boolean[9][9];
int gridSize = 50;
int gridNumSize = 100;
int selectRow = -1;
int selectCol = -1;
int selectNum = 0;

void setup(){
    size(1000,500);
    newGame();
}

void draw(){
    background(255);
    drawGrid();
    drawNum();
    drawNumpadGrid();
    drawNumpadNum();
}

//display board

void drawGrid(){
    stroke(0);
    for(int i = 0; i <=9; i++){
        if(i%3==0){
          strokeWeight(3);
        }else{
          strokeWeight(1);
        }
        line(i*gridSize, 0, i*gridSize, 9*gridSize);
        line(0, i*gridSize, 9*gridSize, i*gridSize);
    }
}

void drawNum(){
    textAlign(CENTER,CENTER);
    textSize(24);
    fill(0);
    for(int row = 0; row < 9; row++){
        for(int col = 0; col < 9; col++){
            if(grid[row][col] != 0){
                text(grid[row][col], col*gridSize + gridSize/2, row*gridSize + gridSize/2);
            }
        }
    }
}

//Numpad

void drawNumpadGrid(){
    stroke(0);
    strokeWeight(3);
    for(int i = 0;i < 4; i++){
        line(i*gridNumSize+600,0,i*gridNumSize+600,4*gridNumSize);
    }
    for(int i = 0;i < 5; i++){
        line(600,i*gridNumSize,3*gridNumSize+600,i*gridNumSize);
    }
}

void drawNumpadNum(){
    textAlign(CENTER,CENTER);
    textSize(30);
    fill(0);
    int numpadNum = 1;
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < 3; j++){
          text(numpadNum, (j*gridNumSize)+600+(gridNumSize/2), (i*gridNumSize)+(gridNumSize/2));
          numpadNum++;
      }
    }
    text("-",600+gridNumSize+gridNumSize/2,3*gridNumSize+gridNumSize/2);
}

//Input number

void mousePressed(){
    if(mouseY < 9*gridSize && mouseX < 9*gridSize){
        if(!locked[floor(mouseY/gridSize)][floor(mouseX/gridSize)]){
            selectCol = floor(mouseX/gridSize);
            selectRow = floor(mouseY/gridSize);
        }else{
            println("Can't change this number");
        }
    }
    if(mouseY < 400 && mouseX > 600 && mouseX < 900){
        if(mouseY < 100){
            if(mouseX < 700){
                selectNum = 1;
            }else if(mouseX < 800){
                selectNum = 2;
            }else{
                selectNum = 3;
            }
        }else if(mouseY < 200){
            if(mouseX < 700){
                selectNum = 4;
            }else if(mouseX < 800){
                selectNum = 5;
            }else{
                selectNum = 6;
            }
        }else if(mouseY < 300){
            if(mouseX < 700){
                selectNum = 7;
            }else if(mouseX < 800){
                selectNum = 8;
            }else{
                selectNum = 9;
            }
        }else{
            if(mouseX > 700 && mouseX < 800){
                selectNum = 0;
            }
        }
    }
    if(selectRow != -1 && selectCol != -1){
        if(selectNum == 0 || checkValid(grid, selectNum, selectRow, selectCol)){
            grid[selectRow][selectCol] = selectNum;
            selectNum = 0;
        }else {
        if(selectRow != -1 && selectCol != -1){
            println("Invalid number");
            }
        }
    }
}

//Logic

boolean checkValid(int[][] arr, int num, int row, int col){
    for(int i = floor(row/3)*3; i < floor(row/3)*3+3; i++){
        for(int j = floor(col/3)*3; j < floor(col/3)*3+3; j++){
            if( arr[i][j] == num && !(i == row && j == col)){
                return false;
            }
        }
    }
    for(int j = 0; j < 9; j++){
        if(j != col && arr[row][j] == num) return false;
    }
    for(int i = 0; i < 9; i++){
        if(i != row && arr[i][col] == num) return false;
    }
    return true;
}

//random number and amount of number that appear

void shuffleArray(Integer[] arr) {
  for (int i = arr.length - 1; i > 0; i--) {
    int j = int(random(i+1));
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }
}

boolean generateFullBoard(int[][] board) {
  for (int row = 0; row < 9; row++) {
    for (int col = 0; col < 9; col++) {
      if (board[row][col] == 0) {
        Integer[] numbers = {1,2,3,4,5,6,7,8,9};
        shuffleArray(numbers);

        for (int n : numbers) {
          if (checkValid(board, n, row, col)) {
            board[row][col] = n;
            if (generateFullBoard(board)) return true;
            board[row][col] = 0;
          }
        }
        return false;
      }
    }
  }
  return true;
}

void newGame() {
  int[][] full = new int[9][9];
  generateFullBoard(full);

  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      grid[r][c] = full[r][c];
      locked[r][c] = true;
    }
  }
  int holes = 50;
  for (int k = 0; k < holes; k++) {
    int r = int(random(9));
    int c = int(random(9));
    grid[r][c] = 0;
    locked[r][c] = false;
  }
}
