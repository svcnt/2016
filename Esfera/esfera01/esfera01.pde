/*

Crear una malla esférica que admita texturas y relieves

*/

//Variables
int rad = 200;
int rows = 150;
int cols = rows;
float[][] ondulation; // array de cotas de relieve para la red
int maxBump = 50;
int minBump = -maxBump;
float wind = 0;

//Setup
void setup(){
  size(500,500, P3D);
  stroke(255);
  //strokeWeight(5);
  noFill();
  ondulation = new float [cols][rows]; // array bidimensional de nodos
}

//Loop
void draw(){
  background(0);
  translate(width*0.5, height*0.5);
  rotateY(frameCount*0.01);
  
  
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
  
  
  //Esfera (NO MALLA)
  pushMatrix();
  for(int y = 0; y<rows; y++){
    pushMatrix();
    //point(0,0,0);
    for(int x = 0; x<rows; x++){
      pushMatrix();
      float rad2 = rad+ondulation[x][y];
      translate(rad2, 0, 0);
      point(0, 0, 0);
      //pushMatrix();
      //rotateY(HALF_PI);
      //fill(255, 50);
      //rect(0,0,20,20);
      //popMatrix();
      //ellipse(0,0,25,25);
      beginShape(QUAD_STRIP);
      endShape();
      popMatrix();
      rotateZ(TWO_PI/rows);
    }
    popMatrix();
    rotateY(TWO_PI/rows);
  }  
  popMatrix();
}
