int[][] grid = new int[9][9];
boolean[][] locked = new boolean[9][9];
int gridNumSize;
int selectRow = -1;
int selectCol = -1;
int selectNum = 0;
boolean answer = true;
boolean stage = false;
int dificulty;
int menuY = 0;
int gridSize;
boolean menuAni;


void setup(){
    size(width,height);
    gridSize = width/9;
    gridNumSize = width/5;
    stage = false;
    menuY = height;
}

void draw(){
    if(!stage){
        if(menuY < height){
            menuY+=height/25;
        }else{
            background(0);
            menuAni = true;
        }
        openMenu();
    }
    if(stage){
        background(255);
        drawGameUI();
        drawGrid();
        drawNum();
        drawNumpadGrid();
        drawNumpadNum();
        drawSaveButton();
        drawMenuButton();
        openMenu();
        if(menuY > 0){
          openMenu();
          menuY-=height/25;
        }else menuAni = true;
    }
}

//display board

void drawGrid(){
    stroke(0);
    int i = 0;
    while(i <= 9){
        if(i%3==0){
          strokeWeight(3);
        }else{
          strokeWeight(1);
        }
        line(i*gridSize, 0, i*gridSize, 9*gridSize);
        line(0, i*gridSize, 9*gridSize, i*gridSize);
        i++;
    }
}

void drawNum(){
    textAlign(CENTER,CENTER);
    textSize(gridSize/2);
    fill(0);
    int row = 0;
    while(row < 9){
        int col = 0;
        while(col < 9){
            if(grid[row][col] != 0){
                text(grid[row][col], col*gridSize + gridSize/2, row*gridSize + gridSize/2);
            }
            col++;
        }
        row++;
    }
}

//Numpad

void drawNumpadGrid(){
    stroke(0);
    strokeWeight(3);
    int i = 0;
    while(i < 4){
        line(i*gridNumSize+gridNumSize,height/2+height/10,i*gridNumSize+gridNumSize,4*gridNumSize+height/2+height/10);
        i++;
    }
    i = 0;
    while(i < 5){
        line(gridNumSize,i*gridNumSize+height/2+height/10,4*gridNumSize,i*gridNumSize+height/2+height/10);
        i++;
    }
}

void drawNumpadNum(){
    textAlign(CENTER,CENTER);
    textSize(gridNumSize/2);
    fill(0);
    int numpadNum = 1;
    int i = 0;
    while(i < 3){
      int j = 0;
      while(j < 3){
          text(numpadNum, j*gridNumSize+gridNumSize/2+gridNumSize, height/2+height/10+i*gridNumSize+gridNumSize/2);
          numpadNum++;
          j++;
      }
      i++;
    }
    text("-", gridNumSize*2+gridNumSize/2, height-gridNumSize/2);
}

//Input number

void mousePressed(){
    if(!stage){
        if(mouseX >= width/2-200 && mouseY >= menuY-height/2 && mouseX <= width/2+200 && mouseY <=  menuY-height/2+100){
            stage = true;
            menuAni = false;
            newGame();
        }
        if(mouseX >= width/2-200 && mouseY >= menuY-height/2+150 && mouseX <= width/2+200 && mouseY <= menuY-height/2+250){
            loadGame();
            stage = true;
            menuAni = false;
        }
    }
    if(stage && menuAni){
        if(mouseY < 9*gridSize && mouseX < 9*gridSize){
            if(!locked[floor(mouseY/gridSize)][floor(mouseX/gridSize)]){
                selectCol = floor(mouseX/gridSize);
                selectRow = floor(mouseY/gridSize);
                answer = true;
            }else{
                println("Can't change this number");
            }
        }
        if(mouseY < height/2+gridNumSize*5 && mouseX > gridNumSize && mouseX < gridNumSize*4 && mouseY > height/2+gridNumSize){
            if(mouseY < height/2+height/10+gridNumSize){
                if(mouseX < gridNumSize*2){
                    selectNum = 1;
                }else if(mouseX < gridNumSize*3){
                    selectNum = 2;
                }else{
                    selectNum = 3;
                }
            }else if(mouseY < height/2+height/10+gridNumSize*2){
                if(mouseX < gridNumSize*2){
                    selectNum = 4;
                }else if(mouseX < gridNumSize*3){
                    selectNum = 5;
                }else{
                    selectNum = 6;
                }
            }else if(mouseY < height/2+height/10+gridNumSize*3){
                if(mouseX < gridNumSize*2){
                    selectNum = 7;
                }else if(mouseX < gridNumSize*3){
                    selectNum = 8;
                }else{
                    selectNum = 9;
                }
            }else{
                if(mouseX > gridNumSize*2 && mouseX < gridNumSize*3){
                    selectNum = 0;
                }
            }
        
            if(selectRow != -1 && selectCol != -1){
                if(selectNum == 0 || checkValid(grid, selectNum, selectRow, selectCol)){
                    grid[selectRow][selectCol] = selectNum;
                    selectNum = 0;
                    answer = true;
                }else {
                if(selectRow != -1 && selectCol != -1){
                    selectNum = 0;
                    println("Invalid number");
                    answer = false;
                    }
                }
            }
        }
        if(mouseX >= gridNumSize/2 && mouseX <= gridNumSize/2+gridNumSize*2 && mouseY >= height/2 && mouseY <= height/2+gridNumSize/2){
            saveGame();
        }
        if(mouseX >= gridNumSize/2+gridNumSize*2 && mouseX <= gridNumSize/2+gridNumSize*4 && mouseY >= height/2 && mouseY <= height/2+gridNumSize/2){
            stage = false;
            menuAni = false;
        }
    }
}

//Logic

boolean checkValid(int[][] arr, int num, int row, int col){
    int i = floor(row/3)*3;
    while(i < floor(row/3)*3+3){
        int j = floor(col/3)*3;
        while(j < floor(col/3)*3+3){
            if( arr[i][j] == num && !(i == row && j == col)){
                return false;
            }
            j++;
        }
        i++;
    }
    int j = 0;
    while(j < 9){
        if(j != col && arr[row][j] == num) return false;
        j++;
    }
    i = 0;
    while(i < 9){
        if(i != row && arr[i][col] == num) return false;
        i++;
    }
    return true;
}

//random number and amount of number that appear

void shuffleArray(Integer[] arr) {
  int i = arr.length - 1;
  while(i > 0) {
    int j = int(random(i+1));
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
    i--;
  }
}

boolean generateFullBoard(int[][] board) {
  int row = 0;
  while(row < 9) {
    int col = 0;
    while(col < 9) {
      if (board[row][col] == 0) {
        Integer[] numbers = {1,2,3,4,5,6,7,8,9};
        shuffleArray(numbers);

        int i = 0;
        while (i < numbers.length) {
          int n = numbers[i];
          if (checkValid(board, n, row, col)) {
            board[row][col] = n;
            if (generateFullBoard(board)) return true;
            board[row][col] = 0;
          }
          i++;
        }
        return false;
      }
      col++;
    }
    row++;
  }
  return true;
}

void newGame() {
    int[][] full = new int[9][9];
    generateFullBoard(full);

    int r = 0;
    while(r < 9) {
        int c = 0;
        while(c < 9){
            grid[r][c] = full[r][c];
            locked[r][c] = true;
            c++;
        }
        r++;
    }
    int holes = 50;
    int k = 0;
    while(k < holes) {
        r = int(random(9));
        int c = int(random(9));
        grid[r][c] = 0;
        locked[r][c] = false;
        k++;
    }
}

//In game UI

void drawGameUI(){
    if (selectRow != -1 && selectCol != -1) {
        if(answer){
            fill(200, 200, 255, 100);
        }else{
            fill(225,0,0,100);
        }
        noStroke();
        rect(selectCol*gridSize, selectRow*gridSize, gridSize, gridSize);
    }
    int row = 0;
    while(row < 9){
        int col = 0;
        while(col < 9){
            if(locked[row][col]){
                fill(225);
                noStroke();
                rect(col*gridSize, row*gridSize, gridSize, gridSize);
            }
            col++;
        }
        row++;
    }
}

//menu

void openMenu(){
    fill(0);
    rect(0,0,width,menuY);
    textAlign(CENTER,CENTER);
    textSize(75);
    fill(255);
    text("A2 Sudoku the Game",width/2,menuY-height*3/4);
    textSize(50);
    rect(width/2-200,menuY-height/2,400,100);
    rect(width/2-200,menuY-height/2+150,400,100);
    fill(0);
    text("New Game",width/2,menuY-height/2+50);
    text("Load Game",width/2,menuY-height/2+200);
}

//load game

void loadGame() {
  String path = sketchPath("saved_sudoku.txt");
  String[] lines = null;

  try {
    lines = loadStrings(path);
  } catch (Exception e) {
    println("No saved game found at: " + path);
    return;
  }

  for (int r = 0; r < 9; r++) {
    String[] parts = split(lines[r], "|");
    String[] nums = split(trim(parts[0]), " ");
    String[] locks = split(trim(parts[1]), " ");
    for (int c = 0; c < 9; c++) {
      grid[r][c] = int(nums[c]);
      locked[r][c] = (int(locks[c]) == 1);
    }
  }

  println("Game loaded successfully!");
}

//save game

void saveGame() {
  String[] lines = new String[9];
  for (int r = 0; r < 9; r++) {
    String row = "";
    for (int c = 0; c < 9; c++) {
      row += grid[r][c];
      if (c < 8) row += " ";
    }
    row += " | ";
    for (int c = 0; c < 9; c++) {
      row += (locked[r][c] ? 1 : 0);
      if (c < 8) row += " ";
    }
    lines[r] = row;
  }

  saveStrings(sketchPath("saved_sudoku.txt"), lines);
  println("Game saved to: " + sketchPath("saved_sudoku.txt"));
}

void drawSaveButton(){
    fill(255);
    rect(gridNumSize/2, height/2, gridNumSize*2, gridNumSize/2);
    fill(0);
    textSize(gridNumSize/5);
    text("Save Game", gridNumSize+gridNumSize/2, height/2+gridNumSize/4);
}

void drawMenuButton(){
    fill(255);
    rect(gridNumSize/2+gridNumSize*2, height/2, gridNumSize*2, gridNumSize/2);
    fill(0);
    textSize(gridNumSize/5);
    text("Menu", gridNumSize*3+gridNumSize/2, height/2+gridNumSize/4);
}
