int[][] grid = new int[9][9];
boolean[][] locked = new boolean[9][9];
int gridSize = 50;
int gridNumSize = 100;
int selectRow = -1;
int selectCol = -1;
int selectNum = 0;
boolean answer = true;
boolean stage = false;
int dificulty = 0;
int menuY = 0;

void setup(){
    size(1000,500);
    stage = false;
    menuY = height;
}

void draw(){
    if(!stage){
        if(menuY < height){
        menuY+=20;
        }else background(0);
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
          menuY-=20;
        }
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
    textSize(24);
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
        line(i*gridNumSize+600,0,i*gridNumSize+600,4*gridNumSize);
        i++;
    }
    i = 0;
    while(i < 5){
        line(600,i*gridNumSize,3*gridNumSize+600,i*gridNumSize);
        i++;
    }
}

void drawNumpadNum(){
    textAlign(CENTER,CENTER);
    textSize(30);
    fill(0);
    int numpadNum = 1;
    int i = 0;
    while(i < 3){
      int j = 0;
      while(j < 3){
          text(numpadNum, (j*gridNumSize)+600+(gridNumSize/2), (i*gridNumSize)+(gridNumSize/2));
          numpadNum++;
          j++;
      }
      i++;
    }
    text("-",600+gridNumSize+gridNumSize/2,3*gridNumSize+gridNumSize/2);
}

//Input number

void mousePressed(){
    if(!stage){
        if(mouseX >= width/2-100 && mouseY >= menuY-270 && mouseX <= width/2+100 && mouseY <= menuY-230){
            stage = true;
            newGame();
        }
        if(mouseX >= width/2-100 && mouseY >= menuY-220 && mouseX <= width/2+100 && mouseY <= menuY-180){
            stage = true;
            selectInput("Select game file: ","fileSelected");
        }
    }
    if(stage){
        if(mouseY < 9*gridSize && mouseX < 9*gridSize){
            if(!locked[floor(mouseY/gridSize)][floor(mouseX/gridSize)]){
                selectCol = floor(mouseX/gridSize);
                selectRow = floor(mouseY/gridSize);
                answer = true;
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
                answer = true;
            }else {
            if(selectRow != -1 && selectCol != -1){
                selectNum = 0;
                println("Invalid number");
                answer = false;
                }
            }
        }
        if(mouseX >= width/2+gridNumSize && mouseY >= height-70 && mouseX <= width/2+gridNumSize*2 && mouseY <= height-30){
            saveGame();
        }
        if(mouseX >= width/2+gridNumSize*3 && mouseY >= height-70 && mouseX <= width/2+gridNumSize*4 && mouseY <= height-30){
            stage = false;
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
    textSize(50);
    fill(255);
    text("A2 Sudoku the Game",width/2,menuY-400);
    textSize(25);
    rect(width/2-100,menuY-270,200,40);
    rect(width/2-100,menuY-220,200,40);
    fill(0);
    text("New Game",width/2,menuY-250);
    text("Load Game",width/2,menuY-200);
}

//load game

void fileSelected(File selection){
    if(selection != null){
        println("Loading: "+ selection.getAbsolutePath());
        loadGame(selection.getAbsolutePath());
    }
}

void loadGame(String filename) {
  String[] lines = loadStrings(filename);
  for (int r = 0; r < 9; r++) {
    String[] parts = split(lines[r], "|");
    String[] nums = split(trim(parts[0]), " ");
    String[] locks = split(trim(parts[1]), " ");

    for (int c = 0; c < 9; c++) {
      grid[r][c] = int(nums[c]);
      locked[r][c] = (int(locks[c]) == 1);
    }
  }
  stage = true;
  println("Game loaded successfully");
}

//save game

void saveGame() {
  selectOutput("Save your Sudoku game:", "fileSaveSelected");
}

void fileSaveSelected(File selection) {
  if (selection == null) {
    println("Save canceled.");
    return;
  }

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

  saveStrings(selection.getAbsolutePath(), lines);
  println("Game saved to " + selection.getAbsolutePath());
}

void drawSaveButton(){
    fill(255);
    rect(width/2+gridNumSize, height-70, gridNumSize, 40);
    fill(0);
    textSize(20);
    text("Save Game", width/2+gridNumSize+gridNumSize/2, height-50);
}

void drawMenuButton(){
    fill(255);
    rect(width/2+gridNumSize*3, height-70, gridNumSize, 40);
    fill(0);
    textSize(20);
    text("Menu", width/2+gridNumSize*3+gridNumSize/2, height-50);
}
