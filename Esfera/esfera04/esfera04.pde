/*

Crear una malla esférica que admita texturas y relieves

*/

//Variables
float rad = 200;
float rad2, rad3;
int rows = 75;
int cols = rows;
float sepH = (rad*2)/rows;
float sepV = TWO_PI/cols;
float[][] ondulation; // array de cotas de relieve para la red
int maxBump = 25;
int minBump = -maxBump;
float wind = 0;
PImage img;

//Setup
void setup(){
  size(700,700, P3D);
  colorMode(HSB);
  stroke(0, 25);
  //noFill();
  fill(0);
  ondulation = new float [cols*2][rows*2+1]; // array bidimensional de nodos
  img = loadImage("../texturas/tex07.jpg");
}

//Loop
void draw(){
  background(0);
  lights();
  translate(width*0.5, height*0.5);
  rotateY(frameCount*0.01);
  rotateZ(frameCount*0.001);
  
  
  //Textura
  //poblar de datos el array
  float yoff = 0;
  for(int y = 0; y < rows*2+1; y++){
    float xoff= wind;
    for(int x = 0; x <=cols; x++){
      ondulation[x][y] = map(noise(xoff,yoff),0,1,minBump,maxBump);
      xoff += 0.1;
    }
   yoff += 0.1; 
  }
  wind-=0.025;
  
  
  //Esfera 

  for(int y = -rows; y<=rows-1; y++){
    int yy = int(map(y, -rows, rows, 0, rows-1));
    //MALLA  

       
    beginShape(TRIANGLE_STRIP);
    for(int x = 0; x<=cols; x++){
         int fillX = int(map(x, 0, cols, 0, img.width)); 
         int fillY = int(map(y, -rows, rows, 0, img.height)); 
         color c = img.get(fillX,fillY);
         fill(c);
        //DE PUNTOS
        //point(cos(TWO_PI/cols*x)*rad2+ondulation[x][yy], y*sepH , sin(TWO_PI/cols*x)*rad2+ondulation[x][yy]);
      
        vertex(  cos(TWO_PI/cols*x)*(rad2+ondulation[x][rows+y]),    y*sepH ,      sin(TWO_PI/cols*x)*(rad2+ondulation[x][rows+y])  );
        vertex(  cos(TWO_PI/cols*x)*(rad3+ondulation[x][rows+y+1]),  (y+1)*sepH ,  sin(TWO_PI/cols*x)*(rad3+ondulation[x][rows+y+1])  );
    }
    endShape();
    rad2 = sqrt((rad*rad) - (sepH*y)*(sepH*y));
    rad3 = sqrt((rad*rad) - (sepH*(y+1))*(sepH*(y+1)));
  } 
}

