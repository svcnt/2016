/*

Crear una malla cilíndrica que admita texturas y relieves

*/

//Variables
float sep = TWO_PI/24; // 30º
int cols = int(TWO_PI/sep)+1; // número de columnas
int rows = 30; // número de secciones longitudinales
int lon = 10; // longitud de cada sección
int rad = 150; // radio del cilindro
int maxBump = 60; // máximo relieve
int minBump = -maxBump; // mínimo relieve
float[][] ondulation; // array de cotas de relieve para la red
float wind = 0;
PImage img; // imagen para la textura

//Setup
void setup(){
  size(600,600, P3D);
  fill(255);
  noStroke();
  //stroke(0, 126);
  ondulation = new float [cols][rows]; // array bidimensional de nodos
}

//Loop
void draw(){
  background(20);
  lights();
  translate(width*0.5, height*0.25);
  rotateY(PI+wind);
  
  //Textura
  img = loadImage("../texturas/tex08.jpg");
  float sc = 75; // relación imagen original / cilindro (0.5 = ampliar imagen x 2)
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
  wind-=0.02;
  
  //Malla
  for (int y = 0; y < rows-1; y++){
    beginShape(QUAD_STRIP);
    texture(img);
    for (int x = 0; x < cols-1; x++){
      
      float U1 = (x*sep)*sc;
      float V1 = (y*sep)*sc;
      float U2 = (x*sep)*sc;
      float V2 = ((y+1)*sep)*sc;
      float U3 = ((x+1)*sep)*sc;
      float V3 = (y*sep)*sc;
      float U4 = ((x+1)*sep)*sc;
      float V4 = ((y+1)*sep)*sc;
      
      vertex(sin(x*sep)*(rad+ondulation[x][y]), y*lon, cos(x*sep)*(rad+ondulation[x][y]), U1, V1);
      vertex(sin(x*sep)*(rad+ondulation[x][y+1]), (y+1)*lon, cos(x*sep)*(rad+ondulation[x][y+1]), U2, V2);
      vertex(sin((x+1)*sep)*(rad+ondulation[x+1][y]), y*lon, cos((x+1)*sep)*(rad+ondulation[x+1][y]), U3, V3);
      vertex(sin((x+1)*sep)*(rad+ondulation[x+1][y+1]), (y+1)*lon, cos((x+1)*sep)*(rad+ondulation[x+1][y+1]), U4, V4);
    }
    endShape();
  }

}