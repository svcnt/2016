/*

Crear una malla esférica que admita texturas y relieves

*/

//Variables
int rad = 200;
int rows = 150;
int cols = rows;
float[][] ondulation; // array de cotas de relieve para la red
int maxBump = 25;
int minBump = -maxBump;
float wind = 0;

//Setup
void setup(){
  size(500,500, P3D);
  colorMode(HSB);
  stroke(255);
  strokeWeight(2);
  noFill();
  ondulation = new float [cols][rows]; // array bidimensional de nodos
}

//Loop
void draw(){
  background(0);
  translate(width*0.5, height*0.5);
  rotateY(frameCount*0.01);
  rotateZ(frameCount*0.001);
  
  
  //Textura
  //poblar de datos el array
  float yoff = 0;
  for(int y = 0; y < rows; y++){
    float xoff= wind;
    for(int x = 0; x < cols; x++){
      ondulation[x][y] = map(noise(xoff,yoff),0,1,minBump,maxBump);
      xoff += 0.1;
    }
   yoff += 0.1; 
  }
  wind-=0.025;
  
  
  //Esfera de puntos (NO MALLA)
  pushMatrix();
  for(int y = 0; y<rows; y++){
    pushMatrix();
    for(int x = 0; x<cols; x++){
      pushMatrix();
      float rad2 = rad+ondulation[x][y];
      float h = map(ondulation[x][y], minBump, maxBump, 0, 255);
      stroke(h, h, 126);
      translate(0, -rad2, 0);
      point(0, 0, 0);
      beginShape(QUAD_STRIP);
      endShape();
      popMatrix();
      rotateZ(TWO_PI/cols);
    }
    popMatrix();
    rotateX(TWO_PI/rows/2);
  }  
  popMatrix();
}
