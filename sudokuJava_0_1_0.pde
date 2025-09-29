int[][] grid = new int[9][9];
int gridSize = 50;
int gridNumSize = 100;

void setup(){
    size(1000,500);
    createBoard();
}

void draw(){
    background(255);
    drawGrid();
    drawNum();
}

void createBoard(){
    for(int row = 0; row < 9; row++){
        for(int col = 0; col < 9; col++){
            if(int(random(9)) < 5){
                grid[row][col] = int(random(1,10));
                while(!checkValid(grid, grid[row][col], row, col)){
                    grid[row][col] = int(random(1,10));
                }
            }else{
                grid[row][col] = 0;
            }
        }
    }
}

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
