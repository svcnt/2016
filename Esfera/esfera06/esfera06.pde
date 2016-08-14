/*

Crear una malla esférica que admita texturas y relieves

NOTA: Comparar tamaños de arrays y bucles

*/

//Variables
float rad = 200;
float rad2, rad3;
int rows = 100;
int cols = rows;
float sepH = (rad*2)/rows;
float sepV = TWO_PI/cols;
float[][] ondulation; // array de cotas de relieve para la red
float maxBump = 1.5;
float minBump = 0;
float wind = 0;
PImage img;
int files_i = 0;
String[] files = {
  "../texturas/tex01.jpg",
  "../texturas/tex02.jpg",
  "../texturas/tex03.jpg",
  "../texturas/tex04.jpg",
  "../texturas/tex05.jpg",
  "../texturas/tex06.jpg",
  "../texturas/tex07.jpg",
  "../texturas/tex08.jpg",
  "../texturas/tex09.jpg",
  "../texturas/tex10.jpg",
  "../texturas/tex11.jpg",
  "../texturas/tex12.jpg"
};
PVector[][] vecs, vecs2; // array de vectores de posición
float sc = 1;

//Setup
void setup(){
  size(700,700, P3D);
  //background(0);
  //colorMode(HSB);
  //stroke(0, 0);
  //strokeWeight(2);
  //noFill();
  //fill(0);
  ondulation = new float [cols*2+1][rows*2+1]; // array bidimensional de nodos
  vecs = new PVector[cols*2+1][rows*2+1];
  vecs2 = new PVector[cols*2+1][rows*2+1];

}

//Loop
void draw(){
  background(0);
  //lights();
  directionalLight(255, 255, 255, 0, 1, -0.5);
  ambientLight(50, 50, 50);
  translate(width*0.5, height*0.5);
  rotateY(frameCount*0.01);
  rotateZ(frameCount*0.001);
  
  img = loadImage(files[files_i]);
  
  //Textura
  //poblar de datos el array
  float yoff = 0;
  for(int y = 0; y < rows*2+1; y++){
    float xoff= wind;
    for(int x = 0; x <=cols+2; x++){
      ondulation[x][y] = map(noise(xoff,yoff),0,1,minBump,maxBump);
      xoff += 0.05;
    }
   yoff += 0.05; 
  }
  wind-=0.0025;
  
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
    texture(img);
    for(int x = 0; x<=cols-1; x++){
         int fillX = int(map(x, 0, cols, 0, img.width)); 
         int fillY = int(map(y, -rows, rows, 0, img.height)); 
         color c = img.get(fillX,fillY);
         stroke(c, 50);
         //noStroke();
        //DE PUNTOS
        //point(vecs[x][rows+y].x, vecs[x][rows+y].y, vecs[x][rows+y].z);
        
        //POLÍGONOS
        float U1_ = (vecs[x][rows+y].x+img.width/2)*sc;
        float V1_ = (vecs[x][rows+y].y+img.height/2)*sc;
        float U2_ = (vecs2[x][rows+y].x+img.width/2)*sc;
        float V2_ = (vecs2[x][rows+y].y+img.height/2)*sc;
        //float U3_ = (vecs[x+1][rows+y].x+img.width/2)*sc;
        //float V3_ = (vecs[x+1][rows+y].y+img.height/2)*sc;
        //float U4_ = (vecs2[x+1][rows+y].x+img.width/2)*sc;
        //float V4_ = (vecs2[x+1][rows+y].y+img.height/2)*sc;

        vertex( vecs[x][rows+y].x, vecs[x][rows+y].y, vecs[x][rows+y].z, U1_, V1_ );
        vertex( vecs2[x][rows+y].x, vecs2[x][rows+y].y, vecs2[x][rows+y].z, U2_, V2_ );
        //vertex( vecs[x+1][rows+y].x, vecs[x+1][rows+y].y, vecs[x+1][rows+y].z, U3_, V3_ );
        //vertex( vecs2[x+1][rows+y].x, vecs2[x+1][rows+y].y, vecs2[x+1][rows+y].z, U4_, V4_ );
    }
    endShape();
    rad2 = sqrt((rad*rad) - (sepH*y)*(sepH*y));
    rad3 = sqrt((rad*rad) - (sepH*(y+1))*(sepH*(y+1)));
  } 
}

void keyReleased(){
  if (key == 'r' || key == 'R'){
    if (files_i < files.length-1){
        files_i++;
    } else {
      files_i = 0;
    }
    println(files_i);
  }
}