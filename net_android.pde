import android.view.MotionEvent;
import java.util.*;

TouchProcessor touch;

int N;
int[][] stage;
int[][] rotation;
boolean[][] supplied;

void setup() {
  size(480, 480);
  touch = new TouchProcessor();
  
  generate(7);
  update_supplied();
  mode = 0;
}

int mode = 0; //0:clickable 1:rotating 2:cleared
int rotating;
float t = 0;

boolean[][] connected = {
  {true, false, false, false},
  {true, false, true, false},
  {true, true, false, false},
  {true, true, true, false}
};

// dirはup right down leftの順番
void draw_block(float x, float y, float w, float h, int type, float rot, boolean supp) {
  stroke(#513A9B);
  strokeWeight(1);
  if (x>w) {
    line(x-w/2, y-w/2, x-w/2, y+w/2);
  }
  if (y>h) {
    line(x-w/2, y-w/2, x+w/2, y-w/2);
  }
  
  if (supp) {
    stroke(#D9262A);
    fill(#FECBCC);
  } else {
    stroke(#513A9B);
    fill(#FFFFFF);
  }
  
  strokeWeight(4);
  for (int i=0; i<4; i++) {
    if (connected[type][i]) {
      line(x, y, x+(w/2)*sin((rot+i)/4.0*TWO_PI), y-cos((rot+i)/4.0*TWO_PI)*(h/2));
    }
  }
  if (type == 0) {
    ellipse(x, y, (w/2), (h/2));
  }
}

void draw() {
  touch.analyse();
  touch.sendEvents();
  
  background(#DCD4F6);
  
  for (int i=0; i<N; i++) {
    for (int j=0; j<N; j++) {
      draw_block((0.5+j)/N*width, (0.5+i)/N*height, (float)width/N, (float)height/N, stage[i][j],
        rotation[i][j] + ((rotating == i*N+j) ? t : 0), supplied[i][j]);
      if (i==N/2 && j==N/2) {
        rect((float)width/2-0.35*width/N, (float)height/2-0.35*height/N,
             0.7*width/N, 0.7*height/N);
      }
    }
  }
  
  if (mode == 1) {
    t += 0.1;
    if (t >= 1) {
      rotation[rotating/N][rotating%N]++;
      rotation[rotating/N][rotating%N] %= 4;
      mode = 0;
      t = 0;
      update_supplied();
    }
  }
  
  if (mode == 2) {
    noStroke();
    fill(0, 0, 0, 127);
    rect(0, height/2-80, width, 160);
    fill(#FFFFFF);
    
    textAlign(CENTER);
    textSize(120);
    text("CLEAR!", width/2, height/2+40); 
  }
}

void mouseClicked() {
  println("touched");
  if (mode == 0) {
    int x = (int)(mouseY/((float)height/N));
    int y = (int)(mouseX/((float)width/N));
    
    mode = 1;
    rotating = x*N+y;
    t = 0;
  }
  if (mode == 2) {
    setup();
  }
}


void onTap( TapEvent event ) {
  println("tapped");
  mouseX = (int)event.x;
  mouseY = (int)event.y;
  mouseClicked();
}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void onFlick( FlickEvent event ) {
}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void onDrag( DragEvent event ) { 
}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void onRotate( RotateEvent event ) {
}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void onPinch( PinchEvent event ) {
}

boolean surfaceTouchEvent(MotionEvent event) {
  
  // extract the action code & the pointer ID
  int action = event.getAction();
  int code   = action & MotionEvent.ACTION_MASK;
  int index  = action >> MotionEvent.ACTION_POINTER_ID_SHIFT;

  float x = event.getX(index);
  float y = event.getY(index);
  int id  = event.getPointerId(index);

  // pass the events to the TouchProcessor
  if ( code == MotionEvent.ACTION_DOWN || code == MotionEvent.ACTION_POINTER_DOWN) {
    touch.pointDown(x, y, id);
  }
  else if (code == MotionEvent.ACTION_UP || code == MotionEvent.ACTION_POINTER_UP) {
    touch.pointUp(event.getPointerId(index));
  }
  else if ( code == MotionEvent.ACTION_MOVE) {
    int numPointers = event.getPointerCount();
    for (int i=0; i < numPointers; i++) {
      id = event.getPointerId(i);
      x = event.getX(i);
      y = event.getY(i);
      touch.pointMoved(x, y, id);
    }
  } 

  return super.surfaceTouchEvent(event);
}
