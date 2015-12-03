PImage st2,st1,ed2,ed1;
PImage treasure,fighter,enemy;
PImage bg1,bg2; 
PImage bullet;
PImage hp;

PFont board;
int score = 0;
int hpline;

int backOneX = 0;
int backTwoX = -640;

float treasureX,treasureY;
float fighterX,fighterY;
float enemyY;
float [] bulletX = new float [5];
float [] bulletY = new float [5];

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState;

final int C = 0;
final int B = 1;
final int A = 2;
int enemyState;

//enemy
PImage [] enemyPosition = new PImage [5];
float enemyOne [][] = new float [5][2];       
float enemyTwo [][] = new float [5][2];
float enemyThree [][] = new float [8][2];  
float spacingX,spacingY;

//speed
float fighterSpeed;
float enemySpeed;
int bulletSpeed;

//bullet number
int bulletNum = 0;
boolean [] bulletNumlimit = new boolean[5];

//flame
int flameNum;
int flameCurrent;
PImage [] hit = new PImage [5];
float hitPosition [][] = new float [5][2]; 

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;



void setup () {    
  size (640,480) ;
  frameRate(60);
     
  
  st2 = loadImage ("img/start2.png");
  st1 = loadImage ("img/start1.png");  
  bg1 = loadImage ("img/bg1.png");
  bg2 = loadImage ("img/bg2.png");
  ed2 = loadImage ("img/end2.png");
  ed1 = loadImage ("img/end1.png");
  hp = loadImage ("img/hp.png");
  treasure = loadImage ("img/treasure.png");
  fighter = loadImage ("img/fighter.png");
  enemy = loadImage ("img/enemy.png");  
  bullet = loadImage ("img/shoot.png");
  
   for ( int i = 0; i < 5; i++ ){
    hit[i] = loadImage ("img/flame" + (i+1) + ".png" );
  }
  
  gameState = GAME_START;
  enemyState = C;
  hpline = 40; 
  fighterX = 589 ;
  fighterY = 240 ; 
  treasureX = floor( random(65, 600) );
  treasureY = floor( random(65, 400) );


  //speed
  fighterSpeed = 10;
  enemySpeed = 6;
  bulletSpeed = 15;

  //flame
  flameNum = 0;
  flameCurrent = 0;
  for ( int i = 0; i < hitPosition.length; i ++){
    hitPosition[i][0] = 1200;
    hitPosition[i][1] = 1200;
  }
  
  //enemy line
  spacingX = 0;  
  spacingY = -70; 
  enemyY = floor(random(120, 420));
  
  for (int i = 0; i < 5; i++){
   enemyPosition [i] = loadImage ("img/enemy.png");  
   enemyOne [i][0] = spacingX;
   enemyOne [i][1] = enemyY; 
   spacingX -= 70;
  }

  //no bullets
  for (int j =0; j < bulletNumlimit.length ; j ++){
    bulletNumlimit[j] = false;
  }

  board = createFont("Georgia", 28);
  textFont(board, 28);
  textAlign(LEFT);
}


void draw() {  
  switch (gameState) {
    case GAME_START:
      image (st2, 0, 0);     
      if (mouseX>210 && mouseX<430 && mouseY > 380 && mouseY < 425){
            image(st1, 0, 0);
            if(mousePressed){
              gameState = GAME_RUN;
            }
      }
    break;  
    
    
    case GAME_RUN:
    
      //background
     image(bg1, backOneX, 0);
     image(bg2, backTwoX, 0);
     backOneX++;backTwoX++;
     if(backOneX>640){backOneX=-640;backOneX++;}
     if(backTwoX>640){backTwoX=-640;backTwoX++;}
      
      //fighter
      image(fighter, fighterX, fighterY);
      
      //treasure
      image (treasure, treasureX, treasureY);    
 
      if (leftPressed && fighterX > 0) {
        fighterX -= fighterSpeed ;
      }
      if (rightPressed && fighterX < 589) {
        fighterX += fighterSpeed ;
      }  
      if (upPressed && fighterY > 0) {
        fighterY -= fighterSpeed ;
      }
      if (downPressed && fighterY < 429) {
        fighterY += fighterSpeed ;
      }
        
      //flame
      image(hit[flameCurrent], hitPosition[flameCurrent][0], hitPosition[flameCurrent][1]);      
      flameNum ++;
      if ( flameNum % 6 == 0){
        flameCurrent ++;
      } 
      if ( flameCurrent > 4){
        flameCurrent = 0;
      }

      //buring
      if(flameNum > 31){
        for (int j = 0; j < 5; j ++){
          hitPosition[j][0] = 1200;
          hitPosition[j][1] = 1200;
        }
      }   
      
      //bullets
      for (int i = 0; i < 5; i ++){
        if (bulletNumlimit[i] == true){
          image (bullet, bulletX[i], bulletY[i]);
          bulletX[i] -= bulletSpeed;
        }
        if (bulletX[i] < - bullet.width){
          bulletNumlimit[i] = false;
        }
      }
      
      //enemy
      switch (enemyState) { 
        case C :               
          for ( int i = 0; i < 5; i++ ){
            image(enemyPosition[i], enemyOne [i][0], enemyOne [i][1]);
           
       //bullet hits
       for (int j = 0; j < 5; j++ ){
          if(bulletX[j] >= enemyOne [i][0] - bullet.width && bulletX[j] <= enemyOne[i][0] + enemy.width 
           && bulletY[j] >= enemyOne [i][1] - bullet.height && bulletY[j] <= enemyOne [i][1] + enemy.height && bulletNumlimit[j] == true){
       for (int c = 0;  c < 5; c++ ){
           hitPosition [c][0] = enemyOne [i][0];
           hitPosition [c][1] = enemyOne [i][1];
                }    
           enemyOne [i][1] = -1200;
           enemyY = floor(random(35,260));
           bulletNumlimit[j] = false;
           flameNum = 0; 
           scoreChange(20);
              }
            }
            
        //fighter be hit
        if(fighterX >= enemyOne [i][0] - fighter.width && fighterX <= enemyOne[i][0] + enemy.width 
           && fighterY >= enemyOne [i][1] - fighter.height && fighterY <= enemyOne [i][1] + enemy.height){
        for (int j = 0;  j < 5; j++){
           hitPosition [j][0] = enemyOne [i][0];
           hitPosition [j][1] = enemyOne [i][1];
              }
              hpline -= 40;          
              enemyOne [i][1] = -1200;
              enemyY = floor( random(35,260) );
              flameNum = 0; 
            }
            else if(hpline <= 0){
              gameState = GAME_OVER;
              hpline = 40;
              fighterX = 589;
              fighterY = 240 ;
            } 
            else {
              enemyOne [i][0] += enemySpeed;
              enemyOne [i][0] %= 1280;
            }      
          }
          
          //to B
          if (enemyOne [enemyOne.length-1][0] > 800 ) {        
            enemyY = floor(random(35,260));            
            spacingX = 0;  
            for (int s = 0; s < 5; s++){
              enemyTwo [s][0] = spacingX;
              enemyTwo[s][1] = enemyY - spacingX / 2;
              spacingX -= 75;                 
            }
            
            enemyState = B;
          }
        break ; 
        
        case B :
          for (int i = 0; i < 5; i++ ){
            image(enemyPosition[i], enemyTwo [i][0] , enemyTwo [i][1]);
            
            //bullet hit
            for(int j = 0; j < 5; j++){
              if ( bulletX[j] >= enemyTwo [i][0] - bullet.width && bulletX[j] <= enemyTwo[i][0] + enemy.width 
                && bulletY[j] >= enemyTwo [i][1] - bullet.height && bulletY[j] <= enemyTwo [i][1] + enemy.height && bulletNumlimit[j] == true){
            for(int k = 0;  k < 5; k++ ){
              hitPosition [k][0] = enemyTwo [i][0];
              hitPosition [k][1] = enemyTwo [i][1];
                }  
                
              enemyTwo [i][1] = -1200;
              enemyY = floor(random(35,260));
              bulletNumlimit[j] = false;
              flameNum = 0;
              scoreChange(20);
              }
            } 
            
            //fighter be hit
            if ( fighterX >= enemyTwo [i][0] - fighter.width && fighterX <= enemyTwo[i][0] + enemy.width 
              && fighterY >= enemyTwo [i][1] - fighter.height && fighterY <= enemyTwo [i][1] + enemy.height){
            for (int v = 0;  v < 5; v++ ){
                 hitPosition [v][0] = enemyTwo [i][0];
                 hitPosition [v][1] = enemyTwo [i][1];
               }
               
              enemyTwo [i][1] = -1200;
              enemyY = floor(random(210,300));
              flameNum = 0; 
              hpline -= 40;
            }
            else if(hpline<= 0){
              gameState = GAME_OVER;
              fighterX = 589;
              fighterY =240 ;
              hpline = 40;
            } 
            else {
              enemyTwo [i][0] += enemySpeed;
              enemyTwo [i][0] %= 1280;
            }         
          }
          
          //to A
          if (enemyTwo [4][0] > 800){
            enemyY = floor( random(210,300) );
            enemyState = A;            
            spacingX = 0;  
            spacingY = -60; 
            for ( int i = 0; i < 8; i ++ ) {
              if ( i < 3 ) {
                enemyThree [i][0] = spacingX;
                enemyThree [i][1] = enemyY - spacingX;
                spacingX -= 65;
              }
              else if ( i == 3 ){
                enemyThree [i][0] = spacingX;
                enemyThree [i][1] = enemyY - spacingY;
                spacingX -= 70;
                spacingY += 70;
              } 
              else if ( i > 3 && i <= 5 ){
                  enemyThree [i][0] = spacingX;
                  enemyThree [i][1] = enemyY + spacingY;
                  spacingX += 70;
                  spacingY -= 70;
              } 
              else {
                  enemyThree [i][0] = spacingX;
                  enemyThree [i][1] = enemyY + spacingY;
                  spacingX += 70;
                  spacingY += 70;
              }            
            }     
          }
        break ;        
        
        case A :  
          for( int i = 0; i < 8; i++ ){
            image(enemy, enemyThree [i][0], enemyThree [i][1]);     
            
            //bullet hit     
            for( int j = 0; j < 5; j++ ){
              if ( bulletX[j] >= enemyThree [i][0] - bullet.width && bulletX[j] <= enemyThree [i][0] + enemy.width 
                && bulletY[j] >= enemyThree [i][1] - bullet.height && bulletY[j] <= enemyThree [i][1] + enemy.height && bulletNumlimit[j] == true){
                for (int s = 0;  s < 5; s++){
                  hitPosition [s][0] = enemyThree [i][0];
                  hitPosition [s][1] = enemyThree [i][1];
                }
                
                enemyThree [i][1] = -1200;
                enemyY = floor( random(45,240));
                bulletNumlimit[j] = false;
                flameNum = 0; 
                scoreChange(20);
              }
            }       
            
            //fighter be hit
            if ( fighterX >= enemyThree [i][0] - fighter.width && fighterX <= enemyThree[i][0] + enemy.width 
              && fighterY >= enemyThree [i][1] - fighter.height  && fighterY <= enemyThree [i][1] + enemy.height){ 
            for ( int m = 0;  m < 5; m++ ){
              hitPosition [m][0] = enemyThree [i][0];
              hitPosition [m][1] = enemyThree [i][1];
              }
              
              hpline -= 40;
              enemyThree [i][1] = -1200;
              enemyY = floor(random(55,420));
              flameNum = 0; 
            } 
            else if ( hpline <= 0 ) {
              gameState = GAME_OVER;
              fighterX = 589 ;
              fighterY = 240 ;
              hpline = 40;
            } 
            else {
              enemyThree [i][0] += enemySpeed;
              enemyThree [i][0] %= 1920;
            }     
          }
          
          //to C
          if(enemyThree [4][0] > 800 ){
            enemyY = floor(random(80,425));
            spacingX = 0;       
          for (int i = 0; i < 5; i++ ){
            enemyOne [i][1] = enemyY; 
            enemyOne [i][0] = spacingX;
            spacingX -= 70;
            } 
            
            enemyState = C;            
          }  
        break ;
      }

     //hp
      fill(#FF0000); 
      rect(16,10,hpline,20); 
      image(hp,10,10); 
      
     //eats treasure
     if(treasureX+41>=fighterX && treasureX<=fighterX+51 && treasureY+41>=fighterY && treasureY<=fighterY+51){
     hpline+=20;
     treasureX=int(random(580));
     treasureY=int(random(430));
     
 }
      if(hpline >= 200){
        hpline = 200;
      }
      
      fill(#FFFF00);
      text("Score:" + score, 15, 465);
    break ;  
    
    
    case GAME_OVER :
      image(ed2, 0, 0);     
      if (mouseX >= width/3 && mouseX <= 2*width/3 && mouseY >=315 && mouseY <=350){
            image(ed1, 0, 0);
      if(mousePressed){
       treasureX = int(random(580));
       treasureY = int(random(430));    
       enemyState = 0;      
       spacingX = 0;       
            
      for (int i = 0; i < 5; i++ ){
      hitPosition [i][0] = 1200;
      hitPosition [i][1] = 1200;
      bulletNumlimit[i] = false;
      enemyOne [i][0] = spacingX;
      enemyOne [i][1] = enemyY; 
      spacingX -= 70;
      score = 0;
              }
              
              gameState = GAME_RUN;
            }
      }
    break ;
  }  
}


void keyPressed (){
  if (key == CODED) {
    switch ( keyCode ) {
      case UP :
        upPressed = true ;
        break ;
      case DOWN :
        downPressed = true ;
        break ;
      case LEFT :
        leftPressed = true ;
        break ;
      case RIGHT :
        rightPressed = true ;
        break ;
    }
  }
}
  
  
void keyReleased () {
  if (key == CODED) {
    switch ( keyCode ) {
      case UP : 
        upPressed = false ;
        break ;
      case DOWN :
        downPressed = false ;
        break ;
      case LEFT :
        leftPressed = false ;
        break ;
      case RIGHT :
        rightPressed = false ;
        break ;
    }  
  }  
  
  //shoot 
  if ( keyCode == ' '){
    if (gameState == GAME_RUN){
      if (bulletNumlimit[bulletNum] == false){
        bulletNumlimit[bulletNum] = true;
        bulletX[bulletNum] = fighterX - 15;
        bulletY[bulletNum] = fighterY + fighter.height/4;
        bulletNum ++;
        
      } 
      
      if ( bulletNum > 4 ) {
        bulletNum = 0;
      }
    }
  }
}

void scoreChange(int sc){
  score += sc;
}
