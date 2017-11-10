class TTT{
  int x,y,w,h; // x, y coordinate of the board and width and height of the board;
  int state[][] = new int[3][3];
  int turn = 1;
  int winner = 0;
  boolean gameover = false;
  
  void setup(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;    
    /*
    for(int i=0; i<3; i++){
      for(int j=0; j<3; j++){
        state[i][j] = 2;   
      }
    }
    */
  }
  
  void drawBoard(){
    textSize(23);
    if(this.turn==1 && !this.gameover)
      text("Player: 1", 0, 23);
    else if(this.turn==2 && !this.gameover)
      text("Player: 2", 0, 23);
    else 
      text("Player "+this.winner+" Wins!", 0, 23);
    //x = this.x; y=this.y; w=this.w; h=this.h;
    stroke(0xff);
    line(x+w/3,y,x+w/3, y+h);
    line(x+2*w/3,y,x+2*w/3, y+h);
    line(x, y+h/3, x+w, y+h/3);
    line(x, y+2*h/3, x+w, y+2*h/3);

  }
  
  /*
  The drawState works as follows, since each segment is one third of the dimentions, so, we set the text size as 
  one fourth of the dimentions. Which is 0.25/0.33 = 0.75 = 75% of the size of the segment
  Therefore we are leaving 25% of the dimentions as padding.
  Since the alignment of text is done as left bottom, so, we use the formula x' = x+i*w/3+w/12 = x+(i+0.25)*w/3
  */
  void drawState(){
    textSize(w/4);
    for(int i=0; i<3; i++)
      for(int j=0; j<3; j++)
        if(state[i][j]==1)
          text("X", x+(i+0.25)*(w/3), y+(j+0.75)*h/3); 
        else if(state[i][j]==2)
          text("O", x+(i+0.25)*(w/3), y+(j+0.75)*h/3);
  }
  
  public int[] getCoords(int mX,int mY){
    int dX = (int) (mX-x)/(w/3);
    int dY = (int) (mY-y)/(h/3);
    int[] c=  {dX, dY};
    //print(dX+" "+dY+"\n");
    return c;
  }
  
  int checkBoard(){
    
    // check horizontal
    for(int i=0; i<3; i++){
      if(state[i][0]==state[i][1] && state[i][0]==state[i][2] && state[i][0] != 0){
        return state[i][0]; 
      }
    }
    
    // check vertical
    for(int i=0; i<3; i++){
      if(state[0][i]==state[1][i] && state[0][i]==state[2][i] && state[0][i] != 0){
        return state[0][i]; 
      }
    }
    
    // check diagonal 1
    if(state[0][0] == state[1][1] && state[0][0] == state[2][2])
      return state[0][0];
   
   // check diagonal 2
    if(state[0][2] == state[1][1] && state[0][2] == state[2][0])
      return state[0][2];
    
    // doesn't match
    return -1;
  }
  
  void switchTurns(){
    this.turn = this.turn ^ 3;
    /*
      EXPLANATION: Whenever we need to switch players, we need to switch between 1 and 2 only (you can't have 3 players here)
      so, the result is either 0b01 or 0b10 since we can see a two bit cyclic order, we can just simply exor it with 0b11
      EXOR'ing with 0b11 will switch the bits back and forth and this is massively faster than checking if turn is 1 then setting 2 and vice versa
      there is just one fast bit operation and 
    */
  }
  void getInput(int mX, int mY){
    if(!(mX<x || mX>x+w || mY<y || mY > y+h) && !gameover){ // check bounds
      int[] co = this.getCoords(mX, mY);
      int i = co[0];
      int j = co[1];
      if(state[i][j] == 0){
        state[i][j] = this.turn;
        this.switchTurns();
        // we have to check if this game has a winner
        int r = this.checkBoard();
        
        if(r == 1 || r==2){
          this.gameover=true;
          this.winner = r;
          print("Player "+r+" wins!");
        }
      }
    }
  }
  
}

TTT game = new TTT();
boolean clicked = false;

void setup(){
  size(300, 350);
  game.setup(0, 50, 300, 300);
}

void draw(){
  background(0);
  stroke(0xff);
  game.drawBoard();
  game.drawState();
}

void mouseClicked(){
  game.getInput(mouseX, mouseY); 
}