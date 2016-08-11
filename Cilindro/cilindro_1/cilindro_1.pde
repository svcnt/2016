/*

Crear una malla cilíndrica que admita texturas y relieves

*/

//Variables
float sep = TWO_PI/69; // 30º
int cols = int(TWO_PI/sep)+2; // número de columnas
int rows = 100; // número de secciones longitudinales
int lon = 3; // longitud de cada sección
int rad = 100; // radio del cilindro
int maxBump = 75; // máximo relieve. 0 para cilindro liso
int minBump = -maxBump; // mínimo relieve
float[][] ondulation; // array de cotas de relieve para la red
float wind = 0;

//Setup
void setup(){
  size(600,600, P3D);
  fill(255, 25);
  stroke(255, 63);
  //noFill();
  ondulation = new float [cols][rows]; // array bidimensional de nodos
}

//Loop
void draw(){
  background(20);
  lights();
  translate(width*0.5, height*0.25);
  rotateY(PI);
  
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
  
  //Malla
  for (int y = 0; y < rows-1; y++){
    beginShape(QUAD_STRIP);
    for (int x = 0; x < cols-1; x++){
      //point(sin(x*sep)*rad, y*lon, cos(x*sep)*rad);
      vertex(sin(x*sep)*(rad+ondulation[x][y]), y*lon, cos(x*sep)*(rad+ondulation[x][y]));
      vertex(sin(x*sep)*(rad+ondulation[x][y+1]), (y+1)*lon, cos(x*sep)*(rad+ondulation[x][y+1]));
    }
    endShape();
  }

}
