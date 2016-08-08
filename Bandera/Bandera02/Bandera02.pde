/*

Crear una red de polígonos en 3D que simule el movimiento de una bandera
Basado en 3D Terrain Generator, de Daniel Shiffman

La imagen se repite en cada módulo

*/

int cols, rows; // columnas y filas de la red
int sep = 25; // separación entre nodos
int maxBump = sep*5; // relieve máximo de los nodos
int minBump = -maxBump;
float wind = 0; // desplazamiento del campo noise
PImage img; // imagen para la textura
float[][] ondulation; // array de cotas de relieve para la red

void setup(){
  size(1280,700,P3D); // P3D!
  noFill();
  noStroke();
  //stroke(255);
  
  int w = 1000; // ancho
  int h = 800; // alto
  cols = w / sep; // número de columnas
  rows = h / sep; // número de filas
  ondulation = new float [cols][rows]; // array bidimensional de nodos
}

void draw(){
  //luces, fondo
  directionalLight(35, 35, 35, 0, 1, -0.5);
  ambientLight(200, 200, 200);
  background(0);
  
  // ajustar visualización
  scale(1.25); 
  translate(-25,-100);
  rotateY(PI/6);
  
  // textura
  img = loadImage("../texturas/tex01.jpg");
  float sc = 1; // relación imagen / bandera (0.5 = ampliar imagen x 2)
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
  wind-=0.1;
  
  
  // crear la red
  for (int y = 0; y < rows-1; y ++){
    beginShape(QUAD_STRIP);
    textureMode(NORMAL);
    texture(img);
    for (int x = 0; x < cols-1; x++){
      //float texAnchorX = map(terrain[x][y], -maxBump, maxBump, x*sep/5, y*sep/5);
      //float texAnchorY = map(terrain[x][y], -maxBump, maxBump, (x)*sep/5, (y)*sep/5);
      //float texAnchorX = map(terrain[x][y], minBump, maxBump, x, y);
      //float texAnchorY = map(terrain[x][y], minBump, maxBump, y, x);
      float U1 = 0;
      float V1 = 0;
      float U2 = 0;
      float V2 = 1;
      float U3 = 1;
      float V3 = 0;
      float U4 = 1;
      float V4 = 1;
      vertex(x*sep, y*sep, ondulation[x][y], U1, V1);
      vertex(x*sep, (y+1)*sep, ondulation[x][y+1], U2, V2);
      vertex((x+1)*sep, (y)*sep, ondulation[x+1][y], U3, V3);
      vertex((x+1)*sep, (y+1)*sep, ondulation[x+1][y+1], U4, V4);
      
    }
    endShape();
  }
}