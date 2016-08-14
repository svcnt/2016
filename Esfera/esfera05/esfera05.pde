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
float maxBump = 1.5;
float minBump = 0.25;
float wind = 0;
PImage img;
PVector[][] vecs, vecs2; // array de vectores de posición

//Setup
void setup(){
  size(700,700, P3D);
  colorMode(HSB);
  stroke(0, 0);
  //noFill();
  fill(0);
  ondulation = new float [cols*2][rows*2+1]; // array bidimensional de nodos
  vecs = new PVector[cols*2][rows*2+1];
  vecs2 = new PVector[cols*2][rows*2+1];
  img = loadImage("../texturas/tex07.jpg");
}

//Loop
void draw(){
  background(0);
  lights();
  translate(width*0.5, height*0.5);
  //rotateY(frameCount*0.01);
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
  wind-=0.05;
  
  //Relieve
  for (int y = -rows; y <= rows-1; y++){
    for(int x = 0; x <= cols; x++){
      vecs[x][rows+y] = new PVector(cos(TWO_PI/cols*x)*(rad2),    y*sepH ,      sin(TWO_PI/cols*x)*(rad2));
      vecs[x][rows+y].mult(ondulation[x][rows+y]);
      vecs2[x][rows+y] = new PVector(cos(TWO_PI/cols*x)*(rad3),    (y+1)*sepH ,      sin(TWO_PI/cols*x)*(rad3));
      vecs2[x][rows+y].mult(ondulation[x][rows+y+1]);
    }
    rad2 = sqrt((rad*rad) - (sepH*y)*(sepH*y));
    rad3 = sqrt((rad*rad) - (sepH*(y+1))*(sepH*(y+1)));
  }
  
  
  //Esfera 

  for(int y = -rows; y<=rows-1; y++){
    //MALLA  
    beginShape(QUAD_STRIP);
    for(int x = 0; x<=cols; x++){
         int fillX = int(map(x, 0, cols, 0, img.width)); 
         int fillY = int(map(y, -rows, rows, 0, img.height)); 
         color c = img.get(fillX,fillY);
         fill(c);
        //DE PUNTOS
        //point(cos(TWO_PI/cols*x)*rad2+ondulation[x][yy], y*sepH , sin(TWO_PI/cols*x)*rad2+ondulation[x][yy]);
      
        //vertex(  cos(TWO_PI/cols*x)*(rad2+ondulation[x][rows+y]),    y*sepH ,      sin(TWO_PI/cols*x)*(rad2+ondulation[x][rows+y])  );
        //vertex(  cos(TWO_PI/cols*x)*(rad3+ondulation[x][rows+y+1]),  (y+1)*sepH ,  sin(TWO_PI/cols*x)*(rad3+ondulation[x][rows+y+1])  );
        vertex( vecs[x][rows+y].x, vecs[x][rows+y].y, vecs[x][rows+y].z );
        vertex( vecs2[x][rows+y].x, vecs2[x][rows+y].y, vecs2[x][rows+y].z );
    }
    endShape();
    rad2 = sqrt((rad*rad) - (sepH*y)*(sepH*y));
    rad3 = sqrt((rad*rad) - (sepH*(y+1))*(sepH*(y+1)));
  } 
}

